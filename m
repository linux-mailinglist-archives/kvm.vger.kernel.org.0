Return-Path: <kvm+bounces-28045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF14F9923A1
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 06:31:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A8231F228D0
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 04:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EB991304BA;
	Mon,  7 Oct 2024 04:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ns5p+FPN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2804B10A1C;
	Mon,  7 Oct 2024 04:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728275505; cv=none; b=RloQfD07wUeO35AIc9O9qqnTh2jhJhmC4MZM2tJbNGYAnQFvowWtYebfg+2RUPfwzUButwkfhY5OUNtCxI+/SP3IaFKTbH6IRsP/cRV3iQdZEiIbPHNhzupaTyvCFKBzG8VhrrShT6hlnihM2IsQ22xIEJIl+AEnui0mt+Nb6N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728275505; c=relaxed/simple;
	bh=h4BqdarIxiHAkZjTqrf5W1xk6PBnK/XznaYWb774zhU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=c7W4hRViQ6rxnwHolMhRIKgnE3dEx8/ri6x3UVtjI9KtPMOm9SijPM0YSToaaRWKdsYEO3YL8R2UsIjvKKQIgNxDnsTPn2r0ObkurxzAQOardn49tyPxIn8sPc//zj8udPTx+GmUfGkqwgpbqLEWBxIT2cLXW3tur3oIk9+c3Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ns5p+FPN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E00C4CEC6;
	Mon,  7 Oct 2024 04:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728275504;
	bh=h4BqdarIxiHAkZjTqrf5W1xk6PBnK/XznaYWb774zhU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Ns5p+FPNQ6ghH8QdqMYD3NDD1rym469P8SEFY3wude6968PtVUVO1m3sETctDROEx
	 NLAq6xLzPTAJFQVTGNeUG+y9HE8RtxgdgNvzG0o6v5eEB/pilsUmcb6tOZLL8y2Are
	 D35iCJC7QYTDWm01Qy6wJmKoUpGFQ3xJkcpCGKy1LljNh95W5yxkt0h7wdyDmhPhy0
	 ikAU5uV8cEPCeGLLQyVQgUVElKTuilKtfCttAD48Z7x//dJaeI+NQJkLNkf36xPXEC
	 ASr11zQZ/Y4MLavUsS9PH/8JFhHQnQkx6Nf/dBTeQ5dM2WSk//1i7CB16DuuvY8nt6
	 9oTQqp+ZnlLMw==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v5 19/43] KVM: arm64: Handle realm MMIO emulation
In-Reply-To: <20241004152804.72508-20-steven.price@arm.com>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-20-steven.price@arm.com>
Date: Mon, 07 Oct 2024 10:01:33 +0530
Message-ID: <yq5awmik5yai.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> MMIO emulation for a realm cannot be done directly with the VM's
> registers as they are protected from the host. However, for emulatable
> data aborts, the RMM uses GPRS[0] to provide the read/written value.
> We can transfer this from/to the equivalent VCPU's register entry and
> then depend on the generic MMIO handling code in KVM.
>
> For a MMIO read, the value is placed in the shared RecExit structure
> during kvm_handle_mmio_return() rather than in the VCPU's register
> entry.
>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v3: Adapt to previous patch changes
> ---
>  arch/arm64/kvm/mmio.c     | 10 +++++++++-
>  arch/arm64/kvm/rme-exit.c |  6 ++++++
>  2 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> index cd6b7b83e2c3..66a838b3776a 100644
> --- a/arch/arm64/kvm/mmio.c
> +++ b/arch/arm64/kvm/mmio.c
> @@ -6,6 +6,7 @@
>  
>  #include <linux/kvm_host.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/rmi_smc.h>
>  #include <trace/events/kvm.h>
>  
>  #include "trace.h"
> @@ -90,6 +91,9 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>  
>  	vcpu->mmio_needed = 0;
>  
> +	if (vcpu_is_rec(vcpu))
> +		vcpu->arch.rec.run->enter.flags |= REC_ENTER_EMULATED_MMIO;
> +
>  	if (!kvm_vcpu_dabt_iswrite(vcpu)) {
>  		struct kvm_run *run = vcpu->run;
>  
> @@ -108,7 +112,11 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>  		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
>  			       &data);
>  		data = vcpu_data_host_to_guest(vcpu, data, len);
> -		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
> +
> +		if (vcpu_is_rec(vcpu))
> +			vcpu->arch.rec.run->enter.gprs[0] = data;
> +		else
> +			vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
>  	}
>  
>  	/*
>

Does a kvm_incr_pc(vcpu); make sense for realm guest? Should we do

modified   arch/arm64/kvm/mmio.c
@@ -91,9 +91,6 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 
 	vcpu->mmio_needed = 0;
 
-	if (vcpu_is_rec(vcpu))
-		vcpu->arch.rec.run->enter.flags |= RMI_EMULATED_MMIO;
-
 	if (!kvm_vcpu_dabt_iswrite(vcpu)) {
 		struct kvm_run *run = vcpu->run;
 
@@ -123,7 +120,10 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 	 * The MMIO instruction is emulated and should not be re-executed
 	 * in the guest.
 	 */
-	kvm_incr_pc(vcpu);
+	if (vcpu_is_rec(vcpu))
+		vcpu->arch.rec.run->enter.flags |= RMI_EMULATED_MMIO;
+	else
+		kvm_incr_pc(vcpu);
 
 	return 1;
 }



> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
> index e96ea308212c..1ddbff123149 100644
> --- a/arch/arm64/kvm/rme-exit.c
> +++ b/arch/arm64/kvm/rme-exit.c
> @@ -25,6 +25,12 @@ static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
>  
>  static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
>  {
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	if (kvm_vcpu_dabt_iswrite(vcpu) && kvm_vcpu_dabt_isvalid(vcpu))
> +		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu),
> +			     rec->run->exit.gprs[0]);
> +
>  	return kvm_handle_guest_abort(vcpu);
>  }
>  
> -- 
> 2.34.1

