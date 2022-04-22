Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4AC50B724
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 14:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447201AbiDVMXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 08:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447433AbiDVMWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 08:22:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BAA56757;
        Fri, 22 Apr 2022 05:19:47 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23MAZ8Ae025902;
        Fri, 22 Apr 2022 12:19:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=VtvAgeBu5sGfSik79lehW9rX56+WEAzb1ZQwId0LZYY=;
 b=LIqgyo0XD3kuU+Xe2KmBBraa5oc9k3fDmFXYcR7L0sbIJdYRb9x1rDPJUvCod1c3lhrC
 t7AoFHdWeH531wRQXzVQkoPx6JF8w7TD80Eoo5jNMmeRTSG+laxb7ykX7+hHc8HmYcL2
 SijHPHVjMxSlDnrNSqo6zIkqub8IiNlgv6csFkCFu8XrJFx6VqDYSlorkTSvUm9Ek9i9
 PylDzYnfaR6wn/vq5t9OHSHaMukED1LY/OqhpQff1niaXPZ2s8tEIIR3ivF1EsIBkzq6
 8GTSpuNpOkaCvJFzj4zTjvptMIwL832CWX+sHoGPxSRzbwgxJu7QufKH7iHn/IwQFk/u xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fkm5q13v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 12:19:46 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23MBlhMv029475;
        Fri, 22 Apr 2022 12:19:46 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fkm5q13uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 12:19:46 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23MCFduK021372;
        Fri, 22 Apr 2022 12:19:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ffne99bag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 12:19:43 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23MCJehI35848486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 12:19:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F62442045;
        Fri, 22 Apr 2022 12:19:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E393F4204B;
        Fri, 22 Apr 2022 12:19:39 +0000 (GMT)
Received: from [9.171.18.128] (unknown [9.171.18.128])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Apr 2022 12:19:39 +0000 (GMT)
Message-ID: <f2b8b140-7f84-8547-8dad-6d23a3571da7@linux.ibm.com>
Date:   Fri, 22 Apr 2022 14:19:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v3] s390x: Test effect of storage keys on
 some instructions
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220421090421.2425142-1-scgl@linux.ibm.com>
 <20220422135625.6e46e2e7@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220422135625.6e46e2e7@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 87h7_FfZ4ls7WOBKyFw2yaFYqGrVER9M
X-Proofpoint-GUID: -Pw_KLH_EVp2jfwxVLrJE53Pr2Jozw3D
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_03,2022-04-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 clxscore=1015 bulkscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204220053
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/22/22 13:56, Claudio Imbrenda wrote:
> On Thu, 21 Apr 2022 11:04:21 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> Some instructions are emulated by KVM. Test that KVM correctly emulates
>> storage key checking for two of those instructions (STORE CPU ADDRESS,
>> SET PREFIX).
>> Test success and error conditions, including coverage of storage and
>> fetch protection override.
>> Also add test for TEST PROTECTION, even if that instruction will not be
>> emulated by KVM under normal conditions.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>> v2 -> v3:
>>  * fix asm for SET PREFIX zero key test: make input
>>  * implement Thomas' suggestions:
>>    https://lore.kernel.org/kvm/f050da01-4d50-5da5-7f08-6da30f5dbbbe@redhat.com/
>>
>> v1 -> v2:
>>  * use install_page instead of manual page table entry manipulation
>>  * check that no store occurred if none is expected
>>  * try to check that no fetch occured if not expected, although in
>>    practice a fetch would probably cause the test to crash
>>  * reset storage key to 0 after test
>>

[...]

>> +static void test_set_prefix(void)
>> +{
>> +	uint32_t *out = (uint32_t *)pagebuf;
>> +	pgd_t *root;
>> +
>> +	report_prefix_push("SET PREFIX");
>> +	root = (pgd_t *)(stctg(1) & PAGE_MASK);
>> +
>> +	asm volatile("stpx	%0" : "=Q"(*out));
>> +
>> +	report_prefix_push("zero key");
>> +	set_storage_key(pagebuf, 0x20, 0);
>> +	asm volatile("spx	%0" :: "Q" (*out));
> 
> so you are changing the prefix to... the old prefix (so nothing
> changes). how do you know that something happened at all?

Basically, I'm only checking that no exception occurs, which would
crash the test. 
> 
> (see my longer comment below)
> 
>> +	report_pass("no exception");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("matching key");
>> +	set_storage_key(pagebuf, 0x10, 0);
>> +	set_prefix_key_1(out);
>> +	report_pass("no exception");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("mismatching key, no fetch protection");
>> +	set_storage_key(pagebuf, 0x20, 0);
>> +	set_prefix_key_1(out);
>> +	report_pass("no exception");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("mismatching key, fetch protection");
>> +	set_storage_key(pagebuf, 0x28, 0);
>> +	expect_pgm_int();
>> +	*out = 0xdeadbeef;
> 
> so here you are trying to set 0xdeadbeef as prefix, right?

In the sense that I'm executing SPX with that as operand, yes, but
the hypervisor is not supposed to ever read that value, so the
content should not matter.

> which would fail for other reasons I guess, since that would be outside
> memory (unless otherwise specified, kvm unit tests run with 128M of ram)
> 
>> +	set_prefix_key_1(out);
>> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);

This ^ is the important check, the two lines below indeed questionable,
I considered just dropping them.

>> +	asm volatile("stpx	%0" : "=Q"(*out));
>> +	report(*out != 0xdeadbeef, "no fetch occurred");
> 
> and here you check that the prefix has not changed to that "wrong
> value", which would be impossible anyway because it would be outside of
> memory. moreover the address you give is not even in the lower 2G, so
> in case the address has been changed, it would not match your magic
> value anyway.
> 
> for this (and the following) tests, I propose the following:
> 
> add a new
> char tmplowcore[2 * PAGE_SIZE] __attribute((aligned(2*PAGE_SIZE)));
> 
> initialize it properly (memcpy the actual lowcore into it), and use
> that address for SPX. this way if SPX does not fail, at least you would
> have a valid lowcore. and at that point you can check against that
> address instead of your magic

I'll try it out, maybe it will make tcg not crash and just fail the test.

[...]

