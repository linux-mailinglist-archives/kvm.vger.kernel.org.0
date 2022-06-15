Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310ED54C5C0
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 12:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiFOKTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 06:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237034AbiFOKT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 06:19:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8BF427F1;
        Wed, 15 Jun 2022 03:19:26 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25F8Bx8Z020509;
        Wed, 15 Jun 2022 10:19:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ysak+bOxf2WK1p19LI1YGYc6xtN+QIwFGyYHHce1LNw=;
 b=fl/as7pRKi3oyNScMPATmNbfNK0YO0fx4MY8Nmx1KOKF45ra5zOxC46BcuDxhAgmdwGK
 8lpqil8DUVLtYPtuBo3s/WrMiboehDAE0U/MUvsUqtvXpF1BL52bO891dH1n0IbDYo+x
 hGpL4Vh6U73FJEjLhUIn2R0jCQgPGTaqu0L8aPUqriUYr9UZtt0kdBrc8nDjtdVBtKn4
 XZQA/Kqa39MSQkedDiHf4IZi487So2B+yR1jIrzx4Sz5BamJE/ARFacj7/VxP8Sx0KEF
 ADQVS/obYxeom9+IYE3vZVps/emG0sH2ULTbDPKr8pQaPEmeAnWadTVVgG2TdHMmFKzy xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gq8e4raju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 10:19:25 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25F8Rclr016427;
        Wed, 15 Jun 2022 10:19:25 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gq8e4raj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 10:19:25 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25FA6TT1018252;
        Wed, 15 Jun 2022 10:19:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3gmjp94c9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 10:19:23 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25FAJNmS25493976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 10:19:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3648411C04A;
        Wed, 15 Jun 2022 10:19:20 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D63411C050;
        Wed, 15 Jun 2022 10:19:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.67])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 Jun 2022 10:19:19 +0000 (GMT)
Date:   Wed, 15 Jun 2022 12:19:16 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v11 14/19] KVM: s390: pv: cleanup leftover protected VMs
 if needed
Message-ID: <20220615121916.77b039af@p-imbrenda>
In-Reply-To: <0a13397a-86e0-7c25-0044-7a5733f61730@linux.ibm.com>
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
        <20220603065645.10019-15-imbrenda@linux.ibm.com>
        <0a13397a-86e0-7c25-0044-7a5733f61730@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YMSFfob9GrASPT3jG10CkjicSGUSQwCW
X-Proofpoint-GUID: n1uBPQq9KFPwu3vX7eKS_Wchr_NSB4Rq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_03,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0
 impostorscore=0 phishscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206150039
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Jun 2022 11:59:36 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 6/3/22 08:56, Claudio Imbrenda wrote:
> > In upcoming patches it will be possible to start tearing down a
> > protected VM, and finish the teardown concurrently in a different
> > thread.  
> 
> s/,/
> s/the/its/

will fix

> 
> > 
> > Protected VMs that are pending for tear down ("leftover") need to be
> > cleaned properly when the userspace process (e.g. qemu) terminates.
> > 
> > This patch makes sure that all "leftover" protected VMs are always
> > properly torn down.  
> 
> So we're handling the kvm_arch_destroy_vm() case here, right?

yes

> Maybe add that in a more prominent way and rework the subject:
> 
> KVM: s390: pv: cleanup leftover PV VM shells on VM shutdown

ok, I'll change the description and rework the subject

> 
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   arch/s390/include/asm/kvm_host.h |   2 +
> >   arch/s390/kvm/kvm-s390.c         |   2 +
> >   arch/s390/kvm/pv.c               | 109 ++++++++++++++++++++++++++++---
> >   3 files changed, 104 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> > index 5824efe5fc9d..cca8e05e0a71 100644
> > --- a/arch/s390/include/asm/kvm_host.h
> > +++ b/arch/s390/include/asm/kvm_host.h
> > @@ -924,6 +924,8 @@ struct kvm_s390_pv {
> >   	u64 guest_len;
> >   	unsigned long stor_base;
> >   	void *stor_var;
> > +	void *prepared_for_async_deinit;
> > +	struct list_head need_cleanup;
> >   	struct mmu_notifier mmu_notifier;
> >   };
> >   
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index fe1fa896def7..369de8377116 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -2890,6 +2890,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >   	kvm_s390_vsie_init(kvm);
> >   	if (use_gisa)
> >   		kvm_s390_gisa_init(kvm);
> > +	INIT_LIST_HEAD(&kvm->arch.pv.need_cleanup);
> > +	kvm->arch.pv.prepared_for_async_deinit = NULL;
> >   	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
> >   
> >   	return 0;
> > diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> > index 6cffea26c47f..8471c17d538c 100644
> > --- a/arch/s390/kvm/pv.c
> > +++ b/arch/s390/kvm/pv.c
> > @@ -17,6 +17,19 @@
> >   #include <linux/mmu_notifier.h>
> >   #include "kvm-s390.h"
> >   
> > +/**
> > + * @struct leftover_pv_vm  
> 
> Any other ideas on naming these VMs?

not really

> Also I'd turn that around: pv_vm_leftover

I mean, it's a leftover protected VM, it felt more natural to name it
that way

> 
> > + * Represents a "leftover" protected VM that is still registered with the
> > + * Ultravisor, but which does not correspond any longer to an active KVM VM.
> > + */
> > +struct leftover_pv_vm {
> > +	struct list_head list;
> > +	unsigned long old_gmap_table;
> > +	u64 handle;
> > +	void *stor_var;
> > +	unsigned long stor_base;
> > +};
> > +  
> 
> I think we should switch this patch and the next one and add this struct 
> to the next patch. The list work below makes more sense once the next 
> patch has been read.

but the next patch will leave leftovers in some circumstances, and
those won't be cleaned up without this patch.

having this patch first means that when the next patch is applied, the
leftovers are already taken care of

> >   static void kvm_s390_clear_pv_state(struct kvm *kvm)
> >   {
> >   	kvm->arch.pv.handle = 0;
> > @@ -158,23 +171,88 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
> >   	return -ENOMEM;
> >   }
> >     
> 
> >     
> 

