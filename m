Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8565D56B5CE
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 11:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbiGHJjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 05:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237523AbiGHJjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 05:39:39 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B12D6B27F;
        Fri,  8 Jul 2022 02:39:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9/CKpqu6mQ8IrAG5/aIxREvu/V4391svdjt0j6ICGh84AoEOQ5WJCMFV3z3jZHov46FfNPx7EjsH+inp/fOoQbs26E6K6ND0jqKE+U5aKzMAxTnpSWkbQZ2k7o0IrXUNBy0L3RUR2pfF9Rqw28IPuNfu6Sx1g5ccvcKyxNQl2VyCWyyqCrmKIowTVqnslXYQN7QX0vvfjrL8RcfR5ky7GPDo/H9r0rws8NeE7Kas504lLhyfWVUk/LYTry7HMNAb6lJxI5qeZw8fHr8UFmOYLptgYNSHMA2FGu5EsXeS1yhFXOk59Vp6VCXQmcl8tkG/iRSWlzeJpl654xByI2vYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLoruYACLiuGTVmehUrDRnHWSzzA63yNQHE+auuH/+M=;
 b=n1J9fCgsd0gKOAws+DX/4h+yrljxYlA6sdENPbXGXZ+0FEfxmNPeqaGSnUw7NxYMhIh9vFFhWvo8DqRgn0jAP9p6w549z/WVuGKO4ZScsxeJAfvgi1dzBs696s4/KFqWLzZGa1WyAV79BfW7SESNg9kEX1zFcVEmDMt4HlYt9nOAj22Ok75Oj7X1/lrh1KY5EeHUA2C1HpDLl+OMvJ5i2XL3sr3ZpbM+HuBNbiMYL4nPb6RxDc1ykISSQS3tXk9FmTk3yBO7tq3C/yXTBfO572E++Z7O4tK0aC6shzqYlLv4ExBYGT8WqdqA5R9UlVYy7PeW2gddsGfN9I3f0xmPGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLoruYACLiuGTVmehUrDRnHWSzzA63yNQHE+auuH/+M=;
 b=OfMSKKytwiN7Tv9camNVoYXz8HKXcN+bTcDDIiAPqN9MuMfUq/Zv9ZJmrZ4KepT6bpgIq7Ezih0klsbJK43bktfeFkfLBKNgew7zzAfwOQ7qsYw7AsrvQggQ5bxyzRsSSRvT9wqQWXKJ1fZKABkU9IBrvzYSMQBFsw0OwWR16dclI1xJAal3Hzl1JmUnvxYHZKI9orRpMVffXNqtu6ZQi6cvLUW0Uq+kpVDb8EmWyK3RKufbUfob4/QtM9KPmM12gWjXgO+p3IIGKi7uTivoeUpsMhEVzR+p82Uy6lnJCV7wMlUhsZ9YVzA4NYP/Xf9pjuAKtxrDcM4rhb/XdAfA0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by PH7PR12MB6396.namprd12.prod.outlook.com (2603:10b6:510:1fc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Fri, 8 Jul
 2022 09:39:35 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 09:39:35 +0000
Message-ID: <ad80eb14-18a1-8895-ecfb-32687a4ba021@nvidia.com>
Date:   Fri, 8 Jul 2022 15:09:22 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 2/6] vfio: Add a new device feature for the power
 management
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20220701110814.7310-1-abhsahu@nvidia.com>
 <20220701110814.7310-3-abhsahu@nvidia.com>
 <20220706093959.3bd2cbbb.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220706093959.3bd2cbbb.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MAXPR01CA0109.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::27) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22b78cd3-fc5e-40c7-f599-08da60c5c4df
X-MS-TrafficTypeDiagnostic: PH7PR12MB6396:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /xT1oMn3uenPnFVAaIB9mSbilJSuYCO52gjJXqq0L2LFPDt5MIvSx1jXCKi0HLiV8f6AhNBaoGpPlR9+lzmzUo1aOQ/gclp+lMOjE6/fgGqfbsCN5aDbYnHTFoDXFU+UUXf9zS6j2mkuUHZDT5LVRMF6HVZw5aZbeVyUS3McQEEWRWhry7G9aIcJ8tnkURv+9kkyVzCjuMfxO5bNsyx2lce5uUJeBxH/hOKjyNu1QRuWQc7GzVBcdjNCrFX16U1EFmgv5GH4x61+ZJnrr8jUBaihadnUPBxm9XYgwrOln+E3Fy8hSSgC71VwTyTnABlhuafys1rGjot3d0Di+OjTWp0BiXoznKuxB6ltJ+z43qP3uz+srNs/my55K/hMtQ5BITUq6O9xFpJkS/8qNdaSfSZdCdo4iPcH5Dqm0PtnoiLGCOkPJXLzTyUP89T1gM3UqzBXjL/YkisKRuqqgA04mJIZq7iNcAOighK56/kj9dRSTT03WHIdwhyQMcE56ZXYMDbcb9D9/oYBPvKUe6BbIx6BoABECp/bejy4srNO6DPjxE8dzxxKXbpE9mHt+YVK9O17R5h7L86VLaGzAR3gmh/raHJ3pSVXm8B4tzWj4qHN47Xad15s8IatgpvrACzWZquVZePN0omv9rGFDXx9cH297POdzg2jOUalscBIC5DTOrSZ9de8ls9WB1c7l+AJ3iBNHZmhrSFfoB5e6FuQoBuQMyIy3QBdD+fSjJQgj2Lgf3Ugf7CDbYpTMRPdDnwmZAhKg2oOp3oDEEDx1Zmd/X3ZnarQ4GeuUXKgXov6dzodfjKMFsDnBNxuA7dI6e2/K/gykDHaKhK14rO3/Qlm+G61zPY0RGsFw8ollhgB+jM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(84040400005)(2906002)(2616005)(8936002)(6666004)(41300700001)(38100700002)(6506007)(54906003)(6512007)(53546011)(36756003)(316002)(31686004)(55236004)(6916009)(86362001)(478600001)(26005)(66476007)(186003)(8676002)(66946007)(4326008)(83380400001)(7416002)(6486002)(31696002)(66556008)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWRkcUY3ZG1YM2tVM20veGxrYmhPbTN2bVpiTlY4dzJ5MmdYbThka3VXRFQr?=
 =?utf-8?B?MkRKMVZwSkZGMXZtbVlIUmZZVzFxaFhHTUdNUXdDYVpuUjJyWGRJY0JRT2Ev?=
 =?utf-8?B?Wkt6TTRVa3RHODFBcHdxbXBhQVJLV0hPUG9ac0NiQUZ6V2dEWk9sVTNjWWQ2?=
 =?utf-8?B?TW5sTWo0Rk1FQ2tHUnJHQk1wdmMxUnpFNTNtQnpVY0FqY2JNMHNGa0dPbDhG?=
 =?utf-8?B?VGMwK2lFb3pROVZVdjdkdjc1RUtKQTU3cytOYStKaXRBa2Rqc0NQSU9adWdM?=
 =?utf-8?B?U09lUWhYUVdKRnFEb0RNRy92Zll6UXp5cG9WZXdvbnVqSU84b3YveGZPYzg1?=
 =?utf-8?B?MUNEUUF0SWQvbDVlSG9IdW45YmdJVmwyNyt2L01Za05hWll0VTV0a2N6V1NG?=
 =?utf-8?B?REdFVWY1M1BqU2RYQWlpdWcyNEhTVjN2amt2UXVFSkNsWUpIcHgrZ2NOQXlP?=
 =?utf-8?B?Z0xSWnlEUEgrdG5YZk50TTFGK3lLZUtFR1lNd2MxQlVKWEJyTWdLR0tJU2p4?=
 =?utf-8?B?dmlTb0Iwdnlkc1N4Q3RNWWowQXBid2dZV1BpUUE1eEFhWmlBNHJwTm5TL2hB?=
 =?utf-8?B?VS8ybnBnSVZPcy9lUlVPd0o2TmlhM2tBMHZpT0draE1OditleTh2bVRIdndG?=
 =?utf-8?B?ZEpkc3RIVk9kSmZhQzdMYXl0b1dSbmpvVTdhSVdRMFA4NTlSdTc0a1Nhc09r?=
 =?utf-8?B?RHJ3Tmx2Uk5VaTBlTlE0a1dMbkQzazNYNnhSN0NPUEJpaktLVW0zVDZUUS9W?=
 =?utf-8?B?bkxqSERkRzBYam1yZ3pOVzlVaTZhejBlZjYrcWxkZGFNZER6b2FVRUdMamly?=
 =?utf-8?B?VjRjSERkTjBIc0Y1NHYxN0xyT2gzdzVReVdrRk5WeVJjOWxHMzIvRGdlSXNM?=
 =?utf-8?B?VytLVVdUSjZ6aDU4SUxrcGpxZ3hHQ1Rna0J6RXd5RG1oWlZpSjNGUFpZQ1VM?=
 =?utf-8?B?UE9ISDZPcVBHdmYxOC84bmRxUUk3ZDV0YkJObFp0c3JXSEtDT1J4a1JHdW5s?=
 =?utf-8?B?QlEyQXNRTHd6ZEZQeE1KWm1pbUU2b29kZVhUekhabnZ0bXM2QktSd2RwZmR0?=
 =?utf-8?B?MDR1OEhJT1pjV2drSjN0T0tvN0FOOEVJdDBKR29uRHlBQzhGN3JKYVlYY3lN?=
 =?utf-8?B?NDY3Z2VYanZWelBVQloxN2dhNGErQ3RRdUpRRnlyQXRQSDZiQXhKeE1lTThh?=
 =?utf-8?B?RjRrMzVXM2JvRExzTTRuRVBkVDBwRUVtdHlYUTMrdHlFK0dBdFNvbFJkQUdq?=
 =?utf-8?B?THdaaFlHRHU3eTBLZ0J5d2xYRnZtV1NIWGFtdFdQL01Fbm5mUWo2b3RHbzdJ?=
 =?utf-8?B?TzFkOHhpRnZ5dFBiTlBoZXgzaXhXMjRyWm5iS2tQRmR3SG1VVGJkMUZkZUFt?=
 =?utf-8?B?dlJnZFExT2lWVFVjZXQvU0VmTFRibkZEcXBIR0E5QmhtRm9TNnNsL25KTFls?=
 =?utf-8?B?c25nRlFkSmhZWDdEL0xoQXl4c1ZpakRGWmNjZERaV0FRZFFyVy96UFRCa2J6?=
 =?utf-8?B?L1U1Qy9EdE50OFppTDhHSlNyUWR6OG1WZVlha1M0djJHWHRtb0FwY2ZaL0JD?=
 =?utf-8?B?YW1jak5seWdydTVFQzZOL3VsTUxobW9CWlIrTndLWE4rcVNBanpra1VKRkhX?=
 =?utf-8?B?cHlpd1JiUTZyeVV2VDNVd0tzWC8xVUxYNUs2Wm9KL0Jqb0hlMHA2bmM5eFZj?=
 =?utf-8?B?M0VzU2p0RHE0YVJLall2SHJDSzhpTUdQYUNRbXUzUTJ6MzFROFVRbUpobDJB?=
 =?utf-8?B?SlFmTGxMcnE2U0cycTQ2WFl1d3RIL2R1YWdlZVNHNzNRTFFCQVl3QlYzUWFE?=
 =?utf-8?B?RW5XYmlrcjkzN3lsNjNHYWljUmdNL3NRdHdUSXYvdUlmbXpja3RwS1ZBUDBk?=
 =?utf-8?B?Q2lRZ0Z6Nkl0QmpDbWNlbjhkcnliK09zczZpU2dPdHdtOFgzc25ac0lhejZQ?=
 =?utf-8?B?cnZrNkNET0ZHa3RzT1JqU3ZKQlhTbzMyR00wVGUyanFXTS9KamNETDRnMjJy?=
 =?utf-8?B?OUFjMlkxSDhndXk4NEViNFcxRTlRb25IdzFnSVJNSitWWWo2dWw0N1ZEUk8r?=
 =?utf-8?B?dm8wWVN4TVQyZEpLT2dDRkphZ3g5ZThnSGdtd1ovUjVrNzdGdlFKVENOajdK?=
 =?utf-8?Q?xBpN9BS2M/6hzeQzNbw0ZO4KS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b78cd3-fc5e-40c7-f599-08da60c5c4df
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 09:39:35.7305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ES/DRAAYzqcZXiKnmUIT85NujVb9Ew2ttg+JG5FAhocyK5NeqYydVKSU1JOM8NLYQVfRYP+42hme+9a3VgWcBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6396
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/6/2022 9:09 PM, Alex Williamson wrote:
> On Fri, 1 Jul 2022 16:38:10 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> This patch adds the new feature VFIO_DEVICE_FEATURE_POWER_MANAGEMENT
>> for the power management in the header file. The implementation for the
>> same will be added in the subsequent patches.
>>
>> With the standard registers, all power states cannot be achieved. The
>> platform-based power management needs to be involved to go into the
>> lowest power state. For all the platform-based power management, this
>> device feature can be used.
>>
>> This device feature uses flags to specify the different operations. In
>> the future, if any more power management functionality is needed then
>> a new flag can be added to it. It supports both GET and SET operations.
>>
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 55 insertions(+)
>>
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 733a1cddde30..7e00de5c21ea 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -986,6 +986,61 @@ enum vfio_device_mig_state {
>>  	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>>  };
>>  
>> +/*
>> + * Perform power management-related operations for the VFIO device.
>> + *
>> + * The low power feature uses platform-based power management to move the
>> + * device into the low power state.  This low power state is device-specific.
>> + *
>> + * This device feature uses flags to specify the different operations.
>> + * It supports both the GET and SET operations.
>> + *
>> + * - VFIO_PM_LOW_POWER_ENTER flag moves the VFIO device into the low power
>> + *   state with platform-based power management.  This low power state will be
>> + *   internal to the VFIO driver and the user will not come to know which power
>> + *   state is chosen.  Once the user has moved the VFIO device into the low
>> + *   power state, then the user should not do any device access without moving
>> + *   the device out of the low power state.
> 
> Except we're wrapping device accesses to make this possible.  This
> should probably describe how any discrete access will wake the device
> but ongoing access through mmaps will generate user faults.
> 

 Sure. I will add that details also.

>> + *
>> + * - VFIO_PM_LOW_POWER_EXIT flag moves the VFIO device out of the low power
>> + *    state.  This flag should only be set if the user has previously put the
>> + *    device into low power state with the VFIO_PM_LOW_POWER_ENTER flag.
> 
> Indenting.
> 
 
 I will fix this.

>> + *
>> + * - VFIO_PM_LOW_POWER_ENTER and VFIO_PM_LOW_POWER_EXIT are mutually exclusive.
>> + *
>> + * - VFIO_PM_LOW_POWER_REENTERY_DISABLE flag is only valid with
>> + *   VFIO_PM_LOW_POWER_ENTER.  If there is any access for the VFIO device on
>> + *   the host side, then the device will be moved out of the low power state
>> + *   without the user's guest driver involvement.  Some devices require the
>> + *   user's guest driver involvement for each low-power entry.  If this flag is
>> + *   set, then the re-entry to the low power state will be disabled, and the
>> + *   host kernel will not move the device again into the low power state.
>> + *   The VFIO driver internally maintains a list of devices for which low
>> + *   power re-entry is disabled by default and for those devices, the
>> + *   re-entry will be disabled even if the user has not set this flag
>> + *   explicitly.
> 
> Wrong polarity.  The kernel should not maintain the policy.  By default
> every wakeup, whether from host kernel accesses or via user accesses
> that do a pm-get should signal a wakeup to userspace.  Userspace needs
> to opt-out of that wakeup to let the kernel automatically re-enter low
> power and userspace needs to maintain the policy for which devices it
> wants that to occur.
> 
 
 Okay. So that means, in the kernel side, we don’t have to maintain
 the list which currently contains NVIDIA device ID. Also, in our
 updated approach, this opt-out of that wake-up means that user
 has not provided eventfd in the feature SET ioctl. Correct ?
 
>> + *
>> + * For the IOCTL call with VFIO_DEVICE_FEATURE_GET:
>> + *
>> + * - VFIO_PM_LOW_POWER_ENTER will be set if the user has put the device into
>> + *   the low power state, otherwise, VFIO_PM_LOW_POWER_EXIT will be set.
>> + *
>> + * - If the device is in a normal power state currently, then
>> + *   VFIO_PM_LOW_POWER_REENTERY_DISABLE will be set for the devices where low
>> + *   power re-entry is disabled by default.  If the device is in the low power
>> + *   state currently, then VFIO_PM_LOW_POWER_REENTERY_DISABLE will be set
>> + *   according to the current transition.
> 
> Very confusing semantics.
> 
> What if the feature SET ioctl took an eventfd and that eventfd was one
> time use.  Calling the ioctl would setup the eventfd to notify the user
> on wakeup and call pm-put.  Any access to the device via host, ioctl,
> or region would be wrapped in pm-get/put and the pm-resume handler
> would perform the matching pm-get to balance the feature SET and signal
> the eventfd. 

 This seems a better option. It will help in making the ioctl simpler
 and we don’t have to add a separate index for PME which I added in
 patch 6. 

> If the user opts-out by not providing a wakeup eventfd,
> then the pm-resume handler does not perform a pm-get. Possibly we
> could even allow mmap access if a wake-up eventfd is provided.

 Sorry. I am not clear on this mmap part. We currently invalidates
 mapping before going into runtime-suspend. Now, if use tries do
 mmap then do we need some extra handling in the fault handler ?
 Need your help in understanding this part.

> The
> feature GET ioctl would be used to exit low power behavior and would be
> a no-op if the wakeup eventfd had already been signaled.  Thanks,
>
 
 I will use the GET ioctl for low power exit instead of returning the
 current status.
 
 Regards,
 Abhishek

> Alex
> 
>> + */
>> +struct vfio_device_feature_power_management {
>> +	__u32	flags;
>> +#define VFIO_PM_LOW_POWER_ENTER			(1 << 0)
>> +#define VFIO_PM_LOW_POWER_EXIT			(1 << 1)
>> +#define VFIO_PM_LOW_POWER_REENTERY_DISABLE	(1 << 2)
>> +	__u32	reserved;
>> +};
>> +
>> +#define VFIO_DEVICE_FEATURE_POWER_MANAGEMENT	3
>> +
>>  /* -------- API for Type1 VFIO IOMMU -------- */
>>  
>>  /**
> 

