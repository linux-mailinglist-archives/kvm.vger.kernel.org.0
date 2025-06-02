Return-Path: <kvm+bounces-48174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFED3ACB022
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 16:01:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE563402AEB
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 14:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F2922259C;
	Mon,  2 Jun 2025 14:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="odmJ29Tg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAFA221DA2;
	Mon,  2 Jun 2025 14:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872827; cv=none; b=JVAEcMJ8M+Lzd2xpsKnDZ2FIp5hIA4rJjZ56JCYJCWWIKrHhtNfhqNTg3notHcLtwTm42GEEkfCtaPxLMBO+863Zt+rMcS8ProjXMs89Og3YM8OLJB5JoQRDzDpJcCHsylNsJb/yH9r2YQXh2FSZtmWowwNKQcMuvD7HnNUzsUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872827; c=relaxed/simple;
	bh=wNC7AaKe9Ra7Pe5UYUQ6T8kl4WJKtgV4gm/y/d9HwYA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hm4OHHaMqnMaPibwGoiQ6g1+kf0H+fzgSvZIAw1zkgKDaL/VtJ6C22ejori/o2gm055onyrfZPH6+ph8y/az9f/syfn9WqMKG0ql1K26/JzEPrpj92355IWE9fVPnDaCx1ZZPe8Irb1Y7lIt9ilayMj55usTfCNKMTr0sziD1F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=odmJ29Tg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AD1C4AF09;
	Mon,  2 Jun 2025 14:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748872826;
	bh=wNC7AaKe9Ra7Pe5UYUQ6T8kl4WJKtgV4gm/y/d9HwYA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=odmJ29TgLSk1eGgj/iJAPiRUO858mVI2Tt41Em+yUgfpwQafnTSb0TYyzYTji7Gfm
	 hqF4QIi+Ql3uxYhMBXD91tvYIYfQ0/PDKDJK6SKMnh9hjY7kOqmhwIdmtAmmfVf8Sb
	 qj03+/Ou5TEWeF8opqLH9BZjMJO+2cXnEFhjWrVwxCwY16Km0zvogqhjoH1/EBama/
	 aX41571aA3F335y3HaJwIR/5t1O8XN+chx2jx6C0vgeCVrokOeyOwvtDkBxdTbVo7V
	 k7przZP19XGI0Jr+fxT4GAhMjOiYqxUkZDZry3pMwxqmu3sYOYGxpee2p/31RnZLsj
	 1m6i0Io8ggCfA==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Xu Yilun <yilun.xu@linux.intel.com>, kvm@vger.kernel.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	jgg@nvidia.com, dan.j.williams@intel.com, aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, vivek.kasireddy@intel.com,
	yilun.xu@intel.com, yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com,
	linux-pci@vger.kernel.org, zhiw@nvidia.com, simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com, iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: Re: [RFC PATCH 20/30] vfio/pci: Do TSM Unbind before zapping bars
In-Reply-To: <20250529053513.1592088-21-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-21-yilun.xu@linux.intel.com>
Date: Mon, 02 Jun 2025 19:30:15 +0530
Message-ID: <yq5ar002jlao.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Xu Yilun <yilun.xu@linux.intel.com> writes:

> When device is TSM Bound, some of its MMIO regions are controlled by
> secure firmware. E.g. TDX Connect would require these MMIO regions
> mappeed in S-EPT and never unmapped until device Unbound. Zapping bars
> irrespective of TSM Bound state may cause unexpected secure firmware
> errors. It is always safe to do TSM Unbind first, transiting the device
> to shared, then do whatever needed as before.
>
> Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c |  4 +++
>  drivers/vfio/pci/vfio_pci_core.c   | 41 +++++++++++++++++++-----------
>  drivers/vfio/pci/vfio_pci_priv.h   |  3 +++
>  3 files changed, 33 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 7ac062bd5044..4ffe661c9e59 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -590,6 +590,7 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
>  		new_mem = !!(new_cmd & PCI_COMMAND_MEMORY);
>  
>  		if (!new_mem) {
> +			vfio_pci_tsm_unbind(vdev);
>  			vfio_pci_zap_and_down_write_memory_lock(vdev);
>  			vfio_pci_dma_buf_move(vdev, true);
>

For a secure device mmio range instead of vfio_pci_zap_and_down_write_memory_lock()
-> unmap_mapping_range() we want the vfio_pci_dma_buf_move right? Also
is that expected to get called twice as below?

vfio_pci_tsm_unbind-> pci_tsm_unbind -> tdx_tsm_unbind ->
tsm_handler->disable_mmio() -> vfio_pci_core_tsm_disable_mmio -> vfio_pci_dma_buf_move(vdev, true);

-aneesh

