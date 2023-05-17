Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1623670665E
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 13:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjEQLPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 07:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbjEQLPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 07:15:03 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543BB271B;
        Wed, 17 May 2023 04:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oA7UPGpTSZL9i4ew+XAireX7x3872RNVvWWFAISPjRE=; b=bIzarW9nY78beCdFYkOzB2QpCI
        LwSpvqZ14pH65RAvNk4PL/ZhRxHLB2P/DnJVNRs0KHX+L6xIymUdyRrL9OqOIvei1ChQ8PwFKtqiA
        hUKgqtynFlY1CY0oEj/N9baV/gKFVT+wD5RCkjcFPBjKMe3geCwvi/Q9TDN1a0mTUTL6fjzTSyLT8
        skL8CmSo8gXsa4K9fko4iAguxtuT5obqtkoRqf5paYJtzr4Y9Vwi2hoPXE0AsM98aR9r8Xanq9Nee
        bdWgp1kjCJ5BPBZGqArNBReMrA0wLO7eUgzgTa1XIiOqkaXd2vuov0EQ9TfV7vShVQNgmIU7+vRW4
        U7x+E2Xg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pzF6Y-00DCdL-0C;
        Wed, 17 May 2023 11:14:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 484E23003CF;
        Wed, 17 May 2023 13:13:58 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1DEDB241D47E6; Wed, 17 May 2023 13:13:58 +0200 (CEST)
Date:   Wed, 17 May 2023 13:13:58 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
        "kernel@xen0n.name" <kernel@xen0n.name>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "longman@redhat.com" <longman@redhat.com>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "john.ogness@linutronix.de" <john.ogness@linutronix.de>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "bristot@redhat.com" <bristot@redhat.com>,
        "vschneid@redhat.com" <vschneid@redhat.com>,
        "jstultz@google.com" <jstultz@google.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH 7/9] x86/tsc: Provide sched_clock_noinstr()
Message-ID: <20230517111358.GC2665450@hirez.programming.kicks-ass.net>
References: <20230508211951.901961964@infradead.org>
 <20230508213147.853677542@infradead.org>
 <20230508214419.GA2053935@hirez.programming.kicks-ass.net>
 <BYAPR21MB1688853D01CABA74B51DA841D77E9@BYAPR21MB1688.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR21MB1688853D01CABA74B51DA841D77E9@BYAPR21MB1688.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 17, 2023 at 02:26:35AM +0000, Michael Kelley (LINUX) wrote:

> Peter -- I've sent you an RFC patch to incorporate into your broader
> patch set.  I think it probably makes sense for all the Hyper-V
> stuff to be a separate patch.

Perhaps, it's not that much.

> I haven't previously worked with the details of notrace vs. noinstr,
> but I followed the patterns elsewhere in patch set. Please review
> to see if it seems correct.

notrace inhibits the "call __fentry__" at the start of the symbol.

The __fentry__ call is mostly for ftrace, there's a few sites where
inhibiting tracing is critical -- stuff that happens before the ftrace
recursion handling, but mostly it's about performance these days,
constantly hitting the recusion code isn't very good.

noinstr inhibits any and all compiler generated 'extra' -- it is for the
C as a portable assembler usage. This very much includes notrace, but it
also covers all the *SAN nonsense. Basically, if it does not directly
reflect the code as written, it shouldn't be emitted.

Additionally, and for validation purposes, it also ensures all these
symbols end up in a special text section.

But yeah, you seem to have gotten it right.

> One thing:  In the cases where I added __always_inline, I dropped
> any notrace or noinstr annotations.  I presume such code always
> takes on the attributes of the caller.  If that's not correct, let me know.

Correct; noinstr actually has an explicit noinline because compilers
suck :/
