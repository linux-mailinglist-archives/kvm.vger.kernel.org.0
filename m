Return-Path: <kvm+bounces-53609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAF75B149C4
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 10:09:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A29861894E9B
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 08:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D22D9275AF7;
	Tue, 29 Jul 2025 08:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oh0raH+w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083AC253F1B;
	Tue, 29 Jul 2025 08:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753776571; cv=none; b=lP6Oce5I+Olrld2zbLuJDDGTbMuDiZVOzBd5ri0Hec7TIYLC+i55huzvsML5BdUmr7/oVDtUmX0aVh2yeHqneT9VJ/0MRJP5Qvz1nyKyCTz5b1voa96Ee6/dp83cELqBOlW93udA/g3cl7ElQL22g4jmfkmHdWMquTtRSkjoARs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753776571; c=relaxed/simple;
	bh=Ij7Ymnaxc/DGUvIdevj8VlgMUZz8ZVDdL8pduuUCM5U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oY9uWaxELA2o15l0PVLg1lEZcmOrkXaIeb+Bi+dSj3qAa7unF+UYMOAC+Dx+Efl89oZ1k2bOWkbNwRgg6BYaMS9ZSd7fEcEziBTXe0R1nLytj9i6VBI16hsLOhZ4d8eLw9DZ2VK7YD0uw/4oeVzQjJpdH8/ckQM7yjmwVR1eZyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oh0raH+w; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753776568; x=1785312568;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ij7Ymnaxc/DGUvIdevj8VlgMUZz8ZVDdL8pduuUCM5U=;
  b=Oh0raH+w5Jveh8t5N5WhYBH8Wzan6qYVgisoSTe1oEHg1fDwGISvhZ6M
   l1Au2s9aESSP6cYjM0cn43sxcp8CKPGal9GbLrlAkQSpTroK+l85Wxk4u
   viBIEl5V7EQFKEW23EP2zAxKuGAoPJ5kfgRGDT5GeSY1rzar5fbqOQ8XZ
   yYffFQy7lRAHSMhzEyKxyYYCxXyravvJxExtw1XaVhpKpnG3KqQEcJoWh
   oI7nS394M/4VgiED0XYBPrykdenjaYIsVDLNDcheTS3Zu4RxtUdhuccgS
   G+AV5MrhqBebx7K7v+wwfjbl1sibvbnNy54VyO6ELBeFOvZtHEzephgkL
   A==;
X-CSE-ConnectionGUID: zIEQatVwRNm3xxv3vhllIg==
X-CSE-MsgGUID: vkrJufYwTg+93ujAsDuIVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11505"; a="56009327"
X-IronPort-AV: E=Sophos;i="6.16,348,1744095600"; 
   d="scan'208";a="56009327"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 01:09:28 -0700
X-CSE-ConnectionGUID: yliyZV1bT5GA0nAttgIj5g==
X-CSE-MsgGUID: Do91cK04QJWrVeE20TctQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,348,1744095600"; 
   d="scan'208";a="166810470"
Received: from soc-5cg4396xfb.clients.intel.com (HELO [172.28.180.57]) ([172.28.180.57])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 01:09:25 -0700
Message-ID: <c236b8ef-b899-4c23-bded-cf411c5b5ad1@linux.intel.com>
Date: Tue, 29 Jul 2025 10:09:21 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vhost: initialize vq->nheads properly
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com, eperezma@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sgarzare@redhat.com,
 will@kernel.org, JAEHOON KIM <jhkim@linux.ibm.com>,
 Breno Leitao <leitao@debian.org>
References: <20250729073916.80647-1-jasowang@redhat.com>
Content-Language: pl, en-US
From: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
In-Reply-To: <20250729073916.80647-1-jasowang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-07-29 9:39 AM, Jason Wang wrote:
> Commit 7918bb2d19c9 ("vhost: basic in order support") introduces
> vq->nheads to store the number of batched used buffers per used elem
> but it forgets to initialize the vq->nheads to NULL in
> vhost_dev_init() this will cause kfree() that would try to free it
> without be allocated if SET_OWNER is not called.

nit: as someone who is not familiar with vhost code, it took me a while 
to figure out you meant VHOST_SET_OWNER and the corresponding 
vhost_dev_set_owner()

> 
> Reported-by: JAEHOON KIM <jhkim@linux.ibm.com>
> Reported-by: Breno Leitao <leitao@debian.org>
> Fixes: 7918bb2d19c9 ("vhost: basic in order support")
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Reviewed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>

Thanks,
Dawid

