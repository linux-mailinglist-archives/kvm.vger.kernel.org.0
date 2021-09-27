Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F5D4194D5
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 15:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbhI0NLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 09:11:17 -0400
Received: from mail-sn1anam02on2065.outbound.protection.outlook.com ([40.107.96.65]:6614
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234454AbhI0NLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 09:11:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZg6/kvDB/MfxtCQl2rUom+5j2onIGQ/KzSagTvYrwb17rpfM8M4L31xAG1pr/7KVeEgznKo2kE6AKa1apu0PFC3ycBV2RXm8CJbJUC3F9bM3CN6s1soODNN4mSQmjWECfpRgT54zSBk94CZwARLaP+CghgA9tcoHdnG8dfwvftcD1Z+F5CZbM586Z6f03Xfghf3HvUfCmAMfWSmvC3MzLWnxlmMhIroPh64UIjIJSYzvn5dDNNoXN3QyiczEqM+m7CIX/gHP22W2i6l5Eee4+jJkvkoyM21WBSHKCWG845buDgyUfs/G6wd9LU9CQV9m1/qtZ/ZFXbt0WoUWSCmFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cAQhS2Hw1BCNuFEAO1/nN1colwpSiNUkQ+g1/vlEosE=;
 b=LNvX+cVJACrzNFO+16VPwfI/vENGtQAC1qCZp/Z1+oOb3bbTBsETFmEDgMTM38sYVB4/89IELC6OzKDaPruOduFVu+jTSRV3f1IhoRjsLASlueeWiG2fjQ5XLwqCCWirgYY4o+BAhXWL0tem65kOftaj8SBGpFYVNbf1YPhd6C8d5bJ/2YRHso3gmlAphZ3WAJdlceiKJkH3B1kFygaNZpmsp30VAEmH9LN0YKmLP2O1ab3ZrWxFDxk99uQIKlrGSoQlRXuFr2JWVGbt/vy3UEG9PpkREMYEx/NdK5Pbzj7XiaNp+kMwee8suPi/5zQtFvDu00TwTKVq2eb8G2Vycw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAQhS2Hw1BCNuFEAO1/nN1colwpSiNUkQ+g1/vlEosE=;
 b=Ibpr4PFk+Z9xk4Nq1MhkCTabhU733gLQYKv2RXbUvHh99rjpgVD/c702wFRkHKOJahN928FoUCqIhDlJSi/Tr692Dhw5XfgF+hlcpoMXWkYt8L6cs/Lmv6YCA7Urvg9c2weFJSlptHa+rbTasvRd8nGfonZAHR49fhj3zh61ehYEBB8tjVTLnbVI+6cr5sBoJI7KlcKLLiCPHysKxiNaDUBUBJASgZvREHKG0W8YGrKgyEnVSHxSatCQl3kyr0RDTybD9fd3b7wrsRAUHIjoXyY8dZ1ow2XWPpFaLKHiMTl8DH0oMvc4hETSW3S4jA4Us0zAALxxetRSn0vKvaNs5g==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5539.namprd12.prod.outlook.com (2603:10b6:208:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 13:09:36 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 13:09:36 +0000
Date:   Mon, 27 Sep 2021 10:09:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Message-ID: <20210927130935.GZ964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927115342.GW964074@nvidia.com>
 <BN9PR11MB5433502FEF11940984774F278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433502FEF11940984774F278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:208:32b::9) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0004.namprd03.prod.outlook.com (2603:10b6:208:32b::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 13:09:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mUqNz-006Kx9-DT; Mon, 27 Sep 2021 10:09:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 202543a6-b1f4-4557-9bf7-08d981b80e47
X-MS-TrafficTypeDiagnostic: BL0PR12MB5539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB55399AB101303D9CB4C76F1AC2A79@BL0PR12MB5539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ya54t1PIaPykfxTEZ+wWOjbgqN68PWgbVRhxpL9uKdOu3JOqsD1SJ8fcsaOlZ8/ukuYchrBZxWR9rLA/L2+cqZ8eJRInC7B5T9io9v+mTRu3mbDgG/Md+KW8ny8nXSYQ4UPrxx3Rpp6gxZGSX34yVdq8ZzA2xsWsYbu92vD8AXVzxFPsSYWEXWjYPyQA6txbJYf9+z2TjKm/rypbFHRz2HV3r9H7Ne1QgJtZ9R5RIdydgKCUPtlFBDJboHGJ04mLw/ZNFBJRPDVwXwfln2u0VnHynykIvuye4lWdkz/V5gfkGl2OXsovRJIprCjcu43sEeCFU6oLe+C4Vwpbz/Q/RNfGmhMitC2n/8ce/B/0Hapwfvrbx456iH7amr4NNz1QXuipylYWxopad2N97Bd6WuwOgKrEGsRNa4FRvlIzu0sMW366lDJUh+NEFOtrZKcXNoRsr9XbP80GEUaruvVDk0Us5gffJ2aUiw590F2FwJd/OYH0vzl5vdcygiPUmYCFqOU0ces1zbKQm3bcMKBDPNunzFy4X2yox6f5Qvv8SyGwA8DPHRDdeSKDalov10ZWRsk7EGqyF6YbJw+6JXs/LCEOEyKiNYFGkoUPehmDe5dul8eAjzFCSVyaOdbtH1QlIeZiBWYEPnlhF74/FU8KrNquE6EdIWF08bEI2L6VpqiTMiZlL9aE6+fGSN3diAukvPMFDilv38IQR5AsGICHmUn1v/wxuM33SRE+7MiVp671g8H/0/8dwPbYZCk3H2Bu/gUlpqzTxRP0IMF8sbQNFFxyMYuXtb5hzGCI68V92xYXL1aDb+3TPOawtGdKmqBn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(966005)(66946007)(316002)(107886003)(2616005)(5660300002)(4326008)(2906002)(36756003)(66476007)(1076003)(66556008)(8676002)(508600001)(54906003)(83380400001)(9786002)(9746002)(33656002)(7416002)(8936002)(426003)(6916009)(86362001)(186003)(38100700002)(26005)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UjDfeb01+UqvmaxxeRPCtEv07zQOBThVAwYy2zvpn2kMCPqBVt6XOktEmZy0?=
 =?us-ascii?Q?RxSXTHAfObOWz10WR5lA7Nb6+0MmqdQhGYbgWp684z2BvJepQ5EulWiRh66U?=
 =?us-ascii?Q?RItboFwJf2CxzVlHbsE8bwBjv9HQOG+Q9GkuZVdPuwK5om5AA12T/AkkBkAz?=
 =?us-ascii?Q?AzV6ydJuD/hauHI/91UwJjrJlbw+vni3x3xzu2AUd2SZzxbUIdNLA+LeOF1L?=
 =?us-ascii?Q?U8iBsWjWkShyVMZPlhZnflJSkajIwNJd11WWa5Lb9Jk3GTxUmwwVN4UTFdsZ?=
 =?us-ascii?Q?Qy+boR5as9p1JJOrGrnl2V/UkOTCJ0f3cFdr51QBYo4Voue10KtWouztYUSG?=
 =?us-ascii?Q?Mn5w57fUSf3/uSSVoCDaPiRD872ElJoogxr+1636exMJEtcgdcQkeLEAxJuP?=
 =?us-ascii?Q?Q26GB+MM/vpb1qaiSt6rb3InoOO47ae2citV4fA0BNiDZHrsozl8FBAu+syj?=
 =?us-ascii?Q?6qmyn8EY6/g+lZpDhBqDlS70ND9YspaLCYLvJJEJHzbyggmD30mfvqPfjQQ+?=
 =?us-ascii?Q?NzLGYdYNoUqvkv3MLx5iP3GAPx34bjdqEreAtz/W5j7hSG3HygDFLmcEVpnz?=
 =?us-ascii?Q?gf4ZkYYlKqlSyhUfzkeMA64E/kZ/0TraBvZmJsW9wztyN4ilQ5185RJs1QjV?=
 =?us-ascii?Q?n9CnMKiQDZpNzKRAP8UhvLAOdSEwT9RcZvySrWJtpUcMvySw2gW2GaIBZf54?=
 =?us-ascii?Q?0Z5TruMTcsJOwaxoAsfYUbX6lBTHK4ApJjELQuh2cTsl210kB8eNLZpLWtDD?=
 =?us-ascii?Q?f+C8+rZT+aLKXTxWQFdMYyhdTRH07aKv3jLfTuRw2hjL/VDIHGj1qxEcTyo1?=
 =?us-ascii?Q?y9pAgSNGWPomdrJDouDR5WdIaoCynKGeFeAkbrDBhC30/blU5shEgRogubx7?=
 =?us-ascii?Q?1HOZm/T24pVWrga0eraWCUBP1S3ACiTHvtoluShKXFMBmXqAehE5KdkWNsrU?=
 =?us-ascii?Q?Xz9GeUzpy/LdyjFvEmFMpql3ZU0+BoHfQJwFbKZin3GU2BIVjG6t8S03U7Ns?=
 =?us-ascii?Q?FPlNdJCSqNwByWPWPe64jTbTNlUVDapuEJiQwpZ5iBtfveCGLwGlvFpoMkQa?=
 =?us-ascii?Q?4DEbK4Dmbkr3ALK8Vo4llaQDT7DQlKAAv4TVYq8dsrYjOZNMBHderICBMbqT?=
 =?us-ascii?Q?U5zZhpQiLW80GqAq5x1WPA9JxpwW6zxcebpQGE4RGCn4gOH2I75bB206lFB6?=
 =?us-ascii?Q?gB22//83kU3Fy7kMWDJKkLHNE5OkHTODv7rpBITYLXADdOw49LAqoUvTHE2l?=
 =?us-ascii?Q?yae8Tv7VkXR1cwpBfZsAq7bw51gxB+Lctlm7eUvJxs4Z+sajtp4oi2HJuo6+?=
 =?us-ascii?Q?PBcSpPQ57opRcSmxMO/3ihQO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 202543a6-b1f4-4557-9bf7-08d981b80e47
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 13:09:36.5833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eDmdSqHZv/2vDB69GOIa4WXkznhzLsFk5yQG6fCnJwZA1rSFT8g4nFKp7BkAE52s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5539
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 01:00:08PM +0000, Tian, Kevin wrote:

> > I think for such a narrow usage you should not change the struct
> > device_driver. Just have pci_stub call a function to flip back to user
> > mode.
> 
> Here we want to ensure that kernel dma should be blocked
> if the group is already marked for user-dma. If we just blindly
> do it for any driver at this point (as you commented earlier):
> 
> +       ret = iommu_set_kernel_ownership(dev);
> +       if (ret)
> +               return ret;
> 
> how would pci-stub reach its function to indicate that it doesn't 
> do dma and flip back?

> Do you envision a simpler policy that no driver can be bound
> to the group if it's already set for user-dma? what about vfio-pci
> itself?

Yes.. I'm not sure there is a good use case to allow the stub drivers
to load/unload while a VFIO is running. At least, not a strong enough
one to justify a global change to the driver core..

> > > +static int iommu_dev_viable(struct device *dev, void *data)
> > > +{
> > > +	enum dma_hint hint = *data;
> > > +	struct device_driver *drv = READ_ONCE(dev->driver);
> > 
> > Especially since this isn't locked properly or safe.
> 
> I have the same worry when copying from vfio. Not sure how
> vfio gets safe with this approach...

Fixing the locking in vfio_dev_viable is part of deleting the unbound
list. Once it properly uses the device_lock and doesn't race with the
driver core like this things are much better. Don't copy this stuff
into the iommu core without fixing it.

https://github.com/jgunthorpe/linux/commit/fa6abb318ccca114da12c0b5b123c99131ace926
https://github.com/jgunthorpe/linux/commit/45980bd90b023d1eea56df70d1c395bdf4cc7cf1

I can't remember if the above is contingent on some of the mdev
cleanups or not.. Have to get back to it.

Jason
