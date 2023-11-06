Return-Path: <kvm+bounces-824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E22E17E2FE2
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 23:34:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1059E1C209D0
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 22:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A84D42FE13;
	Mon,  6 Nov 2023 22:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3dmbzPBc"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81062FE05
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 22:34:12 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2630AD51
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 14:34:11 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5b0c27d504fso35287707b3.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 14:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699310050; x=1699914850; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EUyeZVrGKUIxD2oX7nrB+I3sRTsmHGPuYrgW41CJ7bM=;
        b=3dmbzPBcg4apJiyd2Tmo0YEOMeeSzudfs0aLXyBjcUeG2pcRfQob85XMtti7QIQ+JL
         k0DEf/hbpzoRT7JYLfYZLYvRZRlfKvIr62mOLJ66xSbXRES2o2DWF3QozI/IfKSZrO2f
         U1SZ7PZfh10hSD9pd3lf9u9zH+eli700LSDMHK6PCPSbTmu4TzlqnMSeCAxaF44UpO4W
         A9/RSZGyloQ5MZZf3D5NBOD65AeBcIoNtne5pbplLHd0XQH/G7k34hmzhgrVfQb6qagB
         2f/XPx3IhlxM3XLLLepfbEtlYjYOsUc7YSdTq+rJwdP/I1pNL9NasoxLBOVCoydXOBTD
         Ohtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699310050; x=1699914850;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EUyeZVrGKUIxD2oX7nrB+I3sRTsmHGPuYrgW41CJ7bM=;
        b=HUzw85qkF3OaNTkx/X/hXP4RKcg5rxLdKxS7+z5zwOpj9ndOQwgLcgGkCS1aBRrvWM
         SLVnXuKuataEOXP9ffoZKoIv6Iy293m9/1EboZ3O2fDXH+nS7YOANSF32+LxIVk1dKy6
         i9sH3pSkVbOtLjAFWfQJBdkx6un9OfxEj2f3bygX5pKnmIqEmAo/LVTlXnYCY5utoWf1
         Bpew29ieCBvvt7teX7C/zMyDiEsAMMG7TXVuj6vO/ut5Sd8+r+xSOzBmgVlPVXjptTt+
         6nvvUwPlsqE5n/xCL0QPAxc/VAIWEmTs6HB/RZ/T+UBWcJWwthytOzX6FjJCMDZ9JK0d
         7mEw==
X-Gm-Message-State: AOJu0YzZv+8E9A/m7vngQkIpu4A6eGmljt1fvkuP+fF87xm/RoRmoLvS
	FL5nGRnnnAL7QMTh6nrhPdpljF1O0fA=
X-Google-Smtp-Source: AGHT+IEjUNWlNgHmfYhPjHCzzNKzxbToKC9/B3SzaHgYUiPI1NW/NknDJAeG9rA6dFxpeshoXTWGLheybj8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:760e:0:b0:5ae:75db:92c5 with SMTP id
 r14-20020a81760e000000b005ae75db92c5mr25698ywc.2.1699310050370; Mon, 06 Nov
 2023 14:34:10 -0800 (PST)
Date: Mon, 6 Nov 2023 14:34:08 -0800
In-Reply-To: <ZUIVfpAz0+7jVZvC@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <2C868574-37F4-437D-8355-46A6D1615E51@cs.utexas.edu>
 <ZTxEIGmq69mUraOD@google.com> <ZT+eipbV5+mSjr+G@yzhao56-desk.sh.intel.com>
 <ZUAC0jvFE0auohL4@google.com> <ZUDQXbDDsGI3KiQ8@yzhao56-desk.sh.intel.com>
 <ZUEZ4QRjUcu7y3gN@google.com> <ZUIVfpAz0+7jVZvC@yzhao56-desk.sh.intel.com>
Message-ID: <ZUlp4AgjvoG7zk_Y@google.com>
Subject: Re: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Yibo Huang <ybhuang@cs.utexas.edu>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 01, 2023, Yan Zhao wrote:
> On Tue, Oct 31, 2023 at 08:14:41AM -0700, Sean Christopherson wrote:
> > FWIW, I don't think that page aliasing with WC/UC actually causes machine checks.
> > What does result in #MC (assuming things haven't changed in the last few years)
> > is accessing MMIO using WB and other cacheable memtypes, e.g. map the host APIC
> > with WB and you should see #MCs.  I suspect this is what people encountered years
> > ago when KVM attempted to honored guest MTRRs at all times.  E.g. the "full" MTRR
> > virtualization patch that got reverted deliberately allowed the guest to control
> > the memtype for host MMIO.
> > 
> > The SDM makes aliasing sound super scary, but then has footnotes where it explicitly
> > requires the CPU to play nice with aliasing, e.g. if MTRRs are *not* UC but the
> > effective memtype is UC, then the CPU is *required* to snoop caches:
> >
> Yes, I tried below combinations, none of them can trigger #MC.
> - effective memory type for guest access is WC, and that for host access is UC
> - effective memory type for guest access is UC, and that for host access is WC
> - effective memory type for guest access is UC, and that for host access is WB
> 
> >   2. The UC attribute came from the page-table or page-directory entry and
> >      processors are required to check their caches because the data may be cached
> >      due to page aliasing, which is not recommended.
> > 
> > Lack of snooping can effectively cause data corruption and ordering issues, but
> > at least for WC/UC vs. WB I don't think there are actual #MC problems with aliasing.
> > 
> Even no #MC on guest RAM?
> E.g. what if guest effective memory type is UC/WC, and host effective memory type
> is WB?
> (I tried in my machines with guest PAT=WC + host PAT=WB, looks no #MC, but I'm not sure
> if anything I'm missing and it's only in my specific environment.)
> 
> If no #MC, could EPT type of guest RAM also be set to WB (without IPAT) even
> without non-coherent DMA?

No, there are snooping/ordering issues on Intel, and to a lesser extent AMD.  AMD's
WC+ solves the most straightfoward cases, e.g. WC+ snoops caches, and VMRUN and
#VMEXIT flush the WC buffers to ensure that guest writes are visible and #VMEXIT
(and vice versa).  That may or may not be sufficient for multi-threaded use cases,
but I've no idea if there is actually anything to worry about on that front.  I
think there's also a flaw with guest using UC, which IIUC doesn't snoop caches,
i.e. the guest could get stale data.

AFAIK, Intel CPUs don't provide anything like WC+, so KVM would have to provide
something similar to safely let the guest control memtypes.  Arguably, KVM should
have such mechansisms anyways, e.g. to make non-coherent DMA VMs more robust.

But even then, there's still the question of why, i.e. what would be the benefit
of letting the guest control memtypes when it's not required for functional
correctness, and would that benefit outweight the cost.

> > > For CR0_CD=1,
> > > - w/o KVM_X86_QUIRK_CD_NW_CLEARED, it meets (b), but breaks (a).
> > > - w/  KVM_X86_QUIRK_CD_NW_CLEARED, with IPAT=1, it meets (a), but breaks (b);
> > >                                    with IPAT=0, it may breaks (a), but meets (b)
> > 
> > CR0.CD=1 is a mess above and beyond memtypes.  Huh.  It's even worse than I thought,
> > because according to the SDM, Atom CPUs don't support no-fill mode:
> > 
> >   3. Not supported In Intel Atom processors. If CD = 1 in an Intel Atom processor,
> >      caching is disabled.
> > 
> > Before I read that blurb about Atom CPUs, what I was going to say is that, AFAIK,
> > it's *impossible* to accurately virtualize CR0.CD=1 on VMX because there's no way
> > to emulate no-fill mode.
> > 
> > > > Discussion from the EPT+MTRR enabling thread[*] more or less confirms that Sheng
> > > > Yang was trying to resolve issues with passthrough MMIO.
> > > > 
> > > >  * Sheng Yang 
> > > >   : Do you mean host(qemu) would access this memory and if we set it to guest 
> > > >   : MTRR, host access would be broken? We would cover this in our shadow MTRR 
> > > >   : patch, for we encountered this in video ram when doing some experiment with 
> > > >   : VGA assignment. 
> > > > 
> > > > And in the same thread, there's also what appears to be confirmation of Intel
> > > > running into issues with Windows XP related to a guest device driver mapping
> > > > DMA with WC in the PAT.  Hilariously, Avi effectively said "KVM can't modify the
> > > > SPTE memtype to match the guest for EPT/NPT", which while true, completely overlooks
> > > > the fact that EPT and NPT both honor guest PAT by default.  /facepalm
> > > 
> > > My interpretation is that the since guest PATs are in guest page tables,
> > > while with EPT/NPT, guest page tables are not shadowed, it's not easy to
> > > check guest PATs  to disallow host QEMU access to non-WB guest RAM.
> > 
> > Ah, yeah, your interpretation makes sense.
> > 
> > The best idea I can think of to support things like this is to have KVM grab the
> > effective PAT memtype from the host userspace page tables, shove that into the
> > EPT/NPT memtype, and then ignore guest PAT.  I don't if that would actually work
> > though.
> Hmm, it might not work. E.g. in GPU, some MMIOs are mapped as UC-, while some
> others as WC, even they belong to the same BAR.
> I don't think host can know which one to choose in advance.
> I think it should be also true to RAM range, guest can do memremap to a memory
> type that host doesn't know beforehand.

The goal wouldn't be to honor guest memtype, it would be to ensure correctness.
E.g. guest can do memremap all it wants, and KVM will always ignore the guest's
memtype.

