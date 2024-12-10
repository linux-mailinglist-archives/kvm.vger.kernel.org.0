Return-Path: <kvm+bounces-33432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90AC99EB5A9
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 17:08:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DA081880423
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 16:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E411C07F4;
	Tue, 10 Dec 2024 16:08:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B044323DEA7;
	Tue, 10 Dec 2024 16:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733846896; cv=none; b=Y3/EYqvLkUdtWeNpUhVzSrh1dbkrlXDObGlKQ0xvMNn7GOA/jxMkr2+IcO04aIKdki3bABECoPY9UMV3Uz39DnR50FgTOtzpfz+3mMJ+o8ngNbhNlnNe61TT/gU1/TcRDB/0miTPf6dYQbQuhKCLq509nuf/5bhUy50azZhVFWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733846896; c=relaxed/simple;
	bh=PLfAgq5Hmdu2Pj0dxykFQD+ZyQvOCG+Bk4IVmhx0xP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sQ22KxWNgeWOLNYAwjVxQq4wff5KOklvSBpFhDKp/2aRP78QtyhWtB2KJb5AGfqnfeGTG+azcJiSu1GhcUyGNEnccDX/wt7pgtiJPgplu9a+1PdmJm1M+W7MQ0cEUfrxMMaEBKjYaSZaEteX+hkJkLUjTGYPj77Zq97rhAST0NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2401C4CED6;
	Tue, 10 Dec 2024 16:08:09 +0000 (UTC)
Date: Tue, 10 Dec 2024 16:08:07 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Will Deacon <will@kernel.org>,
	ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	ryan.roberts@arm.com, shahuang@redhat.com, lpieralisi@kernel.org,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	zhiw@nvidia.com, mochs@nvidia.com, udhoke@nvidia.com,
	dnigam@nvidia.com, alex.williamson@redhat.com,
	sebastianene@google.com, coltonlewis@google.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/1] KVM: arm64: Map GPU memory with no struct pages
Message-ID: <Z1hnZ0H13Pst5sKF@arm.com>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241210140739.GC15607@willie-the-truck>
 <20241210141806.GI2347147@nvidia.com>
 <0723d890-1f90-463b-a814-9f7bb7e2200b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0723d890-1f90-463b-a814-9f7bb7e2200b@redhat.com>

On Tue, Dec 10, 2024 at 10:56:43AM -0500, Donald Dutile wrote:
> So, I'm not sure I read what is needed to resolve this patch. I read
> Will's reply to split it further and basically along what logical
> lines of functionality; is there still an MTE complexity that has to
> be resolved/included in the series?

Since MTE is still around, the complexity did not go away. But I need to
properly read the patch and Will's comment and page in the whole
discussion from last year.

There's now FEAT_MTE_PERM as well but we don't have those patches in
yet:

https://lore.kernel.org/r/20241028094014.2596619-1-aneesh.kumar@kernel.org/

-- 
Catalin

