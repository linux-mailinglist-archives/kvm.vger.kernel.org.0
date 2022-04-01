Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6ED04EF744
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 18:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiDAPzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 11:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352324AbiDAPWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 11:22:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC75C3CFC9;
        Fri,  1 Apr 2022 08:03:33 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 231EDTrd010712;
        Fri, 1 Apr 2022 15:03:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Wgqc0ZYvnXN4jSICangZboZXwxC+LF/TjMq5lsL1PuM=;
 b=L1ELKdlJOwXZ5ymPrhGvLV8l6im3b+8JHOvhAMETmT+3KOxxSEszs0Deoi7r+rzRPoTZ
 zFTI8oE665+kMYKpb8V9c0wIszx321RKDfRNmYiWj2v+/3DvWah7Ayw3VNXxmSmIGZWI
 uZL6HQNH2yB3VyJhvvi90ZHea/pl5fTHkuXCqkBJUpLxz+og7ePs35RHy3pDx83Hnyzx
 ZDtcgvzURN2FyYyg/BelQF8Rg58fLOBlUQ24U12a/jxCkdouXqp+EIgA9v27hDzAXX+s
 wX0ZOeDol4Q6TssBXp6XBuxi8oqs8sEx288i6+h5RLdRmUBmf9rWnlzKRfGPie+AaZeR QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f62y91244-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 15:03:32 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231EIvss029812;
        Fri, 1 Apr 2022 15:03:32 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f62y9122r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 15:03:32 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231EwCUS023958;
        Fri, 1 Apr 2022 15:03:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3f3rs3r8k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 15:03:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231F3QDx31523152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 15:03:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30AD64203F;
        Fri,  1 Apr 2022 15:03:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D77E42042;
        Fri,  1 Apr 2022 15:03:25 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.73])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 15:03:25 +0000 (GMT)
Date:   Fri, 1 Apr 2022 17:03:20 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v9 11/18] s390/mm: KVM: pv: when tearing down, try to
 destroy protected pages
Message-ID: <20220401170320.4b985bc9@p-imbrenda>
In-Reply-To: <a61d614f-df0a-d0a8-c1f1-45a915e26b23@linux.ibm.com>
References: <20220330122605.247613-1-imbrenda@linux.ibm.com>
        <20220330122605.247613-12-imbrenda@linux.ibm.com>
        <a61d614f-df0a-d0a8-c1f1-45a915e26b23@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n-Ye25tC6IAgsGzX09Ork2zbvEwOwVBH
X-Proofpoint-ORIG-GUID: jkkba_k1_of4SFej0kaV6qgkPHpUHSQK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_05,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 phishscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

On Thu, 31 Mar 2022 15:34:42 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 3/30/22 14:25, Claudio Imbrenda wrote:
> > When ptep_get_and_clear_full is called for a mm teardown, we will now
> > attempt to destroy the secure pages. This will be faster than export.
> > 
> > In case it was not a teardown, or if for some reason the destroy page
> > UVC failed, we try with an export page, like before.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Acked-by: Janosch Frank <frankja@linux.ibm.com>
> > ---
> >   arch/s390/include/asm/pgtable.h | 18 +++++++++++++++---
> >   1 file changed, 15 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> > index 23ca0d8e058a..72544a1b4a68 100644
> > --- a/arch/s390/include/asm/pgtable.h
> > +++ b/arch/s390/include/asm/pgtable.h
> > @@ -1118,9 +1118,21 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
> >   	} else {
> >   		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
> >   	}
> > -	/* At this point the reference through the mapping is still present */
> > -	if (mm_is_protected(mm) && pte_present(res))
> > -		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
> > +	/* Nothing to do */
> > +	if (!mm_is_protected(mm) || !pte_present(res))
> > +		return res;
> > +	/*
> > +	 * At this point the reference through the mapping is still present.  
> 
> That's the case because we zap ptes within a mm that's still existing, 
> right? The mm will be deleted after we have unmapped the memory.

not exactly, the mm can exist without pages.

the reference is there because when we enter the function,
there is still a pointer to the page (the PTE itself), the page is still
reachable, and therefore its reference count cannot be less than 1.

when we leave the function, there is no more mapping for the page
(that's the point of the function after all), and only then the counter
can be decremented.

if you look at zap_pte_range in mm/memory.c, you see that we call
ptep_get_and_clear_full first, and then a few lines below we call
__tlb_remove_page which in the end calls put_page on that page.

> 
> 
> > +	 * The notifier should have destroyed all protected vCPUs at this
> > +	 * point, so the destroy should be successful.
> > +	 */
> > +	if (full && !uv_destroy_owned_page(pte_val(res) & PAGE_MASK))
> > +		return res;
> > +	/*
> > +	 * But if something went wrong and the pages could not be destroyed,
> > +	 * the slower export is used as fallback instead.
> > +	 */
> > +	uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
> >   	return res;
> >   }
> >     
> 

