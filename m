Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E310377082C
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 20:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjHDSvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 14:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjHDSvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 14:51:02 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276C8A9;
        Fri,  4 Aug 2023 11:51:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZNwdoJCCTtX3CaI9vw5lORwypJA+3edpVUH6Njd+PekFkfJLNqUrMBiVtPlysngnX5NvCx+r6Go72afbuPXaJXUAZ6HJDnw50FY4ctBVdbPbg0TT5HedKvCbclTlKXUU3qx2vLxkjVjhVEIWG62oXmhWLMnREMkT7kBiYFLKjIiZnu2pzl/UUtDD6VAAoEhdA6STuGYFG8T0OGj20KlKQDkPKyKTDiVmLQ9G4FqvmgzPZd3KDglGmG7npX5NcZ19Afv9FzQajdDPRXjE0U8MgdCTV037/kVJwucHtukQPheYMgzkJ1y1lVUI9NiQOeyzt/0g/M6H20Dt8ClfvRpt5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9IMP3Nm79aj42/CQkdrz2mFUrera2iLpnQNslnzH70=;
 b=UEo7LMXP5+g1bo/ezZm7DyYXGzb/mhNeev9ASkdgRM7eJA6WqFs9M2nIb8muvcy39ePCzav9IrETvPfLpUExiQEWBbSTcdOcAz9OGDihVu8PAAOMHlkKd59GnaZ/VoG7Jhq93K3T3wyMvOIXH+fWg7WqBtAYUIEe7o3bGJZSBbWq+UR6NqPLwbOmE+Jxx52/RxbuB7hJAwLmA8cmMRwfPi0niQYtpIHWqThbmE0VnPpqmmNWT4HbAjZTgEqCJo2O111qQuqVO28MtdsZLGgd3AvrMLhTcPWqYYaWQ4AN8/8QHfsQRBfcBVzORl0ZO9Q6wDG9fPNlzNenmhR4usAH9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9IMP3Nm79aj42/CQkdrz2mFUrera2iLpnQNslnzH70=;
 b=vUKXkbrgluZULFBN76aFIEZjQGc7ClUnqKo6yg2QkTSE5qyDF3LO8TNT2QVct8wBssgCKjlhchd0AHutpPXJD6d2Q0j9k56s8WBxpzegkRX6KpmkrP3dcaI3vN7PXev/A6oeYO24/qsH2MNmeuMFNwvtLMDtwlhnk0bVlEtpKAE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by PH0PR12MB7885.namprd12.prod.outlook.com (2603:10b6:510:28f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Fri, 4 Aug
 2023 18:50:58 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%4]) with mapi id 15.20.6652.021; Fri, 4 Aug 2023
 18:50:58 +0000
Message-ID: <73c3aabd-1859-573c-c878-e4fc73186576@amd.com>
Date:   Fri, 4 Aug 2023 11:50:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v13 vfio 6/7] vfio/pds: Add support for firmware recovery
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, alex.williamson@redhat.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, simon.horman@corigine.com,
        shannon.nelson@amd.com
References: <20230725214025.9288-1-brett.creeley@amd.com>
 <20230725214025.9288-7-brett.creeley@amd.com> <ZM0y9H0UbHHW8qJV@nvidia.com>
 <73aa389d-7ef6-5563-0109-a4d6750756df@amd.com> <ZM09c8IG+ba+fdts@nvidia.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZM09c8IG+ba+fdts@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0064.namprd17.prod.outlook.com
 (2603:10b6:a03:167::41) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|PH0PR12MB7885:EE_
X-MS-Office365-Filtering-Correlation-Id: f49b03cc-42eb-441a-1a1a-08db951bbdf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fXhDwzirVevo9z+PiPuowpQWQUMNjFOndcnRjxqX6oyt2xJP68yYjCR8Az+KiFm1+fU+wxDplh1zNpieDWD6Mmy+T11wyv40Mz292+60K4+JK0zJMmbbilD7etzDhRdmla/LgwyzNmLpd5zfOWCwSNwb9bbfYKct2rRg9ZcDUcKYVomUzCdYFRDK0bwccDozesMphfgz/AFDXJxBXjtfSKIvwRaMTq7EMugVZ7eHZvVPSlHbhvbT37DvJixgUz4IUiBPYqxe07+3rKzbiVKswGJDrGNQesra3WUCrR0T59TnhI3XAM7Bnoihq/q7D2DmPMASM8/r2q5+HKIFKorJ65GBjOFS3mCSV0wTjeZRCYtlupjDh87G2Sef8/tI2NB7F1Pq13dUxN2701tuGGDlN+3gbP/tuZ/VJEvdHp+8GEoYpiT4Qu5LPeYWot+a4ujm9mF+PsOg6n9rYYDLsL/8NRwfUh8bTZmbuTg/v6/PO0tUhMeFVxwOJc1UxNY/lWIEjEWUN+IIYr3WNYI2EKND+j3j+KIMy9xYktDQWTsER2P4e0u/Rt10msVPALOBDJX1M0dXG9RWr2DrO/663eCp3vWbaeQJ6QjmxAQ0Egp1FVO6rkuJMKRuBszOwfIU7+NPGPIGb2Uz7pehpF6GlgQ4rg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(451199021)(1800799003)(186006)(31696002)(66476007)(8936002)(31686004)(316002)(5660300002)(8676002)(4326008)(6916009)(66946007)(66556008)(41300700001)(478600001)(38100700002)(2906002)(36756003)(6512007)(6486002)(26005)(6506007)(83380400001)(53546011)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEJPc1R5RTV2T0xTaUhmTERDYTFobVJ2WFdLK0dZYTRTYnc1WlRPdmRsNHNI?=
 =?utf-8?B?TTVST2VJNHIrbVdhakRTa2xiMHh1MWsyM2RVUldRYzZyRWZVd2NXM3h1bDJ3?=
 =?utf-8?B?b0dXTU10SmNKWFNvSUVlRnlxU0RKc0IzeWdZQXFMVTdUWXZRUFRyUTR6NTJo?=
 =?utf-8?B?L0JUdVdLb0JNbEFIN25uU3pjNXZBUlpSUTZYMG0rNTNNa0h5cURqTzk4K2Jk?=
 =?utf-8?B?bzB4K1FIdm1VQzJyYXRxSk83WlBXdkNSdVcxakw5b0c2dmlhTlBqTlA4QWRT?=
 =?utf-8?B?bGpYcDlaZUswU2UxeVpJZXlJT0RkeEFOSFVleUdwZCt6MmNqNnVPcWdreXlX?=
 =?utf-8?B?N1lBY1JtK0lReGdqOFk4R3FMUXBYYlYvdnd4S2NvV3czRmlDanZjNHJOc014?=
 =?utf-8?B?dlFCQnJtSkhHb2ZMTUtqNGJzNHhWV2o0Y0NaUnhQb3hhZDB4MEtUYnFENDgy?=
 =?utf-8?B?OVFhdlNhVDdMNFUxTXRaeFVubUlxYkJMMHRvbmJudGtuajJiMXlxWkJybmF0?=
 =?utf-8?B?eDg2SDFNK1NjSzRTaFFxbktxLzJUQXhaS0o2enpMNTErSUZTU1JPNWxMQzJR?=
 =?utf-8?B?NmRXSjY5cGNXei9sbUwvcU5OblB0VlhZQXNNbDB6L3I2NEZmZjZWVU5nT0Rr?=
 =?utf-8?B?YlJKdXAxRWFWWTFFb25HZnVVNm1EWk5oQzJ5eTYrcjJNSGJXY21kNExOaThI?=
 =?utf-8?B?Mk9zVkUwY2wvQSs0OUd0OEp0R0trTG1rMGdYR3Y2cG5tSURnU0ZpbEVPbkg2?=
 =?utf-8?B?aytmaXU2K2NqYThIZm0zdUJScTJBMTBVaE9rd0RJOVN1c0gyd0VVWVo0eXlU?=
 =?utf-8?B?NmhYK2Q2QWtTVnJjTEdoalRlbXVsQVdmTnd2a3BKUlgzY2RVSUVJSTNGQmc4?=
 =?utf-8?B?cDBhQjFEQVdHdlVzSlBPbmx2UHRQUmdxUlBHV1FmQ2ovZlpFV1dCVmhCSUlm?=
 =?utf-8?B?cU9pZG1jUHk3VjZoNnQxUjZLaDdnSGVLY2NxajRFSUpTK1lUaVk2czNBcGp0?=
 =?utf-8?B?SVM4RU5hREdoa1dRbzBuUDUwMlMwOFUzNmtzY1IxaXRERkY4RFlnNG1yYmp4?=
 =?utf-8?B?YkdidFdOM0J6MzhESEQzYW93MDJYMnNGbDYrazk1ajlVTFg4MXNWa1ovYmR2?=
 =?utf-8?B?eGkrZVdmNHo5Q1FJcUFRRXFxdUNVbDlBcE9EcnB6eE5UV3lTZVErOXVpVkYw?=
 =?utf-8?B?SWkxSERYcit6TGhnQldEd1hzS1F0Q1dMWDcyZkFVZVFud0lTbjhRS0Z2SHM5?=
 =?utf-8?B?THlBQm8ydW5meURUb0lLbVFBc0kwM3RlQ0VrRTFManBBUVlrdFFXYjE3L0Zm?=
 =?utf-8?B?WE1KVkxGTkJSc2tBbWo2dFRqWTlkdFVkaE1TcWUxQ214dHRmVndzYjdmYTUr?=
 =?utf-8?B?cTg0MFI2cmF6WkFHQTlLQTlxK0d6MXdZbkNzWDd6VzExa0JPSWdJanpQNzZH?=
 =?utf-8?B?WnJUS0MzM3NzVStkOG5rakpOcnFCYURJVTdSNGQwR21lNE9LZUZLSUczOFFk?=
 =?utf-8?B?Z1VnSEQyaGc2Tkx1N3FJT1gzb1pzSExQMGF0N1NOZ1FaSjYwQWFJblFMRURV?=
 =?utf-8?B?dDlGTkRhejBJQmJ1cmliT2FYaFlXbDk3LzVoZEhsVGdjeEJod1hzbisxUzRQ?=
 =?utf-8?B?NzkyMXcxemxJNUlxWnJwZUVGNlA2WWE4d24wQ3czdWJEdlhsT2JFVXlBT3Zs?=
 =?utf-8?B?V25UUm0wVzl6TzdXdC9oYlRBb3lnTEJndGx6OUZaK1FvSnNoQ04xMlpOSnMx?=
 =?utf-8?B?K29IWFN6eDA5SGd0eTNMa0R2WWZLTEcyOFpGMytMY3lQUldvTGhJNUY5T3Z3?=
 =?utf-8?B?MURkbWJYQlBZMFFHSmhvdDRFeGxreG40UmxPUGdFVE8zU2JRWXdwZG16OERH?=
 =?utf-8?B?SFVhNEpKWldhNXFsMFkzWHo1NUdVRzlVTVp4Vm91cGZpc25WalNMYXZFcFUy?=
 =?utf-8?B?cDVOU09vNEpRUEFrQjdZL05IUzBSNCtzTThlVkQ0clROM3g0L2NwbmtrcUVJ?=
 =?utf-8?B?eTlLZmdId3ZBR0s0V1N0YzVITDBTbmhsaGZQODlLbHBzRFNHOW5vYk1HZ2RX?=
 =?utf-8?B?RHJlT1VkcDVSZzdGVG9wNkVUVGJhMERkY0RCY1p6WGVwT0NJRm80U2ZTQ0w0?=
 =?utf-8?Q?LJbxmybRxSX+69M8o62rKt2XE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f49b03cc-42eb-441a-1a1a-08db951bbdf4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 18:50:58.7731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R7EwIjPanNns98YcnQvSBL1uaiQfziZl60x01RRAYFDCFAif4AHh/GITZZ2JUic7TmcGRsRph7kJ82qNs0/sBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7885
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/2023 11:03 AM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Fri, Aug 04, 2023 at 10:34:18AM -0700, Brett Creeley wrote:
>>
>>
>> On 8/4/2023 10:18 AM, Jason Gunthorpe wrote:
>>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>>
>>>
>>> On Tue, Jul 25, 2023 at 02:40:24PM -0700, Brett Creeley wrote:
>>>> It's possible that the device firmware crashes and is able to recover
>>>> due to some configuration and/or other issue. If a live migration
>>>> is in progress while the firmware crashes, the live migration will
>>>> fail. However, the VF PCI device should still be functional post
>>>> crash recovery and subsequent migrations should go through as
>>>> expected.
>>>>
>>>> When the pds_core device notices that firmware crashes it sends an
>>>> event to all its client drivers. When the pds_vfio driver receives
>>>> this event while migration is in progress it will request a deferred
>>>> reset on the next migration state transition. This state transition
>>>> will report failure as well as any subsequent state transition
>>>> requests from the VMM/VFIO. Based on uapi/vfio.h the only way out of
>>>> VFIO_DEVICE_STATE_ERROR is by issuing VFIO_DEVICE_RESET. Once this
>>>> reset is done, the migration state will be reset to
>>>> VFIO_DEVICE_STATE_RUNNING and migration can be performed.
>>>
>>> Have you actually tested this? Does the qemu side respond properly if
>>> this happens during a migration?
>>>
>>> Jason
>>
>> Yes, this has actually been tested. It's not necessary clean as far as the
>> log messages go because the driver may still be getting requests (i.e. dirty
>> log requests), but the noise should be okay because this is a very rare
>> event.
>>
>> QEMU does respond properly and in the manner I mentioned above.
> 
> But what actually happens?
> 
> QEMU aborts the migration and FLRs the device and then the VM has a
> totally trashed PCI function?
> 
> Can the VM recover from this?
> 
> Jason

As it mentions above, the VM and PCI function do recover from this and 
the subsequent migration works as expected.

Thanks,

Brett
