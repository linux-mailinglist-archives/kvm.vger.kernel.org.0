Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0EF3B14A3
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 09:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhFWHdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 03:33:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48500 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229864AbhFWHdA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 03:33:00 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N75fFV140226;
        Wed, 23 Jun 2021 03:30:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=F7bt4O/05Kr+Qx023Omcae80hPDtTuF2fh/gQbJdv3I=;
 b=e5NADUSKgYEbpkJXT9ZOrpawt2y828fpOQtzR5YfVc7+L7ugat5LTbsNrugkzUbCH2qD
 eSZvKila01nQ2faqpYwnhwYQomXoDWFlof+/5efqX20G4y6t6cfEeYv3vqpq30AF8kY2
 0H0NeALPew8/WXSOHRdYitCa/L/0M+KnaScbyKLpWHlNUDC0q54kIiFEUvLQjH1i8L+p
 TWYDXTbDX30kpRexQYFmzXOneA095A5l6zr6lg5MyAtWylhI5wPvVIb4oD4CXGKnLy4E
 EW2Dfnqm7kKBGHKemRT08h5WCNkNareRW4DOIFdlv5GuvbLX63x0uCpcBnsJm7g0cSGN 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39btvr0bpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jun 2021 03:30:42 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15N75rNa141005;
        Wed, 23 Jun 2021 03:30:42 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39btvr0bnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jun 2021 03:30:42 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15N7Uek3030439;
        Wed, 23 Jun 2021 07:30:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3997uhh0t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jun 2021 07:30:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15N7UbtK30867946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 07:30:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6142DA4055;
        Wed, 23 Jun 2021 07:30:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC8EAA4059;
        Wed, 23 Jun 2021 07:30:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.77.251])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Jun 2021 07:30:36 +0000 (GMT)
Subject: Re: [PATCH 2/2] KVM: s390: allow facility 192
 (vector-packed-decimal-enhancement facility 2)
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20210622143412.143369-1-borntraeger@de.ibm.com>
 <20210622143412.143369-3-borntraeger@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <27a7078e-955e-3676-eb14-a6bf529c9842@linux.ibm.com>
Date:   Wed, 23 Jun 2021 09:30:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622143412.143369-3-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EHkt6FpbDok4T7ZukAbl03OMjqDyvFCu
X-Proofpoint-ORIG-GUID: mVMMWCD_oEJbZMYdlqyCXej9XQY_WWP_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_02:2021-06-22,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106230041
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/21 4:34 PM, Christian Borntraeger wrote:
> pass through newer vector instructions if vector support is enabled.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 1296fc10f80c..0d59f9331649 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -713,6 +713,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  				set_kvm_facility(kvm->arch.model.fac_mask, 152);
>  				set_kvm_facility(kvm->arch.model.fac_list, 152);
>  			}
> +			if (test_facility(192)) {
> +				set_kvm_facility(kvm->arch.model.fac_mask, 192);
> +				set_kvm_facility(kvm->arch.model.fac_list, 192);
> +			}
>  			r = 0;
>  		} else
>  			r = -EINVAL;
> 

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
