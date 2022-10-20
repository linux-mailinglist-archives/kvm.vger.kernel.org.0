Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1A5605F3B
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 13:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiJTLrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 07:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiJTLrO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 07:47:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8659161FF0
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 04:47:13 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KBd2qL025432
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:47:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=20/Wmo5ewcS+X99p5fYxc5LC9NWSmFMhwTP49eqd8Po=;
 b=ODNBX5Ul1V5UGqSVQeC+ES+DEJYWq2NSTovNcsLkP/anR/EfcR9Q7cyrG3cNX3VRPlFS
 YjBQjhvyf73s8ZQR5LjoAiy0Rv7u/L6HG2VPW+1olkSkxcKP+1LJW6f/jBZj0txOWIHI
 iVWymH4dtiJqZN+8dUou2mHpw3r/gqWTCTtXyaQzTP95oeMK12TV1BbB7cxtn7zp0RtU
 V8d4aWlHeee4627XXCRZL60JycBdYN3L5jmjaZLe7ndmOOjbYLVwuTJxpY6a/zq0kfpn
 Zza/XUscE7QSBLFw1pwxNfcdcf+3JrRpq1d4tsGdVqK5chcon3b5F5fyNqVXAG9zkePj rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb4eahw67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:47:13 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29KBhEFe006512
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:47:13 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb4eahw5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 11:47:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KBZg74005703;
        Thu, 20 Oct 2022 11:47:10 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg98v0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 11:47:10 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KBl6Pt655910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 11:47:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3F335207E;
        Thu, 20 Oct 2022 11:47:06 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 59F295208F;
        Thu, 20 Oct 2022 11:46:47 +0000 (GMT)
Date:   Thu, 20 Oct 2022 13:46:45 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 5/7] lib: s390x: Use a new asce for
 each PV guest
Message-ID: <20221020134645.2915964b@p-imbrenda>
In-Reply-To: <23a68320-a5f1-8fc6-38cd-112ccaded844@linux.ibm.com>
References: <20221020090009.2189-1-frankja@linux.ibm.com>
        <20221020090009.2189-6-frankja@linux.ibm.com>
        <20221020112551.1034d160@p-imbrenda>
        <23a68320-a5f1-8fc6-38cd-112ccaded844@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jVYgyAuq-1Zx5JBDCR9CPjJEFHW6liwO
X-Proofpoint-ORIG-GUID: 4zwXU_htfuCveBwfr-5STZhCYJokbfB6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_03,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Oct 2022 13:27:22 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 10/20/22 11:25, Claudio Imbrenda wrote:
> > On Thu, 20 Oct 2022 09:00:07 +0000
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >   
> >> Every PV guest needs its own ASCE so let's copy the topmost table
> >> designated by CR1 to create a new ASCE for the PV guest. Before and
> >> after SIE we now need to switch ASCEs to and from the PV guest / test
> >> ASCE. The SIE assembly function does that automatically.
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> ---
> >>   lib/s390x/asm-offsets.c |  2 ++
> >>   lib/s390x/sie.c         |  2 ++
> >>   lib/s390x/sie.h         |  2 ++
> >>   lib/s390x/uv.c          | 24 +++++++++++++++++++++++-
> >>   lib/s390x/uv.h          |  5 ++---
> >>   s390x/cpu.S             |  6 ++++++
> >>   6 files changed, 37 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
> >> index fbea3278..f612f327 100644
> >> --- a/lib/s390x/asm-offsets.c
> >> +++ b/lib/s390x/asm-offsets.c
> >> @@ -75,9 +75,11 @@ int main(void)
> >>   	OFFSET(SIE_SAVEAREA_HOST_GRS, vm_save_area, host.grs[0]);
> >>   	OFFSET(SIE_SAVEAREA_HOST_FPRS, vm_save_area, host.fprs[0]);
> >>   	OFFSET(SIE_SAVEAREA_HOST_FPC, vm_save_area, host.fpc);
> >> +	OFFSET(SIE_SAVEAREA_HOST_ASCE, vm_save_area, host.asce);
> >>   	OFFSET(SIE_SAVEAREA_GUEST_GRS, vm_save_area, guest.grs[0]);
> >>   	OFFSET(SIE_SAVEAREA_GUEST_FPRS, vm_save_area, guest.fprs[0]);
> >>   	OFFSET(SIE_SAVEAREA_GUEST_FPC, vm_save_area, guest.fpc);
> >> +	OFFSET(SIE_SAVEAREA_GUEST_ASCE, vm_save_area, guest.asce);
> >>   	OFFSET(STACK_FRAME_INT_BACKCHAIN, stack_frame_int, back_chain);
> >>   	OFFSET(STACK_FRAME_INT_FPC, stack_frame_int, fpc);
> >>   	OFFSET(STACK_FRAME_INT_FPRS, stack_frame_int, fprs);
> >> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> >> index 3fee3def..6efad965 100644
> >> --- a/lib/s390x/sie.c
> >> +++ b/lib/s390x/sie.c
> >> @@ -85,6 +85,8 @@ void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len)
> >>   
> >>   	/* Guest memory chunks are always 1MB */
> >>   	assert(!(guest_mem_len & ~HPAGE_MASK));
> >> +	/* For non-PV guests we re-use the host's ASCE for ease of use */
> >> +	vm->save_area.guest.asce = stctg(1);
> >>   	/* Currently MSO/MSL is the easiest option */
> >>   	vm->sblk->mso = (uint64_t)guest_mem;
> >>   	vm->sblk->msl = (uint64_t)guest_mem + ((guest_mem_len - 1) & HPAGE_MASK);
> >> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> >> index 320c4218..3e3605c9 100644
> >> --- a/lib/s390x/sie.h
> >> +++ b/lib/s390x/sie.h
> >> @@ -205,12 +205,14 @@ union {
> >>   struct vm_uv {
> >>   	uint64_t vm_handle;
> >>   	uint64_t vcpu_handle;
> >> +	uint64_t asce;
> >>   	void *conf_base_stor;
> >>   	void *conf_var_stor;
> >>   	void *cpu_stor;
> >>   };
> >>   
> >>   struct vm_save_regs {
> >> +	uint64_t asce;
> >>   	uint64_t grs[16];
> >>   	uint64_t fprs[16];
> >>   	uint32_t fpc;
> >> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
> >> index 3b4cafa9..0b6eb843 100644
> >> --- a/lib/s390x/uv.c
> >> +++ b/lib/s390x/uv.c
> >> @@ -90,6 +90,25 @@ void uv_init(void)
> >>   	initialized = true;
> >>   }
> >>   
> >> +/*
> >> + * Create a new ASCE for the UV config because they can't be shared
> >> + * for security reasons. We just simply copy the top most table into a
> >> + * fresh set of allocated pages and use those pages as the asce.
> >> + */
> >> +static uint64_t create_asce(void)
> >> +{
> >> +	void *pgd_new, *pgd_old;
> >> +	uint64_t asce = stctg(1);
> >> +
> >> +	pgd_new = memalign_pages_flags(PAGE_SIZE, PAGE_SIZE * 4, 0);  
> > 
> > here you can use memalign_pages, since you are not using the flags  
> 
> Sure
> 
> >   
> >> +	pgd_old = (void *)(asce & PAGE_MASK);
> >> +
> >> +	memcpy(pgd_new, pgd_old, PAGE_SIZE * 4);
> >> +
> >> +	asce = __pa(pgd_new) | ASCE_DT_REGION1 | REGION_TABLE_LENGTH | ASCE_P;  
> > 
> > why not taking the flags from the old ASCE? what if we choose to use a
> > different type of table?
> > 
> > something like this:
> > 
> > asce = _pa(pgd_new) | ASCE_P | (asce & ~PAGE_MASK);  
> 
> I should at least preserve DT and TL but I'd opt to not copy over the 
> other bits. If someone wants to do funky ASCE stuff they now have the 
> possibility to simply change vm->save_area.guest.asce

that's ok
