Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A92401DDE
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 17:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243472AbhIFP5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 11:57:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21118 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231591AbhIFP5k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 11:57:40 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 186FZOYW191091;
        Mon, 6 Sep 2021 11:56:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=sAAYZ/TpZgJZV2gSG5yBW/z+vpJI/mnRZMpF2K/bBYE=;
 b=RgemcpiLKrONF+FpXwRYOi8itmZFa/9g3xAm1ZFS5/XkVcOZciRwMJzz7j+VBsyppERn
 eqHPcWGEk98TbgzJmnwvbVM53Bdl8YquTx9pH3iFd5r7woY43MISzO2AOqoChrM61VZd
 UrlaVKzFI74CwUhchoozrWpnB56fsUlYjF/P5mRiDyMg6GPCA5u0LSt/E0djClBGmnYr
 tLmthI+PXO/1EPt1Vyci4NTqOHLntC7/PPTEGykLCdgHrT66OXdZp00oIrlUJwdjeMw3
 XdQMBjqKNZ7exbl8zPwJaMgaWpONwJ2lijHITyTlG1JZWG6ao9UuhYHQCfHzYsuQ50tG OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3awnra0atd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 11:56:34 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 186FlWIQ044700;
        Mon, 6 Sep 2021 11:56:33 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3awnra0at5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 11:56:33 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 186FrT6C030660;
        Mon, 6 Sep 2021 15:56:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3av02j57jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 15:56:31 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 186FqGiF61473130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Sep 2021 15:52:16 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F73A11C066;
        Mon,  6 Sep 2021 15:56:27 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1834711C054;
        Mon,  6 Sep 2021 15:56:27 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.215])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  6 Sep 2021 15:56:27 +0000 (GMT)
Date:   Mon, 6 Sep 2021 17:54:53 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: Re: [PATCH v4 05/14] KVM: s390: pv: leak the ASCE page when destroy
 fails
Message-ID: <20210906175453.5b98ca26@p-imbrenda>
In-Reply-To: <36ce2f10-a65d-ff2a-3a11-8f2cd853f3e9@de.ibm.com>
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
        <20210818132620.46770-6-imbrenda@linux.ibm.com>
        <36ce2f10-a65d-ff2a-3a11-8f2cd853f3e9@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VkSm3zPnOHUA1BaAGqghTRCu1dGkUBBO
X-Proofpoint-ORIG-GUID: LCjnU0W8THVWwaN4j5_IbvtpyRMElo8F
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-06_06:2021-09-03,2021-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109060099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 6 Sep 2021 17:32:36 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> The subject should say
> 
> KVM: s390: pv: leak the topmost page table when destroy fails
> 
> 
> On 18.08.21 15:26, Claudio Imbrenda wrote:
> > When a protected VM is created, the topmost level of page tables of its
> > ASCE is marked by the Ultravisor; any attempt to use that memory for
> > protected virtualization will result in failure.  
> 
> 
> maybe rephrase that to
> Each secure guest must have a unique address space control element and we
> must avoid that new guests will use the same ASCE to avoid an error. As
> the ASCE mostly consists of the top most page table address (and flags)
> we must not return that memory to the pool unless the ASCE is no longer
> used.
> 
> Only a a successful Destroy Configuration UVC will make the ASCE no longer
> collide.
> When the Destroy Configuration UVC fails, the ASCE cannot be reused for a
> secure guest ASCE. To avoid a collision, it must not be used again.
> 

ok

>   
> > Only a successful Destroy Configuration UVC will remove the marking.
> > 
> > When the Destroy Configuration UVC fails, the topmost level of page
> > tables of the VM does not get its marking cleared; to avoid issues it
> > must not be used again.
> > 
> > This is a permanent error and the page becomes in practice unusable, so
> > we set it aside and leak it.  
> 
> Maybe add: on failure we already leak other memory that has ultravisor marking (the
> variable and base storage for a guest) and not setting the ASCE aside (by
> leaking the topmost page table) was an oversight.
> 
> Or something like that
> 
> maybe also add that we usually do not expect to see such error under normal
> circumstances.
> 

makes sense

> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   arch/s390/include/asm/gmap.h |  2 ++
> >   arch/s390/kvm/pv.c           |  4 ++-
> >   arch/s390/mm/gmap.c          | 55 ++++++++++++++++++++++++++++++++++++
> >   3 files changed, 60 insertions(+), 1 deletion(-)
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
> > index 00d272d134c2..76b0d64ce8fa 100644
> > --- a/arch/s390/kvm/pv.c
> > +++ b/arch/s390/kvm/pv.c
> > @@ -168,9 +168,11 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> >   	atomic_set(&kvm->mm->context.is_protected, 0);
> >   	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
> >   	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
> > -	/* Inteded memory leak on "impossible" error */
> > +	/* Intended memory leak on "impossible" error */
> >   	if (!cc)
> >   		kvm_s390_pv_dealloc_vm(kvm);
> > +	else
> > +		s390_replace_asce(kvm->arch.gmap);
> >   	return cc ? -EIO : 0;
> >   }
> >   
> > diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> > index 9bb2c7512cd5..5a138f6220c4 100644
> > --- a/arch/s390/mm/gmap.c
> > +++ b/arch/s390/mm/gmap.c
> > @@ -2706,3 +2706,58 @@ void s390_reset_acc(struct mm_struct *mm)
> >   	mmput(mm);
> >   }
> >   EXPORT_SYMBOL_GPL(s390_reset_acc);
> > +
> > +/*
> > + * Remove the topmost level of page tables from the list of page tables of
> > + * the gmap.
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
> > +	spin_unlock(&gmap->guest_table_lock);
> > +	/* in case the ASCE needs to be "removed" multiple times */
> > +	INIT_LIST_HEAD(&old->lru);  
> shouldn't that also be under the spin_lock?
> 
> > +}
> > +EXPORT_SYMBOL_GPL(s390_remove_old_asce);
> > +
> > +/*
> > + * Try to replace the current ASCE with another equivalent one.
> > + * If the allocation of the new top level page table fails, the ASCE is not
> > + * replaced.
> > + * In any case, the old ASCE is removed from the list, therefore the caller
> > + * has to make sure to save a pointer to it beforehands, unless an
> > + * intentional leak is intended.
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
> 
> It seems that we do not handle errors in our caller?

for now, but it doesn't hurt to report an error

> 
> > +	table = page_to_virt(page);
> > +	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
> > +
> > +	spin_lock(&gmap->guest_table_lock);
> > +	list_add(&page->lru, &gmap->crst_list);
> > +	spin_unlock(&gmap->guest_table_lock);
> > +
> > +	asce = (gmap->asce & ~PAGE_MASK) | __pa(table);  
> 
> Instead of PAGE_MASK better use _ASCE_ORIGIN ?

ok

> > +	WRITE_ONCE(gmap->asce, asce);
> > +	WRITE_ONCE(gmap->mm->context.gmap_asce, asce);
> > +	WRITE_ONCE(gmap->table, table);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(s390_replace_asce);
> >   

