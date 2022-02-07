Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70AA4ABF5C
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 14:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiBGMbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 07:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443158AbiBGMWK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 07:22:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48927C03BFEB;
        Mon,  7 Feb 2022 04:16:50 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217BWmZS003556;
        Mon, 7 Feb 2022 12:16:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=YR731IOIUoe6WymUzX7ZbD7U/uLM5NOtPVbMIdoTLTA=;
 b=MN1qvd8OZvYGF4YqTEDssI5L9V4o/C+w9Oj61bKRoVTDIWXkHu3jT5N9p6K+9yGFyfhh
 SCslhbzCHFpeXImPaLVtmPbAYA4bTT/wF+iquHu2ZwfP8W6TvMwzngNcwjD+0i/KhTiI
 lInCxldtYQ6KPqnlDhk4xYC79mlLoboIdVNyK1YdH8QhjVQq9Ah2/wdmes83YSUI5DHF
 2R1q3Qooh9OVzcvPBl5NhZ/05fotExRXaS1+YhOmfp4pH4toZ8Lo159DYK89ef1wrBh2
 LIKJwXZdNbVPjrWJ4YnzrtuHlm3DY8n7ppC7n3tyn9oNd8piNrY+d8cmfgkMcLp6NugO UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22qek8a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 12:16:49 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217CCRe4013446;
        Mon, 7 Feb 2022 12:16:49 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22qek89c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 12:16:49 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217C84tj005217;
        Mon, 7 Feb 2022 12:16:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3e1gv937jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 12:16:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217CGh3n47383036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 12:16:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91CB652054;
        Mon,  7 Feb 2022 12:16:43 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.11.12])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0F7E452051;
        Mon,  7 Feb 2022 12:16:43 +0000 (GMT)
Date:   Mon, 7 Feb 2022 13:16:40 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: Re: [PATCH v7 10/17] KVM: s390: pv: add mmu_notifier
Message-ID: <20220207131640.198ff201@p-imbrenda>
In-Reply-To: <28955238-1fac-ad9a-f2bb-2c6c0c2ed894@linux.ibm.com>
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
        <20220204155349.63238-11-imbrenda@linux.ibm.com>
        <28955238-1fac-ad9a-f2bb-2c6c0c2ed894@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yZzlt7oeNMnV4J9c-sY6e4cC9uKNOq6U
X-Proofpoint-GUID: Q-UssAWRYASupH6j_gbKeSDOSf1f0GwN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_04,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 adultscore=0 malwarescore=0 clxscore=1015 suspectscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Feb 2022 12:04:56 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 2/4/22 16:53, Claudio Imbrenda wrote:
> > Add an mmu_notifier for protected VMs. The callback function is
> > triggered when the mm is torn down, and will attempt to convert all
> > protected vCPUs to non-protected. This allows the mm teardown to use
> > the destroy page UVC instead of export.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   arch/s390/include/asm/kvm_host.h |  2 ++
> >   arch/s390/kvm/pv.c               | 20 ++++++++++++++++++++
> >   2 files changed, 22 insertions(+)
> > 
> > diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> > index a22c9266ea05..1bccb8561ba9 100644
> > --- a/arch/s390/include/asm/kvm_host.h
> > +++ b/arch/s390/include/asm/kvm_host.h
> > @@ -19,6 +19,7 @@
> >   #include <linux/kvm.h>
> >   #include <linux/seqlock.h>
> >   #include <linux/module.h>
> > +#include <linux/mmu_notifier.h>
> >   #include <asm/debug.h>
> >   #include <asm/cpu.h>
> >   #include <asm/fpu/api.h>
> > @@ -921,6 +922,7 @@ struct kvm_s390_pv {
> >   	u64 guest_len;
> >   	unsigned long stor_base;
> >   	void *stor_var;
> > +	struct mmu_notifier mmu_notifier;
> >   };
> >   
> >   struct kvm_arch{
> > diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> > index f1e812a45acb..d3b8fd9b5b3e 100644
> > --- a/arch/s390/kvm/pv.c
> > +++ b/arch/s390/kvm/pv.c
> > @@ -193,6 +193,21 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> >   	return -EIO;
> >   }
> >   
> > +static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
> > +					     struct mm_struct *mm)
> > +{
> > +	struct kvm *kvm = container_of(subscription, struct kvm, arch.pv.mmu_notifier);  
> 
> Are we sure that the kvm pointer is still valid at this point?

it should be, because KVM is torn down after the mm. which is the whole
reason why the notifier is needed.

on the other hand, I realized that I should have unregistered the
notifier somewhere, which I forgot to do. the best place would be KVM
teardown, which then also guarantees that the notifier can only be
called with a valid struct kvm

> 
> > +	u16 dummy;
> > +
> > +	mutex_lock(&kvm->lock);  
> 
> Against what are we locking here?
> 
> > +	kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);  
> 
> I'd guess that we can't really have a second kvm_s390_cpus_from_pv() 
> call in flight, right? If the mm is being torn down there would be no 
> code left that can execute the IOCTL.

yeah makes sense

> 
> > +	mutex_unlock(&kvm->lock);
> > +}
> > +
> > +static const struct mmu_notifier_ops kvm_s390_pv_mmu_notifier_ops = {
> > +	.release = kvm_s390_pv_mmu_notifier_release,
> > +};
> > +
> >   int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> >   {
> >   	struct uv_cb_cgc uvcb = {
> > @@ -234,6 +249,11 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> >   		return -EIO;
> >   	}
> >   	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
> > +	/* Add the notifier only once. No races because we hold kvm->lock */
> > +	if (kvm->arch.pv.mmu_notifier.ops != &kvm_s390_pv_mmu_notifier_ops) {
> > +		kvm->arch.pv.mmu_notifier.ops = &kvm_s390_pv_mmu_notifier_ops;
> > +		mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
> > +	}
> >   	return 0;
> >   }
> >   
> >   
> 

