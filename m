Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CF368CAF8
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 01:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjBGAKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 19:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjBGAKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 19:10:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D47729F
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 16:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675728592;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZgIvx9a/Uji2IqDErHvY4UDPIdQLSSPtFLzNxB0bpXM=;
        b=Aq2N3tWDbXicXJctJWftVWt39qWho0N7Xarp7zltX1enQFblcd9XSMnNuUImFcI9Ft2pt6
        2R6DXfBjc0A+7D7RneLG9I7XHxqVSVCML/3/ye9ObGHiCPJqdQFzLjLKpDYWTmOKc+FUR/
        RYoiTcTxrWmQvXsVITC3w+HO4QopAzc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-jcP-7hMSNQCwZpi9Zc845g-1; Mon, 06 Feb 2023 19:09:49 -0500
X-MC-Unique: jcP-7hMSNQCwZpi9Zc845g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A1CE1869B0D;
        Tue,  7 Feb 2023 00:09:48 +0000 (UTC)
Received: from [10.64.54.63] (vpn2-54-63.bne.redhat.com [10.64.54.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 561062166B29;
        Tue,  7 Feb 2023 00:09:42 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 6/7] KVM: arm64: Change return type of
 kvm_vm_ioctl_mte_copy_tags() to "int"
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linuxppc-dev@lists.ozlabs.org
References: <20230203094230.266952-1-thuth@redhat.com>
 <20230203094230.266952-7-thuth@redhat.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <c6e605fe-f251-d8b6-64ed-bd1e17e79512@redhat.com>
Date:   Tue, 7 Feb 2023 11:09:39 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20230203094230.266952-7-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 2/3/23 8:42 PM, Thomas Huth wrote:
> This function only returns normal integer values, so there is
> no need to declare its return value as "long".
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 4 ++--
>   arch/arm64/kvm/guest.c            | 4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 35a159d131b5..b1a16343767f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -963,8 +963,8 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>   int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>   			       struct kvm_device_attr *attr);
>   
> -long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> -				struct kvm_arm_copy_mte_tags *copy_tags);
> +int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> +			       struct kvm_arm_copy_mte_tags *copy_tags);
>   
>   /* Guest/host FPSIMD coordination helpers */
>   int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index cf4c495a4321..80e530549c34 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -1013,8 +1013,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>   	return ret;
>   }
>   
> -long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> -				struct kvm_arm_copy_mte_tags *copy_tags)
> +int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> +			       struct kvm_arm_copy_mte_tags *copy_tags)
>   {
>   	gpa_t guest_ipa = copy_tags->guest_ipa;
>   	size_t length = copy_tags->length;
> 

It's possible for the function to return number of bytes have been copied.
Its type is 'size_t', same to 'unsigned long'. So 'int' doesn't have sufficient
space for it if I'm correct.

long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
                                 struct kvm_arm_copy_mte_tags *copy_tags)
{
         gpa_t guest_ipa = copy_tags->guest_ipa;
         size_t length = copy_tags->length;
         :
         :
out:
         mutex_unlock(&kvm->slots_lock);
         /* If some data has been copied report the number of bytes copied */
         if (length != copy_tags->length)
                 return copy_tags->length - length;
         return ret;
}

Thanks,
Gavin

