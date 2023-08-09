Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA60D776446
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 17:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbjHIPpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 11:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjHIPpV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 11:45:21 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2083.outbound.protection.outlook.com [40.107.212.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AA9F1;
        Wed,  9 Aug 2023 08:45:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RM1rR/+aeqplAbv65hKiF2GwADfYYdDQ8hlfMeBGtCdCnTiDdLmCCwgIEx1PhZWsgwJA4I1IbZrcMcqDwC3+M3JMo1y/P8DJKqAyhQ5K7OMQk/auu4BC8MTwYXdCEd/PWKi9tEwY9U4G5RxSSA/MgJhJxUEZgRDQQeHecPY89TYGaxRvgUIQfwJi6yTCaIRycFJ81MfdZY07kqfV3s7wZg98OE3PrPvbz6UQN8q3zPcDer2gNWK/qpvs4/RS4rgAXkSn2L3xG/g+aaNI9NiJymE87i44GEniNEPF2BZVOY0VnjtKx0AoAGFbvIH+0fdRK7yk1+AfO6xycUxDLN572g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xpmpiKNBXBGD0h+w8Kc2kx7EYySgEMBTpZe3gjNroe0=;
 b=N0tkLOAB3deCkmqVwNq8timMz0FrpWlf9WFN7ASeDV7STpLaB77D3nh500BuMoAc0phETihYPOh6d5yCGW/9IAtSshXzyDXyS1DtnP688/Bmax5NKjhlVkXFF6t7U6Noj/v1KpaTZ0VzBXaw6zCAwXujKJVS3QxiNpFJ0tRrIZpeKoIDuK3MoAiT5bV6WSUp8wqT9tV9p1s2gTTjy4TsltibVgYqrJtu6Wv5UTRPg4ncM7D+2e8vSruoAfoZsFB5det7q3Mw9RV4Pz9gWpRQIyeW5OXhB92xqEjOp5yNy2njLDrgUvt2t4JJsuZ32ftmBrpZYMPfiESv+J8tMs+VLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpmpiKNBXBGD0h+w8Kc2kx7EYySgEMBTpZe3gjNroe0=;
 b=5Y1hObeglDEOuNegSwA8pLVqHAXBxaJ3VgK8a/gI9ly4BhpChJcnn8Kpd9X2QJtvcs1pthiSr8c4BmLbvMzxOtmHrp/thwocoySq6iRRzR5hfoq/FmxQmx1MqOCsgRFS5bMmkH966yCgTOzN61gTgZKdBMOANNG5vC5xsuVK3Wo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DM4PR12MB6613.namprd12.prod.outlook.com (2603:10b6:8:b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 15:44:15 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%4]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 15:44:14 +0000
Message-ID: <ff61f675-a5a8-d1d6-a1bf-a5879914b4a9@amd.com>
Date:   Wed, 9 Aug 2023 08:44:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v14 vfio 5/8] vfio/pds: Add VFIO live migration support
To:     Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, horms@kernel.org, shannon.nelson@amd.com
References: <20230807205755.29579-1-brett.creeley@amd.com>
 <20230807205755.29579-6-brett.creeley@amd.com>
 <20230808162704.7f5d4889.alex.williamson@redhat.com>
Content-Language: en-US
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230808162704.7f5d4889.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0026.namprd07.prod.outlook.com
 (2603:10b6:510:5::31) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DM4PR12MB6613:EE_
X-MS-Office365-Filtering-Correlation-Id: bd7ceb0b-4d61-4fca-1614-08db98ef7bc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XrNx/3dwPSMoj+/7HqiF0ImJrkQEat/BniDPT2LJK4BCRljADDMCVuy51LtQ2/450n9slToiAPwYnzgU/+iTRuYwIw6lpuRXc9jng5AT+J3FgjAWyA3ubUv8TA5pXEB0tAR/xyphDj7CQ7lBE9d3g21MNjNRHnh1WLwNvSqU0FF8xaDMqm2BZvVQJZ7zslTshXoIFRyc0EIxMP5uOn7Lel+LRAoE5jxWEAtj8Jdy6XyS45CyGLjRyBghR+QlBa+ON21wt5Jj4mkgrW5d0/AKBY6Vzs9xW3Gdk/2jH6moK6FeBbeCeyGHZLFYNc0lilY+zwldSSTImTv3M9rgt02x19aqNP7BgwvgRBqqyKaPrrgeGEyd3z3cFzNzKo74pUbmcXPW2moRr6qczgqdLMRozcU4X0uISCmlgjHcJcurMuvruLdO/dFHvlgMlD0PfiG1WEvYDgEJ9GbS1qF3/ZR33ej+HF6O32CLEY7a3E1mudPmQD7BB7qgu2HvYQdHYLzoaHP9PmjM44gdGJtlZz9mIXGT0kD7hVnDWnNjQ5zxof25rG5sRksLmXCtWS9wJIB5XWDNfoFeOJ49aI6Flj+9LPS+iXXTXtM4/U5N1p7l6axv55vc5jCjC6pb/D5X6RkM1Y9gl8QXDRGCArufNBl3Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(186006)(451199021)(1800799006)(31686004)(6512007)(26005)(53546011)(6486002)(6506007)(478600001)(110136005)(38100700002)(2616005)(83380400001)(4326008)(66946007)(66476007)(66556008)(6636002)(8936002)(8676002)(2906002)(41300700001)(316002)(36756003)(31696002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDd5RkUzZVdCYTBEdndLc3NQSURWQldzMk1xUTRtbTlFTUovVUxvaEhaSXdC?=
 =?utf-8?B?Vm5vUGwwZmJmUks1SC9SSncvMTRJaUlONmlvU2Z4Ty96OEtxRW95dWgyQkIr?=
 =?utf-8?B?R1U2ei9nN3k4UmEzVUdnaGRQL1I4TU9NQ0hnKzBua1lWNEJWNlR2Y3UzNElP?=
 =?utf-8?B?YUpYWnFVdHBXYkZWTlJ6dUI4N1JRbi82YjNvU2FkOWdrYzFKMW5CWkZhcDMw?=
 =?utf-8?B?Vm9tdmhIdkttS0F0MHhPaFBpK2h6YUhQbW5lbDNiRmxHeFVxUGlJdS9uTWdX?=
 =?utf-8?B?elFJbVhpb3kwN0luZHR2OGlrN2lXWXRRTTdDQmFXalA3a3l1OGJlSmRiWXd1?=
 =?utf-8?B?WHRBeDd2VDVvTWwvZnByaW5DcWoweTdSOU5JVTlyR2hVUC9yV2JLY0hoeTFQ?=
 =?utf-8?B?a2wraFVqQzlQK1NFLzVqTUVuSkp2cnV1Q3hBRG1QQ3V0U0Z6cDNmdTc5enZ6?=
 =?utf-8?B?a3RpL0hVZkRMVWZXelB2NVVPUmNEaEpPQTRXYm5CUXhJTFZ2Z3YwL21yK0lQ?=
 =?utf-8?B?ZFdwZi8yTG9nbytON2l3QWhacGxNUkNtQXd2Vm9oM05sZFB3cmJZanZLdHE1?=
 =?utf-8?B?Z1E1SGFRdjdzdHdVK2pQL0JFSXFQWk1xclNQQ01IczJ0WjJoMm9BcVd6bUxV?=
 =?utf-8?B?QjZFbXRqdFU0Skg0NGNRU3VqRVNsa3diS2tjM2JYNlczUWxoOFRKT3E5STJo?=
 =?utf-8?B?L1hvMy9KMTd1cGFrTW8wRmxmV2RVMjZmbnYxenFNVnpRMXdHRFByamhoWE83?=
 =?utf-8?B?Nng1ZHJZdW5ZaW1EYkEwSmlEQkJaUWc5bDBqZnZzOXZ5Ulh2akJ5U3kwNCt2?=
 =?utf-8?B?VitTZFUyQTc2YTFwTzA1M29mc2UxcFY2cnBBbHVDc3dBK0RKb0cwMlFQWnU0?=
 =?utf-8?B?MEpPQUY5QXdZUXlFMlNucG5ldm16U2s0WjVtcUdOWUJJMzJkWVVUemsxZ2xG?=
 =?utf-8?B?emdrTGZlRlJDc2R3T1l3cGJIZi9Rd3gxYTZJWnp6ZXovcXdZSWw2d1BjYXYv?=
 =?utf-8?B?OWh3dkFWalE5ZC9NT0c4ZUJyL05sWm02bm0veFJ0VmdjM25YRkFET3Fra3hi?=
 =?utf-8?B?alQ3UWRwNFpBTDZ2Q2YvMHJOMThXT3JzVXBybUtlOTczTDZ5ZDUySWlWN1U1?=
 =?utf-8?B?bnlLQUNONW54WEpqbFFpUXpkQVU1UFIxMW52RVl4M3gvVkYyV3U3aXBPMzBJ?=
 =?utf-8?B?R21YUHVkbUp2WEsveXIyd1AzdHRLeGY5NFF1S0RReUVTSlh3NHcrUXpMYU5W?=
 =?utf-8?B?dDJzanlMY0Q1b29JVWFIQ1VDSXBDd0Qvd1pYTXM5cDlUVVNpbkw0MkVDNiti?=
 =?utf-8?B?N2VQY1pkK0pCR2tOWStOQnlvVWxEaDloazcyMUFXcjE4TVhsYXA4bGdYTWU1?=
 =?utf-8?B?UlBnKzNFdkZkRFQyVkYweko4YjZTaXg4TUtBY1FtM3c0djhHeXczb1VYS05M?=
 =?utf-8?B?Z3cyc0w2WGo1YjIwQ2M4VUtiWElJWm9GYTl6Z01BYmZGVXBXb0Y5TlVTa01N?=
 =?utf-8?B?dVN6K3JXUDIzOTNuL3MrV2VNVVhmQk9jTGtmeFl2TnRyRWhsZHBVQk9MaFFS?=
 =?utf-8?B?KzUzN2h2eU1xVG1ZbUxrSE43TU1OMkVxS3p0bFo3V1BUVzA1WTBuSWRhWkdJ?=
 =?utf-8?B?Ums2TUZ2VEtORWNWTTFnbERFYk5KSEM3eVN6enpxVHAvNFlkaTdKUXFuQlFz?=
 =?utf-8?B?MXcxTmFrTUV0Mzc5STl1Q1RSa2tiTzBVNTJCMVcwbHh0Mnd0VHAxcEcraXZR?=
 =?utf-8?B?Q20wRmpVUWJPanBJOXdzSG1RQUV2TFA0Q213eWFuYWNCQ0xwT213T0doNWoz?=
 =?utf-8?B?bndwbTZVL2hFQnpwbW1pdEZua0FHeDMyYW8wQmt1OTZwYXV6a3NZMWVndGpN?=
 =?utf-8?B?U253Tm1ZUHVsNzJuOUk0OU5tdjFLMlVDQmdlZHk3M2lETFFabTlKdUtIaUtl?=
 =?utf-8?B?UFhEMXc4NlJxNmxvRHFrVnMxSlAvdEQ5TDRHc2ZFWlZ1bVdtOW8xUFJMaXVR?=
 =?utf-8?B?L3dYS0t1d3V0c2dOcHJjemVEZTF3ajduS1ZZOEF1YUZMZXhzbFhJRXI2QjR2?=
 =?utf-8?B?eUtyL2JBZUJKdERId2MzV0gzT2l4Z0RpUSt2Y0NpcXJpaS90MWJqd1QvQiti?=
 =?utf-8?Q?ZMRoKdCjPbs/erN+7TSCM+/oC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd7ceb0b-4d61-4fca-1614-08db98ef7bc4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 15:44:14.5469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oHVVVErkwUZME/GfED1DJ+RNsniIesEqcPC0LbKyfLfElZfAmYOXA7J0S+iKyq9NwGm0JsA7Ij+eDAndsxp5lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6613
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/8/2023 3:27 PM, Alex Williamson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Mon, 7 Aug 2023 13:57:52 -0700
> Brett Creeley <brett.creeley@amd.com> wrote:
> ...
>> +static int
>> +pds_vfio_suspend_wait_device_cmd(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     union pds_core_adminq_cmd cmd = {
>> +             .lm_suspend_status = {
>> +                     .opcode = PDS_LM_CMD_SUSPEND_STATUS,
>> +                     .vf_id = cpu_to_le16(pds_vfio->vf_id),
>> +             },
>> +     };
>> +     struct device *dev = pds_vfio_to_dev(pds_vfio);
>> +     union pds_core_adminq_comp comp = {};
>> +     unsigned long time_limit;
>> +     unsigned long time_start;
>> +     unsigned long time_done;
>> +     int err;
>> +
>> +     time_start = jiffies;
>> +     time_limit = time_start + HZ * SUSPEND_TIMEOUT_S;
>> +     do {
>> +             err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, &comp, true);
>> +             if (err != -EAGAIN)
>> +                     break;
>> +
>> +             msleep(SUSPEND_CHECK_INTERVAL_MS);
>> +     } while (time_before(jiffies, time_limit));
>> +
>> +     time_done = jiffies;
>> +     dev_dbg(dev, "%s: vf%u: Suspend comp received in %d msecs\n", __func__,
>> +             pds_vfio->vf_id, jiffies_to_msecs(time_done - time_start));
>> +
>> +     /* Check the results */
>> +     if (time_after_eq(time_done, time_limit)) {
>> +             dev_err(dev, "%s: vf%u: Suspend comp timeout\n", __func__,
>> +                     pds_vfio->vf_id);
>> +             err = -ETIMEDOUT;
> 
> If the command completes successfully but exceeds the time limit
> this turns a success into a failure.  Is that desired?  Thanks,
> 
> Alex
> 

Yes, this is the desired behavior. Based on the testing we have done and 
downtime expectations for live migration it seems like the suspend 
operation timing out after 5 seconds is reasonable behavior. It could 
succeed, but that could also be the case if the timeout value was 10, 
20, 30, or more seconds. Even so, it seems like we don't want to keep 
spinning in the driver forever and we also don't want to further 
increase the VM downtime.

Thanks,

Brett
