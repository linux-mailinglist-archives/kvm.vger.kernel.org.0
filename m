Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD78C3FB352
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 11:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbhH3JnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 05:43:05 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:55249
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235535AbhH3JnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 05:43:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfyTJNRzIXjvaoCfFg200MWl9DBHym4vIPzfqRLuASHbFUqXY2YzrdQj4ds5mdowAqMfOEZ5SpZAT56zJ4YoiOjsdRSO5bhUkIs4zD4oxS9XW+wUb+pHy4lJUbWfhxL+VO8CgwXDzZ80qP7U3AASjYxsowuCIABQcwmQBF0Ah74l4EkUb9fIs84Vy8Fd8mqILe08ZV9fSH5VKreQ5E8JV45Egm+FBmV63iJTod6BiAMUNEiuDsKuOYU3ox1n00LJQMbvv0Jw5CDK9aknsx/QXs32KOYS+pkZiuZgM6KmGQ/8Q4jxdjgz/yo2fMpEt7h3Vd/OpLIuTgxmYdAj1B+/JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxzU42qYmJWMMAQMbnyIgN9d26eu8AqYnitbA2G/RtI=;
 b=f/tAqKWySFPq/G+D4XyQdHJWcy+VTpKGhVx3iybNjWAhTU2G2VoBvSeZXLT3Py84ih1N5YySWZXfvypLWqq1c60nOm6EUc4EYZK4UWfieAW4mj8i+6+VOlPvC5sVn9/AfzJdeWSmego4IXo4ihbGMeXMk7qcBMUpSsZtSe6PgrM/muHN+mOm5WaKGN3VSGY3sOWIcZ4ufvAqywq3C0GTVoWC3aLVjS3rK+Qq3BCpMKw+Nclk91VAOQ/AoVtnXFdyPNSc3zim60xU3eBkOP8pqxLV9tz6Jvrz+5/anrRwLDa7poUX2kVzoXtH2aIeg9DtHAG9x+JQnssYWj2vix0y2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxzU42qYmJWMMAQMbnyIgN9d26eu8AqYnitbA2G/RtI=;
 b=mA/5LpHlo8D4WnLBDmTsF6tgsi/0lCSmWsq5uZUFftvnO5z5K0pjMzUMgFU91KEqzXxAUu1mqFZnnqqvXYNgvvzr+6Z39y0M1RAa76ARSGe3NO5X/eXzRzwm6XKveg79CBRj8VRIDp6fUd9LrW4x3Y+AMhv24hriHRpG+WptzT0=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com (2603:10a6:803:3::26)
 by VI1PR04MB6992.eurprd04.prod.outlook.com (2603:10a6:803:139::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 30 Aug
 2021 09:42:08 +0000
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::10e6:799c:9d34:fc2d]) by VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::10e6:799c:9d34:fc2d%6]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 09:42:08 +0000
Subject: Re: [PATCH 2/2] vfio/fsl-mc: Add per device reset support
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>, linux-arm-kernel@lists.infradead.org
References: <20210825090538.4860-1-diana.craciun@oss.nxp.com>
 <20210825090538.4860-2-diana.craciun@oss.nxp.com>
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
Message-ID: <4d0e9854-4187-cca3-c2dc-036258639e4b@nxp.com>
Date:   Mon, 30 Aug 2021 12:42:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210825090538.4860-2-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0701CA0001.eurprd07.prod.outlook.com
 (2603:10a6:200:42::11) To VI1PR0402MB3405.eurprd04.prod.outlook.com
 (2603:10a6:803:3::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.108] (79.113.50.66) by AM4PR0701CA0001.eurprd07.prod.outlook.com (2603:10a6:200:42::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.10 via Frontend Transport; Mon, 30 Aug 2021 09:42:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b66c9f31-1c2a-4055-96b9-08d96b9a6ecf
X-MS-TrafficTypeDiagnostic: VI1PR04MB6992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB69926CF81846447E1EDAC49BECCB9@VI1PR04MB6992.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1P7/XNhFiF4TNgV41o7yPAabcFB54/NPD0lQuB6w7oRAzcNDWXL3aB1Q36NoInQEIil28UC90yXI2a57pWw9FwrmG6/sfXDdISLxif2UIIX42EzKOSKAap98FqujoobmBotxinifXp6VoP16lYRB434BFnvrhczYc9Z2yeFwX/ejRgxW20PDnFPL95SdQU6MDlgHIx1cyUJd+UxQfwgapMxSfUZU3yZ7yu7qzaVknaHKuWtK8KpTl3s15EFOg4dXTKY+tmHhgoC6lHt/nx5vLqFt8DlDcDUHDa/gOR/IQh5ZHq8hCDVJhNdFKFJwKMFjzGcMn18VR3CX+XbMCnNAhyqddFiiVwKy386Z96AjKukioVfBsUIqGoKv+E5G2PldS7fmmINOa4r4U0A/qNKY4Uj3ki6dHZYvnJ2vW3hlwkkmkSktbqFA/8tBv0pbirSNNa47GV8Fqk5NCfSrtz0cB0pIb/H8Hfbooeut+ZFenVyt+/KJBx6fsrhDxh2l6vrTXNKNhjsmHyUIqfXAMBX5JtKfOsAmmwnLT7wYDvNHwe3H2xPyuzV3w4nKw8zEFk6/7unKFPeMv+1y5ewLFX4f7Zu7iFN1uPUDtwdST7kLqCPBEAJJfUpBgxYsg9IExNOwz+5TO2RuCth+BveWaZVq2FKinNMEnyRKGelZttMoX4Kqrq2gIZEK1TIYtR7QWYOwLN7JxH0WKpUCyP/HfllFNfH2sgCILHUurXxvqLkZqcuPTntsljAGgGbbgeWvl53DpyU4tVsmU1973oTi0Mj6tA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3405.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(478600001)(36756003)(52116002)(38350700002)(16576012)(4326008)(86362001)(66556008)(110136005)(26005)(2616005)(316002)(31686004)(66946007)(8936002)(53546011)(186003)(83380400001)(66476007)(38100700002)(956004)(2906002)(31696002)(6486002)(8676002)(44832011)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YzlhUlpOZEE3eHlrRUxWYUgxVWN4Z1NsemkxUTkwTjRNQ2lreE43azVKcGFl?=
 =?utf-8?B?a2VRUGhXdGl6eTB2Yjd3aHlzRkF1M2RTTTR6Y0ZpNTZaQ0JnRVp1bHo4SUVi?=
 =?utf-8?B?bk9wMGpoanVVS1BJQm9tbDZQK2RRN05RZTBrd0p5c1Q5cFNaRzl4YmQwWDFF?=
 =?utf-8?B?eStHZlFWQmdPVE93UUNraDV1dHpFbEg2RDVjbUVqRHdXNWxMOG1ubjBYZXp2?=
 =?utf-8?B?MWlDczh6K2VQTlVRV1VTNjVmTVYvOVptWmNQMzB4SC96M3BmRGV4Y0FGWmk4?=
 =?utf-8?B?OFBEWFU0UFFwb2RJTVlac2lPc2lxdW1MMjA0ZmFhMmw1bzU2UHVlMWRuZXFo?=
 =?utf-8?B?SDUvbHV3cVJKZGVFZEF6eFkzRlBsVDBaU2hEWlRTQSt1TCsramtVZlpMZDZO?=
 =?utf-8?B?UVdBOE5QNld5dkQ5V3kxei9IcTU5NVkzT21aRFNSb0x4TmoyWHBmbmRQaEda?=
 =?utf-8?B?d2JLSEMrbyt1QTU3TCt0TXRaMHZQbDM2VG8ralFFVGllVlBoOERGU0dFZGtk?=
 =?utf-8?B?em5GVmx1bmtac1pjVFFKSkFRZkNDTEQzWU5PU2JEdUpnMWFvWlhwUi9Fczli?=
 =?utf-8?B?dXk2SldjVldtVWxkaENZZXE2NEE2QjVBZm5sUW1xS0IzNEpwWEMxTVRuTFNy?=
 =?utf-8?B?UUNFYXpPOGh4V1M0STdqaS9nNVA5ZUkrV21KY0FGL3BxU3JGMkFHOWNBRC9m?=
 =?utf-8?B?Sm5rTk4zaFI4dm1vN01idEI1dE1ib05tWEJTWm93ckhRTnM0Wng0UU82NjMw?=
 =?utf-8?B?aTF0Z1FMTmlUMDZrNG9Td3ZUSWpTN3FkYlZ3K3NmTDRHMUp2L1liSWJQTjZF?=
 =?utf-8?B?c2t4UDJZMytMeXNUQ1huekdndk9BTDE2dFVNUkVlZGthSXB5SlhnVFFGN2dF?=
 =?utf-8?B?WVkrSEgxWHNlK3AxOVJ5dDlGWXNORVNrUEo3Ylg2OG4yZEVtRHBCWTE4TjhV?=
 =?utf-8?B?cGczakM1UDlib0pYanZlbWJ2VVFLZXlhdVRyZEdySm1Yenc2NTUzYUFuRlNR?=
 =?utf-8?B?YUpkd3BTeXFlVmIweGJrai9hSElDSTlVK2VJL09TQjRYaWpvbUV6dnJtSWFz?=
 =?utf-8?B?R2M3S3doeGRxS1ZYVmIveGQ1YlFiTkJ2SFRCWXFHeTY4NWNMQ1IvZjhiWkNj?=
 =?utf-8?B?UFpwVGRmTVBZOFBFUVluNVhlMDR1bGtCNG1uQi83Y0lKOTRTN1U1QjIxZ2Jj?=
 =?utf-8?B?TDdpSWw3UVd3Q0tkL0ExWlhxVHhadHBqbDFnUWdhWUc1TjhvWVNBbWpiZEdX?=
 =?utf-8?B?UzEyMi83Zk9YcjhPL2NCRXo1MDRTSFF0RllVTjFhVmx5RXR1T0FHbVdSdkR0?=
 =?utf-8?B?cG8yeXBmN3MxckJReUNNd05nWkQ4NTlOdGZEVnRjekRXbFVkZFovczAxSEk4?=
 =?utf-8?B?ZVdzeGZta3NxTnErOVVOd2ZDV05tVldHbG1rdEQ0RjV4aGR1NzEyMGZqcHF0?=
 =?utf-8?B?VHFRTU9rNzl6RHRVQ0xxMG1iRkdld2p5bGpMaWVyaW1LR0pqeW9tTWpucllN?=
 =?utf-8?B?OUYvZG82Q3RPVGNBUXhqdEhsTlZ0ZzZNUHUwZ0dwYkVPdWI2bHJlcTdOZGxi?=
 =?utf-8?B?cTFJd3J2Z2Z4U3dkYTQrbjhVTnJCRlF6SDdkRmhqbllBdmh1QXl5cG5NNDJM?=
 =?utf-8?B?UktHKzJ4WHlFK2ZuUWkyRXJ6d3RMcFkrNjdRVFJ5VGVKVFRvSkprQ3RPclRz?=
 =?utf-8?B?bFN6SWhKRnY4bWdFQURFZW9ybUl6VWE4bURQTFF4NjAvOGZxSWhvV2RDTUky?=
 =?utf-8?Q?U3GJJL/mkvxv/mzUb7S3SKLR3b4vcwdvvGfNoJ5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b66c9f31-1c2a-4055-96b9-08d96b9a6ecf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3405.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 09:42:07.9788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IvMapfLLge4cWY294QAWYJNQGtSzsXq2NzGhMRewUM9EvX2RSJvAzE4BNlk1VHqj7vri0l5ibRiT1PMDiWN8Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6992
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/25/2021 12:05 PM, Diana Craciun wrote:
> Currently when a fsl-mc device is reset, the entire DPRC container
> is reset which is very inefficient because the devices within a
> container will be reset multiple times.
> Add support for individually resetting a device.
> 
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 45 ++++++++++++++++++++-----------
>  1 file changed, 29 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 90cad109583b..46126d41dc32 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -155,6 +155,33 @@ static int vfio_fsl_mc_open(struct vfio_device *core_vdev)
>  	return ret;
>  }
>  
> +static int vfio_fsl_mc_reset_device(struct vfio_fsl_mc_device *vdev)
> +{
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +	int ret = 0;
> +
> +	if (is_fsl_mc_bus_dprc(vdev->mc_dev)) {
> +		return dprc_reset_container(mc_dev->mc_io, 0,
> +					mc_dev->mc_handle,
> +					mc_dev->obj_desc.id,
> +					DPRC_RESET_OPTION_NON_RECURSIVE);
> +	} else {
> +		int err;
> +		u16 token;
> +
> +		err = fsl_mc_obj_open(mc_dev->mc_io, 0, mc_dev->obj_desc.id,
> +				      mc_dev->obj_desc.type,
> +				      &token);
> +		if (err)
> +			return err;
> +		ret = fsl_mc_obj_reset(mc_dev->mc_io, 0, token);
> +		err = fsl_mc_obj_close(mc_dev->mc_io, 0, token);
> +		if (err)
> +			return err;

Error handling here looks a bit atypical to me. Maybe something like
this, which will also get rid of the 2nd err var.

	{
		ret = fsl_mc_obj_open(...);
		if (ret)
			goto out;
		ret = fsl_mc_obj_reset(...);
		if (ret) {
			fsl_mc_obj_close(...);
			goto out;
		}
		ret = fsl_mc_obj_close(...);
	}

out:
	return ret;

---
Best Regards, Laurentiu

> +	}
> +	return ret;
> +}
> +
>  static void vfio_fsl_mc_release(struct vfio_device *core_vdev)
>  {
>  	struct vfio_fsl_mc_device *vdev =
> @@ -171,10 +198,7 @@ static void vfio_fsl_mc_release(struct vfio_device *core_vdev)
>  		vfio_fsl_mc_regions_cleanup(vdev);
>  
>  		/* reset the device before cleaning up the interrupts */
> -		ret = dprc_reset_container(mc_cont->mc_io, 0,
> -		      mc_cont->mc_handle,
> -			  mc_cont->obj_desc.id,
> -			  DPRC_RESET_OPTION_NON_RECURSIVE);
> +		ret = vfio_fsl_mc_reset_device(vdev);
>  
>  		if (ret) {
>  			dev_warn(&mc_cont->dev, "VFIO_FLS_MC: reset device has failed (%d)\n",
> @@ -302,18 +326,7 @@ static long vfio_fsl_mc_ioctl(struct vfio_device *core_vdev,
>  	}
>  	case VFIO_DEVICE_RESET:
>  	{
> -		int ret;
> -		struct fsl_mc_device *mc_dev = vdev->mc_dev;
> -
> -		/* reset is supported only for the DPRC */
> -		if (!is_fsl_mc_bus_dprc(mc_dev))
> -			return -ENOTTY;
> -
> -		ret = dprc_reset_container(mc_dev->mc_io, 0,
> -					   mc_dev->mc_handle,
> -					   mc_dev->obj_desc.id,
> -					   DPRC_RESET_OPTION_NON_RECURSIVE);
> -		return ret;
> +		return vfio_fsl_mc_reset_device(vdev);
>  
>  	}
>  	default:
> 
