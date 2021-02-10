Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F8C317469
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhBJXa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:30:58 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14110 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbhBJXau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:30:50 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60246c800000>; Wed, 10 Feb 2021 15:30:08 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 23:30:03 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 10 Feb 2021 23:30:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjEQDw+pMSKdn8N0TRW6vd2MpTO2nECv3/+cvqB7Uf4zXeaA/EXfSkZrcNdWPHvlxC4dfR54jK/B2NeYm0BqpIFxwn0TiwU7SbMAE/kWJhzKRUYALuLbyXlo5GVBWeZguoz6qe876HvyaG7NPkYJKeViu/TfvmOUpMSkt1P5ANbL4icxzbtyfMduf5F+C+a7LFeF60r8Q3SknZXrQcZYM/PO3/KZbKt+UTrhAdWVSzzu+AV90L/rr1Jg+Sj+mXiUaAFwRVUhE4GW19HM1P6pFnkvtpHWhk7L3hF7TDCdPUBea4acR0EszN+mJcPFWAaQoENMA7pv9ctfy3gVkWIDpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9U1C0iQXBOumWCpl0gnnohAV96/xhugwerL2nuh/Ano=;
 b=MfEkDQQqKZfxrnY4sgpDv39yZqrOaqzBCunC9GT1NNqteIsNrme7e6s55x0onJLDS1Ikk0Vo7Otu9FPFA+CXhqT+CBHYbkK3TcaW0sDyHTuVJ/oNx7AxHoj65U3Ynw1MUkFMNquWUvipyYUIo1nBjHay0vgVoMsZZthg2yCBfQtqPpzQ5lCM2DSrhj7xcz9fM+1uiN64d2hswoTF5aVTAjyPUDBz6xFhcWEXIFdEXj4HL7bNGrEpUfKMtm5uVcAh2tir9AtG1zW2x39xntw7lpyqPBz+JBo1xImTTaF3jPs586kt0BMtOkN134p+Z3YmOly7e10nSAekPwD+wj+PGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0105.namprd12.prod.outlook.com (2603:10b6:4:54::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Wed, 10 Feb
 2021 23:30:02 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 23:30:02 +0000
Date:   Wed, 10 Feb 2021 19:30:00 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
CC:     <alex.williamson@redhat.com>, <kwankhede@nvidia.com>,
        <tglx@linutronix.de>, <vkoul@kernel.org>, <megha.dey@intel.com>,
        <jacob.jun.pan@intel.com>, <ashok.raj@intel.com>,
        <yi.l.liu@intel.com>, <baolu.lu@intel.com>, <kevin.tian@intel.com>,
        <sanjay.k.kumar@intel.com>, <tony.luck@intel.com>,
        <dan.j.williams@intel.com>, <eric.auger@redhat.com>,
        <parav@mellanox.com>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <pbonzini@redhat.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 02/14] dmaengine: idxd: add IMS detection in base
 driver
Message-ID: <20210210233000.GH4247@nvidia.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255838583.339900.1371114106574605023.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <161255838583.339900.1371114106574605023.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: MN2PR20CA0012.namprd20.prod.outlook.com
 (2603:10b6:208:e8::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR20CA0012.namprd20.prod.outlook.com (2603:10b6:208:e8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 23:30:01 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l9yvo-006He6-Lo; Wed, 10 Feb 2021 19:30:00 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612999808; bh=9U1C0iQXBOumWCpl0gnnohAV96/xhugwerL2nuh/Ano=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=gsbswl776hvr/ih53+ggAPu8yqQ0uJwu24vSCgKenoT8MqoHX03TKs9Z7bxAj9EeA
         MVpIDLtW05holQcavcGZfmoLx25nIEZos0oObtbyoyJAaR4RlNNqf1H3vjEB7EblY8
         7GqJGA1VbubmG9jQ+QlJ9jYyZR68Ijp6gZXqpzpEfsKfZNmAob1cNZgjoPP0QHgStH
         5MQFo0Nqs1W3UzI25b+7RfYciQ/IlmynnDCKZToB+HybXgni4MVtizyRxloxy1Bp7B
         4jyl4ZWj50Ie8PsQEwW01Gm7vRP1BbcEXmOIMUJ0YcssNpPrQr2FKJa3ePObBRFI6/
         4Qf5Mca23b8Rg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 01:53:05PM -0700, Dave Jiang wrote:

> diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
> index 21c1e23cdf23..ab5c76e1226b 100644
> +++ b/drivers/dma/idxd/sysfs.c
> @@ -1444,6 +1444,14 @@ static ssize_t numa_node_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(numa_node);
>  
> +static ssize_t ims_size_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct idxd_device *idxd = container_of(dev, struct idxd_device, conf_dev);
> +
> +	return sprintf(buf, "%u\n", idxd->ims_size);
> +}

use sysfs_emit for all new sysfs functions please

Jason
