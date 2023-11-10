Return-Path: <kvm+bounces-1493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A437E7E07
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 18:09:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1225DB20D6E
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 17:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50BCD20B14;
	Fri, 10 Nov 2023 17:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rKzlsSrJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923DC208C1
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 17:09:36 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AE943914
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 09:09:35 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a828bdcfbaso31434437b3.2
        for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 09:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699636174; x=1700240974; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hznnpG8et6XCs8lWEVE15t3+f8DKbwMJPjXs5s2aL9c=;
        b=rKzlsSrJYED43cSBuRFkhad2Jk4NNSAOYs35egaq9MOmKo/6GLi8k4/AFjXPE0GQKS
         4WSBn2UVulcyBfm0If+WJad9DuTav1d566y/FvJ9lnvhMKWgvvP5WvPomqU/NsdUchVU
         PvqOWYISbjv889Qeb3GQnVxR+KDCN8hQJF1L1fXhuLhpE4DGy//vYmv3VUcbdcyEbMas
         ALOdd+KrK0XDCq/v4rhcgfAE5hXqqP5PTd86NqCzbOZk9LAgAIkFsRkkk5HQdM69lqpi
         bnINO638iRl5tRmTSORrCJKnzLV/xQXrIYMcc2VtU+kMCLCV40bc9Orb0FM8XbEFpNue
         a3MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699636174; x=1700240974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hznnpG8et6XCs8lWEVE15t3+f8DKbwMJPjXs5s2aL9c=;
        b=WfBnewF5Ae8zy7bJh/nrq19svbh+ZdBlV1xY5sKosVG9alHCS5nTBtQlBzO/Bykslf
         GPDOErvLYBcjo/FNHYakx6Bqq34jNtIFCv47cSLx2M6dtAHvSIGxChhcjGvcrBELdQxu
         9Cn4M1yio4PDJh6UqsIpPFoZ5Rka96K08CiJPfcdYfcqpW08chRAahjsti2mA8EDgWu8
         vKKrhQ6+rfmwPfi8WODBGTBhi/hi5YwtOFOHBpCxf+d1xRRat1nj1EUdqtiU0E81wixS
         kNeQdn7WPiY0XHgOlSNAWQC8in/C94rFZuz0LldcrsKmTLVp+j5WciL/LOrbLM0duHZi
         CSng==
X-Gm-Message-State: AOJu0YzySkGpGBDDyW/T+UMkinyDC606G1+pTtkFktnkKFl4Oln7t6dl
	gEKc9wDStKL/mZdhALpSb+ZeNs/rWPo=
X-Google-Smtp-Source: AGHT+IENqCN+oKyPpilkEFYxVN531QoZ+fdQmfKK80fTiShTmNx2x3C7ihkoSewL9wenI3oD8lKeZssmpKQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ad5e:0:b0:dae:e8dc:c026 with SMTP id
 l30-20020a25ad5e000000b00daee8dcc026mr154511ybe.13.1699636174714; Fri, 10 Nov
 2023 09:09:34 -0800 (PST)
Date: Fri, 10 Nov 2023 09:09:33 -0800
In-Reply-To: <ZUsPQTh9qLva81pA@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZTxEIGmq69mUraOD@google.com> <ZT+eipbV5+mSjr+G@yzhao56-desk.sh.intel.com>
 <ZUAC0jvFE0auohL4@google.com> <ZUDQXbDDsGI3KiQ8@yzhao56-desk.sh.intel.com>
 <ZUEZ4QRjUcu7y3gN@google.com> <ZUIVfpAz0+7jVZvC@yzhao56-desk.sh.intel.com>
 <ZUlp4AgjvoG7zk_Y@google.com> <ZUoCxyNsc/dB4/eN@yzhao56-desk.sh.intel.com>
 <ZUp8iqBDm_Ylqiau@google.com> <ZUsPQTh9qLva81pA@yzhao56-desk.sh.intel.com>
Message-ID: <ZU5jzV06Wm92win2@google.com>
Subject: Re: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Yibo Huang <ybhuang@cs.utexas.edu>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 08, 2023, Yan Zhao wrote:
> On Tue, Nov 07, 2023 at 10:06:02AM -0800, Sean Christopherson wrote:
> > On Tue, Nov 07, 2023, Yan Zhao wrote:
> > > On Mon, Nov 06, 2023 at 02:34:08PM -0800, Sean Christopherson wrote:
> > > > On Wed, Nov 01, 2023, Yan Zhao wrote:
> > > > > On Tue, Oct 31, 2023 at 08:14:41AM -0700, Sean Christopherson wrote:
> > > 
> > > > > If no #MC, could EPT type of guest RAM also be set to WB (without IPAT) even
> > > > > without non-coherent DMA?
> > > > 
> > > > No, there are snooping/ordering issues on Intel, and to a lesser extent AMD.  AMD's
> > > > WC+ solves the most straightfoward cases, e.g. WC+ snoops caches, and VMRUN and
> > > > #VMEXIT flush the WC buffers to ensure that guest writes are visible and #VMEXIT
> > > > (and vice versa).  That may or may not be sufficient for multi-threaded use cases,
> > > > but I've no idea if there is actually anything to worry about on that front.  I
> > > > think there's also a flaw with guest using UC, which IIUC doesn't snoop caches,
> > > > i.e. the guest could get stale data.
> > > > 
> > > > AFAIK, Intel CPUs don't provide anything like WC+, so KVM would have to provide
> > > > something similar to safely let the guest control memtypes.  Arguably, KVM should
> > > > have such mechansisms anyways, e.g. to make non-coherent DMA VMs more robust.
> > > > 
> > > > But even then, there's still the question of why, i.e. what would be the benefit
> > > > of letting the guest control memtypes when it's not required for functional
> > > > correctness, and would that benefit outweight the cost.
> > > 
> > > Ok, so for a coherent device , if it's assigned together with a non-coherent
> > > device, and if there's a page with host PAT = WB and guest PAT=UC, we need to
> > > ensure the host write is flushed before guest read/write and guest DMA though no
> > > need to worry about #MC, right?
> > 
> > It's not even about devices, it applies to all non-MMIO memory, i.e. unless the
> > host forces UC for a given page, there's potential for WB vs. WC/UC issues.
> Do you think we can have KVM to expose an ioctl for QEMU to call in QEMU's
> invalidate_and_set_dirty() or in cpu_physical_memory_set_dirty_range()?
> 
> In this ioctl, it can do nothing if non-coherent DMA is not attached and
> call clflush otherwise.

Why add an ioctl()?  Userspace can do CLFLUSH{OPT} directly.  If it would fix a
real problem, then adding some way for userspace to query whether or not there
is non-coherent DMA would be reasonable, though that seems like something that
should be in VFIO (if it's not already there).

