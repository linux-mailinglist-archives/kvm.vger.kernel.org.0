Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173D333F5A4
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 17:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhCQQgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 12:36:48 -0400
Received: from mail-eopbgr00080.outbound.protection.outlook.com ([40.107.0.80]:13699
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232328AbhCQQgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 12:36:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxBkBvo7sDVkgvpHfDtX0RoMOKLCLXvfTSFp8aqAmYK7hhs3AKhAycjMhu0OIJutAdjlY+l3JzoASrWu6JUUM33XVkeo4z7KZNbskZxW/4LTpVGfVT48g/t5LvQkJMmKB9f4jMoW6B0LZJGgX10zXxpZ0pVcCyT9WuL9r9H6RVf1oNm0hG0eimyMx7nQ3jwO3EnGODm81EJp1JkRa97dSYBln5u6FMgxIHzesFHluRquUi9tifUPKtLfYfDCCRk9n4/hrJf2k7GDf2yX/tDXmc0i3iBZiOXmVkuvFrwEizkyjw3Ppsc2q2sUJwjXhxQzbaaI3pqJMcYpd5a4Z+7lag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVsB+2l7RB7XO79Fu1W3BYTnKhn+1Tnpr5D1dISJ0Qc=;
 b=kQWFR4uJFona43JT+1n6aGfZpa1YdquzjiSFf0Q+wwFroFSJ3IocoVbSyBFV8vQHuGfCnc8yaarTZfOhUXpfmXC9rOuVOKvAXrr3Quw/+sCNySadoFNw47hFZTiikD4SxNPnBo/Bfw0hdYLvaUfgZW1U/6u4J1yQgW/tVn8sb/pJujeyuqRDagCI5MVvZe6UBWcqw6vuau7+qwL01AbFB74vINDqlwd1B8mFgWKs/lcXe0sU4QDe6PBHjbE0wl2425RsQ4UjNrkJV8WAyzjbmRM7+ZODxrEOHSFQzq5g5DGVy0cjd3ez5yjlnJPcsf3AycW55ei4ND3KRz78HXVWyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVsB+2l7RB7XO79Fu1W3BYTnKhn+1Tnpr5D1dISJ0Qc=;
 b=WJ3c39JTYvTYz2NfkJbSfYydRFzjCUESSgJo9XP6RzAxXNQPZUnYL7wDPbxhzHt72csqOb+1oO2zFS2dvWdMYVB89BYj9d353/dcFD7sEd3OiubriKtdFYgeKS+YY8Vec60/aQsTPd1EgmxdB8dRvZiRrk1lMdHfU6mLebFti70=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB3503.eurprd04.prod.outlook.com (2603:10a6:803:d::26)
 by VI1PR0402MB2846.eurprd04.prod.outlook.com (2603:10a6:800:ba::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 16:36:14 +0000
Received: from VI1PR0402MB3503.eurprd04.prod.outlook.com
 ([fe80::f81c:a9ad:61af:1e39]) by VI1PR0402MB3503.eurprd04.prod.outlook.com
 ([fe80::f81c:a9ad:61af:1e39%5]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 16:36:14 +0000
Message-ID: <ddaf1e9a-5f8a-e28d-9f19-928ccf9a15b5@oss.nxp.com>
Date:   Wed, 17 Mar 2021 18:36:09 +0200
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
        Tarun Gupta <targupta@nvidia.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
References: <5-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
In-Reply-To: <5-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.26.44.171]
X-ClientProxiedBy: FR2P281CA0008.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::18) To VI1PR0402MB3503.eurprd04.prod.outlook.com
 (2603:10a6:803:d::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.127] (188.26.44.171) by FR2P281CA0008.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10 via Frontend Transport; Wed, 17 Mar 2021 16:36:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b50dd591-412c-4366-4634-08d8e962c77a
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2846:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2846753E11AE5BE24D7C21E9BE6A9@VI1PR0402MB2846.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wf5JvXnoWzWiLCV8u6uJSirKRrWY3eAj/v3gyHZ1pvqvFlRXII5DrPvhhYBZEr+u9oOcZpf99eeBZc1vpgz+h1tLAb5GXU501ggk0yj9R9thkK4px7JetdtZ0vTBoG7PYHXuRO3tvzoMURDE8eKjDFyLrXIiNAby8VacwcfJcMEHGOjUcLhSS/xDZpMWu2JZQm00u4B9H6QsNz64c1+1gReME0ENt6RKgf9AHVgMEsm9Zf0hBECj0zmUEFCRNitkjkAs+llf+1C/S0+9xR1Z+Rrjts+KwlcJRgytjfMe2dpIC5l42RmR3gyKt0IvV6C+B/0M4PxJDXjfUNsC124gNa+Cztep7Je6wIqTv8gKhVX76vovim0FrV0JA+oXJ2BJ3iN21StxCnBJ/+aS74R9zN24pO0SQYZaR8NlKhfw1AUd1YWo49MZ4TyydlLZIFKOoZWMT3byYssx6SBDTMo1P5EIbkZIPYFxSLgLyct/scBHv/kFqS/MntVXOuvpBHk1GeX7mzGV6780+Y+J9pP+bZ8FlnlFcEDtbdOdCidT1RWCx6T8T2nbDSjtVWZh83JLhmvb5rYhuoYmv3+eVX8yUepSMdYt3ZbZ6ziZwFU3Eq7syj4RkewSrvbjPePrmnEF+RJneLj0iXaKnT4fJOyOOiFf8g3e/GL34ARqzhLEoCM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3503.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39850400004)(396003)(366004)(346002)(956004)(110136005)(52116002)(16576012)(31686004)(54906003)(2616005)(478600001)(2906002)(316002)(8936002)(53546011)(5660300002)(16526019)(83380400001)(4326008)(186003)(8676002)(6666004)(66476007)(31696002)(66946007)(66556008)(86362001)(7416002)(26005)(6486002)(169823001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S3FwQXY0TzZXcGNhZkRGT2RSc1A2bUZ0T2F2OTN3R1RMWlVMYUtQd2pBdDZw?=
 =?utf-8?B?QnJuNWRIdU1LUVkvL3ZtS29US2dhaWZPSTByNk1LbTd4SWZGb3kyNmNrR3dM?=
 =?utf-8?B?bU1sKzRaTkJKVHBpaUJXZ3lUc0RTdzFsdUlYbTRWYzd3V0dEaFB3dS9oRm5w?=
 =?utf-8?B?MWpMUnFkSU9vRDlsWWhjOWxRZHRNWXhKUC8wYmVvMXBIQzRISW5wRkFpQXZp?=
 =?utf-8?B?WlFvV2ZuNURkYlZaK0h2VGp4Z2hhR3QzRGtWZHNOZnFFRDMzZytRbVBwRzZW?=
 =?utf-8?B?WGlQVXd0c05LTUFSdkRyOVc1dXlvMmJTQ2dJWHdZbzlZakcxZVlDVU5VMFR6?=
 =?utf-8?B?RkRONm5jYjFQbmdhV0grZXdoZHZIVVg2c0VxYk1rMDJveXRkcHQ2Mkh2NGZE?=
 =?utf-8?B?eWd1V3dXTURkcXh5SmdsZ1pzTkdWUC9NUFNCNC9Fcm1iQmkrZ01YbVJpbFZm?=
 =?utf-8?B?U2pUdWF6SHdJZEZ0cTR4bVBnTnRPY3hDNXRkbGRyWkNqWVZENkRnQjd4cnVW?=
 =?utf-8?B?cUkrVVJSUGdNM2RKNWtLb0dmRWNkMkhVVkliSlBkU1N2OG1iVU5zaVdHOWdi?=
 =?utf-8?B?R2RIeUtpRDFpZ1cyZnFKRnJlZ3hGSnJBWjQ3WmhhMlE3MXBTZHpXdjlkVjNn?=
 =?utf-8?B?N1IyY3VwWXdOUTlkdWVwMGdtWTBRdUpkWHR6UjBiOGU5Lzl5Yzg3SysrSUds?=
 =?utf-8?B?TCtDNjUxaUEvT0tOVUxvRmFlQW9aU1h1L3VrWmdqbXlPTmNKSmg2WjRqYWFm?=
 =?utf-8?B?K3d6M2RtSTVMVi81RUU5MytuTUl5M2dNU0FWVmlveFRHMlFCY0tvWTVjRkE2?=
 =?utf-8?B?OCtVS1hwVnRvU0FhaERXbHVNZTFzZDNEOGhXQ2FNSzlCR3pwbE1lbzVwOS9r?=
 =?utf-8?B?WlNhNWRGNnhOMk1RNEtwMW51ZlhFS2hpS1I1dnJ4QmJCM2k5SnZRMHk4aVBq?=
 =?utf-8?B?cG00T2EvUnNGelhSK2pSeHBacm1Ea0FqQklLQmdvOEd5THgvdlliZ2ZlWFJq?=
 =?utf-8?B?NHhzY1dOWnV2aVp0a1hEdTZvWXkyb2dLbnpqWkNTaUx1TkNJeDM4V0h4Vnk5?=
 =?utf-8?B?YjlwNjZ4cjl6YUI1bWtRdFoyQVhKMFhIRWdKZlhQSk01Yk5CYk5GOTNoSk83?=
 =?utf-8?B?QlgxTXBqeSsvRTNGZ0YwTWxWeWZBVTlWeW5UcE9rK3NzME4rTkdiM3FGYWFZ?=
 =?utf-8?B?ZmdWVzExdzJxSkRLQ1RUVjZhK2JJSTY2dEM3WDhKYUpZeUFUSnkzUHBkamVG?=
 =?utf-8?B?bjZTakUzMElZWm50VUtyQVN2ZStqR1Izd2MzT2hvZnJ5UTRtK3NzbEdiZXo2?=
 =?utf-8?B?OEdzMkpqNmNOZjlyWlk5TTRHU1lCV0REZEI0SkxkNkNueS9zaFQvMjRKMjZJ?=
 =?utf-8?B?ODVDdGluM0hCRDZBZmkybXpTejRlSnlvMVU2ZTFNU1lwbzBmRmZpY1dMU0hr?=
 =?utf-8?B?V0RyRmhZSDBHN0srT09ueGF1SkVZZ0VyTHgrVjNRdlg3RldFK2ljc3JVUlha?=
 =?utf-8?B?RTg4amZsbjhZWmR1VFRCSXNZT1c3KzE5Y0hBZmZFY09RZXRTQXVVTXkyTUli?=
 =?utf-8?B?Ui95VDJtaXRsL3VDNTRoRHFzOStTWmk0TFE1MDh5d2ljWmx5SUxRRCtQV2NQ?=
 =?utf-8?B?a01RNGRLaWVML01NeFhWM2xPcmJlTTRLN05RUElCYWZhWEY1OG9ZS2FtM0t2?=
 =?utf-8?B?NWtQNTJWdU10VlBPTzNQVWZiQzF1OElyZlNzOTExSStLQnJwaTFkRVVIR0Ew?=
 =?utf-8?Q?TXVmoayUw0nLjBJwo2tLk8/vg+nJTuHc4C4AZOX?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b50dd591-412c-4366-4634-08d8e962c77a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3503.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 16:36:14.0758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gXkJENmvjwjGG+PJz5S/vIsRRSzmntB0E8zJmYaAh6NhV01y2J+UdzMC6L3TvXA8dRh5VYKuLvs6sa9GNoH6VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2846
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Thanks for finding this!

I tested the series and currently the binding to vfio fails. The reason 
is that it is assumed that the objects scan is done after 
vfio_add_group_dev. But at this point the vdev structure is completly 
initialized.

I'll add some more context.

There are two types of FSL MC devices:
- a DPRC device
- regular devices

A DPRC is some kind of container of the other devices. The DPRC VFIO 
device is scanning for all the existing devices in the container and 
triggers the probe function for those devices. However, there are some 
pieces of code that needs to be protected by a lock, lock that is 
created by vfio_fsl_mc_reflck_attach() function. This function is 
searching for the DPRC vdev (having the physical device) in the vfio 
group, so the "parent" device should have been added in the group before 
the child devices are probed.


I did some changes on top of these series and this is how they look 
like. I hope that I do not do something that violates the way the VFIO 
is designed.

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c 
b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 3af3ca59478f..9b4c9356515a 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -578,22 +578,32 @@ static int vfio_fsl_mc_init_device(struct 
vfio_fsl_mc_device *vdev)
                 goto out_nc_unreg;
         }

-       ret = dprc_scan_container(mc_dev, false);
-       if (ret) {
-               dev_err(&mc_dev->dev, "VFIO_FSL_MC: Container scanning 
failed (%d)\n", ret);
-               goto out_dprc_cleanup;
-       }
-
         return 0;

-out_dprc_cleanup:
-       dprc_remove_devices(mc_dev, NULL, 0);
-       dprc_cleanup(mc_dev);
  out_nc_unreg:
         bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
         return ret;
  }

+static int vfio_fsl_mc_scan_container(struct vfio_fsl_mc_device *vdev)
+{
+       struct fsl_mc_device *mc_dev = vdev->mc_dev;
+       int ret;
+
+       /* non dprc devices do not scan for other devices */
+       if (is_fsl_mc_bus_dprc(mc_dev)) {
+               ret = dprc_scan_container(mc_dev, false);
+               if (ret) {
+                       dev_err(&mc_dev->dev, "VFIO_FSL_MC: Container 
scanning failed (%d)\n", ret);
+                       dprc_remove_devices(mc_dev, NULL, 0);
+                       return ret;
+               }
+       }
+
+       return 0;
+}
+
+
  static void vfio_fsl_uninit_device(struct vfio_fsl_mc_device *vdev)
  {
         struct fsl_mc_device *mc_dev = vdev->mc_dev;
@@ -642,9 +652,16 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device 
*mc_dev)
                 dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
                 goto out_device;
         }
+
+       ret = vfio_fsl_mc_scan_container(vdev);
+       if (ret)
+               goto out_group_dev;
+
         dev_set_drvdata(dev, vdev);
         return 0;

+out_group_dev:
+       vfio_unregister_group_dev(&vdev->vdev);
  out_device:
         vfio_fsl_uninit_device(vdev);
  out_reflck:


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

