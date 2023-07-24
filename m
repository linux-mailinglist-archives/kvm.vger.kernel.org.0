Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4705175FEE9
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 20:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjGXSS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 14:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjGXSSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 14:18:53 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2042.outbound.protection.outlook.com [40.107.102.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF46C10DE;
        Mon, 24 Jul 2023 11:18:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ON7yJJqt9peF3kqUyPM1AWHFYtec5Seg1FiSF/+pOaeu/fcuLPwdQCqmaepevbRJfSpPjg9YIe9Tfw07r0N5w8EuCdqUKLw9emnKKtITMra+N0VBMtJ543CUGj5HNlGd2iKnDlNb3FHcIH4ZN51OonP/W82Wou9SH42zTYSQHk4+dIyEwJ2rL13hbGv/NZjB1WrJz9zMIhHLyNterqX3PkKALBFNsS2D6fk+cRje3yKhQn9qP/xxudXS/LPErs338puK2z/+ZQM7BI4SRb/8rsB+lB/jz5zDF8KDC3sKqMzM0+7ZnSIdLuDtSi//jpw8mG7s98+T+pRDlG/9CI66bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e2ACnDfXnmMH+cy6Z6Pt0ASdFzOL/ws/5i537Pcct6U=;
 b=TQYq/0ZQKziii35S8KddX7Qyag2OTowJ+VcgKvI80eqXPQw2C2pBRuxhVFsSKYoPZ7jVdbFE/+u6uBvwHZfc4L/akQKjAvyK+youcjR8SZZtZ7Lk72dM/V8v7BL/0ShY9Xzz0AfUu2Gn2Mj6qy6R2+twhgYatnbMntg62mPsTRU51no5G8Xb3NmwOjQzOAAPsx1mWazI8Q9lzmVJCBoqZtcvWtfpHpUmhbZj5cPYRFezSz0moJ+PLTwDiwHiZ7c1ifqSoZZ3/5m9cOg6AlVxykd9eRM/p7BJnXEbKc1tp1edNYDG6SiHsoQi6MBlyHBH/UeKSMrRrbqMu29HMvsRPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2ACnDfXnmMH+cy6Z6Pt0ASdFzOL/ws/5i537Pcct6U=;
 b=lns7EE9VKf75jjeD9/Qn/Socmar7qAXyEomvIXbbE2nSf72cOlis4w0KpiR0HHULKPc3apq19JnvkYP39HT22GebcVHT7shWx5n1yflu1B6Hm8XrpJmDUg45YNYvY1bepvAN1TwTk7ig9/L5e2Ld21myQmmsbgh4Tjm4swoc/6E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SJ0PR12MB7473.namprd12.prod.outlook.com (2603:10b6:a03:48d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.31; Mon, 24 Jul
 2023 18:18:50 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::6872:1500:b609:f9cf%5]) with mapi id 15.20.6609.029; Mon, 24 Jul 2023
 18:18:50 +0000
Message-ID: <cc44a695-2e3e-e9c2-1025-6c89cd87d3cc@amd.com>
Date:   Mon, 24 Jul 2023 11:18:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v12 vfio 3/7] vfio/pds: register with the pds_core PF
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Cc:     "shannon.nelson@amd.com" <shannon.nelson@amd.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-4-brett.creeley@amd.com>
 <BN9PR11MB527656A2E28090DDA4ED07728C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ea5cd85a-e29e-d178-5b17-1440be84f5fe@amd.com>
 <BN9PR11MB52761F84D9EDF16B158AC9A18C02A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <BN9PR11MB52761F84D9EDF16B158AC9A18C02A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0270.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::35) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SJ0PR12MB7473:EE_
X-MS-Office365-Filtering-Correlation-Id: 16180a07-9fcd-456a-4c55-08db8c726da0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/h+hpwXAg6Kj2UgTQkqrsEKTz3dgt7pEepPt2148M1Lf0wZHSewu/w219HCa+XSKweQlVfepDPGLTor8ND4xWBX7u+uT0SRZBx6kVq/hcYAQBEPNGGFDSNnAV0gmRmwbjINeZp6nu0Kpye2aaQCFB7eATYLupJuvEgn6Mu1gvwkcCzt6wJXFWOv6/00qtPqHnLDPExGE35R1/4O2GmfLX6OoeEZ8CYV/7Br1uA9qdJ4B5c07kXRPGPyRTyMZyN39kh3U1BbUqsN2UlknkuOtAsFiMHYVsWYJlWaxED8HsIj/ZCsOso8Dqn+XP7PjIO5ct7G8Wn61YGAdKit2BtlkhiLPKqAvJIonMcMe/DeaIEjrK8C1BSHyzP66VyDAO5uZO5xCZ2nWb5QRojeWABpRPAw/kGGl7lwtzV+bbi9NkVSVDjOQ+jpnhC1rQB/ch0NdPcljBP4tcbw/rmwZzxoLyKjOEpKw2lli+bEBAh8dDo2IN7KzhaXDj9hGVc74SMiD/8ZhL9yoKESHIJiyjdZDoPTKdttN96VPbyPBz/vvPcs4Clc64ICvIG15GOH5UdUHevmknYQshanSCtjC0BK9xeNN65o6bXloRVjrF0tCp++7WsAGTHbtzrNWWpIUc3jbJxB2yeIFHgFNwvUE9d/cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(451199021)(2906002)(478600001)(38100700002)(8676002)(83380400001)(6512007)(186003)(6506007)(26005)(2616005)(53546011)(8936002)(31696002)(5660300002)(36756003)(6666004)(6486002)(66556008)(66476007)(66946007)(316002)(110136005)(41300700001)(4326008)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHdaQVBLeVU3L3BZaERYUmJ1dEY0UkJCWEtlLytMOE1iYW9ma05tY3IvRUhN?=
 =?utf-8?B?MG96aVdWS1k4TlBselJuMHlFWnIycXZFdG8wUnRJSnJTUElsRlFlWnFjNXBI?=
 =?utf-8?B?RDIra2FVSUIvaUNLTEc3TzR4TVYwZnFFS1U4dU9Oc0NqU2N3bGlQOGdEMmwx?=
 =?utf-8?B?SVNxN2ZDbnVodGs0bVZLclY0WDFRNXZrT1dYMHlGblZIb2FzWUFFdC8wRlE1?=
 =?utf-8?B?d25sdUNxKzVxK3pZbTdvZHpjNFhvZGJGNmZGNEFacDNGY21YSmpsd0hBOWhH?=
 =?utf-8?B?V3dPV0pGSlFtUnRUWVRQSUc4am9jRWIvU3l4N3VlSjJMZ2FjSnRNWDNHZWFQ?=
 =?utf-8?B?UHMyUkV5bXpNTlFKTmpPV25mSFhvVkFQVXkvZkVUckZYUW45WlZOaUtyS2Iv?=
 =?utf-8?B?ZWRiWUl4QlVibThncHFXTnVocHZJVFpjNDZQRUdZMDlBNjdXekRyVDhsc3hY?=
 =?utf-8?B?bU11dWl1TEZYOG5aL3Vzd1RYQWtMK0xZVGpnSjVPa0ZEZjRGMFJzL24yVFps?=
 =?utf-8?B?TG9PSnBPaytFcWZKQ0UwN3djbHc0T3BnNitkRzNnTVhZeTZQTkU0c0NSQm5P?=
 =?utf-8?B?SXhybEFzY2lYNGdJeC9kd3JCYmJxL3RZZmc4U2drcGNBTzAzNyt0cC9MVlUw?=
 =?utf-8?B?di84RlV5cklSU3Nvc3NSY1d2aEkvMno2cWZCSGNFeTBCQVVEbHltZmNod3lY?=
 =?utf-8?B?UGRCQlNMNStZR0kyNFZmbW93Snkxd1Y5dU5Ubk1SaVVpc2ZkQ3pqeGU1QitR?=
 =?utf-8?B?QnVud0JZaHgxZEZvWVl4Q3d0SldtUzE3Rk9JWWJVR3U2ZjEyY3d6MU5zMGV4?=
 =?utf-8?B?YzlEbGxHRmt3dTd2eWJmT3VxeU9ucFBFK2JEczlaWWJGLzY4bURidC9COGI1?=
 =?utf-8?B?STIrOGRmMTVhVVFhMWY5SjhoeDRyZCtURjVITEdjdGZyemo3VEFlM0JtdFJ6?=
 =?utf-8?B?YmhMOFdYVmQrbjA5Y1NueXVPdi9uemZpOVRQUHZVbWI3WHd5MzVQam55VFB4?=
 =?utf-8?B?YmdPbXJWSFNOWktZT1RHUVM2NlErdVBINFpieVpKME9FRHZqNWJmQXhMZ1NL?=
 =?utf-8?B?OFhPOCtQaGV4ME9OZERnTmV6N2lnQkN0ajV5VlFIWVRMQk1XbzZ0VzlpQXlJ?=
 =?utf-8?B?UEdHeXR0UHhQWnBlaFh0SGt0cjdseVJIUy8rcFJTM3Iycy90eVpTbHB2a0th?=
 =?utf-8?B?Rk93bExCT2xFZFZTdFc0WFA0WkR3L3gvdDFLckp3NmVGVGlnU0ZxNlZRVXNi?=
 =?utf-8?B?SmEyNmhwOUVZNG14QTBrcXhiZ25CdUkydmg0L0FUaENFTGNWTThhZ3hMT3dK?=
 =?utf-8?B?V3lUOXpsMkR0aldXN2dFRERqRzByYkpRd3hVTHVITjJzWlRxNFlOQW5MdkdF?=
 =?utf-8?B?QXJWN0RPYUJjVlVXbnprTG5XQnc3Q05UTWhsV1JYak9LOUNaRXJKdS9DTFov?=
 =?utf-8?B?REpLMTdlWEZTTFJNZUxjTmR5cE1hUTFyeWY3YWFUTzJkakxPZk5keUhyY2lm?=
 =?utf-8?B?ZkUrWlUvNElkeWhuUWVZSE9qYlJlSytXcFZxTE1QTXlNZFI1VDNYWmswN0o1?=
 =?utf-8?B?VWdJTXpUc2R1ZmM2bFZCNm9EMk1LVEltSXN1ZFlmQ20yNDVERXUwNjZrZ3dp?=
 =?utf-8?B?UkxKdCtaZmkrUDltbE54Vm1IV0ROLytZY1NQU1FrMkRYUGIrMEh1bTF4M3BW?=
 =?utf-8?B?UVNHQkZtQXpTV2ZXZS9KWWQ5L05HQTZjY0IzUG5BUzh2ZGxrZWRQZlBwcm8r?=
 =?utf-8?B?WlBnQjJLS3k3SWMvaUhqN1lXSUVrNlNUR1ZHazVXLzFDekxBSlFTdUtPNFlx?=
 =?utf-8?B?akU0UVkvd0FqSVlienEwTkVPN1ZTajhra1NSeUQvTk5aR2QrTUtpWFhvUEQ4?=
 =?utf-8?B?c2NVekx2dzhXeFFHNHFTc0x3R1lrcGJKV2tweGRLTFFUWHViSzJtL0VjRHFa?=
 =?utf-8?B?ZXkvZlhXSEIxS3RybGZyUHk5dUdka0liWnlFekIxSVVrVGhvL012Q3NWSVZa?=
 =?utf-8?B?ajN0YXhiZzJWL0RMNjk4Q014RzlXNnBLbGRHRGxucU5TU01icEgyZE0yTkli?=
 =?utf-8?B?MFFzZmxlb2tNV3RsZTI4d2NMdXA5T3dSRjlXOWw5eUp4Ly9rd0ZBSTVWV0dt?=
 =?utf-8?Q?IjuXWdij2dMzPnYADN+A0Hs0Q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16180a07-9fcd-456a-4c55-08db8c726da0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 18:18:49.7649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DdAki/Ee5nG0MY3uykOXAvT5OsVd3tGeWI3CyHQZbkfuWG1LJT+hJ74NQ/RkDYsk6RyAHjOtrfaGgctYfwf+oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7473
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/23/2023 7:25 PM, Tian, Kevin wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> From: Brett Creeley <bcreeley@amd.com>
>> Sent: Saturday, July 22, 2023 3:10 PM
>>
>> On 7/21/2023 2:01 AM, Tian, Kevin wrote:
>>> Caution: This message originated from an External Source. Use proper
>> caution when opening attachments, clicking links, or responding.
>>>
>>>
>>>> From: Brett Creeley <brett.creeley@amd.com>
>>>> Sent: Thursday, July 20, 2023 6:35 AM
>>>>
>>>> @@ -34,12 +34,13 @@ enum pds_core_vif_types {
>>>>
>>>>    #define PDS_DEV_TYPE_CORE_STR        "Core"
>>>>    #define PDS_DEV_TYPE_VDPA_STR        "vDPA"
>>>> -#define PDS_DEV_TYPE_VFIO_STR        "VFio"
>>>> +#define PDS_DEV_TYPE_VFIO_STR        "vfio"
>>>>    #define PDS_DEV_TYPE_ETH_STR "Eth"
>>>>    #define PDS_DEV_TYPE_RDMA_STR        "RDMA"
>>>>    #define PDS_DEV_TYPE_LM_STR  "LM"
>>>>
>>>>    #define PDS_VDPA_DEV_NAME     "."
>>>> PDS_DEV_TYPE_VDPA_STR
>>>> +#define PDS_LM_DEV_NAME              PDS_CORE_DRV_NAME "."
>>>> PDS_DEV_TYPE_LM_STR "." PDS_DEV_TYPE_VFIO_STR
>>>>
>>>
>>> then should the name be changed to PDS_VFIO_LM_DEV_NAME?
>>>
>>> Or is mentioning *LM* important? what would be the problem to just
>>> use "pds_core.vfio"?
>>
>> LM is important for the device. I don't plan to change this.
> 
> What about in the future VDPA also wants to gain migration support?
> with VFIO_STR in the name does it make more sense to at least
> define the name as PDS_VFIO_LM_DEV_NAME?

Sure I can rename the define that way.
