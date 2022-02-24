Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21084C27EE
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 10:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbiBXJSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 04:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbiBXJRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 04:17:52 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219261323E8
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 01:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645694240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rUyon0ziXzbCoYk4LAHmM5G5cE9HdiJvxQMgR85UqUI=;
        b=fz5+ehQ3AVDGhQEwhNBwTEpYqyTWjhOpX7giFm784ZEeheIzbEMCWJBUpEM6EWongGackc
        WOY2iKXDrCqmZ9+RL5IZ4xaDfT/SyKWWYpmhNOdDy/C2knUzZ7qvdi844kgNwfyb1v25Hl
        l3ileAvxjAeoGJ4qAJ9qaNYEiRi3jeM=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2056.outbound.protection.outlook.com [104.47.1.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-18-fK45O7iNOVyX1kM3PRT2Dw-1; Thu, 24 Feb 2022 10:17:18 +0100
X-MC-Unique: fK45O7iNOVyX1kM3PRT2Dw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eeQPPraoSTzHI6MHC7pKqNvo2myC0itdV5DCzEUdM0WAVy65el4uDsc6c9tbJwBLOcyHI8z+G9igtfYOWS/BkSyRcVE+bu/f1NtWcT/g6asfETY9P+Vq3xv/+M7FH9nadFnhxY3/t7VLakHYrfnPXK1fGSCDCu3gW6kDIit/CdrDK007aPvAmkYh1svaIbDlP00fE7KZVJ9YnGxWlleyZ0Vh6PejoE0yhnXvFZ5hgMkEg5p1sJSXnIaZiAbEf6uwykxEn91YD20meuwibc4t3PHFQSRV7ZE2rdLEzm32f0eg7i60LxaA3qWXnrb6FayHgk9JoEhFe+13bSH1w8RBqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rUyon0ziXzbCoYk4LAHmM5G5cE9HdiJvxQMgR85UqUI=;
 b=aSPomVYSEqhUQFuGXr5E3oO1X7Wx4RdUwHH5iGrUQJh1mWr8+dyudFVaFn2xdw06uuT6fyZbdEj4W/1Jms/yry3Xu7WJl6VUF43f0LCHAZ/V0c3LIeoJFuprVEF++zqXENc/j4PtY4pn2DRGARDdGuoQzW/E92j1Ru7RIP4C08exoUG4jL4rYB84B+I6SSAZWEKOtXu4MQtR5GALCMxRitw+b6aovLYpKTk614gU3gajbH9PYPNRlcKLbX98Kpg0/pSKP8ZPbbKB8BomyilzYVu/om6Bua3KveXQamfUXEKGJhMOlMPI/21XVkg2XRu6rPzdryqjJ3zB3htSGFAV5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by DB3PR0402MB3866.eurprd04.prod.outlook.com (2603:10a6:8:e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Thu, 24 Feb
 2022 09:17:17 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::59d3:d855:d7ba:16b6]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::59d3:d855:d7ba:16b6%5]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 09:17:17 +0000
Subject: Re: [kvm-unit-tests PATCH v2 04/10] x86: AMD SEV-ES: Pull related
 GHCB definitions and helpers from Linux
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
 <20220209164420.8894-5-varad.gautam@suse.com>
 <CAA03e5ECgoC-2aSdVWJOAbMjq6iFZYbswWNWnA7movt5OK5dfw@mail.gmail.com>
From:   Varad Gautam <varad.gautam@suse.com>
Message-ID: <eae63b62-284e-21e6-673a-6dd7b197aafd@suse.com>
Date:   Thu, 24 Feb 2022 10:17:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CAA03e5ECgoC-2aSdVWJOAbMjq6iFZYbswWNWnA7movt5OK5dfw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0010.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::20) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca7f9114-d5d8-4bad-eba8-08d9f77673c3
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3866:EE_
X-Microsoft-Antispam-PRVS: <DB3PR0402MB386623293EC4B067B9980C88E03D9@DB3PR0402MB3866.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tYRTzzQEH6BXb+j+Lonb/3T529Vi14sT26zgJePcS8TewxFy17Oro1G/0iPFG+8bjGn1G0eX2ip9v5vmFuVHB1Tnxl6vC4O4iEipoWihz5iwqPotT+ZBwcLVgPIEU1MBIyuUMTOJ6g0uhS+7cgo8u+S0dPUSmxap7mitNEkQISCXsSGO2t9cfnOjhYSlrjEYCEDc8JldZtyGZRCBEGvovip4xRt9IxLssWmKiWdwEll2Vqt8x3wHilMODtDv1v0pgYQ56a/ZmjhmdG5M6tA7MbiAGafNHQKEz7GMLPFh5wdNoNMHlp1kzxGGs8xIBMND1r4eyksnAk1ZoYPF1GML4CTFWdfFU5SlK3QQrJri2B2QvfO3VEPeTz41hiQqSR2O8SM6gcsqH2Bj5guvC0GITdmYaVkOUpipSBxYEAGB31vRC/i8yoHi3onT0tWY7XI/p4XK5J6CvUiSOuzubBgDO0+eCN+BxmKBLIQQFWMFyODzjaiNSE/GBnwkqnB2IRJFImcS7UdRWNReAIl2j2tU9Q2R2znXGcuSpAhJjk0WOLnGjdwPMllRt3i0XisK0/UhSWMdnB9O+XQm6qkpFWr0KfecDde5RxHiNKerolvJlcPw19VS5aNmHVfmPn1/UgYCb4ALc8UC2k3KmtHKpJZ8NTiseeRXU3kdKReE8g7sfPS/aQsck6Utxk4bVn2fUHg+g3wos9VdQ4kx3gBon4sgFishTubPL4DA/dytYVTgViE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(4326008)(5660300002)(2616005)(2906002)(8676002)(31686004)(83380400001)(66476007)(66946007)(66556008)(316002)(54906003)(508600001)(86362001)(38100700002)(6512007)(6506007)(6486002)(31696002)(36756003)(186003)(7416002)(53546011)(8936002)(26005)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3BEdjlTelNLQ1dyRkgzLytXaWp5K0pPQ0J5SG9EZzJyVWJDYUE2V2FXdVpn?=
 =?utf-8?B?elI5R2U2ckRpNHlDSmlPRjFWUnd6d1VoeHlvSFExVTd2aUg5b1V4MlhheExC?=
 =?utf-8?B?YWY5aU9kbUUzRTJlemN3c1BNaStWZmJjeVZCQVNmSHgwaFF4dGFHTmZiTmpQ?=
 =?utf-8?B?RG1pdjF4TDMxOU5XQmVrR3dOZW5LN2RpNFJ5U1JGY3VjN3BqVUdzWldyNllL?=
 =?utf-8?B?ZjQ5T2hNVHdTemp3N2FPY2xQSjRVaTVRZHdKVTFzMGV0dnZTV1YyRTFWRkJP?=
 =?utf-8?B?ZzRsRysrcWVoRW1HWGVJajkyL1dRZ3d1blVGQmU0RDdLVGpZU096eng0NWxa?=
 =?utf-8?B?YVFEdFE0YktaZ3BwTFB5YjBrMnZlaFNIUGRUOW13TzI4dFZIR2xTMkhma2JS?=
 =?utf-8?B?Z1VLbkxUZVBic1hCU1N1MXFVZDc5K0Q2SGMvZndZTXNpWU5OaSt1dTFLNTl3?=
 =?utf-8?B?NkorVmVoRWZHRUdBMVk1dnorS2hCUFZkbDFYTWF4NzZmMEhXL1p1SHFoczRP?=
 =?utf-8?B?QmRDSW5HQmpVWFRYeHdPVnQ4eW1iN2hpZE1IS2w2VXFrVEY4bVlCd1B4Tkta?=
 =?utf-8?B?MWxHUHU2YXQvQ2wxa2lHTTRWUWlrMFVHQitJbXNCcTA0Rk5xeUJYc3RWOVRU?=
 =?utf-8?B?QXllMk5HU3dvZjRkNHE4V2EzK09yVFZlTSt0TzFMaGdYWVBQQ3VHUTh6c25E?=
 =?utf-8?B?YUxoK3F1YUtkUkxvWmJOMW5adEpQaGZhcEpSR3I5bjdMUW1rUUZBdmRyMVZV?=
 =?utf-8?B?b0wvcy9hZVNsUGRkNW9mMW5FUjRqT0kyS2JTSzk3WFlxUFZPRG1YZTFBZ1JU?=
 =?utf-8?B?VmlzZ3h5OE5TVHd3aS8vM1FzNUhkZEI1RU9IZGVwTnE0L3VXNWozWEs2VCtT?=
 =?utf-8?B?MHU5OER2VUNZK3ZDRmFybWNpcUkxUkMyenFOdTJCUGExVVk2cHZSZXVwOFVU?=
 =?utf-8?B?YWpNSDljOVlOLzFJNFFMNEgreGdWeU1Ea1B3QVFjWnNxR2tHTjBGZHlJZml6?=
 =?utf-8?B?dzhZQnlTQ0RKWC9iOWNtWm9JMmRQdFJLMllIaG13Tk5aRW4wS1hpWjJSKzhQ?=
 =?utf-8?B?aGFZVGU3Q2doZW9Jcnc2N2t6Q0wvcW5YUlF5TlArSnR5UDBhdEtESUdQcit1?=
 =?utf-8?B?djJiVmdLM1hJaE0wNXNCRmYreGx1Y21jeDlQUk5vc0lmcjFFN3JjdTNqeHkw?=
 =?utf-8?B?WStXdDFZT3pLV0Q2eG9CaE15NmQ5RG5KbEpDRlVERndCRDdSbS8raVlBVXN6?=
 =?utf-8?B?TlVJTGpGYUtISEZ3VjNZUndUcGR1QzNDVWJQaGZZTElMUllkVFRBV011Ulp4?=
 =?utf-8?B?akV4YktNMVNCdEpUU1VscU5hSGNMS0QxQ1JkbkNKd2F0QUV4cVEzL01CejRN?=
 =?utf-8?B?WFdjVllBbUZSUXBLSlJQdWNQVG5WcnNXU0M5bFMva3JVNS9kLy9DVWQrUmNJ?=
 =?utf-8?B?YmYzOUh6Ly9lTjVCWTI5NEJHbUx0UFg3TzJpZ04zRTQ0T2lwNlQ5akJ1ckt4?=
 =?utf-8?B?UDgzVlBzbE1NNmhEcVdDeDZEVHRITVl1YUpBYzFiZ3l6cEpMUCtwcG5GaHl3?=
 =?utf-8?B?OGhMQnZVQjEyc0tJeGVTVFJ1cEw0TjcrNkNYNEFIVnFzMU10c1RCRFk5cFUx?=
 =?utf-8?B?MHNMMGxhYkpiV3Z1bmVDMDFKaXo2N3F3TGpldkxIcGFsUEp3c1k5bDZyNlRa?=
 =?utf-8?B?RU5LdEFFWVcwTWJJenp1eURjQzg4Uk5FNmh2Y2ZZNHloZm9jQXVKVlVBeStI?=
 =?utf-8?B?ZlpZdGgrU1NMK1p3ak1Zck1scXpXZWt4cHM3d05yUmN0NkVncUh6bTJTSHUr?=
 =?utf-8?B?VG1MNVl5alV1OFQzYmRDWHg5N0RyaXhqUFhsZVZRdHg3QVR4UURyQnRHVDFn?=
 =?utf-8?B?bnl0aVM3NnNTcVdxb0tpaVBnM1ZjcEFSTERWZlVsRHk0ZFhsMXA0d2xpUFBB?=
 =?utf-8?B?N1dFbFp2a2duaG1VdnBTUnZHMVdpUFo4NGRaYUs0N0JmeVFpOUJpc2V0cm5I?=
 =?utf-8?B?Z2diSW51UTdzSDBOUGd2TzZ4bVZ6dnRqdC8vekJiYnJGTEhLT0ZjZW1Kam5n?=
 =?utf-8?B?NXZwd2VIc2tpWGdHNHNDQUh4bXlRWU5JMkN5R2tWbXRNbnplVEhMb3MrcVAr?=
 =?utf-8?B?MXhnU3BKWUpYTmRMNDZvclYvM3hiRzBrc2g0V1B2YXo2bTNQd2Y3TlB5MTFi?=
 =?utf-8?Q?o0gpSnaIeUnk0WlFwtFOzcw=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca7f9114-d5d8-4bad-eba8-08d9f77673c3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 09:17:17.2088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BE1tFuarlDWUXZ+tDc8h/zWfJRMbGIGnsUEygED268ZHmtel7egJOuOjGZZxLXcBTNFOdR7yvsADVcmtlPm4OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3866
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/12/22 8:09 PM, Marc Orr wrote:
> On Wed, Feb 9, 2022 at 8:44 AM Varad Gautam <varad.gautam@suse.com> wrote:
>>
>> Origin: Linux 64222515138e43da1fcf288f0289ef1020427b87
>>
>> Suppress -Waddress-of-packed-member to allow taking addresses on struct
>> ghcb / struct vmcb_save_area fields.
>>
>> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
>> ---
>>  lib/x86/amd_sev.h   | 106 ++++++++++++++++++++++++++++++++++++++++++++
>>  lib/x86/svm.h       |  37 ++++++++++++++++
>>  x86/Makefile.x86_64 |   1 +
>>  3 files changed, 144 insertions(+)
>>
>> diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
>> index afbacf3..ed71c18 100644
>> --- a/lib/x86/amd_sev.h
>> +++ b/lib/x86/amd_sev.h
>> @@ -18,6 +18,49 @@
>>  #include "desc.h"
>>  #include "asm/page.h"
>>  #include "efi.h"
>> +#include "processor.h"
>> +#include "insn/insn.h"
>> +#include "svm.h"
>> +
>> +struct __attribute__ ((__packed__)) ghcb {
>> +       struct vmcb_save_area save;
>> +       u8 reserved_save[2048 - sizeof(struct vmcb_save_area)];
>> +
>> +       u8 shared_buffer[2032];
>> +
>> +       u8 reserved_1[10];
>> +       u16 protocol_version;   /* negotiated SEV-ES/GHCB protocol version */
>> +       u32 ghcb_usage;
>> +};
>> +
>> +/* SEV definitions from linux's include/asm/sev.h */
> 
> nit: "include/asm/sev.h" should be "arch/x86/include/asm/sev.h".
> 
> Also, while I feel that I like verbose comments more than many, it
> might be best to skip this one. Because when this code diverges from
> Linux, it's just going to cause confusion.
> 

Ack, dropping the comment.

>> +#define GHCB_PROTO_OUR         0x0001UL
>> +#define GHCB_PROTOCOL_MAX      1ULL
>> +#define GHCB_DEFAULT_USAGE     0ULL
>> +
>> +#define        VMGEXIT()                       { asm volatile("rep; vmmcall\n\r"); }
>> +
>> +enum es_result {
>> +       ES_OK,                  /* All good */
>> +       ES_UNSUPPORTED,         /* Requested operation not supported */
>> +       ES_VMM_ERROR,           /* Unexpected state from the VMM */
>> +       ES_DECODE_FAILED,       /* Instruction decoding failed */
>> +       ES_EXCEPTION,           /* Instruction caused exception */
>> +       ES_RETRY,               /* Retry instruction emulation */
>> +};
>> +
>> +struct es_fault_info {
>> +       unsigned long vector;
>> +       unsigned long error_code;
>> +       unsigned long cr2;
>> +};
>> +
>> +/* ES instruction emulation context */
>> +struct es_em_ctxt {
>> +       struct ex_regs *regs;
>> +       struct insn insn;
>> +       struct es_fault_info fi;
>> +};
>>
>>  /*
>>   * AMD Programmer's Manual Volume 3
>> @@ -59,6 +102,69 @@ void handle_sev_es_vc(struct ex_regs *regs);
>>  unsigned long long get_amd_sev_c_bit_mask(void);
>>  unsigned long long get_amd_sev_addr_upperbound(void);
>>
>> +static int _test_bit(int nr, const volatile unsigned long *addr)
>> +{
>> +       const volatile unsigned long *word = addr + BIT_WORD(nr);
>> +       unsigned long mask = BIT_MASK(nr);
>> +
>> +       return (*word & mask) != 0;
>> +}
> 
> This looks like it's copy/pasted from lib/arm/bitops.c? Maybe it's
> worth moving this helper into a platform independent bitops library.
> 
> Alternatively, we could add an x86-specific test_bit implementation to
> lib/x86/processor.h, where `set_bit()` is defined.
> 

lib/x86/processor.h sounds like a decent place for both test_bit() and
lower_bits() later.

>> +
>> +/* GHCB Accessor functions from Linux's include/asm/svm.h */
>> +
>> +#define GHCB_BITMAP_IDX(field)                                                 \
>> +       (offsetof(struct vmcb_save_area, field) / sizeof(u64))
>> +
>> +#define DEFINE_GHCB_ACCESSORS(field)                                           \
>> +       static inline bool ghcb_##field##_is_valid(const struct ghcb *ghcb)     \
>> +       {                                                                       \
>> +               return _test_bit(GHCB_BITMAP_IDX(field),                                \
>> +                               (unsigned long *)&ghcb->save.valid_bitmap);     \
>> +       }                                                                       \
>> +                                                                               \
>> +       static inline u64 ghcb_get_##field(struct ghcb *ghcb)                   \
>> +       {                                                                       \
>> +               return ghcb->save.field;                                        \
>> +       }                                                                       \
>> +                                                                               \
>> +       static inline u64 ghcb_get_##field##_if_valid(struct ghcb *ghcb)        \
>> +       {                                                                       \
>> +               return ghcb_##field##_is_valid(ghcb) ? ghcb->save.field : 0;    \
>> +       }                                                                       \
>> +                                                                               \
>> +       static inline void ghcb_set_##field(struct ghcb *ghcb, u64 value)       \
>> +       {                                                                       \
>> +               set_bit(GHCB_BITMAP_IDX(field),                         \
>> +                         (u8 *)&ghcb->save.valid_bitmap);              \
>> +               ghcb->save.field = value;                                       \
>> +       }
>> +
>> +DEFINE_GHCB_ACCESSORS(cpl)
>> +DEFINE_GHCB_ACCESSORS(rip)
>> +DEFINE_GHCB_ACCESSORS(rsp)
>> +DEFINE_GHCB_ACCESSORS(rax)
>> +DEFINE_GHCB_ACCESSORS(rcx)
>> +DEFINE_GHCB_ACCESSORS(rdx)
>> +DEFINE_GHCB_ACCESSORS(rbx)
>> +DEFINE_GHCB_ACCESSORS(rbp)
>> +DEFINE_GHCB_ACCESSORS(rsi)
>> +DEFINE_GHCB_ACCESSORS(rdi)
>> +DEFINE_GHCB_ACCESSORS(r8)
>> +DEFINE_GHCB_ACCESSORS(r9)
>> +DEFINE_GHCB_ACCESSORS(r10)
>> +DEFINE_GHCB_ACCESSORS(r11)
>> +DEFINE_GHCB_ACCESSORS(r12)
>> +DEFINE_GHCB_ACCESSORS(r13)
>> +DEFINE_GHCB_ACCESSORS(r14)
>> +DEFINE_GHCB_ACCESSORS(r15)
>> +DEFINE_GHCB_ACCESSORS(sw_exit_code)
>> +DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
>> +DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
>> +DEFINE_GHCB_ACCESSORS(sw_scratch)
>> +DEFINE_GHCB_ACCESSORS(xcr0)
>> +
>> +#define MSR_AMD64_SEV_ES_GHCB          0xc0010130
> 
> Should this go in lib/x86/msr.h?
> 
>> +
>>  #endif /* TARGET_EFI */
>>
>>  #endif /* _X86_AMD_SEV_H_ */
>> diff --git a/lib/x86/svm.h b/lib/x86/svm.h
>> index f74b13a..f046455 100644
>> --- a/lib/x86/svm.h
>> +++ b/lib/x86/svm.h
>> @@ -197,6 +197,42 @@ struct __attribute__ ((__packed__)) vmcb_save_area {
>>         u64 br_to;
>>         u64 last_excp_from;
>>         u64 last_excp_to;
> 
> In upstream Linux @ 64222515138e, above the save area, there was a
> change made for ES. See below. Maybe we should go ahead pull this
> change from Linux while we're here adding the VMSA.
> 

I'll update this in v3.

> kvm-unit-tests, with this patch applied:
> 
> 172         u8 reserved_3[112];
> 173         u64 cr4;
> 
> Linux @ 64222515138e:
> 
> 245         u8 reserved_3[104];
> 246         u64 xss;                /* Valid for SEV-ES only */
> 247         u64 cr4;
> 
>> +
>> +       /*
>> +        * The following part of the save area is valid only for
>> +        * SEV-ES guests when referenced through the GHCB or for
>> +        * saving to the host save area.
>> +        */
>> +       u8 reserved_7[72];
>> +       u32 spec_ctrl;          /* Guest version of SPEC_CTRL at 0x2E0 */
>> +       u8 reserved_7b[4];
>> +       u32 pkru;
>> +       u8 reserved_7a[20];
>> +       u64 reserved_8;         /* rax already available at 0x01f8 */
>> +       u64 rcx;
>> +       u64 rdx;
>> +       u64 rbx;
>> +       u64 reserved_9;         /* rsp already available at 0x01d8 */
>> +       u64 rbp;
>> +       u64 rsi;
>> +       u64 rdi;
>> +       u64 r8;
>> +       u64 r9;
>> +       u64 r10;
>> +       u64 r11;
>> +       u64 r12;
>> +       u64 r13;
>> +       u64 r14;
>> +       u64 r15;
>> +       u8 reserved_10[16];
>> +       u64 sw_exit_code;
>> +       u64 sw_exit_info_1;
>> +       u64 sw_exit_info_2;
>> +       u64 sw_scratch;
>> +       u8 reserved_11[56];
>> +       u64 xcr0;
>> +       u8 valid_bitmap[16];
>> +       u64 x87_state_gpa;
>>  };
>>
>>  struct __attribute__ ((__packed__)) vmcb {
>> @@ -297,6 +333,7 @@ struct __attribute__ ((__packed__)) vmcb {
>>  #define        SVM_EXIT_WRITE_DR6      0x036
>>  #define        SVM_EXIT_WRITE_DR7      0x037
>>  #define SVM_EXIT_EXCP_BASE      0x040
>> +#define SVM_EXIT_LAST_EXCP     0x05f
> 
> nit: There is a spacing issue here. When this patch is applied, 0x05f
> is not aligned with the constants above and below.
> 

Ack.

>>  #define SVM_EXIT_INTR          0x060
>>  #define SVM_EXIT_NMI           0x061
>>  #define SVM_EXIT_SMI           0x062
>> diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
>> index a3cb75a..7d3eb53 100644
>> --- a/x86/Makefile.x86_64
>> +++ b/x86/Makefile.x86_64
>> @@ -13,6 +13,7 @@ endif
>>
>>  fcf_protection_full := $(call cc-option, -fcf-protection=full,)
>>  COMMON_CFLAGS += -mno-red-zone -mno-sse -mno-sse2 $(fcf_protection_full)
>> +COMMON_CFLAGS += -Wno-address-of-packed-member
>>
>>  cflatobjs += lib/x86/setjmp64.o
>>  cflatobjs += lib/x86/intel-iommu.o
>> --
>> 2.32.0
>>
> 

