Return-Path: <kvm+bounces-67652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA9FD0D3F5
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 10:27:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 07E3E3020CC0
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 09:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B890E2DA76A;
	Sat, 10 Jan 2026 09:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="jDwehzmi"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812E035965;
	Sat, 10 Jan 2026 09:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768037232; cv=none; b=fGdhaCAaReRxZeG5MWsIiw06O5RDm4CV2t3DHxGVjiNWmHpFNkBJDW8pJd1Bzf6ETDQcUIFDD9h/Pjf/D1Em52UTxPctajrLbwn9IOVs2UzBrG67GPPYvDML21Y3oHFrYaoNsw3X8pZPJK/J2VWw3zT0uMs9wMS6kiYHcorKnzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768037232; c=relaxed/simple;
	bh=wYmoWm7BTojrEnJyTKvvqvGn/JiK9wET35aEG/KxfoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EI32AcvO5ypv14dyVQGuAM7suCFZw6H/6fIANMpdArdvWp41IoBgbaoJq7geLuQrGeYpup59DaSRB20666G7zK1YDdwm5oIhHdoa2Y29PdEpdH7aG45Oh2qe/xTqsLBdi1hEls/Zd9aRCb1seYdNCzZ5kWQeI847gslH99AGijA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=jDwehzmi; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p200300f6af1d9600dfc71246d978d903.dip0.t-ipconnect.de [IPv6:2003:f6:af1d:9600:dfc7:1246:d978:d903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 2914F5DC43;
	Sat, 10 Jan 2026 10:27:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1768037223;
	bh=wYmoWm7BTojrEnJyTKvvqvGn/JiK9wET35aEG/KxfoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jDwehzmiUPaneVy8leWWUS+FSM8CwhlYOagzG/QPx5OpdR79dWq0gFnxMh7QsvWxb
	 esqVGiliwYW5JR7ntfQEg8m4Nz1nqf1jK8Sza68vMW1/3DtQ0/PMa0hY/Pxws08qUE
	 u+JAL7GlwKnfAMny1kdVdijEeO1L9J8ZI2cZQbH4qxCzEutwIoVL5eZzb/ymVckkpJ
	 NdIbPtRkMXOpSP86W7EnXN5Ve3GtkMVyB4BF3ZC5xV/h98OE8vho/EhkB1ZZjMZ6Ac
	 tuHhUpugpklqEkxDpIrdJRMancXyp+uCALimyIhATb1m6zyhdfYm5HNKvr69zJzRnC
	 L4VFHPVYrrJRQ==
Date: Sat, 10 Jan 2026 10:27:01 +0100
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, afael@kernel.org, 
	lenb@kernel.org, bhelgaas@google.com, alex@shazbot.org, jgg@nvidia.com, 
	kevin.tian@intel.com, baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, 
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev, 
	pjaroszynski@nvidia.com, vsethi@nvidia.com, helgaas@kernel.org, etzhao1900@gmail.com
Subject: Re: [PATCH v8 0/5] Disable ATS via iommu during PCI resets
Message-ID: <u3763xmcq6tr5nnuye7jj7c74nxbboneylbgywvydjtuhlmxcu@ho7sf4z4u55l>
References: <cover.1765834788.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1765834788.git.nicolinc@nvidia.com>

On Mon, Dec 15, 2025 at 01:42:15PM -0800, Nicolin Chen wrote:
> Nicolin Chen (5):
>   iommu: Lock group->mutex in iommu_deferred_attach()
>   iommu: Tidy domain for iommu_setup_dma_ops()
>   iommu: Add iommu_driver_get_domain_for_dev() helper
>   iommu: Introduce pci_dev_reset_iommu_prepare/done()
>   PCI: Suspend iommu function prior to resetting a device

Applied, thanks.

