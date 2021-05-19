Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC448388B64
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 12:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347325AbhESKN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 06:13:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49634 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239579AbhESKNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 06:13:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JA5s92172229;
        Wed, 19 May 2021 10:12:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6gsim/e0/sH9sRE2x3oYlLhZp/gycpL6fdCJ0rKcCfI=;
 b=ZOSUzB3wfVT+wwlxiEyP65q9MBH04b0KUtz4yyL5ohKOjcQWQO/8I2nvkJPVMbT739wc
 OOxoQbDijP2zonVyzn2dKNswF5fen5zKZx2vuAOu71nJ4+pfPm13FvOvvuRHSiroUBty
 wDtH3R8sHeAUsfZgE/KiJZZ7S3kn1YGwHI0RplQod7rbI44cTKS2sB8//H+HUg/b+MGy
 doOJ+ebnvXCtT6ZW7MLOjmg0D4C5t6KuFtYdD+ONzlCTsqXicHp0CBIuTr22fquGrNhQ
 2kLTHvXe7NS6N6UkRjkqQiKnfSdYVTU6CcxSzVWAnGYZ7VHqXYvXPX5ugKyIBZUdoIN6 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38j6xnh1qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 10:12:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JA5s0Y045768;
        Wed, 19 May 2021 10:12:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 38mechqcxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 10:12:14 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14JA6WwH053027;
        Wed, 19 May 2021 10:12:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 38mechqcw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 10:12:14 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 14JACALZ006865;
        Wed, 19 May 2021 10:12:10 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 May 2021 03:12:10 -0700
Date:   Wed, 19 May 2021 13:11:49 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Anup Patel <anup.patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH v18 14/18] RISC-V: KVM: Implement ONE REG interface for
 FP registers
Message-ID: <20210519101149.GS1955@kadam>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
 <20210519033553.1110536-15-anup.patel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519033553.1110536-15-anup.patel@wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: cHcD0Ne08M-eDvFMU9La0STty0w6mH1R
X-Proofpoint-ORIG-GUID: cHcD0Ne08M-eDvFMU9La0STty0w6mH1R
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9988 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 09:05:49AM +0530, Anup Patel wrote:
>  static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
>  				  const struct kvm_one_reg *reg)
>  {
> @@ -427,6 +519,12 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
>  		return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
>  	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
>  		return kvm_riscv_vcpu_set_reg_timer(vcpu, reg);
> +	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_F)
> +		return kvm_riscv_vcpu_set_reg_fp(vcpu, reg,
> +						 KVM_REG_RISCV_FP_F);
> +	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_D)
> +		return kvm_riscv_vcpu_set_reg_fp(vcpu, reg,
> +						 KVM_REG_RISCV_FP_D);
>  
>  	return -EINVAL;
>  }
> @@ -442,6 +540,12 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
>  		return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
>  	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
>  		return kvm_riscv_vcpu_get_reg_timer(vcpu, reg);
> +	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_F)
> +		return kvm_riscv_vcpu_get_reg_fp(vcpu, reg,
> +						 KVM_REG_RISCV_FP_F);
> +	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_D)
> +		return kvm_riscv_vcpu_get_reg_fp(vcpu, reg,
> +						 KVM_REG_RISCV_FP_D);

These have become unwieldy.  Use a switch statement:

	switch (reg->id & KVM_REG_RISCV_TYPE_MASK) {
	case KVM_REG_RISCV_TIMER:
		return kvm_riscv_vcpu_get_reg_timer(vcpu, reg);
regards,
dan carpenter

