Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CCA36495B
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 19:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240347AbhDSR6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 13:58:14 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36846 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbhDSR6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 13:58:11 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13JHu7hv171270;
        Mon, 19 Apr 2021 17:57:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=hvOMdtRXcXCxIJAv6ke5BBXA83H95KtCeVFSlqoXD6Y=;
 b=GGNIMVGfKda/3yfdUre9JCIyS5RsB8LvmU29F8/UrYQxgTF9QF8qTNv8IP78CIQeBkw2
 noJ+0TZwgLcVGY6pmlHh3ZuBpCV/rbOPukzL2v6gaRaoeqrmofJQRE8kIKXBszlkDSZW
 oESyGxNBYGCcZ7Wn4v8s41WmEKYFLI2jkE4ajObZOrG24UEWrwWgUQKuEN0xwN1f/15n
 tgwDuKZNJ47U7cUJUSIXT+8JzsNJafScWtyMgw4SC7M6I0zE+NIbR1FUO48i/u7l0lRE
 sHCNlI1mObSpO2pZVnw7fufghEGRyDx78l75/aRDCMf4As3RrlXRGBpw/Lxx2bhiUO5s Ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37yn6c4p0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Apr 2021 17:57:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13JHsqOC063280;
        Mon, 19 Apr 2021 17:57:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3030.oracle.com with ESMTP id 38098p0kad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Apr 2021 17:57:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FcM96liY4N5OfH33Un2zNzhT2Mko/2hp7U1YnZoE/o26Kl+OcmGbyF9PrFGBmIH5QHPSc4Ho4pWqlZ26O4oPUcKSWgcalOCrvF6QgOz4RnbK64yFvSfEL/kqm6ewaZO1n/Ss/hE+69pt2Yp9ivWF9A524BR03/iaro84jruStEoG6Fopng73I0uJIvSppj4Vz1YKAS69ijWIFW93pncy0GZPbC6mUdJShlC/St2n3LXmAK+Jtgd0werLiuQkZocbvH/CwTAmr7x8AbcdQEY9srpc0ze3Sd3b+dXyQx7rpso5ZqZ/uWQbiVG8qv/NtH+bT7V9W/NouHnW3TYqBuqgDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvOMdtRXcXCxIJAv6ke5BBXA83H95KtCeVFSlqoXD6Y=;
 b=ZeUVErObELC1WKemaQPSJBOSvqJqux/uRgzl7y1faVIyW3hgvfscfArjfG9aMsiGUaWk7Xo4MeboL2YS+VgzXoWO1PeCHPvms6hEFpIluQ8Awh8CNgxnrvfzyZOjiauRgoR7pxf8QOGdT+lSuZPN065z0UO4hsU6RTNh17WOOK2/LRi664IvBxmkEoYRoLQpUzPuaEQm72IyZgcQrKR5XUv57lX6yKq4Nzf+TF99+/Vz5eq/YxnM9Ij/YinB1PvnS0+q+ja9caKXlMGmrL2LTRxAjN30q8u7PI7nFMezEdQoCNsXaRHfGjCHTkZAe9BGIN4Efur07NNRlMMvaon21w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvOMdtRXcXCxIJAv6ke5BBXA83H95KtCeVFSlqoXD6Y=;
 b=EZf2APoNqTwYEnlNNY7p5vy1rM8Pf6Oc0BN0YENvVG90SsqE6dRtHg2g6qgiYwvAivZmSsQY00jQmlCAVGt1/OabQFau/dsWo8VNMOCFrI7wNbjZXhhVXxgpo5M8sX8V4WSdsPpFQcLcnjpv6l6bdiXwuyIqk0hwH+QhRznt2BE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4508.namprd10.prod.outlook.com (2603:10b6:806:11d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Mon, 19 Apr
 2021 17:57:35 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 17:57:35 +0000
Subject: Re: [PATCH 2/7 v7] KVM: nSVM: Define an exit code to reflect
 consistency check failure
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
 <20210412215611.110095-3-krish.sadhukhan@oracle.com>
 <fdf27d2b-d0b6-96fa-f661-bef368f04469@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <711a0aa9-c46e-7bd3-5161-49bd9dd56286@oracle.com>
Date:   Mon, 19 Apr 2021 10:57:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <fdf27d2b-d0b6-96fa-f661-bef368f04469@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: BY3PR10CA0002.namprd10.prod.outlook.com
 (2603:10b6:a03:255::7) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by BY3PR10CA0002.namprd10.prod.outlook.com (2603:10b6:a03:255::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Mon, 19 Apr 2021 17:57:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 847b8556-3388-4694-8036-08d9035c9cb8
X-MS-TrafficTypeDiagnostic: SA2PR10MB4508:
X-Microsoft-Antispam-PRVS: <SA2PR10MB45089686371FDDCD094F172581499@SA2PR10MB4508.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q8m/dzGXNEQ1+vanl6jn1GBZzT7tRMp9gatVJ4IOURiUO/PbtU7f0gnUl13SN0UUEROpdn8U7Zx0PzYyuEYYqYnfhViNvNfnR+kkhDt/zr5zXHHTKn4ANnBCK2n4WtO3yOf4dY+f53hLAFxwiQeDSO2kFQ3Nj3Z7fseKr3TBkn2WcI9UbUxqZQ+X8rCP7i19KXYtR9KOIEeu+mZxYxFCobFw168uMRsimZK0PtIBADun4e0TrD2Kgyzk+JbW9WgSP5Wl6+jX6F52mJ+/r7BxZi77M0rbgjVxg91iVUZXEZx/1ujfoc4AmnuDw/Z17O3I+8qegUDplUGnOK5wI6P0JOVJb8YQDz+BYOYAffY/D/YITP4UhQY9TWLA01EAlneOHQjIc++hM57LPrJ2esb1NRhtKl1Dy5wYhJES1MEW8/Ekaeow2MwwgN73EOrz6ihRdH2iYjMGPmxgCQXRA4FUFxTbPZarp7Ci72GLYjOduYNyadOg2TSBSeEX1XLvaG/+vsmstkrrzhJg0enAPe8BINHWU/UM7afyNS6PfGJq6gPWgWdjAVgcP5ukMj29+E9ooGXCM6rHge6hvUdsuLQTit76trK5RooXouO6K5EidMrBlmoW8goDLn2n5uqsxyGM/sDOtoWDWDeXiweh28QDoWG7UdvXvsvlglyg2Vg5ri7hqKFVtRvixqd8gifpkvgS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(39860400002)(396003)(16526019)(186003)(38100700002)(66946007)(2906002)(2616005)(86362001)(6486002)(6512007)(44832011)(31686004)(8676002)(31696002)(5660300002)(316002)(8936002)(4326008)(53546011)(83380400001)(478600001)(6506007)(36756003)(66476007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b0p3ZmdPRkwrVlN0K0RFODIyd2tFNytEL1FNRlgwZ24yWHlST2wrcUdkcGNh?=
 =?utf-8?B?V0NhYmgvaEFxVWhnL1dnT3JIKzBVeTJwY2tFTDg3dmpHR2NFOGg5aEpVTDVZ?=
 =?utf-8?B?d3hWZHVxelpGY0xHczZRaTlINTJxQ0NBZmxJRnNHVWVrYmI1QjZHMWpFQUlY?=
 =?utf-8?B?a0k1RzNGMnd1MVhoS3VJMVY1WEZKVU1UOXBYNmNhT2dZaURMVG94K3F2K1dm?=
 =?utf-8?B?ZlJMMGJmdUFTUmhhc3JuSG9kd3FzNDRpMjdtMGc4N3VrL3pEKzN6Z0diRTdx?=
 =?utf-8?B?YU1JK0hYc3pkT25UOEVYWTYxZVlDekU4akNORDNUTUtQRlFBN2tQaDM5bUdN?=
 =?utf-8?B?dzhXVkRHQjlZVXNHSHRMRCsyeVVrVFVCcWFaREdoOWFaeWNvemU4dG1RSEZi?=
 =?utf-8?B?RDByZWUzdjcxTWRoajU5dFJaZ0pkUHc3b2FYY2JTM3ZiWXI2RXdYaTlGWVEy?=
 =?utf-8?B?d0JJNkxDT08walgvYlhEeHl3V1BPM3RmbmszZitpUGZKRTFLb2NlazhzNWJZ?=
 =?utf-8?B?ZUx0eHpjM2VlSlRkSnZiU1RzbDZyWUg3RFlINUd1cElXd1lpZnVjcms2YU0z?=
 =?utf-8?B?U1pqaFRKTU5LZVVKN2NlWDUwY0lJd1FkUklBUTdCNHZTQUdGNzVXTGlyMnZm?=
 =?utf-8?B?WnF3ZDVpSkFZV25Sa25ZbFE1U3Nld3dzdGJibXd0ZG8wU0I0RXorYldJMFVY?=
 =?utf-8?B?ek5xUnhMS0ZQMjZmSnVZTGVNNUZDUW9peTRUNW1uZ0MyOEFWRVV1WVJFeDhq?=
 =?utf-8?B?anZybUh1UkN6amxiYUdrTnNjTDFmT1pnSEU5Ykt3Z2F4b2pVNjFBV3Bac3VD?=
 =?utf-8?B?bGxVWSt4UUhtbkxYeGZ2QzVlWDh3TUdIMTlNY3Jxd1gxSW1ORk1uQm50ZFRD?=
 =?utf-8?B?YlZ4dzQ2Tm5nL25XakNHbjRmN1IrWW1kUGZvS3ExbGIzOWVXcjVFeEpJeHBO?=
 =?utf-8?B?SnJ6RXZrQkZPWm03OG5sWmMvRFZKUTd2UmJVZ0cyV0w2UDlkMUEycGptcUI5?=
 =?utf-8?B?ekREWDJtWmxGRnE5alJHckxMU1E2UGc3QURlSEJwYklNeSsweC9ZRDlLOURL?=
 =?utf-8?B?cXBxeSt6TVZiQkU0dTdKVUs1eUQ2UmhVdmpvOG5EUFlLSXpCVGZrOTN5RGdo?=
 =?utf-8?B?dEM1d2FOenFoRkVjdU96a2tXNytjeThHbmtpZTBvcUppRDdUbDJ0TU8vQ2lU?=
 =?utf-8?B?Ri9JQ1hPemRpTi9YYW10TEpyV2pXV2ZsOUFwVWJHTEhNSW1NWHRZMWxZZlZn?=
 =?utf-8?B?LzAwdFAwUHpTSXFTSDlTVGNxbGNvNTIxcVJ3TEp3dE5rOWh5WjBVcWJPeHIw?=
 =?utf-8?B?UXl6YzFudWpGeVlTSXZyejg3RXlFbTlTeUdnMWRpak9iaUNWZGlqWHhlRXdn?=
 =?utf-8?B?Q3huODNpTlBVQWdFaWVSYWRWTkpGdmwzU2hOVjB6U3M0Smo2M3BFeW43OUF2?=
 =?utf-8?B?WlVFQnl0RFFlM0pOVDVJMXVjc1RudENNMmQrVzFwNU9BSnBPejFaR2dwT1Vn?=
 =?utf-8?B?THlXZlNKN1lOMmFtOXFTUWRkRzIyZ2NnTGdITURSbUtJNnRiWW9JZHBJK0FB?=
 =?utf-8?B?Tmg2bFlFQkpWd0p4LzNHdi9lVnNINzlFVlNLWGZMN2pjbnFURUEwaWZxOWdw?=
 =?utf-8?B?NDVUOENsYnFjQ3cweVRCRGpobUR2MWs5b2xtdmtmTnBDenpMcVo0bEtFYTBi?=
 =?utf-8?B?a1VkTUI5U0k5eVFaQnJuYW1aVDdlMGNZcjgxbmk4RHBYeWYrOUY5M04za1pS?=
 =?utf-8?B?K0JYSEJrUUwzWDJqWVBlUnU1ampuaHM5UGYybU55WFZDVDFwSzhaV1laU1pr?=
 =?utf-8?B?OUw4SGFMemt3YjV2d1F3UT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 847b8556-3388-4694-8036-08d9035c9cb8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 17:57:35.2486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6luFeD1TbSyQvV4AJtRqe7iviLxhEh+5E9kk9hJghmAvpWNwiMPd2vCSIwmzbrYPLlmWRqJqKaQs3iTIADxPWdzKSOiVTTAOXSp9wJHNYjM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4508
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104190123
X-Proofpoint-GUID: y1xCGeTZNiPyhLGWZWmFk7hjM0d0Y0KU
X-Proofpoint-ORIG-GUID: y1xCGeTZNiPyhLGWZWmFk7hjM0d0Y0KU
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104190123
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/17/21 7:17 AM, Paolo Bonzini wrote:
> On 12/04/21 23:56, Krish Sadhukhan wrote:
>> nested_svm_vmrun() returns SVM_EXIT_ERR both when consistency checks for
>> MSRPM fail and when merging the MSRPM of vmcb12 with that of KVM 
>> fails. These
>> two failures are different in that the first one happens during 
>> consistency
>> checking while the second happens after consistency checking passes 
>> and after
>> guest mode switch is done. In order to differentiate between the two 
>> types of
>> error conditions, define an exit code that can be used to denote 
>> consistency
>> check failures. This new exit code is similar to what nVMX uses to 
>> denote
>> consistency check failures. For nSVM, we will use the highest bit in 
>> the high
>> part of the EXIT_CODE field.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>
> The exit code is defined by AMD, we cannot change it.


The reason why I thought of this is that SVM implementation uses only 
the lower half, as all AMD-defined exit code are handled therein only. 
Is this still going to cause an issue ?

>
> Paolo
>
>> ---
>>   arch/x86/include/uapi/asm/svm.h | 1 +
>>   arch/x86/kvm/svm/nested.c       | 2 +-
>>   2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/uapi/asm/svm.h 
>> b/arch/x86/include/uapi/asm/svm.h
>> index 554f75fe013c..b0a6550a23f5 100644
>> --- a/arch/x86/include/uapi/asm/svm.h
>> +++ b/arch/x86/include/uapi/asm/svm.h
>> @@ -111,6 +111,7 @@
>>   #define SVM_VMGEXIT_UNSUPPORTED_EVENT        0x8000ffff
>>     #define SVM_EXIT_ERR           -1
>> +#define    SVM_CONSISTENCY_ERR    1 << 31
>>     #define SVM_EXIT_REASONS \
>>       { SVM_EXIT_READ_CR0,    "read_cr0" }, \
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index 8453c898b68b..ae53ae46ebca 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -606,7 +606,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>>       if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
>>           !nested_vmcb_check_controls(&svm->nested.ctl)) {
>>           vmcb12->control.exit_code    = SVM_EXIT_ERR;
>> -        vmcb12->control.exit_code_hi = 0;
>> +        vmcb12->control.exit_code_hi = SVM_CONSISTENCY_ERR;
>>           vmcb12->control.exit_info_1  = 0;
>>           vmcb12->control.exit_info_2  = 0;
>>           goto out;
>>
>
