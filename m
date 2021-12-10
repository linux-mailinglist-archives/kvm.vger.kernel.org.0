Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C3546F9E6
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 05:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhLJEl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 23:41:28 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13538 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229481AbhLJEl1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 23:41:27 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BA0W5gb012280;
        Fri, 10 Dec 2021 04:37:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : date : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PgsXyRv1zMmct7k+oq+R4dzh3F5/48R3Bo1dLsHxNNM=;
 b=RRH16bhR7h77ugnPahJSlL047EWPoKIsCApHJecv72KZzjx8WraqaEBEzP/noM/iqTgZ
 1eChYJWYmJb5AtmUpPV102OMqrqAFWFeI4E3g70b4d3DN02NkNfrDsmTYN0gpyMR30JD
 tcf97g9Glg2WsP8tQixTzUdLsSMZ4ZD5GiV87sJzoglrefRE905zf94ptHZBNNhXAOAU
 3NGUHELXezv4llSg5DzbUHwhGA3iKiJgT3CwBvt7MP5pOzPFwzCqAmRGv5T1ViwqOT66
 AdVodJNyO+BHtnh0xm5/RKQxy7uTh0f4Sw8CtwMBNLoc4j58ktmJ4xf2YeyVTFfQnWzc sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctrj2wcdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 04:37:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BA4ZXX0081657;
        Fri, 10 Dec 2021 04:37:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by aserp3030.oracle.com with ESMTP id 3csc4x79v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 04:37:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9x/zLFrE8HB7TX7Ajdf9FQHURjsAHXAghtjWKaZvFaDGN+0q8wh+3ryJ1EU2uU6IhRmM7M/f6rrEHbA7sLyz0TwE7jYMLIxgnSh7F27FVhCXZzIxpxlbL0qgruUaeo80mjvU+fvpfZ62yNbCwREKZyzgTUADzTS8lJ599GM1dbDM/tCyn4+wqJCyfQa00ZOnVfiNIBpZ3yNz9Axbpce+/xhubFKdOYhazjt8QZV6aQRMky1qes5AWC1tem1snJ2gyo3NOB0DSbflKHP8coN9SwjeuzgAJqS0oTUdT0eFoJaHgnNkBbFQVq6VUiJz4y5gQyjWJks/tUqHQHp44fhxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PgsXyRv1zMmct7k+oq+R4dzh3F5/48R3Bo1dLsHxNNM=;
 b=f6DnyBq6XdviJJuQNAzV8n0Ba2ke0vnBF7LBJ6Ptr2tSuApQRmdlv9TyLNph+8Co+YyDQ+P3291Cs6L2BChRYwqoV4KuidQXUZP1hLkB6l9309miJmDOIBHaaBgAUkalht6LdkwkGvATccgpeUQO6ik2UsWTpZ5dEyhACjSa6y36E4xGKoISzCWUrpxNXVfGBPwKGfjLB0oq5PCFhGrS4BAPw98p2FKIpM1e26MHI2L5TC5idhdN7GNJHv0zsT/ghcyda5cjrXt39aaplSHLAwARh/yFDD61ntFnXkEdNvMtlnIqUM/1WON6XnK7izd4b5JtxYPqExreqJZ3+AdC5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PgsXyRv1zMmct7k+oq+R4dzh3F5/48R3Bo1dLsHxNNM=;
 b=sf6Utu78CYNdwkhyx8SUS1uzgf74XHIUFtSZuNjfAmll4ywOKmLk4Qa2Gz8M38U3mUgA4IDBq2JrXfHcvB/IjsUVjXBeBJS2q6t4wWi1sazKcouKebkMzlk5Ms3ONb5/bc/7nsRoXkqo0jHkoi8uvdnhRai+2idwnXvO39xRHIM=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by MWHPR10MB1824.namprd10.prod.outlook.com (2603:10b6:300:10a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 10 Dec
 2021 04:37:19 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::8cb9:73cc:9b75:6098]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::8cb9:73cc:9b75:6098%8]) with mapi id 15.20.4778.013; Fri, 10 Dec 2021
 04:37:19 +0000
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
 <20211020170305.376118-8-ankur.a.arora@oracle.com>
 <b955c5c4-bc4b-9f43-be1c-3a45973de259@linux.alibaba.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     Yu Xu <xuyu@linux.alibaba.com>
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH v2 07/14] x86/clear_page: add clear_page_uncached()
In-reply-to: <b955c5c4-bc4b-9f43-be1c-3a45973de259@linux.alibaba.com>
Date:   Thu, 09 Dec 2021 20:37:07 -0800
Message-ID: <87czm5ulcc.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: PN2PR01CA0003.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::8) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78236596-2d77-4f01-6c4f-08d9bb96c027
X-MS-TrafficTypeDiagnostic: MWHPR10MB1824:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1824371682E33D3688C7E11ACE719@MWHPR10MB1824.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: suT7ruqut5M0glCgZtSmHyyjdO0ZzrQLGm168TQioAHK8F/vgIVpz/yRf0dGFlGhrAbnwCY93oql9VcDDs0iNl0qlMUMDtHkwBRdIoajfPOEp8U15E319xt6ej4E5hO0H5RorxfKNHXKN8V03ScM1uP91oetZRNyywa/Czp5HrBBWwpeLpptio7SLkHcBLokRSi8muROsjJRXisBRTydrG68ouYefmdwKwa5SJ29bTJyer9hVOspUff2AkxYM7nIe10RZbi/USAll38tGa/HGaDIwgaHvQEhUjrTlom8LaPYcZZ4W7PGIsgk6ZgfEnqCemC5Z4p8OAXKc6ssypd4jF1BCnQQTwoc8WS2jRzUvZ+Bt0t1+J0TVQhsMv7Q3lHhdL8zCvGST1r/kxSqOStlRle4VU44Q6YGyIU3gnGBU4ryOhUwLM7BsvG11DkTYFpAm/tteWseKSicyD0zUSHlzMgfNqjM5bGxDB8V08OjtI+iMwDqLxC0qzoFork0r49xefRzWDun/KeVDmJQzYAAkB0dVIbkY3lMoLzbBFKEqdlx/BadeH7rI3AnrltCYIg/JV7//WGEMEsfxoZnOkBOtLxSinmVFth1Ejord0UcgLzlnQZK/wBqgL6qSOjnMtr+ses9fTcyU7QYWVb08kE78Y/O6FbMQq13Oi9fAC8ZHAVD0qG1kCBqWxIuNn0OiJVo6g6WZM1YkpvRb+5rWTlG8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(5660300002)(8936002)(38350700002)(38100700002)(8676002)(107886003)(316002)(2616005)(4326008)(508600001)(7416002)(6666004)(86362001)(6486002)(52116002)(66476007)(66556008)(36756003)(53546011)(6506007)(6512007)(6916009)(83380400001)(186003)(2906002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ksVTf66Hr2zcGXz0S7vTLsTe7qETqQ2QUf29i8+3/JBLw6B367u+wdIpa1xI?=
 =?us-ascii?Q?strkHMDFibcEForZB6kRSpcQeQ974hJ9btw/DxwDODWKS/60aoRQQlTww4tT?=
 =?us-ascii?Q?lmN5bPscgg+05+zc879gpto9cO6x+ed+94Kv2A85LwVSDqR6CADkdJ/3G/oo?=
 =?us-ascii?Q?4Ev5Ivge6yPV1MAqLmx8D6W7KKXwybjeQmRJJn9rEVGkNGXeqSqUJr7TUscN?=
 =?us-ascii?Q?kQXMNDs/5Cie1fgu1mXQLlwUlqTTQLPFLqpTw31ww3XP+1b5m71j4hhFhvIi?=
 =?us-ascii?Q?fCar53YyBn5QxBPec3kqGiTD9mTWRdvMwMEmd31t0rxYfu6W1lFC+TwTjEqp?=
 =?us-ascii?Q?aI5m0IWTAeKP+fgXB7uGFvvISwWzzRDGwdV7gJSbqUcXWOW82ZtHhS7geCEh?=
 =?us-ascii?Q?YIC7FJMtFp7v1VJbR+2HT+/fEikK7eQqtAuYTeAXNXOmO5tAcYmWrwcmjvJC?=
 =?us-ascii?Q?BAd3suqRa/h5KbdwVtQ1+iW35HsMsfzMoRqrSBtHUBjo6Zdcw25EfbTNR2/w?=
 =?us-ascii?Q?9C9OUfE/ovt9QYjxbGpAlhtZepWPRPSqPtM7n+0z0XL7p68v9RcFHTEDVDL8?=
 =?us-ascii?Q?s2q00P2GyYi3xu5Hic3hpS6tf/MZKFKiDPm1xm5+wQOGczlh6B/xj+PabKki?=
 =?us-ascii?Q?9yQDfo22sEzZStJV4KCtn9vqhzOe16CqW+kpzd6Gok6oNU5bJj/qgJfrE3iV?=
 =?us-ascii?Q?5KtT+untw89HMmDGmv61TW7nK/hii8fb4ze+VtpvHoACjDwSApcfv/qwGPIK?=
 =?us-ascii?Q?tdpnKsskc8nYpETNnPfEF64N0KFFClF+Gvqqi/s9D5CtK+zCX7ietAp8FEHh?=
 =?us-ascii?Q?Ko2RB5yvbsQNdfLUIAMdcxTs5/T5qKQxQdYzkks9zD9B34yKaZRTFO7AHo2C?=
 =?us-ascii?Q?1SwmlzfRBOocPpUOxCBrY15VKxFRV5L6DizuI2oZnmq09WyBF1p6bj2a5KJ4?=
 =?us-ascii?Q?ritQeNh4uvVhzrvciTvXTyREGfVlw1VECT7VekbyHNkqg4b6f8AXIg5kF33D?=
 =?us-ascii?Q?rHdmqFdIBibqEKUMYqYhzWpymoaKO01IwP2wE0HvERtro6VLB/w3jh4441Ii?=
 =?us-ascii?Q?mRx1Ura+ni7ainfzgtSO2xSKlmCW5KMS5VEb7svds5fbmcotfhTxy4cpG747?=
 =?us-ascii?Q?1CNWF7JHuuPwEfaGThL3bokNDhdQlW1FZLXOYs0j38tXHZP4U8Y440GOYEL0?=
 =?us-ascii?Q?pUxNblJAjTH3TqKUStsOJrp8URFVSjC+ok0h+1IovtILdP1dVJpx5DKDwtu3?=
 =?us-ascii?Q?opq9zmDO/WGrxqj3kpVayQEap5MYed9MAerzgMNnyGQKGt56pYKyAE8ZiWSL?=
 =?us-ascii?Q?WajuawYHEq9YX8a83veM3xZVgrv/hT0ZDP/KqGhtMb1/yZcJjexttc8MJvvT?=
 =?us-ascii?Q?9HdOiTiMo2Ka6aSoCkw7oP6wIO4TY+8iMWGRnBnbrZMmkerZYKVOY69VHY2F?=
 =?us-ascii?Q?fY5GKRul1CwpVjdYbiDGW9xcWNTRNPvYGGgfOCOo7jISaof3ZlpMhv2QITYl?=
 =?us-ascii?Q?eSJdzk2bwWod/q3seeGASTun53ZMK3QNc7ZVd5VucnS4xTzH06BRWYwSIgCZ?=
 =?us-ascii?Q?MF2+UfkaHe0kKvp66OuVCXqcOpK0tj0hXQlcD4i9vBPVgxPtwItCEdpykqXa?=
 =?us-ascii?Q?sr8N0uk0y/RFgk3cEYWHM0SkHbI7wUqG1tFA2x2E7Xdu5OmWNNFhwetp//nn?=
 =?us-ascii?Q?fVGIag=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78236596-2d77-4f01-6c4f-08d9bb96c027
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 04:37:19.4964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AAbuG9xGdFC+LtKnWUtAHuhejbytio1v0euvapKotRoOseHMfvs7dYAmgu3h1/R5huUK2ThxPDiA1el2eioDqV0gM+2pZaTH1r7bxiSurbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1824
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10193 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100024
X-Proofpoint-ORIG-GUID: FOM953yynR2HNOtv8ZY59lKV6jGAbJ96
X-Proofpoint-GUID: FOM953yynR2HNOtv8ZY59lKV6jGAbJ96
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Yu Xu <xuyu@linux.alibaba.com> writes:

> On 10/21/21 1:02 AM, Ankur Arora wrote:
>> Expose the low-level uncached primitives (clear_page_movnt(),
>> clear_page_clzero()) as alternatives via clear_page_uncached().
>> Also fallback to clear_page(), if X86_FEATURE_MOVNT_SLOW is set
>> and the CPU does not have X86_FEATURE_CLZERO.
>> Both the uncached primitives use stores which are weakly ordered
>> with respect to other instructions accessing the memory hierarchy.
>> To ensure that callers don't mix accesses to different types of
>> address_spaces, annotate clear_user_page_uncached(), and
>> clear_page_uncached() as taking __incoherent pointers as arguments.
>> Also add clear_page_uncached_make_coherent() which provides the
>> necessary store fence to flush out the uncached regions.
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>> Notes:
>>      This patch adds the fallback definitions of clear_user_page_uncached()
>>      etc in include/linux/mm.h which is likely not the right place for it.
>>      I'm guessing these should be moved to include/asm-generic/page.h
>>      (or maybe a new include/asm-generic/page_uncached.h) and for
>>      architectures that do have arch/$arch/include/asm/page.h (which
>>      seems like all of them), also replicate there?
>>      Anyway, wanted to first check if that's the way to do it, before
>>      doing that.
>>   arch/x86/include/asm/page.h    | 10 ++++++++++
>>   arch/x86/include/asm/page_32.h |  9 +++++++++
>>   arch/x86/include/asm/page_64.h | 32 ++++++++++++++++++++++++++++++++
>>   include/linux/mm.h             | 14 ++++++++++++++
>>   4 files changed, 65 insertions(+)
>> diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
>> index 94dbd51df58f..163be03ac422 100644
>> --- a/arch/x86/include/asm/page_32.h
>> +++ b/arch/x86/include/asm/page_32.h
>> @@ -39,6 +39,15 @@ static inline void clear_page(void *page)
>>   	memset(page, 0, PAGE_SIZE);
>>   }
>>   +static inline void clear_page_uncached(__incoherent void *page)
>> +{
>> +	clear_page((__force void *) page);
>> +}
>> +
>> +static inline void clear_page_uncached_make_coherent(void)
>> +{
>> +}
>> +
>>   static inline void copy_page(void *to, void *from)
>>   {
>>   	memcpy(to, from, PAGE_SIZE);
>> diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
>> index 3c53f8ef8818..d7946047c70f 100644
>> --- a/arch/x86/include/asm/page_64.h
>> +++ b/arch/x86/include/asm/page_64.h
>> @@ -56,6 +56,38 @@ static inline void clear_page(void *page)
>>   			   : "cc", "memory", "rax", "rcx");
>>   }
>>   +/*
>> + * clear_page_uncached: only allowed on __incoherent memory regions.
>> + */
>> +static inline void clear_page_uncached(__incoherent void *page)
>> +{
>> +	alternative_call_2(clear_page_movnt,
>> +			   clear_page, X86_FEATURE_MOVNT_SLOW,
>> +			   clear_page_clzero, X86_FEATURE_CLZERO,
>> +			   "=D" (page),
>> +			   "0" (page)
>> +			   : "cc", "memory", "rax", "rcx");
>> +}
>> +
>> +/*
>> + * clear_page_uncached_make_coherent: executes the necessary store
>> + * fence after which __incoherent regions can be safely accessed.
>> + */
>> +static inline void clear_page_uncached_make_coherent(void)
>> +{
>> +	/*
>> +	 * Keep the sfence for oldinstr and clzero separate to guard against
>> +	 * the possibility that a cpu-model both has X86_FEATURE_MOVNT_SLOW
>> +	 * and X86_FEATURE_CLZERO.
>> +	 *
>> +	 * The alternatives need to be in the same order as the ones
>> +	 * in clear_page_uncached().
>> +	 */
>> +	alternative_2("sfence",
>> +		      "", X86_FEATURE_MOVNT_SLOW,
>> +		      "sfence", X86_FEATURE_CLZERO);
>> +}
>> +
>>   void copy_page(void *to, void *from);
>>     #ifdef CONFIG_X86_5LEVEL
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 73a52aba448f..b88069d1116c 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3192,6 +3192,20 @@ static inline bool vma_is_special_huge(const struct vm_area_struct *vma)
>>     #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
>>   +#ifndef clear_user_page_uncached
>
> Hi Ankur Arora,
>
> I've been looking for where clear_user_page_uncached is defined in this
> patchset, but failed.
>
> There should be something like follows in arch/x86, right?
>
> static inline void clear_user_page_uncached(__incoherent void *page,
>                                unsigned long vaddr, struct page *pg)
> {
>         clear_page_uncached(page);
> }
>
>
> Did I miss something?
>
Hi Yu Xu,

Defined in include/linux/mm.h. Just below :).

>> +/*
>> + * clear_user_page_uncached: fallback to the standard clear_user_page().
>> + */
>> +static inline void clear_user_page_uncached(__incoherent void *page,
>> +					unsigned long vaddr, struct page *pg)
>> +{
>> +	clear_user_page((__force void *)page, vaddr, pg);
>> +}

That said, as this note in the patch mentions, this isn't really a great
place for this definition. As you also mention, the right place for this
would be somewhere in the arch/.../include and include/asm-generic hierarchy.

>>      This patch adds the fallback definitions of clear_user_page_uncached()
>>      etc in include/linux/mm.h which is likely not the right place for it.
>>      I'm guessing these should be moved to include/asm-generic/page.h
>>      (or maybe a new include/asm-generic/page_uncached.h) and for
>>      architectures that do have arch/$arch/include/asm/page.h (which
>>      seems like all of them), also replicate there?
>>      Anyway, wanted to first check if that's the way to do it, before
>>      doing that.

Recommendations on how to handle this, welcome.

Thanks

--
ankur
