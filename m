Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7B885742B
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 00:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfFZWQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 18:16:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48546 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfFZWQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 18:16:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QME0wx082341;
        Wed, 26 Jun 2019 22:15:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=cWbz2yERuzz7UyNNkQxjWvKZgSB6D9mFQCdfznBADes=;
 b=2wKPq54QuaWIETN9EfI66+VKzbmirmb2bnsc3qoqh1jDHvOXR/xe4G4WslKiLF9uNlVt
 mlwlF4vLyEYLNhYqXbKQqETSbze6Ue/z81fIgfHKRqgTPJSPlxiLZ9JxZqHMCTqk/m7T
 wlc0Xg/xskLUWDuOznIXHA1FU0pPBpgTN0+/jW+usutm/KDxcRx++slsx8vnV1r1x7M3
 78mQdeZPFdNOfPrQ/OuN5FPbq/C/b8BPMmoaMaqYtWCQaNufYNpBCnA0CDm439BqsGQh
 ySotXtd7gyNJNntRTIQY2Wfms4ZQUCQFiiCjzd221RY0k7m2V7LK79MKDnq4HUIbiVzT jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t9cyqmtaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 22:15:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QMFSue062070;
        Wed, 26 Jun 2019 22:15:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tat7d2jg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 22:15:54 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QMFr9E023522;
        Wed, 26 Jun 2019 22:15:54 GMT
Received: from localhost.localdomain (/10.159.235.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 15:15:53 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: Remove assumptions on CR4.MCE
To:     Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>
References: <20190625120322.8483-1-nadav.amit@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <25acb1d2-41d1-9f55-965f-e6a00e0dcd2c@oracle.com>
Date:   Wed, 26 Jun 2019 15:15:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190625120322.8483-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260254
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260254
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/25/19 5:03 AM, Nadav Amit wrote:
> CR4.MCE might be set after boot. Remove the assertion that checks that
> it is clear. Change the test to toggle the bit instead of setting it.
>
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>   x86/vmx_tests.c | 29 +++++++++++++++--------------
>   1 file changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index b50d858..3731757 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -7096,8 +7096,11 @@ static int write_cr4_checking(unsigned long val)
>   
>   static void vmx_cr_load_test(void)
>   {
> +	unsigned long cr3, cr4, orig_cr3, orig_cr4;
>   	struct cpuid _cpuid = cpuid(1);
> -	unsigned long cr4 = read_cr4(), cr3 = read_cr3();
> +
> +	orig_cr4 = read_cr4();
> +	orig_cr3 = read_cr3();
>   
>   	if (!(_cpuid.c & X86_FEATURE_PCID)) {
>   		report_skip("PCID not detected");
> @@ -7108,12 +7111,11 @@ static void vmx_cr_load_test(void)
>   		return;
>   	}
>   
> -	TEST_ASSERT(!(cr4 & (X86_CR4_PCIDE | X86_CR4_MCE)));
> -	TEST_ASSERT(!(cr3 & X86_CR3_PCID_MASK));
> +	TEST_ASSERT(!(orig_cr3 & X86_CR3_PCID_MASK));
>   
>   	/* Enable PCID for L1. */
> -	cr4 |= X86_CR4_PCIDE;
> -	cr3 |= 0x1;
> +	cr4 = orig_cr4 | X86_CR4_PCIDE;
> +	cr3 = orig_cr3 | 0x1;
>   	TEST_ASSERT(!write_cr4_checking(cr4));
>   	write_cr3(cr3);
>   
> @@ -7126,17 +7128,16 @@ static void vmx_cr_load_test(void)
>   	 * No exception is expected.
>   	 *
>   	 * NB. KVM loads the last guest write to CR4 into CR4 read
> -	 *     shadow. In order to trigger an exit to KVM, we can set a
> -	 *     bit that was zero in the above CR4 write and is owned by
> -	 *     KVM. We choose to set CR4.MCE, which shall have no side
> -	 *     effect because normally no guest MCE (e.g., as the result
> -	 *     of bad memory) would happen during this test.
> +	 *     shadow. In order to trigger an exit to KVM, we can toggle a
> +	 *     bit that is owned by KVM. We choose to set CR4.MCE, which shall
> +	 *     have no side effect because normally no guest MCE (e.g., as the
> +	 *     result of bad memory) would happen during this test.
>   	 */
> -	TEST_ASSERT(!write_cr4_checking(cr4 | X86_CR4_MCE));
> +	TEST_ASSERT(!write_cr4_checking(cr4 ^ X86_CR4_MCE));
>   
> -	/* Cleanup L1 state: disable PCID. */
> -	write_cr3(cr3 & ~X86_CR3_PCID_MASK);
> -	TEST_ASSERT(!write_cr4_checking(cr4 & ~X86_CR4_PCIDE));
> +	/* Cleanup L1 state. */
> +	write_cr3(orig_cr3);
> +	TEST_ASSERT(!write_cr4_checking(orig_cr4));
>   }
>   
>   static void vmx_nm_test_guest(void)


Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

