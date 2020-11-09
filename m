Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3110F2AB1E4
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 08:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgKIHul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 02:50:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60438 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728904AbgKIHul (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Nov 2020 02:50:41 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A97VXdf003044
        for <kvm@vger.kernel.org>; Mon, 9 Nov 2020 02:50:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=I+tE6d1QwklQHWXzQy1SXSL6MeYt9+56t3YGruSwg28=;
 b=X/ZBCpjfx372Eyz6ZVjBwcdavUfzuQwAsIJR2rx6bOq28VwUrngncHyQMZR4ihKPoLid
 adiP0Tj9EJ9N6/jvyWtcSeeehO8Q0iJdrNphgsVeHrveER4tQw2QLPZLyKGd2O8JOYmF
 8x5iAm47Euo7T53ND0hA7vwBXe82RjbtQs7OlqqVS/Z0uSTOLyem3LQCBkyEZTWDPv8m
 tHF/bfjbdes0e8c3Qs0MOVNbXe+QD87pRgwGLS+U80Aw6r6zxopwG8tBBQgW0SsFcEQk
 BmbRX8pPylBm4D7zMFZOME1MisHuF8+BPCHmYRnC6e2Sv3SbkXpDFEPUHqoJjWNGYpSm pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34nrevw6bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Nov 2020 02:50:39 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A97WFc9006265
        for <kvm@vger.kernel.org>; Mon, 9 Nov 2020 02:50:39 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34nrevw6ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 02:50:39 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A97mNq3005430;
        Mon, 9 Nov 2020 07:50:37 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 34q084018h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 07:50:37 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A97oYUv5440122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Nov 2020 07:50:34 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99A42A405C;
        Mon,  9 Nov 2020 07:50:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35C43A4054;
        Mon,  9 Nov 2020 07:50:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.58])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Nov 2020 07:50:34 +0000 (GMT)
Subject: Re: [PATCH] s390/kvm: remove diag318 reset code
To:     Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org
Cc:     gor@linux.ibm.com, hca@linux.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, david@redhat.com, borntraeger@de.ibm.com
References: <20201104181032.109800-1-walling@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <1055e30c-1fc7-7819-ce29-47dee4860223@linux.ibm.com>
Date:   Mon, 9 Nov 2020 08:50:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201104181032.109800-1-walling@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_02:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090042
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/20 7:10 PM, Collin Walling wrote:
> The diag318 data must be set to 0 by VM-wide reset events
> triggered by diag308. As such, KVM should not handle
> resetting this data via the VCPU ioctls.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> 
> Fixes: 23a60f834406 (s390/kvm: diagnose 0x318 sync and reset)
> Signed-off-by: Collin Walling <walling@linux.ibm.com>
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

