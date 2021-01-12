Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833C22F345C
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 16:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391897AbhALPkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 10:40:32 -0500
Received: from foss.arm.com ([217.140.110.172]:48580 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391706AbhALPkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 10:40:32 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FACC1FB;
        Tue, 12 Jan 2021 07:39:46 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92BFB3F719;
        Tue, 12 Jan 2021 07:39:44 -0800 (PST)
Subject: Re: [PATCH 6/9] docs: kvm: devices/arm-vgic-v3: enhance
 KVM_DEV_ARM_VGIC_CTRL_INIT doc
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-7-eric.auger@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <4c0b3988-904c-a922-d0be-87a354c3203c@arm.com>
Date:   Tue, 12 Jan 2021 15:39:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201212185010.26579-7-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 12/12/20 6:50 PM, Eric Auger wrote:
> kvm_arch_vcpu_precreate() returns -EBUSY if the vgic is
> already initialized. So let's document that KVM_DEV_ARM_VGIC_CTRL_INIT
> must be called after all vcpu creations.

Checked and this is indeed the case,
kvm_vm_ioctl_create_vcpu()->kvm_arch_vcpu_precreate() returns -EBUSY is
vgic_initialized() is true.

>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  Documentation/virt/kvm/devices/arm-vgic-v3.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
> index 5dd3bff51978..322de6aebdec 100644
> --- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
> @@ -228,7 +228,7 @@ Groups:
>  
>      KVM_DEV_ARM_VGIC_CTRL_INIT
>        request the initialization of the VGIC, no additional parameter in
> -      kvm_device_attr.addr.
> +      kvm_device_attr.addr. Must be called after all vcpu creations.

Nitpick here: the document writes VCPU with all caps. This also sounds a bit
weird, I think something like "Must be called after all VCPUs have been created"
is clearer.

Thanks,
Alex
>      KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
>        save all LPI pending bits into guest RAM pending tables.
>  
