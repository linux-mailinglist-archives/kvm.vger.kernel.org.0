Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81ACA455F62
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbhKRP1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:27:39 -0500
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:3584
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232083AbhKRP1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 10:27:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTzPmfb7+5yvhY80v9E5ZNOp53dmshYqCqkCy2Z6isaT40VqM6KjGmOlg1EW755mI+e+7aKxMnzQnltX4yj/3uluNpdtPTmgM8qF17fV3CcoHNSKZLZHD/p1CQku6t0TkrFR/7q2uhGYvpAAwsD38yjvwkZAH+8mZIeESDVoWh3Urq1i9mCQnGjK96koOFqFOGeOl+xl/w0+9hC9/6LCI0aDxK76QxUnWL2+3JzPR+b/FvqE3FZ7GxbLvfuGvbouQxQnIBA304u7AI0IFfnlM/ayRoLDNR4iuGBEvZlAr6QtMGgWw48wRGl+y5tRFswU64yS2ZUaktaDX2XVDRO3rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eXVSKVPZ9KUGZLJ3rTe3B9m3iU7bvxBmmvh3y8nvk2o=;
 b=c818yuPKdnaO/BoibqB+GJPi3xSDfNDon6aPq1TasECb9in0N9k5wDh0dx+k5+/082K3XZMrAXudWICcplbh0B2iIrHIvfA7zL842OXWOKmscWKrD7crejmP5m5iy83wBgo/DjQ0xakitYZ5++5a0Lb+CL2WISI6foc1lXa5HogqApvCEq5JRhalKOAE6R+JxOzQXKBEi2AM3mQVacTBIxfVW5+kyQmYnOcBtsXI3yXVxHgV8Pd7KC/41Ovraf7DwjGXAcC3OUraIoc2YQSqHM0+XFgYqtXTeh64KV0c6HwN7uebve8yJ6UZce74T5MS8jP6j2GU/Y6Px7mBHpFupg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXVSKVPZ9KUGZLJ3rTe3B9m3iU7bvxBmmvh3y8nvk2o=;
 b=crjxSybMYlmrcvMDINr9JrUeJ0emidLLt7T5td2xji1D61tfL1eC549nrLFGKQXrhG8IRyUA1MqPyS6MIB9pvo+n79ezGeZddbP+SHkLCXsNpg8lsYS+fMxVesWrH/rjanl+NWsaGkGpuw9gYckuWqe1SYOMAZv7JysYyotISgE8SevaMc+M0ndeNcEQZ5+7wyaa3FAqaUhHmMqIGSUewta7yZLqhPrzHVI/TspfL7PMPjBBjqfuS0tU0SiygPGHNPfxTyGOO3MCCr4bbnjld9NM9IKc7o7nWlYHTD0oi2vE9EFonLN7kE4cV46KzSYEtIfCmUAk32WzqOWAezVGgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2937.namprd12.prod.outlook.com (2603:10b6:5:181::11)
 by DM6PR12MB3305.namprd12.prod.outlook.com (2603:10b6:5:189::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Thu, 18 Nov
 2021 15:24:32 +0000
Received: from DM6PR12MB2937.namprd12.prod.outlook.com
 ([fe80::ac32:c8f7:f83a:8734]) by DM6PR12MB2937.namprd12.prod.outlook.com
 ([fe80::ac32:c8f7:f83a:8734%7]) with mapi id 15.20.4690.027; Thu, 18 Nov 2021
 15:24:32 +0000
Message-ID: <96bb2b52-27b2-655e-2a2f-157efb98826c@nvidia.com>
Date:   Thu, 18 Nov 2021 20:54:17 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [RFC 2/3] vfio/pci: virtualize PME related registers bits and
 initialize to zero
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org
References: <20211115133640.2231-1-abhsahu@nvidia.com>
 <20211115133640.2231-3-abhsahu@nvidia.com>
 <20211117105304.5f9f9d72.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20211117105304.5f9f9d72.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0016.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::26) To DM6PR12MB2937.namprd12.prod.outlook.com
 (2603:10b6:5:181::11)
MIME-Version: 1.0
Received: from [10.40.163.75] (115.114.90.35) by MA1PR0101CA0016.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20 via Frontend Transport; Thu, 18 Nov 2021 15:24:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a9448bc-1bcd-4bed-25ab-08d9aaa78529
X-MS-TrafficTypeDiagnostic: DM6PR12MB3305:
X-Microsoft-Antispam-PRVS: <DM6PR12MB33059A2F3333AC44E094FBE6CC9B9@DM6PR12MB3305.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BHO/jSx7kXin4LQl3fKa0Gi1re81Q3bceIhDlbqPGI6Sh0x6cgVpv7RTIa5/OLmAiF85+q+ZrVAEXLqPG435zxsvWsNTM1QvDfMOV8BMrRS3ggcWQOuI874wZ21wjJRxhfKtwifF60zrvLKxhjz3iFmitSij39MNJ/Wye2M9J5NyzX5F/c2hUJee1mwH3hO6ejG/mO+UmJP1h2ecDTqoWOAqtMzflwJVloSlPuBxBuRn/kKP/wRU61KYUKa9CwOfnGJXNbsyWZaskymSh3E4NhC0Z/lxLP5ASqxdvNtrZBqSiSCchlD/zznh+HHv0/qxYLzChl7kC33huQ7oA30P9JeF53euiQN0ekB345UZhqFUU7ijCct2LJKrwwgo+L5iqffNW5md+JEKQRG/anm1nqd/kfqrE4xlOf5mc792qZBMe9Chi/by8F4W2Jp2LS8PgokM5w3BpMPuEfP3fwh4KySzmruVkFclHUfSn874ZB3/w8Sogkyw4DiCpWay4/fbMYyxDprsdbV2gFs2g+zfftfDt3RLmMxRWcDFuyWS3kLaCFR3dh3W9QuD1r5Ns0vri0QrZyAaAQtqjglgru9GRGVC22OLSceCnala+hcayroCOfs55wlfwIrqEQqzvzTCiOO+gRYPhIhpXY4UwHGm53IX2nIzQqEueDGqSbpN/nYBpuEMKVhgn6SFh67NELxZh5SNLjAQ0tZm1gx8GpbOrpc/9JGyUB8eRLySzevHR1I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2937.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(6666004)(36756003)(26005)(2906002)(6916009)(16576012)(55236004)(53546011)(54906003)(8936002)(83380400001)(66946007)(66556008)(38100700002)(31696002)(66476007)(2616005)(31686004)(8676002)(86362001)(6486002)(5660300002)(956004)(4326008)(508600001)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekR3Y1JsczIrcHd1cnNtNWtEK2x2RjFXcDJ1MmdIek4wRTVFdXh5dDZhaGR4?=
 =?utf-8?B?NGcySlFtWXpYdVEzRWUwQkZvNWE5bWpBSnNwK2h0cXVMcFlQVllhYWxOVUI5?=
 =?utf-8?B?NW14SkpvbEl4MFprMkFnSGJwRUpYZm5keXBXSmF1SThDV1RRYzBEZGtWQmdw?=
 =?utf-8?B?NzRQNlo5UnNoRkFnNzVudmdmNjBuUHNpMXgrOTRCaHppQWFVQjkvS29vTElN?=
 =?utf-8?B?amt1V2pqTFRMc1orYzR1QnZYUmVjbTl5M0R1QTRFQW1mbWhlMlhnSVB6WFVZ?=
 =?utf-8?B?UWFiMmIvT0lTVGhNNi9pbnVZVHlBOEtGeVdZelBPZXRMOTc5MmV0RSs1T24w?=
 =?utf-8?B?SjlJcTJZVmNNTHA2cHVRN28vK3d4R0RHb3VXTFduM1V1bG54VnV4Z2Qxd091?=
 =?utf-8?B?RGgyNDRGR09XMVcwSnZick9LZmRvKzdiZjlwQ0xQM1Q3bEM4eDZ5MGQ0N2lS?=
 =?utf-8?B?N3BkMXlrM2JXdjV2ZFU3OU9lUDNhNFBlMDY4ZzBvOC9ORnYrL2RKdTlzdExS?=
 =?utf-8?B?V201cTQ4UmZLZmp6dVdqQUUrNUNobVhkaUhuUWJYaDBYR3hEUk11OENYYkF2?=
 =?utf-8?B?dXRqL0cycDZJQjV0cWZCcDQvOG4wRG1nSnRwM3ZxbVNJMy9YWC9kWnIzR3RO?=
 =?utf-8?B?MGRzVW94NC96dENwLzlJVlZUT0pIekk0aThsYmU3YUlVNUZta3BjemVGN245?=
 =?utf-8?B?eEd1K3pFcFRSZGtIQ202eDMyRXp3OGhVS1ZvSkVjSkNOc2M0RjRCRGt3QnM2?=
 =?utf-8?B?ODVtVHJtdTZVSXNMYzdhdlhtNnd2c2Vra2w2eEZmQUZrTFhDc0d3YmtxWlBW?=
 =?utf-8?B?eU5PWTkyNXZJSDhxMUkxRWJRSk9za1RYemNUY2J2TGtsT3JoVXpnMDZ3WVBM?=
 =?utf-8?B?RUNTTFJCbmFXYmUyL0d1RTVZV0NieFV5VFRhbGtWbytOenV1T1p3dG15elVx?=
 =?utf-8?B?K1hINERyNnQzR1lzYTh5UmNFbTVuazlpT2llUkZtcXhrT3p4dkdXOHNOVWgr?=
 =?utf-8?B?cWhsdFIyejJseDNadmt3L24xVTR3b0dYQytBWm51L0M2OXF1OGcvRHVhZ1lS?=
 =?utf-8?B?c3JOcGJHL1NpbHVMV0lRbzU0Z2RrblVvN1A2bndIWnRHZmhoTE1tLzBIY3dz?=
 =?utf-8?B?SXdxc2VHR1AwaDNZenhCYlVwMmdBdkR4dCtoVWYxUi9TZEVxbWg4VTI4d2Fz?=
 =?utf-8?B?ZkRHVFZiMjdXTFZmeHprWkpzZENuUlJMeDgyZ0ZzbkkwZ3RsT0NVUjUzVkNz?=
 =?utf-8?B?UThqWUY1dFFaeDU2SUpPKzNwTWlUQmJSMHlBclp5NHcvMjhPR3AyYWVEVm51?=
 =?utf-8?B?ajFQVTk4V0JKekhzTUtFUWtQU2JFcnBLdU5BMEZzNWhQeHBFenRKeXZFYzVB?=
 =?utf-8?B?QzhkTGFickF2dk91ei9mbHM4Sklab04xOWlsUUFXOHgzWVkwaFMvOXNYaU1X?=
 =?utf-8?B?SzVEbk9kZEFsRVgwcTJrODEwQ2FsNU1LK25NR1JmdHgraDJLUWVwbEYxU2d4?=
 =?utf-8?B?VlljYlRQWlc2RW1rbUpPbE4xYTh0d0xtYXczNmN3azZ0eUVpcmlseS9DajVk?=
 =?utf-8?B?a3hSNm1Tc3FLL1pUTjBlTjUxZUtPL2tWNlAwYjVCbVVaSFcrYzlicitrMElu?=
 =?utf-8?B?aVVqMlc2VXhqaUd1dTdqVU9BZXp6TFNJekF5YzFyS24xaDlTUlljRTdjS3pS?=
 =?utf-8?B?Ni9NUVpkVU42SnYvdDhrUE5tZWJqM3Y5SCtPSWlORXhDSnRNNDVCWEk0Y3Ex?=
 =?utf-8?B?K0ZFVi84elF1VEJUM0FWUmZ2M08zaGtCQXpVZGZXV1lBcThBZDd0c0FxZzN3?=
 =?utf-8?B?WjBDN0xuSW0yRmIvS0tib3Y0cTJ4aXFTaW5LdUZMZjVGQ2gyK1FaVjQ5ZFpE?=
 =?utf-8?B?UlhXSEc3ZUZTWW4vQzUrSUplMlRUT0JLOUtDSGhkVUlpNkJnTisxSjdjWmxv?=
 =?utf-8?B?TFR3MHpwREFndkYvWXJrODZSSVQrTFBwRWxSQ0R4WmV3aHBRTGlvdm16QUkv?=
 =?utf-8?B?NlEyWS8yZFNZYVV3cmVQRDlZZHpRL051QW5TM2Q5Rm5COG1sTGZHTHBUazJZ?=
 =?utf-8?B?UURiTDYyeVZ0d1BrREV0UGM3dytUbVBSWERTOHJpZThXUnZFZVI2MmR4eEVn?=
 =?utf-8?B?Wm5ZdjRyblNDdVpjdFZsY1J6RVFtK1kwOFozc2t0amZIZlkycVI4OUZhRTNQ?=
 =?utf-8?Q?P1uVMtr58uEmpdRJvg8NNKw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9448bc-1bcd-4bed-25ab-08d9aaa78529
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2937.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 15:24:32.3740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cItxVlGjctEVMbzIrcQOriLbvBjMVq6NU0WjC/r7u1eDMVyJE2G43HHfDPxF8OKLDlWL4w4zJ0OM+Dlpi3HggQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3305
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/2021 11:23 PM, Alex Williamson wrote:
> On Mon, 15 Nov 2021 19:06:39 +0530
> <abhsahu@nvidia.com> wrote:
> 
>> From: Abhishek Sahu <abhsahu@nvidia.com>
>>
>> If any PME event will be generated by PCI, then it will be mostly
>> handled in the host by the root port PME code. For example, in the case
>> of PCIe, the PME event will be sent to the root port and then the PME
>> interrupt will be generated. This will be handled in
>> drivers/pci/pcie/pme.c at the host side. Inside this, the
>> pci_check_pme_status() will be called where PME_Status and PME_En bits
>> will be cleared. So, the guest OS which is using vfio-pci device will
>> not come to know about this PME event.
>>
>> To handle these PME events inside guests, we need some framework so
>> that if any PME events will happen, then it needs to be forwarded to
>> virtual machine monitor. We can virtualize PME related registers bits
>> and initialize these bits to zero so vfio-pci device user will assume
>> that it is not capable of asserting the PME# signal from any power state.
>>
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_config.c | 32 +++++++++++++++++++++++++++++-
>>  1 file changed, 31 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>> index 6e58b4bf7a60..fb3a503a5b99 100644
>> --- a/drivers/vfio/pci/vfio_pci_config.c
>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>> @@ -738,12 +738,27 @@ static int __init init_pci_cap_pm_perm(struct perm_bits *perm)
>>        */
>>       p_setb(perm, PCI_CAP_LIST_NEXT, (u8)ALL_VIRT, NO_WRITE);
>>
>> +     /*
>> +      * The guests can't process PME events. If any PME event will be
>> +      * generated, then it will be mostly handled in the host and the
>> +      * host will clear the PME_STATUS. So virtualize PME_Support bits.
>> +      * It will be initialized to zero later on.
>> +      */
>> +     p_setw(perm, PCI_PM_PMC, PCI_PM_CAP_PME_MASK, NO_WRITE);
>> +
>>       /*
>>        * Power management is defined *per function*, so we can let
>>        * the user change power state, but we trap and initiate the
>>        * change ourselves, so the state bits are read-only.
>> +      *
>> +      * The guest can't process PME from D3cold so virtualize PME_Status
>> +      * and PME_En bits. It will be initialized to zero later on.
>>        */
>> -     p_setd(perm, PCI_PM_CTRL, NO_VIRT, ~PCI_PM_CTRL_STATE_MASK);
>> +     p_setd(perm, PCI_PM_CTRL,
>> +            PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS,
>> +            ~(PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS |
>> +              PCI_PM_CTRL_STATE_MASK));
>> +
>>       return 0;
>>  }
>>
>> @@ -1412,6 +1427,18 @@ static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epo
>>       return 0;
>>  }
>>
>> +static void vfio_update_pm_vconfig_bytes(struct vfio_pci_core_device *vdev,
>> +                                      int offset)
>> +{
>> +      /* initialize virtualized PME_Support bits to zero */
>> +     *(__le16 *)&vdev->vconfig[offset + PCI_PM_PMC] &=
>> +             ~cpu_to_le16(PCI_PM_CAP_PME_MASK);
>> +
>> +      /* initialize virtualized PME_Status and PME_En bits to zero */
> 
>         ^ Extra space here and above.
> 
> 
>> +     *(__le16 *)&vdev->vconfig[offset + PCI_PM_CTRL] &=
>> +             ~cpu_to_le16(PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS);
> 
> Perhaps more readable and consistent with elsewhere as:
> 
>         __le16 *pmc = (__le16 *)&vdev->vconfig[offset + PCI_PM_PMC];
>         __le16 *ctrl = (__le16 *)&vdev->vconfig[offset + PCI_PM_CTRL];
> 
>         /* Clear vconfig PME_Support, PME_Status, and PME_En bits */
>         *pmc &= ~cpu_to_le16(PCI_PM_CAP_PME_MASK);
>         *ctrl &= ~cpu_to_le16(PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS);
> 
> Thanks,
> Alex
> 

 Thanks Alex. I will fix this.

 Regards,
 Abhishek

>> +}
>> +
>>  static int vfio_fill_vconfig_bytes(struct vfio_pci_core_device *vdev,
>>                                  int offset, int size)
>>  {
>> @@ -1535,6 +1562,9 @@ static int vfio_cap_init(struct vfio_pci_core_device *vdev)
>>               if (ret)
>>                       return ret;
>>
>> +             if (cap == PCI_CAP_ID_PM)
>> +                     vfio_update_pm_vconfig_bytes(vdev, pos);
>> +
>>               prev = &vdev->vconfig[pos + PCI_CAP_LIST_NEXT];
>>               pos = next;
>>               caps++;
> 

