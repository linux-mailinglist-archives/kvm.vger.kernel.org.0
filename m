Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60902392BE8
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 12:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbhE0KhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 06:37:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235950AbhE0KhS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 06:37:18 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RAXtRR153268;
        Thu, 27 May 2021 06:35:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UcmNkgsGMF9YBSHsLQD9v8WnRBSvndasoAjAPC/Fn8g=;
 b=qe8n354LcF1FSQWMI5ORnYkLg9/r1V9V5PloT0IVfrxHXtri26GTOdYKk1zSM0g4WTl5
 7PAn1GnIfkefzeITM/4dYi3ZcbJvMiYvM9QlJbm2FTXdPgtP8dnEL6pr877ch/vva6wz
 nAI5RbBEWCx+f+Y7j3of8otC27mmesCdE9RuzJy0EZjdidWMu1mf5m3fLL/8AAQJp4nu
 ZGSZq5YDWiyaRJ3oSJXKj01npdfnN66ZsruOfibEKFmPE/xEJ+38TPps4PywogHMw2E2
 htG3JvoQUGz39ilOm/4/InpaBCJbRDRTBv+FjiSU7mcfmAgew+iVwNiNkPG7rJV1Lp0X EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38t8fkag0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 06:35:44 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14RAZiL7161835;
        Thu, 27 May 2021 06:35:44 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38t8fkag04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 06:35:43 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14RAS8I8028781;
        Thu, 27 May 2021 10:35:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 38s1ukh4ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 10:35:41 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14RAZcHd26542396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 10:35:39 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA41711C050;
        Thu, 27 May 2021 10:35:38 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AB6B11C04A;
        Thu, 27 May 2021 10:35:38 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.86.253])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 May 2021 10:35:38 +0000 (GMT)
Subject: Re: [PATCH v1 10/11] KVM: s390: pv: module parameter to fence lazy
 destroy
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
 <20210517200758.22593-11-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <7b43f05f-30e0-1c84-74f1-c28fdd6fcff4@linux.ibm.com>
Date:   Thu, 27 May 2021 12:35:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517200758.22593-11-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ob1OI9kh7xDqOy2NSMECDARFhcLe_MRh
X-Proofpoint-GUID: yf_WtlHvJM8fsY1cS8pRIfYvDlkUBH2T
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_04:2021-05-26,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105270069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/17/21 10:07 PM, Claudio Imbrenda wrote:
> Add the module parameter "lazy_destroy", to allow the lazy destroy
> mechanism to be switched off. This might be useful for debugging
> purposes.
> 
> The parameter is enabled by default.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/pv.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 4333d3e54ef0..00c14406205f 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -26,6 +26,10 @@ struct deferred_priv {
>  	unsigned long real;
>  };
>  
> +static int lazy_destroy = 1;
> +module_param(lazy_destroy, int, 0444);

I'm pondering if we want to make that writable or not.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> +MODULE_PARM_DESC(lazy_destroy, "Deferred destroy for protected guests");
> +
>  int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
>  {
>  	int cc = 0;
> @@ -348,6 +352,9 @@ int kvm_s390_pv_deinit_vm_deferred(struct kvm *kvm, u16 *rc, u16 *rrc)
>  {
>  	struct deferred_priv *priv;
>  
> +	if (!lazy_destroy)
> +		kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
> +
>  	priv = kmalloc(sizeof(*priv), GFP_KERNEL | __GFP_ZERO);
>  	if (!priv)
>  		return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
> @@ -396,6 +403,12 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>  	/* Outputs */
>  	kvm->arch.pv.handle = uvcb.guest_handle;
>  
> +	if (!lazy_destroy) {
> +		mmap_write_lock(kvm->mm);
> +		kvm->mm->context.pv_sync_destroy = 1;
> +		mmap_write_unlock(kvm->mm);
> +	}
> +
>  	atomic_inc(&kvm->mm->context.is_protected);
>  	if (cc) {
>  		if (uvcb.header.rc & UVC_RC_NEED_DESTROY) {
> 

