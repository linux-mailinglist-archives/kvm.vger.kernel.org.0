Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D84700016
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 08:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239923AbjELGBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 02:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbjELGBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 02:01:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103B0449A;
        Thu, 11 May 2023 23:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JgTBFDjjwSw1zqVfagUl7AKzd0vmwdZDo99pKCmQQP0=; b=eDdL5ePvbY/jB1rcT9W4xmiaH/
        5m/v/TWCs08Qq8j4qKMc2vGMvLL5roJ3tIsKMaZQp2BX9VRHZfQWdfUwabjxBqW4Gn7SkBvwKP3ek
        hUsEpADpLyHP4WYDo9ohbtNjzgyWj2N6lntMZ81jWY93R8LmicuYVMlBrzPNMnOQfvTzz18Vgc0t4
        YqLaDv86aJFPGJaZXoaeUGbN4o5aQ25kK75TN2AVlkFlZ4fxuPUlMdnZeXqkbUvLVQ8HYrYY+YipA
        jXwS+C4JUjbL4UND999W65sHHNBuZFwvPuCnGaugL8m/VLeHbPDw1MALFGqukWBIaNcHwHWrKFGbg
        NW2Um0lA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pxLpq-000QcQ-7n; Fri, 12 May 2023 06:00:58 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 87025300338;
        Fri, 12 May 2023 08:00:54 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6D0322C7DB768; Fri, 12 May 2023 08:00:54 +0200 (CEST)
Date:   Fri, 12 May 2023 08:00:54 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     Wei Liu <wei.liu@kernel.org>,
        "ltykernel@gmail.com" <ltykernel@gmail.com>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
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
Message-ID: <20230512060054.GA2313201@hirez.programming.kicks-ass.net>
References: <20230508211951.901961964@infradead.org>
 <20230508213147.853677542@infradead.org>
 <20230508214419.GA2053935@hirez.programming.kicks-ass.net>
 <ZFmGI1EN24xroPHa@liuwe-devbox-debian-v2>
 <20230511202351.GE2296992@hirez.programming.kicks-ass.net>
 <BYAPR21MB16883A65BBCFA19A30BADA4CD7749@BYAPR21MB1688.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR21MB16883A65BBCFA19A30BADA4CD7749@BYAPR21MB1688.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 11:11:07PM +0000, Michael Kelley (LINUX) wrote:
> From: Peter Zijlstra <peterz@infradead.org> Sent: Thursday, May 11, 2023 1:24 PM

> > > Tianyu and Michael, what's your thought on this?
> > >
> > > Is the MSR-based GHCB usable at this point?
> > >
> > > What other clock source can be used?
> > 
> > You do have TSC support -- which is what I fixed for you. It's just the
> > whole MSR thing that is comically broken.
> > 
> > You could do a read_hv_clock_msr() implementation using
> > __rdmsr() and add some sanity checking that anything GHCB using (SEV?)
> > *will* use TSC.
> > 
> > Anyway, will you guys do that, or should I pull out the chainsaw and fix
> > it for you?
> 
> Peter -- I'll work on a fix.  But it will be the first half of next week before
> I can do it.

OK, Thanks!
