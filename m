Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F82E434641
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 09:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhJTHyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 03:54:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24022 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229503AbhJTHyd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 03:54:33 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K6iB6r011722;
        Wed, 20 Oct 2021 03:52:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=q5de9NsjcUlxTjFhuifPOey8eSlbyYuWuXYhNSMUUTw=;
 b=RC0dnvNM+ygqj743dUDbp+h8zKn6PL5OGsLw9z3CCfWApBlQLq7DCeIsikbeOebFMrTb
 pUJO9uW3Q1auVg7x4YI3F1eT314B7py0fp2xjPe/qIa1SJ7NK7rc37SwbSaW62kCx34x
 zjJR2Zy+B+eznucqOXUrfjxz1FgnKrWrwfH+L5DUvXVWi+6R7dbJrGAdAvbM14wAl9fg
 Zz7B70JeWHoVhWLQwRn+cZYFq29Kznb56/NpVGLVBNo9kaLbTGSx1fbQbcEbGmyl47JF
 qsWNjVyLlmzK52wO6UrxElS6imQGDLDop2VYFilXa1sBFfWmEp5LVBvFAigajjZeCYUV Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bt8erqbmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 03:52:17 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19K7YRbP014719;
        Wed, 20 Oct 2021 03:52:17 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bt8erqbkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 03:52:16 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19K7hVXT029439;
        Wed, 20 Oct 2021 07:52:15 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3bqpc9qjc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 07:52:15 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19K7kLHV49086834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 07:46:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8E0642047;
        Wed, 20 Oct 2021 07:52:11 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA39C4204C;
        Wed, 20 Oct 2021 07:52:10 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.29.112])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 20 Oct 2021 07:52:10 +0000 (GMT)
Date:   Wed, 20 Oct 2021 09:52:08 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 3/3] KVM: s390: clear kicked_mask if not idle after set
Message-ID: <20211020095208.5e34679a.pasic@linux.ibm.com>
In-Reply-To: <c5c84a99-c56a-2232-7574-a6d207d7c11f@de.ibm.com>
References: <20211019175401.3757927-1-pasic@linux.ibm.com>
        <20211019175401.3757927-4-pasic@linux.ibm.com>
        <c5c84a99-c56a-2232-7574-a6d207d7c11f@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6ymktboXP1mo8IuDPaF18MKXQ1kyE6PN
X-Proofpoint-ORIG-GUID: ufZLra34ohiHToLeH_Ep1qbdjrpG8_w2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200040
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Oct 2021 23:35:25 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> > @@ -426,6 +426,7 @@ static void __unset_cpu_idle(struct kvm_vcpu *vcpu)
> >   {
> >   	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_WAIT);
> >   	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.idle_mask);
> > +	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);

BTW, do you know are bit-ops garanteed to be serialized as seen by
another cpu even when acting on a different byte? I mean
could the kick_single_vcpu() set the clear of the kicked_mask bit but
not see the clear of the idle mask?

If that is not true we may need some barriers, or possibly merging the
two bitmasks like idle bit, kick bit alterating to ensure there
absolutely ain't no race.


> >   }
> >   
> >   static void __reset_intercept_indicators(struct kvm_vcpu *vcpu)
> > @@ -3064,7 +3065,11 @@ static void __airqs_kick_single_vcpu(struct kvm *kvm, u8 deliverable_mask)
> >   			/* lately kicked but not yet running */
> >   			if (test_and_set_bit(vcpu_idx, gi->kicked_mask))
> >   				return;
> > -			kvm_s390_vcpu_wakeup(vcpu);
> > +			/* if meanwhile not idle: clear  and don't kick */
> > +			if (test_bit(vcpu_idx, kvm->arch.idle_mask))
> > +				kvm_s390_vcpu_wakeup(vcpu);
> > +			else
> > +				clear_bit(vcpu_idx, gi->kicked_mask);  
> 
> I think this is now a bug. We should not return but continue in that case, no?
> 

I don't think so. The purpose of this function is to kick a *single* vcpu
that can handle *some* of the I/O interrupts indicated by the
deliverable_mask. The deliverable mask predates the check of the idle_mask.
I believe if we selected a suitable vcpu, that was idle and before we
actually do a wakeup on it we see that it isn't idle any more, I believe
it is as good if not better as performing the wakeup (and a new wakeup()
call is pointless: this vcpu either already got the the irqs it can get,
or is about to enter SIE soon to do so. We just saved a pointless call
to wakeup().

> 
> I think it might be safer to also clear kicked_mask in __set_cpu_idle

It would not hurt, but my guess is that kvm_arch_vcpu_runnable() before
we really decide to go to sleep:

void kvm_vcpu_block(struct kvm_vcpu *vcpu)                                      
{ 
[..]
        for (;;) {                                                              
                set_current_state(TASK_INTERRUPTIBLE);                          
                                                                                
                if (kvm_vcpu_check_block(vcpu) < 0)     <=== calls runnable()                        
                        break;                                                  
                                                                                
                waited = true;                                                  
                schedule();                                                     
        } 

>  From a CPUs perspective: We have been running and are on our way to become idle.
> There is no way that someone kicked us for a wakeup. In other words as long as we
> are running, there is no point in kicking us but when going idle we should get rid
> of old kick_mask bit.
> Doesnt this cover your scenario?

In practice probably yes, in theory I don't think so. I hope this is
more of a theoretical problem than a practical one anyway. But let me
discuss the theory anyway.

Under the assumption that an arbitrary amount of time can pass between 
1) for_each_set_bit finds the vcpus bit in the idle mask set
and
2) test_and_set_bit(kicked_mask) that returns a false (bit was not set,
and we did set it)
then if we choose an absurdly large amount of time, it is possible that
we are past a whole cycle: an __unset_cpu_ilde() and an __set_cpu_idle()
but we didn't reach set_current_state(TASK_INTERRUPTIBLE). If
we set the bit at a suitable place there we theoretically may end up
in a situation where the wakeup is ineffective because the state didn't
change yet, but the bit gets set. So we end up in a stable sleeps and
does not want to get woken up state. If the clear in
kvm_arch_vcpu_runnable() does not save us... It could be that, that
clear alone is sufficient. Because, before we really go to sleep we kind
of attempt to wake up, and this guy clears on every attempted wakeup. So
the clear in kvm_arch_vcpu_runnable() may be the only clear we need. Or?

Anyway the scenario I described is very very far fetched I guess, but I
prefer solutions that are theoretically race free over solutions that
are practically race free if performance does not suffer.

Regards,
Halil
