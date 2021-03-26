Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B526034ACE8
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 17:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhCZQz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 12:55:29 -0400
Received: from mail-db8eur05on2082.outbound.protection.outlook.com ([40.107.20.82]:49728
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230076AbhCZQzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 12:55:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AxQZK+j0iG0TmhIyT73DdNhTTucQMoUgSrkK9/jLOXnpVqVbBUdsse6S8AgVa4SbuHbrsWXIFGT+NqEQAIvXwt6Y4uxQKlmtJK7h492/upDb6viR2cgtFCNe/mqmH8yQD723WYaK3ZJTGjjJ8SnNYa9+bHdf/4oKO6do2eFapOoNrI4spTP1nwAtdHOUDCXZl/1JNpIntdTHm8dnIW+r3WcNxnR2LfcPeLB78btd+2v7/na1le6x+Z8mNOo89ba6hL7kc8zJ/OQWnb5WtfNGPV1QwSXU00XXrLO1Zh4VOcNWk0LrPAAtoTrPhG65c6lT7Ew4+2CzkeNPeyqiXzSGiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ro/9nDKmyN3R67p2r8irJf1NYK9Cku32fu9Xy/Do7uQ=;
 b=JAATb+JvFVb+0AD5HukZDkv2yGCHEAuhhPwoBkF+FNC6yKdI7DdUymnkwhCUc8YOCeVAZmK7WpbvyGU3ojudldzXNtqjQW+3krs9K07zYfbCLH4Q0jTkbmW82WqDWbt9s+OT6EDVTUfsjVpy//hfxxXI13KxL48JVS21DdoScUXUzwjGXu7XAWPi02kFz327yREb9uQLJOyCMKrXj0hf0sQb2WVvLfsDmKRNyVg18ieLqSdaslbygOqqa2JhxwrzpFQuE8gL5re7vSzMHA2NB6mqHSL0aLE6vSX5pzTtwlFZU0GzSGB4Xol4wbk9UeS4Uzzg5IvNu1Zo4wQ8715ijg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ro/9nDKmyN3R67p2r8irJf1NYK9Cku32fu9Xy/Do7uQ=;
 b=Gv1ulEEYgbQflkADFFuZB9bwHzhlBB/9NhtWTIKli07YJdnTgWJuiQa1PBFgUuG2w31PUtesEalpLODaZis0Id8qyP738YIxJFYCL3NfaZvJWsJRt3xGhLZl8+WpMlBp3hSwl2KxVjG1IiaWuxVCvd8WxmSeCaj/pFvCHPsZrLI=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB3503.eurprd04.prod.outlook.com (2603:10a6:803:d::26)
 by VI1PR04MB5776.eurprd04.prod.outlook.com (2603:10a6:803:e7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Fri, 26 Mar
 2021 16:55:04 +0000
Received: from VI1PR0402MB3503.eurprd04.prod.outlook.com
 ([fe80::f81c:a9ad:61af:1e39]) by VI1PR0402MB3503.eurprd04.prod.outlook.com
 ([fe80::f81c:a9ad:61af:1e39%5]) with mapi id 15.20.3977.026; Fri, 26 Mar 2021
 16:55:04 +0000
Message-ID: <bdedc3db-6730-0bc4-457d-af3d1ef6a846@oss.nxp.com>
Date:   Fri, 26 Mar 2021 18:54:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [PATCH v3 05/14] vfio/fsl-mc: Re-order vfio_fsl_mc_probe()
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
References: <5-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
In-Reply-To: <5-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [86.126.4.172]
X-ClientProxiedBy: AM0PR02CA0189.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::26) To VI1PR0402MB3503.eurprd04.prod.outlook.com
 (2603:10a6:803:d::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.211] (86.126.4.172) by AM0PR02CA0189.eurprd02.prod.outlook.com (2603:10a6:20b:28e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 16:55:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 52a69e9a-8e69-45c2-bf78-08d8f077e6ee
X-MS-TrafficTypeDiagnostic: VI1PR04MB5776:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB577673B52F14EF7617EBA936BE619@VI1PR04MB5776.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 13tMV0f/35wDNmptB5qwccrm6vgzUbKxL4x52V7pdsX/mVA1yiotvgtJkvY09E44BKjULvIIOjEViBBLEnyvHU9GTUmHlzGO4B6Hs0IdB4G6Fvu6HYjBbwYqkfg7IYL8Zpvm1w/9mnmrPPsTFwNDrp1UrP74eD+7G3CEotETNTFyMRoEdZVnTFdu/GFLWJNZJ6sQUkNJX1V/yNqXUtIe0280zMzaHydhwTZL9maIVPRX+nGmTdVNgZghWPQ5BG3x+FPBT7DCInFdYuluid6xjdeW5EtteXroD67TUFjw+0sA8WpBToIbB8O/aFuO6WimATWJMAZDPgyLzbKBn4eH8XWc+EzE2syczECHGr7dQV6LFZqGIYztnwR+bMF5bY06OcZemQ/tRNo77//8SiISwKR0Aq+2dry8pLQdJ6Ose3qAvzcfmsNdA0qryIx5HLQCOXCxYJ/ZYW8EalK8s71th5P/fVVPX8ZQADBLJeTNrvmgZvydv45pg7DIGx9CU9S5y+CyetQuuGt3+Vh5/dizXw5IqXhOBkdyyVUiIq1LWFFMyGYKDSk3ZxKY2RJVGDUmuHvwO6ECQ/+SwEVeLgZ3zifV3B124JH4hGe1Br2XLhjZB9MFTu3RM7lL1lUjDb0CK9hNMV/3yHR+Q9YUykJUmygecdryiNHMh0BvfCEpCkEXDPwmusSjNn2sTktWJcv5+MGMCwxgknbF/7LdU1b5TDnr7e4nRUGXBksvGe0O7CX37FXdCqorqk3XQYB/hJZ8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3503.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(956004)(66476007)(316002)(6666004)(2616005)(66556008)(8936002)(6486002)(83380400001)(2906002)(31696002)(478600001)(16576012)(110136005)(8676002)(54906003)(86362001)(5660300002)(53546011)(26005)(4326008)(16526019)(38100700001)(31686004)(66946007)(7416002)(186003)(52116002)(169823001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q3FYYkIxOExqQlFjTXFSWllFREEvYVIrQ2dpc3k5cU1VdzVVY0ZicEZJcktp?=
 =?utf-8?B?anFwbkRFNy80NWZXOFFyVjQ3RlpPQU43Z25HWTFCd3cvZktld0lkUnNUSThw?=
 =?utf-8?B?Q3ltbTJzdHhhMWpMYnQ1Z1FxUjQwRmFHemZrdC92SU53YmNOdzR6K1dOYnVh?=
 =?utf-8?B?ME9STU5WaUR6cmlhS1kwcDFXdVVvZEEyNmlseTNxU2dPUWlRdDIrYSt0Mnc3?=
 =?utf-8?B?NnN2anU4NTlDWld3amQ3SkpoRldTYlE1RnB5cnMvVEo0aHBQb05hYWpwbHBm?=
 =?utf-8?B?Nzgwb1o2WWI4Q1dSazd2NmJtUGhPSVdCNXpHZ3JiU3hUd0ZqU3AwdWx4R0RK?=
 =?utf-8?B?QlUyT0FET2ZwaUVZbldTKzhlL1I5U1JpS2lIb3Z5bGphWDNZVHZSWTNmcGY0?=
 =?utf-8?B?a3JVbU9sRjZ1KzRiT0ZyeWR1YUI4M3dkc3ZiRlF2UktZQ2s1M2ZJT3hHcXd0?=
 =?utf-8?B?RGNZem05YzdLaldzdm01R3RicWRyd1lZK3FYdFdnRWhwTXRBdWZtSWFrSjRa?=
 =?utf-8?B?MDNzOEU4bkxqSjVEOEEweTRyWnlRZnIyQjJGZCtpNng5VFNBbHFUUXROaDFK?=
 =?utf-8?B?cER3MEJHNWo5MVVoeDdNRFcrUEtlUHd4cmFJTjRNSDZaTlk5azFiTDB6NS9T?=
 =?utf-8?B?b09TUHA0Q2RaZ0lGMWI0cmNXb0VNVEpkVVIyV2hwem9raGFSZFhXTHJEZmZM?=
 =?utf-8?B?K21DcG9yMUw5TUcxdkpjMnZwSlJvWjFZQ1RsWnYrWlR2ZE5UVW9kQ04xeE96?=
 =?utf-8?B?Ly9tRU4valdoTjFEMFJmVVNuRU9uWkhlemxPc1BoNkUrWnFoc29JNDFXcVp3?=
 =?utf-8?B?eTBhQXlmTUNPcHhSbVprQmxMWEh4OHY4RGJLUHEzTjZPSEJlbUl1VzB0UERW?=
 =?utf-8?B?ZHRhZm83SW1aMC8zb1NnakFXNG5IdGZFOHZNMXdQWEt2ek81YldvaGVSN0Jp?=
 =?utf-8?B?OUpCQmNYOVVTOSs2dXppeG81M3F4cHdiYlNNV09LN0F2VGxnY01aVHFEcmU0?=
 =?utf-8?B?RlRIbCs5TGFNMTh2T1M3d1R2NlNMVHhvRjA5Z1VTWGt1NjJQWll3a2UvTlpj?=
 =?utf-8?B?MGJXWFdXaWowa2JUUXJpbUkvaUtrTG5sbUFEeXJLcHNBQ1RvWVRITjlUajA3?=
 =?utf-8?B?L2xwZ0VrNzMvbm1TbzBCNG4zQjI1ZjhKV3ZwM0tGME9IOXhpNDBjelpEWG55?=
 =?utf-8?B?R0NUb1pQMys4bGl0bmQ3ako4K0Y1ZGoyTi9maVVzN09oMkJ1dm9CeTM2V05W?=
 =?utf-8?B?bmgxTUxEL0pTam1nVmFRdkNqUHlOS1lsckc2R2tNU25LcHFxOC9SNWltSTVP?=
 =?utf-8?B?NjRZVDVERjVDNWpHSndwOGQ5S0tKektlVElLNi9ueHB5YWpQMytwZ050SFhy?=
 =?utf-8?B?WlFIOE9paWU0a3BDQWo2VnJSbFo5NGsxbzlybmVlNWVLU3dYcEpGTDRyajJk?=
 =?utf-8?B?Ni9KV2hscjM1TGk0LzdnNFR1Qy9BTDRxNGY3ZlNkVTN4alJOM2o4cjJ1NXlu?=
 =?utf-8?B?NVk2VnE1eGZKS1YrZmdJSVNwbndjVkd1TzNFZ3FNa1J1UmNNbE5BbjFjb3oz?=
 =?utf-8?B?d3YzamQ0M1h1TmZpUGovbGJadGlrSnc1Y0dGNFRvdE1hNjFUb2xScS9GOFcr?=
 =?utf-8?B?aWVGSnVxNmNEZkxqVHF1cmcyS1o5RGNJQTdaZDJ4eEVaVWhJVWFVTUV0Q3By?=
 =?utf-8?B?cU1uckk5djVyYXM0NkhpeG9UN0xQc0VRL25WOG1pemM5ZmNEc0FrZ0JXcFVy?=
 =?utf-8?Q?wF5kVK5dfBEom4bpDWgAhbP3wj173n7oaGu4GCf?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52a69e9a-8e69-45c2-bf78-08d8f077e6ee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3503.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 16:55:04.4193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UbgzkCz+NVPPwzuo7FwBamMggi5Cf3zmIvelQIRkkK2bNRRR3dJdLSvY2SOXoCDPNxcy7RcV/4Bt9xON0W/UbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5776
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks, I have tested the patches and they work fine.

Diana

On 3/23/2021 6:14 PM, Jason Gunthorpe wrote:
> vfio_add_group_dev() must be called only after all of the private data in
> vdev is fully setup and ready, otherwise there could be races with user
> space instantiating a device file descriptor and starting to call ops.
> 
> For instance vfio_fsl_mc_reflck_attach() sets vdev->reflck and
> vfio_fsl_mc_open(), called by fops open, unconditionally derefs it, which
> will crash if things get out of order.
> 
> This driver started life with the right sequence, but two commits added
> stuff after vfio_add_group_dev().
> 
> Fixes: 2e0d29561f59 ("vfio/fsl-mc: Add irq infrastructure for fsl-mc devices")
> Fixes: f2ba7e8c947b ("vfio/fsl-mc: Added lock support in preparation for interrupt handling")
> Co-developed-by: Diana Craciun OSS <diana.craciun@oss.nxp.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/fsl-mc/vfio_fsl_mc.c | 74 ++++++++++++++++++++-----------
>   1 file changed, 47 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index f27e25112c4037..8722f5effacd44 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -568,23 +568,39 @@ static int vfio_fsl_mc_init_device(struct vfio_fsl_mc_device *vdev)
>   		dev_err(&mc_dev->dev, "VFIO_FSL_MC: Failed to setup DPRC (%d)\n", ret);
>   		goto out_nc_unreg;
>   	}
> +	return 0;
> +
> +out_nc_unreg:
> +	bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
> +	return ret;
> +}
>   
> +static int vfio_fsl_mc_scan_container(struct fsl_mc_device *mc_dev)
> +{
> +	int ret;
> +
> +	/* non dprc devices do not scan for other devices */
> +	if (!is_fsl_mc_bus_dprc(mc_dev))
> +		return 0;
>   	ret = dprc_scan_container(mc_dev, false);
>   	if (ret) {
> -		dev_err(&mc_dev->dev, "VFIO_FSL_MC: Container scanning failed (%d)\n", ret);
> -		goto out_dprc_cleanup;
> +		dev_err(&mc_dev->dev,
> +			"VFIO_FSL_MC: Container scanning failed (%d)\n", ret);
> +		dprc_remove_devices(mc_dev, NULL, 0);
> +		return ret;
>   	}
> -
>   	return 0;
> +}
> +
> +static void vfio_fsl_uninit_device(struct vfio_fsl_mc_device *vdev)
> +{
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +
> +	if (!is_fsl_mc_bus_dprc(mc_dev))
> +		return;
>   
> -out_dprc_cleanup:
> -	dprc_remove_devices(mc_dev, NULL, 0);
>   	dprc_cleanup(mc_dev);
> -out_nc_unreg:
>   	bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
> -	vdev->nb.notifier_call = NULL;
> -
> -	return ret;
>   }
>   
>   static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
> @@ -607,29 +623,39 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
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
> +	ret = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
> +	if (ret) {
> +		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
> +		goto out_device;
> +	}
>   
> +	/*
> +	 * This triggers recursion into vfio_fsl_mc_probe() on another device
> +	 * and the vfio_fsl_mc_reflck_attach() must succeed, which relies on the
> +	 * vfio_add_group_dev() above. It has no impact on this vdev, so it is
> +	 * safe to be after the vfio device is made live.
> +	 */
> +	ret = vfio_fsl_mc_scan_container(mc_dev);
> +	if (ret)
> +		goto out_group_dev;
>   	return 0;
>   
> -out_reflck:
> -	vfio_fsl_mc_reflck_put(vdev->reflck);
>   out_group_dev:
>   	vfio_del_group_dev(dev);
> +out_device:
> +	vfio_fsl_uninit_device(vdev);
> +out_reflck:
> +	vfio_fsl_mc_reflck_put(vdev->reflck);
>   out_group_put:
>   	vfio_iommu_group_put(group, dev);
>   	return ret;
> @@ -646,16 +672,10 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>   
>   	mutex_destroy(&vdev->igate);
>   
> +	dprc_remove_devices(mc_dev, NULL, 0);
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

