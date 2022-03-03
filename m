Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68E94CC0A5
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 16:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbiCCPGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 10:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbiCCPGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 10:06:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFFF1903E8;
        Thu,  3 Mar 2022 07:05:59 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223DraAF023446;
        Thu, 3 Mar 2022 15:05:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=2lJB5IciALVLGT3XMIlnYZtf1pXTz5WbRx1MT3ce5yc=;
 b=BGvzShiW6XK454YunH6FAn/mduYRS0GKAkdWyRlb6rKcuGtwK31CbTiOXi/8oQRfR1iL
 qUvgPryZLe1UCeiZBTMddxV30S83lwJKLM9Dm9r2xsBrfRTR7J2kCpSmpGsbfHOcUeAM
 3uaeb1qQT4EQeB9a3kaNvRbWtKSmlZh3xAvmBV49oK9vQaLniM9USj3756wxkNTnZlrZ
 aWDEDLkgC2vIx3PczFOcs6zF4jhv1sk+Ye/FCO3OOMpxFHOxXH9ec7Y6P2dlNZIesY9+
 Nq76ZVRmzSh8eFSUBC6yQ9O82sTWDwaxq7qmSDbN6qXfz1ZyFHFsMVqn2BFjHxdAV8/w bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ejvpqmmx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 15:05:58 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 223DwEYr021826;
        Thu, 3 Mar 2022 15:05:57 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ejvpqmmw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 15:05:57 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 223Evh8k027060;
        Thu, 3 Mar 2022 15:05:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3egbj1dfg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 15:05:55 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 223F5pB350069972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Mar 2022 15:05:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E39811C04C;
        Thu,  3 Mar 2022 15:05:51 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E1BF11C04A;
        Thu,  3 Mar 2022 15:05:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.6.81])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Mar 2022 15:05:50 +0000 (GMT)
Date:   Thu, 3 Mar 2022 16:05:47 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v8 01/17] KVM: s390: pv: leak the topmost page table
 when destroy fails
Message-ID: <20220303160547.391db6d9@p-imbrenda>
In-Reply-To: <ff7291c0-e762-9fe9-4181-e62125bf2f59@linux.ibm.com>
References: <20220302181143.188283-1-imbrenda@linux.ibm.com>
        <20220302181143.188283-2-imbrenda@linux.ibm.com>
        <ff7291c0-e762-9fe9-4181-e62125bf2f59@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sFN4_W4LgkV8GNZaO4aQs0YyFJA0qJPV
X-Proofpoint-GUID: kvIefrS_K3CzF7hfp9E-GxV3THs2qyQA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_07,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 adultscore=0
 clxscore=1015 mlxlogscore=999 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203030072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Mar 2022 15:40:42 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> On 3/2/22 19:11, Claudio Imbrenda wrote:
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
> >  arch/s390/include/asm/gmap.h |  2 +
> >  arch/s390/kvm/pv.c           |  9 +++--
> >  arch/s390/mm/gmap.c          | 71 ++++++++++++++++++++++++++++++++++++
> >  3 files changed, 79 insertions(+), 3 deletions(-)
> >   
> [...]
> 
> > +/**
> > + * s390_replace_asce - Try to replace the current ASCE of a gmap with
> > + * another equivalent one.
> > + * @gmap the gmap
> > + *
> > + * If the allocation of the new top level page table fails, the ASCE is not
> > + * replaced.
> > + * In any case, the old ASCE is always removed from the list. Therefore the
> > + * caller has to make sure to save a pointer to it beforehands, unless an
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
> > +	table = page_to_virt(page);
> > +	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));  
> 
> Is concurrent modification of *gmap->table possible during the copy?

that would only be possible if the guest touches memory in such way
that the table needs to be changed.

this function is only called when the guest is not running (e.g. during
reboot), so nobody should touch the table

> 
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
> > +	asce = (gmap->asce & _ASCE_ORIGIN) | __pa(table);
> > +	WRITE_ONCE(gmap->asce, asce);
> > +	WRITE_ONCE(gmap->mm->context.gmap_asce, asce);
> > +	WRITE_ONCE(gmap->table, table);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(s390_replace_asce);  
> 

