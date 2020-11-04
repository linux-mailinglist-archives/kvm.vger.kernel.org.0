Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E1A2A6CAA
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 19:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732368AbgKDS3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 13:29:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726801AbgKDS3b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 13:29:31 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A4ICSt9006764
        for <kvm@vger.kernel.org>; Wed, 4 Nov 2020 13:29:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JyVFIhZrj3CiXNEKWRFfus+6K26LOcHvX2hU+zqwL9I=;
 b=Xb4ka38VOFjjZnX1sW4XYW1BjVP09WFK9cMRIUMdaX83OtMh92QFNIa/1+JGGgM1WDVz
 Q7JDP1KGA+4pgrBP3u+KdcF1BBVajBjTbTm7zdUMnoi7op4/Ed2yeLypgWfF4QDeTBek
 mgK+7yR1fIYJ/nMUCKQKgF1Tbn0gkg8vgxqZn0ZZHXU/PF968AYtD/5M0cGsblWwtIm2
 E0pGMuG6nwGj1PuamoommFE04olEvzv8yhZyxvpLii48SVygQrJmRYZRdq3obXsCwUEo
 OWiMJ8gL3MqQvQpMVbF4e8Rak68JgYhu30bs+Ie7O+6yW+6U8nKcT1eHEFwSloPF8Vyd 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34m0qchnnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 04 Nov 2020 13:29:30 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A4ICcge007196
        for <kvm@vger.kernel.org>; Wed, 4 Nov 2020 13:29:30 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34m0qchngx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 13:29:29 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A4ISeBa002333;
        Wed, 4 Nov 2020 18:29:19 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 34h0f6tc1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 18:29:19 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A4ITG6263308278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Nov 2020 18:29:16 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B97AAE04D;
        Wed,  4 Nov 2020 18:29:16 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EFBFAE045;
        Wed,  4 Nov 2020 18:29:15 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.56.249])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 Nov 2020 18:29:15 +0000 (GMT)
Subject: Re: [PATCH] s390/kvm: remove diag318 reset code
To:     Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org
Cc:     gor@linux.ibm.com, hca@linux.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, david@redhat.com, frankja@linux.ibm.com
References: <20201104181032.109800-1-walling@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <246ca4c9-2b46-f4c3-3fde-6308b08543bc@de.ibm.com>
Date:   Wed, 4 Nov 2020 19:29:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201104181032.109800-1-walling@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-04_12:2020-11-04,2020-11-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 clxscore=1015 mlxlogscore=999 impostorscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040130
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

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

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
