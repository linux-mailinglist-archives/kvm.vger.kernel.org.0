Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B1D4EF73E
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 18:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348582AbiDAPzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 11:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356977AbiDAPiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 11:38:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3876BEA760;
        Fri,  1 Apr 2022 08:13:11 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 231DCKDN024630;
        Fri, 1 Apr 2022 15:13:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=OLeow45T6onKVkerq7bmlAegWan314OMLymZR4dRimo=;
 b=oy7xxp6mWHirB2L3WLRW00IaHTlncxS7p7wBMzWnKX/HNACs+32RyfEwM9nDWRjwEpij
 0ALvTabDvvxePJOOuWY+12HaD3WVWOxWJoFbbGvbHr1HezEB0f7Ll4RfnakxcwcBfD7K
 UklZEi4mgKtiOcV/quPolFR+dDJVjj7tcq60ZF7vrZKapHv2qRJnfLcpAiWaaaVy88H7
 a//TBgiH7qJ7MY7k94Ftr31bhMR9HVdkNlwEYtBAx+kCDnedH9H0lDPmuh4/DOE0LBtu
 EyJ1Gk7W6clQykcPOcriadh0MiU4y0ZpSg+u4bMqWng1DEE81dIoER1LZ7vGnUHOT/13 PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f622sak56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 15:13:10 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231FBjTV030294;
        Fri, 1 Apr 2022 15:13:09 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f622sak4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 15:13:09 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231FCZhc025639;
        Fri, 1 Apr 2022 15:13:07 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3f1tf937kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 15:13:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231FD4hF39321964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 15:13:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BEE711C04C;
        Fri,  1 Apr 2022 15:13:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C02AD11C050;
        Fri,  1 Apr 2022 15:13:03 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.73])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 15:13:03 +0000 (GMT)
Date:   Fri, 1 Apr 2022 17:13:02 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v9 13/18] KVM: s390: pv: cleanup leftover protected VMs
 if needed
Message-ID: <20220401171302.60415a07@p-imbrenda>
In-Reply-To: <827cfa86-bad4-8c31-8038-8db9a011fee9@linux.ibm.com>
References: <20220330122605.247613-1-imbrenda@linux.ibm.com>
        <20220330122605.247613-14-imbrenda@linux.ibm.com>
        <827cfa86-bad4-8c31-8038-8db9a011fee9@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FcJuACXsFvNapsRqhCdp2jBElUXrgXBb
X-Proofpoint-GUID: v4AIpO-loT_2Hlv1dEP_gxNm0LeWMB1o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_05,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 31 Mar 2022 16:02:55 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 3/30/22 14:26, Claudio Imbrenda wrote:
> > In upcoming patches it will be possible to start tearing down a
> > protected VM, and finish the teardown concurrently in a different
> > thread.
> > 
> > Protected VMs that are pending for tear down ("leftover") need to be
> > cleaned properly when the userspace process (e.g. qemu) terminates.
> > 
> > This patch makes sure that all "leftover" protected VMs are always
> > properly torn down.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   arch/s390/include/asm/kvm_host.h |  2 +
> >   arch/s390/kvm/kvm-s390.c         |  1 +
> >   arch/s390/kvm/pv.c               | 69 ++++++++++++++++++++++++++++++++
> >   3 files changed, 72 insertions(+)
> > 
> > diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> > index 1bccb8561ba9..50e3516cbc03 100644
> > --- a/arch/s390/include/asm/kvm_host.h
> > +++ b/arch/s390/include/asm/kvm_host.h
> > @@ -922,6 +922,8 @@ struct kvm_s390_pv {
> >   	u64 guest_len;
> >   	unsigned long stor_base;
> >   	void *stor_var;
> > +	void *async_deinit;
> > +	struct list_head need_cleanup;
> >   	struct mmu_notifier mmu_notifier;
> >   };
> >   
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 446f89db93a1..3637f556ff33 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -2788,6 +2788,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >   	kvm_s390_vsie_init(kvm);
> >   	if (use_gisa)
> >   		kvm_s390_gisa_init(kvm);
> > +	INIT_LIST_HEAD(&kvm->arch.pv.need_cleanup);  
> 
> kvm->arch.pv.sync_deinit = NULL;

isn't the struct allocated with __GFP_ZERO ?

> 
> >   	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
> >   
> >   	return 0;
> > diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> > index be3b467f8feb..56412617dd01 100644
> > --- a/arch/s390/kvm/pv.c
> > +++ b/arch/s390/kvm/pv.c
> > @@ -17,6 +17,19 @@
> >   #include <linux/mmu_notifier.h>
> >   #include "kvm-s390.h"
> >   
> > +/**
> > + * @struct deferred_priv
> > + * Represents a "leftover" protected VM that does not correspond to any
> > + * active KVM VM.  
> 
> Maybe something like:
> ...that is still registered with the Ultravisor but isn't registered 
> with KVM anymore.

will fix

> 
> > + */
> > +struct deferred_priv {
> > +	struct list_head list;
> > +	unsigned long old_table;
> > +	u64 handle;
> > +	void *stor_var;
> > +	unsigned long stor_base;
> > +};
> > +
> >   static void kvm_s390_clear_pv_state(struct kvm *kvm)
> >   {
> >   	kvm->arch.pv.handle = 0;
> > @@ -163,6 +176,60 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
> >   	return -ENOMEM;
> >   }
> >   
> > +/**
> > + * kvm_s390_pv_cleanup_deferred - Clean up one leftover protected VM.
> > + * @kvm the KVM that was associated with this leftover protected VM
> > + * @deferred details about the leftover protected VM that needs a clean up
> > + * Return: 0 in case of success, otherwise 1
> > + */
> > +static int kvm_s390_pv_cleanup_deferred(struct kvm *kvm, struct deferred_priv *deferred)
> > +{
> > +	u16 rc, rrc;
> > +	int cc;
> > +
> > +	cc = uv_cmd_nodata(deferred->handle, UVC_CMD_DESTROY_SEC_CONF, &rc, &rrc);
> > +	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", rc, rrc);
> > +	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", rc, rrc);
> > +	if (cc)
> > +		return cc;
> > +	/*
> > +	 * Intentionally leak unusable memory. If the UVC fails, the memory
> > +	 * used for the VM and its metadata is permanently unusable.
> > +	 * This can only happen in case of a serious KVM or hardware bug; it
> > +	 * is not expected to happen in normal operation.
> > +	 */
> > +	free_pages(deferred->stor_base, get_order(uv_info.guest_base_stor_len));
> > +	free_pages(deferred->old_table, CRST_ALLOC_ORDER);
> > +	vfree(deferred->stor_var);
> > +	return 0;
> > +}
> > +
> > +/**
> > + * kvm_s390_pv_cleanup_leftovers - Clean up all leftover protected VMs.
> > + * @kvm the KVM whose leftover protected VMs are to be cleaned up
> > + * Return: 0 in case of success, otherwise 1
> > + */
> > +static int kvm_s390_pv_cleanup_leftovers(struct kvm *kvm)
> > +{
> > +	struct deferred_priv *deferred;
> > +	int cc = 0;
> > +
> > +	if (kvm->arch.pv.async_deinit)
> > +		list_add(kvm->arch.pv.async_deinit, &kvm->arch.pv.need_cleanup);
> > +
> > +	while (!list_empty(&kvm->arch.pv.need_cleanup)) {
> > +		deferred = list_first_entry(&kvm->arch.pv.need_cleanup, typeof(*deferred), list);
> > +		if (kvm_s390_pv_cleanup_deferred(kvm, deferred))
> > +			cc = 1;
> > +		else
> > +			atomic_dec(&kvm->mm->context.protected_count);
> > +		list_del(&deferred->list);
> > +		kfree(deferred);
> > +	}
> > +	kvm->arch.pv.async_deinit = NULL;
> > +	return cc;
> > +}
> > +
> >   /* this should not fail, but if it does, we must not free the donated memory */
> >   int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> >   {
> > @@ -190,6 +257,8 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> >   	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
> >   	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
> >   
> > +	cc |= kvm_s390_pv_cleanup_leftovers(kvm);
> > +
> >   	return cc ? -EIO : 0;
> >   }
> >     
> 

