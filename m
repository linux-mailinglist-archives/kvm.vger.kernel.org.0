Return-Path: <kvm+bounces-66318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 52539CCF8DE
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:19:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E040D3035A56
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 11:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E499430F554;
	Fri, 19 Dec 2025 11:19:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE272F6199;
	Fri, 19 Dec 2025 11:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766143189; cv=none; b=SR1FUKlK6LuK1XtVpT89vlGuRAnbijnqoDhEInIubYvbc4O+H5zvsntCKM8podletufkmqyUZslEeWgAg7wzrwlV2qo0QYvW7TS5zb9eKxrndByY6/+2pUNeh0UKtSC+WNLkqsyASNXDt08RnMjNB3hBU1wIf84DYjkpnfWvJFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766143189; c=relaxed/simple;
	bh=ruHRsdlqnlZ041j7NKcKTYoo1k6EESLmoqH/3W6LTbI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n3Mhao6d237zKt9a3f1QetjnAQgMFaMWglOmy8b5s+BWZvOuIvUXAtwUYxKFJodJ+xqgjG2RKfIbD60gOnn5U2N+AFi9g8Ujksm9CYtFbY4FBYUsHAj59Zx/PF1g89Vnx/jvXsIGyT1bfffx7a93RBMGWiDt8h3w5ypt+sWelPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dXlRR02wczHnGgv;
	Fri, 19 Dec 2025 19:19:15 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 06C2A40570;
	Fri, 19 Dec 2025 19:19:44 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 19 Dec
 2025 11:19:43 +0000
Date: Fri, 19 Dec 2025 11:19:41 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>,
	<chao.gao@intel.com>, <dave.jiang@intel.com>, <baolu.lu@linux.intel.com>,
	<yilun.xu@intel.com>, <zhenzhong.duan@intel.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@linux.intel.com>,
	<dan.j.williams@intel.com>, <kas@kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v1 01/26] coco/tdx-host: Introduce a "tdx_host" device
Message-ID: <20251219111941.00005bd7@huawei.com>
In-Reply-To: <20251117022311.2443900-2-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
	<20251117022311.2443900-2-yilun.xu@linux.intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Mon, 17 Nov 2025 10:22:45 +0800
Xu Yilun <yilun.xu@linux.intel.com> wrote:

> From: Chao Gao <chao.gao@intel.com>
> 
> TDX depends on a platform firmware module that is invoked via instructions
> similar to vmenter (i.e. enter into a new privileged "root-mode" context to
> manage private memory and private device mechanisms). It is a software
> construct that depends on the CPU vmxon state to enable invocation of
> TDX-module ABIs. Unlike other Trusted Execution Environment (TEE) platform
> implementations that employ a firmware module running on a PCI device with
> an MMIO mailbox for communication, TDX has no hardware device to point to
> as the TEE Secure Manager (TSM).
> 
> Create a virtual device not only to align with other implementations but
> also to make it easier to
> 
>  - expose metadata (e.g., TDX module version, seamldr version etc) to
>    the userspace as device attributes
> 
>  - implement firmware uploader APIs which are tied to a device. This is
>    needed to support TDX module runtime updates
> 
>  - enable TDX Connect which will share a common infrastructure with other
>    platform implementations. In the TDX Connect context, every
>    architecture has a TSM, represented by a PCIe or virtual device. The
>    new "tdx_host" device will serve the TSM role.
> 
> A faux device is used as for TDX because the TDX module is singular within
> the system and lacks associated platform resources. Using a faux device
> eliminates the need to create a stub bus.
> 
> The call to tdx_enable() makes the new module independent of kvm_intel.ko.
> For example, TDX Connect may be used to established to PCIe link encryption
> even if a TVM is never launched.  For now, just create the common loading
> infrastructure.
> 
> [ Yilun: Remove unnecessary head files ]
> Co-developed-by: Xu Yilun <yilun.xu@linux.intel.com>
> Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
LGTM
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


