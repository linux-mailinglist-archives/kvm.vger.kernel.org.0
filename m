Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E87651FF15
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 16:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbiEIOLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 10:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236879AbiEIOL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 10:11:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C756219F66;
        Mon,  9 May 2022 07:07:33 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249DOPEk014341;
        Mon, 9 May 2022 14:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KNV586YhxorVuL/oyck7CFaNNYyFVhABaxGh67qbDVg=;
 b=Pw52bvi/x7W0TFAZqvtdjJkG5vgmYgZftXxfBS8Fr++IoZ61HmzfvfQpec5VALf3UBuz
 P3KN9RAcuc8Og+aPtApjMjp5xmyAca+GCAHL+5IRScJpGD8iKDs4WwBf+gMC+vFgMu4m
 pJ4I+nzqX+bLHGoqQJh7MXsDgKidm3486+PGet4cBxYvwLtPgJa1BSrUPYdqYp+XgPa2
 uaj+9x80YHE4uAtf03J8IKwCCjs+HQv2jwJCu3sNrdwM1FlFEukf/kZGNK5xSG3WNFTk
 kLvHciWlziCdrqSoZ1d9XG/wINq9zQkjSYZv0jbFV0Yx9SgGENWVd41kJI7AHXrBVv1B Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy3thgx3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 14:07:32 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 249DkR9T011447;
        Mon, 9 May 2022 14:07:31 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy3thgx39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 14:07:31 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 249E708I003315;
        Mon, 9 May 2022 14:07:30 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3fwgd8t1tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 14:07:30 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 249E7Qd229950348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 May 2022 14:07:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC72CA4060;
        Mon,  9 May 2022 14:07:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94C59A405C;
        Mon,  9 May 2022 14:07:26 +0000 (GMT)
Received: from [9.171.38.150] (unknown [9.171.38.150])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 May 2022 14:07:26 +0000 (GMT)
Message-ID: <9635e559-5c2c-30f4-ab19-aef28ba24ac0@linux.ibm.com>
Date:   Mon, 9 May 2022 16:07:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: Test effect of storage keys on
 some more instructions
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220505124656.1954092-1-scgl@linux.ibm.com>
 <20220505124656.1954092-4-scgl@linux.ibm.com>
 <20220506185227.165c7d86@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220506185227.165c7d86@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ajATeLVwAir5PQ--_fZUYwbvzTXwjfaK
X-Proofpoint-ORIG-GUID: -u6wDI2bLbHO6_kkGsEE4DIwqeroX5wx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_03,2022-05-09_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205090077
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/22 18:52, Claudio Imbrenda wrote:
> On Thu,  5 May 2022 14:46:56 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> Test correctness of some instructions handled by user space instead of
>> KVM with regards to storage keys.
>> Test success and error conditions, including coverage of storage and
>> fetch protection override.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>  s390x/skey.c        | 277 ++++++++++++++++++++++++++++++++++++++++++++
>>  s390x/unittests.cfg |   1 +
>>  2 files changed, 278 insertions(+)
>>
>> diff --git a/s390x/skey.c b/s390x/skey.c
>> index 56bf5f45..d50470a8 100644
>> --- a/s390x/skey.c
>> +++ b/s390x/skey.c
>> @@ -12,6 +12,7 @@
>>  #include <asm/asm-offsets.h>
>>  #include <asm/interrupt.h>
>>  #include <vmalloc.h>
>> +#include <css.h>
>>  #include <asm/page.h>
>>  #include <asm/facility.h>
>>  #include <asm/mem.h>
>> @@ -284,6 +285,114 @@ static void test_store_cpu_address(void)
>>  	report_prefix_pop();
>>  }
>>  
>> +/*
>> + * Perform CHANNEL SUBSYSTEM CALL (CHSC)  instruction while temporarily executing
>> + * with access key 1.
>> + */
>> +static unsigned int channel_subsystem_call_key_1(void *communication_block)
> 
> this function name is very long (maybe chsc_with_key_1 instead?)

It's because of consistency with set_prefix_key_1 where I spelled out the instruction
name too. Granted the name of chsc is longer.
When in doubt I go for what seems more readable/contains more information.
> 
>> +{
>> +	uint32_t program_mask;
>> +
>> +	asm volatile (
>> +		"spka	0x10\n\t"
>> +		".insn	rre,0xb25f0000,%[communication_block],0\n\t"
>> +		"spka	0\n\t"
>> +		"ipm	%[program_mask]\n"
>> +		: [program_mask] "=d" (program_mask)
>> +		: [communication_block] "d" (communication_block)
>> +		: "memory"
>> +	);
>> +	return program_mask >> 28;
>> +}
>> +
>> +static void init_store_channel_subsystem_characteristics(uint16_t *communication_block)
> 
> same here (init_comm_block?)

Since we're only performing one kind of operation in this test, that is fine,
but I'll add a comment saying how we initialize the communication block then.
> 
>> +{
>> +	memset(communication_block, 0, PAGE_SIZE);
>> +	communication_block[0] = 0x10;
>> +	communication_block[1] = 0x10;
>> +	communication_block[9] = 0;
>> +}
>> +
>> +static void test_channel_subsystem_call(void)
>> +{
>> +	static const char request_name[] = "Store channel-subsystem-characteristics";
> 
> so this "request_name" is for when CHSC succeeds? why not just
> "Success" then?

That's the operation being performed. So maybe I should change it to
msg[] = "Performed store channel-subsystem-characteristics" ?
> 
>> +	uint16_t *communication_block = (uint16_t *)&pagebuf;
> 
> long name (consider comm_block, or even cb)
> 
>> +	unsigned int cc;
>> +
>> +	report_prefix_push("CHANNEL SUBSYSTEM CALL");
>> +
>> +	report_prefix_push("zero key");
>> +	init_store_channel_subsystem_characteristics(communication_block);
> 
> see what I mean when I say that the names are too long? ^

Fits in 80 columns ;-)
> 
>> +	set_storage_key(communication_block, 0x10, 0);
>> +	asm volatile (
>> +		".insn	rre,0xb25f0000,%[communication_block],0\n\t"
>> +		"ipm	%[cc]\n"
>> +		: [cc] "=d" (cc)
>> +		: [communication_block] "d" (communication_block)
>> +		: "memory"
>> +	);
>> +	cc = cc >> 28;
>> +	report(cc == 0 && communication_block[9], request_name);
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("matching key");
>> +	init_store_channel_subsystem_characteristics(communication_block);
>> +	set_storage_key(communication_block, 0x10, 0);
> 
> you just set the storage key in the previous test, and you did not set
> it back to 0, why do you need to set it again?

It's not necessary, but I want the tests to be independent from each other,
so you can remove/reorder/add ones without having to think.
> 
>> +	cc = channel_subsystem_call_key_1(communication_block);
>> +	report(cc == 0 && communication_block[9], request_name);
>> +	report_prefix_pop();
>> +

[...]

>> +
>> +	cc = stsch(test_device_sid, schib);
>> +	if (cc) {
>> +		report_fail("could not store SCHIB");
>> +		return;
>> +	}
>> +
>> +	report_prefix_push("zero key");
>> +	schib->pmcw.intparm = 100;
>> +	set_storage_key(schib, 0x28, 0);
>> +	cc = msch(test_device_sid, schib);
>> +	if (!cc) {
>> +		WRITE_ONCE(schib->pmcw.intparm, 0);
> 
> why are you using WRITE_ONCE here?

It's a dead store because of the stsch below.
That line is just for good measure so we know stsch really overwrote the value.
> 
>> +		cc = stsch(test_device_sid, schib);
>> +		report(!cc && schib->pmcw.intparm == 100, "fetched from SCHIB");

[...]
