Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2081543B3E5
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 16:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhJZOZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 10:25:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20728 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234276AbhJZOZS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 10:25:18 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QDk88T023788;
        Tue, 26 Oct 2021 14:22:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rc2hYgUAmIqVmD1vKk02kSKzJHU5JUNEOVYRHwobACE=;
 b=jmitWKnfGcML08eeKGjUX1Uq9hpZBVRCJsCjp3lIekfInkOHlM80+jbB0B2RXM2zub1q
 gtyRept+BYN+LIwlNqCBKWYP1vDC9itBkemKyd9G25N3zD2zziXcb34QdN7atoVfwFaX
 adQKQvf4qTAsz1XQkhaTNIBcbjvPor0y+4df7JkcelLZQcQ+aUgco8A/iEIFd+iwYHaX
 AZwXfkU7eWFkfJO9B8kKXPdkxHI6ak/LiRa9ogaHJR991VWx0Gy20gnVdZ2DdrTIWMDL
 x+OgMH3jwpjbAYHS49nEQ7fIOxvuebRPfU7zpc7MLz/BaZGtsEWQxzWj6oCt85ZHX6mc Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bx4ygrg8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 14:22:50 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19QDvdkR007947;
        Tue, 26 Oct 2021 14:22:50 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bx4ygrg76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 14:22:50 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19QEEJm6011363;
        Tue, 26 Oct 2021 14:22:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3bx4epp0c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 14:22:47 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19QEMiVi58917248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 14:22:44 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24133AE057;
        Tue, 26 Oct 2021 14:22:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED06CAE05A;
        Tue, 26 Oct 2021 14:22:40 +0000 (GMT)
Received: from [9.171.95.189] (unknown [9.171.95.189])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Oct 2021 14:22:40 +0000 (GMT)
Message-ID: <32dfb400-4191-44f8-354e-809fac890b63@linux.vnet.ibm.com>
Date:   Tue, 26 Oct 2021 16:22:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 2/2] s390x: Test specification
 exceptions during transaction
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211022120156.281567-1-scgl@linux.ibm.com>
 <20211022120156.281567-3-scgl@linux.ibm.com>
 <20211025193012.3be31938@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
In-Reply-To: <20211025193012.3be31938@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hO3vkHqn-aemhirmVlVrStQaZFCrk_lA
X-Proofpoint-GUID: QFxwi-bn2gTrZVPsi6MFeOqa_393gP3S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_04,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110260081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/25/21 19:30, Claudio Imbrenda wrote:
> On Fri, 22 Oct 2021 14:01:56 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> Program interruptions during transactional execution cause other
>> interruption codes.
>> Check that we see the expected code for (some) specification exceptions.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---

[...]

>> +#define TRANSACTION_MAX_RETRIES 5
>> +
>> +/* NULL must be passed to __builtin_tbegin via constant, forbid diagnose from
>> + * being NULL to keep things simple
>> + */
>> +static int __attribute__((nonnull))
>> +with_transaction(void (*trigger)(void), struct __htm_tdb *diagnose)
>> +{
>> +	int cc;
>> +
> 
> if you want to be extra sure, put an assert here (although I'm not sure
> how nonnull works, I have never seen it before)

Ok, with nonnull, the compiler might warn you if you pass NULL.
> 
>> +	cc = __builtin_tbegin(diagnose);
>> +	if (cc == _HTM_TBEGIN_STARTED) {
>> +		trigger();
>> +		__builtin_tend();
>> +		return -TRANSACTION_COMPLETED;
>> +	} else {
>> +		return -cc;
>> +	}
>> +}
>> +
>> +static int retry_transaction(const struct spec_ex_trigger *trigger, unsigned int max_retries,
>> +			     struct __htm_tdb *tdb, uint16_t expected_pgm)
>> +{
>> +	int trans_result, i;
>> +	uint16_t pgm;
>> +
>> +	for (i = 0; i < max_retries; i++) {
>> +		expect_pgm_int();
>> +		trans_result = with_transaction(trigger->func, tdb);
>> +		if (trans_result == -_HTM_TBEGIN_TRANSIENT) {
>> +			mb();
>> +			pgm = lc->pgm_int_code;
>> +			if (pgm == 0)
>> +				continue;
>> +			else if (pgm == expected_pgm)
>> +				return 0;
>> +		}
>> +		return trans_result;
>> +	}
>> +	return -TRANSACTION_MAX_RETRIES;
> 
> so this means that a test will be considered failed if the transaction
> failed too many times?

Yes.
> 
> this means that could fail if the test is run on busy system, even if
> the host running the unit test is correct

I suppose so, don't know how likely that is.
> 
> also, do you really need to use negative values? it's probably easier
> to read if you stick to positive values, and less prone to mistakes if
> you accidentally forget a - somewhere.

Ok.
> 
>> +}
>> +
>> +static void test_spec_ex_trans(struct args *args, const struct spec_ex_trigger *trigger)
>> +{
>> +	const uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION
>> +			      | PGM_INT_CODE_TX_ABORTED_EVENT;
>> +	union {
>> +		struct __htm_tdb tdb;
>> +		uint64_t dwords[sizeof(struct __htm_tdb) / sizeof(uint64_t)];
>> +	} diag;
>> +	unsigned int i, failures = 0;
>> +	int trans_result;
>> +
>> +	if (!test_facility(73)) {
>> +		report_skip("transactional-execution facility not installed");
>> +		return;
>> +	}
>> +	ctl_set_bit(0, CTL0_TRANSACT_EX_CTL); /* enable transactional-exec */
>> +
>> +	for (i = 0; i < args->iterations && failures <= args->max_failures; i++) {
>> +		register_pgm_cleanup_func(trigger->fixup);
>> +		trans_result = retry_transaction(trigger, args->max_retries, &diag.tdb, expected_pgm);
> 
> so you retry each iteration up to args->max_retries times, and if a
> transaction aborts too many times (maybe because the host system is
> very busy), then you consider it a fail
> 

[...]
