Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7944C3DA0B9
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 11:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbhG2J6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 05:58:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44094 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235546AbhG2J6t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 05:58:49 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T9bf2v074402;
        Thu, 29 Jul 2021 05:58:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MS7Ztwk3n6D4oO2vbrxMsYXbpyCELWnAOsoH77A5qE8=;
 b=UKqsVqNRkcAdto2zxWKpQwekEdl+e3wVsRB3oN+PApYva5D4R/HM/6nQt+vyiOvfAgoN
 AIcnrh863IjW2Lu1xV5SqLWUh6uF9MVl75txS63QcD7z/C8+7NHcBmLTm84FWrbGmUU2
 GVoO4HbaprNr55f+r6D5gWJxfX+roqttAufmSYdNcrYYFvvoP5cZZ0eOkDwtA6zHsj0l
 dIXu5y3v8Q/EzkycMnEYlfEMeIZPAF89K8Rx/XG1hPmF+OXXK0HuAa5g8ZPlpDviWMsY
 Tagthd9/6+aO2Qqy5++m8znIqBneqd6N2PKYrv3v8y4On3Xyc2gZTxtS9PBjA//GsdDf 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a3qb0677s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 05:58:46 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16T9c8uk077434;
        Thu, 29 Jul 2021 05:58:46 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a3qb06776-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 05:58:46 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16T9qoMK026695;
        Thu, 29 Jul 2021 09:58:44 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3a235m1m2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:58:44 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16T9werq26083706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 09:58:40 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2F2911C04C;
        Thu, 29 Jul 2021 09:58:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25A2811C050;
        Thu, 29 Jul 2021 09:58:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.155.135])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 09:58:40 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
 <20210728142631.41860-2-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v2 01/13] KVM: s390: pv: avoid stall notifications for
 some UVCs
Message-ID: <6bbeded3-ef94-6c83-f093-796d76b70792@linux.ibm.com>
Date:   Thu, 29 Jul 2021 11:58:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210728142631.41860-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Fl98WZyN4g1J67ZGvl3pfJVy0CLNBA5O
X-Proofpoint-ORIG-GUID: Xp9oa9ErG5W0bwq8FOUxg8yB-HtjX5Vr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_09:2021-07-27,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 mlxscore=0
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107290061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/28/21 4:26 PM, Claudio Imbrenda wrote:
> Improve make_secure_pte to avoid stalls when the system is heavily
> overcommitted. This was especially problematic in kvm_s390_pv_unpack,
> because of the loop over all pages that needed unpacking.
> 
> Also fix kvm_s390_pv_init_vm to avoid stalls when the system is heavily
> overcommitted.

Fixes tag?

> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kernel/uv.c | 11 ++++++++---
>  arch/s390/kvm/pv.c    |  2 +-
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index aeb0a15bcbb7..fd0faa51c1bb 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -196,11 +196,16 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
>  	if (!page_ref_freeze(page, expected))
>  		return -EBUSY;
>  	set_bit(PG_arch_1, &page->flags);
> -	rc = uv_call(0, (u64)uvcb);
> +	rc = __uv_call(0, (u64)uvcb);

We should exchange rc with cc since that's what we get back from
__uv_call(). Technically we always get a cc but for the other functions
it's only ever 0/1 which translates to success/error so rc is ok.

>  	page_ref_unfreeze(page, expected);
> -	/* Return -ENXIO if the page was not mapped, -EINVAL otherwise */
> -	if (rc)
> +	/*
> +	 * Return -ENXIO if the page was not mapped, -EINVAL for other errors.
> +	 * If busy or partially completed, return -EAGAIN.
> +	 */
> +	if (rc == 1)
>  		rc = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
> +	else if (rc > 1)
> +		rc = -EAGAIN;
>  	return rc;

Could you define the CCs in uv.h and check against the constants here so
it's easier to understand that the rc > 1 checks against a "UV was busy
please re-issue the call again" cc?

Maybe also make it explicit for cc 2 and 3 instead of cc > 1

>  }
>  
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index c8841f476e91..e007df11a2fe 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -196,7 +196,7 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>  	uvcb.conf_base_stor_origin = (u64)kvm->arch.pv.stor_base;
>  	uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
>  
> -	cc = uv_call(0, (u64)&uvcb);
> +	cc = uv_call_sched(0, (u64)&uvcb);
>  	*rc = uvcb.header.rc;
>  	*rrc = uvcb.header.rrc;
>  	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
> 

