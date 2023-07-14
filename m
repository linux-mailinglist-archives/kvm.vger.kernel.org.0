Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D5C753AF9
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 14:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbjGNM3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 08:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbjGNM32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 08:29:28 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2078.outbound.protection.outlook.com [40.107.104.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0AE35A1;
        Fri, 14 Jul 2023 05:29:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnHWVMjH1nAYXNEDqXDv293RxoxVuKlyU9244ZgTRW2tr1a6AFuoDUrsiq5Dbcswn097zvcm2gze8fVgfkhu7u4yKAwTEBVtDbjE9CSh19APJyrG5AGqQ1yff0xNPgvJBCme2WuEsyzyaHYbAf/anVrWAI//hGsAmJEhhgGuf5P07gY+fAmA2uLiBiD5prgZQsMAYvY7EKjTvTKxpzYlENVZQVcE9zvcVZs+elMTU9Iwg3HlWOvUHXzhAgZLqcMwnstciKfq/MBj+/7xzLmvmPCrIGY3fnmIskom7hBLSE7t6HV4HJ71vKb9IxX3XngStFpni8Y3s/EAJ1mZoSK96w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w2t3L/hSRRZjqaV5sSCpUwSvgrFE/dKADUY0Rk/fxFI=;
 b=QrkcHr4sMkGyENOiMl7h3y0tekaaQP3U2Cm4OQfZfsUuiG58CgYZ4j9qWHgz7Ib5qe6K3xZowjCfyJr92B2DGMKA+A9lBJnYGNZAMTNAMJV2LwtoMlEe7P+ZktD6rD7oWV6T4AUCzvfzDMMaNS2MK5j7dM/0CoCcbHFi4REk0BWcSgaprG/QYGhLNwJd5hDN5fJMx5Nve0xIsGQEstFZpKIttw4TLfQ/38hzJbojD2TtGIAxUFoz9yNCL5LH1wPT/8XqaK4KWupTfV95fwxe/oi/Fubg8qvSk3ET+9fT+FFx4iG9GpGFJyXNCRwssORf/Y9aZgwGF+2ir3PhaVvWhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w2t3L/hSRRZjqaV5sSCpUwSvgrFE/dKADUY0Rk/fxFI=;
 b=igorbT6FTKUS5mXdf96vmEGZDM04ohqtqs/sVKpQctpnw4zoaK9V5y2Lwmce/Usa0v65D2ndYFMQf7kEcdgCWJ0wN6IvjHjiU5sFaM9OYae07QEi/ZGmuj+80HiqZBwV8B4JvYUqR4rwCG2j5eTUEKtD8hv9IHTBR/LNxUbFW4XTGSjFUltN3bV/+59qNToYbRucAvUvKPmcwJFtRsUamU5EDviEGLPP3wOJ/dW+n3ttQNvm+gzdXcOkfEb6EG5QURZLhusIDLMeIvvbN9CYOg698oxiEIlfk7DxE36LqYK1OyyP8PjRMW/D/CjUbOZtOvM4NUZVPfPvw4w+id2/PQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by DU2PR04MB9065.eurprd04.prod.outlook.com (2603:10a6:10:2f0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.27; Fri, 14 Jul
 2023 12:28:46 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d%4]) with mapi id 15.20.6588.027; Fri, 14 Jul 2023
 12:28:46 +0000
Message-ID: <574a6b44-38bf-85ce-1dd0-2414fa389c48@suse.com>
Date:   Fri, 14 Jul 2023 15:28:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 04/10] x86/tdx: Make macros of TDCALLs consistent with the
 spec
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, peterz@infradead.org,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
References: <cover.1689151537.git.kai.huang@intel.com>
 <ba4b4ff1fe77ca76cca370b2fd4aa57a2d23c86d.1689151537.git.kai.huang@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <ba4b4ff1fe77ca76cca370b2fd4aa57a2d23c86d.1689151537.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0129.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::17) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|DU2PR04MB9065:EE_
X-MS-Office365-Filtering-Correlation-Id: b10b629f-45bf-46b9-3d95-08db8465de6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2wtRq3m5c5FhzmCKG/bqrlax+Zt4e0kSbvr+R40c2FAboydetcd8x4BeNVWE2EEZ/O73iRm8uKtChy1Y33KBposBuFhQ20uISAmfvoQNXazOdMCG8nTS0L0ProPTFPzZYXgjqQNO/BSaYMTgdNS1bUemZSuRKaIXfSEOIxUp3S/cL0I1LH5tNNdN/Xb1mHiaTTzxeP+GXNHpQEPWFDGTsz3E1/2pLRjojkbDvoDsQBbm2VKryzUJxkB4ly+KL9HqkBDm4PH1kFzp+qESqyHVy93xuIGtipiSgVnH95KChS6goqBw/+4CxzXDRfpjwJKeYBiNB/rgvmF6/ZM+YJjPyv5AV3BhbLQh38dt4Cux73uul19X6Xrtvf1dzXVIYEs/NDLzkCpB+th9g9yE6k8VAq6++hDVDWahpKs3q9wnLElxP2m2xE4KOMkLtuUWjkofhb7ZuqoRCUnh7OQVBui5qDlVvO4Clq00oVZ33tHm4Y7g0xsh+Sbi+shL5gtunIrQixQU/6I2dSxCKzkpOwO7eTFioaF/4pjmBZjgYXJdKw1JsdaYH55pMkdMbyJcaDXTl8pG2LwxruwuuXztopKteCUOSMHTE7kzJCGTYr+YS/2qvR1Kcsh5t4RrSasR3iSc4P38D2C57E1TpyyupvVHQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199021)(31686004)(186003)(4326008)(6486002)(41300700001)(316002)(66946007)(66556008)(66476007)(6512007)(6666004)(478600001)(8936002)(8676002)(7416002)(31696002)(6506007)(5660300002)(83380400001)(86362001)(36756003)(2906002)(2616005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tzhud3Q0U0FBaUVud00yMDZFNWJOWnJJTlhkeDFTOHlyUzcvT1RDekx5Qk0z?=
 =?utf-8?B?UDRDaVpWR2RZUUIwMVMzTVF3R0F6Z1kxQk5vSStRQWUreDh4a1B4NURvblRt?=
 =?utf-8?B?bi81aEljRmxnK0hzSXJieFVlcG1qcEtheVYrTDdxRUhWeWFqUHVUSnFDTzlM?=
 =?utf-8?B?VlN6MnFxMlhMcUI4NmZVcWxTVlJXanFMampiMllqb0I3TTRXSE1WVTExemcr?=
 =?utf-8?B?TmFCUnZsM1pISndZQVBWaFVVQ2xDK2doZ240VkNsdTFRa3FoejFzdHJ6dGpH?=
 =?utf-8?B?YWh1WGowcFVMWDhsYlNLejZqTWVhTWtjQ0lYRFlLYlJKVDJ3SGRXNWVXSC8x?=
 =?utf-8?B?OCtCVHdsSW5URXhOR21PQXJQVHMyd2RSdnIvaFlxdzNHWlBBUXJ2YXBsUGl6?=
 =?utf-8?B?RjNFU3NMRUx1emIzVHNXQ1FLOTIybFY1dTB6YTZSYXlsNHF2YmRTa3BwREtH?=
 =?utf-8?B?MTNKaW9EMldKYXMxRm5WQnJobkFNd2RXUGovRWY1MGlXc3IvSkJ5VmttNG5I?=
 =?utf-8?B?RzZSci9BdllpS1pXM2VkSTNlNzJMNjllUjFXSlA0V0M1ZFFnMk5STndaRm1v?=
 =?utf-8?B?V1lxeGlTYXBvOHlmWGJzYXpvOWIwOTN1MkNscXZrSlRUWkY5QUVmbXRzYnFv?=
 =?utf-8?B?VUVwSzltZTdDQTlqeTFUK3Q4SHpvRnlTTHN6ajJLTk1GVTVmRThnRG5icUky?=
 =?utf-8?B?cTVmeko3bk42U21PalpXZjAyMXpnVzF0TFJoUWoxbkxRLytDSW1JUFFTank3?=
 =?utf-8?B?blh5MEZxWFY3L01FQ3c2eTdoK3Vpc2ZaRjRkYWxMalVrcTlXaXBaZlFveUk1?=
 =?utf-8?B?bGtPUUt2a0paeFBGNFU4MGp4UWZSeW1JanJVc0Q3ckJHaVdhN21CUjVBeFdV?=
 =?utf-8?B?YnRudjZJbzZvbEo0NkozZUZ4cTB5WnZMcDZTdVVLZEx1WVpRTlZFNmgzcU5B?=
 =?utf-8?B?amlLMy9Wc0U5c3YvMzh1NzkrREJ1Q1VsSlhDT3prbkVYSWV5M0FKZ3BULyt3?=
 =?utf-8?B?ODJwb0YzR3JCN3JYUUtjY0dkQVova09Qd0hXNTZaU0F0ZnJvM3VyMjR0Q1Fk?=
 =?utf-8?B?cGxENUxpVWdPQWZTT05WNlg4YW9JanU4OXlSQURpWTlCZWpzMDFOOTVzNWx3?=
 =?utf-8?B?UC9OZDN2aEsrQlpuTnZheXJaYy81SjEyVkxicWxiRjhua3o1RUE2emNUVEI2?=
 =?utf-8?B?YUJ6S3RzaXJIWkpES29obUFYWnhUT3M1K28yVnBIV1NTR0p2SkUrd09QaU44?=
 =?utf-8?B?ZURyczNaRy9HMWswRVdyMyt6YUZyRFNyMTB0b0s5b0tYNlo4TGdxY2syaDNB?=
 =?utf-8?B?eEpJK2dKMUllaE0rUmxjdHFJOHlaeXVjTGhtVDdUWlNCZ0lCcUVsVnBWM1l0?=
 =?utf-8?B?RFp3T3U3QkZXQnlFZGoxQnQ1VFlHMXVETk4veWJhbkc0YktuOGIxMnNGeWhm?=
 =?utf-8?B?VFpMcVJCbHA0NHBtN2crMnJFMEdZZndsbExvdVdVS1VuWkhLVGJyL2VPbGl3?=
 =?utf-8?B?RWRTc2lGeVN6dng5ZjVvZmVzMFU3QUFkTnY2RkhCWWhvZ2RQM29uOXBIVVU5?=
 =?utf-8?B?cDl4cXQrdzdLUU00SUNha0oxNmVrNjNNY0lsSHlTL1g1dlQ0RFFMZUVkWFBE?=
 =?utf-8?B?ZGlhZDcxNkZablplZDN3enRkbkdiSzlLZGF6VmdyZ1JGNWRFSWhoYm5sZDgw?=
 =?utf-8?B?Nmo5NFVpczFZRGY1RFRMc3Zzd080OGFkUjhnaGVRR2o3NVllQ2k0MDVhMTdI?=
 =?utf-8?B?NENvQlF4Wm9tNXQwdEdXWGVCaGdIK3l3L3dzT1I2S3RPcXFBV3FveWs3Z3Vs?=
 =?utf-8?B?YTlvZitralVIK2RUNFNIYk00cmdwQitzYlNmblBnYUliUytNaExGZVRiREJI?=
 =?utf-8?B?RzBMNFhrNVdoYWxNc2Q5b2RPZTNRdnNmbVJzRGJZWE1Mc0VXbTZ3a2wzS1Nu?=
 =?utf-8?B?d1h1cFdKb09OUE16MU8way9uTHZVMnJVdGhpSGNzT2pIQW1qOTN2ZU9TRkEr?=
 =?utf-8?B?YlVtdllLaDl5Rm5ORkhTNzlVNzN1Z3dkZzFJYzdLak41RmxjbUVRNUVoak1r?=
 =?utf-8?B?ZzhEMlpCcGtDZ1FSMTRPVnlyYzNZVlN3Q24wb0lyckFDSDVEYlB6QlljdjJO?=
 =?utf-8?B?NHd2bzFsbklyeWhhK0NwcW5VVFhhZW1EMllva1h5RFN4MUYrdmluNm9JTitV?=
 =?utf-8?Q?M/rd+E7V8203j3S4CYBih/SdN3+X/6hTD209ocOuTZ4r?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b10b629f-45bf-46b9-3d95-08db8465de6e
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 12:28:46.3189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G6tEBXe+4gK+2hT5ydzPdzYbcuoVKMCjx8PJ/XEn2IDrqvJkVNjVwSOTF8iIvqDnOtmjmEcTs+UI3o9r+vguFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9065
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12.07.23 г. 11:55 ч., Kai Huang wrote:
> The TDX spec names all TDCALLs with prefix "TDG".  Currently, the kernel
> doesn't follow such convention for the macros of those TDCALLs but uses
> prefix "TDX_" for all of them.  Although it's arguable whether the TDX
> spec names those TDCALLs properly, it's better for the kernel to follow
> the spec when naming those macros.
> 
> Change all macros of TDCALLs to make them consistent with the spec.  As
> a bonus, they get distinguished easily from the host-side SEAMCALLs,
> which all have prefix "TDH".
> 
> No functional change intended.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/coco/tdx/tdx.c | 22 +++++++++++-----------
>   1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
> index 5b8056f6c83f..de021df92009 100644
> --- a/arch/x86/coco/tdx/tdx.c
> +++ b/arch/x86/coco/tdx/tdx.c
> @@ -15,11 +15,11 @@
>   #include <asm/pgtable.h>
>   
>   /* TDX module Call Leaf IDs */
> -#define TDX_GET_INFO			1
> -#define TDX_GET_VEINFO			3
> -#define TDX_GET_REPORT			4
> -#define TDX_ACCEPT_PAGE			6
> -#define TDX_WR				8
> +#define TDG_VP_INFO			1
> +#define TDG_VP_VEINFO_GET		3
> +#define TDG_MR_REPORT			4
> +#define TDG_MEM_PAGE_ACCEPT		6
> +#define TDG_VM_WR			8
>   
What branch is this patch set based off? Because the existing TDX_GET_* 
defines are in arch/x86/include/asm/shared/tdx.h due to ff40b5769a50f ?


<snip>
