Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83CC84951F
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 00:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfFQWXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 18:23:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60616 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbfFQWXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 18:23:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HML59B153781;
        Mon, 17 Jun 2019 22:23:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=14ePqxfipwL/tsIaiw3rK/EDL+lbdm4jbslQBd7LCUw=;
 b=p8zM9+n08ITK5rEFDxeF6ysfPhOzpXdasSuJUmS4OkY9oCvwHt1AW3yoQBqR5Khj+5gq
 Ud+Qy880PHiIQfW1Z3BCBoL0LiFPyI0SuviN91/KganwyxPx3GCJTko7W6r58Dv1sAq+
 DpXrm0zRCr62vMlyrm8bF5lSJSE4iePem3834GfhDOv9cymnfaRNgGSJCd0HNhF96WaW
 8Y0l2s078wFPSkVqlrgrfLosNzukmrzAA+QhHwzcqVSH4Bgsa4tLU4m2MFn6KIezR6tC
 82zfP7RwDh7OXvKf8uU5EoVjOqOExzeQ2xMTD8DUbJ3wv8SbJi1ba0doBnXbFQ0NzBiv bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t4saq8wu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 22:23:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HMMwkQ004721;
        Mon, 17 Jun 2019 22:23:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t59gdfwg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 22:23:00 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5HMMxK0017075;
        Mon, 17 Jun 2019 22:22:59 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Jun 2019 15:22:59 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Mask undefined bits in exit
 qualifications
To:     Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190503174919.13846-1-nadav.amit@gmail.com>
 <A9500030-816E-49F7-84C7-6176C722C2B0@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <720b1ba2-11aa-6baf-9f21-aa3e1e324afa@oracle.com>
Date:   Mon, 17 Jun 2019 15:22:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <A9500030-816E-49F7-84C7-6176C722C2B0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906170193
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906170193
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/17/2019 12:52 PM, Nadav Amit wrote:
>> On May 3, 2019, at 10:49 AM, nadav.amit@gmail.com wrote:
>>
>> From: Nadav Amit <nadav.amit@gmail.com>
>>
>> On EPT violation, the exit qualifications may have some undefined bits.
>>
>> Bit 6 is undefined if "mode-based execute control" is 0.
>>
>> Bits 9-11 are undefined unless the processor supports advanced VM-exit
>> information for EPT violations.
>>
>> Right now on KVM these bits are always undefined inside the VM (i.e., in
>> an emulated VM-exit). Mask these bits to avoid potential false
>> indication of failures.
>>
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>> x86/vmx.h       | 20 ++++++++++++--------
>> x86/vmx_tests.c |  4 ++++
>> 2 files changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/x86/vmx.h b/x86/vmx.h
>> index cc377ef..5053d6f 100644
>> --- a/x86/vmx.h
>> +++ b/x86/vmx.h
>> @@ -603,16 +603,20 @@ enum vm_instruction_error_number {
>> #define EPT_ADDR_MASK		GENMASK_ULL(51, 12)
>> #define PAGE_MASK_2M		(~(PAGE_SIZE_2M-1))
>>
>> -#define EPT_VLT_RD		1
>> -#define EPT_VLT_WR		(1 << 1)
>> -#define EPT_VLT_FETCH		(1 << 2)
>> -#define EPT_VLT_PERM_RD		(1 << 3)
>> -#define EPT_VLT_PERM_WR		(1 << 4)
>> -#define EPT_VLT_PERM_EX		(1 << 5)
>> +#define EPT_VLT_RD		(1ull << 0)
>> +#define EPT_VLT_WR		(1ull << 1)
>> +#define EPT_VLT_FETCH		(1ull << 2)
>> +#define EPT_VLT_PERM_RD		(1ull << 3)
>> +#define EPT_VLT_PERM_WR		(1ull << 4)
>> +#define EPT_VLT_PERM_EX		(1ull << 5)
>> +#define EPT_VLT_PERM_USER_EX	(1ull << 6)
>> #define EPT_VLT_PERMS		(EPT_VLT_PERM_RD | EPT_VLT_PERM_WR | \
>> 				 EPT_VLT_PERM_EX)
>> -#define EPT_VLT_LADDR_VLD	(1 << 7)
>> -#define EPT_VLT_PADDR		(1 << 8)
>> +#define EPT_VLT_LADDR_VLD	(1ull << 7)
>> +#define EPT_VLT_PADDR		(1ull << 8)
>> +#define EPT_VLT_GUEST_USER	(1ull << 9)
>> +#define EPT_VLT_GUEST_WR	(1ull << 10)

This one should be named EPT_VLT_GUEST_RW,  assuming you are naming them 
according to the 1-setting of the bits.

>> +#define EPT_VLT_GUEST_EX	(1ull << 11)
>>
>> #define MAGIC_VAL_1		0x12345678ul
>> #define MAGIC_VAL_2		0x87654321ul
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index c52ebc6..b4129e1 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -2365,6 +2365,10 @@ static void do_ept_violation(bool leaf, enum ept_access_op op,
>>
>> 	qual = vmcs_read(EXI_QUALIFICATION);
>>
>> +	/* Mask undefined bits (which may later be defined in certain cases). */
>> +	qual &= ~(EPT_VLT_GUEST_USER | EPT_VLT_GUEST_WR | EPT_VLT_GUEST_EX |
>> +		 EPT_VLT_PERM_USER_EX);
>> +

The "DIAGNOSE" macro doesn't check any of these bits, so this masking 
seems redundant.

Also, don't we need to check for the relevant conditions before masking 
the bits ? For example, EPT_VLT_PERM_USER_EX is dependent on "mode-based 
execute control" VM-execution control"  and the other ones depend on bit 
7 and 8 of the Exit Qualification field.

>> 	diagnose_ept_violation_qual(expected_qual, qual);
>> 	TEST_EXPECT_EQ(expected_qual, qual);
>>
>> -- 
>> 2.17.1
> Ping.
>

