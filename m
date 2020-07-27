Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5EE22F71E
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 19:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbgG0R4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 13:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729686AbgG0R4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 13:56:01 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B73CA2070B;
        Mon, 27 Jul 2020 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595872560;
        bh=v11Epheq5tSy5AvwBVwRwdX6oVjInFx2eoLMFquy0RA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z5m7WFP3q6x8fuIeCZan7fGpFiqVVVda9qmiiAI480Y3aJrd5O2sETTQ8j4lZP2Mv
         RLvYMAkbp1wGuYjzlOl1AqEtB46wXHjYIus9aFIbkoKue3mdFmQSz5XmoIIrjt60vF
         lYkwjPj3976MbdOAdFWD/88b9UB6vyj4vIfuvIh8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k07Lz-00FO0M-Bc; Mon, 27 Jul 2020 18:55:59 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 27 Jul 2020 18:55:59 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, steven.price@arm.com
Subject: Re: [PATCH 4/5] KVM: Documentation minor fixups
In-Reply-To: <20200711100434.46660-5-drjones@redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <20200711100434.46660-5-drjones@redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <7f940c35be5e4c11dc3e7a6188539091@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-07-11 11:04, Andrew Jones wrote:
> Reviewed-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>

It'd be good to have an actual commit message.

> ---
>  Documentation/virt/kvm/api.rst | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst 
> b/Documentation/virt/kvm/api.rst
> index 320788f81a05..3bd96c1a3962 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6122,7 +6122,7 @@ HvCallSendSyntheticClusterIpi,
> HvCallSendSyntheticClusterIpiEx.
>  8.21 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
>  -----------------------------------
> 
> -:Architecture: x86
> +:Architectures: x86
> 
>  This capability indicates that KVM running on top of Hyper-V 
> hypervisor
>  enables Direct TLB flush for its guests meaning that TLB flush
> @@ -6135,16 +6135,17 @@ in CPUID and only exposes Hyper-V
> identification. In this case, guest
>  thinks it's running on Hyper-V and only use Hyper-V hypercalls.
> 
>  8.22 KVM_CAP_S390_VCPU_RESETS
> +-----------------------------
> 
> -Architectures: s390
> +:Architectures: s390
> 
>  This capability indicates that the KVM_S390_NORMAL_RESET and
>  KVM_S390_CLEAR_RESET ioctls are available.
> 
>  8.23 KVM_CAP_S390_PROTECTED
> +---------------------------
> 
> -Architecture: s390
> -
> +:Architectures: s390
> 
>  This capability indicates that the Ultravisor has been initialized and
>  KVM can therefore start protected VMs.

But this seems to be an otherwise unrelated patch.
I'm happy to take it, but it seems odd here.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
