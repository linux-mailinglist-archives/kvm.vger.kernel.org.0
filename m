Return-Path: <kvm+bounces-66333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EC8D4CCFB55
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 13:09:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4CDFC30EA2BD
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 217732D877A;
	Fri, 19 Dec 2025 12:02:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A6D1FC101;
	Fri, 19 Dec 2025 12:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766145771; cv=none; b=dbzzT5t21f7JWyjccYZds1Dkgj741j5uf8Zr3M6XtQ394EZDZ5btdcOSPHwJBN73JQf7rxQlddK/xFDhyT9t/IveO+dKXBbom/zMp+ET+JwZU00OpCRjmBzj7mlKXQYZVWIIxucSdwqkaZ291NuYezJHtSdMstX/wUQiju4CEmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766145771; c=relaxed/simple;
	bh=wfTPFW0Skm9Y4Ph5lbUSNnOXj7XdGAr9TCijD6P8CsE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IfoZ+mQcwKArYnCmwFzdEyOPqvxdkF+TiH5XDO7hZwyQc0dOLe0M+KX4LJZCU4ovQxKdrWxwUwYxj3y2vRYDiRYL5dXaGVK4fzO5eM0So1X5sUfvUHhvKJmrQTP8Dzp0oNR9/OhrH4wZk5OgUjbPkwvu8UJxmlfwv+CqaReKkB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dXmP16nlszJ46bv;
	Fri, 19 Dec 2025 20:02:13 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 809A140571;
	Fri, 19 Dec 2025 20:02:46 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 19 Dec
 2025 12:02:45 +0000
Date: Fri, 19 Dec 2025 12:02:44 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>,
	<chao.gao@intel.com>, <dave.jiang@intel.com>, <baolu.lu@linux.intel.com>,
	<yilun.xu@intel.com>, <zhenzhong.duan@intel.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@linux.intel.com>,
	<dan.j.williams@intel.com>, <kas@kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v1 23/26] coco/tdx-host: Parse ACPI KEYP table to init
 IDE for PCI host bridges
Message-ID: <20251219120244.00000514@huawei.com>
In-Reply-To: <20251117022311.2443900-24-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
	<20251117022311.2443900-24-yilun.xu@linux.intel.com>
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

On Mon, 17 Nov 2025 10:23:07 +0800
Xu Yilun <yilun.xu@linux.intel.com> wrote:

> Parse the KEYP Key Configuration Units (KCU), to decide the max IDE
> streams supported for each host bridge.
> 
> The KEYP table points to a number of KCU structures that each associates
> with a list of root ports (RP) via segment, bus, and devfn. Sanity check
> the KEYP table, ensure all RPs listed for each KCU are included in one
> host bridge. Then extact the max IDE streams supported to
> pci_host_bridge via pci_ide_set_nr_streams().
> 
> Co-developed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
LGTM
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>



