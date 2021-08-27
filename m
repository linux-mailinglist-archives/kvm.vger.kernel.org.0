Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3F53F9B31
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 16:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245170AbhH0O62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 10:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhH0O62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 10:58:28 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE432C061757;
        Fri, 27 Aug 2021 07:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NSdJTnTrDORwb+LwDd1YsYwMgPCJRxx0pXYK8FlAauE=; b=Fa7lAXZuZMGlhMkvCLlAaInQ0M
        LvZMAI9dgp92KcFz4u2w541+/Nu67i2Ea3rAZpKD6Q1P9ILjKx8E7vJPC9Yy4BHzufUafcmzb+2zu
        XEqetUQrDWVmWgUJbeWVLi3VrFACkcynBo/GAIrkEDlonwYXZkgrnKNPnvuRXhzSenXsmorxKXv3b
        UaLmP8193HgPXArb5Wp1c/mrxTLlf/21JEFOup9O58miZONiwbcuapmO9GWG87OVfsWhj7CHiSkGX
        N5n6bqMpN0VhS93yWvq33V/48j5w+oHy6eCsh396wVtLrGJfjfA+JtKu/NF0o3UbeTizVS7b6v5Pe
        Ifw0PqQQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJdHk-00DX6q-CH; Fri, 27 Aug 2021 14:56:48 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 06096300DEF;
        Fri, 27 Aug 2021 16:56:46 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DA39829CFAC0B; Fri, 27 Aug 2021 16:56:45 +0200 (CEST)
Date:   Fri, 27 Aug 2021 16:56:45 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
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
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: Re: [PATCH 05/15] perf: Track guest callbacks on a per-CPU basis
Message-ID: <YSj9LQfbKxOhxqcP@hirez.programming.kicks-ass.net>
References: <20210827005718.585190-1-seanjc@google.com>
 <20210827005718.585190-6-seanjc@google.com>
 <YSiRBQQE7md7ZrNC@hirez.programming.kicks-ass.net>
 <YSj7jq32U8Euf38o@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSj7jq32U8Euf38o@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 02:49:50PM +0000, Sean Christopherson wrote:
> On Fri, Aug 27, 2021, Peter Zijlstra wrote:
> > On Thu, Aug 26, 2021 at 05:57:08PM -0700, Sean Christopherson wrote:
> > > Use a per-CPU pointer to track perf's guest callbacks so that KVM can set
> > > the callbacks more precisely and avoid a lurking NULL pointer dereference.
> > 
> > I'm completely failing to see how per-cpu helps anything here...
> 
> It doesn't help until KVM is converted to set the per-cpu pointer in flows that
> are protected against preemption, and more specifically when KVM only writes to
> the pointer from the owning CPU.  

So the 'problem' I have with this is that sane (!KVM using) people, will
still have to suffer that load, whereas with the static_call() we patch
in an 'xor %rax,%rax' and only have immediate code flow.

> Ignoring static call for the moment, I don't see how the unreg side can be safe
> using a bare single global pointer.  There is no way for KVM to prevent an NMI
> from running in parallel on a different CPU.  If there's a more elegant solution,
> especially something that can be backported, e.g. an rcu-protected pointer, I'm
> all for it.  I went down the per-cpu path because it allowed for cleanups in KVM,
> but similar cleanups can be done without per-cpu perf callbacks.

If all the perf_guest_cbs dereferences are with preemption disabled
(IRQs disabled, IRQ context, NMI context included), then the sequence:

	WRITE_ONCE(perf_guest_cbs, NULL);
	synchronize_rcu();

Ensures that all prior observers of perf_guest_csb will have completed
and future observes must observe the NULL value.

