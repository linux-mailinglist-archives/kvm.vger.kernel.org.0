Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BB546BC42
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 14:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236929AbhLGNUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 08:20:02 -0500
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:24131
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230153AbhLGNUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 08:20:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNPXSS4g61errMNtc1Yv/QI9LtqKPPP0xNsB0i0an5SUs2O82q7W4b14wYknGZIGcl4Rs8ckS7x91S8ioaAHvYGrASV/9dW9sTbVdNxcer20IB8SG6fK6zNcxepQEX3L++t92xk1QRC/prUsZWaxwg0psWgT+x27Q+dNhf578o1EYypHeP5eYkKdhqCiYLSJBRMlhZ681c1Ys8bZ9miZnCVN+Bj83H5M5NbT/ca91w8vku41hXuKFZv/Y8+UyRB+s3f3bphcdKpxLQb4ougCbeFUHxzTWofvLJXpVZ2XK45HNrzQPcF+8Ks7UcPvY1Cr7+SW/wB6FRkGAroV2Fv6vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zmdgNnx9Yh293BnIk6nuv8SnDHr4Cb6nAWcq9L1D2og=;
 b=AGM/mZEapW07/Su9+4JymIxqbAdZG5GwxwkRMXHrpcv9HEHFgzIuuYPf3OCSAMFkIrnevJlHoKf+rD7ZSrmmLzvrnwy6ky5ujbF0N3Bi+iHnBk29//Rhnjcw1odDlhjH62IjO18T/PG45Dfd/wW6pc/JST/iE7sVJAyjM57QaVh6HR6TLXb5/GRy9FbZ6TI/yyRQHiR60ZVAJF8MJyOSaiPtU8o43BkWovXbVfHdhMSIrja8eiju763yk6vyU/GR4SWVsS9rXo93RfhP7dgip0bIUkh2Ntj/3ET5ZlNhHopqbnuSeYovPHH6IRqna7ULEuUw2gO7ssdtIHPdWjtm6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmdgNnx9Yh293BnIk6nuv8SnDHr4Cb6nAWcq9L1D2og=;
 b=lRg74KxsqcZjmjSq62oRh4gqbly/xBTddGHYOSAcRnEQgWFte0sxyBCTBSQ7N9TvPI48joDOSjX8np1Nr+kIOjRrER09jxEGi53NUT66441co6fR6eWHxNjyMlIoMktXqEud+6gZ3IAgEVZh1zKSx1bGXJfQoi8glrStu3VtjC7drBMhNHZXyOG8rvB3HHhnycQaiGndEM4Pis48s97e5VTGdlWFtLURiMisS8DQLpTPcKg8bRtO7iKtV81mgdjF+VMEDTreO1R5OOFaj8ZuDgU+JB+IhsQe2gl7A2BEGpMsLkj0d8jOXgHJhGzHtmvB3SZiBB8KKhtE3Yf5uCaYWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5110.namprd12.prod.outlook.com (2603:10b6:208:312::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19; Tue, 7 Dec
 2021 13:16:28 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 13:16:28 +0000
Date:   Tue, 7 Dec 2021 09:16:27 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/18] driver core: platform: Add driver dma ownership
 management
Message-ID: <20211207131627.GA6385@nvidia.com>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-5-baolu.lu@linux.intel.com>
 <Ya4f662Af+8kE2F/@infradead.org>
 <20211206150647.GE4670@nvidia.com>
 <56a63776-48ca-0d6e-c25c-016dc016e0d5@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56a63776-48ca-0d6e-c25c-016dc016e0d5@linux.intel.com>
X-ClientProxiedBy: BL1PR13CA0083.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::28) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0083.namprd13.prod.outlook.com (2603:10b6:208:2b8::28) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 7 Dec 2021 13:16:28 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1muaKZ-0002Kd-An; Tue, 07 Dec 2021 09:16:27 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc05e192-cd03-4851-6cba-08d9b983c715
X-MS-TrafficTypeDiagnostic: BL1PR12MB5110:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5110595A9D5263DB012CD184C26E9@BL1PR12MB5110.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aHVEYRemFZTxpinvPoWvJ8YCHcohx9u9fX8EnoFwnT3ynloehqzGvM4/E8el4XgWMC+rW8seIJOODTcqRTW1iMXTFJDMf2XhDNZGqMI/ir4IvPSIRuFbDp+EmYLDXYiluRrvEPGiBVcnxVdbHMfh5t0N6QkWlFfBEv1FxwzWvTfDFmL+ROvTvc1WRfZm7RquJzQLZj67eh9EaTz6ryuUu+cwgOrqbnWCC8/K1vj1Q5Ww7PNOEvaqpPiGINHfAcN6wE8HwAqMLTEDmqAuA/54BUkmpLkM3C2HiJMPIFrwT0W5EZs7eCUxl0sKA1DdvPHv+jiS+PQG+WzrkvME2HrHSezTp6I2FnVA1KuXwAd9hTBGTlO7A/V65G4l0gUT4eED36Zz67A2IMSXvB35tzly7wRIyxRQyONB3IQrBXon+OFTSPprVgmedGSAXxWmr+BJqTyBVID+L5PTDnByBfWNB8r7vKdlSR5CJ1naFva9oQq3sCE7h/PsLQ0j6zNHDtUXGDk2r8uiJhSe6ULu4efGna8ydlK7XOgGfBIzmhuTmFE6ITDQztD1rF4rtKkTUQJBgt0iShvW4P+Z8jJdAFVNy8jZwD8iBeyQmxrFS+vYAJ0+Ge+zoDxx+uVy/vzZijzCs2NEuHOH45EbYXRlIQEcgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(86362001)(36756003)(4326008)(8936002)(2906002)(316002)(8676002)(1076003)(7416002)(2616005)(54906003)(33656002)(9786002)(6916009)(5660300002)(9746002)(426003)(66476007)(66946007)(66556008)(53546011)(186003)(508600001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iGhceYS88Vb3jgEPPM/SwMbuNszqofkXKi03h7RdVRd3SWztNliODl7Fflz1?=
 =?us-ascii?Q?Sjrd8NE2CDOeei7xtwUElmRXnn7RMAzJ7zAt5TDaxsVGeIySWKkSsGR5Puab?=
 =?us-ascii?Q?DhFaAgPpsvz9LeXid6nA7hHpB7YYfGSp+eZN2GQ/AU55MCNxWV259OJES5m6?=
 =?us-ascii?Q?2l5mifO5Pd5P12yT4q0WTtzyZyPIdV2cHE4RCVqJ2HEo684A55QW+IYNk+JP?=
 =?us-ascii?Q?xbXaoR8VTC3i+u1ANmU/olSlAFpiTxXB3QrwtKGhMm3a96jGTFCVtKvqKOCQ?=
 =?us-ascii?Q?+ye1deb12vxlXJySizjqbYfGeL762ax9Vl3cMCSoRjgLhWZ1gnchQxNkjI4i?=
 =?us-ascii?Q?ca/tWdUQ4JNBx0Y6MSfMcyFWwrCtVfw0YlhDOYPI9Rqb6fryVm8384VVeRco?=
 =?us-ascii?Q?SZ7+slYGkLegWdieZb3PzITJZXxlTGcE1jUZbirwFY52R2ESLoAUTy3E7BsP?=
 =?us-ascii?Q?d0P7ZfYfm5n5yLjQEuwC0yyjBW5rndUxMzFqgPYGvxbCf0sDu6cIEoZWFox9?=
 =?us-ascii?Q?QGZA8dEJV/AV9RgJUkH2utz5cvgsrURKfuhEpi6A8MH0TtPlehm69PJbvWNq?=
 =?us-ascii?Q?m751rehpTXUdY72Ftqe+m1E30UIQjOlj60ZiI/jmknRQMibpNf34pVQ9ENSQ?=
 =?us-ascii?Q?c0/bg5D0nWNZJKQb+c48CRYWz+DE5QVxr9/Z/2xI60ixRAt5v5Nw/Bz6YgLK?=
 =?us-ascii?Q?BSdlwtG2P0/Bt68ng0+GVSLpAz648vTJ6PUUnMY1nnyoOYiYOBz1YmE0/hhi?=
 =?us-ascii?Q?ZfEmZfxpEYquAAo0olt4vSDyCtu1024ihzpTi+cSdaWiGjgLK5VpSx2yI6o8?=
 =?us-ascii?Q?yubHa3daA8qGyX9+tfgVGiluPcyosNVnTTaXr5fzsaf3SERndltdQPZFII+j?=
 =?us-ascii?Q?rKB9wShLINEzqz+IUjVPtwR1brXj47U7mdlOHNNoUur7odHYtX48ND00bb6Q?=
 =?us-ascii?Q?CB4KQreLwUwRcaP2yM3Kg9SXDJ+muBuiCbGabZBvOQc5EuBk1jf2Vmy7xSuY?=
 =?us-ascii?Q?LDxNV3QichF0nhqFlA+VN+DqGmUKoY2K/FvU8o3UEQY9GHZgK7+e/Lzx4U49?=
 =?us-ascii?Q?IiXgA6yWUNNoXKjWbn+Jp6i8dsSd9YJ3MlnXAVaYYDtRJLp4msDmjW3X9nYp?=
 =?us-ascii?Q?ybACU1tEQgvfBiFh3mBzZcmRryeriNicIxUeiw5GMgUyHqrjEOiVaoaqxcFv?=
 =?us-ascii?Q?uzWbp+mgGoWzwNjsYKgzAaHWx/0VcAW06mPqUwrwxVpfXIv83+gN9cQrZzKe?=
 =?us-ascii?Q?JTyW7o+A06NmVkGI11qOe1MkkJUV/jOjunYIyO9ymFBOEYXdNr0sbQ8ijPyb?=
 =?us-ascii?Q?+sFKW2MNf8dVIvAVhekLUTefCqf6ryAHF0Y9JEqYIAlqfmaMeHHOfvmHp6ND?=
 =?us-ascii?Q?zPpHvWtkkqsntk1V5oR7kSH+nulHNqU6Ckbl5NU7AbSOuXaG37CKWHo5jip8?=
 =?us-ascii?Q?+ZFwkD+kqZM8IcTjFeS5CWXoLn3hXsaxMuS0it5WoV74JV/PPaAR5ULtDZGS?=
 =?us-ascii?Q?ZyjFhQJU9mqYg8npx7lyd0qEwuK8TlpO9CLSqB63l8c9y1p7o0fiOcBlPc5n?=
 =?us-ascii?Q?LXswj35U3HYX4mEV5gg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc05e192-cd03-4851-6cba-08d9b983c715
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 13:16:28.3290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JNfkygqzK5OlthFeNlCPeu0bu2f57OXCDomP5a53m4AS8FRzzV/DRILUDB8SFbgm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07, 2021 at 10:57:25AM +0800, Lu Baolu wrote:
> On 12/6/21 11:06 PM, Jason Gunthorpe wrote:
> > On Mon, Dec 06, 2021 at 06:36:27AM -0800, Christoph Hellwig wrote:
> > > I really hate the amount of boilerplate code that having this in each
> > > bus type causes.
> > +1
> > 
> > I liked the first version of this series better with the code near
> > really_probe().
> > 
> > Can we go back to that with some device_configure_dma() wrapper
> > condtionally called by really_probe as we discussed?
> > 
> 
> Are you talking about below change?
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 68ea1f949daa..368f9e530515 100644
> +++ b/drivers/base/dd.c
> @@ -577,7 +577,13 @@ static int really_probe(struct device *dev, struct
> device_driver *drv)
>  	if (dev->bus->dma_configure) {
>  		ret = dev->bus->dma_configure(dev);
>  		if (ret)
> -			goto probe_failed;
> +			goto pinctrl_bind_failed;
> +
> +		if (!drv->no_kernel_dma) {
> +			ret = iommu_device_set_dma_owner(dev, DMA_OWNER_DMA_API, NULL);
> +			if (ret)
> +				goto pinctrl_bind_failed;
> +                }
>  	}

Yes, the suggestion was to put everything that 'if' inside a function
and then of course a matching undo function.

Jason
