Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A3F45A1B5
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 12:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbhKWLpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 06:45:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26362 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236309AbhKWLpA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 06:45:00 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANBM1Dm014821;
        Tue, 23 Nov 2021 11:41:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0ozfpilddtTk/OMMy1V6wLP7ov1adclROeHEKPsN8XA=;
 b=h4IK2zsSgjBdtGx5zW0ovsddr5mdjFcY0bYq63hOHuqfn0e9XbG6RGFbLFW7vJKe9qEq
 78V5PpaYmCkVixK+k+nhUwihPjI75k+ywVwLkDDJzsZ9EEotE+APw2SU4nJRphBe61FM
 f7s7pnslgDpMI1qYN4ej9YXE/o463oqszXS1NbAlnuhs3W0rYfWMwJuha+0ORe2456mr
 1U8NYLWLwDciHvOEZa99W9gFK9wlojgvUkqCd44B4hDDUDNZ43rtobDVXGklJ7juGjF4
 qkY11GTw5YfSGYDIk1UVDXgtudyDogQD9Tgm0OboKMmIXbMIXfrafP7kq8ixCO3uZTTN sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgyc3rbk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:41:52 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANBZcLT029779;
        Tue, 23 Nov 2021 11:41:52 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgyc3rbje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:41:52 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANBcZhA012710;
        Tue, 23 Nov 2021 11:41:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3cern9e6wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:41:49 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANBYZOi55968012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 11:34:35 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1AA411C066;
        Tue, 23 Nov 2021 11:41:46 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C4A111C052;
        Tue, 23 Nov 2021 11:41:46 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.158])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 11:41:46 +0000 (GMT)
Date:   Tue, 23 Nov 2021 11:51:14 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/8] lib: s390x: sie: Add sca allocation
 and freeing
Message-ID: <20211123115114.65f48dd4@p-imbrenda>
In-Reply-To: <20211123103956.2170-2-frankja@linux.ibm.com>
References: <20211123103956.2170-1-frankja@linux.ibm.com>
        <20211123103956.2170-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Gpch2HH4eohYG79GU4TSry91YmQvw3wb
X-Proofpoint-GUID: 0MYkoYaf9v6DLgGoPuSfE6CfRLcaMKwo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_04,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Nov 2021 10:39:49 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> For protected guests we always need a ESCA so let's add functions to
> create and destroy SCAs on demand. We don't have scheduling and I
> don't expect multiple VCPU SIE in the next few months so SCA content
> handling is not added.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/sie.c | 12 ++++++++++++
>  lib/s390x/sie.h |  2 ++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index b965b314..51d3b94e 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -55,6 +55,16 @@ void sie(struct vm *vm)
>  	vm->save_area.guest.grs[15] = vm->sblk->gg15;
>  }
>  
> +void sie_guest_sca_create(struct vm *vm)
> +{
> +	vm->sca = (struct esca_block *)alloc_page();
> +
> +	/* Let's start out with one page of ESCA for now */
> +	vm->sblk->scaoh = ((uint64_t)vm->sca >> 32);
> +	vm->sblk->scaol = (uint64_t)vm->sca & ~0x3fU;
> +	vm->sblk->ecb2 |= ECB2_ESCA;
> +}
> +
>  /* Initializes the struct vm members like the SIE control block. */
>  void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len)
>  {
> @@ -80,4 +90,6 @@ void sie_guest_destroy(struct vm *vm)
>  {
>  	free_page(vm->crycb);
>  	free_page(vm->sblk);
> +	if (vm->sblk->ecb2 & ECB2_ESCA)
> +		free_page(vm->sca);
>  }
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index 7ef7251b..f34e3c80 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -191,6 +191,7 @@ struct vm_save_area {
>  struct vm {
>  	struct kvm_s390_sie_block *sblk;
>  	struct vm_save_area save_area;
> +	void *sca;				/* System Control Area */
>  	uint8_t *crycb;				/* Crypto Control Block */
>  	/* Ptr to first guest page */
>  	uint8_t *guest_mem;
> @@ -203,6 +204,7 @@ void sie(struct vm *vm);
>  void sie_expect_validity(void);
>  void sie_check_validity(uint16_t vir_exp);
>  void sie_handle_validity(struct vm *vm);
> +void sie_guest_sca_create(struct vm *vm);
>  void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
>  void sie_guest_destroy(struct vm *vm);
>  

