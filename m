Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A128D4B5E83
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 01:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbiBOAAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 19:00:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiBOAAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 19:00:30 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F04403DC;
        Mon, 14 Feb 2022 16:00:21 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EMHl28008866;
        Tue, 15 Feb 2022 00:00:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=qgqqJFIxMDkX/B5M+Osdluep2Trr0dSueKlPtlQSPPk=;
 b=MZeQc87u6HGdQTZek3u2+fakfrYkwxP/mj3QWlHs6VBlSSvHETvkV5xMpdDC0puNjM+8
 BdoZdK43IeTPU/986Sv6iUGNqRCQbpz6QyrPDGjjiiJdw0JZeOOcnZIAkzP7Itb55B1S
 JzKM3M0AedEJMracYIHt2mPFKI/1QC1B2t555BLnM0wIMTVbrdWmGnXTTX9/3xsGLPpo
 KtQdQjr3EkOLU6mGzbS5J1sS3UfvlElYNJIMm5GkFofp0efjGwGDRIkYxXA9ZuhxMMiB
 fPbNasGL/ih/a+P4VPA7oKz+gRjTUOolY/GshOF2J8vvaDk3OLtPxCJ28+7yvO+06uKs QQ== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e6thy02y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:00:20 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21ENxAHC026638;
        Tue, 15 Feb 2022 00:00:18 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3e645jgu8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:00:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21F00GS228508496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 00:00:16 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBE4CA404D;
        Tue, 15 Feb 2022 00:00:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42DDCA405E;
        Tue, 15 Feb 2022 00:00:15 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.54])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 00:00:15 +0000 (GMT)
Date:   Mon, 14 Feb 2022 18:47:56 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v4 08/10] KVM: s390: Add capability for storage key
 extension of MEM_OP IOCTL
Message-ID: <20220214184756.047483b1@p-imbrenda>
In-Reply-To: <20220211182215.2730017-9-scgl@linux.ibm.com>
References: <20220211182215.2730017-1-scgl@linux.ibm.com>
        <20220211182215.2730017-9-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GbrrRbpnCSgN9aKbwmOKqQ1VPKUykTA-
X-Proofpoint-ORIG-GUID: GbrrRbpnCSgN9aKbwmOKqQ1VPKUykTA-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140134
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Feb 2022 19:22:13 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Availability of the KVM_CAP_S390_MEM_OP_EXTENSION capability signals that:
> * The vcpu MEM_OP IOCTL supports storage key checking.
> * The vm MEM_OP IOCTL exists.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 1 +
>  include/uapi/linux/kvm.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 773bccdd446c..c2c26c2aad64 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -564,6 +564,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_S390_VCPU_RESETS:
>  	case KVM_CAP_SET_GUEST_DEBUG:
>  	case KVM_CAP_S390_DIAG318:
> +	case KVM_CAP_S390_MEM_OP_EXTENSION:
>  		r = 1;
>  		break;
>  	case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4bc7623def87..08756eeea065 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1140,6 +1140,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_VM_GPA_BITS 207
>  #define KVM_CAP_XSAVE2 208
>  #define KVM_CAP_SYS_ATTRIBUTES 209
> +#define KVM_CAP_S390_MEM_OP_EXTENSION 210
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  

