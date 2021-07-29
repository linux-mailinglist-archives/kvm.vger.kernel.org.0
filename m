Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B583DA456
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237913AbhG2NaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:30:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237865AbhG2N3P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 09:29:15 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TD5lQ2157942;
        Thu, 29 Jul 2021 09:29:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1NnEBtLgFViQYUe8uwCFZf0dmKuUwb5R1EFAooMauJE=;
 b=GA2W+oHbHXV0oc3CzAx/6TJng0pceUxA8bx+RcpqfG1IVEen+MUVWnzRXhMb6GtiOW3+
 QAVK8pEqRXjn6pZqhjh+FJoPtYvjtRBuVQkIbHzTtnOYqRBokQT2yPaeNgNvwbApU5eY
 k1TPlXK3ul6WTJe/VmrtyC11FUc3POBouOrsKovqYNhaNkMJPGSOaFZnd2O9N30Hghxm
 AZO3iVxY4CPWcvXMp4wLN1q/VV892uaVJ+EMtuuX9eNyoQbS7mPUgJPoOP+lLzyiORTA
 DKuwU3VFbFXYiZ6D3ZTKzd0DOv/1aGJw869iHD76yXu84OMsT736k74/nUQvoSfUVqL8 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3us4benf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:29:12 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TD6YPe164509;
        Thu, 29 Jul 2021 09:29:11 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3us4bemh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 09:29:11 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TDIqLn017699;
        Thu, 29 Jul 2021 13:29:09 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3a235ks4hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 13:29:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TDT5Om33292724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 13:29:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9CF2A4060;
        Thu, 29 Jul 2021 13:29:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6894CA405B;
        Thu, 29 Jul 2021 13:29:05 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.151])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 13:29:05 +0000 (GMT)
Date:   Thu, 29 Jul 2021 14:54:14 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/13] KVM: s390: pv: leak the ASCE page when destroy
 fails
Message-ID: <20210729145414.62b568cf@p-imbrenda>
In-Reply-To: <21eb4861-f118-cf3b-409e-ea31694582a5@linux.ibm.com>
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
        <20210728142631.41860-3-imbrenda@linux.ibm.com>
        <21eb4861-f118-cf3b-409e-ea31694582a5@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GZsrXDE9Zd5rZOWvSSTyjiCFnpAehJM-
X-Proofpoint-GUID: LpEXbeFP_k_B8cNfdYQBm7_5fpZ_SBY1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Jul 2021 12:41:05 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 7/28/21 4:26 PM, Claudio Imbrenda wrote:
> > When a protected VM is created, the topmost level of page tables of
> > its ASCE is marked by the Ultravisor; any attempt to use that
> > memory for protected virtualization will result in failure.
> > 
> > Only a successful Destroy Configuration UVC will remove the marking.
> > 
> > When the Destroy Configuration UVC fails, the topmost level of page
> > tables of the VM does not get its marking cleared; to avoid issues
> > it must not be used again.
> > 
> > Since the page becomes in practice unusable, we set it aside and
> > leak it.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/kvm/pv.c | 53
> > +++++++++++++++++++++++++++++++++++++++++++++- 1 file changed, 52
> > insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> > index e007df11a2fe..1ecdc1769ed9 100644
> > --- a/arch/s390/kvm/pv.c
> > +++ b/arch/s390/kvm/pv.c
> > @@ -155,6 +155,55 @@ static int kvm_s390_pv_alloc_vm(struct kvm
> > *kvm) return -ENOMEM;
> >  }
> >  
> > +/*
> > + * Remove the topmost level of page tables from the list of page
> > tables of
> > + * the gmap.
> > + * This means that it will not be freed when the VM is torn down,
> > and needs
> > + * to be handled separately by the caller, unless an intentional
> > leak is
> > + * intended.
> > + */
> > +static void kvm_s390_pv_remove_old_asce(struct kvm *kvm)
> > +{
> > +	struct page *old;
> > +
> > +	old = virt_to_page(kvm->arch.gmap->table);
> > +	list_del(&old->lru);
> > +	/* in case the ASCE needs to be "removed" multiple times */
> > +	INIT_LIST_HEAD(&old->lru);
> > +}
> > +
> > +/*
> > + * Try to replace the current ASCE with another equivalent one.
> > + * If the allocation of the new top level page table fails, the
> > ASCE is not
> > + * replaced.
> > + * In any case, the old ASCE is removed from the list, therefore
> > the caller
> > + * has to make sure to save a pointer to it beforehands, unless an
> > + * intentional leak is intended.
> > + */
> > +static int kvm_s390_pv_replace_asce(struct kvm *kvm)
> > +{
> > +	unsigned long asce;
> > +	struct page *page;
> > +	void *table;
> > +
> > +	kvm_s390_pv_remove_old_asce(kvm);
> > +
> > +	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
> > +	if (!page)
> > +		return -ENOMEM;
> > +	list_add(&page->lru, &kvm->arch.gmap->crst_list);
> > +
> > +	table = page_to_virt(page);
> > +	memcpy(table, kvm->arch.gmap->table, 1UL <<
> > (CRST_ALLOC_ORDER + PAGE_SHIFT));  
> 
> Don't we want to memcpy first and then add it to the list?
> The gmap is still active per-se so I think we want to take the
> guest_table_lock for the list_add here.

doesn't really make a difference, it is not actually used until a few
lines later

also, the list is only ever touched here, during guest creation and
destruction; IIRC in all those cases we hold kvm->lock

> > +
> > +	asce = (kvm->arch.gmap->asce & ~PAGE_MASK) | __pa(table);
> > +	WRITE_ONCE(kvm->arch.gmap->asce, asce);
> > +	WRITE_ONCE(kvm->mm->context.gmap_asce, asce);
> > +	WRITE_ONCE(kvm->arch.gmap->table, table);  
> 
> If I remember correctly those won't need locks but I'm not 100% sure
> so please have a look at that.

it should not need locks, the VM is in use, so it can't disappear under
our feet.

> > +
> > +	return 0;
> > +}  
> 
> That should both be in gmap.c

why?

> > +
> >  /* this should not fail, but if it does, we must not free the
> > donated memory */ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16
> > *rc, u16 *rrc) {
> > @@ -169,9 +218,11 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16
> > *rc, u16 *rrc) atomic_set(&kvm->mm->context.is_protected, 0);
> >  	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x",
> > *rc, *rrc); WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc
> > %x", *rc, *rrc);
> > -	/* Inteded memory leak on "impossible" error */
> > +	/* Intended memory leak on "impossible" error */
> >  	if (!cc)
> >  		kvm_s390_pv_dealloc_vm(kvm);
> > +	else
> > +		kvm_s390_pv_replace_asce(kvm);
> >  	return cc ? -EIO : 0;
> >  }
> >  
> >   
> 

