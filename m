Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C415F97EA
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 07:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiJJFrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 01:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJJFrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 01:47:13 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3884DB4E;
        Sun,  9 Oct 2022 22:47:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dv1UmmQj77d2ycE5/LhEbqmXe6apLC46yCqtov2VWy2riDBPo6e6Bjjff/JwIH43RkHxw35PoAy9a43Z0KtFCFMkeX+/Yzk1LmE5Dmf6oKGJjAZrz7GKx3LQuKv/sB3LC30k/gQoGwRajRSvhKOclB181VlNjYpIs4YNnVfKtyKO88hp8lKfVrFu3n20+eVAKXMsTP7KNjXC4uflVv6M83XELzD38JylEE+xMN/ZT958BWTijyFyzk8QZnidVq6ZNCE3TKny8mnJMK1nX29NGMlNClI4NOvq+pVIRHZZAfwNED4T4/S6g/uBhpiIo1++tPORaxFtLxN3p0/bNN3UXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TwKYKF1f5bssX7BDJfbSndm+322XQgs5+E0C70TKX+c=;
 b=LvYlaOlHecSXpFgNdlsN37c1NNkET7HJp5l43BFgOOCD5oJTonIUyHwAiZWHhIt2TPDPpLzJUAmWo6vlBKIryspXuOWb1D5QKkdTjTP/optCz0XGJtM1+0PS/mazSCXeyWXYKFeJSGTIDuDy13Kh2ySg78DMfaS7hhk766mctWa4szdoN5r8n/lWkQJxJRwZ2xxjpCwkGPmkw5mS0hfec/muXpnxj6jLRubWUCtofv4el2hFK7raDMsfup83Tt80Asm/vw/lDr7NYOhjlmWudKSrGW6/hs55BX3yoFzi0XDfMQNtSq/bqD4pJbnFph/HifuGxDpO9lI6wx3OdRH08Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwKYKF1f5bssX7BDJfbSndm+322XQgs5+E0C70TKX+c=;
 b=a9zBcvTLlZhJnG61FVxB5RZLQ920M5+5VctZCTszGgabsw43JzeBFK+xebb1LdBMwJyXzodISwtspLvcl30XPttYUJvxt0KInpssDdC3xFq7VLyx9/o7iT2tHuVFXItnCGMj2NAsIzTdFN5jGXxV1iorIx9r9dLAR4GrPoHCJbY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by MN2PR12MB4109.namprd12.prod.outlook.com (2603:10b6:208:1d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 10 Oct
 2022 05:47:09 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::3bd9:dc6b:7c66:d776]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::3bd9:dc6b:7c66:d776%7]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 05:47:09 +0000
Message-ID: <b8a6ac33-eb39-5bf3-db55-a2189d67d202@amd.com>
Date:   Mon, 10 Oct 2022 11:16:56 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCHv4 0/8] Virtual NMI feature
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com,
        mail@maciej.szmigiero.name
References: <20220829100850.1474-1-santosh.shukla@amd.com>
 <Yz8hIY9XdlycXE+N@google.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <Yz8hIY9XdlycXE+N@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0047.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::22) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|MN2PR12MB4109:EE_
X-MS-Office365-Filtering-Correlation-Id: a7975eb4-00e8-4c1f-6eee-08daaa82df2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MGHR3MD6c3kZwnqxiYsp2brl/FmVJMqHWXZIl+QIoFc3h6z8YR4pluSBKNS6gxGporXbhUKiVi9/f/BbqPygGq0becyeQKS9LPbDS4jCt/+Civt4RiEP3A0ZjwgAiLZ6YPvR6DxRwBp3kY8danfZAFK5QrQ2JfXplRys4rOvwqWWCWOsmyhg7M2WxBcmJC7X3DBPhvaVfkBmijHHdKFHZVkVkZhgR3lpomYdYRhu0CbTG1jBh9qSpE97vLSdk/RTYn8dEebHM9d2Vr0gm42XNduvR7EMsW/1ISsB/M9wtDLrwCrLv7MnmJOL5o6AyR30JazBl6uAezWZPUv7iH11m2t/dWR4kIYLW4Gd0y9nGWkV6mJC6IceFcEzO0eTvIyJxgrUew3KBLeEu/JKWiA84BGuhT4NZJYpzJD+yz6XTeTOfF/5QxftFFZCwGhvWMwmt6TchzQUH50t4UGILU9zJ+Loim5VhV2hL+Xv2lMnw/gXa4GC72i39YrMxHajJvXulgaHTY+0GFlFYAxkTPwihAvnnx27otcw/5+kwB+tBQbpFp2uZ2nNvvk+tYCtvk8BtHZDPqw+xFU4fEnAz5hl3AgiS9u1OSoC4r8kwNVf8V5AlGE2NwI21hFcb/7AwrNprN92URaHelsvmOY4epk4yVVzkugfoTsAjM3bvTsxTG8d6FLcBGOkyTAwCeLJBoPMotwC+h03lCKw3G4GdO5CEPKHZs5J71Tcd3cNv7cuRZ0dEiaYoU9Yk1Bh/0lGFp/RMD3Bh8WgiB8fMv4n8o6h3OSSNpJw5QJKRIQrM3o55+GTDUWuXOiX+2+njaNxjUj9q7q7dVPkS2ePr5QYvcn11w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199015)(31686004)(2906002)(66556008)(44832011)(66946007)(8676002)(8936002)(66476007)(5660300002)(41300700001)(4326008)(54906003)(316002)(6916009)(6666004)(38100700002)(31696002)(36756003)(2616005)(478600001)(6512007)(966005)(6486002)(86362001)(26005)(53546011)(6506007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amtZdlRzdDlWV1E1Y1U1cHNZTnRpZFUvc3U5N0p6aHY5L1ZxNGdueUY1cDZt?=
 =?utf-8?B?WVBSK3pQbUZEQm95d2grazUxK0FOUzYxTmpheVFXZGNKZ05UUkRnWXoybk9m?=
 =?utf-8?B?TmhNYUtDaVowb3lML2doelBNdG5nYmJCMGRhK3RjS3Z0cjYxU0dWZzQ2eExS?=
 =?utf-8?B?NC9HckFtTTVRdjdsV3g2LzBudlYvVWpBZXRvNVp5aUZrTFgrWUpRdFZjMkw5?=
 =?utf-8?B?MldvQzlRRG5FYnp2MUFYWU9zVnY1U0JuS1VsdTBlcGFKK2o5a2dQNGlPUUp1?=
 =?utf-8?B?UjJSb2JnNk9VVXdaelN0dU54dU1qSjQwVEM2ejJWS3I0ajZaWVFxNktmZzdD?=
 =?utf-8?B?TkpRU3grcTNwKzBnVmttRXRJTm1mS2h5QWM0bFE0K1E1MHZRaTl5OUlMVEZ2?=
 =?utf-8?B?dUxnTjZNNkJOQnBJRVdheEU4SE9PN2lhK1RWNzRHUmVySDhyaVMwWXU2ODg4?=
 =?utf-8?B?VURkeEpuZktrand1aER5NnlaMjl6NEpTVXdzZjNGS0pMQSs3Y1ZXRGluaGRR?=
 =?utf-8?B?Y3VXeFBreEVkZnpOTmw0THJQaGYydEp3NXZOREk4aDBXbzNKY0p4d3BIVFBv?=
 =?utf-8?B?UXVNQjlSaTJQMHB2QUJSSXRVZzQ0R1pYVEUxQ2dkUHFrRjdnbXlzRWEwMjVK?=
 =?utf-8?B?S1phd3FXL3IvTzlGTDdNcFdtcnZFWCsyQkpxR25LNVRJVXJ3MktYTmtSNUpM?=
 =?utf-8?B?WTZ5QzZ6UCtTanR5U0tpdkVISGx1eTFIU1J4cDRPcDVQMFdnMEZUQzEzeFZz?=
 =?utf-8?B?Z3ozTkNrdy9jUTBoaDVFcSszWkxiaTlpMStZYk5Penh3dURkS2JiSHlHamQz?=
 =?utf-8?B?NGNPMUdNZ0xxbklaUnhWWjRmM1ZUTC9kM2p3WHl2TEU4TU5JbzIzR3VtQlhx?=
 =?utf-8?B?d1dxRkN6OUc2cEJXOXlzVEc4TEREUGVuc1J3dWNxa0YzK0cyK2lIK1dHOXhw?=
 =?utf-8?B?UzN4WHBRUnZ0OUkzYVRsSlhkMW42NEdVMHVvSCt6dDdMSHhHeHkyb1VXY2x2?=
 =?utf-8?B?V1hHNVdJazVBWWk1bmd5aFlqZVloSjRwVWdKcE1wTDZZcC8wVHJqWnRpd1B4?=
 =?utf-8?B?NFZZaDdpVXJBdG1PSEFaYXpobFNHKzk1Y3FZWlhmK2JXTUQwdTIxZHdoVGpo?=
 =?utf-8?B?Wkh6Ukw2NVJXdngvMkt3UVdGWDFtb0xWaTBmUU0vNXBvakFKVGNZQnYvTzk2?=
 =?utf-8?B?eU9lbFRKZ2RRSGFvVHVNSmwzTlhKZWlrYTZQQm5iOW1yN0VnaURXNEM1bXJ1?=
 =?utf-8?B?L0R3OHNucGFoaVRtWXJBd2Z6d25LVkJsRDJKV0ZMT0hEYkp5N0RWTDJQaUcv?=
 =?utf-8?B?cDRTTDRpTTdKcXFJWlVxN2NmdTUvd25PcFFsT3BIYzJ5Q2xyQzJGVzg4NjR3?=
 =?utf-8?B?RDJNVHlOS0tjc2wxcUF0cHFHRnRpU1NSd0QrWHljQmsyV2lqaHEwRUZ1cGRP?=
 =?utf-8?B?ZkdVOFR2YWt4MERMcCt2QzNldEROeXJHUVNjcTc5TVplQjZ3U1EvMDN6SzFm?=
 =?utf-8?B?Y3RFNk94aHhIVnIzSXZJd0xGWWtnbm0yZ1lJUC9VUEJiWmJlUjYxWk54NUhr?=
 =?utf-8?B?S3l3ZE1jejF3RHZ6TENOcUhlMUU3WDBKc0VhSGwyaDE4cE1GR1I2OTRvR2Nt?=
 =?utf-8?B?OXZ6R2s0MlJBS0NKR2pIODN2R1A2OHBXQnZRaEFNL09BM0dyeUphTkFwclc0?=
 =?utf-8?B?YW1acjVwdENyQzBGRzArWnQzWkZFYWJJQWs5Uktkbm90cE42b2lYRVNUem9B?=
 =?utf-8?B?TGVBN3JYWEZlVGJBR2g4ZU1VMkVQYW96TS9DdmM4c01ucUp5NU4vUFlMZlRW?=
 =?utf-8?B?Z0g1b2VndWp1OTJHbXdtMDZuQ1JsNnlpWE80QXYrQmkveUlNcEdSLzNFbmVa?=
 =?utf-8?B?UytLNTgwUG5nWWNuWHFBNS9GSklHR2k2UzVTNkdMYjk4bm5tWTJZaHNiSnhs?=
 =?utf-8?B?aFRWaWR5dnQ2d0JxTnQ5b2U0Zy9aMkhJRjF6TEhLNU4yQlBETFU0ci90TDBL?=
 =?utf-8?B?cWFVa2xUVVAvQ0c3dWsxVEVKMHdiSURGWllWdHZHeUh5c2dtemVrZ2ZKYXRj?=
 =?utf-8?B?Nk9WZXFtQmpuN2ZySnVWeUxldGp6d0dhbUNWNU00cnd0QVd6T0loYkFxQ2Jz?=
 =?utf-8?Q?n9A2cHJJLJI+BU2VgQ4bgm4KS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7975eb4-00e8-4c1f-6eee-08daaa82df2c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 05:47:09.6641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AdHAylQkWZnLHFfyVyrToRwXPu4UhwfpmajYxlxC33jPeHxFk2GIZixvgRIYRHxNPe+S73rF39n2wrKmvFjCZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4109
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/7/2022 12:10 AM, Sean Christopherson wrote:
> On Mon, Aug 29, 2022, Santosh Shukla wrote:
>> If NMI virtualization enabled and NMI_INTERCEPT bit is unset
>> then HW will exit with #INVALID exit reason.
>>
>> To enable the VNMI capability, Hypervisor need to program
>> V_NMI_ENABLE bit 1.
>>
>> The presence of this feature is indicated via the CPUID function
>> 0x8000000A_EDX[25].
> 
> Until there is publicly available documentation, I am not going to review this
> any further.  This goes for all new features, e.g. PerfMonv2[*].  I understand
> the need and desire to get code merged far in advance of hardware being available,
> but y'all clearly have specs, i.e. this is a very solvable problem.  Throw all the
> disclaimers you want on the specs to make it abundantly clear that they are for
> preview purposes or whatever, but reviewing KVM code without a spec just doesn't
> work for me.
> 

Sure Sean.

I am told that the APM should be out in the next couple of weeks.

Thanks,
Santosh

> [*] https://lore.kernel.org/all/20220919093453.71737-1-likexu@tencent.com>
