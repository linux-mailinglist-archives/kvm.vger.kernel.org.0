Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A9E42277D
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbhJENNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:13:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16375 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234981AbhJENNt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:13:49 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195D46EQ024082;
        Tue, 5 Oct 2021 09:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sn8JNMLsVNgRbSJzI/EzW7A8UP/FvqC8QJg8zhzAmuU=;
 b=XEx53wdm/hC57fjBZ3IDq1HC0qFvvAxNXSHcouJhewKVWUDipMzJUSOU1BQjejlVsjkU
 8rBy24BwCTzBlRBqlNjaN+UL7Zsfv+hNh6rdmcGkHQhgb25LYMWGHN7RveVTex7SZFuC
 r6JyNU4GU6KOmiIu9gjmbnd9KZ6Z3qX5sx5fwLZ+3hBusNXyNc/8+PvxVZLe7oyWnFg1
 3Vd3VJ99iWYg84Tn4ZHlvAn6y0BZOIXISmrkGFTf6wQl+IrL2wG49wa4eqU3E+TD1qAo
 XSzvqWKMgvogvsebdb/k7r6UKyplIabdIUzZsuzhI/yKb9PshCHkYTNnuofdefR9q4I8 nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgnm9avh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:11:58 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 195D4Y9p026132;
        Tue, 5 Oct 2021 09:11:57 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgnm9avgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:11:57 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195D66G4009972;
        Tue, 5 Oct 2021 13:11:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3bef29rg91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 13:11:55 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195DBmBH14745926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 13:11:48 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52798A40A0;
        Tue,  5 Oct 2021 13:11:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE0B0A4093;
        Tue,  5 Oct 2021 13:11:47 +0000 (GMT)
Received: from [9.145.45.132] (unknown [9.145.45.132])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Oct 2021 13:11:47 +0000 (GMT)
Message-ID: <440d852f-ae4e-7466-ecb8-c60890a6d849@linux.ibm.com>
Date:   Tue, 5 Oct 2021 15:11:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v5 02/14] KVM: s390: pv: avoid double free of sida page
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
 <20210920132502.36111-3-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20210920132502.36111-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rlPs-mcViv1av9yTZd3cnX5TYvyOk_an
X-Proofpoint-ORIG-GUID: psWW0_MgIlChGltkfi_5Ht2seQCSuHuk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_02,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 mlxlogscore=738 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/20/21 15:24, Claudio Imbrenda wrote:
> If kvm_s390_pv_destroy_cpu is called more than once, we risk calling
> free_page on a random page, since the sidad field is aliased with the
> gbea, which is not guaranteed to be zero.
> 
> This can happen, for example, if userspace calls the KVM_PV_DISABLE
> IOCTL, and it fails, and then userspace calls the same IOCTL again.
> This scenario is only possible if KVM has some serious bug or if the
> hardware is broken.
> 
> The solution is to simply return successfully immediately if the vCPU
> was already non secure.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 19e1227768863a1469797c13ef8fea1af7beac2c ("KVM: S390: protvirt: Introduce instruction data area bounce buffer")

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/kvm/pv.c | 19 +++++++++----------
>   1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index c8841f476e91..0a854115100b 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -16,18 +16,17 @@
>   
>   int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
>   {
> -	int cc = 0;
> +	int cc;
>   
> -	if (kvm_s390_pv_cpu_get_handle(vcpu)) {
> -		cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu),
> -				   UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
> +	if (!kvm_s390_pv_cpu_get_handle(vcpu))
> +		return 0;
> +
> +	cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu), UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
> +
> +	KVM_UV_EVENT(vcpu->kvm, 3, "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
> +		     vcpu->vcpu_id, *rc, *rrc);
> +	WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x", *rc, *rrc);
>   
> -		KVM_UV_EVENT(vcpu->kvm, 3,
> -			     "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
> -			     vcpu->vcpu_id, *rc, *rrc);
> -		WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x",
> -			  *rc, *rrc);
> -	}
>   	/* Intended memory leak for something that should never happen. */
>   	if (!cc)
>   		free_pages(vcpu->arch.pv.stor_base,
> 

