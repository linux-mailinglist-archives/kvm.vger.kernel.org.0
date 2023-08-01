Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4A776B8F2
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 17:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbjHAPp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 11:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbjHAPpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 11:45:54 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C27A268D;
        Tue,  1 Aug 2023 08:45:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyLWLCvqrUb3h2offe9G39SyiiJr52rg76Sx8I8wShj6V0wbi6hJx38neH18tgXDsnyCOGkRfGDuV3uaa9FxxrR5yRA4tVdlHqT/FNHhaIZxPj9IXTv2EYR0yeqD36pOBCv0VzTPQj057cojNMSh7evCDfxD0H1sqnJ86bC7l8KSPZL0l0wkt1j0wAP01ROwJd2pxfe24G1+KkVUFsrKhgHDKfJm+1ooRGAYEkmUl2hvMM4YrxMRW6YAixINfLN5B0bx8V9jvf73ThuKa7OkD342VK9PC+qvVUQ0gufzccncdDOecvk6Fq2OFjUnkZ3Ac8d1w1o1kwaPWqorFzmKRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j/6f+rxKvC68jkXObWHTB8wnUqp+HLP0A21+w04Djj8=;
 b=UqkTKZk1PmPHrRh+13Gnop57jr9f21qayQI19xD9mEV+lVIqf+ZTuT3MzGTIo9GFtKREy4UW044bCEE8EFOQGx2bMJ59n9N73P0IPJ5Dl/RhOubsigI2J8oC+730J5GsPWfNekbEOGDF692Duyn/n/jGHgw5s2oth7oE0jmgNFHGaDrGzVjPRbRb+80JPuXTcQq+IVAyk2sMVMvWkOKYvofbWB863Ty2cczTC83SE2xuCmGd66AQPXcul0xDDD2YZ3OYw+2lbjaugsSq3dq34oCZ6VWV/Za07HgoUPnnYD5kej6ZGvzaNOaUiAGFB5yiTNfJW39nUi1iVG0kW69NXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/6f+rxKvC68jkXObWHTB8wnUqp+HLP0A21+w04Djj8=;
 b=IG+Wd/uMKG7+Nbx+Eo16vdq3AUo98r73TbohMdyhsbgUPHRfB/8Cxeij1zxj4WCKKFsNtDUBjkhul4lDWevNkXiaZyW0mF/YTGFNRO0KLLQWRyBF1qKbfDhGUcGOQaeJcOcTRHUqLBkJPKuvZKDpKV6wDjVUuPB8UouDABQVz1o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by MW3PR12MB4379.namprd12.prod.outlook.com (2603:10b6:303:5e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.41; Tue, 1 Aug
 2023 15:45:36 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf%5]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 15:45:36 +0000
Message-ID: <15b46c20-0dc0-26dc-f1b4-6b430c74fe36@amd.com>
Date:   Tue, 1 Aug 2023 08:44:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v13 vfio 3/7] vfio/pds: register with the pds_core PF
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, simon.horman@corigine.com,
        shannon.nelson@amd.com
References: <20230725214025.9288-1-brett.creeley@amd.com>
 <20230725214025.9288-4-brett.creeley@amd.com>
 <20230731145725.1c81e802.alex.williamson@redhat.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230731145725.1c81e802.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0240.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::35) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|MW3PR12MB4379:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a2da3ef-3307-4d3b-8657-08db92a65921
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uh4mrguPwgeralXLmWVwLyWbF3iBr4wCkqQDZJ+mnAfp9sZbxRApg9icP18fBp71WjI8JlXWSaJ4QVyLMFOaC85i1dC8pX7mWshLUHXb4W9CF67CLLTUtJtapSbug6Ddn/Yg0gKPeTwCMkXQx6PUpdtEUEifL225BI/7hXp9jwDwBQV+A0wArOHgJt5t/Dwl+irxbzew/ewoFtLXSHcPk5bI0rw2LitzE1JDr0ULTfpY2hRfhrZbOOv96NZ4twfw4z+X3CQH/rImhz5V/kICJfwnJfRQCWyLc3RhLHq4MVdzCJJAmv2iW//cRNpH/qEIeOdZCdHDhPoStCP60LqszDp2om+lsr++15ePheJrVq5YWSUCQgM2uW8BYGcfj0msEGCFQFuZl8QkmpQbIXfeJ96+hIKKC9iei8C3AzKHT9EcXA76PZC9jMX1CDoz7lndXBxF1645zx4Dzq+iv1UJ6cESQB+Jvm5h6jpddn5d4YJe07TeLg2QSMWyhSjP5/rmhFUPEeCQ+ANpm8PR9qitMpoTS3EpkjRkWYGb7SKLhzFSSvrqmXd989iRhm6EC9KaScdQOrE+ood7WFGkpEUgfPLarg70BDQHPniSTeNPmhadzeYcZQ+zqpUm49Go8CvAVTEQegNEDfT7BHKQIsUA+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199021)(38100700002)(66476007)(31696002)(8676002)(8936002)(31686004)(316002)(5660300002)(6636002)(4326008)(110136005)(66946007)(66556008)(41300700001)(478600001)(2906002)(6666004)(36756003)(6512007)(6486002)(26005)(6506007)(83380400001)(186003)(53546011)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXUrNTJSditwTGtmcDA3aDR1S2c3cVFSbDcwMDBWYWNjR1NDOGxuckVjVEJW?=
 =?utf-8?B?VWFJREEwNmZqSUtyS0J6bEp0NE5Nc1VjbXJLUHhZcUNiSFp6d2ZxM3VaOHIz?=
 =?utf-8?B?MTFBaENqZG5mMVFkNU0xQlpoT1lXNUlNbld2Mk1ob0s3UWN1eWU2VVprUWw2?=
 =?utf-8?B?MjJpVE8vVVRKSjBaWnhJMjM0Z2N2ODVHK1MvZzBxOHFtZTd3K0hEWEkyQ0Ns?=
 =?utf-8?B?dHlPckNuWmJQOGszRWRZNEY4bWVVL3F6SEYzZG5lRDlyOWxLWENnZWhpQ01E?=
 =?utf-8?B?Tkt6UTl2eFpOZmk4YWpBUithaXlQc0NqZ3I5aEUzZFpOR3M4c0xsei9lWFRs?=
 =?utf-8?B?RmFCOWFkMGxsV2xmWjd3VUdpdTBsV083UElFYnhwVUZGa0s1azhFSlA3clNw?=
 =?utf-8?B?WmhSdUZSTHFOMklKbjVtNmxVOThvVkNlSEk5UHFudElRWGV6Y3V6UldMWG9a?=
 =?utf-8?B?SXBpMFNtaWgyeTBXeVRmeWZoWVo1VGhWTXE3eDkwU1UvZEQ5T1ZpNStFOEtO?=
 =?utf-8?B?TGQrRHRXTGhJTytxVTk5bGZHWithOVlKdi92TEh4cFArekhoWWd6RFVuL2l0?=
 =?utf-8?B?c3A5LzA3S2Z4TlcrZ3VzM3BNWm4vaHRVcEhuUDNIdHhiaTFsQ2dtcFRFR09D?=
 =?utf-8?B?Z0MwM2R3Ukx4OVROZWVNWGVic2dVbDg1S3pCaldWdjVmVDNmYVdMUjZRcW12?=
 =?utf-8?B?WCtnM0w0U2RMaG1SN2o4d2Vqa3JUbGlqSjZaYlhKdHpwdTdUczlqZmt0MzVK?=
 =?utf-8?B?R2VYR2ZnRDQwWUhva0tPQ0FNcVdQNFJoWTN3K3A3YjFmQlV3bTJ2a3lFOEFt?=
 =?utf-8?B?WTJMbDBvM2FIRWNCN1ZDRUVNSStLZEEzMnhnUHJsbmp2WnlXYWJ5SkhNci9r?=
 =?utf-8?B?U3RuZ2tmMHhmLzJuSVhIZkhZR0pZMm02djVIb0hVS1pNN25zYWpjc2VVdm9m?=
 =?utf-8?B?N05UUE42Nlp4ZFFqNzQyVXhFbVNPcW5XUkVzV3AxN29ZaU1DT1dZcmp4ZWFa?=
 =?utf-8?B?WlhKMnRMNG5CQUNvWG1ScHQ4bXl0VDk3V3Mwa0VYLzlndDh0SU05dVlLc254?=
 =?utf-8?B?dFlSdUtCYTJGYUV4OU43RFdmSzEwT0drZ3NsZFJCaWZiL0xWV2RlTm16dGRK?=
 =?utf-8?B?Q0VHY3VpREFwWU0ySlVVSmtmL0RuSjNOZFBzTmQ5eUFEZFl2VzhoNy9wbk91?=
 =?utf-8?B?NysrZzRiZ2xBcHBEZFplc05aenJySENvWVAxdGZHVGZMYWxVM1g5VnR0ZU1W?=
 =?utf-8?B?aUtNVVVVZ2Z5eEFNWTBJMEdUZVdjbmQ5OXhEOTU1UDRPSzFOMGI1UVVPT2JC?=
 =?utf-8?B?SnQySDdjQkY4bFlRS0ZGTkZJT1dUeXozcXVNVy9MQWF5ZE41bzJlbVlVSmR6?=
 =?utf-8?B?UGtwRnJIUUNlT0RUZVhkamtTd2FnZmQ2STQ3dDNJQWx3UHFTU29DdjZDa3VB?=
 =?utf-8?B?TWhCWmRDcVpRb1FVcDlEbUoxeXZBcjFrTGpSb09RV1NDMWJkN0tzVU05Zm11?=
 =?utf-8?B?OGlUaDV0RHY1MURNSjRyMnZhTWpFL1pDVVBsZEpPZy9nbkxhRjQ0MGwwUmhh?=
 =?utf-8?B?N1pMZi9zQ2Z2VlpDajhNRlh3Zk5RUUFkdHhXZXBrYXh1L3B1MXRZUDlNUjA1?=
 =?utf-8?B?KzNhQ2dRdk91ZS9XTi9HMysrbzYrYUIzQ2haN1BMRGxpci9CQ01XV2Z4QXJs?=
 =?utf-8?B?NjRWNUFjWlIzSmFNcHkyL2p6TVU2Z2VMRnFOdnJyeExOTFU4WTF5ek5rVC9L?=
 =?utf-8?B?a2pJKzcxVmsrV1A2cE1MQUVaR2FrOVVTYUR1YkJ0N1VNWWNBUm5tOE1UTW53?=
 =?utf-8?B?VWNUelBSd1E1R05rUHYvYlZFYk5UZFBkSmVJNys3eDdyTllqcVNvRllPQ3JY?=
 =?utf-8?B?Q3VwYkZ1SFF2SGFiMC94Ty9nR1lzbUVKWDVmMUs4MmZZdjFwZFIzY2lpMFVE?=
 =?utf-8?B?QlFuOWhZWTRlZGlUYWZGZU5kSlRBTkFNY3VrcEtJSG1SemN2NXFRQ1dYbDZZ?=
 =?utf-8?B?UmdOK2xBQUxRRXNobDFWT2l3eWtoS1N3SytVaXZsQVVKZDdEUlc0emdkSUE4?=
 =?utf-8?B?TXBvdnFOdytZYnhHQ0pSV2o3RWNCWm1XVEc5TFhnVjlzOGtKbUw2NDFIdmtj?=
 =?utf-8?Q?DGiGxx00a7KVMYP0h1w4skB3C?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a2da3ef-3307-4d3b-8657-08db92a65921
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 15:45:36.2058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9GkSzAwPta+sy9LrudwcLwRA/b+pE3wc+LgydXas/JZirGOF6Lyt9H6uFV/ol8ItJV84ezq86Fgl2AsjGLpugw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4379
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/31/2023 1:57 PM, Alex Williamson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Tue, 25 Jul 2023 14:40:21 -0700
> Brett Creeley <brett.creeley@amd.com> wrote:
> 
>> The pds_core driver will supply adminq services, so find the PF
>> and register with the DSC services.
>>
>> Use the following commands to enable a VF:
>> echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
>>
>> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/vfio/pci/pds/Makefile   |  1 +
>>   drivers/vfio/pci/pds/cmds.c     | 44 +++++++++++++++++++++++++++++++++
>>   drivers/vfio/pci/pds/cmds.h     | 10 ++++++++
>>   drivers/vfio/pci/pds/pci_drv.c  | 19 ++++++++++++++
>>   drivers/vfio/pci/pds/pci_drv.h  |  9 +++++++
>>   drivers/vfio/pci/pds/vfio_dev.c | 13 +++++++++-
>>   drivers/vfio/pci/pds/vfio_dev.h |  6 +++++
>>   include/linux/pds/pds_common.h  |  3 ++-
>>   8 files changed, 103 insertions(+), 2 deletions(-)
>>   create mode 100644 drivers/vfio/pci/pds/cmds.c
>>   create mode 100644 drivers/vfio/pci/pds/cmds.h
>>   create mode 100644 drivers/vfio/pci/pds/pci_drv.h
>>
>> diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
>> index e5e53a6d86d1..91587c7fe8f9 100644
>> --- a/drivers/vfio/pci/pds/Makefile
>> +++ b/drivers/vfio/pci/pds/Makefile
>> @@ -4,5 +4,6 @@
>>   obj-$(CONFIG_PDS_VFIO_PCI) += pds-vfio-pci.o
>>
>>   pds-vfio-pci-y := \
>> +     cmds.o          \
>>        pci_drv.o       \
>>        vfio_dev.o
>> diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
>> new file mode 100644
>> index 000000000000..198e8e2ed002
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/cmds.c
>> @@ -0,0 +1,44 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>> +
>> +#include <linux/io.h>
>> +#include <linux/types.h>
>> +
>> +#include <linux/pds/pds_common.h>
>> +#include <linux/pds/pds_core_if.h>
>> +#include <linux/pds/pds_adminq.h>
>> +
>> +#include "vfio_dev.h"
>> +#include "cmds.h"
>> +
>> +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
>> +     char devname[PDS_DEVNAME_LEN];
>> +     int ci;
>> +
>> +     snprintf(devname, sizeof(devname), "%s.%d-%u", PDS_VFIO_LM_DEV_NAME,
>> +              pci_domain_nr(pdev->bus),
>> +              PCI_DEVID(pdev->bus->number, pdev->devfn));
>> +
>> +     ci = pds_client_register(pci_physfn(pdev), devname);
>> +     if (ci < 0)
>> +             return ci;
>> +
>> +     pds_vfio->client_id = ci;
> 
> Not to be solved in this series, but the documentation is wrong:
> 
> /**
>   * pds_client_register - Link the client to the firmware
>   * @pf_pdev:    ptr to the PF driver struct
>   * @devname:    name that includes service into, e.g. pds_core.vDPA
>   *
>   * Return: 0 on success, or
>   *         negative for error
>   */
> 
> But obviously it does return the client ID and cannot return 0.  Thanks,

Let me push out a separate patch today that fixes this.

Thanks,

Brett

> 
> Alex
> 
>> +
>> +     return 0;
>> +}
>> +
>> +void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
>> +     int err;
>> +
>> +     err = pds_client_unregister(pci_physfn(pdev), pds_vfio->client_id);
>> +     if (err)
>> +             dev_err(&pdev->dev, "unregister from DSC failed: %pe\n",
>> +                     ERR_PTR(err));
>> +
>> +     pds_vfio->client_id = 0;
>> +}
>> diff --git a/drivers/vfio/pci/pds/cmds.h b/drivers/vfio/pci/pds/cmds.h
>> new file mode 100644
>> index 000000000000..4c592afccf89
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/cmds.h
>> @@ -0,0 +1,10 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>> +
>> +#ifndef _CMDS_H_
>> +#define _CMDS_H_
>> +
>> +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio);
>> +void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio);
>> +
>> +#endif /* _CMDS_H_ */
>> diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
>> index 4670ddda603a..928903a84f27 100644
>> --- a/drivers/vfio/pci/pds/pci_drv.c
>> +++ b/drivers/vfio/pci/pds/pci_drv.c
>> @@ -8,9 +8,13 @@
>>   #include <linux/types.h>
>>   #include <linux/vfio.h>
>>
>> +#include <linux/pds/pds_common.h>
>>   #include <linux/pds/pds_core_if.h>
>> +#include <linux/pds/pds_adminq.h>
>>
>>   #include "vfio_dev.h"
>> +#include "pci_drv.h"
>> +#include "cmds.h"
>>
>>   #define PDS_VFIO_DRV_DESCRIPTION     "AMD/Pensando VFIO Device Driver"
>>   #define PCI_VENDOR_ID_PENSANDO               0x1dd8
>> @@ -27,13 +31,27 @@ static int pds_vfio_pci_probe(struct pci_dev *pdev,
>>                return PTR_ERR(pds_vfio);
>>
>>        dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
>> +     pds_vfio->pdsc = pdsc_get_pf_struct(pdev);
>> +     if (IS_ERR_OR_NULL(pds_vfio->pdsc)) {
>> +             err = PTR_ERR(pds_vfio->pdsc) ?: -ENODEV;
>> +             goto out_put_vdev;
>> +     }
>>
>>        err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
>>        if (err)
>>                goto out_put_vdev;
>>
>> +     err = pds_vfio_register_client_cmd(pds_vfio);
>> +     if (err) {
>> +             dev_err(&pdev->dev, "failed to register as client: %pe\n",
>> +                     ERR_PTR(err));
>> +             goto out_unregister_coredev;
>> +     }
>> +
>>        return 0;
>>
>> +out_unregister_coredev:
>> +     vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
>>   out_put_vdev:
>>        vfio_put_device(&pds_vfio->vfio_coredev.vdev);
>>        return err;
>> @@ -43,6 +61,7 @@ static void pds_vfio_pci_remove(struct pci_dev *pdev)
>>   {
>>        struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
>>
>> +     pds_vfio_unregister_client_cmd(pds_vfio);
>>        vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
>>        vfio_put_device(&pds_vfio->vfio_coredev.vdev);
>>   }
>> diff --git a/drivers/vfio/pci/pds/pci_drv.h b/drivers/vfio/pci/pds/pci_drv.h
>> new file mode 100644
>> index 000000000000..e79bed12ed14
>> --- /dev/null
>> +++ b/drivers/vfio/pci/pds/pci_drv.h
>> @@ -0,0 +1,9 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
>> +
>> +#ifndef _PCI_DRV_H
>> +#define _PCI_DRV_H
>> +
>> +#include <linux/pci.h>
>> +
>> +#endif /* _PCI_DRV_H */
>> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
>> index 6d7ff1e07373..ce42f0b461b3 100644
>> --- a/drivers/vfio/pci/pds/vfio_dev.c
>> +++ b/drivers/vfio/pci/pds/vfio_dev.c
>> @@ -6,6 +6,11 @@
>>
>>   #include "vfio_dev.h"
>>
>> +struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     return pds_vfio->vfio_coredev.pdev;
>> +}
>> +
>>   struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev)
>>   {
>>        struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
>> @@ -20,7 +25,7 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
>>                container_of(vdev, struct pds_vfio_pci_device,
>>                             vfio_coredev.vdev);
>>        struct pci_dev *pdev = to_pci_dev(vdev->dev);
>> -     int err, vf_id;
>> +     int err, vf_id, pci_id;
>>
>>        vf_id = pci_iov_vf_id(pdev);
>>        if (vf_id < 0)
>> @@ -32,6 +37,12 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
>>
>>        pds_vfio->vf_id = vf_id;
>>
>> +     pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
>> +     dev_dbg(&pdev->dev,
>> +             "%s: PF %#04x VF %#04x vf_id %d domain %d pds_vfio %p\n",
>> +             __func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
>> +             pci_domain_nr(pdev->bus), pds_vfio);
>> +
>>        return 0;
>>   }
>>
>> diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
>> index a4d4b65778d1..824832aa1513 100644
>> --- a/drivers/vfio/pci/pds/vfio_dev.h
>> +++ b/drivers/vfio/pci/pds/vfio_dev.h
>> @@ -7,13 +7,19 @@
>>   #include <linux/pci.h>
>>   #include <linux/vfio_pci_core.h>
>>
>> +struct pdsc;
>> +
>>   struct pds_vfio_pci_device {
>>        struct vfio_pci_core_device vfio_coredev;
>> +     struct pdsc *pdsc;
>>
>>        int vf_id;
>> +     u16 client_id;
>>   };
>>
>>   const struct vfio_device_ops *pds_vfio_ops_info(void);
>>   struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
>>
>> +struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio);
>> +
>>   #endif /* _VFIO_DEV_H_ */
>> diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
>> index 435c8e8161c2..1295ff2518a6 100644
>> --- a/include/linux/pds/pds_common.h
>> +++ b/include/linux/pds/pds_common.h
>> @@ -34,12 +34,13 @@ enum pds_core_vif_types {
>>
>>   #define PDS_DEV_TYPE_CORE_STR        "Core"
>>   #define PDS_DEV_TYPE_VDPA_STR        "vDPA"
>> -#define PDS_DEV_TYPE_VFIO_STR        "VFio"
>> +#define PDS_DEV_TYPE_VFIO_STR        "vfio"
>>   #define PDS_DEV_TYPE_ETH_STR "Eth"
>>   #define PDS_DEV_TYPE_RDMA_STR        "RDMA"
>>   #define PDS_DEV_TYPE_LM_STR  "LM"
>>
>>   #define PDS_VDPA_DEV_NAME    PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_STR
>> +#define PDS_VFIO_LM_DEV_NAME PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_LM_STR "." PDS_DEV_TYPE_VFIO_STR
>>
>>   int pdsc_register_notify(struct notifier_block *nb);
>>   void pdsc_unregister_notify(struct notifier_block *nb);
> 
