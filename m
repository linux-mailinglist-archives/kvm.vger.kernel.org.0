Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1F255D302
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbiF0IfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 04:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiF0IfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 04:35:18 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5D2625F;
        Mon, 27 Jun 2022 01:35:17 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25R8MQT3006510;
        Mon, 27 Jun 2022 08:35:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6DlWVYA8hMNjFBiZ87iwSCITxHGwTcyAmb3K65dXJhY=;
 b=rRtumoFLpM1BfgP6ELoG/TamJJ25MW5ejahyMJGU2WR2uau6fXGxHR3Eu+8XopnkPhnV
 NlmM5iwtYkl3ATxqGCBW75VS/wIpAXFht4Bdqq4QcYWx7llAuc7TQkH4T+A0qMhwqz9L
 FjHT8NRwrg3lYGDa6IGMBLQow+a/sv0O6vYsml+X4A1vXgRcENqpCo4QVTIOoGnnV/zr
 p0mDod8ri7+INOXVJWqd3+fB1RI1pVqzVldqriGCAeCHMlQ61FKt5/wzOmWrnikPTOs3
 gjWh6cuxH2m+P0+3UfWocWRAOc85vQLzxLyyavLY9wH3veeyHhszNVuwhbw1Ogzrhvmt zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gy8yy88jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 08:35:16 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25R8P6pW018538;
        Mon, 27 Jun 2022 08:35:16 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gy8yy88j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 08:35:16 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25R8KqdW027610;
        Mon, 27 Jun 2022 08:35:14 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3gwt08tj7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 08:35:14 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25R8ZBoW14746028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 08:35:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B536CA4051;
        Mon, 27 Jun 2022 08:35:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71111A404D;
        Mon, 27 Jun 2022 08:35:11 +0000 (GMT)
Received: from [9.145.155.49] (unknown [9.145.155.49])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 08:35:11 +0000 (GMT)
Message-ID: <6e6e4e06-a32f-c5b7-0b3a-f9f62ed164df@linux.ibm.com>
Date:   Mon, 27 Jun 2022 10:35:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v2 1/3] lib: s390x: add functions to set
 and clear PSW bits
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, scgl@linux.ibm.com, nrb@linux.ibm.com,
        thuth@redhat.com
References: <20220624144518.66573-1-imbrenda@linux.ibm.com>
 <20220624144518.66573-2-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220624144518.66573-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LKvK5l0oSJ01FppKH4VWWEyFJ2264CsH
X-Proofpoint-GUID: JT2Khc2yPeO6K034ezwMkmlEpSNTfyG0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206270036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/24/22 16:45, Claudio Imbrenda wrote:
> Add some functions to set and/or clear bits in the PSW.
> This should improve code readability.
> 

Also we introduce PSW_MASK_KEY and re-order the PSW_MASK_* constants so 
they are descending in value.

> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h | 58 +++++++++++++++++++++++++++++++++++-----
>   lib/s390x/asm/pgtable.h  |  2 --
>   lib/s390x/mmu.c          | 14 +---------
>   lib/s390x/sclp.c         |  7 +----
>   s390x/diag288.c          |  6 ++---
>   s390x/selftest.c         |  4 +--
>   s390x/skrf.c             | 12 +++------
>   s390x/smp.c              | 18 +++----------
>   8 files changed, 63 insertions(+), 58 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 78b257b7..b0052848 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -46,9 +46,10 @@ struct psw {
>   #define AS_SECN				2
>   #define AS_HOME				3
>   
> -#define PSW_MASK_EXT			0x0100000000000000UL
> -#define PSW_MASK_IO			0x0200000000000000UL
>   #define PSW_MASK_DAT			0x0400000000000000UL
> +#define PSW_MASK_IO			0x0200000000000000UL
> +#define PSW_MASK_EXT			0x0100000000000000UL
> +#define PSW_MASK_KEY			0x00F0000000000000UL
>   #define PSW_MASK_WAIT			0x0002000000000000UL
>   #define PSW_MASK_PSTATE			0x0001000000000000UL
>   #define PSW_MASK_EA			0x0000000100000000UL
> @@ -313,6 +314,53 @@ static inline void load_psw_mask(uint64_t mask)
>   		: "+r" (tmp) :  "a" (&psw) : "memory", "cc" );
>   }
>   
> +/**
> + * psw_mask_set_clear_bits - sets and clears bits from the current PSW mask
> + * @clear: bitmask of bits that will be cleared
> + * @set: bitmask of bits that will be set
> + *
> + * Bits will be cleared first, and then set, so if (@clear & @set != 0) then
> + * the bits in the intersection will be set.
> + */
> +static inline void psw_mask_set_clear_bits(uint64_t clear, uint64_t set)

This function isn't used at all, no?
