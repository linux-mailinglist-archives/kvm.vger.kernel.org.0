Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FC533D062
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 10:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbhCPJRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 05:17:07 -0400
Received: from mail-eopbgr70054.outbound.protection.outlook.com ([40.107.7.54]:44039
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231599AbhCPJRE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 05:17:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHX1uQU0dQ9Aa76mLhxbcgXdF3RP3qNCC76yDaFQTc0hM3C6eaDnAGkwJDn+ymMwyh7VCI7Jf0FNK/9CxvXIZoF0GvTrNCb3LAHwo156hK7RNabAUbl3cfmwBgGGnTQUjkQ2aDoz8TiuZRugmobTkTlpPIYCT8Aw1FCFQu5HsBP+ByuSetyNwqCtFTfgKx1IJ0ohcWeK2zDCxHk6XK9FV8JOFY4o5AHvx/hVEDZ7K98vaR6ztOtwyFjtmUXkC4JtyFtEJ6ySAmc7KywJCx5DaZO6fzTp0NEkvf61F6Fl7jS6pxsHU7cHzOx9NGT+42jdRXesN4p6seDuWyjgsHkBsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAh1MHA7DpCam/kbdYTH3BecSqS1peA2nQ1Jly/jENM=;
 b=Tq+HJSzJoUlwSbT0gsHiqto6vM2hQonY3QBQfOuxcAnQBTKIDUtFKVu3sVODCj8AAQJDvobYmV/H6BMqa5aCrjwFz0Uyl0iMHb32NiZQdAwGR0lrC/ffC6tuEpySnl8R6ZY1G8wT/keFjl7nb0YpNBnv5ovXCDavsfLaVhcXnWujFCvl71As0HtZlFk+yKeTUNGGq86wDQ+9BLgI3xJ79Q+55zscQmRUUPq0bQriyJmChQg/euAkZRTsW1ej7+wAeA0YkMbdZ7q7M6gpV3NUvPnWzGSdcFnFDvZaNJ2TY0z92/Kz3dFiIpg0+EOjZv91bjDtpYrygCui9tkwXel4Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAh1MHA7DpCam/kbdYTH3BecSqS1peA2nQ1Jly/jENM=;
 b=V39DFR3Ovq5Njyl1BYrFahvRDxxB2LkI4+EcfyIIFb3hu8w9g6R/dxy6ED0I0K9qK3e/QYd/LMqEDILj1ccwGUzUPiVHMKepMh34LlmY4+ES2Kv6HlHqHQn94ZhZnPUU6g52sEDqiXcjap4HMrn5gq3lDSd1Q6A7sdIuVV1ckI8=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB3503.eurprd04.prod.outlook.com (2603:10a6:803:d::26)
 by VI1PR04MB6160.eurprd04.prod.outlook.com (2603:10a6:803:fd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 09:16:57 +0000
Received: from VI1PR0402MB3503.eurprd04.prod.outlook.com
 ([fe80::f81c:a9ad:61af:1e39]) by VI1PR0402MB3503.eurprd04.prod.outlook.com
 ([fe80::f81c:a9ad:61af:1e39%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 09:16:57 +0000
Message-ID: <1dfe9554-d255-15a4-7b4f-642a592103cc@oss.nxp.com>
Date:   Tue, 16 Mar 2021 11:16:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [PATCH v2 05/14] vfio/fsl-mc: Re-order vfio_fsl_mc_probe()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <5-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
In-Reply-To: <5-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.26.44.171]
X-ClientProxiedBy: AM0PR02CA0207.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::14) To VI1PR0402MB3503.eurprd04.prod.outlook.com
 (2603:10a6:803:d::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.127] (188.26.44.171) by AM0PR02CA0207.eurprd02.prod.outlook.com (2603:10a6:20b:28f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 09:16:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0c65c46c-0387-4731-9eb5-08d8e85c3ef4
X-MS-TrafficTypeDiagnostic: VI1PR04MB6160:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6160093E8B18A8E72871F972BE6B9@VI1PR04MB6160.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Omx5SLViCx6eR/69FNuteARohiHkHNEseFF8Vm5lP7XXFI3aAtbYRZlU6hZHk0WzyoNR1o95vtju4/U8QuARKVfc90qoe23s8UqNQGbLD6d2he72jnOWxajZSQ9WDIpkMUl2yvcHry2krmpbavJESEIzsTGo1+aaXHHnBwTuqu+HPHv1PiCw8Givngmln/IFodFjSm4VzM0P6iI2qn9LyT+CGDs1MQawDaqOD6252GHFiVQGxJaTXFgIk4Lb8BjiwMj2QDdq4Ka/ewur8Gud1jkK+6Wda+aWSSJ5PcxIH2qLkiDBBv7wkmYfsJzZSQ4vYsFiyv0ZBhAXJUxIdF/QWMVfQdqaAjjQ3JubUs+oBHnlzbPmNB0YThgVOiA6CyF1yxWhPY5nJ25BLCgADkOd4JuTEeb/V+igxrzd/jIhg9Dg7KgmqWZrAEWuozIAzdlg8wnWIs1Ecyz3rk7fM+CIuggaAFM2utqK1/wssGGhySGXy7bzDMgdLIBg1DBfLsDTo8wGWmQFwGVGFaqm9/iz5jboim8rhLIrStLmwQmTbBQmdk4Nt7p7o+OJsoyJzor4mXrueNdeGwPILHdm6hCHyGe7Dgvt12oP+33gLOyl9N325GFW+LPnlKkp+DgrvDk+xPyMsGQgmFuzjAoUN+uhj78+LNFaD9WAJ+9X1J7OG0I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3503.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(7416002)(66946007)(110136005)(66556008)(66476007)(16576012)(86362001)(16526019)(8676002)(956004)(2906002)(31696002)(186003)(2616005)(478600001)(6666004)(31686004)(83380400001)(6486002)(8936002)(53546011)(4326008)(54906003)(52116002)(5660300002)(316002)(26005)(169823001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZTBidUYza3FSOHFIK1hDaWcxYlVpVWpTanRxcmN4c2N0WWp0T3dZTDVvSDkv?=
 =?utf-8?B?eVdrdjJVMWNpVFdGR2d6VTh2QStXeVpYTzd1Tit0WENadExRUlVPUU5xc3hU?=
 =?utf-8?B?OFdNNkNtK1hid1ZsZm9MaVd6bGpCdmt0SHdadnV1Q0Z3U2NZWkFTMWYyNkE5?=
 =?utf-8?B?UmNQNWlhNUZRT2Y0UG80dXJVQ1kvUXRNRUt2Rk9lbW9OU1NiaFhqQ1BNU1JM?=
 =?utf-8?B?azZiUEV2TkhIREVLM2gvSldoZ1Z4VDBJMjdWaW8rNTZ4VUJSWG8xNDlwb0o1?=
 =?utf-8?B?WTJMcEJYSGZOTlRkMCtQSmtUN0MwT2l4WUlPLy80Tms1Z1ZXcUpMK0dxby90?=
 =?utf-8?B?Y0lwdjVNUEprQ3k0aUdFdzhFa0NHMjF2NDc0eW11Y3BDbHBlMENqK2xrT0Fi?=
 =?utf-8?B?bXpKR2ljcVNwTHAxWEJybnJRbWFWcGlTTUdwRUdOT3oyU1JsYmV6ZjZteG4w?=
 =?utf-8?B?bExMMmNkdy93alAydStCT1hZTkE3ajF1UHE4UnZvM2lVSUVVL1ArMDRranZ6?=
 =?utf-8?B?OE95VkY0NjRDeUVEKzRWcWtpeSt0NkJqYXRVaElqK3pRWGRnY3hSTWlPWGtj?=
 =?utf-8?B?VFN5TXlUVGU2NklFOXNJWTYza1NiZmhuamZ2NlFzeW16cHduNHlrRmZlUWJu?=
 =?utf-8?B?N0tzQWlhQnV3Wlppa0ZiUXlJNGtJdnRPQTZHN2E2MURHNkljV1puMmc5VzB4?=
 =?utf-8?B?dzUvRWNCVkR5N2FlTWd2WkhiRUxEMFFEQ1k1MXBvRTdCM0ZqS3lOT3FzTnNu?=
 =?utf-8?B?Y1lpTzVFVmNCTEo5QnJ4NU84aTVXbUVraWZBVmVRZllDY2pNaUx5Y2lzcW94?=
 =?utf-8?B?T3hucmpyaGIyVG93VTdjUXNqU1h1cmFXdml3VThBRVRLemoxUHMzRUQ5R0I0?=
 =?utf-8?B?ZzMyQ09PNUNtOEtKRE02WW1BOXNlMTFpV0I4Rm1hdmVxZS9FeTZEN1h2UDBO?=
 =?utf-8?B?M2R6aG91cUUxOEpUaE5pSTNDc0dhbTZSNmNTRmhCb1NKUWkySlFHTGsvdjMy?=
 =?utf-8?B?MjdPS1B3QnlkR0dpSm5lRUZtbkpDYVlLTnBuQTB0eEFpS213TFR0SmF3VGJJ?=
 =?utf-8?B?L2RlcnBPZjNJRmdBbGFuRURFdlkxeFA1MkcxaDBnay9VdVQ3QWJGRE5SRDdC?=
 =?utf-8?B?NVpNR3hGTU5VUzJkNmd2UmV6Sm53bG1sZGV4OWFsU0tjRG81eEUyMGJjcG1D?=
 =?utf-8?B?M1J5M3E5TStOenJWOVVxbTh1VU10eXk4eGxEKzFqVFkzYTExdEV0ZEk2R2pp?=
 =?utf-8?B?K1JKckg2dFd0RFFxN2NVcGR0cHAxbVg1Mk82azJTRmVORTNKV0p4eFNLaFZM?=
 =?utf-8?B?cXZWOGs1RkdqMGlXcERuazZnUzNSVmhlYkZWWFp1dk5QNVVXVytWeGNDcU85?=
 =?utf-8?B?MFJOeHBhV3oxUVZ3MlRRTHJaNm9RaWJ3ZExWenJ6T0s4T2l0cU03emdFMTFM?=
 =?utf-8?B?ZGIzTjBrenM1NU00TWFPKzNBNEpuMUNNRk5CTlZPdUQvTjd1K09kTldLeisr?=
 =?utf-8?B?T0RyRllSUjFUWm95blRnWkhzNmFZNUFha0xiaGI2QTBmTURPNWFBTUo5UzhQ?=
 =?utf-8?B?VVRmZUJsWTFhTXFmekpxRnhGdzQ0MDZDQ05lNG9ESFFXRmFicmdqR3NoYURD?=
 =?utf-8?B?YkNIcm9ZT3FtS29nQW1zRnRnN2w5ZVh2ZE82T2dWWXJWWnNHSmx1cjVqRmpo?=
 =?utf-8?B?cVd1NG10d0dGK3N0ajlYWTRmdWduK1lydlQ4WEhQVjBybXkwRTR6SzNTSmlt?=
 =?utf-8?Q?GQMZqLvCZALyAX6517i9MbGmCqV+FoZcoIMbcs+?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c65c46c-0387-4731-9eb5-08d8e85c3ef4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3503.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 09:16:57.3014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O3GIgj8D3uKRUPI5tKpkx+yne/rfOLcMgeaHqvUQEiChtZJXe7ELgQZKWq/2XkKuNNopmf9RhOJLunvCkyYT4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6160
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I will test the fsl-mc related changes in the next couple of days.

Thanks,
Diana

On 3/13/2021 2:55 AM, Jason Gunthorpe wrote:
> vfio_add_group_dev() must be called only after all of the private data in
> vdev is fully setup and ready, otherwise there could be races with user
> space instantiating a device file descriptor and starting to call ops.
> 
> For instance vfio_fsl_mc_reflck_attach() sets vdev->reflck and
> vfio_fsl_mc_open(), called by fops open, unconditionally derefs it, which
> will crash if things get out of order.
> 
> This driver started life with the right sequence, but three commits added
> stuff after vfio_add_group_dev().
> 
> Fixes: 2e0d29561f59 ("vfio/fsl-mc: Add irq infrastructure for fsl-mc devices")
> Fixes: f2ba7e8c947b ("vfio/fsl-mc: Added lock support in preparation for interrupt handling")
> Fixes: 704f5082d845 ("vfio/fsl-mc: Scan DPRC objects on vfio-fsl-mc driver bind")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/fsl-mc/vfio_fsl_mc.c | 43 ++++++++++++++++---------------
>   1 file changed, 22 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index f27e25112c4037..881849723b4dfb 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -582,11 +582,21 @@ static int vfio_fsl_mc_init_device(struct vfio_fsl_mc_device *vdev)
>   	dprc_cleanup(mc_dev);
>   out_nc_unreg:
>   	bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
> -	vdev->nb.notifier_call = NULL;
> -
>   	return ret;
>   }
>   
> +static void vfio_fsl_uninit_device(struct vfio_fsl_mc_device *vdev)
> +{
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +
> +	if (!is_fsl_mc_bus_dprc(mc_dev))
> +		return;
> +
> +	dprc_remove_devices(mc_dev, NULL, 0);
> +	dprc_cleanup(mc_dev);
> +	bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
> +}
> +
>   static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>   {
>   	struct iommu_group *group;
> @@ -607,29 +617,27 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>   	}
>   
>   	vdev->mc_dev = mc_dev;
> -
> -	ret = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
> -	if (ret) {
> -		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
> -		goto out_group_put;
> -	}
> +	mutex_init(&vdev->igate);
>   
>   	ret = vfio_fsl_mc_reflck_attach(vdev);
>   	if (ret)
> -		goto out_group_dev;
> +		goto out_group_put;
>   
>   	ret = vfio_fsl_mc_init_device(vdev);
>   	if (ret)
>   		goto out_reflck;
>   
> -	mutex_init(&vdev->igate);
> -
> +	ret = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
> +	if (ret) {
> +		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
> +		goto out_device;
> +	}
>   	return 0;
>   
> +out_device:
> +	vfio_fsl_uninit_device(vdev);
>   out_reflck:
>   	vfio_fsl_mc_reflck_put(vdev->reflck);
> -out_group_dev:
> -	vfio_del_group_dev(dev);
>   out_group_put:
>   	vfio_iommu_group_put(group, dev);
>   	return ret;
> @@ -646,16 +654,9 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>   
>   	mutex_destroy(&vdev->igate);
>   
> +	vfio_fsl_uninit_device(vdev);
>   	vfio_fsl_mc_reflck_put(vdev->reflck);
>   
> -	if (is_fsl_mc_bus_dprc(mc_dev)) {
> -		dprc_remove_devices(mc_dev, NULL, 0);
> -		dprc_cleanup(mc_dev);
> -	}
> -
> -	if (vdev->nb.notifier_call)
> -		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
> -
>   	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
>   
>   	return 0;
> 

