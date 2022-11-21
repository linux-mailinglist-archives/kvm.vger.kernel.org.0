Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28CD632198
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 13:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiKUMII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 07:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiKUMIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 07:08:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803582035A;
        Mon, 21 Nov 2022 04:07:59 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALACSXO011886;
        Mon, 21 Nov 2022 12:07:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iYdZtxyIcVkOs+W7JFZZMD2g9Q8yK4JWy0ciE3X934k=;
 b=CQnPyRrYLcEhcRbvHycqHePQrwvpcEjI9t5Kvpik1InJwXkRh6tNW8MGsMsR57bvr5TS
 NAn21Iacsbwb3vXal9mlhwsLNFL2TBvZO+xWDeuVXoUeOwIexTx23Q4X4bEgIUiIuAVJ
 CYJ5aevvy4lKytUcurnmgDf4Ea0Lj3uWQgEGsMccK/ytSRDqH3OKGw4cjnUmy5d56CNB
 w3eOResKYkHGy1ZAEn92uuV1peqTpd4LgTrdLsbIv+oKAbdcT+8EVD+HQbzL7we6wfaQ
 BfbJI8twqbKomm0zc73EQiR/Bew77v8LS+ZHbHLpYhJaiDGL65h1EXBZ11AENleHQ+0j Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ky8qtggrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 12:07:58 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ALApEwm015122;
        Mon, 21 Nov 2022 12:07:57 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ky8qtggra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 12:07:57 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALC6VnT012969;
        Mon, 21 Nov 2022 12:07:56 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3kxpdj1y8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 12:07:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALC7qd849807700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 12:07:52 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E6134C044;
        Mon, 21 Nov 2022 12:07:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13F9F4C040;
        Mon, 21 Nov 2022 12:07:52 +0000 (GMT)
Received: from [9.171.81.97] (unknown [9.171.81.97])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Nov 2022 12:07:52 +0000 (GMT)
Message-ID: <d8f54fc3-c99f-32b7-acd3-7f687fb8ee40@linux.ibm.com>
Date:   Mon, 21 Nov 2022 13:07:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] KVM: s390: remove unused gisa_clear_ipm_gisc() function
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20221118151133.2974602-1-hca@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221118151133.2974602-1-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xo31VfLVhR2pvIpkF52u-z4WwKID0wS8
X-Proofpoint-GUID: VmEF9-pXkJuhloqiITYevMoLdE7HRw7K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_12,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=875 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 18.11.22 um 16:11 schrieb Heiko Carstens:
> clang warns about an unused function:
> arch/s390/kvm/interrupt.c:317:20:
>    error: unused function 'gisa_clear_ipm_gisc' [-Werror,-Wunused-function]
> static inline void gisa_clear_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
> 
> Remove gisa_clear_ipm_gisc(), since it is unused and get rid of this
> warning.
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Thanks, queued.

> ---
>   arch/s390/kvm/interrupt.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index ab569faf0df2..1dae78deddf2 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -314,11 +314,6 @@ static inline u8 gisa_get_ipm(struct kvm_s390_gisa *gisa)
>   	return READ_ONCE(gisa->ipm);
>   }
>   
> -static inline void gisa_clear_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
> -{
> -	clear_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
> -}
> -
>   static inline int gisa_tac_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
>   {
>   	return test_and_clear_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
