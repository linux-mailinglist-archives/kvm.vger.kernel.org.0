Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE013452F8
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 00:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhCVXZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 19:25:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46036 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbhCVXYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 19:24:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MNO45q019327;
        Mon, 22 Mar 2021 23:24:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Kw61yaXZPcyKOOIaTtmKsoYUbw9HD9W6LJyH9cGQ0hU=;
 b=VTgtNoEjkTCEkHGq1q1Ut/P4vaLMEaRHciJZtksBa1xLq+IEUjP7fBu1Sq3clcUWGCST
 BDOQfI+MTZVTy4onyJ09woEou7/TJOMj5Xj8WJWbbog/QOJSu6REYIlsgYMOjW4Ziltn
 w0SDf3uq1gvGolEkTB5s9GSAGNYIPREWKySpjOgxNNHPRjsJwnK1Le9I4r/mOPwjkCI0
 e0VMoZwS89YwnP33ZU/762NAx9FRKMORVH+msemEvAj4xpmenzvrQcXUnM1UMLjSuJ1h
 EfM4nbHPy8lgsRbmwTwKggX9uvMULepVDEYXwE5ZOY762ei2T7BQhL3iXpSYnSP3L1Vg vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37d9pmw34s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 23:24:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MNKKEM083335;
        Mon, 22 Mar 2021 23:24:26 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by aserp3020.oracle.com with ESMTP id 37dtxxhsbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 23:24:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUPGlB/2IlkTeHaz4nijWjBgMuib6Tni8A9mP34qMb+0NMrGO47U2lGYHBSP1bk5b1GmZLavWB1mS7GT6yuv8V26t5u2kXxO0mX/tlEgBU5dMCjH/svEFdDPUs7dfpUVyRWDUBf0DlLg/c3x+aX1qiNlPfoMZszY/hIdDzq0aOk6taWtC70WxW/+XJadPLiBgpy4BgJRIZrxl2Mqwll8uDRX6eT5Y+RIDRCajkl0v2birw3MiwjFDy2gnaZBVxVKpYvNQadH0GEqyi/SaSy0ZwVlmOK/cFP6e05PnNOMWTBClmRDp4aZbc3qcD5xHmzmDYIVv43I09NS2/kcz1iO0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kw61yaXZPcyKOOIaTtmKsoYUbw9HD9W6LJyH9cGQ0hU=;
 b=IiXo3JbDg8pjS4eNHd4MXyCRhoWmp+Cqv26Ig5vxYCQv5LzQ30viaVwXgp/28PqDk3QKJVrGHlxNJM/vsoDQFQAuYjKPdTU1W/I91zaiUZbR7tXIRg36dPaGwFvvUTqQSo474QidYB66TJPf9+k9wZkVDk+KoDwojh3FlxG2k2W6EUmR+5aidFIJ+f+Y0EFYivp5KZnsJxBZ83U5gwiECffTb2bm+f3WR+xjFb6FOB0fQWHPwK8gLt1cG+yIJ/luKUT5AA+BGSBbbC8IdLnNv6eO75SRRX3qWxpNQ8DYn0QymZwZ9LPWuQCAzk6x07w1EAgRGXpYG/vZDUg7r1K/NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kw61yaXZPcyKOOIaTtmKsoYUbw9HD9W6LJyH9cGQ0hU=;
 b=n3IXoQsUQLT/z1OZdNhDITpDkxgA71OEBtx7ZwOdE7aXkAFBfg6bF7WhHiXWYJI4kysnk9iIo+QkTLa3zbb4JqRULZVqyLV3qe92uprn5qNbkIX37BNdMuNtQeGFlobesYeBKDfPLotr70V+dPMu8+cBtopDjkniPSi+kuscZG8=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 23:24:24 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 23:24:24 +0000
Subject: Re: [PATCH 1/4 v4] KVM: nSVM: Trigger synthetic #DB intercept
 following completion of single-stepped VMRUN instruction
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210322181007.71519-1-krish.sadhukhan@oracle.com>
 <20210322181007.71519-2-krish.sadhukhan@oracle.com>
 <cc8a657c-19c6-cefe-d527-6e14567dc7dc@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <1e4aab7f-e8bf-0858-809e-ae4493582a6f@oracle.com>
Date:   Mon, 22 Mar 2021 16:24:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <cc8a657c-19c6-cefe-d527-6e14567dc7dc@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: BYAPR11CA0092.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::33) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by BYAPR11CA0092.namprd11.prod.outlook.com (2603:10b6:a03:f4::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 23:24:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1fc7217-6c5e-42fe-2f7a-08d8ed89a110
X-MS-TrafficTypeDiagnostic: SA2PR10MB4665:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4665D57FB516F25DFB5ED7F981659@SA2PR10MB4665.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HxR7WkBU8541Bzoylu1BbEWyyjf0y3iBsKbJzY9rEPUB9fP8q6TEylbATqk7N0BjAocmiVHTVDliNNHhzcV7Ze56uuAuyzuoKkmSnztHshbpRzIdKizmPZagc61EUghB5np29iNqPBQ7YXb8TtFhnktFu7Z5Rwjg4zcO+yzn6LEL4EtcfF54Pigt7uiEdJsrblXcj99W0DRj2GBfLfN4wTG5HG+DrZwgqRmVPQbp3xUPz/giVYTdHlDHdOoqz3/YvGaae9BhYhC/tGwbilXLwzXMD6FjtAG5WWjAqGMaiKnzyBKu2aopNX0cHnWaJGEvJYA41pXAd+KW8+a6cc/yHovlS3i4hip17SyW9nT78ZzT/+VuFMqSa0pztUM3Y25ZUHc86lnU6rL5fPJqlUekp2NhinQoLvgN6rqvcurOiouHibfZvwe8ZHUgAvmYQm+/w9PXLpayTZaTtPNv3PWMwWFaM/1jlhI1azzS0IsXS0IzQ8ffhKDxyTVjZAj+9dg+ayeCXB/kGd0WA9xKEIoU84AY3ycxx/ZhtD8edVdTwoa5tyv+UhiIGe1ibszUdI5MO8kgXMj7VvDl+9W6m3BdUKAwQxGgZqoXx3JTAQFHFT9w6VIgdncf9tWKCd/MzapySwbpdq+Coy3/7IP94t/yQ6BIGWFHI9Om+w0boP4OhrztObWxSOE0T65jvc30FVgWCNEgoQCcIvhmvqOm83X8UA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(66946007)(36756003)(6486002)(16526019)(478600001)(31696002)(2616005)(6512007)(186003)(38100700001)(53546011)(44832011)(2906002)(66556008)(31686004)(66476007)(316002)(8936002)(5660300002)(83380400001)(4326008)(6506007)(8676002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MmRudzU0b3pJczZKWDQwVUwwdCtsVUNhK3FIelUzQ1o0M0RxNVZ1bXdycFM1?=
 =?utf-8?B?L1dmeTQzdy9pYURVa2lrQ3RpeU9BZ3VRR0xZZVU5dnpSUnRpSmpGTjB5V1ZX?=
 =?utf-8?B?UTU3SHBtSFAyV0docnVlNTk0RVIwZGFVM0p4RHVKZ1JDMXlYa0xUclZ4K1Y0?=
 =?utf-8?B?Qk1WWVdmNjZzdlZpRnpaVG02dmIzTjd2NkpZdmp3emwxb3poMS81MC9TTWo1?=
 =?utf-8?B?SkpWRmNCYUFqbEd5WmMzdldHVlFPWmJ1NldpOHVvU05xVUllbGhvbFJCUUpP?=
 =?utf-8?B?cThpOVRMVVdXQXJvTzRTWklVZTVlSXkwWEUrNWljT28za2gwN0h2Lzg3OTMx?=
 =?utf-8?B?MFIxcGtWbEJnWSs3REt2UlJBRkd5REVCU1BjN3JLVUhXQ1pZSmQyMU9XM2NE?=
 =?utf-8?B?MGVZcEVpY3FuK2NnMnI5ZHdIZXpZMUYyd2RzWlJCejlBOVhBY1MxeThnZi9K?=
 =?utf-8?B?RlhLQUM5S0huNVR5SFVsL3R1aUh2dG84QW9hR1RkalRXZnhiTDNpSjl0c25K?=
 =?utf-8?B?OWZZSURIa01nbUdxcGFVVGFpbGdPTXIvTHo4ZzJXanIrYzlCcjJ4SXJmU053?=
 =?utf-8?B?aDJoYWdzSU94L3VqVGR2cXczaFRTTlVNakJvNVlxN2tjZlRaS2ZxOWREdDhX?=
 =?utf-8?B?bisrNVQ5RmtMTitCRE1zYWtZc3lXMEdTclRKYlBxa2lOUkF2Y3diYStkeFNL?=
 =?utf-8?B?d05ibVErYUR0YUFaVzV5OEQ5VDhGeCtrK3l4RmJVU0NHd1dFdW9lY2dwZi9J?=
 =?utf-8?B?ZHJlb2I5Nk5yaUNyWGxERk9rc0NveWlXSWNjQlRsb1hPR01KQ3pyUU1DL21T?=
 =?utf-8?B?TFB0Mk5rNFJkckp3ZjlNV3BFaGNmOHBVblVzQjQ5UlJvYVlhNzlueFMxSFBs?=
 =?utf-8?B?K1ExT3Jla0tGZjZjYzFDcUs0NCtIVjVYaUVOLzdHOEFJRG5waUloTlpJcWUz?=
 =?utf-8?B?MUxha1ZaRGI2RmswY0hRK2hjdXNINWxrQW5TeHRoVHdpYzFJQlNBbmd2Y0RV?=
 =?utf-8?B?WjVRVGJIZmNOOUhwSC91cXlLTjlrbHlhbTQ1SHpYbzkwSGJORUo3Y05COFVM?=
 =?utf-8?B?UHZaVFZiWXE2c0tmZ2pPOFFpTzU0MExIK1puUUNpZFpNV1hNRXpHdFpORVls?=
 =?utf-8?B?VEV5K1hQaHR5VFNQcHd5NmY3Q3ZkbkRLeDFRbU5ybThXTjdZcXZFUC9leW1N?=
 =?utf-8?B?dklSSjNVZEUxdDgvNTliMWE5T0ROOHBYTkVSSW1yemhPK3o4S0lYQTlJZHYv?=
 =?utf-8?B?Ymh2TnQ1Q1R0RWxjdmhsYzlOQ0lSYnRSLys2bjZmMlFLbzBzR1h2bzZWVGoz?=
 =?utf-8?B?Ymt3K2x1Y2FxYWJONEl1VW1jdC9sa2ZKVCtWbWFOelpQRFh0OE01aDVub1NS?=
 =?utf-8?B?UWc2dWtXMFhZR09WYVpDNk1naTl6M3l0TUtaMWdpZkF6TTJIbGl0anJLZGh5?=
 =?utf-8?B?d0hGZVp3RG11OXlseGZDa0hJUm1hQUc1RW5yNS9rRjFtN2h3TWJLYUhIcmNY?=
 =?utf-8?B?SGV2dm5UdEgwVVY4dlFwK3hxTHdGWHFNZ1QyejJUQXhNWjdnZjR3bUlTVmNm?=
 =?utf-8?B?QUY2MjZkcXRrbFNaK3JvcU9xZTVFcUxVcDJIa3o5QnQ2dVkydzd6VER3S0VM?=
 =?utf-8?B?Zi9CdjRaM0NSekpHSGQxakdMTkFQMHhDM0NRNmE1OVlBdFFkYzlkNjVncmNM?=
 =?utf-8?B?clRqNjd3ZE5IRVZrWk54Nk03UTB1aGg0WHVqTy9ISjhiaDljYzlBOTMvS2s4?=
 =?utf-8?B?bExVeDRnRURmcnNhMnpscEhqYlNySzJtNU1GejJwNjZGbXYrSzJuemZ1QzhH?=
 =?utf-8?B?NkpYRFVydGJtVzNqUWlvQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1fc7217-6c5e-42fe-2f7a-08d8ed89a110
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 23:24:24.6916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: thSICIl13PW12KALMbNiaAFbZwWYg1HzhX9tptujpp9cUGj3zF7HOAQmYiZVrYxiDBhfqlKURK/NtvgVMkyyGZhUYCpS663Gu16JcaK48Uk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4665
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103220173
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220174
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/22/21 12:08 PM, Paolo Bonzini wrote:
> On 22/03/21 19:10, Krish Sadhukhan wrote:
>> According to APM, the #DB intercept for a single-stepped VMRUN must 
>> happen
>> after the completion of that instruction, when the guest does #VMEXIT to
>> the host. However, in the current implementation of KVM, the #DB 
>> intercept
>> for a single-stepped VMRUN happens after the completion of the 
>> instruction
>> that follows the VMRUN instruction. When the #DB intercept handler is
>> invoked, it shows the RIP of the instruction that follows VMRUN, 
>> instead of
>> of VMRUN itself. This is an incorrect RIP as far as single-stepping 
>> VMRUN
>> is concerned.
>>
>> This patch fixes the problem by checking for the condtion that the VMRUN
>> instruction is being single-stepped and if so, triggers a synthetic #DB
>> intercept so that the #DB for the VMRUN is accounted for at the right 
>> time.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oraacle.com>
>> ---
>>   arch/x86/kvm/svm/svm.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 58a45bb139f8..085aa02f584d 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3825,6 +3825,21 @@ static __no_kcsan fastpath_t 
>> svm_vcpu_run(struct kvm_vcpu *vcpu)
>>         trace_kvm_entry(vcpu);
>>   +    if (unlikely(to_svm(vcpu)->vmcb->control.exit_code == 
>> SVM_EXIT_VMRUN &&
>> +        to_svm(vcpu)->vmcb->save.rflags & X86_EFLAGS_TF)) {
>> +        /*
>> +         * We are here following a VMRUN that is being
>> +         * single-stepped. The #DB intercept that is due for this
>> +         * single-stepping, will only be triggered when we execute
>> +         * the next VCPU instruction via _svm_vcpu_run(). But it
>> +         * will be too late. So we fake a #DB intercept by setting
>> +         * the appropriate exit code and returning to our caller
>> +         * right from here so that the due #DB can be accounted for.
>> +         */
>> +        svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + DB_VECTOR;
>> +        return EXIT_FASTPATH_NONE;
>> +    }
>> +
>>       svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
>>       svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
>>       svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
>>
>
> Thanks for the test...  Here I wonder if doing it on the nested 
> vmexit, and using kvm_queue_exception, would be clearer.


Doing it in nested_svm_vmexit() also works. I will send out v5. Thanks !

> This VMCB patching is quite mysterious.
>
> Paolo
>
