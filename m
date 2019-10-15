Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0B8D8339
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 00:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387771AbfJOWF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 18:05:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60716 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbfJOWF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 18:05:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FLxjVb100533;
        Tue, 15 Oct 2019 22:05:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=KPP03hfrrXQ4Nsszrtqc/SzL79QsW11j9w/mUGBt86s=;
 b=nlZUuFWkWk5gzDyq5PkBnONz9nPKO9+D+TgGNcvG57cq/bbMqFjC00IA90N3beSmu3VD
 vqfy159fIujtSNqe9JflwD9f7QgHZ9Iakqr+L9J72aKad82ofCsUmJg/cWF+JTeQoOE9
 MqNii6ia6cMozivw/VwmPV1VVCDedr64SwakwSmhf4MfFQGT5jOMJlML5yS5lSvli5Wz
 m7tzH2JYxgxo0lrQQrfieiejG6yYej92IG7zgtp1FHG8G39P7r1O1CExX9J0N+lFYP9z
 IecDZthsOOeNxEdWqe3cGfupUym4o565i3OGSQuLxdQklU3tO7VV5gLOGKYtKoDlKcAE 1w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vk7frawmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 22:05:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FM43P6119202;
        Tue, 15 Oct 2019 22:05:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vn71987su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 22:05:06 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9FM539h014007;
        Tue, 15 Oct 2019 22:05:03 GMT
Received: from dhcp-10-132-91-76.usdhcp.oraclecorp.com (/10.132.91.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 22:05:03 +0000
Subject: Re: [PATCH 1/4] KVM: VMX: rename {vmx,nested_vmx}_vcpu_setup
 functions
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191015164033.87276-1-xiaoyao.li@intel.com>
 <20191015164033.87276-2-xiaoyao.li@intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <82a41967-98ca-1bc8-fce3-77aaf18b0c1a@oracle.com>
Date:   Tue, 15 Oct 2019 15:05:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20191015164033.87276-2-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=11 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150189
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=11 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150189
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/15/2019 09:40 AM, Xiaoyao Li wrote:
> Rename {vmx,nested_vmx}_vcpu_setup to {vmx,nested_vmx}_vmcs_setup,
> to match what they really do.
>
> No functional change.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 2 +-
>   arch/x86/kvm/vmx/nested.h | 2 +-
>   arch/x86/kvm/vmx/vmx.c    | 9 +++------
>   3 files changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 5e231da00310..7935422d311f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5768,7 +5768,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>   	return ret;
>   }
>   
> -void nested_vmx_vcpu_setup(void)
> +void nested_vmx_vmcs_setup(void)
>   {
>   	if (enable_shadow_vmcs) {
>   		vmcs_write64(VMREAD_BITMAP, __pa(vmx_vmread_bitmap));
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index 187d39bf0bf1..2be1ba7482c9 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -11,7 +11,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
>   				bool apicv);
>   void nested_vmx_hardware_unsetup(void);
>   __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
> -void nested_vmx_vcpu_setup(void);
> +void nested_vmx_vmcs_setup(void);
>   void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
>   int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry);
>   bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e660e28e9ae0..58b77a882426 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4161,15 +4161,12 @@ static void ept_set_mmio_spte_mask(void)
>   
>   #define VMX_XSS_EXIT_BITMAP 0
>   
> -/*
> - * Sets up the vmcs for emulated real mode.
> - */
> -static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
> +static void vmx_vmcs_setup(struct vcpu_vmx *vmx)
>   {
>   	int i;
>   
>   	if (nested)
> -		nested_vmx_vcpu_setup();
> +		nested_vmx_vmcs_setup();
>   
>   	if (cpu_has_vmx_msr_bitmap())
>   		vmcs_write64(MSR_BITMAP, __pa(vmx->vmcs01.msr_bitmap));
> @@ -6777,7 +6774,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>   	cpu = get_cpu();
>   	vmx_vcpu_load(&vmx->vcpu, cpu);
>   	vmx->vcpu.cpu = cpu;
> -	vmx_vcpu_setup(vmx);
> +	vmx_vmcs_setup(vmx);
>   	vmx_vcpu_put(&vmx->vcpu);
>   	put_cpu();
>   	if (cpu_need_virtualize_apic_accesses(&vmx->vcpu)) {

May be we should rename vmx_vcpu_reset() to vmx_vmcs_reset()  as well  ?
