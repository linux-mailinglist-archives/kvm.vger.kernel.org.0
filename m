Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE845770732
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 19:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjHDRe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 13:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjHDReY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 13:34:24 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD9CA9;
        Fri,  4 Aug 2023 10:34:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWJk+k8yZ5U6/rVii6qyKQjpoa1tcugyC9lTFixbl3PsjeUr6be9BovUCWqz+bv5O1Ay2CB/lj4bl65z3yYl2BGtcXXSQqJJsHWcafIAGtlv3H133WJmNqjmnTCZqC3ewMipP4cRrQ2yqpnn/ImRQjalNxsr/G0HEdpGvneg6jtD2TzV/iCE20RZwAMjQHoMflGQ1xf5lhIGMtLTR8QgNUp+oKrfP63pWn3IXjOg7evLfhtRyMpcN8tnC/IFTdceqPW+Zen6uw31pCunXA3e7LNe9j4nk0lk1cmNgsmOotelEMSxnFmzJi93UHvhDrgpIWnnInHaDMLcV1zIojG4rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mW5ZbnxUWYIVLc3NWlab6OvwD4v5G5VWWM0bySUv1NY=;
 b=A8saE47AYcw545PftGuKhWrTxFiHugG/BmXDVFWe/vhFclX6j4EMPXD/2XKPhBaCxLIlxCNmdqyoRTvUOBKZdiD4jT1eGQxLq0HMIIXLY3bLQrTbLZB4F2sCEEElDeLoN8jzbS5oYxyAIpaYAFIvGiSnk8cRe73xHJufKFZSjvgmrXTuoP+0HSPIU2JUKaNe7UMxQYDQuNgOl7x1nuKXVx5makwNR9Ng7dRouGd88I8kxZhLfkIZYcrtzDR41PKx9JjwbdqsUfiTjgSM9sRygx4CbdAbGhnonsBt4VL4tJeZrrUoBg7UyyIUTP2KCivu7zZGpPzJss37ZWghAq9V4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mW5ZbnxUWYIVLc3NWlab6OvwD4v5G5VWWM0bySUv1NY=;
 b=h/LEDQ8il3GJlILpzVfSay+GfD+WezlEdsdKEHIwcXKvnr5J/x4ShPL76xHJfFkedIEgxSzqay73WK/Fck1A126TySjwR1FSm/uR27zUOYk7dqcX22wZBAWVaCZNcr46sWsdlXe7iJuTXih5gKD5nsSOykUU8PMBkX7426D0xsw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DM4PR12MB7718.namprd12.prod.outlook.com (2603:10b6:8:102::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.21; Fri, 4 Aug
 2023 17:34:21 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%4]) with mapi id 15.20.6652.021; Fri, 4 Aug 2023
 17:34:21 +0000
Message-ID: <73aa389d-7ef6-5563-0109-a4d6750756df@amd.com>
Date:   Fri, 4 Aug 2023 10:34:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v13 vfio 6/7] vfio/pds: Add support for firmware recovery
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        simon.horman@corigine.com, shannon.nelson@amd.com
References: <20230725214025.9288-1-brett.creeley@amd.com>
 <20230725214025.9288-7-brett.creeley@amd.com> <ZM0y9H0UbHHW8qJV@nvidia.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZM0y9H0UbHHW8qJV@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0181.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::6) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DM4PR12MB7718:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d2353ca-3c75-4925-ef4c-08db95110989
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ha/bHjuJ3YiQNtd/Gx2KWISrnbpOpZl/QR3SNNw0YXbnLrap3uITOst31+DrG3SGiDlzJHjCRYHYoDIhB8GLTwnK3oJRXAB1Ote6+Rs7JSVaYPcx9o/Pdrmei5uwUJXtWM50b24OeTo4eaPZF9/c3S3jlql5jhkhYvB4i6JhKrI2uPL1OOZHkTmbGwcJd3zpAipLypzo37jQSlieHx6kgDP4ys+CVdgspfDg0G7N2dbU1LxzkFPR6GQ9ukQHrJCNcm6BPo4XzPt29+pmVl+Ecs1XjV/g8JKYLDvASvvQ86nS98x6supFXWFSSg7Fv6ofPLMi1m45MvGnxf5tU42cg6+10+mdByYBlIAkw5+8L+2bR8z/G8q3aw4CjX/G/MAOgTOYsYiZ4QP2qG/GNjgpoTWsZB24RR7hhV2wt+Bb9aX6bLCAzsuL8vT1GX1uLMZvdVf8IAlQxVv7f2iIA22PMwSyfdJmQ9lfWUQewFTSD3Oa3YEudyhnTCNe/zQ7Dw8K+0qI9XYpRObSVbWtq0BoOJvSybimejNYWXX/oERFvDNLudoykbDwRefB2vnVZP//ug4v/r4Pu6DwmFodb1LLcenec1rVbBsu5qFXxU/OIfuKDtyJqSAo3vjqOGjbu27TgLixdnaokHq4XNPPwL1rZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(39860400002)(376002)(136003)(1800799003)(186006)(451199021)(2906002)(36756003)(2616005)(53546011)(83380400001)(26005)(6506007)(31696002)(66556008)(66476007)(66946007)(6636002)(4326008)(38100700002)(41300700001)(316002)(6486002)(6512007)(110136005)(31686004)(6666004)(478600001)(8676002)(8936002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TytScmVjZTUvUmE2aEYxd2VoMXJjUXFWeFc0WU81amxGVGdrWmdDV3UwNGNE?=
 =?utf-8?B?YVpsbGVCdlkxQXU5cllvc2p3RjRxYmVYTS9pYnRDa1FQZXhEdE5xWnhMeUZH?=
 =?utf-8?B?Nm50Zmt1M3F3QmZaVThCUzNpNFdvTUgrRWxHb2VhRFpIV3JFUFNRNzlFcHMr?=
 =?utf-8?B?SGxjdmQwbWNtYnk4dS93TWtnL2U2Q0YrMlg2R3Z4TG01ckE3UUY0MXl0R1Ev?=
 =?utf-8?B?OTQ4a05HV0duMGpTa2ZEK0wzNGppTTluTEFmUk5Nd3Nmb2tteDNUTEZHSjUy?=
 =?utf-8?B?U0dzaHJNdnU2dEdka0N4MU84MU9FTGhmQlhZdTNlU2VId05wWXRyVXZielZh?=
 =?utf-8?B?OEd1TUw2bitIR1MxVC9USXhzc201TWl0aHlVeml5djBRNGVFVXRTaGVwaUQ4?=
 =?utf-8?B?RHdWQy9YZG9URGNMc1BBYXc1ZFN2TnlKSEd5bnZqLy9EeG1oOVZ5U2YrSzdX?=
 =?utf-8?B?b1pVczczN0ZuUGg0bFpsZWRvbmxEaFJGa1lQTmJIOU9GZWpSdmZqeDMzTDQr?=
 =?utf-8?B?dlRwNnorL09OditCbnladVFlU1ZRVmYzc3dDVGZTL2lYRk1XOWp5NmZwRUhn?=
 =?utf-8?B?d3R0V1NPQkRoSXgwVEpTOG5rUVRXQjJ6dHpMUEhmUGJGWlJCNTAyZEloSjZZ?=
 =?utf-8?B?ajhEeTNHaWg5NG1yN0o3b1BmenVrRHFtenJ2NDZmYTNkVFltT2VQVGpVRjNV?=
 =?utf-8?B?TDM2bE5FUWlld3JDYTNycEF3ZzNzajVjOVlqS0JUVFEzQjRFSEMxSjRKZExB?=
 =?utf-8?B?dk1YNWpsZVRXT1h2VW9vMW9SUE8rVWNDTVR5VnYrSi9QK3F1VU92Nld0N2or?=
 =?utf-8?B?UGJYZ2NsczlmN2JoeVZVZkRMaHlVWW1IRkRobm9RNnJ6UDZmTnNFbE11QVJS?=
 =?utf-8?B?NTVSdW8vMnlVQmJPR1Q1TGxiUDBOUjlUU0d1VkJpQTRPZmdONUpDUlA5WVJN?=
 =?utf-8?B?VXFvZllrWDl1TFQ3TGF4bmtWM0lYNWw5SnRjaHhHTGNRT09oTkE2d1lTWGI0?=
 =?utf-8?B?QmZFVXpiMWRLb2NWdzFQeGtQczFmSFJQNEVYV2s1Vlk3a25FS3RwN1R3dEl0?=
 =?utf-8?B?VHZhdFZHU2k3ZlQzL0ExZWQzQkcraHZYTEJrN2plUEQ3Y3AzeWN1cUZlM3BP?=
 =?utf-8?B?Ym8vQlNWLzRkMVQ3YUF3Nk9LT2FnSVB4S0NXR3Jrdlc0eTJHOVl1TllZNWgv?=
 =?utf-8?B?Sk4vdWdBbTJVNURMTERBSmM5QXN6bUJCR1JSL3pHcys3KzBJczZNTk42Zjhp?=
 =?utf-8?B?THZZS202SG43OFlNd1dja3djdzFnMkpsOGpGTHR4YXpnRXFMQnZQVDRvUnpy?=
 =?utf-8?B?ckNlRUgweVBNYlk5NDd6S3orRDg3T3d3WS8xR29uWnlTOS80N2thNWdJYVhP?=
 =?utf-8?B?YVAvay9lUUlvb0dEM280cnY5dENhMFI2aFROdHdtQitHUDBCOFpGUkcwMHBp?=
 =?utf-8?B?YUFtajlEaWdYZnVRUUQvVGJXdy9Vd25Ub2ZGT05RVjllMEQ2N1pqaXppM1pK?=
 =?utf-8?B?VXpWdUdGRExVczhvdlE4dGMzOURQU2JYTXZuYXpqWmxoODN3ZEN2Y2J0cVZC?=
 =?utf-8?B?WDFQTE15cXQ5eFI0bE1LK1l3UUZtbldrYmxXa0x2N0tzU0h1RTNiQXdzK2JP?=
 =?utf-8?B?UDNybG1HUGR5NzhTbFNHREJDaWZTOU82cUtkdEYxTDhGNGtXVTgvRFJIWjJI?=
 =?utf-8?B?WGorOWZnRHBLMWFpTWVna0wybTZ1ZlhhbitnaUtEQk1Tbi96RTBMb2cvMGNL?=
 =?utf-8?B?cDRua3hhb040U0Q4aDVDNnZtWUp5Y09tZnYwT0F2YVFQWFJ6M1RySTByRmFC?=
 =?utf-8?B?T1Uvd3Z1QXplMGJRVzVjTVpqeDVzdmRpazhTWGpidlBXdEljQVJvZnN3NTk0?=
 =?utf-8?B?Q1hFbTg5bHErNEovSnVXNlFvV0ZWSEEwQXV0ZDB3eVhWWGNzcE9WbHpIUkh2?=
 =?utf-8?B?TmxKQ3hjQkdIN0lTSnN6eUpNd05LRHdiMzNJU256ZzhqL1JrdmhlaXkyLzYr?=
 =?utf-8?B?bGJqN0tFbXBvNDRHRS9EZUo4dFE0blNnT2FTVmF5eW5WdjIzZ0duOHdhZXdo?=
 =?utf-8?B?U2RWRmJVaFFEdWlUSVdEUTQwTWhqcC8zMnA4VzVwekREZU5pVUpYKytVVEZX?=
 =?utf-8?Q?uM728CYZX/VX+NL/fWk8CDyid?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d2353ca-3c75-4925-ef4c-08db95110989
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 17:34:21.1310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+dXTw1YbaB4JmsNjcH7H9KSlvxcSlVK4POugtwyzqczCLQxlR5pT9SW5GjjNJLIjA5DRPnEMfbrCs4a037igw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7718
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/4/2023 10:18 AM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Tue, Jul 25, 2023 at 02:40:24PM -0700, Brett Creeley wrote:
>> It's possible that the device firmware crashes and is able to recover
>> due to some configuration and/or other issue. If a live migration
>> is in progress while the firmware crashes, the live migration will
>> fail. However, the VF PCI device should still be functional post
>> crash recovery and subsequent migrations should go through as
>> expected.
>>
>> When the pds_core device notices that firmware crashes it sends an
>> event to all its client drivers. When the pds_vfio driver receives
>> this event while migration is in progress it will request a deferred
>> reset on the next migration state transition. This state transition
>> will report failure as well as any subsequent state transition
>> requests from the VMM/VFIO. Based on uapi/vfio.h the only way out of
>> VFIO_DEVICE_STATE_ERROR is by issuing VFIO_DEVICE_RESET. Once this
>> reset is done, the migration state will be reset to
>> VFIO_DEVICE_STATE_RUNNING and migration can be performed.
> 
> Have you actually tested this? Does the qemu side respond properly if
> this happens during a migration?
> 
> Jason

Yes, this has actually been tested. It's not necessary clean as far as 
the log messages go because the driver may still be getting requests 
(i.e. dirty log requests), but the noise should be okay because this is 
a very rare event.

QEMU does respond properly and in the manner I mentioned above.

Thanks,

Brett
