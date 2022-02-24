Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C74D4C2856
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 10:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbiBXJmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 04:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbiBXJmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 04:42:18 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0EC35860
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 01:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645695701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EYNwRAlnYimMuyzqGPJkjpUtsOKLBN/OTqav+eOZPLU=;
        b=RvmwEiQoHhoHGa6/Z/Q93f8wqcv9/77ugptg23owi+XWTRjcBRYs2WNMeYirHyY8Eok68T
        1/N2nPWfUC2ATFz+8csg1nwEhXHQzw1WRnp+nw1zXK7hrLcIIIg6qb7YcIZ1LsmWk2JwuZ
        UrEfo+DTd1nLpvnZjVMpXppaURysoDs=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2052.outbound.protection.outlook.com [104.47.14.52]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-5-iAYXKLb1PcuHzQDehjVyNQ-1; Thu, 24 Feb 2022 10:41:40 +0100
X-MC-Unique: iAYXKLb1PcuHzQDehjVyNQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHnK61vPl4e2zzLqO0uZ1WXb+/xrDiyWPwmBCMCJLEPwzuynqXTnj9ShG29AbEbtZTNEssA/V5dWHlvB52RsHBki/OJ02qiKSLUuKhjARppw9x9asbvtBw83dpul/kwqEhykwYRaocC9hX+/V203I8WtVwXoZrFZA1vZgm0BQxqfUT/bHWNG00VawMj0Q8AdO5wFlvwl/65OkjKVb4WrvgzQ3obO8A96xKUAhQLccS7QSocpz3tMFnusqllvb9U8ES7M137BC/OYPuyX2l89csCnPf7lBiebyd4SvM3U62DQwsOINOtgUpT0IxCtBzqD6YYUMqnRz/mDLh4fQR1kUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EYNwRAlnYimMuyzqGPJkjpUtsOKLBN/OTqav+eOZPLU=;
 b=EiLUEa7BX8Z+4M8jTbK2NkmB1X9+zA5wqUw9dSIFSp4D+/dsf1G6UhUpsO0QAU7w/qVWBQZ8ATD3N7g/nXYeCyBzfoz9U/CC6gYDhqC8O8wRbTxiF6+FoVAH+MDuhttLQjyhZIYupzH0AQp2cIyiPN5vAK6F3IF8sN6RGySLTDxMzfyxUt8hjFlAQloMnOGtNlvzkclU4Nwx6bp4dnrpowAE5R8NDUpH/KcaiVx6rRQeNRRZMqfGz7mr5CXHoM0sWII8uXm0ptk7KBraZ5gp9rdSop1as4Igye3+2Ni7rX56YryX/xIGECuE0oU+jAPvaxfFtnHcXGm7gmk8MmeVSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by VI1PR04MB6173.eurprd04.prod.outlook.com (2603:10a6:803:ff::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 09:41:37 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::59d3:d855:d7ba:16b6]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::59d3:d855:d7ba:16b6%5]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 09:41:36 +0000
Subject: Re: [kvm-unit-tests PATCH v2 07/10] x86: AMD SEV-ES: Handle CPUID #VC
To:     Marc Orr <marcorr@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
References: <20220209164420.8894-1-varad.gautam@suse.com>
 <20220209164420.8894-8-varad.gautam@suse.com>
 <CAA03e5Eu1SmGgV4ne22ox1qU2wGZ_ce-iFTiCNqzKeD7qeiUiw@mail.gmail.com>
From:   Varad Gautam <varad.gautam@suse.com>
Message-ID: <7e38127e-8c8b-d950-031e-f17a2792492f@suse.com>
Date:   Thu, 24 Feb 2022 10:41:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CAA03e5Eu1SmGgV4ne22ox1qU2wGZ_ce-iFTiCNqzKeD7qeiUiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0091.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::6) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cb2495d-e346-4201-2f89-08d9f779d9e1
X-MS-TrafficTypeDiagnostic: VI1PR04MB6173:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6173269363B2673FEF56E6AFE03D9@VI1PR04MB6173.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 36SAO3Iq5fNZ51KnDw7WSEj6FrrcKRk0csR97mUg2wsGVJK3i6E6IC5P0jIhcy1QP37ukHcmik1pj3Qq/b4yF9BppSad5kD6UvZCORlTWv+zBqcae0yYpZf5IWgIdgquTFwC9G1NvxKe/1c2QuCWa0ArXIive/OaXovaCylz0Z8bygkJX+Npa8kBxfQfwsqzq1ES9YJIE23Xp3Bjk19aMl7sOp/+uuMjocK4+U0KkNA9fxSAg+XItDVZrzURvoj4S8e70BEbsx/umylGjyZYE1yWS6sKYX/PsAS5GskXt7HyIYvMmQ8QFenxW6FdnoPDH6RxCEme5Lbz0kYdooFEx2N8/702YbYZ7rl1ue727RucQe7zKzlpvYI2iuDE8RB63c6eWYK5oUAxCOwIpiPwero15im6AD6BvF3eb6iyxt0ySc07sOFZhtID0/0kqOnyLxg3GFwaUy76dc/Z9s8+WT8Aa6kcObALt/majDxpE4ETzq+udupxDH6hlvt9njDRvS+z643DRIJVi/fNLktnjY3r76sDVYFH0yFTVNWC4Q+sIl6Qc1tnsB8C4hIuAehkctJgs+KH++oN+kTSOUEtwrvxNLHhTOxYvYPdzxbhAEYA/ryTaC93y7y0wU1o/olEq7e40skysgUUG7EITTOPJ+teXSsiD9ZBWy0ZFJ+ntkpzZElZJ1m27kPNtSwJwwBiTnE9ayB3oMx1XSjFGFL4mymsKLATRb3xGcHUWw5sNYk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(2906002)(31686004)(66476007)(4326008)(36756003)(66556008)(66946007)(8676002)(54906003)(6486002)(186003)(26005)(2616005)(6916009)(316002)(6512007)(44832011)(38100700002)(5660300002)(53546011)(508600001)(31696002)(6506007)(86362001)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGRLcmNQYU1EYWh1cmI2S01LWkR5TzAwLy9wcGoyUDljR3BCQlpwUG1qZ0Vu?=
 =?utf-8?B?Z2dQZ3lPcWlqaXlnWXhBMC9jTThSRVU2Q3IzSUxhaGdLVGRxbW1JYkJQRzNu?=
 =?utf-8?B?K21oTnFUaDY5VHViVzVXQ2VJUzZOQXJwK1BCL0tCOCtTQjBlNGRqT0ZSbUds?=
 =?utf-8?B?MjVobjIzTVRuUzdEUWNIVUEwQmYxa3F2eVczb1hYQXVkcXpXTU0zZVF0c2VB?=
 =?utf-8?B?aXRkUjlkemw3ME5QU3hjOFBvRHE2M05kZnlBemc3c3BpMWZSODZmbS9CUXN2?=
 =?utf-8?B?SGtIK3I0RGhzejIvU3M3dTc3aVMvNnFLZWthUHlZWGE1UzZ6Qzl2aG16THE4?=
 =?utf-8?B?WE80NFpzeUVRYnRoQ2wvZ2lJbDlOUnR3KzJKZ3UvNElROVh6TlJwNk5CVjZC?=
 =?utf-8?B?bm9QdWo2WFlBcCt3Ny95T0RhRjcwR2IzWHFzRTdpVUluRVMrN3ZRcXdCVGti?=
 =?utf-8?B?ZndnQnRkTmlyaE5zQ0FSUzd2K09pTWhRVEx3OXdIQjJEWm8zZmhtME5NSzcz?=
 =?utf-8?B?WXo1bHd1ckZObUxzR2gxOXVsTWNCTUhqQ2w4QXJOcHp3dnJIbmUycnVWRk9Z?=
 =?utf-8?B?Zm5rTUtDQ0p0Y3NNOUJJVFUxdmVyY2prZVl1cEpZYks2VGgrbncxZVBtRlV3?=
 =?utf-8?B?Q3psTnZJanQ3MndEZjhjM2U4VHpvKzc3enlhL0o3N3ZYOEtnRFFDYzVPNXVi?=
 =?utf-8?B?eVlFVU9jNWxaUk1RNVFWb1lnUHNMdzZjbXIvS21BM2haRklMeW9OMjVVcDRO?=
 =?utf-8?B?R0JIdzhyN0J1N1ZkVWpURXhHM3FKZHR2K0QzYmhJQjEwQjdCTitjNTBha1ZX?=
 =?utf-8?B?NDk3MW5uWi9zNTBybkVVVDFrRlc4VlhyUnIzRVJnb3huZjA3TFk3VnJKU0lz?=
 =?utf-8?B?QmtpN0c4UkVDcE83ajU5d0FwRlJjRlQ4bFJ0R0hiTGdGK2F2TGdzZHFvenYr?=
 =?utf-8?B?Rlgxd2dWVGhVcHBrTzNEMmRjdU1Za091eml4REIwRmxVdkhQb25uNlNDcVp3?=
 =?utf-8?B?NWdOdFVEdjFrNGFQNmErQm56UnZCMUJLSE5MQnp0RHB0ZzNmQnpuYjEvWnRH?=
 =?utf-8?B?U0RDY3lNcGFxUkM1MDMyVkw1MjBEVGNadnV5M2NybUtjeGV0M0tiYVU3K1R3?=
 =?utf-8?B?WFRjdlliNTIvb20vWkVHdTNFcnF1TVd0bHZ4WUR4aXN3Y2ZzWTl4a0c2ZkIx?=
 =?utf-8?B?YzlLdWRZQUg1R3NWUE5EM3oyM1M3S3I5bGlCeHZySTBjU2kyeWpqV2t2QzE5?=
 =?utf-8?B?Z1N2V1NEL2ZNa21UTDQ1dXlFUyswTUdWbWhFSW5ta3h3MXM4dU94Y3NrbGFF?=
 =?utf-8?B?Q2I2WWNJSnh5S005MDk4eGluVHR2RERjUmpLQ3dUdVlESE5SUVF1NFFFU0lj?=
 =?utf-8?B?NGpwRmJoVWcya3A4TmhYK3g2UmFOL0tBd0FNQU1xVTNWcERnRXNZM3RNOEVQ?=
 =?utf-8?B?b2JGWlJadEJMdXFaSmVGR3BEMXFCaXNnWldpTlNlaWtueHJESVVlaS9taGhL?=
 =?utf-8?B?QWErblpBWEF2QlNEazBSOXF2Q1drUVczZVlydTcyUU5nUC82MG5LTmNkdVpO?=
 =?utf-8?B?c3dBUFp2UVFBL0lSdmpPOHNSSDdLRU5yeTNsYWgxc1RGU3RTelU5V25ub3Ix?=
 =?utf-8?B?Q3FwYjdQcnNIdkE3bEgrcTNUaWUyWnVlaWFOK1ZaZ3JYeWRtT1EvcEFVNFJQ?=
 =?utf-8?B?Sm5KZjVyeVc2ZE16R0Z6czZTckNLb1hSVGcxRDZWKytOU1BVMnlPdEZmQ21G?=
 =?utf-8?B?RHJiWVNUZGxtMkR1TmRHU2xoUzJReG83aGZKeFNBbWltbXVRVEtiUWF6MmdJ?=
 =?utf-8?B?ZEZuQi9VV2hDWFNyN3h4Uld0MnhVMnFuQ2dOZHB4aWRkVEx1QUNpZjJvWTcy?=
 =?utf-8?B?dEIvYUd5Q1lTak5qZmVqam9uZE5kQlVkSXdMa0hOUGwxQllJMlBRcG1OSmlF?=
 =?utf-8?B?QkpRb1NtY0hrUVcxZDdSa2NjcS9sZHB6V05nblFWaWd3NzlTTVE1MkVqQlFS?=
 =?utf-8?B?enczTXh2K0JreDZtT2hRRG54LzJWODAzZDNlbGtKNkxldHpFL3hFcjlRWkFZ?=
 =?utf-8?B?Z3J5NExYN1IxdXRibmlvaXNkTEVHbmtxeFd1bEpnTXJVc05WME4wZUdMNzY0?=
 =?utf-8?B?ODllbzh0NG5PeU42ZWZlYzJWM2NPLzIvaU5XRGI1ejU2ZmQzdVd6L2hha3Ey?=
 =?utf-8?Q?GXhduzqGhE6hSR3b+ltHKQ0=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cb2495d-e346-4201-2f89-08d9f779d9e1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 09:41:36.9246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PIHfWAiber4g/YSF5YsQJWjqryhjuww1TbYzUvLdm1BJsel2gCKvG8i+b7lUCEyhzISoZqsLmQQMJM0wVCCwNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6173
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/12/22 10:32 PM, Marc Orr wrote:
> On Wed, Feb 9, 2022 at 8:44 AM Varad Gautam <varad.gautam@suse.com> wrote:
>>
>> Using Linux's CPUID #VC processing logic.
>>
>> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
>> ---
>>  lib/x86/amd_sev_vc.c | 98 ++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 98 insertions(+)
>>
>> diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
>> index 142f2cd..9ee67c0 100644
>> --- a/lib/x86/amd_sev_vc.c
>> +++ b/lib/x86/amd_sev_vc.c
>> @@ -2,6 +2,7 @@
>>
>>  #include "amd_sev.h"
>>  #include "svm.h"
>> +#include "x86/xsave.h"
>>
>>  extern phys_addr_t ghcb_addr;
>>
>> @@ -52,6 +53,100 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
>>         ctxt->regs->rip += ctxt->insn.length;
>>  }
>>
>> +static inline u64 lower_bits(u64 val, unsigned int bits)
>> +{
>> +       u64 mask = (1ULL << bits) - 1;
>> +
>> +       return (val & mask);
>> +}
> 
> This isn't used in this patch. I guess it ends up being used later, in
> path 9: "x86: AMD SEV-ES: Handle IOIO #VC". Let's introduce it there
> if we're going to put it in this file. Though, again, maybe it's worth
> creating a platform agnostic bit library, and put this and
> `_test_bit()` (introduced in a previous patch) there.
> 

Ack, it makes sense to introduce it later (and at a different place).

>> +
>> +static inline void sev_es_wr_ghcb_msr(u64 val)
>> +{
>> +       wrmsr(MSR_AMD64_SEV_ES_GHCB, val);
>> +}
>> +
>> +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>> +                                         struct es_em_ctxt *ctxt,
>> +                                         u64 exit_code, u64 exit_info_1,
>> +                                         u64 exit_info_2)
>> +{
>> +       enum es_result ret;
>> +
>> +       /* Fill in protocol and format specifiers */
>> +       ghcb->protocol_version = GHCB_PROTOCOL_MAX;
>> +       ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;
>> +
>> +       ghcb_set_sw_exit_code(ghcb, exit_code);
>> +       ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
>> +       ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
>> +
>> +       sev_es_wr_ghcb_msr(__pa(ghcb));
>> +       VMGEXIT();
>> +
>> +       if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1) {
>> +               u64 info = ghcb->save.sw_exit_info_2;
>> +               unsigned long v;
>> +
>> +               info = ghcb->save.sw_exit_info_2;
> 
> This line seems redundant, since `info` is already initialized to this
> value when it's declared, two lines above. That being said, I see this
> is how the code is in Linux as well. I wonder if it was done like this
> on accident.
> 

Nice catch, it seems so. It's harmless, but I will drop it in v3.

>> +               v = info & SVM_EVTINJ_VEC_MASK;
>> +
>> +               /* Check if exception information from hypervisor is sane. */
>> +               if ((info & SVM_EVTINJ_VALID) &&
>> +                   ((v == GP_VECTOR) || (v == UD_VECTOR)) &&
>> +                   ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
>> +                       ctxt->fi.vector = v;
>> +                       if (info & SVM_EVTINJ_VALID_ERR)
>> +                               ctxt->fi.error_code = info >> 32;
>> +                       ret = ES_EXCEPTION;
>> +               } else {
>> +                       ret = ES_VMM_ERROR;
>> +               }
>> +       } else if (ghcb->save.sw_exit_info_1 & 0xffffffff) {
>> +               ret = ES_VMM_ERROR;
>> +       } else {
>> +               ret = ES_OK;
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>> +static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
>> +                                     struct es_em_ctxt *ctxt)
>> +{
>> +       struct ex_regs *regs = ctxt->regs;
>> +       u32 cr4 = read_cr4();
>> +       enum es_result ret;
>> +
>> +       ghcb_set_rax(ghcb, regs->rax);
>> +       ghcb_set_rcx(ghcb, regs->rcx);
>> +
>> +       if (cr4 & X86_CR4_OSXSAVE) {
>> +               /* Safe to read xcr0 */
>> +               u64 xcr0;
>> +               xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0);
>> +               ghcb_set_xcr0(ghcb, xcr0);
>> +       } else
>> +               /* xgetbv will cause #GP - use reset value for xcr0 */
>> +               ghcb_set_xcr0(ghcb, 1);
> 
> nit: Consider adding curly braces to the else branch, so that it
> matches the if branch.
> 

Will do.

>> +
>> +       ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
>> +       if (ret != ES_OK)
>> +               return ret;
>> +
>> +       if (!(ghcb_rax_is_valid(ghcb) &&
>> +             ghcb_rbx_is_valid(ghcb) &&
>> +             ghcb_rcx_is_valid(ghcb) &&
>> +             ghcb_rdx_is_valid(ghcb)))
>> +               return ES_VMM_ERROR;
>> +
>> +       regs->rax = ghcb->save.rax;
>> +       regs->rbx = ghcb->save.rbx;
>> +       regs->rcx = ghcb->save.rcx;
>> +       regs->rdx = ghcb->save.rdx;
>> +
>> +       return ES_OK;
>> +}
>> +
>>  static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
>>                                          struct ghcb *ghcb,
>>                                          unsigned long exit_code)
>> @@ -59,6 +154,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
>>         enum es_result result;
>>
>>         switch (exit_code) {
>> +       case SVM_EXIT_CPUID:
>> +               result = vc_handle_cpuid(ghcb, ctxt);
>> +               break;
>>         default:
>>                 /*
>>                  * Unexpected #VC exception
>> --
>> 2.32.0
>>
> 

