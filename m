Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E883C4344EE
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 08:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhJTGKr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 02:10:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229809AbhJTGKj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 02:10:39 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K3GlLn014863;
        Wed, 20 Oct 2021 02:08:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=hm7pxpcPCv47Cs95QUQBpva3Yx4/ZtHWVhsqmNZe7IE=;
 b=Kq8stTwgxQN5is3yYzR2C5NcrmKNHdjuD5Ww2Kw63kdtm9FFN16cS7ojtxYN3QCjXTEZ
 V3IntHxueOu/Z9ueYvVWokgOyKbLGm25TTQkaIpCkxCSD2+OHZqXs6Qv2CYp+dzRMZrp
 vwEQuiZCSgQCV9rC3g+8aWhOtouSNSSpZgaIxlZyzZPGdSAXOTvcLu1BonS7D8qpwwXM
 K5OEgtaOO4dcsZSz95dixvWisKl2Xx8LspUE0Sm+oJYOwLOlErTZ7vJ52PnrGJBXb0Nt
 9WpYHvoICob+31qKbwtY9h058kYvMLhAyhftGr8A335ehW1RVoWCDk9fuZa95dIbw3hG ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btb2qjtx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 02:08:25 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19K60CfC023639;
        Wed, 20 Oct 2021 02:08:25 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btb2qjtw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 02:08:25 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19K68DsZ015884;
        Wed, 20 Oct 2021 06:08:23 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3bqpcas319-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 06:08:22 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19K68JqM43712900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 06:08:19 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B965442049;
        Wed, 20 Oct 2021 06:08:19 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA0DF42045;
        Wed, 20 Oct 2021 06:08:18 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.68])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Oct 2021 06:08:18 +0000 (GMT)
Date:   Wed, 20 Oct 2021 08:08:16 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: s390: clear kicked_mask before sleeping again
Message-ID: <20211020080816.69d26708@p-imbrenda>
In-Reply-To: <1641267f-3a23-aba1-ab50-6f7c15e44528@de.ibm.com>
References: <20211019175401.3757927-1-pasic@linux.ibm.com>
        <20211019175401.3757927-2-pasic@linux.ibm.com>
        <20211020073515.3ad4c377@p-imbrenda>
        <1641267f-3a23-aba1-ab50-6f7c15e44528@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: doNjs0D7S2kippR5Tr8jzz6oxhMVU78g
X-Proofpoint-ORIG-GUID: SwkD9A43gLhruvfonqeL2j53EprFmhR-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 clxscore=1011 lowpriorityscore=0 suspectscore=0
 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200032
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Oct 2021 08:03:40 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am 20.10.21 um 07:35 schrieb Claudio Imbrenda:
> > On Tue, 19 Oct 2021 19:53:59 +0200
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> >   
> >> The idea behind kicked mask is that we should not re-kick a vcpu that
> >> is already in the "kick" process, i.e. that was kicked and is
> >> is about to be dispatched if certain conditions are met.
> >>
> >> The problem with the current implementation is, that it assumes the
> >> kicked vcpu is going to enter SIE shortly. But under certain
> >> circumstances, the vcpu we just kicked will be deemed non-runnable and
> >> will remain in wait state. This can happen, if the interrupt(s) this
> >> vcpu got kicked to deal with got already cleared (because the interrupts
> >> got delivered to another vcpu). In this case kvm_arch_vcpu_runnable()
> >> would return false, and the vcpu would remain in kvm_vcpu_block(),
> >> but this time with its kicked_mask bit set. So next time around we
> >> wouldn't kick the vcpu form __airqs_kick_single_vcpu(), but would assume
> >> that we just kicked it.
> >>
> >> Let us make sure the kicked_mask is cleared before we give up on
> >> re-dispatching the vcpu.
> >>
> >> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> >> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
> >> Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")
> >> ---
> >>   arch/s390/kvm/kvm-s390.c | 1 +
> >>   1 file changed, 1 insertion(+)
> >>
> >> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> >> index 6a6dd5e1daf6..1c97493d21e1 100644
> >> --- a/arch/s390/kvm/kvm-s390.c
> >> +++ b/arch/s390/kvm/kvm-s390.c
> >> @@ -3363,6 +3363,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >>   
> >>   int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
> >>   {
> >> +	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);  
> > 
> > so, you unconditionally clear the flag, before knowing if the vCPU is
> > runnable?
> > 
> > from your description I would have expected to only clear the bit if
> > the vCPU is not runnable.
> > 
> > would things break if we were to try to kick the vCPU again after
> > clearing the bit, but before dispatching it?  
> 
> The whole logic is just an optimization to avoid unnecessary wakeups.
> When the bit is set a wakup might be omitted.
> I prefer to do an unneeded wakeup over not doing a wakeup so I think
> over-clearing is safer.
> In fact, getting rid of this micro-optimization would be a valid
> alternative.

my only concern was if things would break in case we kick the vCPU
again after clearing the bit; it seems nothing breaks, so I'm ok with it

> >   
> >>   	return kvm_s390_vcpu_has_irq(vcpu, 0);
> >>   }
> >>     
> >   

