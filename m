Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E442E3174E4
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 01:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbhBKABR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 19:01:17 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17277 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbhBKABO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 19:01:14 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602473a20000>; Wed, 10 Feb 2021 16:00:34 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 11 Feb
 2021 00:00:31 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.59) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 11 Feb 2021 00:00:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkD6/JzLU6+FsX5mltEZXGTG4Ln00Wvp5ykcu61juOU75HKMUIYKBQyqYetCH1243LF3ofzgQMCwvqydDFZxzkZzqGaU+HPr2Sk3zAWXT2F3cP2QrdPFxba8AIf6r1qAL20YCTQiAA+57c3cBt50oXOyloOUfg8Ix0LtzgXWTWvmKyvTi/lgfLF05+AeNnr3td86TELYMUdeP0ZVsM4CwBQezQODWGWUn/tTBHp0lDc0iWjCKp1jbDLvgnOluuzmifymmNwAM9VlniTv90dyLDj6+yoZZ1C5/idCxewpOEf1kWd5I5oT7TfaSgldBALuOUmUNjVWvANE8yMiWvJH/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fW0dpCfgf+feF+Hanwlm08Xngky9go34WL1qdZ2fT5Y=;
 b=BKt+KrFxa6VuEYJLgAoE1vIi8lzGuSvfvJBUqNHGi4447RVZNkvDP5jZZnKOBGeIYNpS1H2Gg3AiZ2fJL5VCL2bQ9dsPoTDKhfL/A+04ssVTR72sJC9kOnhJbRnQuL5IW64pgtjHy7H7MovpxmNfxAqGC2YL0JbUcElW5gt+V75SKqQmGNp8yoqHDC3U72sU7vvoSr8ooaW00SYcRBUxOE+4gjO4QlNDX8ut9L7WK5k0drZ+GE7BNAH6/TGKpCXZmSGmiGgOS0fL3BgwxIJ1qSzHwjKZjQSnhHLYpoyb9x5bwnph29ZYoQFLxs62F5hNizZvJp3uBN/i4oepOpohnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3210.namprd12.prod.outlook.com (2603:10b6:5:185::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Thu, 11 Feb
 2021 00:00:30 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.027; Thu, 11 Feb 2021
 00:00:30 +0000
Date:   Wed, 10 Feb 2021 20:00:28 -0400
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
Subject: Re: [PATCH v5 07/14] vfio/mdev: idxd: add 1dwq-v1 mdev type
Message-ID: <20210211000028.GK4247@nvidia.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255841792.339900.13314425685185083794.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <161255841792.339900.13314425685185083794.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: BL0PR0102CA0042.prod.exchangelabs.com
 (2603:10b6:208:25::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR0102CA0042.prod.exchangelabs.com (2603:10b6:208:25::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 00:00:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l9zPI-006IFO-BP; Wed, 10 Feb 2021 20:00:28 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613001634; bh=fW0dpCfgf+feF+Hanwlm08Xngky9go34WL1qdZ2fT5Y=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=Hu33ZMC0Qq3PtGiAAnkqMebWtfQZWi8ACiI2TeU6OQjPIO53OG0lp2TsKyBb09CHw
         BSAvrdQvq8XINemzqKovCyw0ri/Yom63D5XIhOjJ27x2snguFiLWB0DI9TjResWEDp
         VUaDSsf8KcXOnVY8BybTAolePD2ExFgJi2FEaVQ5LBxchQ1hrujRZHNCZpN562N0Pl
         gRl71ISoo92H+fo1DuWKCK63LMbB5PQMuwWx7T4YYLU6KCSX8xTMTY14cIbQTIIdzj
         xfI1hdw8Shzt8w4P4QNXEny8KHZU3uBkmyVJtmMBcIvKh0gnEO5wyhFWoM9FGBADrm
         oQA27UltwhcQA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 01:53:37PM -0700, Dave Jiang wrote:

> -static const struct mdev_parent_ops idxd_vdcm_ops = {
> +static ssize_t name_show(struct kobject *kobj, struct device *dev, char *buf)
> +{
> +	struct vdcm_idxd_type *type;
> +
> +	type = idxd_vdcm_find_vidxd_type(dev, kobject_name(kobj));
> +
> +	if (type)
> +		return sprintf(buf, "%s\n", type->name);
> +
> +	return -EINVAL;

Success oriented flow

Jason
