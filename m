Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4EF1AB7D6
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 08:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407296AbgDPGRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 02:17:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407332AbgDPGRa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 02:17:30 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03G68T15006598
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 02:17:29 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30eh6e140v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 02:17:29 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 16 Apr 2020 07:16:49 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 16 Apr 2020 07:16:46 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03G6GGIA41550158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Apr 2020 06:16:16 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90C624C05A;
        Thu, 16 Apr 2020 06:17:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19B0E4C044;
        Thu, 16 Apr 2020 06:17:22 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.162.92])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Apr 2020 06:17:22 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Fix PV check in deliverable_irqs()
To:     Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
References: <20200415190353.63625-1-farman@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Thu, 16 Apr 2020 08:17:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200415190353.63625-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20041606-0016-0000-0000-000003056BC2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041606-0017-0000-0000-000033696DD3
Message-Id: <e8720727-ceee-e668-2a52-54b2b5039087@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_01:2020-04-14,2020-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004160033
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.04.20 21:03, Eric Farman wrote:
> The diag 0x44 handler, which handles a directed yield, goes into a
> a codepath that does a kvm_for_each_vcpu() and ultimately
> deliverable_irqs().  The new check for kvm_s390_pv_cpu_is_protected()
> contains an assertion that the vcpu->mutex is held, which isn't going
> to be the case in this scenario.
> 
> The result is a plethora of these messages if the lock debugging
> is enabled, and thus an implication that we have a problem.
> 
>   WARNING: CPU: 9 PID: 16167 at arch/s390/kvm/kvm-s390.h:239 deliverable_irqs+0x1c6/0x1d0 [kvm]
>   ...snip...
>   Call Trace:
>    [<000003ff80429bf2>] deliverable_irqs+0x1ca/0x1d0 [kvm]
>   ([<000003ff80429b34>] deliverable_irqs+0x10c/0x1d0 [kvm])
>    [<000003ff8042ba82>] kvm_s390_vcpu_has_irq+0x2a/0xa8 [kvm]
>    [<000003ff804101e2>] kvm_arch_dy_runnable+0x22/0x38 [kvm]
>    [<000003ff80410284>] kvm_vcpu_on_spin+0x8c/0x1d0 [kvm]
>    [<000003ff80436888>] kvm_s390_handle_diag+0x3b0/0x768 [kvm]
>    [<000003ff80425af4>] kvm_handle_sie_intercept+0x1cc/0xcd0 [kvm]
>    [<000003ff80422bb0>] __vcpu_run+0x7b8/0xfd0 [kvm]
>    [<000003ff80423de6>] kvm_arch_vcpu_ioctl_run+0xee/0x3e0 [kvm]
>    [<000003ff8040ccd8>] kvm_vcpu_ioctl+0x2c8/0x8d0 [kvm]
>    [<00000001504ced06>] ksys_ioctl+0xae/0xe8
>    [<00000001504cedaa>] __s390x_sys_ioctl+0x2a/0x38
>    [<0000000150cb9034>] system_call+0xd8/0x2d8
>   2 locks held by CPU 2/KVM/16167:
>    #0: 00000001951980c0 (&vcpu->mutex){+.+.}, at: kvm_vcpu_ioctl+0x90/0x8d0 [kvm]
>    #1: 000000019599c0f0 (&kvm->srcu){....}, at: __vcpu_run+0x4bc/0xfd0 [kvm]
>   Last Breaking-Event-Address:
>    [<000003ff80429b34>] deliverable_irqs+0x10c/0x1d0 [kvm]
>   irq event stamp: 11967
>   hardirqs last  enabled at (11975): [<00000001502992f2>] console_unlock+0x4ca/0x650
>   hardirqs last disabled at (11982): [<0000000150298ee8>] console_unlock+0xc0/0x650
>   softirqs last  enabled at (7940): [<0000000150cba6ca>] __do_softirq+0x422/0x4d8
>   softirqs last disabled at (7929): [<00000001501cd688>] do_softirq_own_stack+0x70/0x80
> 
> Considering what's being done here, let's fix this by removing the
> mutex assertion rather than acquiring the mutex for every other vcpu.
> 
> Fixes: 201ae986ead7 ("KVM: s390: protvirt: Implement interrupt injection")

Yes, when adding that check I missed that path. We do have other places that use
kvm_s390_pv_cpu_get_handle instead of kvm_s390_pv_cpu_is_protected when we know
that this place has cases without the mutex being hold. And yes kvm_vcpu_on_spin
is such a place. 

The alternative would be to copy kvm_s390_vcpu_has_irq into a newly create
s390 version of kvm_arch_dy_runnable with a private copy of kvm_s390_vcpu_has_irq.
I think your patch is preferrable as it avoids code duplication with just tiny 
difference. After all it is just a sanity check.

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>


> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  arch/s390/kvm/interrupt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 8191106bf7b9..bfb481134994 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -393,7 +393,7 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
>  	if (psw_mchk_disabled(vcpu))
>  		active_mask &= ~IRQ_PEND_MCHK_MASK;
>  	/* PV guest cpus can have a single interruption injected at a time. */
> -	if (kvm_s390_pv_cpu_is_protected(vcpu) &&
> +	if (kvm_s390_pv_cpu_get_handle(vcpu) &&
>  	    vcpu->arch.sie_block->iictl != IICTL_CODE_NONE)
>  		active_mask &= ~(IRQ_PEND_EXT_II_MASK |
>  				 IRQ_PEND_IO_MASK |
> 

