Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E40322D6A
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 16:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhBWPXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 10:23:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18110 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233194AbhBWPXb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 10:23:31 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NF37ZE049882;
        Tue, 23 Feb 2021 10:22:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=AeTLRAiqELcN1vY/S+DHhmL/3ihuk9h4G3bhNKL/w10=;
 b=YtCTJ7aBtjzOq2OrkW4IbiJIJ3GGSMRiwgcTIqAaP0BrezqojjceDzBbqQ8uYP/sVrAb
 EvhKG473Fw8DsMbKYAmO/hW1rNXIEEal1RZWWWo9TG3GaIdI2vTx9LsxNyiWQRH08ZtX
 OtSCIm8jaGSZXvVUvFCtO0ZxtwLiBA6QYIsAcOl4h5NdQ+8JLAz54d763UhHUqFfifH8
 kxzQ9PXe7upeQaPGEBimRimMxSXZ8TQJr9iYjCljsh/TAEGXIIp1sakuSeKCbzsQnro3
 /oD9lixiHR5sn918ixaWblTGJ7wSYZTd44G7X7YhWe9WkOdMi5kS4OpdleM4McCXrGTW mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkmadwgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 10:22:44 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NF3FlR050706;
        Tue, 23 Feb 2021 10:22:44 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkmadwg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 10:22:44 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NF8eEh009413;
        Tue, 23 Feb 2021 15:22:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 36tt289dy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 15:22:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NFMdbV41025852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 15:22:39 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81B12A4054;
        Tue, 23 Feb 2021 15:22:39 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D313A4060;
        Tue, 23 Feb 2021 15:22:39 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.5.213])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Feb 2021 15:22:39 +0000 (GMT)
Date:   Tue, 23 Feb 2021 16:21:47 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, pmorel@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/5] s390x: lib: improve pgtable.h
Message-ID: <20210223162147.7042e7dc@ibm-vm>
In-Reply-To: <3e87c3ec-2b32-05d2-aaed-d844be847bf2@linux.ibm.com>
References: <20210223140759.255670-1-imbrenda@linux.ibm.com>
        <20210223140759.255670-4-imbrenda@linux.ibm.com>
        <3e87c3ec-2b32-05d2-aaed-d844be847bf2@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_08:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230129
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Feb 2021 15:35:28 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 2/23/21 3:07 PM, Claudio Imbrenda wrote:
> > Improve pgtable.h:
> > 
> > * add macros to check whether a pmd or a pud are large / huge
> > * add idte functions for pmd, pud, p4d and pgd
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> Could you please make the subject more specific?
> "s390x: lib: Add idte and huge entry check functions"

will do

> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> 
> > ---
> >  lib/s390x/asm/pgtable.h | 31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> > 
> > diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
> > index a2ff2d4e..70d4afde 100644
> > --- a/lib/s390x/asm/pgtable.h
> > +++ b/lib/s390x/asm/pgtable.h
> > @@ -100,6 +100,9 @@
> >  #define pmd_none(entry) (pmd_val(entry) & SEGMENT_ENTRY_I)
> >  #define pte_none(entry) (pte_val(entry) & PAGE_ENTRY_I)
> >  
> > +#define pud_huge(entry)  (pud_val(entry) & REGION3_ENTRY_FC)
> > +#define pmd_large(entry) (pmd_val(entry) & SEGMENT_ENTRY_FC)
> > +
> >  #define pgd_addr(entry) __va(pgd_val(entry) & REGION_ENTRY_ORIGIN)
> >  #define p4d_addr(entry) __va(p4d_val(entry) & REGION_ENTRY_ORIGIN)
> >  #define pud_addr(entry) __va(pud_val(entry) & REGION_ENTRY_ORIGIN)
> > @@ -216,6 +219,34 @@ static inline void ipte(unsigned long vaddr,
> > pteval_t *p_pte) : : "a" (table_origin), "a" (vaddr) : "memory");
> >  }
> >  
> > +static inline void idte(unsigned long table_origin, unsigned long
> > vaddr) +{
> > +	vaddr &= SEGMENT_ENTRY_SFAA;
> > +	asm volatile(
> > +		"	idte %0,0,%1\n"
> > +		: : "a" (table_origin), "a" (vaddr) : "memory");
> > +}
> > +
> > +static inline void idte_pmdp(unsigned long vaddr, pmdval_t *pmdp)
> > +{
> > +	idte((unsigned long)(pmdp - pmd_index(vaddr)) |
> > ASCE_DT_SEGMENT, vaddr); +}
> > +
> > +static inline void idte_pudp(unsigned long vaddr, pudval_t *pudp)
> > +{
> > +	idte((unsigned long)(pudp - pud_index(vaddr)) |
> > ASCE_DT_REGION3, vaddr); +}
> > +
> > +static inline void idte_p4dp(unsigned long vaddr, p4dval_t *p4dp)
> > +{
> > +	idte((unsigned long)(p4dp - p4d_index(vaddr)) |
> > ASCE_DT_REGION2, vaddr); +}
> > +
> > +static inline void idte_pgdp(unsigned long vaddr, pgdval_t *pgdp)
> > +{
> > +	idte((unsigned long)(pgdp - pgd_index(vaddr)) |
> > ASCE_DT_REGION1, vaddr); +}
> > +
> >  void configure_dat(int enable);
> >  
> >  #endif /* _ASMS390X_PGTABLE_H_ */
> >   
> 

