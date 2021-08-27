Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6393F9567
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 09:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244487AbhH0HuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 03:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244460AbhH0Ht7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 03:49:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE94C061757;
        Fri, 27 Aug 2021 00:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mwqNvZJA9dIpDEWigadLmAt4ekXHrBRvbcdnGdey0lE=; b=I/IvqbDlSMWcIbpdOOAXfLAePd
        VnuHf80Ij7eT65HZ/ZmLgO4WMPy4itQhDo5T0oqUnYiX+gy+Rpm1rDaH4yfbNkb40sVQ1Gs3+K6Uq
        CAc6W/5Ofu26xIMuG6qfRfTVilpdhWEX2zSVyoNEfY39xPi+5hJeAJd/b2amtCtk8saRHvdqd3spd
        k3S7rVNP4X1Ahst2d+VG5ZMlKiq+sDTGG7S40hJJ0KnXYxsSWY1gkda21RFgy0QIi2/QZhbbB2Vlz
        96YSYnpgLCOvEhsZUVTk4sOSCYRU5PzhafRroNnuKOSTjrZC6AYQI4zn9xh9YCEYcHiHS9VshLf0l
        /zvt21FA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJWXo-00EGbQ-KU; Fri, 27 Aug 2021 07:45:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7022A30035D;
        Fri, 27 Aug 2021 09:44:52 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 549952C6670ED; Fri, 27 Aug 2021 09:44:52 +0200 (CEST)
Date:   Fri, 27 Aug 2021 09:44:52 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jason Baron <jbaron@akamai.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 00/15] perf: KVM: Fix, optimize, and clean up callbacks
Message-ID: <YSiX9OPcrDsr3P4C@hirez.programming.kicks-ass.net>
References: <20210827005718.585190-1-seanjc@google.com>
 <fd3dcd6c-b3d5-4453-93fb-b46d0595534e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd3dcd6c-b3d5-4453-93fb-b46d0595534e@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 02:52:25PM +0800, Like Xu wrote:
> + STATIC BRANCH/CALL friends.
> 
> On 27/8/2021 8:57 am, Sean Christopherson wrote:
> > This started out as a small series[1] to fix a KVM bug related to Intel PT
> > interrupt handling and snowballed horribly.
> > 
> > The main problem being addressed is that the perf_guest_cbs are shared by
> > all CPUs, can be nullified by KVM during module unload, and are not
> > protected against concurrent access from NMI context.
> 
> Shouldn't this be a generic issue of the static_call() usage ?
> 
> At the beginning, we set up the static entry assuming perf_guest_cbs != NULL:
> 
> 	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr) {
> 		static_call_update(x86_guest_handle_intel_pt_intr,
> 				   perf_guest_cbs->handle_intel_pt_intr);
> 	}
> 
> and then we unset the perf_guest_cbs and do the static function call like this:
> 
> DECLARE_STATIC_CALL(x86_guest_handle_intel_pt_intr,
> *(perf_guest_cbs->handle_intel_pt_intr));
> static int handle_pmi_common(struct pt_regs *regs, u64 status)
> {
> 		...
> 		if (!static_call(x86_guest_handle_intel_pt_intr)())
> 			intel_pt_interrupt();
> 		...
> }

You just have to make sure all static_call() invocations that started
before unreg are finished before continuing with the unload.
synchronize_rcu() can help with that.

This is module unload 101. Nothing specific to static_call().
