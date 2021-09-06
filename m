Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC911401DDB
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 17:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242942AbhIFP5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 11:57:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4536 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231591AbhIFP5g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 11:57:36 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 186FYWTw124791;
        Mon, 6 Sep 2021 11:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=tW88Ov1dbm7lbHqTTuY5Cu8zRHkIrYbGCNmvGwPlkRc=;
 b=pgZqp4a91fEvnGPLt9Z5oeRndR0fxDHqHhAftz4goPotlMQlSKbSHrIJHB5vWUUGiyWk
 lcsUTCwoZ8kuHjOHkJZ6PE06ANPijl3JtQbFbbG0ZpFgL4dqBt0hqcfEiVP0Nfen23e3
 A0SGzx1fdekFRVGGEYdhIqBWQphSQkXVF6NmVleXtnq1tyzJoQuULproLYcMkGfCFoNb
 YA6CdV8ivgGZKh4RN0Mxc2KBxeMKDoWU6YP53Gwj6t10TdBdX8y0J5skvbnWEN6UKNC3
 OV04r6wgZFAAulYVO+5SI8S/dflt2hRzBEzQDMwkjEGNND989JCxJBoU58xGCwQo30u/ Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awh9cxsar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 11:56:31 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 186FZI1m130107;
        Mon, 6 Sep 2021 11:56:31 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awh9cxsab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 11:56:31 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 186FrUWr018591;
        Mon, 6 Sep 2021 15:56:28 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3av02je1y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 15:56:28 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 186FuOhL57540970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Sep 2021 15:56:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C81A111C05C;
        Mon,  6 Sep 2021 15:56:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 625F211C04A;
        Mon,  6 Sep 2021 15:56:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.215])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  6 Sep 2021 15:56:24 +0000 (GMT)
Date:   Mon, 6 Sep 2021 17:56:18 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: Re: [PATCH v4 06/14] KVM: s390: pv: properly handle page flags for
 protected guests
Message-ID: <20210906175618.4ce0323f@p-imbrenda>
In-Reply-To: <1a44ff5c-f59f-2f37-2585-084294ed5e11@de.ibm.com>
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
        <20210818132620.46770-7-imbrenda@linux.ibm.com>
        <1a44ff5c-f59f-2f37-2585-084294ed5e11@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ERcBGTweHL2nL5PdYs4TijP0aMKbEZRN
X-Proofpoint-ORIG-GUID: x3Dl5fBw0vWACqrJai_MXM-T70LsTKmj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-06_06:2021-09-03,2021-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 spamscore=0
 phishscore=0 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109060099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 6 Sep 2021 17:46:40 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 18.08.21 15:26, Claudio Imbrenda wrote:
> > Introduce variants of the convert and destroy page functions that also
> > clear the PG_arch_1 bit used to mark them as secure pages.
> > 
> > These new functions can only be called on pages for which a reference
> > is already being held.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Acked-by: Janosch Frank <frankja@linux.ibm.com>  
> 
> Can you refresh my mind? We do have over-indication of PG_arch_1 and this
> might result in spending some unneeded cycles but in the end this will be
> correct. Right?
> And this patch will fix some unnecessary places that add overindication.

correct, PG_arch_1 will still overindicate, but with this patch it will
happen less.

And PG_arch_1 overindication is perfectly fine from a correctness point
of view.

> > ---
> >   arch/s390/include/asm/pgtable.h |  9 ++++++---
> >   arch/s390/include/asm/uv.h      | 10 ++++++++--
> >   arch/s390/kernel/uv.c           | 34 ++++++++++++++++++++++++++++++++-
> >   arch/s390/mm/gmap.c             |  4 +++-
> >   4 files changed, 50 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> > index dcac7b2df72c..0f1af2232ebe 100644
> > --- a/arch/s390/include/asm/pgtable.h
> > +++ b/arch/s390/include/asm/pgtable.h
> > @@ -1074,8 +1074,9 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
> >   	pte_t res;
> >   
> >   	res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
> > +	/* At this point the reference through the mapping is still present */
> >   	if (mm_is_protected(mm) && pte_present(res))
> > -		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> > +		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
> >   	return res;
> >   }
> >   
> > @@ -1091,8 +1092,9 @@ static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
> >   	pte_t res;
> >   
> >   	res = ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID));
> > +	/* At this point the reference through the mapping is still present */
> >   	if (mm_is_protected(vma->vm_mm) && pte_present(res))
> > -		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> > +		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
> >   	return res;
> >   }
> >   
> > @@ -1116,8 +1118,9 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
> >   	} else {
> >   		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
> >   	}
> > +	/* At this point the reference through the mapping is still present */
> >   	if (mm_is_protected(mm) && pte_present(res))
> > -		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
> > +		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
> >   	return res;
> >   }
> >   
> > diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> > index b35add51b967..3236293d5a31 100644
> > --- a/arch/s390/include/asm/uv.h
> > +++ b/arch/s390/include/asm/uv.h
> > @@ -356,8 +356,9 @@ static inline int is_prot_virt_host(void)
> >   }
> >   
> >   int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
> > -int uv_destroy_page(unsigned long paddr);
> > +int uv_destroy_owned_page(unsigned long paddr);
> >   int uv_convert_from_secure(unsigned long paddr);
> > +int uv_convert_owned_from_secure(unsigned long paddr);
> >   int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
> >   
> >   void setup_uv(void);
> > @@ -367,7 +368,7 @@ void adjust_to_uv_max(unsigned long *vmax);
> >   static inline void setup_uv(void) {}
> >   static inline void adjust_to_uv_max(unsigned long *vmax) {}
> >   
> > -static inline int uv_destroy_page(unsigned long paddr)
> > +static inline int uv_destroy_owned_page(unsigned long paddr)
> >   {
> >   	return 0;
> >   }
> > @@ -376,6 +377,11 @@ static inline int uv_convert_from_secure(unsigned long paddr)
> >   {
> >   	return 0;
> >   }
> > +
> > +static inline int uv_convert_owned_from_secure(unsigned long paddr)
> > +{
> > +	return 0;
> > +}
> >   #endif
> >   
> >   #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) || IS_ENABLED(CONFIG_KVM)
> > diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> > index 68a8fbafcb9c..05f8bf61d20a 100644
> > --- a/arch/s390/kernel/uv.c
> > +++ b/arch/s390/kernel/uv.c
> > @@ -115,7 +115,7 @@ static int uv_pin_shared(unsigned long paddr)
> >    *
> >    * @paddr: Absolute host address of page to be destroyed
> >    */
> > -int uv_destroy_page(unsigned long paddr)
> > +static int uv_destroy_page(unsigned long paddr)
> >   {
> >   	struct uv_cb_cfs uvcb = {
> >   		.header.cmd = UVC_CMD_DESTR_SEC_STOR,
> > @@ -135,6 +135,22 @@ int uv_destroy_page(unsigned long paddr)
> >   	return 0;
> >   }
> >   
> > +/*
> > + * The caller must already hold a reference to the page
> > + */
> > +int uv_destroy_owned_page(unsigned long paddr)
> > +{
> > +	struct page *page = phys_to_page(paddr);
> > +	int rc;
> > +
> > +	get_page(page);
> > +	rc = uv_destroy_page(paddr);
> > +	if (!rc)
> > +		clear_bit(PG_arch_1, &page->flags);
> > +	put_page(page);
> > +	return rc;
> > +}
> > +
> >   /*
> >    * Requests the Ultravisor to encrypt a guest page and make it
> >    * accessible to the host for paging (export).
> > @@ -154,6 +170,22 @@ int uv_convert_from_secure(unsigned long paddr)
> >   	return 0;
> >   }
> >   
> > +/*
> > + * The caller must already hold a reference to the page
> > + */
> > +int uv_convert_owned_from_secure(unsigned long paddr)
> > +{
> > +	struct page *page = phys_to_page(paddr);
> > +	int rc;
> > +
> > +	get_page(page);
> > +	rc = uv_convert_from_secure(paddr);
> > +	if (!rc)
> > +		clear_bit(PG_arch_1, &page->flags);
> > +	put_page(page);
> > +	return rc;
> > +}
> > +
> >   /*
> >    * Calculate the expected ref_count for a page that would otherwise have no
> >    * further pins. This was cribbed from similar functions in other places in
> > diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> > index 5a138f6220c4..38b792ab57f7 100644
> > --- a/arch/s390/mm/gmap.c
> > +++ b/arch/s390/mm/gmap.c
> > @@ -2678,8 +2678,10 @@ static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
> >   {
> >   	pte_t pte = READ_ONCE(*ptep);
> >   
> > +	/* There is a reference through the mapping */
> >   	if (pte_present(pte))
> > -		WARN_ON_ONCE(uv_destroy_page(pte_val(pte) & PAGE_MASK));
> > +		WARN_ON_ONCE(uv_destroy_owned_page(pte_val(pte) & PAGE_MASK));
> > +
> >   	return 0;
> >   }
> >   
> >   

