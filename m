Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C22D4961E
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 01:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfFQXzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 19:55:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51464 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfFQXzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 19:55:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HNn5Aw116319;
        Mon, 17 Jun 2019 23:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=b5UmgOgmbq0t5JzEVlEwZn8Sp4XAFw8h9rSLeUbgz50=;
 b=OmZJqM7KX2IIzN3ZIcX5gn3SGVRX0q15YwDmUPa2i/0IOOo/I0hKI+sxfEFbRzyf2t20
 sZbZeUXd58GTOpMiW6bjKtiErFEwZB+S+FsrUHbiQYNEUu5CYj1U1tNcGV1JHpC8mK8F
 tTCDmADuN2F8PIsK4NlgZcMAfy+A1pINhEQT6bvTeY1EvZ26soo6AuZFlR6azlHAAOlu
 ve2PPNHMcAC64fSeJ+yt/kU9/cPFglvi3ZihknqXNzkPFxgvMEH0t8CzuEEVmS2JcUPj
 Jfwa4dCA03mVfCVhJXa64Vc30uc4J9WbG5snXWfIlPtYZMpTe/5EFUdI+apisWe2tRFc lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t4rmp15td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 23:54:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HNqRq8171961;
        Mon, 17 Jun 2019 23:52:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2t5mgbmsu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 23:52:55 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5HNqt23010766;
        Mon, 17 Jun 2019 23:52:55 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Jun 2019 16:52:54 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Mask undefined bits in exit
 qualifications
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20190503174919.13846-1-nadav.amit@gmail.com>
 <A9500030-816E-49F7-84C7-6176C722C2B0@gmail.com>
 <720b1ba2-11aa-6baf-9f21-aa3e1e324afa@oracle.com>
 <09CF02B6-D229-479C-A3A2-56D50E030BF9@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <0f4e6b3c-86e5-a6a1-2cfa-a8792137636c@oracle.com>
Date:   Mon, 17 Jun 2019 16:52:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <09CF02B6-D229-479C-A3A2-56D50E030BF9@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906170206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906170206
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/17/2019 03:46 PM, Nadav Amit wrote:
>> On Jun 17, 2019, at 3:22 PM, Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:
>>
>>
>>
>> On 06/17/2019 12:52 PM, Nadav Amit wrote:
>>>> On May 3, 2019, at 10:49 AM, nadav.amit@gmail.com wrote:
>>>>
>>>> From: Nadav Amit <nadav.amit@gmail.com>
>>>>
>>>> On EPT violation, the exit qualifications may have some undefined bits.
>>>>
>>>> Bit 6 is undefined if "mode-based execute control" is 0.
>>>>
>>>> Bits 9-11 are undefined unless the processor supports advanced VM-exit
>>>> information for EPT violations.
>>>>
>>>> Right now on KVM these bits are always undefined inside the VM (i.e., in
>>>> an emulated VM-exit). Mask these bits to avoid potential false
>>>> indication of failures.
>>>>
>>>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>>>> ---
>>>> x86/vmx.h       | 20 ++++++++++++--------
>>>> x86/vmx_tests.c |  4 ++++
>>>> 2 files changed, 16 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/x86/vmx.h b/x86/vmx.h
>>>> index cc377ef..5053d6f 100644
>>>> --- a/x86/vmx.h
>>>> +++ b/x86/vmx.h
>>>> @@ -603,16 +603,20 @@ enum vm_instruction_error_number {
>>>> #define EPT_ADDR_MASK		GENMASK_ULL(51, 12)
>>>> #define PAGE_MASK_2M		(~(PAGE_SIZE_2M-1))
>>>>
>>>> -#define EPT_VLT_RD		1
>>>> -#define EPT_VLT_WR		(1 << 1)
>>>> -#define EPT_VLT_FETCH		(1 << 2)
>>>> -#define EPT_VLT_PERM_RD		(1 << 3)
>>>> -#define EPT_VLT_PERM_WR		(1 << 4)
>>>> -#define EPT_VLT_PERM_EX		(1 << 5)
>>>> +#define EPT_VLT_RD		(1ull << 0)
>>>> +#define EPT_VLT_WR		(1ull << 1)
>>>> +#define EPT_VLT_FETCH		(1ull << 2)
>>>> +#define EPT_VLT_PERM_RD		(1ull << 3)
>>>> +#define EPT_VLT_PERM_WR		(1ull << 4)
>>>> +#define EPT_VLT_PERM_EX		(1ull << 5)
>>>> +#define EPT_VLT_PERM_USER_EX	(1ull << 6)
>>>> #define EPT_VLT_PERMS		(EPT_VLT_PERM_RD | EPT_VLT_PERM_WR | \
>>>> 				 EPT_VLT_PERM_EX)
>>>> -#define EPT_VLT_LADDR_VLD	(1 << 7)
>>>> -#define EPT_VLT_PADDR		(1 << 8)
>>>> +#define EPT_VLT_LADDR_VLD	(1ull << 7)
>>>> +#define EPT_VLT_PADDR		(1ull << 8)
>>>> +#define EPT_VLT_GUEST_USER	(1ull << 9)
>>>> +#define EPT_VLT_GUEST_WR	(1ull << 10)
>> This one should be named EPT_VLT_GUEST_RW, assuming you are naming them
>> according to the 1-setting of the bits.
> Whatever you wish (unless someone else has different preference).
>
>>>> +#define EPT_VLT_GUEST_EX	(1ull << 11)
>>>>
>>>> #define MAGIC_VAL_1		0x12345678ul
>>>> #define MAGIC_VAL_2		0x87654321ul
>>>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>>>> index c52ebc6..b4129e1 100644
>>>> --- a/x86/vmx_tests.c
>>>> +++ b/x86/vmx_tests.c
>>>> @@ -2365,6 +2365,10 @@ static void do_ept_violation(bool leaf, enum ept_access_op op,
>>>>
>>>> 	qual = vmcs_read(EXI_QUALIFICATION);
>>>>
>>>> +	/* Mask undefined bits (which may later be defined in certain cases). */
>>>> +	qual &= ~(EPT_VLT_GUEST_USER | EPT_VLT_GUEST_WR | EPT_VLT_GUEST_EX |
>>>> +		 EPT_VLT_PERM_USER_EX);
>>>> +
>> The "DIAGNOSE" macro doesn't check any of these bits, so this masking
>> seems redundant.
> The DIAGNOSE macro is not the one who causes errors. It’s the:
>
>    TEST_EXPECT_EQ(expected_qual, qual);
>
> That comes right after the call to diagnose_ept_violation_qual().

Sorry, I missed that !

>
>> Also, don't we need to check for the relevant conditions before masking
>> the bits ? For example, EPT_VLT_PERM_USER_EX is dependent on "mode-based
>> execute control" VM-execution control" and the other ones depend on bit 7
>> and 8 of the Exit Qualification field.
> The tests right now do not “emulate” these bits, so the expected
> qualification would never have EPT_VLT_PERM_USER_EX (for instance) set. Once
> someone implements tests for these bits, he would need to change the
> masking.
>

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
