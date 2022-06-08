Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D495543826
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 17:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244692AbiFHPzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 11:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244645AbiFHPzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 11:55:18 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C07CB1EC;
        Wed,  8 Jun 2022 08:55:16 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258FD438001000;
        Wed, 8 Jun 2022 15:55:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=txNEuU224eOnCI1/Om2APq8QKKEtliSOrDExGA4ag64=;
 b=I8Lotd14/kHCSBR638EejxKoYDjRj8MK4cU2WSicrusUp7W36O3ci/RXJze8vyNL9B1l
 u7vWRxemIYoUuUAPiF9mWwHKCcQFhVhfdAfvlfeYppbS5/GEyF0SOFHwNV4B2Y+z/xBp
 ABymelrj/eGfvxbK1D+V6pCUdyuRMPcjaX6SUjLKcsee6qSyoL3Dg62trXXUoLB8T+vY
 oQXEQVgiW0iZBCvcRPEVfl/njX5rm3lL5SuKvWfh76tGJwBL4JKQs7QFjbC2WXP6vk5q
 rs4xXtUY8IgER8DKJ9b6pU1BO1Y9OuPg4xsIiqLKvmqK7g7P7kC4vYvpvC6bSek4+687 yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjx7a0vmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 15:55:16 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258FnQe3026144;
        Wed, 8 Jun 2022 15:55:15 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjx7a0vkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 15:55:15 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258Fq8Gp000545;
        Wed, 8 Jun 2022 15:55:13 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3gfy18vdwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 15:55:13 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258FsrQ724117660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 15:54:53 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40D89AE053;
        Wed,  8 Jun 2022 15:55:10 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECCB0AE045;
        Wed,  8 Jun 2022 15:55:09 +0000 (GMT)
Received: from [9.171.25.241] (unknown [9.171.25.241])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jun 2022 15:55:09 +0000 (GMT)
Message-ID: <6ed956e7-81e0-cb09-85ea-383af9d4446e@linux.ibm.com>
Date:   Wed, 8 Jun 2022 17:55:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Rework TEID decoding and
 usage
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220608133303.1532166-1-scgl@linux.ibm.com>
 <20220608133303.1532166-4-scgl@linux.ibm.com>
 <20220608160357.4fa94ecc@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220608160357.4fa94ecc@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iEHsg6gbNZoBZ-M-R07j6-O0f8KzjSmV
X-Proofpoint-GUID: Y77t9blcbYINUzpiACK7BtpC_L5MD1iH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_05,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 clxscore=1015
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206080065
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/22 16:03, Claudio Imbrenda wrote:
> On Wed,  8 Jun 2022 15:33:03 +0200
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
>>  lib/s390x/asm/interrupt.h | 61 +++++++++++++++++++++++++++---------
>>  lib/s390x/fault.h         | 30 +++++-------------
>>  lib/s390x/fault.c         | 65 ++++++++++++++++++++++++++-------------
>>  lib/s390x/interrupt.c     |  2 +-
>>  s390x/edat.c              | 26 ++++++++++------
>>  5 files changed, 115 insertions(+), 69 deletions(-)
>>
>> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
>> index d9ab0bd7..3ca6bf76 100644
>> --- a/lib/s390x/asm/interrupt.h
>> +++ b/lib/s390x/asm/interrupt.h
>> @@ -20,23 +20,56 @@
>>  

[...]

>>  
>> +enum prot_code {
>> +	PROT_KEY_LAP,
>> +	PROT_DAT,
>> +	PROT_KEY,
>> +	PROT_ACC_LIST,
>> +	PROT_LAP,
>> +	PROT_IEP,
> 
> add:
> 	PROT_CODE_SIZE,	/* Must always be the last one */
> 
> [...]
> 
>> +	case SOP_ENHANCED_2: {
>> +		static const char * const prot_str[] = {
> 
> static const char * const prot_str[PROT_CODE_SIZE] = {
> 
> so you have the guarantee that this has the right size, and you will
> get a compile error if a new value is added to the enum but not here

Will I? It would just initialize missing elements with NULL, no?
> 
> and at this point I think it might make more sense to move this right
> after the enum itself
> 
>> +			"KEY or LAP",
>> +			"DAT",
>> +			"KEY",
>> +			"ACC",
>> +			"LAP",
>> +			"IEP",
>> +		};
>> +		int prot_code = teid_esop2_prot_code(teid);
> 
> enum prot_code prot_code = teid_esop2_prot_code(teid)> 
>>  
>> -	if (prot_is_datp(teid)) {
>> -		printf("Type: DAT\n");
>> -		return;
>> +		assert(0 <= prot_code && prot_code < ARRAY_SIZE(prot_str));
> 
> then you can remove this assert ^
> 
>> +		printf("Type: %s\n", prot_str[prot_code]);
>> +		}
>>  	}
>>  }
>>  
[...]
