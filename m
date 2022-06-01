Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9341E53A274
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 12:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351841AbiFAKTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 06:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243633AbiFAKTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 06:19:49 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFAD6B677;
        Wed,  1 Jun 2022 03:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kmPFKn3CfNA6S8ITvZmyqXq/Q8dnPnZS1T5Vpg4XptA=; b=E08QSsEDzDXwZxdVkGb/CWF7xQ
        efHbWb78SvKvZHoGfgBASeiDq2eiD4WCHpcjIM4FMywEwVHPoUX9UK02Kpb3m6GKjRV5TwHFOq7Qa
        NLi6ISL8StPtArU+wtQGRT/6+M1akpUNg+r0CF29a5nZpULH3kYcWWu4YUZs528GePslagJkbEW6Q
        4kHnRWaB77R7h3xQQQEYLb/3Xd+ZKpzJcqiAdAiJ24BI/CNpdwDHFDjS7gGZRPYvTs7A4o3SxnRvi
        IJWqCLfCW8watu1HENAsz6uXFRanaVgoH4xv+htG+QSV9FxCoNKHHg+066jGLnWV97DUWXFIIoqFN
        /jueuXgA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nwLRV-003k8D-Hj; Wed, 01 Jun 2022 10:19:09 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3319198137D; Wed,  1 Jun 2022 12:19:07 +0200 (CEST)
Date:   Wed, 1 Jun 2022 12:19:07 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>,
        "Allister, Jack" <jalliste@amazon.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "diapop@amazon.co.uk" <diapop@amazon.co.uk>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "metikaya@amazon.co.uk" <metikaya@amazon.co.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: ...\n
Message-ID: <Ypc9G3nTkib1y9X4@worktop.programming.kicks-ass.net>
References: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
 <20220531140236.1435-1-jalliste@amazon.com>
 <YpYpxzt4rmG+LFy9@hirez.programming.kicks-ass.net>
 <059ab3327ac440479ecfdf49fa054347@EX13D32EUC003.ant.amazon.com>
 <307f19cc-322e-c900-2894-22bdee1e248a@redhat.com>
 <87tu94olyd.fsf@redhat.com>
 <b9238c07-68a7-31fa-c654-d8111a1e2d4b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9238c07-68a7-31fa-c654-d8111a1e2d4b@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 01, 2022 at 10:59:17AM +0200, Paolo Bonzini wrote:
> On 6/1/22 09:57, Vitaly Kuznetsov wrote:
> > > > I'll bite... What's ludicrous about wanting to run a guest at a lower CPU freq to minimize observable change in whatever workload it is running?
> > > Well, the right API is cpufreq, there's no need to make it a KVM
> > > functionality.
> > KVM may probably use the cpufreq API to run each vCPU at the desired
> > frequency: I don't quite see how this can be done with a VMM today when
> > it's not a 1-vCPU-per-1-pCPU setup.
> 
> True, but then there's also a policy issue, in that KVM shouldn't be allowed
> to *bump* the frequency if userspace would ordinarily not have access to the
> cpufreq files in sysfs.

So, when using schedutil (which requires intel_pstate in passive mode),
then there's the option to use per-task uclamps which are somewhat
complicated but also affect cpufreq.


