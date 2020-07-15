Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FAD2217B5
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 00:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgGOWV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 18:21:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51686 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGOWV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 18:21:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMD1O1130204;
        Wed, 15 Jul 2020 22:21:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PPGLKgvoj5i7TapTA7OGRWy0LTz7k80lEkNnwexctfg=;
 b=PEYNHzPN1oyGbgmCyb4f7XWR4ios2XOWHrhDWF0IEyXDU7G2t/nTgZFxoNopLEVpGNAa
 bzuhSkaOahoadt9dMOjSfqRRFLlBKjwe2BkogHHCYmfHut6kc7utG2SNAMbU9QLVKYyA
 t+xSH+KURvjSBcnye9o/wYLKqi/NTlGv7XUuN5NIcFczl/DhiEUIyikYg1FWyeXOLOkN
 Zu3Yk4MRMey3Qhs/rMzKoFFAWENxbQxo4gYM+IkIKOTMydkSeWs0hbIy8AFj3uobeROS
 roeH+KjP9FIob0LQaTZNYCo1AazoYac6kUs+ALIc9NLwoB+9i8n8cZAVXaPhvslSWiWF 9g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3275cme1ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 22:21:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMChFf076322;
        Wed, 15 Jul 2020 22:21:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 327qc1ujr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 22:21:23 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FMLMR7007426;
        Wed, 15 Jul 2020 22:21:22 GMT
Received: from localhost.localdomain (/10.159.239.115)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 15:21:22 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
To:     Nadav Amit <namit@vmware.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20200713043908.39605-1-namit@vmware.com>
 <ce87fd51-8e27-e5ff-3a90-06cddbf47636@oracle.com>
 <CCEF21D4-57C3-4843-9443-BE46501FFE8C@vmware.com>
 <abe9138a-6c61-22e1-f0a6-fcd5d06ef3f1@oracle.com>
 <6CD095D7-EF7F-49C2-98EF-F72D019817B2@vmware.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <fe76d847-5106-bc09-e4cf-498fb51e5255@oracle.com>
Date:   Wed, 15 Jul 2020 15:21:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <6CD095D7-EF7F-49C2-98EF-F72D019817B2@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/13/20 4:30 PM, Nadav Amit wrote:
>> On Jul 13, 2020, at 4:17 PM, Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:
>>
>>
>> On 7/13/20 4:11 PM, Nadav Amit wrote:
>>>> On Jul 13, 2020, at 4:06 PM, Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:
>>>>
>>>>
>>>> On 7/12/20 9:39 PM, Nadav Amit wrote:
>>>>> The low CR3 bits are reserved but not MBZ according to tha APM. The
>>>>> tests should therefore not check that they cause failed VM-entry. Tests
>>>>> on bare-metal show they do not.
>>>>>
>>>>> Signed-off-by: Nadav Amit <namit@vmware.com>
>>>>> ---
>>>>>   x86/svm.h       |  4 +---
>>>>>   x86/svm_tests.c | 26 +-------------------------
>>>>>   2 files changed, 2 insertions(+), 28 deletions(-)
>>>>>
>>>>> diff --git a/x86/svm.h b/x86/svm.h
>>>>> index f8e7429..15e0f18 100644
>>>>> --- a/x86/svm.h
>>>>> +++ b/x86/svm.h
>>>>> @@ -325,9 +325,7 @@ struct __attribute__ ((__packed__)) vmcb {
>>>>>   #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
>>>>>     #define	SVM_CR0_RESERVED_MASK			0xffffffff00000000U
>>>>> -#define	SVM_CR3_LEGACY_RESERVED_MASK		0xfe7U
>>>>> -#define	SVM_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
>>>>> -#define	SVM_CR3_LONG_RESERVED_MASK		0xfff0000000000fe7U
>>>>> +#define	SVM_CR3_LONG_RESERVED_MASK		0xfff0000000000000U
>>>>>   #define	SVM_CR4_LEGACY_RESERVED_MASK		0xff88f000U
>>>>>   #define	SVM_CR4_RESERVED_MASK			0xffffffffff88f000U
>>>>>   #define	SVM_DR6_RESERVED_MASK			0xffffffffffff1ff0U
>>>>> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
>>>>> index 3b0d019..1908c7c 100644
>>>>> --- a/x86/svm_tests.c
>>>>> +++ b/x86/svm_tests.c
>>>>> @@ -2007,38 +2007,14 @@ static void test_cr3(void)
>>>>>   {
>>>>>   	/*
>>>>>   	 * CR3 MBZ bits based on different modes:
>>>>> -	 *   [2:0]		    - legacy PAE
>>>>> -	 *   [2:0], [11:5]	    - legacy non-PAE
>>>>> -	 *   [2:0], [11:5], [63:52] - long mode
>>>>> +	 *   [63:52] - long mode
>>>>>   	 */
>>>>>   	u64 cr3_saved = vmcb->save.cr3;
>>>>> -	u64 cr4_saved = vmcb->save.cr4;
>>>>> -	u64 cr4 = cr4_saved;
>>>>> -	u64 efer_saved = vmcb->save.efer;
>>>>> -	u64 efer = efer_saved;
>>>>>   -	efer &= ~EFER_LME;
>>>>> -	vmcb->save.efer = efer;
>>>>> -	cr4 |= X86_CR4_PAE;
>>>>> -	vmcb->save.cr4 = cr4;
>>>>> -	SVM_TEST_CR_RESERVED_BITS(0, 2, 1, 3, cr3_saved,
>>>>> -	    SVM_CR3_LEGACY_PAE_RESERVED_MASK);
>>>>> -
>>>>> -	cr4 = cr4_saved & ~X86_CR4_PAE;
>>>>> -	vmcb->save.cr4 = cr4;
>>>>> -	SVM_TEST_CR_RESERVED_BITS(0, 11, 1, 3, cr3_saved,
>>>>> -	    SVM_CR3_LEGACY_RESERVED_MASK);
>>>>> -
>>>>> -	cr4 |= X86_CR4_PAE;
>>>>> -	vmcb->save.cr4 = cr4;
>>>>> -	efer |= EFER_LME;
>>>>> -	vmcb->save.efer = efer;
>>>>>   	SVM_TEST_CR_RESERVED_BITS(0, 63, 1, 3, cr3_saved,
>>>>>   	    SVM_CR3_LONG_RESERVED_MASK);
>>>>>   -	vmcb->save.cr4 = cr4_saved;
>>>>>   	vmcb->save.cr3 = cr3_saved;
>>>>> -	vmcb->save.efer = efer_saved;
>>>>>   }
>>>>>     static void test_cr4(void)
>>>> APM says,
>>>>
>>>>      "Reserved Bits. Reserved fields should be cleared to 0 by software when writing CR3."
>>>>
>>>> If processor allows these bits to be left non-zero, "should be cleared to 0" means it's not mandatory then. I am wondering what this "should be" actually means :-) !
>>> I really tested it, so I guess we “should” not argue about it. ;-)
>> No, I am not arguing over your test results. :-)
>>> Anyhow, according to APM Figure 5-16 (“Control Register 3 (CR3)-Long Mode”),
>>> bits 52:63 are “reserved, MBZ” and others are just marked as “Reserved”. So
>>> it seems they are not the same.
>> I am just saying that the APM language "should be cleared to 0" is misleading if the processor doesn't enforce it.
> Just to ensure I am clear - I am not blaming you in any way. I also found
> the phrasing confusing.
>
> Having said that, if you (or anyone else) reintroduces “positive” tests, in
> which the VM CR3 is modified to ensure VM-entry succeeds when the reserved
> non-MBZ bits are set, please ensure the tests fails gracefully. The
> non-long-mode CR3 tests crashed since the VM page-tables were incompatible
> with the paging mode.
>
> In other words, instead of setting a VMMCALL instruction in the VM to trap
> immediately after entry, consider clearing the present-bits in the high
> levels of the NPT; or injecting some exception that would trigger exit
> during vectoring or something like that.
>
> P.S.: If it wasn’t clear, I am not going to fix KVM itself for some obvious
> reasons.
>
I think since the APM is not clear, re-adding any test that tests those 
bits, is like adding a test with "undefined behavior" to me.


Paolo, Should I send a KVM patch to remove checks for those non-MBZ 
reserved bits ?

