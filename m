Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FD146E3FC
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 09:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbhLIIV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 03:21:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24220 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229536AbhLIIV0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 03:21:26 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B96wfjI015155;
        Thu, 9 Dec 2021 08:17:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=iyRuyMnrsSYQQ3mu0VpKzkSvgVH8i9BqZ94wHtEHpTM=;
 b=h8zWskPfGLOKCW95i39bydo+Hu4p4qtYpm8Ok1GsLU09TDwd4qFfitBPLLpU7/cYql26
 /OQ55yva6Q2Q7BVQETW4METE1l9SI1lXQkrf25kwDtTkcTav4dDYqLSadRD37RyJd7EM
 OZUtpWKFUISJFU/2vzMYb0p3qLu4Ae1nZ5L4a7SM8Zf/Am3p5pGjtSAMNn2//DAf3TV+
 LiXalOCrEQ0k2CFTVBGWgJoOVsfbCQpR2Tx/ZPjsKwVAsaeuZQcsmyX2VnzAhJJ118E5
 k/0wlpVWvr2Xm6NTSvDONnNtLwEI7OimwtcdoByyzH6y/ploRZSJVl4sd60fLaKTyEGa 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cud0esfr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 08:17:20 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B97sL4h024036;
        Thu, 9 Dec 2021 08:17:20 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cud0esfqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 08:17:20 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B98Cvs8013571;
        Thu, 9 Dec 2021 08:17:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3cqykjpqq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 08:17:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B98HFYr32309678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 08:17:15 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE9A111C05E;
        Thu,  9 Dec 2021 08:17:14 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 247DE11C073;
        Thu,  9 Dec 2021 08:17:14 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.115])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 08:17:14 +0000 (GMT)
Date:   Thu, 9 Dec 2021 09:17:12 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH 6/7] KVM: Drop KVM_REQ_MMU_RELOAD and update
 vcpu-requests.rst documentation
Message-ID: <20211209091712.78ddd2c9@p-imbrenda>
In-Reply-To: <20211209060552.2956723-7-seanjc@google.com>
References: <20211209060552.2956723-1-seanjc@google.com>
        <20211209060552.2956723-7-seanjc@google.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WmrQ3ZcQ74B7keqUzC6JZv2BqAASUL87
X-Proofpoint-ORIG-GUID: RlmryqTfuyC4xn3SUyihBgNcGmwVS3Yp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_03,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090043
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Dec 2021 06:05:51 +0000
Sean Christopherson <seanjc@google.com> wrote:

> Remove the now unused KVM_REQ_MMU_RELOAD, shift KVM_REQ_VM_DEAD into the
> unoccupied space, and update vcpu-requests.rst, which was missing an
> entry for KVM_REQ_VM_DEAD.  Switching KVM_REQ_VM_DEAD to entry '1' also
> fixes the stale comment about bits 4-7 being reserved.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  Documentation/virt/kvm/vcpu-requests.rst | 7 +++----
>  include/linux/kvm_host.h                 | 3 +--
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/vcpu-requests.rst b/Documentation/virt/kvm/vcpu-requests.rst
> index ad2915ef7020..98b8f02b7a19 100644
> --- a/Documentation/virt/kvm/vcpu-requests.rst
> +++ b/Documentation/virt/kvm/vcpu-requests.rst
> @@ -112,11 +112,10 @@ KVM_REQ_TLB_FLUSH
>    choose to use the common kvm_flush_remote_tlbs() implementation will
>    need to handle this VCPU request.
>  
> -KVM_REQ_MMU_RELOAD
> +KVM_REQ_VM_DEAD
>  
> -  When shadow page tables are used and memory slots are removed it's
> -  necessary to inform each VCPU to completely refresh the tables.  This
> -  request is used for that.
> +  This request informs all VCPUs that the VM is dead and unusable, e.g. due to
> +  fatal error or because the VMs state has been intentionally destroyed.
>  
>  KVM_REQ_UNBLOCK
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 636e62c09964..7e444c4e406d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -151,10 +151,9 @@ static inline bool is_error_page(struct page *page)
>   * Bits 4-7 are reserved for more arch-independent bits.
>   */
>  #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> -#define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> +#define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_UNBLOCK           2
>  #define KVM_REQ_UNHALT            3
> -#define KVM_REQ_VM_DEAD           (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQUEST_ARCH_BASE     8
>  
>  #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \

