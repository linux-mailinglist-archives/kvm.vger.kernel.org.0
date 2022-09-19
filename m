Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B965BD20E
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 18:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiISQSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 12:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiISQSG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 12:18:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7E829CA2;
        Mon, 19 Sep 2022 09:18:05 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28JGBsA9021409;
        Mon, 19 Sep 2022 16:18:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0apBg6MkrWoXI0NWsMipFahhj9etyrcEeKzVJWh9FOg=;
 b=YEac65XXBhbVAlZ/b/nTAbHXEAdHb53ulQAIDvEIkunItUGksPKvWKQIwFy3KUqX2ixd
 NC0MZsT9r9g3B+l//206iDZ8zUSG/IVEwOAa3B/jaTV/GYZEWsa+K8WQzkakx6vv8DCq
 /MtV8X2qtkDZnP9xoZkbeMiQXI70sSc5DNtdoeQuBKYyhg8KwISR5n92ABHFSvviD5bs
 uiaxRziuXI0tu2+eizl6kFCX7GDijvKTLTNjiKOJ6YyBLfMkW3dIuZMfZ1moTVQtG5xc
 i5RGp16jL10Slyw2LvUaRUem4zkGMAOhPRxp5SAAaVlqiEm0hagOsEfVySqW7JZLZTXU Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jpuqx066w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 16:18:03 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28JGC8Ed021967;
        Mon, 19 Sep 2022 16:18:02 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jpuqx065w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 16:18:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28JG6xtE013293;
        Mon, 19 Sep 2022 16:18:00 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3jn5gj2pt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 16:18:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28JGHvIw44302608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Sep 2022 16:17:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10A2B4C044;
        Mon, 19 Sep 2022 16:17:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 746D04C040;
        Mon, 19 Sep 2022 16:17:56 +0000 (GMT)
Received: from [9.171.62.75] (unknown [9.171.62.75])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 19 Sep 2022 16:17:56 +0000 (GMT)
Message-ID: <2728b10e-d3f1-e472-25f1-d1658414f1da@linux.ibm.com>
Date:   Mon, 19 Sep 2022 18:17:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2] KVM: s390: Pass initialized arg even if unused
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220825192540.1560559-1-scgl@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220825192540.1560559-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Heka_rtSxD8YCU_RuxCt0j-eOAA89IYu
X-Proofpoint-GUID: 7ypYL0kmmOhd3KoBzMVvZeSjN3WLX-bK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-19_05,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 clxscore=1011 priorityscore=1501 bulkscore=0 spamscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209190108
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 25.08.22 um 21:25 schrieb Janis Schoetterl-Glausch:
> This silences smatch warnings reported by kbuild bot:
> arch/s390/kvm/gaccess.c:859 guest_range_to_gpas() error: uninitialized symbol 'prot'.
> arch/s390/kvm/gaccess.c:1064 access_guest_with_key() error: uninitialized symbol 'prot'.
> 
> This is because it cannot tell that the value is not used in this case.
> The trans_exc* only examine prot if code is PGM_PROTECTION.
> Pass a dummy value for other codes.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Thanks applied.
> ---
> v1 -> v2
>   * drop unlikely, WARN_ON_ONCE instead of WARN (thanks Heiko)
> 
>   arch/s390/kvm/gaccess.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 082ec5f2c3a5..0243b6e38d36 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -489,6 +489,8 @@ enum prot_type {
>   	PROT_TYPE_ALC  = 2,
>   	PROT_TYPE_DAT  = 3,
>   	PROT_TYPE_IEP  = 4,
> +	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
> +	PROT_NONE,
>   };
>   
>   static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
> @@ -504,6 +506,10 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
>   	switch (code) {
>   	case PGM_PROTECTION:
>   		switch (prot) {
> +		case PROT_NONE:
> +			/* We should never get here, acts like termination */
> +			WARN_ON_ONCE(1);
> +			break;
>   		case PROT_TYPE_IEP:
>   			tec->b61 = 1;
>   			fallthrough;
> @@ -968,8 +974,10 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>   				return rc;
>   		} else {
>   			gpa = kvm_s390_real_to_abs(vcpu, ga);
> -			if (kvm_is_error_gpa(vcpu->kvm, gpa))
> +			if (kvm_is_error_gpa(vcpu->kvm, gpa)) {
>   				rc = PGM_ADDRESSING;
> +				prot = PROT_NONE;
> +			}
>   		}
>   		if (rc)
>   			return trans_exc(vcpu, rc, ga, ar, mode, prot);
> @@ -1112,8 +1120,6 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>   		if (rc == PGM_PROTECTION && try_storage_prot_override)
>   			rc = access_guest_page_with_key(vcpu->kvm, mode, gpas[idx],
>   							data, fragment_len, PAGE_SPO_ACC);
> -		if (rc == PGM_PROTECTION)
> -			prot = PROT_TYPE_KEYC;
>   		if (rc)
>   			break;
>   		len -= fragment_len;
> @@ -1123,6 +1129,10 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>   	if (rc > 0) {
>   		bool terminate = (mode == GACC_STORE) && (idx > 0);
>   
> +		if (rc == PGM_PROTECTION)
> +			prot = PROT_TYPE_KEYC;
> +		else
> +			prot = PROT_NONE;
>   		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
>   	}
>   out_unlock:
