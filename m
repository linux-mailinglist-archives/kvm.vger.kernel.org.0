Return-Path: <kvm+bounces-61776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20FAEC29C42
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 02:14:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 816FD188F460
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 01:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6167426ED54;
	Mon,  3 Nov 2025 01:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Cqreozyx"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFBB26B08F;
	Mon,  3 Nov 2025 01:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762132486; cv=none; b=B46PDULcFccTIT+Ngh2CDMkGnYirZhUKA62W0GzoAi3W1fTjqKTKo16mroAvHbdJZuk4SXSyiGb+VoP0oO9H7TiGlLylQ3PvITJoY09TjNsYgxSXhoJRPFlbEeAy0V9K/acx7ny0sVJ9Cobid8JanLVlJNFsuECVkRlagiShAnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762132486; c=relaxed/simple;
	bh=ndMu32m3Z/qhkCKw12MP1FHuN3cdJlkhYoX6/U5RA68=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ioBjwKiQqZlzltRM0Gg/yLlvb44gNO8d+sLDoJF5opvjobjpcNVAxDIkObc8Y2BTAdiDUfvGr2+RKLOuX3GDxaUo7e8oWjOYY1rzk4GZ1pW4Y2/KK2UDcHnIGRaqEHJwxWrZs+F+9kDCLHCCBxh2wt38KuaT+xxEe3PN1VAIM3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Cqreozyx; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=gUWnt8SGrYXYkKR4QzmHhxMLw3wr5brhnEm/g+EnR24=;
	b=CqreozyxUltt+PuSdBf7tYfKEe3p2rlHnntUP1IWynNbf8KgkmHBwwXM7IgqWTj4Gc/+Jyzxb
	ZoAJ8N7BBx3/joSOmm8ndFTswPqH73nzhfjaTO3jc8BZwVWNqkavknXB7ME7uf7+Tj3FAlQ8SOr
	hseaaYPcpkV4xUqyu5lJPls=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4d0D9916W3zLlVC;
	Mon,  3 Nov 2025 09:13:01 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 9773A1A0188;
	Mon,  3 Nov 2025 09:14:34 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 3 Nov 2025 09:14:34 +0800
Subject: Re: [PATCH v2 2/2] hisi_acc_vfio_pci: Add .match_token_uuid callback
 in hisi_acc_vfio_pci_migrn_ops
To: Raghavendra Rao Ananta <rananta@google.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Alex Williamson <alex@shazbot.org>, Alex Williamson
	<alex.williamson@redhat.com>, David Matlack <dmatlack@google.com>
CC: Josh Hilke <jrhilke@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20251031170603.2260022-1-rananta@google.com>
 <20251031170603.2260022-3-rananta@google.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <3acabba9-3ac0-6740-8f0b-457ce81748d6@huawei.com>
Date: Mon, 3 Nov 2025 09:14:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251031170603.2260022-3-rananta@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/11/1 1:06, Raghavendra Rao Ananta wrote:
> The commit, <86624ba3b522> ("vfio/pci: Do vf_token checks for
> VFIO_DEVICE_BIND_IOMMUFD") accidentally ignored including the
> .match_token_uuid callback in the hisi_acc_vfio_pci_migrn_ops struct.
> Introduce the missed callback here.
> 
> Fixes: 86624ba3b522 ("vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD")
> Cc: stable@vger.kernel.org
> Suggested-by: Longfang Liu <liulongfang@huawei.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index fde33f54e99ec..d07093d7cc3f5 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1564,6 +1564,7 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
>  	.mmap = hisi_acc_vfio_pci_mmap,
>  	.request = vfio_pci_core_request,
>  	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>  	.bind_iommufd = vfio_iommufd_physical_bind,
>  	.unbind_iommufd = vfio_iommufd_physical_unbind,
>  	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> 
Reviewed-by: Longfang Liu <liulongfang@huawei.com>

Thanks.
Longfang.

