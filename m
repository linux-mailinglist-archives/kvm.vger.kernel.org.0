Return-Path: <kvm+bounces-66334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB70CCFBC4
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 13:16:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 10C383072E29
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD373321B0;
	Fri, 19 Dec 2025 12:06:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B2C331A4E;
	Fri, 19 Dec 2025 12:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766145982; cv=none; b=iaDif0AgTTSdIFD+zmiHgl376L0tnrwx/dnkUr9A9vyxigYv2Tbfjapu2sP3QMwhty43ed8kqIaMdwvm9zGKFU8C02t5vE8LwxxVLk8hkx4eDQIOcNzmlZj7UKrnXhaBVkZ3hXskCpxMLq6cSeCmIXiMPVntf5EYv7TMuhB0fbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766145982; c=relaxed/simple;
	bh=lPTWcqb09M9SIYecnJ6KVBkozHzUAjxvJUp1Iz0Z7Sk=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IJdMu+J4E8v34PfJO18mkHiFnpvsvmLHHnKVgUHYOwIzWDPlvWgax0nJGEPjIkqHNoB6dInTeM8BCxhp3wvnuE6ocQvU+uxtcCOkc/e0p7HVDtcZ4CSgw8+V+s995PpQ7Er9pFkECuZIXqRIR3HOZlOE/hDthV77drGRj38alNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dXmT606cPzJ46BZ;
	Fri, 19 Dec 2025 20:05:46 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 905D940569;
	Fri, 19 Dec 2025 20:06:18 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 19 Dec
 2025 12:06:17 +0000
Date: Fri, 19 Dec 2025 12:06:16 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>,
	<chao.gao@intel.com>, <dave.jiang@intel.com>, <baolu.lu@linux.intel.com>,
	<yilun.xu@intel.com>, <zhenzhong.duan@intel.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@linux.intel.com>,
	<dan.j.williams@intel.com>, <kas@kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v1 26/26] coco/tdx-host: Finally enable SPDM session and
 IDE Establishment
Message-ID: <20251219120616.00000890@huawei.com>
In-Reply-To: <20251117022311.2443900-27-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
	<20251117022311.2443900-27-yilun.xu@linux.intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Mon, 17 Nov 2025 10:23:10 +0800
Xu Yilun <yilun.xu@linux.intel.com> wrote:

> The basic SPDM session and IDE functionalities are all implemented,
> enable them.
> 
> Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Hard to disagree with this one :)
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

