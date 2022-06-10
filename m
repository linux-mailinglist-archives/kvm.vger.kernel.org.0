Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FD4546276
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 11:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245028AbiFJJcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 05:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347033AbiFJJcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 05:32:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320DBB879;
        Fri, 10 Jun 2022 02:32:06 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25A86WVV000925;
        Fri, 10 Jun 2022 09:32:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XC3pNMaxXU083lbkXCr8ubRZNMxags1cMeND04/wyiI=;
 b=QHZuR3IGp0NFDGuX+tufTfV58HJdle7JdKFS44DJOQnOryG1Gri0647gOZmizm2kYkVR
 7An5jegNrNsH/KghZJ5yIHH5piTzzCVS1XBIrkfgvJg8IKz5T7Syy1CgtsQ2dGDE/W/R
 c9AiY4UVBa89bJqvg+kI4b6Bs6CbImmY2yxnMuHxt+BGKA+pepA8+vJVq5+A45A0dTGO
 t6NDXq47P6KukkHPUMgE/WCEdCFpkED3OxKqpVRfCmUDiqe4a7SPnqqc9F+ekzms9d9h
 Z7TSHa9inHb3g/8cDcpJYuSmW9uc53Zia71IRP4np6RcpY/v7br0aNrwDbBVFeI0yHqm UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gkxxgw0ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 09:32:05 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25A9PXWQ025469;
        Fri, 10 Jun 2022 09:32:04 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gkxxgw0e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 09:32:04 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25A9K8AH010960;
        Fri, 10 Jun 2022 09:32:03 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3gfxnj039y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 09:32:03 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25A9VdEv20644216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 09:31:39 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F26F452052;
        Fri, 10 Jun 2022 09:31:59 +0000 (GMT)
Received: from [9.145.63.156] (unknown [9.145.63.156])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 962855204F;
        Fri, 10 Jun 2022 09:31:59 +0000 (GMT)
Message-ID: <1b4f731f-866c-5357-b0e0-b8bc375976cd@linux.ibm.com>
Date:   Fri, 10 Jun 2022 11:31:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220608133303.1532166-1-scgl@linux.ibm.com>
 <20220608133303.1532166-4-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Rework TEID decoding and
 usage
In-Reply-To: <20220608133303.1532166-4-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z53YhkQfqz2qWYRIljchMLadM1W7SFt0
X-Proofpoint-ORIG-GUID: fMcCKSlnpPfJOx_QZsGabjYVlXBRKp7_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-10_02,2022-06-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206100033
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/22 15:33, Janis Schoetterl-Glausch wrote:
> The translation-exception identification (TEID) contains information to
> identify the cause of certain program exceptions, including translation
> exceptions occurring during dynamic address translation, as well as
> protection exceptions.
> The meaning of fields in the TEID is complex, depending on the exception
> occurring and various potentially installed facilities.
> 
> Rework the type describing the TEID, in order to ease decoding.
> Change the existing code interpreting the TEID and extend it to take the
> installed suppression-on-protection facility into account.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   lib/s390x/asm/interrupt.h | 61 +++++++++++++++++++++++++++---------
>   lib/s390x/fault.h         | 30 +++++-------------
>   lib/s390x/fault.c         | 65 ++++++++++++++++++++++++++-------------
>   lib/s390x/interrupt.c     |  2 +-
>   s390x/edat.c              | 26 ++++++++++------
>   5 files changed, 115 insertions(+), 69 deletions(-)
> 
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index d9ab0bd7..3ca6bf76 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -20,23 +20,56 @@
>   
>   union teid {
>   	unsigned long val;
> -	struct {
> -		unsigned long addr:52;
> -		unsigned long fetch:1;
> -		unsigned long store:1;
> -		unsigned long reserved:6;
> -		unsigned long acc_list_prot:1;
> -		/*
> -		 * depending on the exception and the installed facilities,
> -		 * the m field can indicate several different things,
> -		 * including whether the exception was triggered by a MVPG
> -		 * instruction, or whether the addr field is meaningful
> -		 */
> -		unsigned long m:1;
> -		unsigned long asce_id:2;
> +	union {
> +		/* common fields DAT exc & protection exc */
> +		struct {
> +			uint64_t addr			: 52 -  0;
> +			uint64_t acc_exc_f_s		: 54 - 52;
> +			uint64_t side_effect_acc	: 55 - 54;
> +			uint64_t /* reserved */		: 62 - 55;
> +			uint64_t asce_id		: 64 - 62;
> +		};
> +		/* DAT exc */
> +		struct {
> +			uint64_t /* pad */		: 61 -  0;
> +			uint64_t dat_move_page		: 62 - 61;
> +		};
> +		/* suppression on protection */
> +		struct {
> +			uint64_t /* pad */		: 60 -  0;
> +			uint64_t sop_acc_list		: 61 - 60;
> +			uint64_t sop_teid_predictable	: 62 - 61;
> +		};
> +		/* enhanced suppression on protection 2 */
> +		struct {
> +			uint64_t /* pad */		: 56 -  0;
> +			uint64_t esop2_prot_code_0	: 57 - 56;
> +			uint64_t /* pad */		: 60 - 57;
> +			uint64_t esop2_prot_code_1	: 61 - 60;
> +			uint64_t esop2_prot_code_2	: 62 - 61;
> +		};

Quite messy, would it be more readable to unionize the fields that overlap?

>   	};
>   };
>   
> +enum prot_code {
> +	PROT_KEY_LAP,

That's key OR LAP, right?

> +	PROT_DAT,
> +	PROT_KEY,
> +	PROT_ACC_LIST,
> +	PROT_LAP,
> +	PROT_IEP,
> +};
> +

Yes, I like that more than my quick fixes :-)

> +static void print_decode_pgm_prot(union teid teid, bool dat)
> +{
> +	switch (get_supp_on_prot_facility()) {
> +	case SOP_NONE:
> +		printf("Type: ?\n");
> +		break;
> +	case SOP_BASIC:
> +		if (teid.sop_teid_predictable && dat && teid.sop_acc_list)
> +			printf("Type: ACC\n");
> +		else
> +			printf("Type: ?\n");
> +		break;

I'm wondering if we should cut off the two possibilities above to make 
it a bit more sane. The SOP facility is about my age now and ESOP1 has 
been introduced with z10 if I'm not mistaken so it's not young either.

Do we have tests that require SOP/no-SOP?
