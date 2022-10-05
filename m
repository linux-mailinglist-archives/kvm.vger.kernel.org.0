Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3AF5F58C7
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 19:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiJERCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 13:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiJERCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 13:02:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEC1399F8
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 10:02:07 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295G8FpL023917
        for <kvm@vger.kernel.org>; Wed, 5 Oct 2022 17:02:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=iYRQjSZ/n/U08AccJDoWVhGedNP1gvNuAteMhhfKsJo=;
 b=RNIDPVN3d+IIfxHu3BfRJU4hoaJpTXsBU5dNPenl94d/iXwGDQdFds0hbXbF5cwklX0k
 fXTBgsA3whasupdY2FtArjIXVh9900Pq+4w64SZzS0bChRVhEHHyptzWQbHg5uar5G5H
 xaIqxmM68DDVaNk8heTgGB5osIDEyrAMOwEBedzyL0P6PNuTcZf7eabMoI62C0SNmNpC
 RtJSnnLHxn1r8W9FBkoHj3+xnNAmFjPjQJWSaGq41DOoJ//k+33gQo/gtm7y5p9RcLb6
 rJ3I9WgsENh0ZR/kzZsl1ogGK0pVASLs8nJHVtj62MYTg/FMM81wH6YYEsaDwxOPJeKe 5A== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1cxvhunf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:02:06 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 295Gojvc012113
        for <kvm@vger.kernel.org>; Wed, 5 Oct 2022 17:02:05 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3jxd695tqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:02:05 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 295H21Jl66060688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Oct 2022 17:02:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3B68AE051;
        Wed,  5 Oct 2022 17:02:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81524AE045;
        Wed,  5 Oct 2022 17:02:01 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Oct 2022 17:02:01 +0000 (GMT)
Date:   Wed, 5 Oct 2022 19:01:27 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH v3 2/2] KVM: s390: remove now unused function
 kvm_s390_set_tod_clock
Message-ID: <20221005190127.49f7ab6e@p-imbrenda>
In-Reply-To: <20221005163258.117232-3-nrb@linux.ibm.com>
References: <20221005163258.117232-1-nrb@linux.ibm.com>
        <20221005163258.117232-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pvWiGN8dgd4lK4BADVfS6aZW9X0Vi1lj
X-Proofpoint-ORIG-GUID: pvWiGN8dgd4lK4BADVfS6aZW9X0Vi1lj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_03,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1015
 bulkscore=0 adultscore=0 priorityscore=1501 mlxlogscore=959
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210050102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  5 Oct 2022 18:32:58 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> The function kvm_s390_set_tod_clock is now unused, hence let's remove
> it.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 7 -------
>  arch/s390/kvm/kvm-s390.h | 1 -
>  2 files changed, 8 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 0a8019b14c8f..9ec8870832e7 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4390,13 +4390,6 @@ static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_t
>  	preempt_enable();
>  }
>  
> -void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
> -{
> -	mutex_lock(&kvm->lock);
> -	__kvm_s390_set_tod_clock(kvm, gtod);
> -	mutex_unlock(&kvm->lock);
> -}
> -
>  int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
>  {
>  	if (!mutex_trylock(&kvm->lock))
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index f6fd668f887e..4755492dfabc 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -363,7 +363,6 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
>  int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
>  
>  /* implemented in kvm-s390.c */
> -void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
>  int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
>  long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
>  int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);

