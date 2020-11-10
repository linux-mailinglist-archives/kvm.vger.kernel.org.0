Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A892AD720
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 14:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbgKJNJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 08:09:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730124AbgKJNJi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 08:09:38 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AAD61hl078136
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 08:09:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=u1B6ob8U3IdVPh7QaX6NxZlRN7UKsWnXI3uPe2rFlr4=;
 b=hD7PMzO846ZblIYVnoMNh2FdhcL+ELMItd4PfQwFDN6yW3dWtGF/8bs5JP3t6ZPr0Hml
 uTDtee5P6x9bskCqHFAhPwEdxqUPWK4EgJdhU0Ao2XADsHJMkmfWPG1UOCZCBOgJbNjo
 0rQ0Dcub02CAQW7GhJ65uQNE4O1/6fJrvNT1kjLUla4SOHfqijgRatgaCbIBzsXDt3LD
 7x0ko8dL9YvN/obHeUw737RxZw2VgrQLo1Cyg22tvO9N5ODNN99OxJCxbpyQqbh0V+81
 Kc4WRXItJ7tBVrHWwVoisKCd+sSVmSOA2JsWuBn5YG71eiFxruDDJTv0qOZp0TAOOUrO wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34qta924pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 08:09:37 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AAD7gCB086867
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 08:09:36 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34qta924nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 08:09:36 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AAD1qlc010961;
        Tue, 10 Nov 2020 13:09:35 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 34njuh35kw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 13:09:34 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AAD9WMt65732934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 13:09:32 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEBF64C06A;
        Tue, 10 Nov 2020 13:09:31 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7602E4C062;
        Tue, 10 Nov 2020 13:09:31 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.80.78])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Nov 2020 13:09:31 +0000 (GMT)
Subject: Re: [PATCH] s390/kvm: remove diag318 reset code
To:     Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org
Cc:     gor@linux.ibm.com, hca@linux.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, david@redhat.com, frankja@linux.ibm.com
References: <20201104181032.109800-1-walling@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <81080b0f-94b5-acca-dbd3-696db8ebb6f5@de.ibm.com>
Date:   Tue, 10 Nov 2020 14:09:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201104181032.109800-1-walling@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_05:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011100089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04.11.20 19:10, Collin Walling wrote:
> The diag318 data must be set to 0 by VM-wide reset events
> triggered by diag308. As such, KVM should not handle
> resetting this data via the VCPU ioctls.
> 
> Fixes: 23a60f834406 (s390/kvm: diagnose 0x318 sync and reset)
> Signed-off-by: Collin Walling <walling@linux.ibm.com>

thanks. Applied. 

> ---
>  arch/s390/kvm/kvm-s390.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6b74b92c1a58..f9e118a0e113 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3564,7 +3564,6 @@ static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>  		vcpu->arch.sie_block->pp = 0;
>  		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
>  		vcpu->arch.sie_block->todpr = 0;
> -		vcpu->arch.sie_block->cpnc = 0;
>  	}
>  }
>  
> @@ -3582,7 +3581,6 @@ static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
>  
>  	regs->etoken = 0;
>  	regs->etoken_extension = 0;
> -	regs->diag318 = 0;
>  }
>  
>  int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> 
