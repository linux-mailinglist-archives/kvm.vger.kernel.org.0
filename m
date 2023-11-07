Return-Path: <kvm+bounces-1040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB707E47D0
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0216DB20E77
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B37EB3589E;
	Tue,  7 Nov 2023 18:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fitOuWiU"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AB617F0
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 18:06:05 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E9C120
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 10:06:05 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc3130ba31so42629435ad.0
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 10:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699380364; x=1699985164; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aU34lsBWG3jyTwTzaaJkynQ9ddxhzB5NuqZaVtQepC4=;
        b=fitOuWiUGMs0NOMCalAV3mJmSIokpD3dzOdcShSNZUSg1XSqdNhpTEiYTAutIhhliy
         1gq+lJ53/eF6WyJ7/EVTeSf7hTWbxw+nTzGEQUfq8Hft933IZypTPGutgbuZH7OIB/Xr
         Noc/vUBxWUnoIpSYYoJeFcpumCFutYtaclM4lbpy7AbOAcIWeMWqFVnvtvYixrevNCt7
         04sU2KBaKluspPaDYykSj95SrERza/VZ1IpxUx6glGbfllO9kvSAU8PFgD1I0fknfnSk
         SHfdJLDUBlNpR0nQSv4CDpr0vMPtTwSxMgRkqUNzJNSe3sGHsIqDTNtZwrGpmazItdFi
         nl5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699380364; x=1699985164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aU34lsBWG3jyTwTzaaJkynQ9ddxhzB5NuqZaVtQepC4=;
        b=kg8gz+tq4+k6JcvsLkMxXlNSYHM+xbdSefa+hb6nzuWLx5P6EiMXB1xxRkyK8nhROx
         aAdUtT1qEsOydQRwkkxG2bkRe4kKFxqrl6OCxaEoe6+FqPuU3fpu8Oq6imPS+sWM2urb
         LCt/X1ivggsAT9qJWqcC6RoZ9Npgg/sd9AbVgMCzVqk2LEZU2bIJKUC4lhwagVFc0VfS
         ZvjWC4cMfHZ0BU2vnbTCszk3xgmtQ3o6ifY+u6Pmv+iLKRsBwl8+gwfY35Wle2z62nlD
         lqyoxX/CoWZ5CEugslNhttgQVEYsWvtrT1jQcvYlSQPJZnWsJWtYX8uDB/sm63wphpaI
         IHgg==
X-Gm-Message-State: AOJu0YzauaxNO53KDE9/LYrYG2Uip1hM4GyHcw5tIagudNYJYn6h67MJ
	XztYjrimm9xZc5NSonpGnyc4JqcGCnw=
X-Google-Smtp-Source: AGHT+IFsYh7pqnMF6bnCC/oyEJRS68sDpOtjIDr0qSs0BPKh8B681uNHVt3b3tnovpKX6rtHcRNrk/tc5ZM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ef83:b0:1cc:454f:73dc with SMTP id
 iz3-20020a170902ef8300b001cc454f73dcmr457603plb.7.1699380364543; Tue, 07 Nov
 2023 10:06:04 -0800 (PST)
Date: Tue, 7 Nov 2023 10:06:02 -0800
In-Reply-To: <ZUoCxyNsc/dB4/eN@yzhao56-desk.sh.intel.com>
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
 <ZUlp4AgjvoG7zk_Y@google.com> <ZUoCxyNsc/dB4/eN@yzhao56-desk.sh.intel.com>
Message-ID: <ZUp8iqBDm_Ylqiau@google.com>
Subject: Re: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Yibo Huang <ybhuang@cs.utexas.edu>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 07, 2023, Yan Zhao wrote:
> On Mon, Nov 06, 2023 at 02:34:08PM -0800, Sean Christopherson wrote:
> > On Wed, Nov 01, 2023, Yan Zhao wrote:
> > > On Tue, Oct 31, 2023 at 08:14:41AM -0700, Sean Christopherson wrote:
> 
> > > If no #MC, could EPT type of guest RAM also be set to WB (without IPAT) even
> > > without non-coherent DMA?
> > 
> > No, there are snooping/ordering issues on Intel, and to a lesser extent AMD.  AMD's
> > WC+ solves the most straightfoward cases, e.g. WC+ snoops caches, and VMRUN and
> > #VMEXIT flush the WC buffers to ensure that guest writes are visible and #VMEXIT
> > (and vice versa).  That may or may not be sufficient for multi-threaded use cases,
> > but I've no idea if there is actually anything to worry about on that front.  I
> > think there's also a flaw with guest using UC, which IIUC doesn't snoop caches,
> > i.e. the guest could get stale data.
> > 
> > AFAIK, Intel CPUs don't provide anything like WC+, so KVM would have to provide
> > something similar to safely let the guest control memtypes.  Arguably, KVM should
> > have such mechansisms anyways, e.g. to make non-coherent DMA VMs more robust.
> > 
> > But even then, there's still the question of why, i.e. what would be the benefit
> > of letting the guest control memtypes when it's not required for functional
> > correctness, and would that benefit outweight the cost.
> 
> Ok, so for a coherent device , if it's assigned together with a non-coherent
> device, and if there's a page with host PAT = WB and guest PAT=UC, we need to
> ensure the host write is flushed before guest read/write and guest DMA though no
> need to worry about #MC, right?

It's not even about devices, it applies to all non-MMIO memory, i.e. unless the
host forces UC for a given page, there's potential for WB vs. WC/UC issues.

> > > > > For CR0_CD=1,
> > > > > - w/o KVM_X86_QUIRK_CD_NW_CLEARED, it meets (b), but breaks (a).
> > > > > - w/  KVM_X86_QUIRK_CD_NW_CLEARED, with IPAT=1, it meets (a), but breaks (b);
> > > > >                                    with IPAT=0, it may breaks (a), but meets (b)
> > > > 
> > > > CR0.CD=1 is a mess above and beyond memtypes.  Huh.  It's even worse than I thought,
> > > > because according to the SDM, Atom CPUs don't support no-fill mode:
> > > > 
> > > >   3. Not supported In Intel Atom processors. If CD = 1 in an Intel Atom processor,
> > > >      caching is disabled.
> > > > 
> > > > Before I read that blurb about Atom CPUs, what I was going to say is that, AFAIK,
> > > > it's *impossible* to accurately virtualize CR0.CD=1 on VMX because there's no way
> > > > to emulate no-fill mode.
> > > > 
> > > > > > Discussion from the EPT+MTRR enabling thread[*] more or less confirms that Sheng
> > > > > > Yang was trying to resolve issues with passthrough MMIO.
> > > > > > 
> > > > > >  * Sheng Yang 
> > > > > >   : Do you mean host(qemu) would access this memory and if we set it to guest 
> > > > > >   : MTRR, host access would be broken? We would cover this in our shadow MTRR 
> > > > > >   : patch, for we encountered this in video ram when doing some experiment with 
> > > > > >   : VGA assignment. 
> > > > > > 
> > > > > > And in the same thread, there's also what appears to be confirmation of Intel
> > > > > > running into issues with Windows XP related to a guest device driver mapping
> > > > > > DMA with WC in the PAT.  Hilariously, Avi effectively said "KVM can't modify the
> > > > > > SPTE memtype to match the guest for EPT/NPT", which while true, completely overlooks
> > > > > > the fact that EPT and NPT both honor guest PAT by default.  /facepalm
> > > > > 
> > > > > My interpretation is that the since guest PATs are in guest page tables,
> > > > > while with EPT/NPT, guest page tables are not shadowed, it's not easy to
> > > > > check guest PATs  to disallow host QEMU access to non-WB guest RAM.
> > > > 
> > > > Ah, yeah, your interpretation makes sense.
> > > > 
> > > > The best idea I can think of to support things like this is to have KVM grab the
> > > > effective PAT memtype from the host userspace page tables, shove that into the
> > > > EPT/NPT memtype, and then ignore guest PAT.  I don't if that would actually work
> > > > though.
> > > Hmm, it might not work. E.g. in GPU, some MMIOs are mapped as UC-, while some
> > > others as WC, even they belong to the same BAR.
> > > I don't think host can know which one to choose in advance.
> > > I think it should be also true to RAM range, guest can do memremap to a memory
> > > type that host doesn't know beforehand.
> > 
> > The goal wouldn't be to honor guest memtype, it would be to ensure correctness.
> > E.g. guest can do memremap all it wants, and KVM will always ignore the guest's
> > memtype.
> AFAIK, some GPUs with TTM driver may call set_pages_array_uc() to convert pages
> to PAT=UC-(e.g. for doorbell). Intel i915 also could vmap a page with PAT=WC
> (e.g. for some command buffer, see i915_gem_object_map_page()).
> It's not easy for host to know which guest pages are allocated by guest driver
> for such UC/WC conversion, and it should have problem to map such pages as "WB +
> ignore guest PAT" if the device is non-coherent.

Ah, right, I was thinking specifically of virtio-gpu, where there is more explicit
coordination between guest and host regarding the buffers.  Drat.

