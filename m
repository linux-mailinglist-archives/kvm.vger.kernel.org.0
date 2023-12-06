Return-Path: <kvm+bounces-3714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 506EF8074E0
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE2C21F21182
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F5B747769;
	Wed,  6 Dec 2023 16:23:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D85B3FE35;
	Wed,  6 Dec 2023 16:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4457C433C8;
	Wed,  6 Dec 2023 16:23:27 +0000 (UTC)
Date: Wed, 6 Dec 2023 16:23:25 +0000
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
Message-ID: <ZXCf_e-ACqrj6VrV@arm.com>
References: <ZW8MP2tDt4_9ROBz@arm.com>
 <20231205130517.GD2692119@nvidia.com>
 <ZW9OSe8Z9gAmM7My@arm.com>
 <20231205164318.GG2692119@nvidia.com>
 <ZW949Tl3VmQfPk0L@arm.com>
 <20231205194822.GL2692119@nvidia.com>
 <ZXCJ3pVbKuHJ3LTz@arm.com>
 <20231206150556.GQ2692119@nvidia.com>
 <ZXCQrTbf6q0BIhSw@lpieralisi>
 <20231206153809.GS2692119@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206153809.GS2692119@nvidia.com>

On Wed, Dec 06, 2023 at 11:38:09AM -0400, Jason Gunthorpe wrote:
> On Wed, Dec 06, 2023 at 04:18:05PM +0100, Lorenzo Pieralisi wrote:
> > On Wed, Dec 06, 2023 at 11:05:56AM -0400, Jason Gunthorpe wrote:
> > > On Wed, Dec 06, 2023 at 02:49:02PM +0000, Catalin Marinas wrote:
> > > > BTW, on those Mellanox devices that require different attributes within
> > > > a BAR, do they have a problem with speculative reads causing
> > > > side-effects? 
> > > 
> > > Yes. We definitely have had that problem in the past on older
> > > devices. VFIO must map the BAR using pgprot_device/noncached() into
> > > the VMM, no other choice is functionally OK.
> > 
> > Were those BARs tagged as prefetchable or non-prefetchable ? I assume the
> > latter but please let me know if I am guessing wrong.
> 
> I don't know it was quite old HW. Probably.
> 
> Just because a BAR is not marked as prefetchable doesn't mean that the
> device can't use NORMAL_NC on subsets of it.

What about the other way around - would we have a prefetchable BAR that
has portions which are unprefetchable?

-- 
Catalin

