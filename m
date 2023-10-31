Return-Path: <kvm+bounces-208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A41F7DD037
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 16:15:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82935B20BDA
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 15:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8BD81E506;
	Tue, 31 Oct 2023 15:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M9BWjWpx"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65DA1DDF6
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 15:15:08 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A8E133
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 08:14:44 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7b9e83b70so46536217b3.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 08:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698765282; x=1699370082; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vr1AErEXYYfmkBWS1LpTvT+F3LQxWwS/eQ/Zsz08Hd4=;
        b=M9BWjWpxClyc/8GzdXwMHPm2trrMVt/mDn03SACAKl3QuBZ/JJh0v3AQEQIsQ0bVMf
         1PcMeN59OWwHXFAIO+SQJuSEARd+M+ETklHntkgmIvjtvXBy/z3Wa5/nbbvH0VY5Z2+Y
         rugTX5x5wAz49K81wSU7bOQibbyZGaSiHl5d5KsUeoqMVrVuJ3p6fwdqywsoucrtsOph
         FsDujNX6Inguxiw5Uu1Ze9/TDHCW1eCSTXv8fvp13eDyMUgKIUrklc4ipYDBvY3ZMKO7
         0FuxBNCHHI4OaJ6Ew3FchSd1FkGxwpd4DouViz7Tp9s3QMaZ7Gpol76Qmh+7EJT1hJBP
         q+sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698765282; x=1699370082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vr1AErEXYYfmkBWS1LpTvT+F3LQxWwS/eQ/Zsz08Hd4=;
        b=ouvNbYZ5zHakWWBNu6eHF5bshK2u9LJGcCYTqukHCc+c02yPhFHFEBlSynWcLPa3Mj
         OoRKoocT1ZAkh8cDdyuHj+NIhY63pzfuvxDA2Dw5VzIWy+VYZIXjmZzcS16KvOphW8Pi
         ixG1duOCy9xlgnBPqJhLnaLYn92c2CPvmcJsW9CksAlq4loXaV/rVwA3/XBXvzP/jacV
         7sBVvSRBUaoqW50yeHPC9iBfNacEEcgV48f5+7TvBAM/fp+WJZmwa3a4zvBVdTHxwdEy
         L+faCOfmYazd1tL6Ox0Xlehe8AB6EaGhghRTwGa7UerZIhoczeRoAF8yoXb8Y7UqPTaa
         j0kA==
X-Gm-Message-State: AOJu0YwsGj6ZhXd9HlQsU7Wy38pik9dreMgG1Wq2yJC5zMObvyzv0zRG
	0IFbOX9ooEFvXMqJhHuPlW854RezG8o=
X-Google-Smtp-Source: AGHT+IECkJTmhIJGkTF4pKGmyqapQ5bOlzGrkJelJGfeRGK75Ip1x8yi4FRzdb0jO8EFwvIyDKkUu5yUfSE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:cccd:0:b0:5a7:ad04:5118 with SMTP id
 o196-20020a0dcccd000000b005a7ad045118mr77305ywd.3.1698765282634; Tue, 31 Oct
 2023 08:14:42 -0700 (PDT)
Date: Tue, 31 Oct 2023 08:14:41 -0700
In-Reply-To: <ZUDQXbDDsGI3KiQ8@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <2C868574-37F4-437D-8355-46A6D1615E51@cs.utexas.edu>
 <ZTxEIGmq69mUraOD@google.com> <ZT+eipbV5+mSjr+G@yzhao56-desk.sh.intel.com>
 <ZUAC0jvFE0auohL4@google.com> <ZUDQXbDDsGI3KiQ8@yzhao56-desk.sh.intel.com>
Message-ID: <ZUEZ4QRjUcu7y3gN@google.com>
Subject: Re: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Yibo Huang <ybhuang@cs.utexas.edu>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, Yan Zhao wrote:
> On Mon, Oct 30, 2023 at 12:24:02PM -0700, Sean Christopherson wrote:
> > On Mon, Oct 30, 2023, Yan Zhao wrote:
> > Digging deeper through the history, this *mostly* appears to be the result of coming
> > to the complete wrong conclusion for handling memtypes during EPT and VT-d enabling.

...

> > Note the CommitDates!  The AuthorDates strongly suggests Sheng Yang added the whole
> > IGMT things as a bug fix for issues that were detected during EPT + VT-d + passthrough
> > enabling, but Avi applied it earlier because it was a generic fix.
> >
> My feeling is that
> Current memtype handling for non-coherent DMA is a compromise between
> (a) security ("qemu mappings will use writeback and guest mapping will use guest
> specified memory types")
> (b) the effective memtype cannot be cacheable if guest thinks it's non-cacheable.

And correctness.  E.g. accessing memory with conficting memtypes could cause guest
data corruption, which isn't strictly the same as (a).

> So, for MMIOs in non-coherent DMAs, mapping them as UC in EPT is understandable,
> because other value like WB or WC is not preferred --
> guest usually sets MMIOs' PAT to UC or WC, so "PAT=UC && EPT=WB" or
> "PAT=UC && EPT=WC" are not preferred according to SDM due to page aliasing.
> And VFIO maps the MMIOs to UC in host.
> (With pass-through GPU in my env, the MMIOs' guest MTRR is UC,
>  I can observe host hang if I program its EPT type to
>  - WB+IPAT or
>  - WC
>  )

Yes, but all of that simply confirms that it's KVM's responsibility to map host
MMIO as UC.  The hangs you observe likely have nothing to do with memory aliasing,
and everything to do with accessing real MMIO with incompatible memtypes.

> For guest RAM, looks honoring guest MTRRs just mitigates the page aliasing
> problem.
> E.g. if guest PAT=UC because its MTRR=UC, setting EPT type=UC can avoid
> "guest PAT=UC && EPT=WB", which is not recommended in SDM.
> But it still breaks (a) if guest PAT is UC.
> Also, honoring guest MTRRs in EPT is friendly to old systems that do not enable
> PAT. I guess :)

LOL, no way.  The PAT can't be disabled, and the default PAT combinations are
backwards compatible with legacy PCD+PWT.  The only way for this to provide value
is if someone is virtualizing a pre-Pentium Pro CPU, doing device passthrough,
and *only* doing so on hardware with EPT.

> But I agree, in common cases, honoring guest MTRRs or not looks no big difference.
> (And I'm not lucky enough to reproduce page-aliasing-caused MCE yet in my
> environment).

FWIW, I don't think that page aliasing with WC/UC actually causes machine checks.
What does result in #MC (assuming things haven't changed in the last few years)
is accessing MMIO using WB and other cacheable memtypes, e.g. map the host APIC
with WB and you should see #MCs.  I suspect this is what people encountered years
ago when KVM attempted to honored guest MTRRs at all times.  E.g. the "full" MTRR
virtualization patch that got reverted deliberately allowed the guest to control
the memtype for host MMIO.

The SDM makes aliasing sound super scary, but then has footnotes where it explicitly
requires the CPU to play nice with aliasing, e.g. if MTRRs are *not* UC but the
effective memtype is UC, then the CPU is *required* to snoop caches:

  2. The UC attribute came from the page-table or page-directory entry and
     processors are required to check their caches because the data may be cached
     due to page aliasing, which is not recommended.

Lack of snooping can effectively cause data corruption and ordering issues, but
at least for WC/UC vs. WB I don't think there are actual #MC problems with aliasing.

> For CR0_CD=1,
> - w/o KVM_X86_QUIRK_CD_NW_CLEARED, it meets (b), but breaks (a).
> - w/  KVM_X86_QUIRK_CD_NW_CLEARED, with IPAT=1, it meets (a), but breaks (b);
>                                    with IPAT=0, it may breaks (a), but meets (b)

CR0.CD=1 is a mess above and beyond memtypes.  Huh.  It's even worse than I thought,
because according to the SDM, Atom CPUs don't support no-fill mode:

  3. Not supported In Intel Atom processors. If CD = 1 in an Intel Atom processor,
     caching is disabled.

Before I read that blurb about Atom CPUs, what I was going to say is that, AFAIK,
it's *impossible* to accurately virtualize CR0.CD=1 on VMX because there's no way
to emulate no-fill mode.

> > Discussion from the EPT+MTRR enabling thread[*] more or less confirms that Sheng
> > Yang was trying to resolve issues with passthrough MMIO.
> > 
> >  * Sheng Yang 
> >   : Do you mean host(qemu) would access this memory and if we set it to guest 
> >   : MTRR, host access would be broken? We would cover this in our shadow MTRR 
> >   : patch, for we encountered this in video ram when doing some experiment with 
> >   : VGA assignment. 
> > 
> > And in the same thread, there's also what appears to be confirmation of Intel
> > running into issues with Windows XP related to a guest device driver mapping
> > DMA with WC in the PAT.  Hilariously, Avi effectively said "KVM can't modify the
> > SPTE memtype to match the guest for EPT/NPT", which while true, completely overlooks
> > the fact that EPT and NPT both honor guest PAT by default.  /facepalm
> 
> My interpretation is that the since guest PATs are in guest page tables,
> while with EPT/NPT, guest page tables are not shadowed, it's not easy to
> check guest PATs  to disallow host QEMU access to non-WB guest RAM.

Ah, yeah, your interpretation makes sense.

The best idea I can think of to support things like this is to have KVM grab the
effective PAT memtype from the host userspace page tables, shove that into the
EPT/NPT memtype, and then ignore guest PAT.  I don't if that would actually work
though.

> The credence is with Avi's following word:
> "Looks like a conflict between the requirements of a hypervisor 
> supporting device assignment, and the memory type constraints of mapping 
> everything with the same memory type.  As far as I can see, the only 
> solution is not to map guest memory in the hypervisor, and do all 
> accesses via dma.  This is easy for virtual disk, somewhat harder for 
> virtual networking (need a dma engine or a multiqueue device).
> 
> Since qemu will only access memory on demand, we don't actually have to 
> unmap guest memory, only to ensure that qemu doesn't touch it.  Things 
> like live migration and page sharing won't work, but they aren't 
> expected to with device assignment anyway."

