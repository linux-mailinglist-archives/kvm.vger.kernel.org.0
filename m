Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5052843C246
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 07:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239607AbhJ0Fjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 01:39:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30658 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239564AbhJ0Fji (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 01:39:38 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R4iK1a025951;
        Wed, 27 Oct 2021 05:37:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TvPt6RXIE1nRa+PxByOHawZVcPgwNkqAj2SkpYSoSxQ=;
 b=gesyc+kcx37cB+jHxcUvc8zLGelGL/QgMzAEWGucXnbNnEUPcagSAZtJoyWOab608W3y
 0pl2LY5WydOK89JPjqVDlfX0i7pyy4rYoJ8If8ichj/laRMSzkzW1RxHBCzrjz5HwPsY
 gjK6XPaAHlzTMe4EjSvV9PkdeFLUHrs2UXUxhWcZcJOTVKQDihR4FZlS5Gbb8adJ9IDJ
 VypT3p5JARJpg5WXaIdQyNpwlaHBOTT7DTiLy6fKUJmqJG8xVFvg2DLTccVRGdW4iOhL
 Jtm+P3Jx93ZJOkCtdPxtlvx8Os8nALRvUYP3QfJ9vzW8gPPQVXbDDSs4lyLY9LF+3QHW hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bxw2jen21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 05:37:13 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19R5NshC019961;
        Wed, 27 Oct 2021 05:37:13 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bxw2jen1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 05:37:13 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19R5SRo7010340;
        Wed, 27 Oct 2021 05:37:10 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3bx4et3jry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 05:37:10 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19R5b7TS59375876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 05:37:07 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BD94AE056;
        Wed, 27 Oct 2021 05:37:07 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D884AE051;
        Wed, 27 Oct 2021 05:37:07 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.78.35])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Oct 2021 05:37:07 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390x: add debug statement for diag 318 CPNC data
To:     Collin Walling <walling@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com
References: <20211027025451.290124-1-walling@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <ab36ddd3-1a05-ec6a-3c6e-a8881956d0e2@de.ibm.com>
Date:   Wed, 27 Oct 2021 07:37:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211027025451.290124-1-walling@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: quk-Ga8myb9MeGnYIQ4z25DDQIY6I-kW
X-Proofpoint-GUID: T4FZ6wxo2EF-HtsxKhfeFei_7rKky1mA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_01,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270033
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 27.10.21 um 04:54 schrieb Collin Walling:
> The diag 318 data contains values that denote information regarding the
> guest's environment. Currently, it is unecessarily difficult to observe
> this value (either manually-inserted debug statements, gdb stepping, mem
> dumping etc). It's useful to observe this information to obtain an
> at-a-glance view of the guest's environment, so lets add a simple VCPU
> event that prints the CPNC to the s390dbf logs.
> 
> Signed-off-by: Collin Walling <walling@linux.ibm.com>

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

And it even finds a bug in QEMU. We clear the CPNC on local CPU resets.
Can you have a look? I think we just have to move the cpnc in the env
field from the normal/initial reset range to the full reset range.
> ---
>   arch/s390/kvm/kvm-s390.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6a6dd5e1daf6..da3ff24eabd0 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4254,6 +4254,7 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
>   	if (kvm_run->kvm_dirty_regs & KVM_SYNC_DIAG318) {
>   		vcpu->arch.diag318_info.val = kvm_run->s.regs.diag318;
>   		vcpu->arch.sie_block->cpnc = vcpu->arch.diag318_info.cpnc;
> +		VCPU_EVENT(vcpu, 2, "setting cpnc to %d", vcpu->arch.diag318_info.cpnc);
>   	}
>   	/*
>   	 * If userspace sets the riccb (e.g. after migration) to a valid state,
> 
