Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D64242088
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 21:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgHKTsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 15:48:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46590 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgHKTsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 15:48:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07BJknRf173950;
        Tue, 11 Aug 2020 19:48:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HflSDS4hisU1eokb2bYcX4i0HqwS9nfoQkRuvMLIj+I=;
 b=mOYd4ClpFbv0FDjUiYa8wmDHPUlelXVCZtPGDC7opkkGhcslmO7Z0gjJFl6I3GexJ3HR
 hdUYGXfTEqez69SzZivmXKeTac2YgAFdyuYQK6345PdrrZTD8479XzWvp1I7JcAd+8Qe
 K/GMrlMMVaSgJqMPo/LgHauyj/OY8teRcKlIlZiA6UBZPtXMUzEEqCeTqbCoWIKJuD35
 zrY19yvmxHM0N/Oeqwfk23PMvaToLOGYdJ53ktDFRHF+4oQOxZ6z150QFbtGUb680dzT
 t3oKAznCnfBDnDEudR2E9KfnUNeS62aqbtwZ9rLg2xeeJUWaWK2SxzQBFCiGNRtSK5Lm Fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32sm0mptfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Aug 2020 19:48:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07BJlV3V030448;
        Tue, 11 Aug 2020 19:48:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32t5mpj8ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Aug 2020 19:48:19 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07BJmHv2032124;
        Tue, 11 Aug 2020 19:48:18 GMT
Received: from localhost.localdomain (/10.159.141.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Aug 2020 19:48:17 +0000
Subject: Re: [PATCH] KVM: nSVM: Test combinations of EFER.LME, CR0.PG,
 CR4.PAE, CR0.PE and CS register on VMRUN of nested guests
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
References: <20200810223927.82895-1-krish.sadhukhan@oracle.com>
 <CALMp9eT00_qO8NXnLjtMzHCUYOCV0pWQ2jWp4-EPu+Gc9XpNGg@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <8534bec9-df9d-fa44-8c09-b9730a83c16b@oracle.com>
Date:   Tue, 11 Aug 2020 12:48:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eT00_qO8NXnLjtMzHCUYOCV0pWQ2jWp4-EPu+Gc9XpNGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008110139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008110139
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/11/20 11:37 AM, Jim Mattson wrote:
> On Mon, Aug 10, 2020 at 3:40 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>> According to section "Canonicalization and Consistency Checks" in APM vol. 2
>> the following guest state combinations are illegal:
>>
>>          * EFER.LME and CR0.PG are both set and CR4.PAE is zero.
>>          * EFER.LME and CR0.PG are both non-zero and CR0.PE is zero.
>>          * EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>>   x86/svm_tests.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 44 insertions(+)
>>
>> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
>> index 1908c7c..43208fd 100644
>> --- a/x86/svm_tests.c
>> +++ b/x86/svm_tests.c
>> @@ -1962,7 +1962,51 @@ static void test_efer(void)
>>          SVM_TEST_REG_RESERVED_BITS(16, 63, 4, "EFER", vmcb->save.efer,
>>              efer_saved, SVM_EFER_RESERVED_MASK);
>>
>> +       /*
>> +        * EFER.LME and CR0.PG are both set and CR4.PAE is zero.
>> +        */
>> +       u64 cr0_saved = vmcb->save.cr0;
>> +       u64 cr0;
>> +       u64 cr4_saved = vmcb->save.cr4;
>> +       u64 cr4;
>> +
>> +       efer = efer_saved | EFER_LME;
>> +       vmcb->save.efer = efer;
>> +       cr0 = cr0_saved | X86_CR0_PG;
>> +       vmcb->save.cr0 = cr0;
>> +       cr4 = cr4_saved & ~X86_CR4_PAE;
>> +       vmcb->save.cr4 = cr4;
>> +       report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
>> +           "CR0.PG=1 (%lx) and CR4.PAE=0 (%lx)", efer, cr0, cr4);
> This seems adequate, but you have to assume that CR0.PE is set, or you
> could just be testing the second rule (below).
>
>> +       /*
>> +        * EFER.LME and CR0.PG are both set and CR0.PE is zero.
>> +        */
>> +       vmcb->save.cr4 = cr4_saved;
>> +       cr0 &= ~X86_CR0_PE;
>> +       vmcb->save.cr0 = cr0;
>> +       report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
>> +           "CR0.PG=1 and CR0.PE=0 (%lx)", efer, cr0);
> This too, seems adequate, but you have to assume that CR4.PAE is set,
> or you could just be testing the first rule (above).


I see what you mean. I am just trying to understand how extensive our 
explicit assumptions should be when testing a given APM rule on valid 
guest state. For example, should we also explicitly unset CS.L and CS.D 
bits (third rule below) ? Or should we also explicitly unset CR3 MBZ 
bits because CR3 is relevant when we are setting CR0.PG ?

>
>> +       /*
>> +        * EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero.
>> +        */
>> +       u32 cs_attrib_saved = vmcb->save.cs.attrib;
>> +       u32 cs_attrib;
>> +
>> +       cr4 = cr4_saved | X86_CR4_PAE;
> Or'ing in X86_CR4_PAE seems superfluous, since you have to assume that
> cr4_saved already has the bit set for the above test to be worthwhile.
>
>> +       vmcb->save.cr4 = cr4;
>> +       cs_attrib = cs_attrib_saved | SVM_SELECTOR_L_MASK |
>> +           SVM_SELECTOR_DB_MASK;
>> +       vmcb->save.cs.attrib = cs_attrib;
> At this point, the second rule still applies (EFER.LME and CR0.PG are
> both set and CR0.PE is zero), so this doesn't necessarily verify the
> third rule at all.


Sorry, I missed it somehow. Will fix it.

>
>> +       report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
>> +           "CR0.PG=1 (%lx), CR4.PAE=1 (%lx), CS.L=1 and CS.D=1 (%x)",
>> +           efer, cr0, cr4, cs_attrib);
>> +
>> +       vmcb->save.cr4 = cr4_saved;
>> +       vmcb->save.cs.attrib = cs_attrib_saved;
>>          vmcb->save.efer = efer_saved;
>> +       vmcb->save.cr0 = cr0_saved;
>>   }
>>
>>   static void test_cr0(void)
>> --
>> 2.18.4
>>
