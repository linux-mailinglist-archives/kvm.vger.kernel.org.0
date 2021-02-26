Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB81325D43
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 06:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhBZFly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 00:41:54 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58700 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhBZFlx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 00:41:53 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q5cvv3158223;
        Fri, 26 Feb 2021 05:39:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=PibVjJrJrWhtE77lGkCRHBaZppW9Ki2VlMQecieuDpQ=;
 b=wOrYy8XQqAfgtZWAPg/zn+VefabKf78jShUCWnTZQB6QVlArbEsSdSHHBEnQPdkjg+yb
 byfNhGqRHkKTX0TvIrqI6XhTJkgTIfe7x8YyM07pilmtsye5NwXt5FXDYnnX/+L8L+HE
 HGuTruyk6Cetm7bTy4JT/kFt/tH3GGM3nyms+ElWSkHugGkq5WjWYHOasrNU2jAQpHZq
 idonbjLLjlGLoj9CEOEfUPJMH+4/q80faSzoCfCfh1qG//PnqBrru5uIHU+wtRFfq0RV
 biUqLDoyJT2Uk2/9SESLHJNlluBGGzz9HsqMCkks/5O30Kk5kGZScPNItl9kzNUxdnq1 4w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36vr62b4vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 05:39:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q5ULOM058443;
        Fri, 26 Feb 2021 05:39:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 36uc6vfbgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 05:39:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKMTanz9ss5FhlH0oYO5F54WuFn4Ddb7yGrDnwTM6lwr4KHj8YIC1JlL0dDT2ZZSkDcIyMU0FS3I21qdvrPSmn3zNwuTbBT5ZuvjGPzy7pc0JLt1p4lFZ7VPQxnB7J43Sdrrm8TbIpXCPbDXf47xzEBY6D/lJPAcUZoNNrJhMIzynechc9IrCEX9g8UbC5yz+TmKaHFepU/GjqsCCM+k/kRPjXW14/gQQXaw7GQs2ai/9Sm+AB+team52EqZXu9L8FhvGN8gPentWUIesCeDXGbVttD2fOPhtJQXRgK9oO30kRnEGSolBXU2CsTT4/sR9/Gk0BgJa5OiCT4YAL7XKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PibVjJrJrWhtE77lGkCRHBaZppW9Ki2VlMQecieuDpQ=;
 b=fcRfR8Q8+T7EP5FZCUU7S89j9i6VnV63OIMkIj7+Hy6OwVKUEhHTkQ0VabIphCkjkbFfM76PJQrNESMPzW4oPw8oTIdOUKlBes+VNPkooajMxSpcom6acWyTX5r1TNkWlvTq34zF4iB4kLHJZb9ihUkKU6BArPPpt87ygDCUuFj94TcxsibHcVtavYe9N2uELghv4V28O9zDoWiUxpc10Yc0Z8ABZlKEuTAKnkvzJ12yshFAOmZI7Q5WeGQPQ99JJTFBuIl7WxJ9E3XJZ42ZAiE9X2DiIPU8UEdHAULE3Pr1o0eyuiMAeb8bmf1mRSky2qMb/xE6NJ8C6XddabSarQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PibVjJrJrWhtE77lGkCRHBaZppW9Ki2VlMQecieuDpQ=;
 b=afzoRu+lTzIEBP+waVJ+La+DDj6HHomMSHUgXh1rbvtMzYqWBdiyEVbqcI65Zityysc3p/1vEIU3UVZYjIqTl2f6Ltcm+XqHxBWd+7f7lzZH74RTXI/iDZRHHBnwGcJChk2qwV4yX6N6RIyYG5F6kFjzUNIsp4BdAF6e3QrAQSA=
Authentication-Results: zytor.com; dkim=none (message not signed)
 header.d=none;zytor.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BYAPR10MB2949.namprd10.prod.outlook.com (2603:10b6:a03:8f::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.30; Fri, 26 Feb
 2021 05:39:45 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::b52e:bdd3:d193:4d14]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::b52e:bdd3:d193:4d14%7]) with mapi id 15.20.3846.041; Fri, 26 Feb 2021
 05:39:45 +0000
Subject: Re: [PATCH 1/1] KVM: x86: remove incorrect comment on
 active_mmu_pages
To:     Sean Christopherson <seanjc@google.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
References: <20210223203707.1135-1-dongli.zhang@oracle.com>
 <YDhEby3lwgMVFEjl@google.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <5a003adc-de4e-f983-7d7e-d69870dd38c1@oracle.com>
Date:   Thu, 25 Feb 2021 21:39:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <YDhEby3lwgMVFEjl@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:646:c303:6700::a4a4]
X-ClientProxiedBy: SN4PR0501CA0102.namprd05.prod.outlook.com
 (2603:10b6:803:42::19) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2601:646:c303:6700::a4a4] (2601:646:c303:6700::a4a4) by SN4PR0501CA0102.namprd05.prod.outlook.com (2603:10b6:803:42::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Fri, 26 Feb 2021 05:39:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da353737-8ff1-4a26-d335-08d8da18ec05
X-MS-TrafficTypeDiagnostic: BYAPR10MB2949:
X-Microsoft-Antispam-PRVS: <BYAPR10MB29494633C9AFF4D719240DD2F09D9@BYAPR10MB2949.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XCecLt9gvlOsfF6K1YtN+vRbS1uRomfFLpqGfYn4lXWt8pj8IQCHnlFfZQsm0MYkmu4SdNrZzd/YQCDXtbnMDkTc1wP9QIDsVGyuyHT4HaPfFATKsOKvDmNVU5kB3nvmydk6sXc+D2NeyNvN7Y7SXVKwELWaekQxUa/HbMdmGBDIuudMKhx7+EoZev+UBZo+Kpabhf3typzWL5bbSbWy2Zd1EwveMKhQd4+W1FOuPMaCaFWTIscdTSSzxF99rboT2bwl9jt1Lw1C5HbtTMxZDMk6lu02MZVuSLweDT5rEzeGHuiGwlm3lwUi8FoKuRKfve0U/jGHrJajylT7dQlQ9ATdFqT2AHbXfDH4OespVyeidHk996VWdcr2rJfreBhrqssB0FEWLH+yobcCBvfumS2UBDTjSJ4LSockIQ7PlFCVTIShIHGJu+ijNKu04hrn9onFEX6CXEXVlgqdxyjdN3LDyFQGssXf67dPbpj6RN0FUHGFRyBtPvPeHVKhnfjRK5MhagSn68OBQNRkKqUbU4Ol8KHggq614LbuHMn726YSyxBj73nkgVnc/v7Cleg6ZLF/Qr3/nEFcif07wNWHy66MKYY88ccfII34SJ8dR2s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(39860400002)(366004)(136003)(53546011)(8676002)(83380400001)(6486002)(5660300002)(2906002)(66476007)(86362001)(316002)(66556008)(66946007)(7416002)(2616005)(8936002)(186003)(4326008)(478600001)(31696002)(36756003)(44832011)(31686004)(16526019)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NHZ5QVc2WUg2YVFZMENxTWRuRmRzdndBbVhmZmdYMk4zNEIwQ3B0WUpkNnhk?=
 =?utf-8?B?TjdKZEt1aW1nU2xXamJEYlpKc1Q0d3ljdjgrMTJJRlJmVlY3UnJKbGJMNWdq?=
 =?utf-8?B?N3RWSWU2NjJ6Qi96dUsvakVQaFNROU41aU5LNDEzQmUyeFlmaFlRNldtdUpq?=
 =?utf-8?B?MmxjaUpxNHhsaFdpbitTZDZsUW1zYVhJNWo3ZW9PMXJPeHZvaDdZQU9UalpY?=
 =?utf-8?B?bXp6MTY0YXFFdzJKbWo1cVB5bUpabkt2YVhZTjlvbmNnak8ybkFkVDlpa05y?=
 =?utf-8?B?OWxhVGlib0luTFI0dFFEMmdvYzVGOE9JTXR2YTBldHNIbkFHcGdsRzJCQ3Yv?=
 =?utf-8?B?WmdFcmd2OXE0N2tWVlR0NGpSb3M5VnUwdnpSaXFOK3JzRUVPSVluN3NWdVJp?=
 =?utf-8?B?UnlILzRlazU3ZmFpQ1BWcUhucHhWT1BIOC9pVkJHN25lcGMzemg0SHA4TCtT?=
 =?utf-8?B?K1FKZzJ5MkRhTm13T291TkJYdTZJaldrRHRld3N0NTZtSkJjQzlJajFtT1NW?=
 =?utf-8?B?VzF1UW1PUnh1N0tuQ1ZwUGhZdzlBVllTY1B4M1gyRGpydzZBaDg3VVlmRVlE?=
 =?utf-8?B?QzkzV1g4L3F1TUtCNFJpNGZFNTYyL2c0aFViTHlId1pnbnNHajl6SktYWkR6?=
 =?utf-8?B?UEJUSmM2SXdNeDZneW5PZFJrK0tYdjZUV01DWVlQNVRvVWJSVHZIcmc4VUor?=
 =?utf-8?B?bnR3Y3NvblNqMzVEamtwaUhEYjZLZkxPcm5pMFJKYjFkOVZPOWliSTFkUlIr?=
 =?utf-8?B?Wm5ZNDhudVVvQkVDd01iSXprZ2NERVVyUUNkOGxIcDNiT09mQ2FiSTV1T2JY?=
 =?utf-8?B?WEFaRDNlZDFobHpMRFRISGJVUEdmVUdhZ2V0L0hHU0NRSU4wNHpneWhYZUtG?=
 =?utf-8?B?clpoMXpGRHAvNDZKdnBIbGdvZU1ZTUJGTnA0YlVvcmlUYzRhTnZodjNsMVBL?=
 =?utf-8?B?cDZtT255TzBTaS9qY1U4V3dUbEFuVUZERERwdnovWEU3OStJaUJZdmtJV2FG?=
 =?utf-8?B?RnVQVjBWcFFvb3VGclBTaUQ1bHMzamdRMXFMN1VzWld6M2pKenRub0hWYUJ6?=
 =?utf-8?B?UkJEeVA1eHc0NjhRcFdJSFJLS3BlNmxWcGV1UzIrd29jbExGUHVxTXI4RE1S?=
 =?utf-8?B?dnhwTktsaEhVTTh1MmpXVGE2NEdybEt5bjJVaUViRDNXaEFwOGhGQVQ1RnhY?=
 =?utf-8?B?b0hEQ0M0M3NXdFk4UzRLT00rTG1IZ2h1T01pUUFLZkVtYVZSRjFQbFBNZ3A4?=
 =?utf-8?B?NlI3L094Qk5jazNTQjZqZWZocG9yTGM1VjdoWHlEUW14Q0VkSmgzbGlPdXp1?=
 =?utf-8?B?SnJUSnFlenVaVXMvRFZ3ZnpzSHJqQXNHZHRrY2l3MURUaGY0ZERVb2gvRzZz?=
 =?utf-8?B?TjhhUnc2SEpyNCsyYVFLYm15MDF6SVU5dS82VzN1U0dLSjg5TS9mMUZWV0VK?=
 =?utf-8?B?eVloNkJUZ29YVzUzdjQ5TU1pNW42NGJ1dG1BbzFoT3JzUHMwbVROU0ZCYThM?=
 =?utf-8?B?TWZTQUo0dUVDQjJrYjBHblZWVWV2ejlsazc5ZEdFUFVsakpNa1p6TGVxZWVE?=
 =?utf-8?B?ZHBmL09DT0N5RHZrNUNUQjhVbkM3dmI4amEzaHN6azVEVDBTdjdyUWk4ZFRV?=
 =?utf-8?B?OG8yYk9NUisvM3IyQk1lY3B4VThxUjZhOGJMYmI4RXg3OXhTT0pQZS93c3Rz?=
 =?utf-8?B?UXJrVlRzUjg4R2ZUb09heHhvNUphSG9xaWRZNmJwZU82NlVjcUpzdVhiR3Rt?=
 =?utf-8?B?TncvamQ0b2crTDRpblBnaFhYT0VzanJ6UzZPS0daUk0rMzJhNmVSS0dzcmJS?=
 =?utf-8?Q?JIuB+hR1ME4Tg9MUlKSL6oYxYt/NIeKWK9AaY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da353737-8ff1-4a26-d335-08d8da18ec05
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 05:39:44.8429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /cppJ2wC4jjyjoyk6X20OGuSTsGCflUb5GDlL62YnR+0QT9lfuYMP3u3SD2I+S+uLlrwbLt1FIiUUUiUzHwaog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2949
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260042
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260043
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/25/21 4:44 PM, Sean Christopherson wrote:
> On Tue, Feb 23, 2021, Dongli Zhang wrote:
>> The 'mmu_page_hash' is used as hash table while 'active_mmu_pages' is a
>> list. This patch removes the incorrect comment on active_mmu_pages.
> 
> Maybe change the last sentence to "Remove the misplaced comment, it's mostly
> stating the obvious anyways."  It's more misplaced than flat out incorrect, e.g.
> the alternative would be to hoist the comment above mmu_page_hash.  I like
> removing it though, IMO mmu_page_hash is the most obvious name out of the
> various structures that track shadow pages.

Thank you very much!

I will change the last sentence and send v2 with your Reviewed-by.

Dongli Zhang

> 
> With that tweak:
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
> 
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 84499aad01a4..318242512407 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -937,9 +937,6 @@ struct kvm_arch {
>>  	unsigned int indirect_shadow_pages;
>>  	u8 mmu_valid_gen;
>>  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>> -	/*
>> -	 * Hash table of struct kvm_mmu_page.
>> -	 */
>>  	struct list_head active_mmu_pages;
>>  	struct list_head zapped_obsolete_pages;
>>  	struct list_head lpage_disallowed_mmu_pages;
>> -- 
>> 2.17.1
>>
