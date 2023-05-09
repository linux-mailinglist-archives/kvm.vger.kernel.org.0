Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA1F6FC5B4
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 13:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbjEIL75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 07:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234783AbjEIL7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 07:59:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79344FA;
        Tue,  9 May 2023 04:59:54 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 349BRo2n011242;
        Tue, 9 May 2023 11:59:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=o0qyN5dTTBE89PMggpKSegxyyCQ4S7DBukr1wkMx5Io=;
 b=BzIEGEgS8QWc+TBjN92NgaAUExtehh+jOKOoZP/dfDDwfIN+RTsVJPrDtTvCEn2UiPlV
 mhRp0GIHauwjqo9O2CHGfeFdvjtu4rijWtPlqFJhXVqx1LhOtlVh3HjI9d805bKS9kc4
 K763TqsHDEwm3Jy1fpatFCdz1oe1HtQIb1Pz9Zpn/opFB9D9LNkCK2P+LauOsEFApMkA
 8PMZpPQ6/ugEe6/c1L9XRml9I503uxQx4QgciPx3sM1JDTpyDwrK4pwOB/QzD3dJvXt8
 F9jY1JYLQWyBqAv3eaglhRnnoatJ8Pe8WC9stlaNcqKDiGlr0puAnq0/n84earPMzQt5 fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfmb32dvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:59:53 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 349BnVFb026790;
        Tue, 9 May 2023 11:59:53 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfmb32du8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:59:53 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3492mfmm022263;
        Tue, 9 May 2023 11:59:50 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qf896rdh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:59:50 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 349Bxlao40174000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 May 2023 11:59:47 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F33B2004D;
        Tue,  9 May 2023 11:59:47 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB5F32004E;
        Tue,  9 May 2023 11:59:46 +0000 (GMT)
Received: from [9.171.74.57] (unknown [9.171.74.57])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  9 May 2023 11:59:46 +0000 (GMT)
Message-ID: <c762bd30-9753-7b3e-3f46-b15ba575ee7c@linux.ibm.com>
Date:   Tue, 9 May 2023 13:59:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230509111202.333714-1-nrb@linux.ibm.com>
 <20230509111202.333714-3-nrb@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v1 2/3] KVM: s390: add stat counter for shadow gmap events
In-Reply-To: <20230509111202.333714-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: omvTEdiiMHIAl_w4jdzO-3K8Uffq4YFc
X-Proofpoint-GUID: q7nn9e5KdceUtwNuAvKthT5NaTwKluFS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_07,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 spamscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305090092
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/9/23 13:12, Nico Boehr wrote:
> The shadow gmap tracks memory of nested guests (guest-3). In certain
> scenarios, the shadow gmap needs to be rebuilt, which is a costly operation
> since it involves a SIE exit into guest-1 for every entry in the respective
> shadow level.
> 
> Add kvm stat counters when new shadow structures are created at various
> levels. Also add a counter gmap_shadow_acquire when a completely fresh
> shadow gmap is created.
> 
> Note that there is no counter for the region first level. This is because
> the region first level is the highest level and hence is never referenced
> by another table. Creating a new region first table is therefore always
> equivalent to a new shadow gmap and hence is counted as
> gmap_shadow_acquire.
> 
> Also note that not all page table levels need to be present and a ASCE
> can directly point to e.g. a segment table. In this case, a new segment
> table will always be equivalent to a new shadow gmap and hence will be
> counted as gmap_shadow_acquire and not as gmap_shadow_segment.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h | 5 +++++
>   arch/s390/kvm/gaccess.c          | 6 ++++++
>   arch/s390/kvm/kvm-s390.c         | 7 ++++++-
>   arch/s390/kvm/vsie.c             | 1 +
>   4 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 3c3fe45085ec..7f70e3bbb44c 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -777,6 +777,11 @@ struct kvm_vm_stat {
>   	u64 inject_service_signal;
>   	u64 inject_virtio;
>   	u64 aen_forward;
> +	u64 gmap_shadow_acquire;
> +	u64 gmap_shadow_r2;
> +	u64 gmap_shadow_r3;
> +	u64 gmap_shadow_segment;
> +	u64 gmap_shadow_page;

This needs to be gmap_shadow_pgt and then we need a separate shadow page 
counter that's beeing incremented in kvm_s390_shadow_fault().


I'm wondering if we should name them after the entries to reduce 
confusion especially when we get huge pages in the future.

gmap_shadow_acquire
gmap_shadow_r1_te (ptr to r2 table)
gmap_shadow_r2_te (ptr to r3 table)
gmap_shadow_r3_te (ptr to segment table)
gmap_shadow_sg_te (ptr to page table)
gmap_shadow_pg_te (single page table entry)

>   };
>   
>   struct kvm_arch_memory_slot {
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 3eb85f254881..8348a0095f3a 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -1382,6 +1382,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   				  unsigned long *pgt, int *dat_protection,
>   				  int *fake)
>   {
> +	struct kvm *kvm;
>   	struct gmap *parent;
>   	union asce asce;
>   	union vaddress vaddr;
> @@ -1390,6 +1391,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   
>   	*fake = 0;
>   	*dat_protection = 0;
> +	kvm = sg->private;
>   	parent = sg->parent;
>   	vaddr.addr = saddr;
>   	asce.val = sg->orig_asce;
> @@ -1450,6 +1452,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   		rc = gmap_shadow_r2t(sg, saddr, rfte.val, *fake);
>   		if (rc)
>   			return rc;
> +		kvm->stat.gmap_shadow_r2++;
>   	}
>   		fallthrough;
>   	case ASCE_TYPE_REGION2: {
> @@ -1478,6 +1481,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   		rc = gmap_shadow_r3t(sg, saddr, rste.val, *fake);
>   		if (rc)
>   			return rc;
> +		kvm->stat.gmap_shadow_r3++;
>   	}
>   		fallthrough;
>   	case ASCE_TYPE_REGION3: {
> @@ -1515,6 +1519,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   		rc = gmap_shadow_sgt(sg, saddr, rtte.val, *fake);
>   		if (rc)
>   			return rc;
> +		kvm->stat.gmap_shadow_segment++;
>   	}
>   		fallthrough;
>   	case ASCE_TYPE_SEGMENT: {
> @@ -1548,6 +1553,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   		rc = gmap_shadow_pgt(sg, saddr, ste.val, *fake);
>   		if (rc)
>   			return rc;
> +		kvm->stat.gmap_shadow_page++;
>   	}
>   	}
>   	/* Return the parent address of the page table */
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 17b81659cdb2..b012645a5a7c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -66,7 +66,12 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>   	STATS_DESC_COUNTER(VM, inject_pfault_done),
>   	STATS_DESC_COUNTER(VM, inject_service_signal),
>   	STATS_DESC_COUNTER(VM, inject_virtio),
> -	STATS_DESC_COUNTER(VM, aen_forward)
> +	STATS_DESC_COUNTER(VM, aen_forward),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_acquire),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_r2),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_r3),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_segment),
> +	STATS_DESC_COUNTER(VM, gmap_shadow_page),
>   };
>   
>   const struct kvm_stats_header kvm_vm_stats_header = {
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 8d6b765abf29..beb3be037722 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -1221,6 +1221,7 @@ static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
>   	if (IS_ERR(gmap))
>   		return PTR_ERR(gmap);
>   	gmap->private = vcpu->kvm;
> +	vcpu->kvm->stat.gmap_shadow_acquire++;
>   	WRITE_ONCE(vsie_page->gmap, gmap);
>   	return 0;
>   }

