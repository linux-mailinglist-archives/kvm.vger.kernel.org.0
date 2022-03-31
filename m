Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBA84EDA9B
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 15:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236882AbiCaNgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 09:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbiCaNgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 09:36:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8D9F329E;
        Thu, 31 Mar 2022 06:34:49 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22VCtOjc000908;
        Thu, 31 Mar 2022 13:34:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iWmUhd2gzNOKTbvvfXdB5TlWUvlA8kYnUfYO55tAMHs=;
 b=oLSwMn+1v5SEUcvlfSKN4dYvOsBJaj6I62zaz92ilNhV/OvGX69AI2J9E4pbW2jZJt/I
 2ofwgPoWtgqlegg/MFyRtLl4aQ66jKyfN7uln7nr8elFZDVEOmfU5sCWm8ospKpGJSl+
 8W0RxrrfsRvANDVt44PQs1eXpjiuTcv/pREVEQJ72QEq6BUivYSyxnuM4plaQijoXcSk
 JuMrI3VSYSCkHDiUMFqfwc0jWUdRltbHbtusYheKpz9PE6/1xZCfoGKYxPkfYGVqBnPJ
 vB1/lFkbYKc13H2LnLqM0Gs50BwxAMURAqJVILZETWSS6Jh2X58OQpFAygdaGf2t6u4n 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f5a3k4h5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 13:34:48 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22VCgtDk030123;
        Thu, 31 Mar 2022 13:34:48 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f5a3k4h52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 13:34:48 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22VDTGwZ022039;
        Thu, 31 Mar 2022 13:34:46 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3f1tf918kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 13:34:46 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22VDMfBu49479964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 13:22:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F25AD11C04C;
        Thu, 31 Mar 2022 13:34:42 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84C9B11C058;
        Thu, 31 Mar 2022 13:34:42 +0000 (GMT)
Received: from [9.145.159.108] (unknown [9.145.159.108])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 13:34:42 +0000 (GMT)
Message-ID: <a61d614f-df0a-d0a8-c1f1-45a915e26b23@linux.ibm.com>
Date:   Thu, 31 Mar 2022 15:34:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v9 11/18] s390/mm: KVM: pv: when tearing down, try to
 destroy protected pages
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
References: <20220330122605.247613-1-imbrenda@linux.ibm.com>
 <20220330122605.247613-12-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220330122605.247613-12-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d1_FrIPcBG4GJrJvYOIai_D9VtWzJJI2
X-Proofpoint-ORIG-GUID: w1srTf2AW4TVtdnSQSKQSATQR7L2pL1I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_05,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 phishscore=0 clxscore=1015 spamscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/30/22 14:25, Claudio Imbrenda wrote:
> When ptep_get_and_clear_full is called for a mm teardown, we will now
> attempt to destroy the secure pages. This will be faster than export.
> 
> In case it was not a teardown, or if for some reason the destroy page
> UVC failed, we try with an export page, like before.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   arch/s390/include/asm/pgtable.h | 18 +++++++++++++++---
>   1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index 23ca0d8e058a..72544a1b4a68 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1118,9 +1118,21 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
>   	} else {
>   		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
>   	}
> -	/* At this point the reference through the mapping is still present */
> -	if (mm_is_protected(mm) && pte_present(res))
> -		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
> +	/* Nothing to do */
> +	if (!mm_is_protected(mm) || !pte_present(res))
> +		return res;
> +	/*
> +	 * At this point the reference through the mapping is still present.

That's the case because we zap ptes within a mm that's still existing, 
right? The mm will be deleted after we have unmapped the memory.


> +	 * The notifier should have destroyed all protected vCPUs at this
> +	 * point, so the destroy should be successful.
> +	 */
> +	if (full && !uv_destroy_owned_page(pte_val(res) & PAGE_MASK))
> +		return res;
> +	/*
> +	 * But if something went wrong and the pages could not be destroyed,
> +	 * the slower export is used as fallback instead.
> +	 */
> +	uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
>   	return res;
>   }
>   

