Return-Path: <kvm+bounces-25316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEFF89638BF
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 05:23:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1DF21C21BFA
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 03:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9AB549626;
	Thu, 29 Aug 2024 03:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MMM7kvg/"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E36134B1
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 03:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724901797; cv=none; b=NXtl8L1KaG4sGwz8Y7yJ8klbig55mbahgVhuNV7sYmCQ6MAbBjoQ5JkF+gbKAuApGKtMRsHqC+6RiCNb4+RLKRoh2gBg5p7Wy9/rzXC4sjxgHsWgoRVHN8AeodJXvG65l/J6U9YHE9VX44HmOcnqXC7CjqIZqlWujkvMil6S8mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724901797; c=relaxed/simple;
	bh=oWxRafjjLhIP5AIJzSQUbk9iO58IiQVi2KjoQaaoEOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P+ccUDKUfO6lr0sRDyXKU1Vy1VjJZQGdhQ0QmfRegWO+Aa+ot0ZGFQROnHX8322am3JbCioLz6wiRtJ2+2JiVoC+vonRShE+OhbnZ/pFCy7Oh0NQfd5EtAR9J1ps7Ects3nu1C6DzH0pHCVFEr91eD9Bb38dPgPkwsmOD68pqWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MMM7kvg/; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <aa72bc73-b20d-4652-be89-37d01f291725@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724901792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+fo1NXh8gz1NIdYj9mdGQk+zxleTCJW/UsjD05iB7/k=;
	b=MMM7kvg/yA/IxavmMA65WESHqDBZxcVLmuR/pIu2qHq0lDWwxM/sanHVPOi/3o9UXE8+F+
	vZ/lnFtRiY9RgEez6Qzy7x28CQHTaEHGRF/lI7/qYFd0L8OE1O9E5xcH4ZG5+hUvRn/7g8
	yqgIe5tn571i94FrMaTJUnH08GlSppQ=
Date: Thu, 29 Aug 2024 11:22:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3] Loongarch: KVM: Add KVM hypercalls documentation for
 LoongArch
To: Dandan Zhang <zhangdandan@uniontech.com>, pbonzini@redhat.com,
 corbet@lwn.net, zhaotianrui@loongson.cn, maobibo@loongson.cn,
 chenhuacai@kernel.org, zenghui.yu@linux.dev
Cc: kernel@xen0n.name, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 guanwentao@uniontech.com, wangyuli@uniontech.com, baimingcong@uniontech.com,
 Xianglai Li <lixianglai@loongson.cn>, Mingcong Bai <jeffbai@aosc.io>
References: <4769C036576F8816+20240828045950.3484113-1-zhangdandan@uniontech.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: YanTeng Si <si.yanteng@linux.dev>
In-Reply-To: <4769C036576F8816+20240828045950.3484113-1-zhangdandan@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 2024/8/28 12:59, Dandan Zhang 写道:
> From: Bibo Mao <maobibo@loongson.cn>
>
> Add documentation topic for using pv_virt when running as a guest
> on KVM hypervisor.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> Co-developed-by: Mingcong Bai <jeffbai@aosc.io>
> Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
> Link: https://lore.kernel.org/all/5c338084b1bcccc1d57dce9ddb1e7081@aosc.io/
> Signed-off-by: Dandan Zhang <zhangdandan@uniontech.com>
> ---
>   Documentation/virt/kvm/index.rst              |  1 +
>   .../virt/kvm/loongarch/hypercalls.rst         | 89 +++++++++++++++++++
>   Documentation/virt/kvm/loongarch/index.rst    | 10 +++
>   MAINTAINERS                                   |  1 +
>   4 files changed, 101 insertions(+)
>   create mode 100644 Documentation/virt/kvm/loongarch/hypercalls.rst
>   create mode 100644 Documentation/virt/kvm/loongarch/index.rst
If you don't mind, how about translating these into Chinese? If
you decide to do so, you don't need to split the patch again,
just complete your translation in this patch and add your
Co-developed-by tag.

Thanks,
Yanteng

