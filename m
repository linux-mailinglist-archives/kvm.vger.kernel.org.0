Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB3F4AB757
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 10:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346251AbiBGJMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 04:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349361AbiBGJDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 04:03:53 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F2FC043181;
        Mon,  7 Feb 2022 01:03:51 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2178PwWw003446;
        Mon, 7 Feb 2022 09:03:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=NnzYlCgthbEUz7/lw6koHj5t8c8GN7rOAzDAF4Yiv+E=;
 b=l1GOKiDDQS/9DJgWBqdiH/nzLkPDV0VG2tiZceZy0g5Yd734D9AtDqBuQXCUwAwaiyIr
 itiHG/s96uYNiuMChQxgtlCpGvswqqNM7/FjRlQOSG5wRKDjhtT6+Y024q+Wro/Ez24J
 yitx5KdMyUEI7FwzbMICXvzsFB7PJ/k59Zb3YDhYVaAgu4Fianh6vDA795a7oD8FYLul
 QyXMFR8XRH1ySAWDpPTJV06b3EwUS4JAkNePZzxZBmdb5uowsEbuvU+8VUraGlaENYbD
 6cYFWUqfRB7RLu6jPrON+rU/PupBagY4Zqr0kGd2hA7E9B9h1UqMiK6KWTPb17hgmII0 JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22qeeu4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 09:03:51 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21790lMu004651;
        Mon, 7 Feb 2022 09:03:51 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22qeeu3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 09:03:50 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21792dmd029455;
        Mon, 7 Feb 2022 09:03:48 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3e1gv91j0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 09:03:48 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21792hlL45482358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 09:02:43 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 523464C04A;
        Mon,  7 Feb 2022 09:02:43 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C16D64C050;
        Mon,  7 Feb 2022 09:02:42 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.11.12])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 09:02:42 +0000 (GMT)
Date:   Mon, 7 Feb 2022 10:02:39 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: Re: [PATCH v7 01/17] KVM: s390: pv: leak the topmost page table
 when destroy fails
Message-ID: <20220207100239.1e043759@p-imbrenda>
In-Reply-To: <0939aac3-9427-ed04-17e4-3c1e4195d509@linux.ibm.com>
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
        <20220204155349.63238-2-imbrenda@linux.ibm.com>
        <0939aac3-9427-ed04-17e4-3c1e4195d509@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XWKoMgsixDdrJx6WSfWN23fVGdutGVLX
X-Proofpoint-GUID: JfX93O4wsBtnnpKel1C0pV0RmAWdza5g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_03,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 adultscore=0 malwarescore=0 clxscore=1015 suspectscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Feb 2022 09:56:39 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 2/4/22 16:53, Claudio Imbrenda wrote:
> > Each secure guest must have a unique ASCE (address space control
> > element); we must avoid that new guests use the same page for their
> > ASCE, to avoid errors.
> > 
> > Since the ASCE mostly consists of the address of the topmost page table
> > (plus some flags), we must not return that memory to the pool unless
> > the ASCE is no longer in use.
> > 
> > Only a successful Destroy Secure Configuration UVC will make the ASCE
> > reusable again.
> > 
> > If the Destroy Configuration UVC fails, the ASCE cannot be reused for a
> > secure guest (either for the ASCE or for other memory areas). To avoid
> > a collision, it must not be used again. This is a permanent error and
> > the page becomes in practice unusable, so we set it aside and leak it.
> > On failure we already leak other memory that belongs to the ultravisor
> > (i.e. the variable and base storage for a guest) and not leaking the
> > topmost page table was an oversight.
> > 
> > This error (and thus the leakage) should not happen unless the hardware
> > is broken or KVM has some unknown serious bug.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Fixes: 29b40f105ec8d55 ("KVM: s390: protvirt: Add initial vm and cpu lifecycle handling")
> > ---
> >   arch/s390/include/asm/gmap.h |  2 ++
> >   arch/s390/kvm/pv.c           |  9 +++--
> >   arch/s390/mm/gmap.c          | 69 ++++++++++++++++++++++++++++++++++++
> >   3 files changed, 77 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> > index 40264f60b0da..746e18bf8984 100644
> > --- a/arch/s390/include/asm/gmap.h
> > +++ b/arch/s390/include/asm/gmap.h
> > @@ -148,4 +148,6 @@ void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
> >   			     unsigned long gaddr, unsigned long vmaddr);
> >   int gmap_mark_unmergeable(void);
> >   void s390_reset_acc(struct mm_struct *mm);
> > +void s390_remove_old_asce(struct gmap *gmap);
> > +int s390_replace_asce(struct gmap *gmap);
> >   #endif /* _ASM_S390_GMAP_H */
> > diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> > index 7f7c0d6af2ce..3c59ef763dde 100644
> > --- a/arch/s390/kvm/pv.c
> > +++ b/arch/s390/kvm/pv.c
> > @@ -166,10 +166,13 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> >   	atomic_set(&kvm->mm->context.is_protected, 0);
> >   	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
> >   	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
> > -	/* Inteded memory leak on "impossible" error */
> > -	if (!cc)
> > +	/* Intended memory leak on "impossible" error */
> > +	if (!cc) {
> >   		kvm_s390_pv_dealloc_vm(kvm);
> > -	return cc ? -EIO : 0;
> > +		return 0;
> > +	}
> > +	s390_replace_asce(kvm->arch.gmap);
> > +	return -EIO;
> >   }
> >   
> >   int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> > diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> > index dfee0ebb2fac..ce6cac4463f2 100644
> > --- a/arch/s390/mm/gmap.c
> > +++ b/arch/s390/mm/gmap.c
> > @@ -2714,3 +2714,72 @@ void s390_reset_acc(struct mm_struct *mm)
> >   	mmput(mm);
> >   }
> >   EXPORT_SYMBOL_GPL(s390_reset_acc);
> > +
> > +/**
> > + * s390_remove_old_asce - Remove the topmost level of page tables from the
> > + * list of page tables of the gmap.
> > + * @gmap the gmap whose table is to be removed
> > + *
> > + * This means that it will not be freed when the VM is torn down, and needs
> > + * to be handled separately by the caller, unless an intentional leak is
> > + * intended.
> > + */
> > +void s390_remove_old_asce(struct gmap *gmap)
> > +{
> > +	struct page *old;
> > +
> > +	old = virt_to_page(gmap->table);
> > +	spin_lock(&gmap->guest_table_lock);
> > +	list_del(&old->lru);
> > +	/*
> > +	 * in case the ASCE needs to be "removed" multiple times, for example
> > +	 * if the VM is rebooted into secure mode several times
> > +	 * concurrently.
> > +	 */
> > +	INIT_LIST_HEAD(&old->lru);
> > +	spin_unlock(&gmap->guest_table_lock);  
> 
> The patch itself looks fine to me, but there's one oddity which made me 
> look twice:
> 
> You're not overwriting gmap->table here so you can use it in the 
> function below. I guess that's intentional so it can still be used as a 
> reference until we switch over to the new ASCE page?

yes. maybe I should rename the function or add more comments explaining
that the page is only removed from the list, so that it will not be freed at
teardown, but it's still in use by the VM (because we always need an
ASCE)

> 
> 
> > +}
> > +EXPORT_SYMBOL_GPL(s390_remove_old_asce);
> > +
> > +/**
> > + * s390_replace_asce - Try to replace the current ASCE of a gmap with
> > + * another equivalent one.
> > + * @gmap the gmap
> > + *
> > + * If the allocation of the new top level page table fails, the ASCE is not
> > + * replaced.
> > + * In any case, the old ASCE is always removed from the list. Therefore the
> > + * caller has to make sure to save a pointer to it beforehands, unless an > + * intentional leak is intended.
> > + */
> > +int s390_replace_asce(struct gmap *gmap)
> > +{
> > +	unsigned long asce;
> > +	struct page *page;
> > +	void *table;
> > +
> > +	s390_remove_old_asce(gmap);
> > +
> > +	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
> > +	if (!page)
> > +		return -ENOMEM;
> > +	table = page_to_virt(page);
> > +	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
> > +
> > +	/*
> > +	 * The caller has to deal with the old ASCE, but here we make sure
> > +	 * the new one is properly added to the list of page tables, so that
> > +	 * it will be freed when the VM is torn down.
> > +	 */
> > +	spin_lock(&gmap->guest_table_lock);
> > +	list_add(&page->lru, &gmap->crst_list);
> > +	spin_unlock(&gmap->guest_table_lock);
> > +
> > +	asce = (gmap->asce & ~PAGE_MASK) | __pa(table);  
> 
> Please add a comment:
> Set the new table origin while preserving ASCE control bits like table 
> type and length.

will do

> 
> > +	WRITE_ONCE(gmap->asce, asce);
> > +	WRITE_ONCE(gmap->mm->context.gmap_asce, asce);
> > +	WRITE_ONCE(gmap->table, table);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(s390_replace_asce);
> >   
> 

