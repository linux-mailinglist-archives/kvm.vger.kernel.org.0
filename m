Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFDB4CC02C
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 15:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbiCCOli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 09:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbiCCOlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 09:41:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DC518E411;
        Thu,  3 Mar 2022 06:40:51 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223EQ6LN017263;
        Thu, 3 Mar 2022 14:40:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tWzvjHowkM9ZLalk3vU5BpCzhINWPPar8gHBBGkQiSY=;
 b=bz5eCy69ILwayf5gsLna1mOmSTB3aVwZvrXsAP16Eai6q9XW/fZdLkXMnkALPS+imhlI
 bVsXC2loQdM2somOUf/MVqNaUEBhE322umaNb+edSJFRC0P64hkNEymtv9w9tFC/QEBJ
 4R6jsNMJX/F2O3wUA4InC2aXCUGf8zIjbereBjWfCtN8f4bQzrHeiC+abNMEKXwCsXWh
 S5gdSzod+oYcs1zOEu//CPxMwqXjYSmlRrvOyqQY/irRdBxQIs2MOt8nW6p7ZNrAMfSM
 hEdwdiF9GFcxHRr6xVCQ5843STuIgqcdWC/B7UKrnFW6oOahdXZvfUEwy8fvIX0493cK rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ejyee89kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 14:40:49 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 223ETgHF028763;
        Thu, 3 Mar 2022 14:40:48 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ejyee89k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 14:40:48 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 223EbOSD012167;
        Thu, 3 Mar 2022 14:40:47 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3efbu9gcmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 14:40:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 223EehjT32178534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Mar 2022 14:40:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6476A404D;
        Thu,  3 Mar 2022 14:40:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3328BA4055;
        Thu,  3 Mar 2022 14:40:43 +0000 (GMT)
Received: from [9.171.88.22] (unknown [9.171.88.22])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Mar 2022 14:40:43 +0000 (GMT)
Message-ID: <ff7291c0-e762-9fe9-4181-e62125bf2f59@linux.ibm.com>
Date:   Thu, 3 Mar 2022 15:40:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v8 01/17] KVM: s390: pv: leak the topmost page table when
 destroy fails
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, mimu@linux.ibm.com, nrb@linux.ibm.com
References: <20220302181143.188283-1-imbrenda@linux.ibm.com>
 <20220302181143.188283-2-imbrenda@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220302181143.188283-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jjLJm-JJJzjaQphRJB-X2Tv_HlEpXB00
X-Proofpoint-ORIG-GUID: _RZzT-NDxqHr4wj7P21quRCt1O7s5pFE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_07,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203030069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/22 19:11, Claudio Imbrenda wrote:
> Each secure guest must have a unique ASCE (address space control
> element); we must avoid that new guests use the same page for their
> ASCE, to avoid errors.
> 
> Since the ASCE mostly consists of the address of the topmost page table
> (plus some flags), we must not return that memory to the pool unless
> the ASCE is no longer in use.
> 
> Only a successful Destroy Secure Configuration UVC will make the ASCE
> reusable again.
> 
> If the Destroy Configuration UVC fails, the ASCE cannot be reused for a
> secure guest (either for the ASCE or for other memory areas). To avoid
> a collision, it must not be used again. This is a permanent error and
> the page becomes in practice unusable, so we set it aside and leak it.
> On failure we already leak other memory that belongs to the ultravisor
> (i.e. the variable and base storage for a guest) and not leaking the
> topmost page table was an oversight.
> 
> This error (and thus the leakage) should not happen unless the hardware
> is broken or KVM has some unknown serious bug.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 29b40f105ec8d55 ("KVM: s390: protvirt: Add initial vm and cpu lifecycle handling")
> ---
>  arch/s390/include/asm/gmap.h |  2 +
>  arch/s390/kvm/pv.c           |  9 +++--
>  arch/s390/mm/gmap.c          | 71 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 79 insertions(+), 3 deletions(-)
> 
[...]

> +/**
> + * s390_replace_asce - Try to replace the current ASCE of a gmap with
> + * another equivalent one.
> + * @gmap the gmap
> + *
> + * If the allocation of the new top level page table fails, the ASCE is not
> + * replaced.
> + * In any case, the old ASCE is always removed from the list. Therefore the
> + * caller has to make sure to save a pointer to it beforehands, unless an
> + * intentional leak is intended.
> + */
> +int s390_replace_asce(struct gmap *gmap)
> +{
> +	unsigned long asce;
> +	struct page *page;
> +	void *table;
> +
> +	s390_remove_old_asce(gmap);
> +
> +	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
> +	if (!page)
> +		return -ENOMEM;
> +	table = page_to_virt(page);
> +	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));

Is concurrent modification of *gmap->table possible during the copy?

> +
> +	/*
> +	 * The caller has to deal with the old ASCE, but here we make sure
> +	 * the new one is properly added to the list of page tables, so that
> +	 * it will be freed when the VM is torn down.
> +	 */
> +	spin_lock(&gmap->guest_table_lock);
> +	list_add(&page->lru, &gmap->crst_list);
> +	spin_unlock(&gmap->guest_table_lock);
> +
> +	/* Set new table origin while preserving existing ASCE control bits */
> +	asce = (gmap->asce & _ASCE_ORIGIN) | __pa(table);
> +	WRITE_ONCE(gmap->asce, asce);
> +	WRITE_ONCE(gmap->mm->context.gmap_asce, asce);
> +	WRITE_ONCE(gmap->table, table);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(s390_replace_asce);

