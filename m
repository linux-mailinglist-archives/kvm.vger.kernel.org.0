Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99777542AA5
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 11:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbiFHJFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 05:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbiFHJEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 05:04:10 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE846108F9C;
        Wed,  8 Jun 2022 01:23:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MuVAoDRZwrZE9T3vJye/lqvkZVFZcLg7mKVDFQyi9B79KpdcdyrKLAwa1/2TY020PpRxiPb3j4fWV5+YKPn63OVwoF8iPY4ZeFXS57M6TH1GrLciSPtJwaqz66/T1b0oijQZAPG4pzLW0j3KOfKFnQbzANOCNMPu3MIEN4uzK44HZjy4aoQyrD11B1ZwzYBT4rHvBU/iLGpmC25U/95KlAZKnIGte5yHLHgG0VfyjegYoQfXQqVFHwFNQOZofa5V59DSfRr62HFccFZlWFmgofU99L3uDsfWRSIr9honQPSmBlIipTlk9Y44OARonqtzukuI9fPpryUee1BcwYWcTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3jQBfVLHYicwMo0PDTbx+9R0p7YCmeSpZovy6gFDtk=;
 b=S9/0seWevzuiSt5V5j+sghoF8Um+O9sAzyPrhu9qyoCyH8rL5VJSDeEBgFijwJS111L9+cqa5L0HKfT8+KVeOm6gnjSmccTv5b/dWNXB5Y3H/ri2QX3qVpTvcneUncL0IF09/teNDJRvc1tuBArtMSCBTyTnYcJEyJqk5MShDNk2l2XiwLNtTc0CdQh+ZAicFCeYZXgP0B+Nb+e7jzARua1AKimLWIJimz0ke0Y14C9//xnjdxzM2N7iDp/L4uVHPlwsyYwOI8YnkOViMZpxM+qT+xOyUdFGeWTKpkuYPARzY3g4JuwaSxRReQxtBYmVmP9NYPl7vwoJaG2shTMTig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3jQBfVLHYicwMo0PDTbx+9R0p7YCmeSpZovy6gFDtk=;
 b=nNWAKC3Az4E/87Z8W4KyGEPqhFzZ842exqzURwGAsTu3Vn4eNbteTNeKerW5PxZ8t7PVm8RzFsG70X+AL/naFOZOwwdTn+5fgCD6TwG5qrwJyWnJrY7Vk2qhCxXWbMoMxM6YlIfRuP1UcJ9j4FWnHSnCJG/vAGeCF15PcFjK3VA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB6305.namprd12.prod.outlook.com (2603:10b6:208:3e7::16)
 by BYAPR12MB2984.namprd12.prod.outlook.com (2603:10b6:a03:da::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.16; Wed, 8 Jun
 2022 08:23:48 +0000
Received: from IA1PR12MB6305.namprd12.prod.outlook.com
 ([fe80::c14e:a04b:64a8:77ec]) by IA1PR12MB6305.namprd12.prod.outlook.com
 ([fe80::c14e:a04b:64a8:77ec%7]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 08:23:48 +0000
Message-ID: <fd73f376-345d-6f58-987d-cca203e06cad@amd.com>
Date:   Wed, 8 Jun 2022 13:53:37 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 0/7] Virtual NMI feature
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220602142620.3196-1-santosh.shukla@amd.com>
 <CALMp9eTh9aZ_Ps0HehAuNfZqYmCS72RKyfAP3Pe_u08N9F8ZLw@mail.gmail.com>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <CALMp9eTh9aZ_Ps0HehAuNfZqYmCS72RKyfAP3Pe_u08N9F8ZLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0176.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::18) To IA1PR12MB6305.namprd12.prod.outlook.com
 (2603:10b6:208:3e7::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3907fe5-8673-466b-3e76-08da492835e4
X-MS-TrafficTypeDiagnostic: BYAPR12MB2984:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2984857B18C5430968774C4D87A49@BYAPR12MB2984.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s2qpCZl3arffKlIeL3kguy0ctUAeeYDEDK+qWIOge6Vat4+3OkCzR3zLVDOQK1IAYj75g/SQ7fyawoo+6QMpEPoC/d5yByMNtOX0dGQTwndSmDMJA3/dl17flKQmeavvZNvm05jB0kl0qnpmNPJyC5d85aSfe7s797lbSxVeD9WQHyKYDH91888Wh6KVZ4IQgJPYotz3gkp+dVCcQTO0tNzr3A3ABKqqHptGpvF4sC6WxlkdxH1rw/nft4Yb8wTC4/vfLpgChHBTKN9qMeCiEnvFrAIvLUXjbsai6c/KYOS01Hp+vnzoBwlnfev6RpPOdLbmtWA8R2bV5e5iiPDw9b5Rn26hdgbPwUvqco26nSTN02CpZWgpzvjHaLPxRL6uamIRNUxedHdKKJ4H8aQNBEBxTKOcCff6D+O3Ks6Gg5Yxkyhvs1rrVIivLyqjf4mL5Yg8DoM9iU4BhBxAx0uvrrMd0XEihRKP1M/3ADEBwHmgQtcB3B/HjDopSbWRkwK0cm7lRruj3jLaf2Hga/DexRXHAelQRK2PoLPahQXnVw1tA8Try7jcIW5ujwy8ATJNqx2c44BRYwxSoNRKgYwHYJEqi9jappTYIMm4RKbDX+ZdLXc2RiqEi/EXqoF9Mpac/pTZYaLacTGB87NTLTJE7mB47un/uAulInHgBwgtHpP8sE443UL1XHKxgjlBujxQpewjrQYoVanl62JAJ13z3Ac7dvSCoK91nLAtwtRY7QhpMHoxYTkCherUwqARV39m33ikaX+1i8YbYQhFs+YY2u6KapVZfNzeq6zQhihiuSHHywaEgxq0WI8OuGI4Txy38K53LghyKt9EYqG8IMK7AQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6305.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(186003)(2616005)(86362001)(8936002)(54906003)(26005)(6512007)(6506007)(508600001)(36756003)(31686004)(53546011)(83380400001)(6486002)(6666004)(966005)(5660300002)(38100700002)(31696002)(316002)(66556008)(4326008)(66476007)(8676002)(2906002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmRuSFU1NHlxSlVQNVU1dS9BVVlmMVoveHk0R2tXQ1JZN0x6ZEZXeUZ5d2p3?=
 =?utf-8?B?V01GZU5YTnRuNCt4VjA4Qy81eVZYbVlQVWpFYjArNllqVUdwcCtUakFSNFlR?=
 =?utf-8?B?ZllpcHpjY0dXQi9nV1RsRWJRQ2RXeTVySGVGS0xQQTV4YjZkU0IzbnFJeS9R?=
 =?utf-8?B?Uzk4eUxjcnRaclZwYkxQWGNBY0NMaHJPcmNzdUNNVk1BbTJORDVTbWNkVUsr?=
 =?utf-8?B?YW1WR2JHRGVpcDRidVR6SEJXeVFYKzA0WUZkcDN2NXlhTnRPYXZzYy9OLzJT?=
 =?utf-8?B?NjNJWFhIc3dGeEhUWlM1ZEViSlZjNVc1bFMxdGpFZkFFYm1jNU1Eam4yMitn?=
 =?utf-8?B?OTMyOTFxMHJlNnNnSHJ6dzVLUVo3OTZRVlQ4QThtamwrTmdFVkVXY3hrRE16?=
 =?utf-8?B?Mm5KOS9NcmV0UlNQWU03VUplRjBoNzJHWVRPekw4SVo1VmYxckphcGN3REJy?=
 =?utf-8?B?WlFOR3BndithTVJEQmlyTFBhR2l2U3BUV3BKamZYaGJHREJLMHhGVGM4WkNX?=
 =?utf-8?B?OUJXVzNxdWcxcG80ZDZSS3krY2x3ZVdkWlByTU9zZUFaNHMrWXFEdzZEeXhO?=
 =?utf-8?B?VTlTeVNsSlhlSXJzSlBiQ3pQeTZpaXoxS20zbEJuczVXMFF1YVg2VWFJbUJL?=
 =?utf-8?B?S1BLZFUrU3llZGtFQVZMWWNJQzJqSjUyNkhCbVR2cWRFeU1aNFpwWGNUY1Vs?=
 =?utf-8?B?V3hacXR6ak5oeVdaVGlnYlV2KzdQSElIRHh5TGZEdHJZWlh5b09iTFA5a3p0?=
 =?utf-8?B?bWZxRkZYdzlrQmRxbmg1V08zd3czbkdZY25ONHYwNGtFb3FtdVNwbUlnOTRW?=
 =?utf-8?B?YkZacFF2c3Vndms5OFpoREpWNGFUNzB2RUlrdGZyNHdCbGREWVRacVdnY2RL?=
 =?utf-8?B?bU81VkVPc0FsWGoxM3lQQW5Qa2lJVHU3T0Y2ZFlNekMzSE1mOStqRjVCOWk4?=
 =?utf-8?B?cFg0Q0hBZmlkY0xhcWJHaGV4eVdVYTFITlA0SGVTZEl3N2V5WitPMnFPNHhI?=
 =?utf-8?B?aHhIZVVlSDlMRmlZdjAyM1Erb1BJMEZlT3ZMcXNLRG1wTVBuZFE3Y3B5Z1gv?=
 =?utf-8?B?MS8vZHhYSUVsN2NXMGc1MFpmTmdSa3h6czVoNjJDbkFXSHl4STNSNkNMdi81?=
 =?utf-8?B?Q2p2eU96L0gvandsM25zdUsrZjk1QnFjVk4vYzIvTk5YSEJzamhudVZTa2FH?=
 =?utf-8?B?SU5qalVidDZ2aFByTDNJQ3dUNE15eGd1M3hHY2dydnJEaWtWalRlSVFVUXUz?=
 =?utf-8?B?OXhRc0RrZmhNbThjWEJlbzJRb281eEFrNXduc3dBaFM0aElPTjZLYWI2Y0VY?=
 =?utf-8?B?bVVtbk1VVWxpTVVCb3RyYXlHT0lDZkVzdFk5Y3ltSUIzd2lpQ0hJdWZBOHkv?=
 =?utf-8?B?cnRhK2Rham9jVlFITlJ3aklRVkhCcUhNR3JmYWdNc1A2RDc2L0xJb2MyejNX?=
 =?utf-8?B?WXN4SmIxcWlrNEpCRUI1anNHZ3dTc2hMOUFKZXFDMjk1dWdIWW1lSE1wbkFV?=
 =?utf-8?B?NTRyOTBpQ3VVM1VtRHpvUVFoWHQvbW9kL0lVNXRiR1BDS2xmMERuQXo2azY0?=
 =?utf-8?B?a3k2U0RQazQ3cXJaMXoybHQ3MmdJcmVkanBhNHdGRkQ3bWJLSXdXZ3QwWFB6?=
 =?utf-8?B?N1AyL1pWbzk3Y05oOC9EanRMWENYb0NFU3ZTZzZ3RTVLRVFxUkdNTGN5WHR4?=
 =?utf-8?B?RWNYb1NweGRoVEJLYjJTV2FzQStESXVPaDgyV0NCZ0FxK01OQys5V2ppaU9m?=
 =?utf-8?B?c2xOd2VSbGdJc0JJZXpDRlZEWkp0dDY3UFBpdTNCZDNlODRyTSswSnFXRXJN?=
 =?utf-8?B?ekpmV3hHUTBTS3lHaW1wR3hXaXFZVURVY3JqWXdkUXlvU1ZGdk5GYWVrd3hO?=
 =?utf-8?B?TWJxdllCeDhrMldHQjlpZ1grb2lVcUhGZGlzbHFCQjBkamcwK2g2Zy9aNzBN?=
 =?utf-8?B?ZmU2YjBteDBEKzg0dE15SVo1NWpGK0RRSTIyS2drNHRZOG16bzlaVFgyYjgr?=
 =?utf-8?B?TmNQcXdmOXJqY2FpL2VycUlra2xGSytPQzA3VnpqWWdYcWhLNFIyOEZsUUFo?=
 =?utf-8?B?ekN5VmZ0S2VKN01xTW9lWHJSWVNzenhOc1lsU3VrUnhWQktCSWRZeXFvOUxk?=
 =?utf-8?B?YXJIcGhWU3hjWDlZZTZlaldDVy9pbmlWYWNjSnY2YnlEeE9QTW5pcUFCTng2?=
 =?utf-8?B?SzdmNENtTlp6Q05oYVZiaHNrdVZYb3loKytxdWRDZ2VnV1NXMVdxd1BwQzRJ?=
 =?utf-8?B?aUFJcGF3bkZkQmtlYlZ6RzlHdG5Bd0svbnhYZ05veUNCbzVUTDNMRFZDRmJa?=
 =?utf-8?B?T3Iya2NCdVp4ZDA0NzVOQm83eERTMTdtSm1KZ3FMcElFZFVseDhpdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3907fe5-8673-466b-3e76-08da492835e4
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6305.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 08:23:48.1378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFZU8KNgS+EUTYBip3lWePlmeLnBeJHVKO2zl8QUwT5Ed8t61d0IwFiQTBRpGTcVCkMjV3fsix4dqUA2JCJggQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2984
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/7/2022 4:31 AM, Jim Mattson wrote:
> On Thu, Jun 2, 2022 at 7:26 AM Santosh Shukla <santosh.shukla@amd.com> wrote:
>>
>> Currently, NMI is delivered to the guest using the Event Injection
>> mechanism [1]. The Event Injection mechanism does not block the delivery
>> of subsequent NMIs. So the Hypervisor needs to track the NMI delivery
>> and its completion(by intercepting IRET) before sending a new NMI.
>>
>> Virtual NMI (VNMI) allows the hypervisor to inject the NMI into the guest
>> w/o using Event Injection mechanism meaning not required to track the
>> guest NMI and intercepting the IRET. To achieve that,
>> VNMI feature provides virtualized NMI and NMI_MASK capability bits in
>> VMCB intr_control -
>> V_NMI(11) - Indicates whether a virtual NMI is pending in the guest.
>> V_NMI_MASK(12) - Indicates whether virtual NMI is masked in the guest.
>> V_NMI_ENABLE(26) - Enables the NMI virtualization feature for the guest.
>>
>> When Hypervisor wants to inject NMI, it will set V_NMI bit, Processor will
>> clear the V_NMI bit and Set the V_NMI_MASK which means the Guest is
>> handling NMI, After the guest handled the NMI, The processor will clear
>> the V_NMI_MASK on the successful completion of IRET instruction
>> Or if VMEXIT occurs while delivering the virtual NMI.
>>
>> To enable the VNMI capability, Hypervisor need to program
>> V_NMI_ENABLE bit 1.
>>
>> The presence of this feature is indicated via the CPUID function
>> 0x8000000A_EDX[25].
>>
>> Testing -
>> * Used qemu's `inject_nmi` for testing.
>> * tested with and w/o AVIC case.
>> * tested with kvm-unit-test
>>
>> Thanks,
>> Santosh
>> [1] https://www.amd.com/system/files/TechDocs/40332.pdf
>> ch-15.20 - "Event Injection".
>>
>> Santosh Shukla (7):
>>   x86/cpu: Add CPUID feature bit for VNMI
>>   KVM: SVM: Add VNMI bit definition
>>   KVM: SVM: Add VNMI support in get/set_nmi_mask
>>   KVM: SVM: Report NMI not allowed when Guest busy handling VNMI
>>   KVM: SVM: Add VNMI support in inject_nmi
>>   KVM: nSVM: implement nested VNMI
>>   KVM: SVM: Enable VNMI feature
>>
>>  arch/x86/include/asm/cpufeatures.h |  1 +
>>  arch/x86/include/asm/svm.h         |  7 +++++
>>  arch/x86/kvm/svm/nested.c          |  8 +++++
>>  arch/x86/kvm/svm/svm.c             | 47 ++++++++++++++++++++++++++++--
>>  arch/x86/kvm/svm/svm.h             |  1 +
>>  5 files changed, 62 insertions(+), 2 deletions(-)
>>
>> --
>> 2.25.1
> 
> When will we see vNMI support in silicon? Genoa?
> 
> Where is this feature officially documented? Is there an AMD64
> equivalent of the "Intel Architecture Instruction Set Extensions and
> Future Features" manual?

Hi Jim,

A new revision of the Architecture programmers manual (APM) is slated
to be release soon and that is going to have all the details for
the above questions.

Thanks,
Santosh
