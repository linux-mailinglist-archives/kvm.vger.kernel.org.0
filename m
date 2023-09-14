Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65D57A0BCB
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 19:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238993AbjINRcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 13:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbjINRcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 13:32:03 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90B59B;
        Thu, 14 Sep 2023 10:31:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7m6P628o36NRi1lAVrT7ge1u6nmsOyxNgtW4CgDXmRdwZxI9Tj+gQVDNXx7C6E8ZRqG6N8WPumLDDYWxA+g5h1KppPFCga0w+cXkOi8Bn+OH3qYrZrjn6AOb5DjTAj4TGSZgwHmgnhBiDjRb20sozkTLCZtgZgGmN/OSBK1AMhNpnb6b8kxfZ7SMomOixyYXik7LuaBMlL4PzwMGUxKP3n8pMOdSoB7HkUt3ulB8jLc7PPULjODXue919EUGRwE1yJn/D6AHmjvUCuzZ11Cxa0cID3NK9avrmmctLvhNu+Wrlh0JM3PFvEz71hGTPpFz3628+FGmuzORqhfgDjeuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ju7DBkHVThJ1aNIxhtSMONfc6y6/YfGIYo5m4YyRJgk=;
 b=k0pzVqD+RZHGm3M4+SYHwwdwPBZcFXKkgc60ahKza7q8SmYVPdmXrDsSZ58Tkvpztl7HPK2LbDg91RY/LJIfVryHU8GYfCVJXCchmRbNTaj6qNHK7C+vhrqj3mRKQNXbuYKpIlHZz2npMydkDOAedX99OK2EqRLtyn+j9HMamBhog4B/54jKEda45IG1g6ZwsgOA3t90B1O7IlpQ/AJBFgHi6MjcJtL9VGnunrfbZ1i6tjysijs4flFSywuxSmrZSjp3M2Z6rvtLaXDD5yfvi6EbjU4yQdZc+2+s4QOIGH733QDsSE7sl0JRTzHd7/NGrvZtVtYqOtUi+piYq5yrPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ju7DBkHVThJ1aNIxhtSMONfc6y6/YfGIYo5m4YyRJgk=;
 b=VUsJsD+ai2GnqT6v1E0GI0gCWk3O2BNFh1QJ6U5eF5+MrLpS+N9bmBtnhqgYr/S+sDz2dctycA8NAazGVYDGagT5xoGWFP8RjMm5YIygiJvkKY+GlIjIfbKj7axrt2tg7+h1zFEVqfYMb8bwpyCZzfCod71braz1vjPfRzta0k0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SA1PR12MB7038.namprd12.prod.outlook.com (2603:10b6:806:24d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19; Thu, 14 Sep
 2023 17:31:55 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%5]) with mapi id 15.20.6768.029; Thu, 14 Sep 2023
 17:31:55 +0000
Message-ID: <08009a16-f6b6-f644-406e-ea3dd0a858f1@amd.com>
Date:   Thu, 14 Sep 2023 10:31:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] vfio/pds: Use proper PF device access helper
Content-Language: en-US
To:     oushixiong <oushixiong@kylinos.cn>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230914021332.1929155-1-oushixiong@kylinos.cn>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230914021332.1929155-1-oushixiong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0117.namprd05.prod.outlook.com
 (2603:10b6:a03:334::32) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SA1PR12MB7038:EE_
X-MS-Office365-Filtering-Correlation-Id: 62859b52-b507-43e7-eccb-08dbb5487d94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K6DmhzhNBYrjEM3ML2dNeooM6nsxPHKqAQLeWzqVy/8lL2MPiXeW+ScteGiortTND6W4RfN98U7coe8924/zWvSI/lb1dw0bwHMEurmWCOnDvLUfEDEbSaA+cDjXVGO2q6bxapm2b1pQ+K+jl4Zy8VINN8pnQHCB5VbQjOMEql0RWjIa9kIx+/9SPmW2OW61B/5aIjKM1SfMVwY9djBwiN2clM6jKvQPhFUzuJUScZfNtMSzk/yopDeznf0ZjkEk4FmtwtzwHTcKtpBX4MxdEbYcfFBK7Br1gvo5+A9AQRK8kj1sHX3gazCLzY90mWs62KUOwvRmg68zVoTtt9VVVrnk5AztSdMelRNfNMq9fA3jAu9w3OsCUK8bv2FYztQmpnxKX/sopvquFcl8TPZrMREM7npjj8ER2dsnh6yzx73Z0Iu3pINIZ7pBZL5NrZUC/4MujMgn/BtpjAvon8dCddA6Ne5U+m3TQXPy9EuPZwyX/DPS3H+prmA61cHwGZikR+8KhiqUwZBXO0OXoxl/6/QEBeiLTwhPUiy+7sPCmA09Gh2eCxKPZzMnttp+HlHju0m+w6h3V7kTrFTYAzA1v3vD02tfsq6pbNwc8rp5zD7rZRJqlYveU5EsBSO3wcwA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199024)(186009)(1800799009)(478600001)(6506007)(53546011)(6486002)(6512007)(26005)(83380400001)(2906002)(8936002)(54906003)(66556008)(66476007)(66946007)(2616005)(316002)(110136005)(5660300002)(41300700001)(4326008)(8676002)(38100700002)(31696002)(36756003)(966005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUZsV0JhN2Z3aTRIRzZibnM2TXptVjVDTzVYVXRNNzVKVGgxd2ZUNXVKT2xD?=
 =?utf-8?B?b2lLRzJ2VWFQcFVlSGhnV1ljRkJ1VUx0cVRhZFV1d0QxSEEzQVQxZHlFbVZS?=
 =?utf-8?B?eFBFa0w1WGYwZitVMk5lejd1ME53YjNBbGExYUdFbnJuNndPK3dFdFdJeG1l?=
 =?utf-8?B?ZUhTVEkySnVKcE5BcDFudk90bldSczh4MXRPMWdFaVliYjR1QTFaSndGRFFo?=
 =?utf-8?B?Q0gyZkxKS1BFbE9TVUlueW5remdBSnNTa0FhWHdnbXRRZEZRRUtrY1RHMHp5?=
 =?utf-8?B?ZklNazM0YXBoNUxDWjdReERCMTFQZTVwRTY4eXA5S3c5eG56Q25xYVFwWUlJ?=
 =?utf-8?B?RDJlUE5KY3NBZUhUOExtSzJLVkNDblRlSUJSV3RWK2Q5eDFYRUo2Vlkrcml6?=
 =?utf-8?B?NTBFeGRiUmV2Q0ZHbXVtMXRSdmJJYWhwTzdWWUtTWW40UWYxbTIvV0pHY05F?=
 =?utf-8?B?OTg0WnlXYUJ3NWF2ckxydlkxWGFRZnZOVGRkZUdQb3l5SnlVMHRJcHZlTFF1?=
 =?utf-8?B?VHBJSUdVYmxVRVp4bGRNdUo5TTg2Z1J0L1FkTjlrVEhiQnJCRGUyVVRMME4y?=
 =?utf-8?B?a08wRzEzSXFETXFNM3NzZnlOdDhSajJuWXVYbndlZGFFUjdTMk8zVHdLcDJ0?=
 =?utf-8?B?K2V1aXpiMG82cmVKZ3VyNjlPNkNPSHBrM2FWWTBkN1NKeVU5M2FRekFzNEFo?=
 =?utf-8?B?WnZTWTBYU2ZpSnkvYUNSL0JEd2lMZTdMUklSTUpUeStaM0hnMStzZEtZTDZm?=
 =?utf-8?B?WC9hamV6Nmh2Z1dHNUZuWFQwWnRCa25LV0h3QVhJS0lJQVhXYjRhbkYvUG1n?=
 =?utf-8?B?OFBqSVZYZU5BcWtrY0xHVjZGSFM5VHd6WlhlZ1BxWjdGd0NOTk5PeVhXYTcv?=
 =?utf-8?B?bEIxUXVFZlNTVlEwUHM5WXg1cit3WjhwajJLRGNWRXc2blJhRDFCM2VndmRW?=
 =?utf-8?B?d1NmUk1hbFZCNW5SUXp4aTJrQmd2ejE4NnRQMUN3QWZJV2IxbUhLb21mS3J1?=
 =?utf-8?B?QllXVSsyL1A3cUtvT21kQXBINnNBWGVXTitSYVoyZjcrQUlVYmozQXI2Q0k4?=
 =?utf-8?B?TjZ2cXN3NFQ1S0kxeXFSRWt6QXQ2TU5Cc3p5eGQ5MGJXbytwRGdQQ3U1cGVl?=
 =?utf-8?B?anNpMkRacUF3MnVrNHI5dGZpd05OaEdVSHRsVkdLcGxUR1h3V0ZBei9aTHhs?=
 =?utf-8?B?UExPRGJIQXlJQnVCUy9uVUVHSG0yMURqY2RjSHdJb3VJbVNjVkg0NjlaVTNC?=
 =?utf-8?B?eWxMUHU4c3MyZzZuTmJzREhoYS8yM000ZERZaThaWnhWSXNHQjBFMDJnWUpY?=
 =?utf-8?B?Q2loSGpUcVR5WXN1RGZWdFhrckx2NDBhK2Q4azhxUHNpeTJnUzZVYkxTcXVG?=
 =?utf-8?B?c2tCNy84ZjNrRkw3SUxVR21sWVZsMFlSa1VZMlgySWdrdlRVWWpXWnNtL0Qx?=
 =?utf-8?B?VlNZWWRhcDU5NmNtblRwWDRUVXFtdjRHRjlGQzlQbnNPMnMrRDlYYWMzT2xp?=
 =?utf-8?B?SW1oUDIzSmFiU29xcmsvaEhOQXVYUXBIdTQ4bk9NeHZ2YXI1SlVVdTNUdWRi?=
 =?utf-8?B?Q1pncDEvWE16N05CWVVKRW1rcmJWb1BXSnFwSWVDcmJWQ1J1YzhTNERJRTVn?=
 =?utf-8?B?c3pKNzdwN1h3UFMreGdVc2YvSmplZVNMamJMejZrNGNhbTBWOEk3UGlOUVRi?=
 =?utf-8?B?QTNSQTdkYjY3a2IybTcydGtIUzZJRUdVMC8vRmhTeUUvWXB1eWhaeFIwaEZH?=
 =?utf-8?B?T0xsTDZrSWsxdnZVSENhTCtjK25jNXBucFQ1ZkJrSDN6QmNZeTVUUSs3QjZU?=
 =?utf-8?B?b01aTWtlSFRPZCthOFFudHVCUGtxUlVnVkZLd2xydE51ZlpwVXVNL29RUThL?=
 =?utf-8?B?am8wZk5iTHZNQUpSdWM5N1BCY3pzQVRVblU2QWl5ZlNYME5Vb28vdzZJMVpH?=
 =?utf-8?B?b2lTaEJPN20wdHFSczFaZkVMTzZEMXFNa2hYWG1OdTZJWXdwaWIxWXErS24x?=
 =?utf-8?B?VnpTeTlWbzBSWHUrbU55Q0tCVWJZcXBRVWVMWStobzQvZGQ0QU1ONVVmUzlT?=
 =?utf-8?B?eDRzb1prdWZDcHJWQ3VhV0dBN0FZTjg1Z3JzZXovd0hlZ1ZRYXhRaWpTOUJP?=
 =?utf-8?Q?9bI9HykKzfAlq4TMVp8c3R4iA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62859b52-b507-43e7-eccb-08dbb5487d94
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 17:31:55.3406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Vp3Cm4AvcBFYNs/xIwDpoVMSipevF3CaPTbbuAlXfO3fXTv3uwFhATfKRrf+eC9CMODx9qPH+lwVPjIkFJPxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7038
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/13/2023 7:13 PM, oushixiong wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> From: Shixiong Ou <oushixiong@kylinos.cn>
> 
> The pci_physfn() helper exists to support cases where the physfn
> field may not be compiled into the pci_dev structure. We've
> declared this driver dependent on PCI_IOV to avoid this problem,
> but regardless we should follow the precedent not to access this
> field directly.
> 
> Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
> ---
> 
> This patch changes the subject line and commit log, and the previous
> patch's links is:
>          https://patchwork.kernel.org/project/kvm/patch/20230911080828.635184-1-oushixiong@kylinos.cn/
> 
>   drivers/vfio/pci/pds/vfio_dev.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
> index b46174f5eb09..649b18ee394b 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.c
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -162,7 +162,7 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
>          pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
>          dev_dbg(&pdev->dev,
>                  "%s: PF %#04x VF %#04x vf_id %d domain %d pds_vfio %p\n",
> -               __func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
> +               __func__, pci_dev_id(pci_physfn(pdev)), pci_id, vf_id,
>                  pci_domain_nr(pdev->bus), pds_vfio);
> 
>          return 0;
> --
> 2.25.1
> 

LGTM! Thanks again.

Reviewed-by: Brett Creeley <brett.creeley@amd.com>
