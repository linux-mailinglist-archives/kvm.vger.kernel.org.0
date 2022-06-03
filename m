Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9F453CAE5
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 15:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238644AbiFCNtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 09:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244810AbiFCNtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 09:49:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E65D25EB2;
        Fri,  3 Jun 2022 06:49:44 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 253BTr9U018188;
        Fri, 3 Jun 2022 13:49:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : from : subject : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TdyYOPU40kXZFFG8Xb0JF+fPyOykeVsIfyHEddjXwFY=;
 b=AikR8zSW/CcnTWTlfo8BlXnCEzHpJx3FVWgEAEJqqMvX99i8IpIDpwfLhcz3EWo4v1iO
 jjTkh3QEIwXlqAoTw7EcvGgaG4XMh49FUmvK1Ddy/LGPaC/jGWdajLg65cDuQQXxfkDh
 Pmai3gUY93yz3U/QUQGqBObMA7mlrNuXYyA37U2+8uJLDkUQVsUdbc4yx1tkau0Jpfuu
 RfPga7CV5ZSqyMDbsfgbZHchjGLFBHsDYkEeKo2lL8GRUmOL29a4I9zpFO+CCbj1eUJB
 EmFD+aM5Soxs/QRW+cUldJrG7ahFQLmqd8bu3rhIdhRP3dg4fyDmh6NB1d6dvaiMkOQN dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfhftafpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 13:49:43 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 253DYjw7000481;
        Fri, 3 Jun 2022 13:49:43 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfhftafnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 13:49:43 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 253DaQeY006978;
        Fri, 3 Jun 2022 13:49:40 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3gf2afgt3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 13:49:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 253Dnb9P47645078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 13:49:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7142AA4055;
        Fri,  3 Jun 2022 13:49:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 411B7A4051;
        Fri,  3 Jun 2022 13:49:34 +0000 (GMT)
Received: from [9.171.9.147] (unknown [9.171.9.147])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 13:49:34 +0000 (GMT)
Message-ID: <c5eb73b0-776d-d0eb-7040-09fcbb603a8f@linux.ibm.com>
Date:   Fri, 3 Jun 2022 15:49:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: Rework TEID decoding and usage
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220520190850.3445768-1-scgl@linux.ibm.com>
 <20220520190850.3445768-4-scgl@linux.ibm.com>
 <20220524164030.6adb45bf@p-imbrenda>
Content-Language: en-US
In-Reply-To: <20220524164030.6adb45bf@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MmwAiKSzyDyrSWrfEjqxmt474qwV4dlp
X-Proofpoint-ORIG-GUID: UwX3_PFGQEVC1XOIvRmH98zl3XXtHaBp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_04,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 clxscore=1015
 mlxlogscore=999 malwarescore=0 impostorscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206030059
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/22 16:40, Claudio Imbrenda wrote:
> On Fri, 20 May 2022 21:08:50 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> The translation-exception identification (TEID) contains information to
>> identify the cause of certain program exceptions, including translation
>> exceptions occurring during dynamic address translation, as well as
>> protection exceptions.
>> The meaning of fields in the TEID is complex, depending on the exception
>> occurring and various potentially installed facilities.
>>
>> Rework the type describing the TEID, in order to ease decoding.
>> Change the existing code interpreting the TEID and extend it to take the
>> installed suppression-on-protection facility into account.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>  lib/s390x/asm/interrupt.h | 66 ++++++++++++++++++++++++++--------
>>  lib/s390x/fault.h         | 30 ++++------------
>>  lib/s390x/fault.c         | 74 +++++++++++++++++++++++++++------------
>>  lib/s390x/interrupt.c     |  2 +-
>>  s390x/edat.c              | 20 +++++++----
>>  5 files changed, 124 insertions(+), 68 deletions(-)
>>
>> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
>> index d9ab0bd7..8d5bfbf9 100644
>> --- a/lib/s390x/asm/interrupt.h
>> +++ b/lib/s390x/asm/interrupt.h
>> @@ -20,23 +20,61 @@
>>  
>>  union teid {
>>  	unsigned long val;
>> -	struct {
>> -		unsigned long addr:52;
>> -		unsigned long fetch:1;
>> -		unsigned long store:1;
>> -		unsigned long reserved:6;
>> -		unsigned long acc_list_prot:1;
>> -		/*
>> -		 * depending on the exception and the installed facilities,
>> -		 * the m field can indicate several different things,
>> -		 * including whether the exception was triggered by a MVPG
>> -		 * instruction, or whether the addr field is meaningful
>> -		 */
>> -		unsigned long m:1;
>> -		unsigned long asce_id:2;
>> +	union {
>> +		/* common fields DAT exc & protection exc */
>> +		struct {
>> +			uint64_t addr			: 52 -  0;
>> +			uint64_t acc_exc_f_s		: 54 - 52;
>> +			uint64_t side_effect_acc	: 55 - 54;
>> +			uint64_t /* reserved */		: 55 - 54;
> 
> shouldn't this ^ be 62 - 55 ?

Oops, yes.
> 
>> +			uint64_t asce_id		: 64 - 62;
>> +		};
>> +		/* DAT exc */
>> +		struct {
>> +			uint64_t /* pad */		: 61 -  0;
>> +			uint64_t dat_move_page		: 62 - 61;
>> +		};
>> +		/* suppression on protection */
>> +		struct {
>> +			uint64_t /* pad */		: 60 -  0;
>> +			uint64_t sop_acc_list		: 61 - 60;
>> +			uint64_t sop_teid_predictable	: 62 - 61;
>> +		};
>> +		/* enhanced suppression on protection 1 */
>> +		struct {
>> +			uint64_t /* pad */		: 61 -  0;
> 
> 60 - 0
> 
>> +			uint64_t esop1_acc_list_or_dat	: 62 - 61;
> 
> 61 - 60
> 
> and then:
> 
> uint64_t esop1_teid_predictable : 62 - 61;
> 
Ah, no, but I see how it is confusing.
If bit 61 is one then the exception is due to access list or DAT.
That's why its called acc_list_or_dat.
If it is zero it's due to low address or key and the rest of the TEID
is unpredictable. So this is an alias of sop_teid_predictable.

>> +		};
>> +		/* enhanced suppression on protection 2 */
>> +		struct {
>> +			uint64_t /* pad */		: 56 -  0;
>> +			uint64_t esop2_prot_code_0	: 57 - 56;
>> +			uint64_t /* pad */		: 60 - 57;
>> +			uint64_t esop2_prot_code_1	: 61 - 60;
>> +			uint64_t esop2_prot_code_2	: 62 - 61;
>> +		};
>>  	};
>>  };
>>  
>> +enum prot_code {
>> +	PROT_KEY_LAP,
>> +	PROT_DAT,
>> +	PROT_KEY,
>> +	PROT_ACC_LIST,
>> +	PROT_LAP,
>> +	PROT_IEP,
> 
> I would still also define two PROT_INVALID or PROT_RESERVED
> 
> just to avoid surprises
> 
I guess the values are reserved, but maybe an assert would be better?
Then we'd be notified to fix the test.

[...]

>> +static void print_decode_pgm_prot(union teid teid, bool dat)
>> +{
>> +	switch (get_supp_on_prot_facility()) {
>> +	case SOP_NONE:
>> +		printf("Type: ?\n");
>> +		break;
>> +	case SOP_BASIC:
>> +		if (teid.sop_teid_predictable && dat && teid.sop_acc_list)
>> +			printf("Type: ACC\n");
>> +		else
>> +			printf("Type: ?\n");
>> +		break;
>> +	case SOP_ENHANCED_1:
>> +		if (teid.esop1_acc_list_or_dat) {
>> +			if (teid.sop_acc_list)
>> +				printf("Type: ACC\n");
>> +			else
>> +				printf("Type: DAT\n");
>> +		} else {
>> +			printf("Type: KEY or LAP\n");
>> +		}
>> +		break;
>> +	case SOP_ENHANCED_2:
>> +		switch (teid_esop2_prot_code(teid)) {
> 
> I wonder if it weren't easier to do
> 
> static const char * const prot_strings[6] = {"KEY or LAP", "DAT", ...};
> printf("Type: %s\n", prot_strings[teid_esop2_prot_code(teid)]);
> 
Yeah, good idea.

>> +		case PROT_KEY_LAP:
>> +			printf("Type: KEY or LAP\n");
>> +			break;
>> +		case PROT_DAT:
>> +			printf("Type: DAT\n");
>> +			break;
>> +		case PROT_KEY:
>> +			printf("Type: KEY\n");
>> +			break;
>> +		case PROT_ACC_LIST:
>> +			printf("Type: ACC\n");
>> +			break;
>> +		case PROT_LAP:
>> +			printf("Type: LAP\n");
>> +			break;
>> +		case PROT_IEP:
>> +			printf("Type: IEP\n");
>> +			break;
>> +		}
>>  	}
>>  }
>>  

[...]

>> @@ -65,10 +93,10 @@ void print_decode_teid(uint64_t teid)
>>  	 */
>>  	if ((lowcore.pgm_int_code == PGM_INT_CODE_SECURE_STOR_ACCESS ||
>>  	     lowcore.pgm_int_code == PGM_INT_CODE_SECURE_STOR_VIOLATION) &&
>> -	    !test_bit_inv(61, &teid)) {
>> -		printf("Address: %lx, unpredictable\n ", teid & PAGE_MASK);
>> +	    !teid.sop_teid_predictable) {
>> +		printf("Address: %lx, unpredictable\n ", raw_teid & PAGE_MASK);
>>  		return;
>>  	}
>> -	printf("TEID: %lx\n", teid);
>> -	printf("Address: %lx\n\n", teid & PAGE_MASK);
>> +	printf("TEID: %lx\n", raw_teid);
>> +	printf("Address: %lx\n\n", raw_teid & PAGE_MASK);
> 
> teid.addr << PAGE_SHIFT ?

I got compiler warnings because teid.addr is 52 bit.
> 
>>  }
>> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
>> index 6da20c44..ac3d1ecd 100644
>> --- a/lib/s390x/interrupt.c
>> +++ b/lib/s390x/interrupt.c
>> @@ -77,7 +77,7 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
>>  		break;
>>  	case PGM_INT_CODE_PROTECTION:
>>  		/* Handling for iep.c test case. */
>> -		if (prot_is_iep(lowcore.trans_exc_id))
>> +		if (prot_is_iep((union teid) { .val = lowcore.trans_exc_id }))
>>  			/*
>>  			 * We branched to the instruction that caused
>>  			 * the exception so we can use the return
>> diff --git a/s390x/edat.c b/s390x/edat.c
>> index c6c25042..af442039 100644
>> --- a/s390x/edat.c
>> +++ b/s390x/edat.c
>> @@ -37,14 +37,20 @@ static bool check_pgm_prot(void *ptr)
>>  		return false;
>>  
>>  	teid.val = lowcore.trans_exc_id;
>> -
>> -	/*
>> -	 * depending on the presence of the ESOP feature, the rest of the
>> -	 * field might or might not be meaningful when the m field is 0.
>> -	 */
>> -	if (!teid.m)
>> +	switch (get_supp_on_prot_facility()) {
>> +	case SOP_NONE:
>>  		return true;
>> -	return (!teid.acc_list_prot && !teid.asce_id &&
>> +	case SOP_BASIC:
>> +		if (!teid.sop_teid_predictable)
>> +			return true;
> 
This function is mostly correct, except it's missing
break; statements (so not correct at all :)).

> add:
> 
> if (teid.sop_acc_list)
> 	return false;
> 
Will be taken care of by the return statement at the very bottom.

>> +	case SOP_ENHANCED_1:
> 
> you need to handle the unpredictable case here too
> 
>> +		if (!teid.esop1_acc_list_or_dat)
>> +			return false;
>
> so you return false the it is DAT... but if it is not DAT, it's
> access-control-list... 
> 
So this makes sense if instead you think about bit 61.
It also shows the rational for the variable name if you read it as
"if the exception was not due to either access list or DAT", so we
return false in case we know it was not DAT.

> you might want to replace this whole case with:
> 
> return !teid.esop1_teid_predictable;
> 
> (although I don't understand why you want to exclude DAT here)
> 
>> +	case SOP_ENHANCED_2:
>> +		if (teid_esop2_prot_code(teid) != 1)
> 
> why not using the PROT_DAT enum?

Just forgot.

> also, handle the PROT_ACC_LIST too
> 
> also, add:
> 
> if (PROT_KEY_LAP)
> 	return true;

Am I misunderstanding the edat test? We're expecting nothing but
DAT protection exceptions, no? So everything else is a test failure.
> 
> because in that case you don't have the address part.
> 
> 
> 
> but at this point I wonder if you can't just rewrite this function with
> an additional enum prot_code parameter, to specify the exact type of
> exception you're expecting

Maybe, but I don't think it's worth it. The logic is complicated and I'd
prefer to keep it as simple as possible and keeping it specific to the test
helps with that, instead of generalizing it to all possibilities.
> 
>> +			return false;
>> +	}
>> +	return (!teid.sop_acc_list && !teid.asce_id &&
>>  		(teid.addr == ((unsigned long)ptr >> PAGE_SHIFT)));
>>  }
>>  
> 

