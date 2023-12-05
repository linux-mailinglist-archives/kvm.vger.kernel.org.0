Return-Path: <kvm+bounces-3592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 887CA8059E9
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:24:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 429B328215B
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 16:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B793675B0;
	Tue,  5 Dec 2023 16:24:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5DC675A1;
	Tue,  5 Dec 2023 16:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D01CC433C8;
	Tue,  5 Dec 2023 16:24:25 +0000 (UTC)
Date: Tue, 5 Dec 2023 16:24:22 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <ZW9OtrUa_fPA0_Ns@arm.com>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
 <20231205130517.GD2692119@nvidia.com>
 <ZW81mT4WqKqtLnid@lpieralisi>
 <20231205144417.GE2692119@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205144417.GE2692119@nvidia.com>

On Tue, Dec 05, 2023 at 10:44:17AM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 05, 2023 at 03:37:13PM +0100, Lorenzo Pieralisi wrote:
> > On Tue, Dec 05, 2023 at 09:05:17AM -0400, Jason Gunthorpe wrote:
> > > On Tue, Dec 05, 2023 at 11:40:47AM +0000, Catalin Marinas wrote:
> > > > > - Will had unanswered questions in another part of the thread:
> > > > > 
> > > > >   https://lore.kernel.org/all/20231013092954.GB13524@willie-the-truck/
> > > > > 
> > > > >   Can someone please help concluding it?
> > > > 
> > > > Is this about reclaiming the device? I think we concluded that we can't
> > > > generalise this beyond PCIe, though not sure there was any formal
> > > > statement to that thread. The other point Will had was around stating
> > > > in the commit message why we only relax this to Normal NC. I haven't
> > > > checked the commit message yet, it needs careful reading ;).
> > > 
> > > Not quite, we said reclaiming is VFIO's problem and if VFIO can't
> > > reliably reclaim a device it shouldn't create it in the first place.
> > 
> > I think that as far as device reclaiming was concerned the question
> > posed was related to memory attributes of transactions for guest
> > mappings and the related grouping/ordering with device reset MMIO
> > transactions - it was not (or wasn't only) about error containment.
> 
> Yes. It is VFIO that issues the reset, it is VFIO that must provide
> the ordering under the assumption that NORMAL_NC was used.

And does it? Because VFIO so far only assumes Device-nGnRnE. Do we need
to address this first before attempting to change KVM? Sorry, just
questions, trying to clear the roadblocks.

-- 
Catalin

