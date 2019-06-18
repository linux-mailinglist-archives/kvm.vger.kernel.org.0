Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBA04ADBF
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 00:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbfFRWRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 18:17:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48428 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbfFRWRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 18:17:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IMGJIW194710;
        Tue, 18 Jun 2019 22:16:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=lYY4RyxYhBasL45yqr6qcF0o7IiIm/ZUtdDad0aawUQ=;
 b=tZVXbshththemMMNodKWrH0KDUfEY/crlIHANFuhqYNAHQTqTcSReBpsNQJ8/OafN6au
 uhSMHT1Yxa0bcS368iMs7cgSO03y02O6QdsiEaWjQXDA2UZDwcSjd4rOIWCwvR6l0c0d
 BGFeNeZJMkxCY7FYz/z4ojFGdHGL0f6hDPSJE0kQgKot1DbGGUFkuIaJ5zk6HlhJMFGP
 l6JSE3XBjHq73ZNCUR1ewuLuF3q9AEoDzgXlpm8NtLLiqphbFP0FoJqBaoEuc52neSHO
 aPOew1fP9xFU89qxqc4yti1YmA8aGJQyeztcL5BbLr0lTolHaZ9OGU+VbK1c4CVfYsTq +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2t780983tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 22:16:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IMF7vn069365;
        Tue, 18 Jun 2019 22:16:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2t77ymred3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 22:16:17 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5IMGGJW031854;
        Tue, 18 Jun 2019 22:16:16 GMT
Received: from [10.141.197.71] (/10.141.197.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 15:16:16 -0700
Subject: Re: [Qemu-devel] [QEMU PATCH v3 5/9] linux-headers: i386: Modify
 struct kvm_nested_state to have explicit fields for data
To:     Liran Alon <liran.alon@oracle.com>, qemu-devel@nongnu.org
Cc:     ehabkost@redhat.com, kvm@vger.kernel.org, mtosatti@redhat.com,
        dgilbert@redhat.com, pbonzini@redhat.com, rth@twiddle.net,
        jmattson@google.com
References: <20190617175658.135869-1-liran.alon@oracle.com>
 <20190617175658.135869-6-liran.alon@oracle.com>
From:   Maran Wilson <maran.wilson@oracle.com>
Organization: Oracle Corporation
Message-ID: <fad1387b-54fd-cbfc-89c8-433d9e8da141@oracle.com>
Date:   Tue, 18 Jun 2019 15:16:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617175658.135869-6-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180178
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/17/2019 10:56 AM, Liran Alon wrote:
> Improve the KVM_{GET,SET}_NESTED_STATE structs by detailing the format
> of VMX nested state data in a struct.
>
> In order to avoid changing the ioctl values of
> KVM_{GET,SET}_NESTED_STATE, there is a need to preserve
> sizeof(struct kvm_nested_state). This is done by defining the data
> struct as "data.vmx[0]". It was the most elegant way I found to
> preserve struct size while still keeping struct readable and easy to
> maintain. It does have a misfortunate side-effect that now it has to be
> accessed as "data.vmx[0]" rather than just "data.vmx".
>
> Because we are already modifying these structs, I also modified the
> following:
> * Define the "format" field values as macros.
> * Rename vmcs_pa to vmcs12_pa for better readability.
> * Add stub structs for AMD SVM.
>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>   linux-headers/asm-x86/kvm.h | 41 +++++++++++++++++++++++++++----------
>   1 file changed, 30 insertions(+), 11 deletions(-)
>
> diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
> index 7a0e64ccd6ff..e655d108af19 100644
> --- a/linux-headers/asm-x86/kvm.h
> +++ b/linux-headers/asm-x86/kvm.h
> @@ -383,6 +383,9 @@ struct kvm_sync_regs {
>   #define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	(1 << 2)
>   #define KVM_X86_QUIRK_OUT_7E_INC_RIP	(1 << 3)
>   
> +#define KVM_STATE_NESTED_FORMAT_VMX	0
> +#define KVM_STATE_NESTED_FORMAT_SVM	1
> +
>   #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
>   #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
>   #define KVM_STATE_NESTED_EVMCS		0x00000004
> @@ -390,35 +393,51 @@ struct kvm_sync_regs {
>   #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
>   #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
>   
> -struct kvm_vmx_nested_state {
> +struct kvm_vmx_nested_state_data {
> +	__u8 vmcs12[0x1000];
> +	__u8 shadow_vmcs12[0x1000];

I assume you will replace this magic 0x1000 value too, as discussed with 
respect to patch 7?

Thanks,
-Maran

> +};
> +
> +struct kvm_vmx_nested_state_hdr {
>   	__u64 vmxon_pa;
> -	__u64 vmcs_pa;
> +	__u64 vmcs12_pa;
>   
>   	struct {
>   		__u16 flags;
>   	} smm;
>   };
>   
> +struct kvm_svm_nested_state_data {
> +	/* TODO: Implement */
> +};
> +
> +struct kvm_svm_nested_state_hdr {
> +	/* TODO: Implement */
> +};
> +
>   /* for KVM_CAP_NESTED_STATE */
>   struct kvm_nested_state {
> -	/* KVM_STATE_* flags */
>   	__u16 flags;
> -
> -	/* 0 for VMX, 1 for SVM.  */
>   	__u16 format;
> -
> -	/* 128 for SVM, 128 + VMCS size for VMX.  */
>   	__u32 size;
>   
>   	union {
> -		/* VMXON, VMCS */
> -		struct kvm_vmx_nested_state vmx;
> +		struct kvm_vmx_nested_state_hdr vmx;
> +		struct kvm_svm_nested_state_hdr svm;
>   
>   		/* Pad the header to 128 bytes.  */
>   		__u8 pad[120];
> -	};
> +	} hdr;
>   
> -	__u8 data[0];
> +	/*
> +	 * Define data region as 0 bytes to preserve backwards-compatability
> +	 * to old definition of kvm_nested_state in order to avoid changing
> +	 * KVM_{GET,PUT}_NESTED_STATE ioctl values.
> +	 */
> +	union {
> +		struct kvm_vmx_nested_state_data vmx[0];
> +		struct kvm_svm_nested_state_data svm[0];
> +	} data;
>   };
>   
>   #endif /* _ASM_X86_KVM_H */

