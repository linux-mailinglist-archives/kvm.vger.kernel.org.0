Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A9838B5AD
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 20:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbhETSDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 14:03:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49390 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235935AbhETSDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 14:03:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14KHt8Bw099799;
        Thu, 20 May 2021 18:01:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=JeVENwXKwNyZfk+tk4Pla1tJtsNkNl5paoAHJhKI++s=;
 b=XOavUzTcHm1yhJEPRhnKbja++buHeZNHswWuot8giZ3fAO7+mJV1Z2ZRYrsCs14csLiQ
 xdVX4w+LS1VmAkLEzv8Cb89digWn3WAUWxnMcCEk9Loyn2NLjDfm9hEeqMlht8uR3h9b
 Sx+BDuhQsGn1olwg+ulh8na51mQTLhb1+EPVpR+e7PMpYo5cXuDNfIF5AeGMa882bPEh
 ZAm6xyJk6Jjd2f1ZXzZgXsrQMqdfWZsHtUC4JSKxW2Aa+m9jJmbt5TE6BVZkFMWSweai
 8U3l793d3d7sj3UTkTInSZi5MElk0kyu7fP0agePRRKF976XB+oenOvSheBlSq3sntXr 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38j5qrdj5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 18:01:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14KHtWSi124081;
        Thu, 20 May 2021 18:01:32 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2047.outbound.protection.outlook.com [104.47.74.47])
        by userp3020.oracle.com with ESMTP id 38n49203yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 18:01:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJl2pGm/vO42W3qN2Borx7c7PYf4IhiDi4iwpGbcwnpefWrtSzhNCKFoiJKgurYLZqkYO0xEalaoi2ZQEI7IAvXTG2PWgM1QR5fhutrkY+w9/ZQCVt5/LC9yoY7U3Z93eim+Ugb181XMNDZND+Wyx6rrrXo3OrK/Mwyw8d7kbZcF+VNPR1smpD+dfpkY/pT86iAFoAYjHg9oSLN+FPWl4NaFAmuXs6lKpDhtFtnlNHmTNBweri/cvlf5Ri9NuAz7bD+VDb47p1O2JCEu2k/knM2xREM5HACvJcK0Mcqes7P+wcM99mZAND6ZcSYbrbZJasrWW4QI+tmFcKOpoLiU3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeVENwXKwNyZfk+tk4Pla1tJtsNkNl5paoAHJhKI++s=;
 b=grNCgmNEHs8wxOEQVT9psElXCGsUjOxRyETBM2T73haYODHajeNLoWg+6UpOr2ErPuafvJDQKfhVNJJzJL9pLo8TAbsX2o5z6kOdcCBmJ99Ed8vW6w+PHTc64k2k08IO9+agCW4XkD8MU5sTRqz43YkyUc1tj+jZ2ElZV+szGTkbWL0aile62RmddRFqUKuvECNKd9ydDgsPwvb4rMVeKupWDE+IixA6jAesEB571rjziUYRkKfdKgvA3TigKQyV3XLEhhYShsC8dC33tgF8R3a6QsYP9iN8xoVkb5n2bCKQBfoFg0KLnXsGiTNMI8Z+1IJLGNfPCjllryFuhC2Ydg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeVENwXKwNyZfk+tk4Pla1tJtsNkNl5paoAHJhKI++s=;
 b=h5Oq+G66gRsg7ufopO+tgml15H2cbBXPKsXzSIQ9L0+kNbyPMcuF8shZ2NpOYv9P8jKeElZMRuM5NVZ2eTL+qCkEUg7YhCEm31M/YaHMczY5aIdRhY8OXImpFVjmpUGFRL4WV7F/6XhE6gpNDmPKsroP+gisdn5Xq29FRVMyWRE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 20 May
 2021 18:01:30 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 18:01:30 +0000
Subject: Re: [PATCH 3/4 v2] KVM: nVMX: nSVM: Add a new debugfs statistic to
 show how many VCPUs have run nested guests
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
References: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
 <20210520005012.68377-4-krish.sadhukhan@oracle.com>
 <YKZ4qTp2OIS6LYy2@google.com>
 <CALMp9eT+Sj4=tQZJaeLfJALkeUbo=jiTmM-CQ71z5aOhD6MMiw@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <c4221011-1936-15cc-9eb1-054a585d25b9@oracle.com>
Date:   Thu, 20 May 2021 11:01:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <CALMp9eT+Sj4=tQZJaeLfJALkeUbo=jiTmM-CQ71z5aOhD6MMiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: SN6PR05CA0013.namprd05.prod.outlook.com
 (2603:10b6:805:de::26) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SN6PR05CA0013.namprd05.prod.outlook.com (2603:10b6:805:de::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.11 via Frontend Transport; Thu, 20 May 2021 18:01:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2fdaa06-12d1-4f17-86cd-08d91bb94b8d
X-MS-TrafficTypeDiagnostic: SA2PR10MB4795:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4795898A10071DFA29CDD8E8812A9@SA2PR10MB4795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SuvP/peQzK1lNtCO3yZMij/sjQjriMnlqsiHsdxKyJBNUQ36CpaaTFrVicODB0LDCIjrTn4nYrDpIMksLHKkH2zW8l1AUzWsPtfOzBbce5f+sJLieFlYCdJ1CrfKr4Nqzltapfbl+gjV2ww8HfWYWVZiQFR9bFgp59UcZFNdz+AVKCu0esgCxmntTFFOiOaR3YBuMWQWIbPngzkvS+lyamPeW+S17qoLIJxl4bnVvbzFfq6PMXUf/tfbnz0pgV3CFgo0X+Xwqn/dyD9g6BBK6x+L3Q4QZD++i0bH/WMritBhQYQCmqV4W7dyjfjvrFrUnjr2mpKAdapixJPxrg7Ndr3Ofwdkh22z1c80nX5mMMpRWykuZto+L8PfZFgiG7BZzMdRbDV/hJeryfdhcY6UP+NbtthtpdixGGR2XT7olJfnRpM12fQS6zhJFp7gi2rRbsUWr90PiHO3pPSpzoGV05xho4+m4xuqQoINwMHCf7iO5UhbnnIQ71DzBVdgog1So1tnrByl853RX/Ey3Rx8L6w/sJzwuQv/c8G7gvvGQ4QBOO7eBRnhR1OfbvphA7C/1c6wo6pIzmuD9To1//18IvKE8JKMxiViFAm5wOh914gzfK2P4SCuzoFRlRXTavObMzzyXjBVvdrsHCzzJe7ml6JDtlIuCELCkLxqDYv5pfr+yB3J/ERXgGbWD/Hr88Vc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39860400002)(396003)(110136005)(5660300002)(6486002)(54906003)(2616005)(83380400001)(2906002)(31696002)(6512007)(86362001)(316002)(8676002)(6506007)(16526019)(53546011)(36756003)(8936002)(38100700002)(44832011)(31686004)(4326008)(186003)(66946007)(66556008)(66476007)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?elBpT2Y5SjZucUxZZTJWY2t1OENuUk9VYm1OZTU1a3J1azB3c2Ivd2hQRmZq?=
 =?utf-8?B?OUhuRGJUdVdJTzNXMGVxZ3VYZ3F1NWNHYTY1U1Q0TVJ3aHhLMDQxWkFFUEtl?=
 =?utf-8?B?NHlFdXVwazJBYkh6WG83SXBUVjlmSVlpclpuSm9ydXJGa3Axam5BcUFkb2RI?=
 =?utf-8?B?N3VYbmZTVFAzUUVHOUhMWVJiODFKVlRsL1gvN2drTmxFVFRDWnNqMnZFYU0y?=
 =?utf-8?B?WlBaYXpzUmEvcld3c2lKb0hTSTlsZVlTMms0amhsZ2FuK1NMNFFwd25MalZz?=
 =?utf-8?B?aTZqRCtqZjAxS3BYQVlEUis5Ukczcm5XRFBRb2pOMmtaUzZ4YURzRzkrNmdw?=
 =?utf-8?B?THJSZ25LMW1rd3FkcnV6Rzc5L1RLNXUzSFdZdjhScE5VK2E4ajNNZHdldTA0?=
 =?utf-8?B?ZW1sVi9IRjVoT09pdUpEU2lDR29GN1phblJZU2ZZM1JLbS9sN24rOFZ2R29x?=
 =?utf-8?B?cnp5RE5YMm1Kb0VmcWtyZkRXbHRTVklCWGM3U21JUUxaQ094amFiRTBReXUr?=
 =?utf-8?B?bEs2Q1VGSU5OMEt5dUxZR3RiQ3pXRjAvRFZKdGRtUFBiOXRCYTQxVTdreFZQ?=
 =?utf-8?B?ZFI4NDlGWHJ3enJQNXl5S2JFckptNjFEUzFia0JiOEZMUWRubThKalJFaGsy?=
 =?utf-8?B?UjZjWFppQWo1NXVDd1l0UTlWWjFkakUyM0VxeHZudHp1TGdHU2JEaHR3QUNY?=
 =?utf-8?B?ZFZRd2FGdTVYMmx1MnNqSmRuL0dpYktMbkZVS2txbHJXOW1oSHhGeUNXRC9x?=
 =?utf-8?B?UTNyRHUyQW1XSVhYUnRoNTRIWVNUL1Fpek9FUFY3Qmx3WEJMOHFhUHVZM29S?=
 =?utf-8?B?MzFoNURSQ0pIMFlNK0xwelpUTm9rdFRmMjRyQkgzODVwL0VNNEJDS3pBZDlh?=
 =?utf-8?B?aFp3Qkd3Nlk5bFFML2ZzamhIcUhGNk05c1VUZHpsQjBKVjhBRXFDZHRTSlRD?=
 =?utf-8?B?RFNmeDk0cU8xZURyR1ZiU0IrdW01Ui9ZeGRZVnZScWQ2TURIRktyMjVUSXVK?=
 =?utf-8?B?WGRuS21WaCtBbVBYOTFYeXBZUmUzTXU0RkE0QytPVlZqVzFaaTdPYnd1Nmk1?=
 =?utf-8?B?RnZrVEdPMEp0WThBRUlXYWdHQUtzalJrNnJ0Z293RjJORkkrRjRMd01WSW9z?=
 =?utf-8?B?RythWXJrMzFFTXR4UEZBdlpDbHpsY1JaK0JDaURFcGRqQVFFQ2p4NVplK080?=
 =?utf-8?B?c2F4RzVnQ1JTdWJ1RXc5REtnY3BWOHlkY3o3RFFTK1g5a0xucHlLR2pKQjlX?=
 =?utf-8?B?QzlINW9kZDU2c2ZVdlVYNmJFY1R5VnlxSzNiN0Ntc1NvM0dsQ3hhSEFnMzEz?=
 =?utf-8?B?bXJ6N3FVYjJCR2x5Q2FjUStnUU9rTUlYWjBDcXVoYzV3elpNU28vZVhkOWJx?=
 =?utf-8?B?QkpvT3RtZm5NaVlodStpNmFnZVYxNnhvR000Z2tOK2dYZTkrazFKQSt4RkxB?=
 =?utf-8?B?aUN3UU1rd1VVUEcxREEvR3hJUG5GN2lwVkRwY2V4bHNKM210Y09sRzVJQ3ly?=
 =?utf-8?B?QUpRclVqUXF0djJ4U2JxaktkYVlIRm5TSjJNZ015eUtyV2xSY2p1WWl3OGll?=
 =?utf-8?B?b0ZQTVFZeDJjMko4dS9aMjA0bXcxOUx6a24vWjBtc2E2VGJKWHdFUFhNQjNZ?=
 =?utf-8?B?aDEyYnd4WEc0YlMxRjBWUEVmem9pU0xpWkFxeWdadVozZUVNQ0tpWEdDb2Jx?=
 =?utf-8?B?R1NnZjV0V2c5TEpPUmc5dldMQXpZVCt2bW42MFg5eTdCK1IvaEU0dENwQzlM?=
 =?utf-8?B?VVRvSXc3RHo2RUNGNERzMloxaGRYUy9oNXYxR2FqbGF0SDhlbmUyL3VqKzcx?=
 =?utf-8?B?VGpyekZPYnpIc2p4WGQrZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2fdaa06-12d1-4f17-86cd-08d91bb94b8d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 18:01:30.1371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M2PqCuq45lTDtklmC4jKGlKUaHsSOlXdGy1FQShn2JOgah9wu4P31ZmN3tZEjZ9D5uHnCsNBoBUkd+tJq3+rnUz9hVc+FL2RN66Dsgxoa4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9990 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105200111
X-Proofpoint-GUID: 1KXgxUuL3iH8M8E4YHSkG0RDpCyoNhoc
X-Proofpoint-ORIG-GUID: 1KXgxUuL3iH8M8E4YHSkG0RDpCyoNhoc
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9990 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/20/21 9:57 AM, Jim Mattson wrote:
> On Thu, May 20, 2021 at 7:56 AM Sean Christopherson <seanjc@google.com> wrote:
>> On Wed, May 19, 2021, Krish Sadhukhan wrote:
>>> Add a new debugfs statistic to show how many VCPUs have run nested guests.
>>> This statistic considers only the first time a given VCPU successfully runs
>>> a nested guest.
>>>
>>> Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
>>> Suggested-by: Jim Mattson <jmattson@google.com>
>>> ---
>>>   arch/x86/include/asm/kvm_host.h | 1 +
>>>   arch/x86/kvm/svm/svm.c          | 5 ++++-
>>>   arch/x86/kvm/vmx/vmx.c          | 5 ++++-
>>>   arch/x86/kvm/x86.c              | 1 +
>>>   4 files changed, 10 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index cf8557b2b90f..a19fe2cfaa93 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -1138,6 +1138,7 @@ struct kvm_vm_stat {
>>>        ulong lpages;
>>>        ulong nx_lpage_splits;
>>>        ulong max_mmu_page_hash_collisions;
>>> +     ulong vcpus_ran_nested;
>>>   };
>>>
>>>   struct kvm_vcpu_stat {
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index 57c351640355..d1871c51411f 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -3876,8 +3876,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>>>                /* Track VMRUNs that have made past consistency checking */
>>>                if (svm->nested.nested_run_pending &&
>>>                    svm->vmcb->control.exit_code != SVM_EXIT_ERR &&
>>> -                 svm->vmcb->control.exit_code != SVM_EXIT_NPF)
>>> +                 svm->vmcb->control.exit_code != SVM_EXIT_NPF) {
>>> +                     if (!vcpu->stat.nested_runs)
>>> +                             ++vcpu->kvm->stat.vcpus_ran_nested;
>> Using a separate counter seems unnecessary, userspace can aggregate
>> vcpu->stat.nested_run itself to see how many vCPUs have done nested VM-Enter.
>>
>> Jim, were you thinking of something else?  Am I missing something?
> It was in the context of a proposed stat to indicate how many vCPUs
> are *currently* running nested guests that I said I'd rather just know
> how many vCPUs had *ever* run nested guests. I don't need a separate
> stat. Checking vcpu->stat.nested_run for non-zero values works fine
> for me.
I will fall back to my v1 idea then. That's at least useful if we want 
to create a time graph of VCPUs running nested guests.
