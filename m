Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509E3500C32
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 13:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242706AbiDNLdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 07:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235417AbiDNLdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 07:33:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E866941612;
        Thu, 14 Apr 2022 04:30:41 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EA52Nm027817;
        Thu, 14 Apr 2022 11:30:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nmaAQd4dwn2U67py14DWo8m4aBMKeyjAN7fmOivPwJA=;
 b=I6ViywZi1GfQGOs9M0yj54GUIDq1AlG051Y+NxxNkcnbSYd53b/3ZwuIgDWZLD45wt1+
 iJmgI/8w7zLg3h9QB+xK3N4yv43T1XD9H6NtBwSfhbm0TaVd2ZluSDkIdjSrjZ1YfZko
 rj+uXjtB7zHzynruKiWBe+RebYj8135nKKnnfBjuc8v9PEDRmEb7kH6XuiCyC1smaPb3
 ijj3kiiqNk2q7h6vVg3i3s74HsWRLaXyZXZ6CdtB7w3hMEgFa9M7Ax4gQgnKfNt3PoqB
 +wCnphkbxpQd9zJZ+iOsjWA6KtSuOeZdeLq/O+7XRwQz1tYL5LQnkjhimMvReRKtiiK3 zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3febxa00v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 11:30:41 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23EBFThR018078;
        Thu, 14 Apr 2022 11:30:41 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3febxa00u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 11:30:40 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23EBI8RC025033;
        Thu, 14 Apr 2022 11:30:38 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3fbsj05nv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 11:30:38 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23EBUYmw25690418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 11:30:34 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C124FA4065;
        Thu, 14 Apr 2022 11:30:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44046A405C;
        Thu, 14 Apr 2022 11:30:34 +0000 (GMT)
Received: from [9.145.89.230] (unknown [9.145.89.230])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Apr 2022 11:30:34 +0000 (GMT)
Message-ID: <cc057c0a-58ee-1012-34e4-575b053230db@linux.ibm.com>
Date:   Thu, 14 Apr 2022 13:30:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v10 01/19] KVM: s390: pv: leak the topmost page table when
 destroy fails
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
 <20220414080311.1084834-2-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220414080311.1084834-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pHaqE5irsv5cQHvsFG02lxyl6xOfacfH
X-Proofpoint-ORIG-GUID: eJX2892CoFLhA2EN96R_SOtu-RmxxX7o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_03,2022-04-14_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140060
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/14/22 10:02, Claudio Imbrenda wrote:
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

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> +	/*
> +	 * In case the ASCE needs to be "removed" multiple times, for example
> +	 * if the VM is rebooted into secure mode several times
> +	 * concurrently, or if s390_replace_asce fails after calling
> +	 * s390_remove_old_asce and is attempted again later. In that case
> +	 * the old asce has been removed from the list, and therefore it
> +	 * will not be freed when the VM terminates, but the ASCE is still
> +	 * in use and still pointed to.
> +	 * A subsequent call to replace_asce will follow the pointer and try
> +	 * to remove the same page from the list again.
> +	 * Therefore it's necessary that the page of the ASCE has valid
> +	 * pointers, so list_del can work (and do nothing) without
> +	 * dereferencing stale or invalid pointers.
> +	 */
> +	INIT_LIST_HEAD(&old->lru);
> +	spin_unlock(&gmap->guest_table_lock);
> +}
> +EXPORT_SYMBOL_GPL(s390_remove_old_asce);
> +
> +/**
> + * s390_replace_asce - Try to replace the current ASCE of a gmap with
> + * another equivalent one.

with a copy?

> + * @gmap the gmap
> + *
> + * If the allocation of the new top level page table fails, the ASCE is not
> + * replaced.
> + * In any case, the old ASCE is always removed from the list. Therefore the

removed from the gmap crst list

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
> +	asce = (gmap->asce & ~_ASCE_ORIGIN) | __pa(table);
> +	WRITE_ONCE(gmap->asce, asce);
> +	WRITE_ONCE(gmap->mm->context.gmap_asce, asce);
> +	WRITE_ONCE(gmap->table, table);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(s390_replace_asce);

