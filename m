Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338945ACD21
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 09:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236911AbiIEHtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 03:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236403AbiIEHtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 03:49:16 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6814F3C149;
        Mon,  5 Sep 2022 00:49:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AoXBYyR7AdpauxaM+gZ34RNiL4agzomWs578BXn4iH54/tEHqQ6XbtwVtrSK+XoSdTmKu7OEfrf/rV7vFfrdJPj5Opwnn+35Kq7wxSKexeITr9thD0AWVX+32k9FeihuCGleJwTksMCfglup53Hg1KoncjJzhW/xbalPkRpA23+4XYXA+hf4XpEB7chaelZUcKtaOg2Ft/Bd2ACFbS8uZiLPxBafs9eRjhXkY3tlMdRs0C8XCqPS9uii6c2uE8cd+Jck6Ke21fNqIPI52FDQWIKGktu/FcBDiQdfeaQPYfP8eBS3vIcXus5F9p850N6jZHyLzpn0yMVkFFkEHWqvwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TIWMynNjkxF7tC5EMkuHCYOa073QxjYv5Xwq2dj+Imw=;
 b=QXQRWuNkwmsGBjQHvK4VDfvWUkp2PSStF6hFXoN7Un4buqAGc6FNFk1OfOQUHREwlUHHxrBIv4maJFdRwme+CJVS2Nd+6H3aPYzKiyB/BPWAMQUW0PsJUtzBHTvHW8LfsE8pcGZLTxThpMzKwZ3gD2hY0GfKKex6o3QB7Od8GXqr6Ze0QNWloaI0fJm0NHhcv1goT2oal9aS1AJy+/niPhyXwYQjtvRXVnlBeeE8dbGqXgaNVbxy23DXtrSLVSukdBRCMp1h9m/bmXNZWuhb+KwUOmWNGswZUZIZB/vLLWIdSuOLIjXmnhUZN00Fi1y42mT5fsBj44xPNKmsRhzNHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIWMynNjkxF7tC5EMkuHCYOa073QxjYv5Xwq2dj+Imw=;
 b=MSXEPliFGgOEV/VpTrGTV50Ayo2w1BBaVnWg4+crWaq4+pW1Ms/Ew/A+OKWSDUHma1AlzAZTQhBzYwUvrvxGA1L3psfgA6j5QsZNZ7p68O6RJVJyQcg6fGJ5h9L1kC/7AGifTS5wyd2iLwtvy15OhiV7FrD3e3xSYyK/R4CB03g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by MN2PR12MB4159.namprd12.prod.outlook.com (2603:10b6:208:1da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Mon, 5 Sep
 2022 07:49:13 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::40e5:d623:4a03:af0b]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::40e5:d623:4a03:af0b%3]) with mapi id 15.20.5588.014; Mon, 5 Sep 2022
 07:49:13 +0000
Message-ID: <501af8f5-c1bd-7b16-815e-a4b13f953eeb@amd.com>
Date:   Mon, 5 Sep 2022 13:19:00 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCHv4 1/8] x86/cpu: Add CPUID feature bit for VNMI
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com,
        mail@maciej.szmigiero.name
References: <20220829100850.1474-1-santosh.shukla@amd.com>
 <20220829100850.1474-2-santosh.shukla@amd.com>
 <CALMp9eTrz2SkK=CjTSc9NdHvP4qsP+UWukFadbqv+BA+KdtMMg@mail.gmail.com>
 <a599f0da-3d9b-a37f-af7c-aa1310ed77e1@amd.com>
 <CALMp9eT3zHqZhDLKV=5UTnwLsvmbkpqibsh4tjqFnW4+MGR4aw@mail.gmail.com>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <CALMp9eT3zHqZhDLKV=5UTnwLsvmbkpqibsh4tjqFnW4+MGR4aw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0078.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::23) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c89f8066-27bc-4231-eb6a-08da8f131fec
X-MS-TrafficTypeDiagnostic: MN2PR12MB4159:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i5VGCKgcHRHd3avgjnVoussTPHNXn9BSdVcJq8dEZrzAxR7jZ0Zck04RiiTjdJAhdmUoeM8qI5QGIcxASw9yBIEPvKDpSxhcjDpVa8rzAmnm6POuFmWkflZJ4zR88Bgw/4ovWtvqIjt1xljN98IoWCl6BH9TGKxp0devPVT7Dg0S7I/xsmGumy6fGlfwxa7vOhwWNnYAxUPlhEbRMt3ZjHQALSKr9tyPaGFgQAYakT3QOIdAu01Uqmg3FF4ToYd5uFG4zJIwCsYAyEBr4R8BOEoGw1c2jE1a/BgzV0BbMQVshAk3ijbVsOWgBd1SGBZnSSR5DX8KyCTHLmRSUIYWAWybAICOIMQaEDQtUNIZQsWf1gVxiLkIo68+rn1veyNHQWL/JM0QGapyLjmJ5w0RNhsK68obOjxWOTCGZHT6gkd0FU2K1M2AMuhGBeku6+Bpu0DLUdUqNbOo7PqBEiPNt6eT3UTPaUeiEjCnwpqEK1SjGOsMCZa9REaDVeBY8j5dUcabTXSOa+mpeU4Xzozp5Bklskc+fCUlQM33/qJjzLbbAKUPq6FYGLHi17gs6gn4yAkukkD2guThn6YHL814h1bF2RObcnO5p483wEdCKpzctc0eEA/uc2Z0OjxPVDsCFpB5txQIEgdFaE9Y6LFs12eau/TFgMQhDWWdyQgOb/7c4dv116lg0zY5D/CPhtIqdR3LblpgPlWad5MJHoJjo1JyDPvBBboGa6bGd+OeNM5/mFdldhSlbkb5D+aXS9AeR4/HD+34lIL/RvnzfatxiCQgeaiI12fF/ZftHJ9mDKQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(66476007)(83380400001)(4326008)(8676002)(66946007)(8936002)(5660300002)(6506007)(478600001)(53546011)(26005)(66556008)(6486002)(41300700001)(6512007)(186003)(6666004)(2616005)(36756003)(316002)(54906003)(31696002)(110136005)(86362001)(31686004)(38100700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rk5JQlYxZFd5VTFRemlySHI0cktBVEhwMngzN0lGTlN6cG0ycWp0WjRDSXlI?=
 =?utf-8?B?Nmx1YWNCeHAvN1ByNC9Uajl1WW8yaENUa3BBMk5hby9PZDZCZFFWWm93OWkw?=
 =?utf-8?B?SWpmSUY3K3R5cXdGZjIwSzhqL29hVDNEeWphTGpoRjcwOFhHRmRHbStSbWdy?=
 =?utf-8?B?T2lqalNXZGc2M1pGM0tyT3JqNm5rYklhS3RMcmxFbzRqcHB6V3NVTThOL2Zm?=
 =?utf-8?B?TE5qMkgzOFdyWEhWRlk3YmxjVmpBNnp4ZWtrK3NWclBoeFBYemVIaURBS1RO?=
 =?utf-8?B?UWdibmZrT1FpVGNsQ29xOS92eDU2Z0ZBTnByZ3hCUTUxUkQrMVByL0hOcDVt?=
 =?utf-8?B?UU9ZcEZnVktCUjNITWNsVFJaazZJa2VFR2V1Yi9zUzlkcFB1T1pxUzZ4YXps?=
 =?utf-8?B?MmtSVDVldkVrZTAxRTI3aEFqQkFFYjZGZ2lZVWNpWkVvSlFPbGthSm8zYXpP?=
 =?utf-8?B?NGRuOWxJVmhXdkpHSlV4eXVZMC9jZEJ6cTZEYXRHc3Q3bHlDTk5xR2pYcExV?=
 =?utf-8?B?dGNTbmtiMXF4VHVpUzdJS1h1anhuQ09QbnI2NTNHU1VNa3psRUVJeGJPOVB1?=
 =?utf-8?B?QWRiTjBOeFBneEtrMGJENTczME1vbFFmc1p6MGt6cnZ5ZElwcjJBcXUzenF6?=
 =?utf-8?B?Q3ZITGZqRFJhcjMxZnB0VE0zb2tPMjB3a3RkK2RVakV0TVozNGhKRVRrUXFy?=
 =?utf-8?B?MFhtQ3ZVVVBPNkF2LzNEQi8yUDBXSklSa016S1dtRVFqREowOGxITmprYlQy?=
 =?utf-8?B?M2g2a0lDd2t0VkpRMEswcnVQeDJkNTcxdEIrMmd1Wkd4LzV6MUV2QlcxdWpr?=
 =?utf-8?B?a2ZKMEcvcEtxOVNRSSs4TVVLeUdqbE1YWXhQNUR0OEpLdjhObHVHOVNmQ1B5?=
 =?utf-8?B?ellyYjZIdEZUTmordkNtN01EcnI2Uzc4OFBSMCs0dDZiUW5yOFoyd01sb2dz?=
 =?utf-8?B?Ui9IMUJyOEZjdk5EN1EySktWQktpMXVPSXVsQStWU2JkdlVsQkp6UDNqdGUv?=
 =?utf-8?B?TjJFMHIxN1hjUERWR0UzNXJpc1d0TlNhSnBEZjBGREJKaVI4Ulc5ekdqUmlX?=
 =?utf-8?B?ZGdKa21RYk91b1o5VzBYM3VneC9YWk5PT3JvRmdDa01tWXN5M0dnRjQwNThl?=
 =?utf-8?B?djlvY3JyQW5lQkdSMFRmQ0paSlQySjQ0MURRUzFQZFc0dERvWmUyNlgvSUZ1?=
 =?utf-8?B?QkJpQ3JoalhNckRGWlZMV2Rtc0pNUjByaE1iTCtseDFxUWRWYzZucXlva0t3?=
 =?utf-8?B?VGRCQ1Izbk9aQVQxd3Y1SnRSZUNtLzRQaGFVemk5anI0NVhaNWRZR2I5MVlZ?=
 =?utf-8?B?M1BJSSt2RDlUa1hhMXJjVGEvVmxvRWlqeXkvMDAyT1l0aERSN2V0RzNmM0FJ?=
 =?utf-8?B?Q2RjWVBnM05PRHVWd3BxbzZodEEySmpERXlLc3BtRHNVV01LeDJNeDk2OGF5?=
 =?utf-8?B?eFFSWFZYMDRlY05xclJpb3RBYkZwaHlYa0w4RUJxY0Z6MUl2cHBBakhFTXFO?=
 =?utf-8?B?by9YVzYwc1lpOVJKTy9HMTBVYjZBSDF3aU4xRWZTWjlvc0ZZNyt5eHNaMzA1?=
 =?utf-8?B?N3JYTUVVN2U1cFRGUEZRaW1QV3dVQnNYajlxSmk4ckJzVG5vTUlNbzVyK1Vr?=
 =?utf-8?B?UW1GYkNzR0lTSnlxMWVSTStxenVEOEVYY1c0WklpRkhUNDNrRHhtWUxLZ2Vo?=
 =?utf-8?B?bUd4dGIzcXF3ais5T3FyWjdyY2pJdHRZZmdaT29hWG5ybEFJdXhxNjFKTGVR?=
 =?utf-8?B?akdkcTBsbUxiUmp2ait6OHg0S01BWWtlaGQxb3lTaGZGUy9mZUF2WkhFQS9t?=
 =?utf-8?B?YnZEYnlWMlBWcjNyK0hhNlcvU2pHdWR6N1F4NzNvS2V4NVBsRW1XQTh2UGYv?=
 =?utf-8?B?aE5zM0hTRTFTN3JNSzlnQ1lXb25ndGw4S1ZaQ0x1bUM2aFFDUXk5QWRPMnBs?=
 =?utf-8?B?QmU1b0d4bFdTckk3Q2hMakdFTjk3NGFyQTR4UnlnOWVIS2Vkb1ZCdDZ3azFU?=
 =?utf-8?B?RkQ0aGEveklNVnBqQ0FIYmhqZkxLcnV4NlpzSXN6ZjZ4UWt5ZWR0TW4rQmkz?=
 =?utf-8?B?c2VjR0Z0YVJXL1ZyNHdIWDNxNTlDZGtaaDBFVWhpQ3dKNjJYS2VtemNXcFlV?=
 =?utf-8?Q?CGONh7XXyutA6qle9/WRT9S8t?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c89f8066-27bc-4231-eb6a-08da8f131fec
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 07:49:13.2554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DH39qIfOFeE9DXpdy1Gx5bUs3bsKLMH1fQ40A+6Cim4N03WDERHmcUFjElH/QYlemTPIi3oHU23QeDJstZfRXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4159
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/1/2022 11:13 PM, Jim Mattson wrote:
> On Thu, Sep 1, 2022 at 5:45 AM Shukla, Santosh <santosh.shukla@amd.com> wrote:
>>
>> Hi Jim,
>>
>> On 9/1/2022 5:12 AM, Jim Mattson wrote:
>>> On Mon, Aug 29, 2022 at 3:09 AM Santosh Shukla <santosh.shukla@amd.com> wrote:
>>>>
>>>> VNMI feature allows the hypervisor to inject NMI into the guest w/o
>>>> using Event injection mechanism, The benefit of using VNMI over the
>>>> event Injection that does not require tracking the Guest's NMI state and
>>>> intercepting the IRET for the NMI completion. VNMI achieves that by
>>>> exposing 3 capability bits in VMCB intr_cntrl which helps with
>>>> virtualizing NMI injection and NMI_Masking.
>>>>
>>>> The presence of this feature is indicated via the CPUID function
>>>> 0x8000000A_EDX[25].
>>>>
>>>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>>> ---
>>>>  arch/x86/include/asm/cpufeatures.h | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>>>> index ef4775c6db01..33e3603be09e 100644
>>>> --- a/arch/x86/include/asm/cpufeatures.h
>>>> +++ b/arch/x86/include/asm/cpufeatures.h
>>>> @@ -356,6 +356,7 @@
>>>>  #define X86_FEATURE_VGIF               (15*32+16) /* Virtual GIF */
>>>>  #define X86_FEATURE_X2AVIC             (15*32+18) /* Virtual x2apic */
>>>>  #define X86_FEATURE_V_SPEC_CTRL                (15*32+20) /* Virtual SPEC_CTRL */
>>>> +#define X86_FEATURE_V_NMI              (15*32+25) /* Virtual NMI */
>>>>  #define X86_FEATURE_SVME_ADDR_CHK      (15*32+28) /* "" SVME addr check */
>>>
>>> Why is it "V_NMI," but "VGIF"?
>>>
>> I guess you are asking why I chose V_NMI and not VNMI, right?
>> if so then there are two reasons for going with V_NMI - IP bits are named in order
>> V_NMI, V_NMI_MASK, and V_NMI_ENABLE style and also Intel already using VNMI (X86_FEATURE_VNMI)
> 
> I would argue that inconsistency and arbitrary underscores
> unnecessarily increase the cognitive load. It is not immediately
> obvious to me that an extra underscore implies AMD. What's wrong with
> X86_FEATURE_AMD_VNMI? We already have over half a dozen AMD feature

AMD prefix (X86_FEATURE_AMD_VNMI) is fine with me.

> bits that are distinguished from the Intel version by an AMD prefix.

Hi Paolo,

  Is there any other suggestions/comment on v4? Should I send v5 with Prefix change or
you're ok to consider v4 with AMD prefix change?

Thanks,
Santosh
