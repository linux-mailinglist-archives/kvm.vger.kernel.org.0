Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9EE51D6BE
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 13:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391411AbiEFLhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 07:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391400AbiEFLhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 07:37:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C666832F;
        Fri,  6 May 2022 04:33:42 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246BDoBL027443;
        Fri, 6 May 2022 11:33:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=I3LOhBMq302WzVno2bRgueu34Zp34rUClU5uKaOI1cY=;
 b=oZ0U+UWu+I4zmyLbUJhuZFftoB4UVuHD2yKFfnKHPnfs4nOa29ofjfI6uIpLnPYk9CiS
 mIuJnmCQiTmp8HZDSmiDMcvfJvVX844sB1uvAskHnc7s4G3VwxI9cysAfrwGT+2+oAot
 SuO0fw6c+TqBsBpX2jFmR7WZ7G+6k1K2/SEtukbVUpV/HEw22I/tgcMtlxRoarTXo9c4
 3hpYqk3rgtwcS7hfUt9XcGTQC8N79S6XfLUJRBDtOPLbs9AZ6I2fnx2vUz2TrVPpBcy3
 EkDvLcsQTiiCV1oaxNSmpfglVYYBZkIbaV2GwNv5IULx47vLanFGBB8pcHGIq+zKRMus yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw2m78a3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 11:33:41 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 246BI969009015;
        Fri, 6 May 2022 11:33:41 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw2m78a2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 11:33:41 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 246BSxns025972;
        Fri, 6 May 2022 11:33:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3fvm08gqut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 11:33:39 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 246BXaGU57868726
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 11:33:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5908B4C044;
        Fri,  6 May 2022 11:33:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE5324C040;
        Fri,  6 May 2022 11:33:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.58])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 May 2022 11:33:35 +0000 (GMT)
Date:   Fri, 6 May 2022 13:30:30 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v10 01/19] KVM: s390: pv: leak the topmost page table
 when destroy fails
Message-ID: <20220506133030.6b51e019@p-imbrenda>
In-Reply-To: <08f78cc7-b34e-cdca-72b8-a0f9163f3ca7@redhat.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
        <20220414080311.1084834-2-imbrenda@linux.ibm.com>
        <08f78cc7-b34e-cdca-72b8-a0f9163f3ca7@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3lUAbrIdoCp1ZFtq-KSKYH0w0qDcRcST
X-Proofpoint-GUID: Y3dkZDtvUpBcPzuwHcIGWPRBf7ttbErd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_04,2022-05-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 5 May 2022 16:45:13 +0200
Thomas Huth <thuth@redhat.com> wrote:

> On 14/04/2022 10.02, Claudio Imbrenda wrote:
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
> >   arch/s390/include/asm/gmap.h |  2 +
> >   arch/s390/kvm/pv.c           |  9 ++--
> >   arch/s390/mm/gmap.c          | 80 ++++++++++++++++++++++++++++++++++++
> >   3 files changed, 88 insertions(+), 3 deletions(-)
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
> > index af03cacf34ec..e8904cb9dc38 100644
> > --- a/arch/s390/mm/gmap.c
> > +++ b/arch/s390/mm/gmap.c
> > @@ -2714,3 +2714,83 @@ void s390_reset_acc(struct mm_struct *mm)
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
> > + * intended. Notice that this function will only remove the page from the  
> 
> "intentional leak is intended" ... sounds redundant. Scratch the first 
> "intentional" ?
> 
> > + * list, the page will still be used as a top level page table (and ASCE).
> > + */
> > +void s390_remove_old_asce(struct gmap *gmap)
> > +{
> > +	struct page *old;
> > +
> > +	old = virt_to_page(gmap->table);
> > +	spin_lock(&gmap->guest_table_lock);
> > +	list_del(&old->lru);
> > +	/*
> > +	 * In case the ASCE needs to be "removed" multiple times, for example
> > +	 * if the VM is rebooted into secure mode several times
> > +	 * concurrently, or if s390_replace_asce fails after calling
> > +	 * s390_remove_old_asce and is attempted again later. In that case  
> 
> "In case the ASCE ... . In that case" - this should be either one big 
> sentence, or better, scratch the first "In case" and use "Sometimes" or 
> something similar to start the first sentence.
> 
> > +	 * the old asce has been removed from the list, and therefore it
> > +	 * will not be freed when the VM terminates, but the ASCE is still
> > +	 * in use and still pointed to.
> > +	 * A subsequent call to replace_asce will follow the pointer and try
> > +	 * to remove the same page from the list again.
> > +	 * Therefore it's necessary that the page of the ASCE has valid
> > +	 * pointers, so list_del can work (and do nothing) without
> > +	 * dereferencing stale or invalid pointers.
> > +	 */
> > +	INIT_LIST_HEAD(&old->lru);
> > +	spin_unlock(&gmap->guest_table_lock);
> > +}
> > +EXPORT_SYMBOL_GPL(s390_remove_old_asce);
> > +
> > +/**
> > + * s390_replace_asce - Try to replace the current ASCE of a gmap with
> > + * another equivalent one.
> > + * @gmap the gmap  
> 
> "the gmap" is not a very helpful description for a parmeter that is already 
> called gmap. Write at least "the guest map that should be replaced" ?
> 
> > + *
> > + * If the allocation of the new top level page table fails, the ASCE is not
> > + * replaced.
> > + * In any case, the old ASCE is always removed from the list. Therefore the
> > + * caller has to make sure to save a pointer to it beforehands, unless an  
> 
> s/beforehands/beforehand/
> 
> > + * intentional leak is intended.  
> 
> scratch "intentional".
> 
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
> > +	/* Set new table origin while preserving existing ASCE control bits */
> > +	asce = (gmap->asce & ~_ASCE_ORIGIN) | __pa(table);
> > +	WRITE_ONCE(gmap->asce, asce);
> > +	WRITE_ONCE(gmap->mm->context.gmap_asce, asce);
> > +	WRITE_ONCE(gmap->table, table);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(s390_replace_asce);  
> 
>   Thomas
> 

thanks, I will fix them all

