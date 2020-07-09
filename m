Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C254A2194CC
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 02:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgGIABq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 20:01:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39704 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgGIABp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 20:01:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 068NuaTH087435;
        Thu, 9 Jul 2020 00:01:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2//J1amv76ayHC5QcLuMhpZjgJUSbqih8uPmiWOG3u4=;
 b=XP8k+Eusf1bfNL4n1YmM0jX6cvgBrFEdnn3SO0C0tTg3Wb4tTkcCQuUzyJBVnqHWrYim
 7St4d9JXEactilIMrFuS7Ujo2T035xSz8/SHo/uNXA1mrI7yTpE+9zUkHTbYIxls777k
 1PuGzmCbSHj6hJ5E3E4PMiNfryg1ut2WAf+yLvA9iAE9JxRYOa+h5Nlr9bH2mlTuEVJi
 Hja+F23o13khPZx1iJ415hVY43/aCbrUsGG1kz0WpY9iqwdzSQsFce66T25BoVspsArE
 /6qmiBdbaQYs4P0Fqf3mdGwkcLp0lU3+wL/Le3NpZop8oLMyOahPr7ENB+iC62UmTE30 1w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 325k349g67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 09 Jul 2020 00:01:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 068NwI6F137819;
        Thu, 9 Jul 2020 00:01:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 325k3y6gn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jul 2020 00:01:42 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06901fmQ004881;
        Thu, 9 Jul 2020 00:01:41 GMT
Received: from localhost.localdomain (/10.159.144.146)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Jul 2020 17:01:36 -0700
Subject: Re: [PATCH 3/3 v4] kvm-unit-tests: nSVM: Test that MBZ bits in CR3
 and CR4 are not set on vmrun of nested guests
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <1594168797-29444-1-git-send-email-krish.sadhukhan@oracle.com>
 <1594168797-29444-4-git-send-email-krish.sadhukhan@oracle.com>
 <80ff1de6-f8db-5a09-b67f-ee81937d0dc6@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <8e065692-e073-1ef6-9c0f-9190eb46d359@oracle.com>
Date:   Wed, 8 Jul 2020 17:01:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <80ff1de6-f8db-5a09-b67f-ee81937d0dc6@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9676 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007080144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9676 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1015 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007080144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/8/20 4:07 AM, Paolo Bonzini wrote:
> On 08/07/20 02:39, Krish Sadhukhan wrote:
>> +	SVM_TEST_CR_RESERVED_BITS(0, 2, 1, 3, cr3_saved,
>> +	    SVM_CR3_LEGACY_PAE_RESERVED_MASK);
>> +
>> +	cr4 = cr4_saved & ~X86_CR4_PAE;
>> +	vmcb->save.cr4 = cr4;
>> +	SVM_TEST_CR_RESERVED_BITS(0, 11, 2, 3, cr3_saved,
>> +	    SVM_CR3_LEGACY_RESERVED_MASK);
>> +
>> +	cr4 |= X86_CR4_PAE;
>> +	vmcb->save.cr4 = cr4;
>> +	efer |= EFER_LMA;
>> +	vmcb->save.efer = efer;
>> +	SVM_TEST_CR_RESERVED_BITS(0, 63, 2, 3, cr3_saved,
>> +	    SVM_CR3_LONG_RESERVED_MASK);
> The test is not covering *non*-reserved bits, so it doesn't catch that
> in both cases KVM is checking against long-mode bits.  Doing this would
> require setting up the VMCB for immediate VMEXIT (for example, injecting
> an event while the IDT limit is zero), so it can be done later.
>
> Instead, you need to set/clear EFER_LME.  Please be more careful to
> check that the test is covering what you expect.


Sorry, I wasn't aware that setting/unsetting EFER.LMA wouldn't work !

Another test case that I missed here is testing the reserved bits in 
CR3[11:0] in long-mode based on the setting of CR4.PCIDE.

>
> Also, the tests show
>
> PASS: Test CR3 2:0: 641001
> PASS: Test CR3 2:0: 2
> PASS: Test CR3 2:0: 4
> PASS: Test CR3 11:0: 1
> PASS: Test CR3 11:0: 4
> PASS: Test CR3 11:0: 40
> PASS: Test CR3 11:0: 100
> PASS: Test CR3 11:0: 400
> PASS: Test CR3 63:0: 1
> PASS: Test CR3 63:0: 4
> PASS: Test CR3 63:0: 40
> PASS: Test CR3 63:0: 100
> PASS: Test CR3 63:0: 400
> PASS: Test CR3 63:0: 10000000000000
> PASS: Test CR3 63:0: 40000000000000
> PASS: Test CR3 63:0: 100000000000000
> PASS: Test CR3 63:0: 400000000000000
> PASS: Test CR3 63:0: 1000000000000000
> PASS: Test CR3 63:0: 4000000000000000
> PASS: Test CR4 31:12: 0
> PASS: Test CR4 31:12: 0
>
> and then exits.  There is an issue with compiler optimization for which
> I've sent a patch, but even after fixing it the premature exit is a
> problem: it is caused by a problem in __cr4_reserved_bits and a typo in
> the tests:
>
> diff --git a/x86/svm.h b/x86/svm.h
> index f6b9a31..58c9069 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -328,8 +328,8 @@ struct __attribute__ ((__packed__)) vmcb {
>   #define	SVM_CR3_LEGACY_RESERVED_MASK		0xfe7U
>   #define	SVM_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
>   #define	SVM_CR3_LONG_RESERVED_MASK		0xfff0000000000fe7U
> -#define	SVM_CR4_LEGACY_RESERVED_MASK		0xffbaf000U
> -#define	SVM_CR4_RESERVED_MASK			0xffffffffffbaf000U
> +#define	SVM_CR4_LEGACY_RESERVED_MASK		0xffcaf000U
> +#define	SVM_CR4_RESERVED_MASK			0xffffffffffcaf000U
>   #define	SVM_DR6_RESERVED_MASK			0xffffffffffff1ff0U
>   #define	SVM_DR7_RESERVED_MASK			0xffffffff0000cc00U
>   #define	SVM_EFER_RESERVED_MASK			0xffffffffffff0200U
>
> (Also, this kind of problem is made harder to notice by only testing
> even bits, which may make sense for high order bits, but certainly not
> for low-order ones).
>
> All in all, fixing this series has taken me almost 2 hours.  Since I have
> done the work I'm queuing


Sorry to hear it caused so many issues ! Thanks for looking into it !

>   but, but I wonder: the compiler optimization
> issue could depend on register allocation, but did all of these issues
> really happen only on my machine?


Just as a reference,  I compiled it using gcc 4.8.5 and ran it on an AMD 
EPYC that was running kernel 5.8.0-rc4+. Surprisingly, all tests passed:

PASS: Test CR3 2:0: 641001
PASS: Test CR3 2:0: 641002
PASS: Test CR3 2:0: 641004
PASS: Test CR3 11:0: 641001
PASS: Test CR3 11:0: 641004
PASS: Test CR3 11:0: 641040
PASS: Test CR3 11:0: 641100
PASS: Test CR3 11:0: 641400
PASS: Test CR3 63:0: 641001
PASS: Test CR3 63:0: 641004
PASS: Test CR3 63:0: 641040
PASS: Test CR3 63:0: 641100
PASS: Test CR3 63:0: 641400
PASS: Test CR3 63:0: 10000000641000
PASS: Test CR3 63:0: 40000000641000
PASS: Test CR3 63:0: 100000000641000
PASS: Test CR3 63:0: 400000000641000
PASS: Test CR3 63:0: 1000000000641000
PASS: Test CR3 63:0: 4000000000641000
PASS: Test CR4 31:12: 1000
PASS: Test CR4 31:12: 4000
PASS: Test CR4 31:12: 100000
PASS: Test CR4 31:12: 1000000
PASS: Test CR4 31:12: 4000000
PASS: Test CR4 31:12: 10000000
PASS: Test CR4 31:12: 40000000
PASS: Test CR4 31:12: 1000
PASS: Test CR4 31:12: 4000
PASS: Test CR4 31:12: 100000
PASS: Test CR4 31:12: 1000000
PASS: Test CR4 31:12: 4000000
PASS: Test CR4 31:12: 10000000
PASS: Test CR4 31:12: 40000000
PASS: Test CR4 63:32: 100000000
PASS: Test CR4 63:32: 1000000000
PASS: Test CR4 63:32: 10000000000
PASS: Test CR4 63:32: 100000000000
PASS: Test CR4 63:32: 1000000000000
PASS: Test CR4 63:32: 10000000000000
PASS: Test CR4 63:32: 100000000000000
PASS: Test CR4 63:32: 1000000000000000

>
> Paolo
>
