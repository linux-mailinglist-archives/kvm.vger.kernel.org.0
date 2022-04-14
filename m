Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74C1500CEE
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 14:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243069AbiDNMVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 08:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbiDNMVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 08:21:42 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741595677B;
        Thu, 14 Apr 2022 05:19:17 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EC4089033223;
        Thu, 14 Apr 2022 12:19:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=7hTOhY4Gjs5DHekNEse80mAKRoExlIGNYAHF3+n0hzQ=;
 b=dyV3DReDtAnw+GXDk3CrnnQeoHIxQIBTY9F4V2ERMaDJ4aSvrJIz4DFzvNJ1l6DsqrXe
 KonMJgdvKEDDwdNBa+NP8lQ+rsv09y5jm/fSzipRDxgVeQsO9xkpAEJkqO77yvOJzb7w
 kpEqylHu3cf4Pxpm5JVEkGMVy3pCI6dej9iLfvqOBkEfKi0jvLNQlzzC+CiHM82yAQ7k
 xBX6noni5N4pstEOzq/Q3iII09DlnNyzUPhrIXjMT/dio4POJcKMlXTq1HXP9Wk8E5xj
 +4lWgh8hPmoSwkQrrkzW+0t1zdAOe0Una9YENS/9H93v+61L7Ue2RCJ5mINBKUJI+Rvl XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fef1p5exx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 12:19:16 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23EC69Tr003480;
        Thu, 14 Apr 2022 12:19:16 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fef1p5exb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 12:19:15 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23ECBtR9031687;
        Thu, 14 Apr 2022 12:19:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3fb1dj8fvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 12:19:14 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23EC6bRW28377348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 12:06:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CFA911C050;
        Thu, 14 Apr 2022 12:19:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F0B111C04C;
        Thu, 14 Apr 2022 12:19:10 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.140])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Apr 2022 12:19:10 +0000 (GMT)
Date:   Thu, 14 Apr 2022 14:19:08 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v10 01/19] KVM: s390: pv: leak the topmost page table
 when destroy fails
Message-ID: <20220414141908.1ba04a38@p-imbrenda>
In-Reply-To: <cc057c0a-58ee-1012-34e4-575b053230db@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
        <20220414080311.1084834-2-imbrenda@linux.ibm.com>
        <cc057c0a-58ee-1012-34e4-575b053230db@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lTYcqtpuQn1xSTVnPB5J3BzhCbusdvOx
X-Proofpoint-ORIG-GUID: JN7UPdRLJZ5OKFrmqRYZxaY8kozqKHqP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_04,2022-04-14_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Apr 2022 13:30:33 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 4/14/22 10:02, Claudio Imbrenda wrote:
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
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 
> > +	/*
> > +	 * In case the ASCE needs to be "removed" multiple times, for example
> > +	 * if the VM is rebooted into secure mode several times
> > +	 * concurrently, or if s390_replace_asce fails after calling
> > +	 * s390_remove_old_asce and is attempted again later. In that case
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
> 
> with a copy?

will fix

> 
> > + * @gmap the gmap
> > + *
> > + * If the allocation of the new top level page table fails, the ASCE is not
> > + * replaced.
> > + * In any case, the old ASCE is always removed from the list. Therefore the  
> 
> removed from the gmap crst list

will fix

> 
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

