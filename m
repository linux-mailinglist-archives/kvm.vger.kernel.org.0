Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C36C1A049B
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 03:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgDGBmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 21:42:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40798 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgDGBmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 21:42:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0371d4L4188266;
        Tue, 7 Apr 2020 01:42:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6w6mwO1/F6AL9RA+XNpPVvkcKvpoMm1xGRYiUPW/0xY=;
 b=bnHRi3To2q1F9DR2+K3kOoD1UcE9DZUPVWF8/LPFEOtcCrJEInVGb2mrHUKBuZwyg0B7
 Td6lRAd3Pf9QcaDyL8UwV2zXPvS7Jdn+lgqtN2DSUdR+BmQQ1h2J7jVcyuc58KfUxNlX
 OxDz+RW3meW04DTYurQtVN6pCnWBUTMFvunT3rg5n2Cnm0mlCyEJVCtCs0lO1V5jt/I9
 mpcsD/Fl5iGyyzU6RJPEcQ4TRsFz0+fQfIN8hz24bH3KBBbJCMyVixLOswCX1rV41i4A
 JAEPnSy1bg6agqzIaDyzRwC4KAR2V1E9gQ/1b3FvGcv4vnwWg2Cu3Q+5WkMqnL6r3R8M Ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 306jvn203f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 01:42:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0371bMH5189352;
        Tue, 7 Apr 2020 01:42:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3073qegbt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 01:42:19 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0371gIux031568;
        Tue, 7 Apr 2020 01:42:18 GMT
Received: from localhost.localdomain (/10.159.229.84)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 18:42:18 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: gtests: add new test for
 vmread/vmwrite flags preservation
To:     Simon Smith <brigidsmith@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
References: <20200406225537.48082-1-brigidsmith@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <600aee64-18c4-8525-9ece-a791ca24c5b3@oracle.com>
Date:   Mon, 6 Apr 2020 18:42:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200406225537.48082-1-brigidsmith@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=848
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004070011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=2
 mlxlogscore=909 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 malwarescore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070011
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/6/20 3:55 PM, Simon Smith wrote:
> This commit adds new unit tests for commit a4d956b93904 ("KVM: nVMX:
> vmread should not set rflags to specify success in case of #PF")
>
> The two new tests force a vmread and a vmwrite on an unmapped
> address to cause a #PF and verify that the low byte of %rflags is
> preserved and that %rip is not advanced.  The cherry-pick fixed a
> bug in vmread, but we include a test for vmwrite as well for
> completeness.
>
> Before the aforementioned commit, the ALU flags would be incorrectly
> cleared and %rip would be advanced (for vmread).
>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Simon Smith <brigidsmith@google.com>
> ---
>   x86/vmx.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 121 insertions(+)
>
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 647ab49408876..e9235ec4fcad9 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -32,6 +32,7 @@
>   #include "processor.h"
>   #include "alloc_page.h"
>   #include "vm.h"
> +#include "vmalloc.h"
>   #include "desc.h"
>   #include "vmx.h"
>   #include "msr.h"
> @@ -368,6 +369,122 @@ static void test_vmwrite_vmread(void)
>   	free_page(vmcs);
>   }
>   
> +ulong finish_fault;
> +u8 sentinel;
> +bool handler_called;
> +static void pf_handler(struct ex_regs *regs)
> +{
> +	// check that RIP was not improperly advanced and that the
> +	// flags value was preserved.
> +	report("RIP has not been advanced!",
> +		regs->rip < finish_fault);
> +	report("The low byte of RFLAGS was preserved!",
> +		((u8)regs->rflags == ((sentinel | 2) & 0xd7)));
> +
> +	regs->rip = finish_fault;
> +	handler_called = true;
> +
> +}
> +
> +static void prep_flags_test_env(void **vpage, struct vmcs **vmcs, handler *old)
> +{
> +	// get an unbacked address that will cause a #PF
> +	*vpage = alloc_vpage();
> +
> +	// set up VMCS so we have something to read from
> +	*vmcs = alloc_page();
> +
> +	memset(*vmcs, 0, PAGE_SIZE);
> +	(*vmcs)->hdr.revision_id = basic.revision;
> +	assert(!vmcs_clear(*vmcs));
> +	assert(!make_vmcs_current(*vmcs));
> +
> +	*old = handle_exception(PF_VECTOR, &pf_handler);
> +}
> +
> +static void test_read_sentinel(void)
> +{
> +	void *vpage;
> +	struct vmcs *vmcs;
> +	handler old;
> +
> +	prep_flags_test_env(&vpage, &vmcs, &old);
> +
> +	// set the proper label
> +	extern char finish_read_fault;
> +
> +	finish_fault = (ulong)&finish_read_fault;
> +
> +	// execute the vmread instruction that will cause a #PF
> +	handler_called = false;
> +	asm volatile ("movb %[byte], %%ah\n\t"
> +		      "sahf\n\t"
> +		      "vmread %[enc], %[val]; finish_read_fault:"
> +		      : [val] "=m" (*(u64 *)vpage)
> +		      : [byte] "Krm" (sentinel),
> +		      [enc] "r" ((u64)GUEST_SEL_SS)
> +		      : "cc", "ah"
> +		      );
> +	report("The #PF handler was invoked", handler_called);
> +
> +	// restore old #PF handler
> +	handle_exception(PF_VECTOR, old);
> +}
> +
> +static void test_vmread_flags_touch(void)
> +{
> +	// set up the sentinel value in the flags register. we
> +	// choose these two values because they candy-stripe
> +	// the 5 flags that sahf sets.
> +	sentinel = 0x91;
> +	test_read_sentinel();
> +
> +	sentinel = 0x45;
> +	test_read_sentinel();
> +}
> +
> +static void test_write_sentinel(void)
> +{
> +	void *vpage;
> +	struct vmcs *vmcs;
> +	handler old;
> +
> +	prep_flags_test_env(&vpage, &vmcs, &old);
> +
> +	// set the proper label
> +	extern char finish_write_fault;
> +
> +	finish_fault = (ulong)&finish_write_fault;
> +
> +	// execute the vmwrite instruction that will cause a #PF
> +	handler_called = false;
> +	asm volatile ("movb %[byte], %%ah\n\t"
> +		      "sahf\n\t"
> +		      "vmwrite %[val], %[enc]; finish_write_fault:"
> +		      : [val] "=m" (*(u64 *)vpage)
> +		      : [byte] "Krm" (sentinel),
> +		      [enc] "r" ((u64)GUEST_SEL_SS)
> +		      : "cc", "ah"
> +		      );
> +	report("The #PF handler was invoked", handler_called);
> +
> +	// restore old #PF handler
> +	handle_exception(PF_VECTOR, old);
> +}
> +
> +static void test_vmwrite_flags_touch(void)
> +{
> +	// set up the sentinel value in the flags register. we
> +	// choose these two values because they candy-stripe
> +	// the 5 flags that sahf sets.
> +	sentinel = 0x91;
> +	test_write_sentinel();
> +
> +	sentinel = 0x45;
> +	test_write_sentinel();
> +}
> +
> +
>   static void test_vmcs_high(void)
>   {
>   	struct vmcs *vmcs = alloc_page();
> @@ -1994,6 +2111,10 @@ int main(int argc, const char *argv[])
>   		test_vmcs_lifecycle();
>   	if (test_wanted("test_vmx_caps", argv, argc))
>   		test_vmx_caps();
> +	if (test_wanted("test_vmread_flags_touch", argv, argc))
> +		test_vmread_flags_touch();
> +	if (test_wanted("test_vmwrite_flags_touch", argv, argc))
> +		test_vmwrite_flags_touch();
>   
>   	/* Balance vmxon from test_vmxon. */
>   	vmx_off();

Not related to your patch, but just thought of mentioning it here. I 
find the name 'handle_exception' odd, because we really don't handle an 
exception in there, we just set the handler passed in and return the old 
one. May be, we should call it set_exception_handler ?


Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
