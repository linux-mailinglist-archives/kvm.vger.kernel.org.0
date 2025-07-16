Return-Path: <kvm+bounces-52674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 062E7B080D4
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 01:07:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 846124A5826
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 23:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852302EF64A;
	Wed, 16 Jul 2025 23:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KFLU13GF"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C0A3FE7;
	Wed, 16 Jul 2025 23:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752707263; cv=none; b=FE8Djgh4qOThVDWc0Ha7VZXhBuWFnyO02wyy6D7OhsdhrZF22Ayke/eOmY3uWi6THXXATNBjLp6E66O5LzbPw65hhOPTQu9OVXVPsSIcszem0C5ShwA1mjgOS8aoZ+RWY9Dvff/VXRbxb7F8tl4EK5tpxqwQs8MEYrNQk2MoV1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752707263; c=relaxed/simple;
	bh=BEoXnAAQJ4E+fgJTyB4gNSBQL4iMYHUyYrJsXxB9A6A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qomKISe1HjBW4FzJjvGdbkhbZ6i6+nceRovsXxU9ZK98NMWja9vURcJAaAf4lCtFyL0EMhfejlT3gARiYvc+X/LxjczRK340YD8OgfJ+GzosfA+EKKEykDxVO4ltlAEghhL5+y1j9sVA2JUFGaFafytsrlAFlOt4uG6UEgnbl84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KFLU13GF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=DeMkf81B5yNrigfNCgydML/LD6DZlbT9djSrJqCL3NI=; b=KFLU13GFIsRrfZBt7JylDpgKIM
	OHsWxOYmMRk4JiTf5nzk6kszvXMW2QZEGYqLwxu3iJAuT0UMEp0pixuApTGZwq+yKUYUy7j6AacDq
	UidV35YHgyjbzESoCzP83FvnSzbKxzI67+UuWj9mopNW2wJaehlL0Ohj8PdtV9bvBzneODWNlveo1
	gUmGPz26wapKtOYIwILWjJm9HFA+x2Fx7knFk04tLgKnUxLtVyGaSjh6cvWFqGnQWT1k3kq5E9s4A
	WujcSQu2s8Vb7nYeMPziXzRJO+YMAqtCfuAJlWaTcGUf0WsOGLvgrwA3mcJ2Zv64eGpCjhAtOMi6x
	7iDrYvBw==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ucBDw-00000008qNf-0YZ9;
	Wed, 16 Jul 2025 23:07:40 +0000
Message-ID: <4a6fd102-f8e0-42f3-b789-6e3340897032@infradead.org>
Date: Wed, 16 Jul 2025 16:07:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: Tree for Jul 16 (drivers/vfio/cdx/intr.c)
To: Stephen Rothwell <sfr@canb.auug.org.au>,
 Linux Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-um@lists.infradead.org, Linux KVM <kvm@vger.kernel.org>,
 Nipun Gupta <nipun.gupta@amd.com>, Nikhil Agarwal <nikhil.agarwal@amd.com>,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
References: <20250716212558.4dd0502b@canb.auug.org.au>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250716212558.4dd0502b@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/16/25 4:25 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20250715:
> 

on ARCH=um SUBARCH=x86_64:

../drivers/vfio/cdx/intr.c: In function ‘vfio_cdx_msi_enable’:
../drivers/vfio/cdx/intr.c:41:15: error: implicit declaration of function ‘msi_domain_alloc_irqs’; did you mean ‘msi_domain_get_virq’? [-Wimplicit-function-declaration]
   41 |         ret = msi_domain_alloc_irqs(dev, MSI_DEFAULT_DOMAIN, nvec);
      |               ^~~~~~~~~~~~~~~~~~~~~
      |               msi_domain_get_virq
../drivers/vfio/cdx/intr.c: In function ‘vfio_cdx_msi_disable’:
../drivers/vfio/cdx/intr.c:135:9: error: implicit declaration of function ‘msi_domain_free_irqs_all’ [-Wimplicit-function-declaration]
  135 |         msi_domain_free_irqs_all(dev, MSI_DEFAULT_DOMAIN);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~


Those missing functions are provided by CONFIG_GENERIC_MSI_IRQ
(which is not set).

Should VFIO_CDX select GENERIC_MSI_IRQ or just not build on ARCH=um?


-- 
~Randy


