Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CABD50E2DD
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 16:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242317AbiDYOVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 10:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiDYOVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 10:21:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DF41F610;
        Mon, 25 Apr 2022 07:18:25 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PCm0OB004740;
        Mon, 25 Apr 2022 14:18:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xFYQxtC0B7SQPiXLH83zoxvzJC20pJOVt28ZEpZyYpA=;
 b=omHtM9MGzhzTUvtRiHQBSNMMsNGZ1kmIN1r+7xXTAHDqnqt9HBNyP2M/wuB7MIza9e1W
 l22FqlAYaa8wUDCNPOe0p/9TCt0zVHiaDGfUQkwsCDbk5lW4w2bzqyrbY+FKXeSiHKEH
 Jt5Kk9saJM+WKu93uvQir0OP1YzicBqGkQD1zGbM+5t5QbWr85ITSNefvP4+WVKrNUj5
 rJlpUJZQVq+9RjD6thWsIaJ/DoQN9AqWGqpVBnrdVU8Dp+nn2PSCZAUR9SicL1XN6r6T
 CRW0zXfdAQQ93vfuZV1r3t9EnaMd/fSGl+UKbKnLuOpF72L5FgI4GdeBWFY5P5Yb2dsM xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fns00phey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Apr 2022 14:18:23 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23PE1SXp017501;
        Mon, 25 Apr 2022 14:18:22 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fns00phe6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Apr 2022 14:18:22 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23PEAVR8003972;
        Mon, 25 Apr 2022 14:18:21 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3fm938thaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Apr 2022 14:18:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23PEIHPF40108340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Apr 2022 14:18:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F91DAE051;
        Mon, 25 Apr 2022 14:18:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33554AE04D;
        Mon, 25 Apr 2022 14:18:17 +0000 (GMT)
Received: from [9.171.38.55] (unknown [9.171.38.55])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Apr 2022 14:18:17 +0000 (GMT)
Message-ID: <64fe2f40-4430-ba31-134f-c891d03bcf7c@linux.ibm.com>
Date:   Mon, 25 Apr 2022 16:18:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v4] s390x: Test effect of storage keys on
 some instructions
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220425084128.809134-1-scgl@linux.ibm.com>
 <20220425131623.2c855fcd@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220425131623.2c855fcd@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _gAucEgrxiRyi9PmWbiclZmO4yDyumE9
X-Proofpoint-ORIG-GUID: esmbFkllDkuh6Ecrij9u4R89aqChBJMU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_08,2022-04-25_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 spamscore=0 mlxscore=0 bulkscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204250062
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/25/22 13:16, Claudio Imbrenda wrote:
> On Mon, 25 Apr 2022 10:41:28 +0200
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

[...]

>> +static void test_set_prefix(void)
>> +{
>> +	char lowcore_tmp[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
> 
> perhaps it's cleaner to put this as a global (static) variable
> 
> also, please define LC_SIZE (2*PAGE_SIZE) and use that

I'll call that PREFIX_AREA_SIZE, otherwise it is confusing that that is
not the same as sizeof(struct lowcore).
> 
>> +	uint32_t *prefix_ptr = (uint32_t *)pagebuf;
>> +	uint32_t old_prefix;
>> +	pgd_t *root;
>> +
>> +	report_prefix_push("SET PREFIX");
>> +	root = (pgd_t *)(stctg(1) & PAGE_MASK);
>> +	old_prefix = get_prefix();
>> +	memcpy(lowcore_tmp, 0, PAGE_SIZE * 2);
>> +	assert(((uint64_t)&lowcore_tmp >> 31) == 0);
>> +	*prefix_ptr = (uint32_t)(uint64_t)&lowcore_tmp;
>> +
>> +	report_prefix_push("zero key");
>> +	set_prefix(old_prefix);
>> +	set_storage_key(prefix_ptr, 0x20, 0);
>> +	set_prefix(*prefix_ptr);
>> +	report(get_prefix() == *prefix_ptr, "set prefix");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("matching key");
>> +	set_prefix(old_prefix);
>> +	set_storage_key(pagebuf, 0x10, 0);
>> +	set_prefix_key_1(prefix_ptr);
>> +	report(get_prefix() == *prefix_ptr, "set prefix");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("mismatching key");
>> +
>> +	report_prefix_push("no fetch protection");
>> +	set_prefix(old_prefix);
>> +	set_storage_key(pagebuf, 0x20, 0);
>> +	set_prefix_key_1(prefix_ptr);
>> +	report(get_prefix() == *prefix_ptr, "set prefix");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("fetch protection");
>> +	set_prefix(old_prefix);
>> +	set_storage_key(pagebuf, 0x28, 0);
>> +	expect_pgm_int();
>> +	set_prefix_key_1(prefix_ptr);
>> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>> +	report(get_prefix() != *prefix_ptr, "did not set prefix");
> 
> why don't you check == old_prefix instead? that way you know noting has
> changed (also for all the other tests below where you do the same)

Yeah, that's better.

[...]
