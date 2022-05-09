Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A93F51F4AE
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 08:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiEIGs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 02:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235240AbiEIGjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 02:39:55 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C1798F45
        for <kvm@vger.kernel.org>; Sun,  8 May 2022 23:36:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdcRcmac63tlzkwA3CQCzBP5iVS1MFSlyD18mCl6uBG3Gm8zHYbglxidizrJzhELQL8egnx4c4bPJ8P56VQ82wTTTBb7vwzl0TLjGknYcil0UfYz3+AU0VhHLbFpsMsMTFmJrVKeoUa7iq8AITuhbZJym3Rz9/JOxSP9Pey56Nak1gHUX3G9Cw09yNF9fEFZ44tjSWB/7PJrbpk5W2J7C3mEniyrJe3T6Vq7qMF797/w7oxhGIcdS+lTDYDrNBcf+j4byenE0TTJId0PaTCMybPzG/W54dPGic8Mv7mjC7Gob18uAktREk+AvEghDuptJT2woHLBei+Oqc+a9QAySg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbeLt4bFAv+W+y7bxSwkoGj2WIbesfLZ6pryAtK56w8=;
 b=Jt6QlyY/MbicnEHOK/9+rXkE7FtccAf2XO2Ms0nEDjrRxgKtlI6h+wt9RaacO9kHr/D3qssIfUlKrA/9jT8UO35c+P7f+jSgtrEFyTXAJ+MqgAKLu4jLyuZvu5JzNlecm6FSN2h9uX2I/QYcD51/nuUfiYTb3DOBWgfEEMPYBhQFd2/+O2QTFMmEHgZs84A2n+xRvDCl0Rfacz6jxHcaaC0olqT2+Ew3gSJiBUxX3ZS5WV9Rs41EQrXCWHvAmfYle1y2uXkESMHQSDMoPLZ0kNwNoW/W9F91kbkSlJZ82moDIkTaJVcXruUS3qmubkQd+1Iv+8OXudFt5dyaEyAt9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbeLt4bFAv+W+y7bxSwkoGj2WIbesfLZ6pryAtK56w8=;
 b=Us1jA7M2j8FLkM2Z8zf5Vm4X2ODzWhvKGdWcfPRjMgUW5ixH7Izf+x9H3D92dy7zLsbuGdxvbCICgTkGATkK7HoWtfc+Aci34o9d8S2YaBeNtUugcHIAIB2OoFYyy96U9P/NYgWfeUi2a7L6fcUrhHqHxiNN0JCU3OL+kPoEhEUbZfiRbJirSYR7FJtAS8UvxQeyJsAbMXH3j6pJ/5heVBHoWNxy39I6Z2UVJUSVroMynK6Q/O8srQFczJnjRxNudwhBtz9UAuzHuukqZGAjIazFnubgbYCUPbaj8IcVmQEg4Z74yhpxMCHMH48oIQ55zi9n5RJ449Ce0fr4fHMsFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by MN2PR12MB4520.namprd12.prod.outlook.com (2603:10b6:208:26f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 06:36:00 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d%8]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 06:36:00 +0000
Message-ID: <42a68dc9-dbae-b3e3-5fd4-7bd71bf1d723@nvidia.com>
Date:   Mon, 9 May 2022 12:05:49 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v4 1/2] vfio/pci: Have all VFIO PCI drivers store the
 vfio_pci_core_device in drvdata
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>
References: <1-v4-c841817a0349+8f-vfio_get_from_dev_jgg@nvidia.com>
From:   Abhishek Sahu <abhsahu@nvidia.com>
X-Nvconfidentiality: public
In-Reply-To: <1-v4-c841817a0349+8f-vfio_get_from_dev_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0047.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::18) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4915307f-70ec-4f21-58ce-08da31862e8b
X-MS-TrafficTypeDiagnostic: MN2PR12MB4520:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB452067730E09072028434BD7CCC69@MN2PR12MB4520.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jNVfWIPH/1th4C07E7aEBYEGEOGCtBMlWPv1hJmEuiVjMVexeaMiRX/I48Iefti+J2tf1NTcqCy+cuwqZuyZ9OK4kyATPp98XVqmCJl0rPqfLpGkKPEut6TkO0IJWIxiZ8CBWR396EqvoSbkvDaEAmmu8Lns9r1By2vLqEcxuoICe+JWC7MlbTz+TTSakwPHu/QPClXo0xjS5+J8cgba8VUAoDIkwvUp9bwdNI3S+42HOJfHPfsInQbUNZCwzTBMvZ8O08MjDhDbT3A148QAZfavV/Hap+uVSpU+9GFhMRbRinJbUD7rYjcx/aTsimNs2sp/OQlE20mNJyk8BD0pzMYJdAug4Ltd0W7edd29YssjaDRgeSFM9cm4jv3/fiWYP/vF8ctjW2TpZ6SKnACwxCn8sdnEveyK2BP2PgLrhjIsgMLgzh4wDsujolrg08j+LKBBctDqk0lh7xFC/Jqq/2PKQwniv2mewbURL4xDhZij2Cybd7+jw2GvufZ6klBedEk9d20Sy+LuSuW3xXy/V7gRaqqKhOZQ3YetMQkwK0xKJHxgS8YYqM6IjFnxibTqCiqrGF37h4/dpP0ZwTjlzVlQFwdHR8nITN1otSURFaeKYc/1goZ0kO+tzyBcngz/hCAGy8G+46U/Ck6u4MBNgvXLpuTH69zgLYSxQfC7zyZGZFa9tcczmq0ttXDU7AC2uyUyJGuP4zyTX/DdwVsMhwiGya8dwXWQDXXLPoqZyck=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6636002)(5660300002)(8936002)(38100700002)(508600001)(107886003)(66476007)(66556008)(110136005)(31686004)(36756003)(186003)(66946007)(26005)(31696002)(2616005)(6512007)(86362001)(4326008)(8676002)(2906002)(6666004)(83380400001)(6486002)(6506007)(53546011)(55236004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzU5eExNYThMYVMrRGVpeVRnUnVwWjdhaGFTL0tUdXNybzA0bmFDeFl4V3Yr?=
 =?utf-8?B?UDYxblByMlJVY05HTkhHUDN0ZTdZcHpQSmpWc09JL1lxSXBmUCt6T2VpNTBh?=
 =?utf-8?B?cEFyOVIyaGt1SW85UW9XQjBRd1A3S01XOWRzN0xuQ0N3dzR6aGhFUEN1Nkhi?=
 =?utf-8?B?amR6cmw1c1Rxckd2SFZpSng5bzVHM2lPL0ozdkljSWEwbGxrdlZMRXFROHZI?=
 =?utf-8?B?aFhnd3EzdldQaENzaGI0K0Rnb1FZUU44R3gwUUNZSkVzNHc4RnprSzhyQnVP?=
 =?utf-8?B?bTg0ZVRHQUxRdkUwUEN1UmNVdklCaGJFVDFLdFVRZHNTd1lMamR2V29PcVgx?=
 =?utf-8?B?L0VQZGRBRkh6Q3hwTjRzdmJ0UVRFT2t3YnNVK3ptdUNodGlWZXZwNXdnU2Ry?=
 =?utf-8?B?NW9ML1VYclRKYm02bU1ockpUSEhuMDhUZ3BJaEVQMHpURnVoemR2YXBhMlho?=
 =?utf-8?B?UE42WXVwU25jc1l3YktxYmg4UUxUMmd3OHhuRjRsMnZWNVY0Vk1LenR2NTVW?=
 =?utf-8?B?b3IyU0Z4eHQzcENReWIxbStJRDM1a3p5aEZIdHFEZ1VCckY2MklYVmlzZmUz?=
 =?utf-8?B?aUM3VjQrZ0Uza0NOMXhSVjBNZURXdVpwcVFGQmQ3Zlo0cE9nVFFkSk9KMFY4?=
 =?utf-8?B?MVRmaXp0VnRkaE9zbVNEZTVpQkpFeFpUV05sWGR2bGZOMktWUXNidlQzdVRo?=
 =?utf-8?B?UXhiUnBwbEcrbTMwdHBlRnNPRUt6RDQrU0V0S1MrdjVWa0VnR01wbCsvdW1Z?=
 =?utf-8?B?MWN6dnUrWTZwVWEyd05XY0JjdWl1dWtQYk9OMFpHSDBPMzM5bk5XZWo1dVdj?=
 =?utf-8?B?NlBDZzhQcWRSb1lNVzF2TnpCM2RjekIvRVF1UVpjZTNtMHZ0ZWo3TEJCQUpa?=
 =?utf-8?B?Z2N5RWV3Y0RPZVVlZ0dGM0FpbnE3QVd2Wk5HRE51Y2FQN21nckVoenRwK2tt?=
 =?utf-8?B?Uld2bjJPREg1WDlJdW9MUkw5cDhEWCtnMldHZUM5NjRJWUF5a1E4Wnd4K0lX?=
 =?utf-8?B?SFBCdGx0RlpCZmlBS0F6VS9sV2xDNDR1VGFFMFljb0lRR0laMUM0Y1pBbzc2?=
 =?utf-8?B?cEViL2VLbDFZaW9uSVNwSGg0Qi80eDlJUENhRnVBNXQ5ZE5QYjRrSWlPOW1t?=
 =?utf-8?B?OHR1cXplZTRlbzFkZ1E2TEtFbEJlNVFSSFVFbmdkVmJNRlFKd2dtbndmQzZm?=
 =?utf-8?B?UTMzcFhsVloxSWxQQ2wwcVVxaE1WRkhNaEVMM0l2R3E0R1ozQnh0SDBjQkkx?=
 =?utf-8?B?UXYyUE9hNjY4NGdyNlVjeEVEY2YrYkRjQlg4QnMxZ1hBTVBxei9QMXdJYmJp?=
 =?utf-8?B?OVR0SVpaMmgxS2RaRHJzWmNCZTdVY1BqQ3pJZUZzd3VNL3VxM1kwSEF6NlZH?=
 =?utf-8?B?M2l5akxGQjVwci9nUkFtU2RZOVFqODJrcEtSY0xxeStHL0NoaUtnNmw0ZFV5?=
 =?utf-8?B?dHBmdTNLSy9YRHRUVlRESzBHWXVBTUxUNmN5L0ZEWWhYTXpvMWdrKytUWFlj?=
 =?utf-8?B?NE0zMnZkZTE2LzhXSzRJQ2NZNm5xZWJBSkhldGZjU0FZVkpyaGQ2NHUwSDVH?=
 =?utf-8?B?dUE2L0JJSXNuREVyUHY5NnJmbk1uTlVQUVFmaWNaV1BpL2hwQTZRTERkS3Jp?=
 =?utf-8?B?Q25kR3BXNStBZSsydXlQNGVRWDFmNU9WUlNrMytBRGh2N0J6L0xLSmV4SzQ4?=
 =?utf-8?B?cWJvL25HMjRPVVZkeGxSTkE1UFVYaHNROERta0UxckN3U1FKb2FWZWNBN25N?=
 =?utf-8?B?UDZyMmFrNGlNZ2NDb2RiZVpJb3Y4Nit6RFZpZXJrd21KL0tnK0p1alY1MGNK?=
 =?utf-8?B?RXJKSXhMSlNOR1pRazB6Tmpkb2w1RGp6VmVSWUh2ZUk4WU9PMGZWMkZreGt5?=
 =?utf-8?B?RGdqU3hvUnNRKzVwQWdXcC9pL2ZwTUFvZG5TZWQ4L2ZkTC9nNzBYZXBNRmhQ?=
 =?utf-8?B?ZlZsRUZ4UGdjMXF0NTkvYnNrbTZJWlZBNmZzd28vWVdudVRoWTQ0YmZIRXVv?=
 =?utf-8?B?REwvRXkwV3c0WkNueE9HNXVXTGZoSTFDU01Ud2huWUdiT1JCMDc0ck1rNTFl?=
 =?utf-8?B?SmREY3RYaktWb1ZGZVNRYlMwWlBaN0ZUYndBRzd3MFl4bjlqUTJKaWNWL1RC?=
 =?utf-8?B?WWNMM2g1S01RZlBkMEdSQW4zRlFiTkdJZnRIU2dPczEyekNGVjNiVWpCV0hU?=
 =?utf-8?B?bDVTZlI0S0J0UFdvbDFubUc2cVdHa2EyZjlBOGFyWGJjU3ZOVXRWdkFaSk9u?=
 =?utf-8?B?ZFJmU2FudnoxWUg4Y1lGSWY2S0sxeTl3bUNIT3V6bDJTWHczSi95SzhMV0N2?=
 =?utf-8?B?c1hDREF5VjNPTVFGQlVaSDhBcUFuNlRsVE15cXRlMlFPTHFSaHQrUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4915307f-70ec-4f21-58ce-08da31862e8b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 06:36:00.6058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s6MrqfThSk/6Zit7yIGye/Hs7rDnJmlc9mIs66Si0qq9sPymqjLkHbq/LiOMphvLAXbqWcKbVS69JXygrCb58g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4520
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/2022 4:51 AM, Jason Gunthorpe wrote:
> Having a consistent pointer in the drvdata will allow the next patch to
> make use of the drvdata from some of the core code helpers.
> 
> Use a WARN_ON inside vfio_pci_core_enable() to detect drivers that miss
> this.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 15 +++++++++++----
>  drivers/vfio/pci/mlx5/main.c                   | 15 +++++++++++----
>  drivers/vfio/pci/vfio_pci.c                    |  2 +-
>  drivers/vfio/pci/vfio_pci_core.c               |  4 ++++
>  4 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 767b5d47631a49..e92376837b29e6 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -337,6 +337,14 @@ static int vf_qm_cache_wb(struct hisi_qm *qm)
>  	return 0;
>  }
>  
> +static struct hisi_acc_vf_core_device *hssi_acc_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +
> +	return container_of(core_device, struct hisi_acc_vf_core_device,
> +			    core_device);
> +}
> +
>  static void vf_qm_fun_reset(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  			    struct hisi_qm *qm)
>  {
> @@ -962,7 +970,7 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
>  
>  static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
>  {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
>  
>  	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
>  				VFIO_MIGRATION_STOP_COPY)
> @@ -1274,11 +1282,10 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>  					  &hisi_acc_vfio_pci_ops);
>  	}
>  
> +	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);
>  	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
>  	if (ret)
>  		goto out_free;
> -
> -	dev_set_drvdata(&pdev->dev, hisi_acc_vdev);
>  	return 0;
>  
>  out_free:
> @@ -1289,7 +1296,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>  
>  static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
>  {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
>  
>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
>  	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index bbec5d288fee97..9f59f5807b8ab1 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -39,6 +39,14 @@ struct mlx5vf_pci_core_device {
>  	struct mlx5_vf_migration_file *saving_migf;
>  };
>  
> +static struct mlx5vf_pci_core_device *mlx5vf_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +
> +	return container_of(core_device, struct mlx5vf_pci_core_device,
> +			    core_device);
> +}
> +
>  static struct page *
>  mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
>  			  unsigned long offset)
> @@ -505,7 +513,7 @@ static int mlx5vf_pci_get_device_state(struct vfio_device *vdev,
>  
>  static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
>  {
> -	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
> +	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
>  
>  	if (!mvdev->migrate_cap)
>  		return;
> @@ -614,11 +622,10 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  		}
>  	}
>  
> +	dev_set_drvdata(&pdev->dev, &mvdev->core_device);
>  	ret = vfio_pci_core_register_device(&mvdev->core_device);
>  	if (ret)
>  		goto out_free;
> -
> -	dev_set_drvdata(&pdev->dev, mvdev);
>  	return 0;
>  
>  out_free:
> @@ -629,7 +636,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  
>  static void mlx5vf_pci_remove(struct pci_dev *pdev)
>  {
> -	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
> +	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
>  
>  	vfio_pci_core_unregister_device(&mvdev->core_device);
>  	vfio_pci_core_uninit_device(&mvdev->core_device);
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 58839206d1ca7f..e34db35b8d61a1 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -151,10 +151,10 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		return -ENOMEM;
>  	vfio_pci_core_init_device(vdev, pdev, &vfio_pci_ops);
>  
> +	dev_set_drvdata(&pdev->dev, vdev);
>  	ret = vfio_pci_core_register_device(vdev);
>  	if (ret)
>  		goto out_free;
> -	dev_set_drvdata(&pdev->dev, vdev);
>  	return 0;
>  
>  out_free:
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 06b6f3594a1316..65587fd5c021bb 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1821,6 +1821,10 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  	struct pci_dev *pdev = vdev->pdev;
>  	int ret;
>  
> +	/* Drivers must set the vfio_pci_core_device to their drvdata */
> +	if (WARN_ON(vdev != dev_get_drvdata(&vdev->pdev->dev)))
> +		return -EINVAL;
> +
>  	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
>  		return -EINVAL;
>  

 Thanks Jason.
 I have applied this patch locally and confirmed that my power
 management changes works fine without my dev_set_drvdata() patch.

 Regards,
 Abhishek
