Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C6A56B5E2
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 11:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237608AbiGHJnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 05:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiGHJnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 05:43:37 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C0323C;
        Fri,  8 Jul 2022 02:43:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cyymyYNskJrIBvOCUbprnYtwtMQLGRUrpMGWRqVy+4UFp6DtaHzefZ9mh2zYHMmtBX6GLhujAw43dZhC7hIbxEEP8uPB3qzUS/yuwJOSnPRPK24uGtjqu1rhXUARtxfPhQl6j/gMriP5YcNUnEOMMh3TZh2oietquyW2bBWsMz1+WaR72wFRJ3eklHroq7er+NWx3Hfgf/y2V4vncdCldu8sl1LeeC41Yh/mYrGe6Ne1YE/tpJwn4JFoPU34yfULCtNgYOZ/1Xi3YKOqqMfhjQWXOHSP9odbLWnmoRiquArMdksOulGGiGQoNN8MhgzvjaX1uF6ISIdP1v13eWbKug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8CCEG9fyRsNrXm6en8LTBhos6gxt54B1XntyPcLrieE=;
 b=Myeo4Swgjt9HtDbjAso/U7E6INneBOxpsfO0MtTlZ7HiyquVPY47NIWuVsnHKPwkGcxVWBdTDDnCzfU6YsLX4fPqnC8FplTP7BACT3qJcGW0CAxrwmasFIHw+rMXwFsX6pejmhKUqKbDqIljXlNfBN69dSfLzk8SSy6XuUtlsFqz/ZWITdykw7WhCs3qPir3iuwPm90Ntm/3kPl2uwagckOOy94XkgPcbwEXEhoTvA8VvXhqgSBphcNhEfFNDIB60ZeVh5qQtwxeXNqiFvhWgS4eSxgaQPDnfl+jpKxVz4AzZjc8sE/F2SCc7Yi8pE8LDv449DSuvPpdQu1N+GnbDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CCEG9fyRsNrXm6en8LTBhos6gxt54B1XntyPcLrieE=;
 b=EHJbNM2vninAmSBxbNbOpxePkpey9oPykC5bR3uhu+BFG5jQxWdpf0vXZPlQBRXGiYpft5zCzpqE3RgctclE/MEtGb7Rw//82jQzD6vvW6Z08L5thkVSnHzNaWoVnmPzGM8wWxb0xNuoYVGl3lFL89s1Uv3FX4I0lSafERAIXznPxh6VDyBwU7GfXTss1nAumAf8xlGBNfnVE1UAk7q7TSeryfcR64GeHFzAuYslF68TR6mnBfGIGSFYcjmGREZ7cGet+z7UqthJrNc2zbvFSSTvXQGLVV447wD3HAhteSKFvl4CMayyizJHC4cETBouDqtg8wDfN0SziXd4C1I1EA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by PH7PR12MB6396.namprd12.prod.outlook.com (2603:10b6:510:1fc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Fri, 8 Jul
 2022 09:43:34 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 09:43:34 +0000
Message-ID: <47aa6b7d-e529-b79a-54eb-5f5a7fe639d6@nvidia.com>
Date:   Fri, 8 Jul 2022 15:13:16 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 3/6] vfio: Increment the runtime PM usage count during
 IOCTL call
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
 <20220701110814.7310-4-abhsahu@nvidia.com>
 <20220706094007.12c33d63.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220706094007.12c33d63.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXP287CA0022.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::29) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1df68db0-eaf8-48ae-1cac-08da60c65317
X-MS-TrafficTypeDiagnostic: PH7PR12MB6396:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j0op9uxxos1QBE/o3Kg1WTUxAMBfAY6yueaXsAZyZxFoqzDDL5/e9UUgELldrkppxT9CYBsb8+KYLZ4E6px2ZI3OuN3ao3SL1AKw9sVCNKOdmY8x+WVJ+AbaIZbC7aSIkPpP5Y/v4BDtBTXXBKzk1Z1WAeK8rJH4Xa+fK01VFatiCyL+AgWsvjOF7kTt42sLmxtSP7ymPd5dF2MEetT7HIf4x7+Ed95tsTp0D+T82kIC2g/UA9jK++80RPC9t+O1erWa4AJvDG2sr+Iym7RQDNV0N6HMc6ODXrDrrPeDqs6uaUW3yvO8Yj8wbmuU6lFMzsmI+hnpLJEGRXufySrOeUdcn1PTVkYjMaKEujzbl0SdDiZlGvPum+94HEGJmjb0Yt0w89BYIUD9wXRqr3LXYB05YwOwbHxwtR1SF92MQlTPAbL6Kue6NZWLqS/jE4L32Xdie+gWxvTD3Ad43hcTt39tEeN7ni8RmJl/KFcuJwkM5LT6FH8waWJRkLQ7c9Eb5DQdILRuIW59wLJPMCsDwqfWhtmOwt9oufNsIriL6d8x68WQ2D8RD2fdOKrL+dGGfNutcyAIzKI87z68VmWfBqmmsYQuv7cujqDeDEj/Q1WAdPIUPsozfVXiFaQvxF46Bu4rHkFK/cuQZ2OJZe9oUhP37zhz/WGsh/wq2Lvf1g8ReXaObStczeJcNbyc3xsEdkToTH/urB8YwZGtHHyT1l8vR2HuqNLZqdbMkw7ieBtoPf/9VgcIuuLEIQjMl482detfME8+vj8t6JpWJJpxOM6nuu7o1cjR2RIea2dzspXC5u2viO8yq18TcmKKhdN98vQmFlmn7t3MfP+Gizdh+ET8cvOUshdnuYX5CXhs9RU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(2906002)(2616005)(8936002)(6666004)(41300700001)(38100700002)(6506007)(54906003)(6512007)(53546011)(36756003)(316002)(31686004)(55236004)(6916009)(86362001)(478600001)(26005)(66476007)(186003)(8676002)(66946007)(4326008)(83380400001)(7416002)(6486002)(31696002)(66556008)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3FmRFphV014YXZMVnlwUEVVUUhjRFRKeVVBeHpRSlNBL1hwMUlkZjkwYk9i?=
 =?utf-8?B?RmZsTEovZUpjNUMxdWViQmc0bDQybmhXTkJtSjA3dkU4N25lMjFpWGcyTmxm?=
 =?utf-8?B?WHBYc1Z1d1pzQ1E5Rjl1dm4rSlA4Njc1ZitrOWxBMHp1UWEvWDVCdzdYRjdh?=
 =?utf-8?B?Y093UXAwR2RDWTV1ZmYxQVpMTzViekU4a2xpQ2twTVRJbWJFSG1Rb0ZENmg3?=
 =?utf-8?B?T0t5UGV3Y1RvZGVjU3JOandlbHFKTVlSbE9jdFljSGFkcFpTOE5KaWMybGpF?=
 =?utf-8?B?anpHanVCYlR1REFBZThmRC94bkdxQ3lMeVBSOUU1bHFGK3d2MFJkaUUyZ2ox?=
 =?utf-8?B?ZmVNbFFNNUE3MVdZcWZwTHlWeW0wZWhmY3dLSU5VV1AwZHhHZWI4ZWx6S09Q?=
 =?utf-8?B?YWVDeFo3cnJ3YUx1VDFlSW9PZll5QnZabnFMTG0xNW44T0xwSjlKTGpoTGFp?=
 =?utf-8?B?YUZqd211ZnBkUUZLejN6c05xMlNjblVURDk2UjJtR29ZRHQ4bXU5Z0xGRWR5?=
 =?utf-8?B?QlNBaTVwU01rOXpZM3g3cldaMXJBVkhuVU5YOVcyLzlHSTB5b1Juc0o3bE9w?=
 =?utf-8?B?ZWJLVVRkTGR1dlRNTVYrTUdSaHpXMjVzTGdtTjZrWXZBMHp4RWJSMGxCRDBF?=
 =?utf-8?B?Ni95NTJOMXMxQVdzdklFS1pEY3NodWxMQ08yK3pMS3ByM1NuL2kwa1hVTXkz?=
 =?utf-8?B?cnRMYUhWa2V6b0JHTk5yUk8wUFpzRDRRdXl2ck16NXIweGZHdDc5Z0IvVWNv?=
 =?utf-8?B?Q0NNbjllY0EzZFlkb3RDenk2ODA4ZGtnd3Y3RkpjZEdHTmhKMDFvWmxtQXRl?=
 =?utf-8?B?TS91bGhsZElnYjlnTHFxNit5RmlsYlVIVjlORjE0NDI2dEl6Zk5kUUcvWDVR?=
 =?utf-8?B?YUoxOERrNUZLNDZTMFhMMHE3QjYyYVJjYWRNYWdFUUI2bVJWbWlnVWNTL290?=
 =?utf-8?B?cDBIMWE2bG1tdUFNaENvaG9PM0xkeHlBT1lFNzNGVkFkSmE5Z243OTZRVUFy?=
 =?utf-8?B?VUR6S1JMck81MEx0MXRZMkh6NmtGRTBUNGJpcGpQTEJtVjhqVm5vRElNVU1F?=
 =?utf-8?B?WHB5L1AyZUtTckIyMXU0MzZkZ3FFcnJ2OTVoZ09zeWJkcDJMNDMyOUQzaGVI?=
 =?utf-8?B?am1JcG9wY3g0ZUJKWVpRb2E3emxZV2JTdURwK0N0bUx5UHBCNWs0aThIbGJT?=
 =?utf-8?B?ai85RERNZUV5WVdHMS9MT1gxRnQwaklWd3Z0V3Q3dnc3L2pNTUFHd2xtaXd2?=
 =?utf-8?B?SlNMRjROWTdnYlljb2l1d1VYL3haM3J5U3lvMWpqYWlFZk5UTkg4OEFSNyt0?=
 =?utf-8?B?SzBWekZwUXRTb3R4SzVTaHhtRU9lS203U2tubXFSa2dlQWtheHh1UVd2Zklr?=
 =?utf-8?B?SnJ0aVFuVFA3NWtDQkNWR29vbG9BU3pNcjA0MVBZeEJkTEdLcm00MUdBY1Ix?=
 =?utf-8?B?aDZQNVQvV2ZlU0JwUmwzMDVJeVhPMTJocXJONHQ2TDd2QkJkMEM2REtoNGRT?=
 =?utf-8?B?TmZJLzdiMXJZOWthL2VsRVd4RU1GdEtEaUl4MDhPMTVFUFVrOXh6M2t4cFIw?=
 =?utf-8?B?ZjVyQkU2VjFDbGRyNEE0OWNtb2pvQ2NFUUFoeS8zUzd5bm5md0xua3dlOUc5?=
 =?utf-8?B?WFVVZ3hiK1JMZllIM1c5Skxxc1htNGg2dGMzQ3BvLy8za25sRERMOHg1cUlH?=
 =?utf-8?B?QXZjTUtKMDBpRjBVM1BoNkRXVmhTTi9IMmlydmZxVlR1cUFYQTRBSHVwK0JI?=
 =?utf-8?B?a0dpNEQ5bzExTVA2QzJmYUFzMk8wWllNY2o3N05rUDFZcS9JMFk5Y2c4UkFS?=
 =?utf-8?B?RTBqVnZGQVRhNGtZd2NBSU1YbDRYU3FRU0xvbExlM2dLUno0bnJ1cFZ6TUw1?=
 =?utf-8?B?VjE4ZnFVSC9KUVdWRGNtT281ZmVNZy9LRi8xaUE2YTgyVlNYTDB2ZnJONE0r?=
 =?utf-8?B?VkV4M3V6RjlKQnBzZ0c4YXRRaVBLaDdHRjc0dXplZnNpSWJjZ0tITmY5Vldq?=
 =?utf-8?B?MHRlMVlOS0Y2U09WNlU4TGZlSGdUcmFiWDlwT3BRN0ZsRjRxNXJCQktjeWpB?=
 =?utf-8?B?OU5GTElnVHpmc3VjNzg4RnZ6YVdJWk9CS3R5bFRQOTVXemI3R0FhMEM2S2s0?=
 =?utf-8?Q?KkQI8p1DfPUXmD9GLt3zvNHVV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1df68db0-eaf8-48ae-1cac-08da60c65317
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 09:43:34.3597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E7iUq2FqmUeY36tuIWWJsCGLDnDrdOrtVY6v5t6rOUa1XvBB8aFPWev0UijOLDzKoi0SthpHlA9ez+RjaeXPmQ==
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

On 7/6/2022 9:10 PM, Alex Williamson wrote:
> On Fri, 1 Jul 2022 16:38:11 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> The vfio-pci based driver will have runtime power management
>> support where the user can put the device into the low power state
>> and then PCI devices can go into the D3cold state. If the device is
>> in the low power state and the user issues any IOCTL, then the
>> device should be moved out of the low power state first. Once
>> the IOCTL is serviced, then it can go into the low power state again.
>> The runtime PM framework manages this with help of usage count.
>>
>> One option was to add the runtime PM related API's inside vfio-pci
>> driver but some IOCTL (like VFIO_DEVICE_FEATURE) can follow a
>> different path and more IOCTL can be added in the future. Also, the
>> runtime PM will be added for vfio-pci based drivers variant currently,
>> but the other VFIO based drivers can use the same in the
>> future. So, this patch adds the runtime calls runtime-related API in
>> the top-level IOCTL function itself.
>>
>> For the VFIO drivers which do not have runtime power management
>> support currently, the runtime PM API's won't be invoked. Only for
>> vfio-pci based drivers currently, the runtime PM API's will be invoked
>> to increment and decrement the usage count.
> 
> Variant drivers can easily opt-out of runtime pm support by performing
> a gratuitous pm-get in their device-open function.
>  

 Do I need to add this line in the commit message?
 
>> Taking this usage count incremented while servicing IOCTL will make
>> sure that the user won't put the device into low power state when any
>> other IOCTL is being serviced in parallel. Let's consider the
>> following scenario:
>>
>>  1. Some other IOCTL is called.
>>  2. The user has opened another device instance and called the power
>>     management IOCTL for the low power entry.
>>  3. The power management IOCTL moves the device into the low power state.
>>  4. The other IOCTL finishes.
>>
>> If we don't keep the usage count incremented then the device
>> access will happen between step 3 and 4 while the device has already
>> gone into the low power state.
>>
>> The runtime PM API's should not be invoked for
>> VFIO_DEVICE_FEATURE_POWER_MANAGEMENT since this IOCTL itself performs
>> the runtime power management entry and exit for the VFIO device.
> 
> I think the one-shot interface I proposed in the previous patch avoids
> the need for special handling for these feature ioctls.  Thanks,
> 

 Okay. So, for low power exit case (means feature GET ioctl in the
 updated case) also, we will trigger eventfd. Correct?

 Thanks,
 Abhishek
 
> Alex
>  
>> The pm_runtime_resume_and_get() will be the first call so its error
>> should not be propagated to user space directly. For example, if
>> pm_runtime_resume_and_get() can return -EINVAL for the cases where the
>> user has passed the correct argument. So the
>> pm_runtime_resume_and_get() errors have been masked behind -EIO.
>>
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  drivers/vfio/vfio.c | 82 ++++++++++++++++++++++++++++++++++++++++-----
>>  1 file changed, 74 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>> index 61e71c1154be..61a8d9f7629a 100644
>> --- a/drivers/vfio/vfio.c
>> +++ b/drivers/vfio/vfio.c
>> @@ -32,6 +32,7 @@
>>  #include <linux/vfio.h>
>>  #include <linux/wait.h>
>>  #include <linux/sched/signal.h>
>> +#include <linux/pm_runtime.h>
>>  #include "vfio.h"
>>  
>>  #define DRIVER_VERSION	"0.3"
>> @@ -1333,6 +1334,39 @@ static const struct file_operations vfio_group_fops = {
>>  	.release	= vfio_group_fops_release,
>>  };
>>  
>> +/*
>> + * Wrapper around pm_runtime_resume_and_get().
>> + * Return error code on failure or 0 on success.
>> + */
>> +static inline int vfio_device_pm_runtime_get(struct vfio_device *device)
>> +{
>> +	struct device *dev = device->dev;
>> +
>> +	if (dev->driver && dev->driver->pm) {
>> +		int ret;
>> +
>> +		ret = pm_runtime_resume_and_get(dev);
>> +		if (ret < 0) {
>> +			dev_info_ratelimited(dev,
>> +				"vfio: runtime resume failed %d\n", ret);
>> +			return -EIO;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Wrapper around pm_runtime_put().
>> + */
>> +static inline void vfio_device_pm_runtime_put(struct vfio_device *device)
>> +{
>> +	struct device *dev = device->dev;
>> +
>> +	if (dev->driver && dev->driver->pm)
>> +		pm_runtime_put(dev);
>> +}
>> +
>>  /*
>>   * VFIO Device fd
>>   */
>> @@ -1607,6 +1641,8 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
>>  {
>>  	size_t minsz = offsetofend(struct vfio_device_feature, flags);
>>  	struct vfio_device_feature feature;
>> +	int ret = 0;
>> +	u16 feature_cmd;
>>  
>>  	if (copy_from_user(&feature, arg, minsz))
>>  		return -EFAULT;
>> @@ -1626,28 +1662,51 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
>>  	    (feature.flags & VFIO_DEVICE_FEATURE_GET))
>>  		return -EINVAL;
>>  
>> -	switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
>> +	feature_cmd = feature.flags & VFIO_DEVICE_FEATURE_MASK;
>> +
>> +	/*
>> +	 * The VFIO_DEVICE_FEATURE_POWER_MANAGEMENT itself performs the runtime
>> +	 * power management entry and exit for the VFIO device, so the runtime
>> +	 * PM API's should not be called for this feature.
>> +	 */
>> +	if (feature_cmd != VFIO_DEVICE_FEATURE_POWER_MANAGEMENT) {
>> +		ret = vfio_device_pm_runtime_get(device);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	switch (feature_cmd) {
>>  	case VFIO_DEVICE_FEATURE_MIGRATION:
>> -		return vfio_ioctl_device_feature_migration(
>> +		ret = vfio_ioctl_device_feature_migration(
>>  			device, feature.flags, arg->data,
>>  			feature.argsz - minsz);
>> +		break;
>>  	case VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE:
>> -		return vfio_ioctl_device_feature_mig_device_state(
>> +		ret = vfio_ioctl_device_feature_mig_device_state(
>>  			device, feature.flags, arg->data,
>>  			feature.argsz - minsz);
>> +		break;
>>  	default:
>>  		if (unlikely(!device->ops->device_feature))
>> -			return -EINVAL;
>> -		return device->ops->device_feature(device, feature.flags,
>> -						   arg->data,
>> -						   feature.argsz - minsz);
>> +			ret = -EINVAL;
>> +		else
>> +			ret = device->ops->device_feature(
>> +				device, feature.flags, arg->data,
>> +				feature.argsz - minsz);
>> +		break;
>>  	}
>> +
>> +	if (feature_cmd != VFIO_DEVICE_FEATURE_POWER_MANAGEMENT)
>> +		vfio_device_pm_runtime_put(device);
>> +
>> +	return ret;
>>  }
>>  
>>  static long vfio_device_fops_unl_ioctl(struct file *filep,
>>  				       unsigned int cmd, unsigned long arg)
>>  {
>>  	struct vfio_device *device = filep->private_data;
>> +	int ret;
>>  
>>  	switch (cmd) {
>>  	case VFIO_DEVICE_FEATURE:
>> @@ -1655,7 +1714,14 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>>  	default:
>>  		if (unlikely(!device->ops->ioctl))
>>  			return -EINVAL;
>> -		return device->ops->ioctl(device, cmd, arg);
>> +
>> +		ret = vfio_device_pm_runtime_get(device);
>> +		if (ret)
>> +			return ret;
>> +
>> +		ret = device->ops->ioctl(device, cmd, arg);
>> +		vfio_device_pm_runtime_put(device);
>> +		return ret;
>>  	}
>>  }
>>  
> 

