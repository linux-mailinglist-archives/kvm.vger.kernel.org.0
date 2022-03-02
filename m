Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821C14CA457
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 13:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241642AbiCBMBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 07:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235302AbiCBMBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 07:01:12 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700853337D;
        Wed,  2 Mar 2022 04:00:29 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222BIJap012313;
        Wed, 2 Mar 2022 12:00:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=U0aKZZNrQZbhrowGuYOY84sya9uqs6tXBU6OuSaX+2A=;
 b=WL0yWJfrohwWjKYWagLN3nVZZUkrn8W6iVS6vBhe+Uvi0kX0jfl1awvoVKcdHFnMYcpG
 EO/CWLhnDCA50+w4M1frHDbSQBY9a3WRSG+3youFAMlGy9iVmTAnlKs+xJDQIqUx/rqO
 YzPzbbWJSy4fbNnDtTqRFzrnePnNEInmTIBq2x9LzQv3Is+ymIn5TvDd/cnkwGEHY7K8
 opP/u0+sEtL+rfu75SDitZiAtQdaUxEPiVVTNSKgFhkMTN8Xw0+YwDG1cVK2o878SPVQ
 H87GR4nt5mYBG2AEiJMJSQXGUIUoFkPQ1SHrKZPFYWAeHm6F3cQBYLW4oOmzo8jft3w2 +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ej50kwcj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 12:00:29 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 222C0EbK008573;
        Wed, 2 Mar 2022 12:00:28 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ej50kwcge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 12:00:28 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 222BmilP000955;
        Wed, 2 Mar 2022 12:00:26 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3efbu9ekus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 12:00:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 222BnQSZ52101408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Mar 2022 11:49:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB240A405C;
        Wed,  2 Mar 2022 12:00:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 764F7A4054;
        Wed,  2 Mar 2022 12:00:21 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.5.37])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  2 Mar 2022 12:00:21 +0000 (GMT)
Date:   Wed, 2 Mar 2022 13:00:18 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, borntraeger@de.ibm.com,
        mimu@linux.ibm.com
Subject: Re: [PATCH v1 1/1] KVM: s390x: fix SCK locking
Message-ID: <20220302130018.66e70301@p-imbrenda>
In-Reply-To: <d4c185b3-a788-8416-2f1b-4d7394d157e3@linux.ibm.com>
References: <20220301143340.111129-1-imbrenda@linux.ibm.com>
        <d4c185b3-a788-8416-2f1b-4d7394d157e3@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7JOPiyZkLJHISx3S_6UydiQwMcvvZd7k
X-Proofpoint-ORIG-GUID: dsiyu8jg9zXNFCXD90JXk5EYRWITSvA8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_01,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 suspectscore=0 clxscore=1015
 phishscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2 Mar 2022 11:15:23 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> On 3/1/22 15:33, Claudio Imbrenda wrote:
> > When handling the SCK instruction, the kvm lock is taken, even though
> > the vcpu lock is already being held. The normal locking order is kvm
> > lock first and then vcpu lock. This is can (and in some circumstances
> > does) lead to deadlocks.
> > 
> > The function kvm_s390_set_tod_clock is called both by the SCK handler
> > and by some IOCTLs to set the clock. The IOCTLs will not hold the vcpu
> > lock, so they can safely take the kvm lock. The SCK handler holds the
> > vcpu lock, but will also somehow need to acquire the kvm lock without
> > relinquishing the vcpu lock.
> > 
> > The solution is to factor out the code to set the clock, and provide
> > two wrappers. One is called like the original function and does the
> > locking, the other is called kvm_s390_try_set_tod_clock and uses
> > trylock to try to acquire the kvm lock. This new wrapper is then used
> > in the SCK handler. If locking fails, -EAGAIN is returned, which is
> > eventually propagated to userspace, thus also freeing the vcpu lock and
> > allowing for forward progress.
> > 
> > This is not the most efficient or elegant way to solve this issue, but
> > the SCK instruction is deprecated and its performance is not critical.
> > 
> > The goal of this patch is just to provide a simple but correct way to
> > fix the bug.
> > 
> > Fixes: 6a3f95a6b04c ("KVM: s390: Intercept SCK instruction")
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c | 19 ++++++++++++++++---
> >  arch/s390/kvm/kvm-s390.h |  4 ++--
> >  arch/s390/kvm/priv.c     | 14 +++++++++++++-
> >  3 files changed, 31 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 2296b1ff1e02..4e3db4004bfd 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -3869,14 +3869,12 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
> >  	return 0;
> >  }
> > 
> > -void kvm_s390_set_tod_clock(struct kvm *kvm,
> > -			    const struct kvm_s390_vm_tod_clock *gtod)
> > +static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
> >  {
> >  	struct kvm_vcpu *vcpu;
> >  	union tod_clock clk;
> >  	unsigned long i;
> > 
> > -	mutex_lock(&kvm->lock);
> >  	preempt_disable();
> > 
> >  	store_tod_clock_ext(&clk);
> > @@ -3897,7 +3895,22 @@ void kvm_s390_set_tod_clock(struct kvm *kvm,
> > 
> >  	kvm_s390_vcpu_unblock_all(kvm);
> >  	preempt_enable();
> > +}
> > +
> > +void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
> > +{
> > +	mutex_lock(&kvm->lock);
> > +	__kvm_s390_set_tod_clock(kvm, gtod);
> > +	mutex_unlock(&kvm->lock);
> > +}
> > +
> > +int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)  
> 
> Why int instead of bool?

to be consistent with mutex_trylock, which also returns int

> 
> > +{
> > +	if (!mutex_trylock(&kvm->lock))
> > +		return 0;
> > +	__kvm_s390_set_tod_clock(kvm, gtod);
> >  	mutex_unlock(&kvm->lock);
> > +	return 1;
> >  }
> >   
> [...]

