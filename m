Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4DF199AEC
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 18:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731203AbgCaQHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 12:07:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731153AbgCaQHO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 12:07:14 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02VG3JXa057583
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 12:07:13 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30206ydsrd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 12:07:13 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <rppt@linux.ibm.com>;
        Tue, 31 Mar 2020 17:07:05 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 31 Mar 2020 17:07:01 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02VG77c447775936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 16:07:07 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EB37AE056;
        Tue, 31 Mar 2020 16:07:07 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54913AE04D;
        Tue, 31 Mar 2020 16:07:06 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.148.207.69])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 31 Mar 2020 16:07:06 +0000 (GMT)
Date:   Tue, 31 Mar 2020 19:07:03 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH] KVM: MIPS: fix compilation
References: <20200331154749.5457-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331154749.5457-1-pbonzini@redhat.com>
X-TM-AS-GCONF: 00
x-cbid: 20033116-0012-0000-0000-0000039BB633
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20033116-0013-0000-0000-000021D8C2EF
Message-Id: <20200331160703.GF30942@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_05:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=929 suspectscore=1
 bulkscore=0 phishscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003310141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 31, 2020 at 11:47:49AM -0400, Paolo Bonzini wrote:
> Commit 31168f033e37 is correct that pud_index() & __pud_offset() are the same
> when pud_index() is actually provided, however it does not take into account
> the __PAGETABLE_PUD_FOLDED case.  Provide kvm_pud_index so that MIPS KVM
> compiles.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/mips/kvm/mmu.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
> index 7dad7a293eae..ccf98c22fd2c 100644
> --- a/arch/mips/kvm/mmu.c
> +++ b/arch/mips/kvm/mmu.c
> @@ -25,6 +25,12 @@
>  #define KVM_MMU_CACHE_MIN_PAGES 2
>  #endif
>  
> +#if defined(__PAGETABLE_PUD_FOLDED)
> +#define kvm_pud_index(gva) 0
> +#else
> +#define kvm_pud_index(gva) pud_index(gva)
> +#endif
> +

I'd prefer simply making pud_index() always defined. When pud level is
folded asm-generic/pgtable-nopud.h will define PTRS_PER_PUD to 1 and
pud_index() will evaluate to 0 anyway.

diff --git a/arch/mips/include/asm/pgtable-64.h b/arch/mips/include/asm/pgtable-64.h
index f92716cfa4f4..ee5dc0c145b9 100644
--- a/arch/mips/include/asm/pgtable-64.h
+++ b/arch/mips/include/asm/pgtable-64.h
@@ -172,6 +172,8 @@
 
 extern pte_t invalid_pte_table[PTRS_PER_PTE];
 
+#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
+
 #ifndef __PAGETABLE_PUD_FOLDED
 /*
  * For 4-level pagetables we defines these ourselves, for 3-level the
@@ -210,8 +212,6 @@ static inline void p4d_clear(p4d_t *p4dp)
 	p4d_val(*p4dp) = (unsigned long)invalid_pud_table;
 }
 
-#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
-
 static inline unsigned long p4d_page_vaddr(p4d_t p4d)
 {
 	return p4d_val(p4d);

>  static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
>  				  int min, int max)
>  {
> @@ -234,8 +240,8 @@ static bool kvm_mips_flush_gpa_pud(pud_t *pud, unsigned long start_gpa,
>  {
>  	pmd_t *pmd;
>  	unsigned long end = ~0ul;
> -	int i_min = pud_index(start_gpa);
> -	int i_max = pud_index(end_gpa);
> +	int i_min = kvm_pud_index(start_gpa);
> +	int i_max = kvm_pud_index(end_gpa);
>  	bool safe_to_remove = (i_min == 0 && i_max == PTRS_PER_PUD - 1);
>  	int i;
>  
> @@ -361,8 +367,8 @@ static int kvm_mips_##name##_pud(pud_t *pud, unsigned long start,	\
>  	int ret = 0;							\
>  	pmd_t *pmd;							\
>  	unsigned long cur_end = ~0ul;					\
> -	int i_min = pud_index(start);				\
> -	int i_max = pud_index(end);					\
> +	int i_min = kvm_pud_index(start);				\
> +	int i_max = kvm_pud_index(end);					\
>  	int i;								\
>  									\
>  	for (i = i_min; i <= i_max; ++i, start = 0) {			\
> @@ -896,8 +902,8 @@ static bool kvm_mips_flush_gva_pud(pud_t *pud, unsigned long start_gva,
>  {
>  	pmd_t *pmd;
>  	unsigned long end = ~0ul;
> -	int i_min = pud_index(start_gva);
> -	int i_max = pud_index(end_gva);
> +	int i_min = kvm_pud_index(start_gva);
> +	int i_max = kvm_pud_index(end_gva);
>  	bool safe_to_remove = (i_min == 0 && i_max == PTRS_PER_PUD - 1);
>  	int i;
>  
> -- 
> 2.18.2
> 

-- 
Sincerely yours,
Mike.

