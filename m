Return-Path: <kvm+bounces-45069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8EF8AA5C17
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 10:24:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B50A4C52C6
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDECA212B0C;
	Thu,  1 May 2025 08:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O97L3cnM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3221E8855;
	Thu,  1 May 2025 08:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746087856; cv=none; b=YEtsyNoUYHe2j+ONm4jHpckNl/6Zxv5pjIqF68N9Oc3PC+fxaNCraUlJknCGzhrYf1/pE/gdfPfOazRrN8OuMhAjPpXDzon8xHRkZbCKP8D6DsFpDMHLxrXfY/QiIK5IGDmFoseHSXRzd6eRCn8X6loG+xUDOen9/UqhmzFps8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746087856; c=relaxed/simple;
	bh=FUtw7sDZdVXOm9Nv2svOTgxrCByJlvpP+UTjvuTtS1I=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FM5I6CuVokmwmn/0v6xlE1o9sRRAcUmFStDsfNdyl67edvRYmFkxVVYjytUydOZqqENx0prmVZ6NkDU1Rc44p1kMGKO+pjoJMmpzJB9Oz9I/orxdoym5n2VVihFBMsj/4FsGMW0ZTlChDnk9Ve1zF1l7oi0KfudCa/kU8iHRn90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O97L3cnM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60251C4CEE3;
	Thu,  1 May 2025 08:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746087855;
	bh=FUtw7sDZdVXOm9Nv2svOTgxrCByJlvpP+UTjvuTtS1I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=O97L3cnMvunZjO/0b3AD7mX6YsWjOA1AairfrKios6nfa+PekJx8V9jm72WccaYLD
	 MFg2U9+xORpdBstItLdTn2jDJ/KEsIRT04HWQvHyQCbyTtG0ClRI3D/X2CD6XM+FOj
	 /tz1rvNkqLQslwyHEIsvRxeQEF7oPqOkIM7OE5yCyUmforniQ2Wdg+RNlnV8cmfd9X
	 16HjICyqst700kZfBgn5lDQrvldBI/haW5J2/qj7rZP5/M2+H5tq4/MkVCxXr+bLok
	 BPs+unjgpwBK9BDZKgsuXLVUjyyxhBLmEvRC18HDlHZbiqF5SS0uUSHzhHrhH/LVHG
	 92LXRRsmolgow==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uAPDI-00AWZy-KR;
	Thu, 01 May 2025 09:24:12 +0100
Date: Thu, 01 May 2025 09:24:11 +0100
Message-ID: <864iy4ivro.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Borislav Petkov <bp@alien8.de>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Alexander Potapenko <glider@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Andre Przywara <andre.przywara@arm.com>,
	x86@kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kvm-riscv@lists.infradead.org,
	Atish Patra <atishp@atishpatra.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sebastian Ott <sebott@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Shusen Li <lishusen2@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 2/5] arm64: KVM: use mutex_trylock_nest_lock when locking all vCPUs
In-Reply-To: <20250430203013.366479-3-mlevitsk@redhat.com>
References: <20250430203013.366479-1-mlevitsk@redhat.com>
	<20250430203013.366479-3-mlevitsk@redhat.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: mlevitsk@redhat.com, kvm@vger.kernel.org, linux-riscv@lists.infradead.org, jiangkunkun@huawei.com, longman@redhat.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, bhelgaas@google.com, boqun.feng@gmail.com, bp@alien8.de, aou@eecs.berkeley.edu, anup@brainfault.org, paul.walmsley@sifive.com, suzuki.poulose@arm.com, palmer@dabbelt.com, alex@ghiti.fr, glider@google.com, oliver.upton@linux.dev, andre.przywara@arm.com, x86@kernel.org, joey.gouly@arm.com, tglx@linutronix.de, kvm-riscv@lists.infradead.org, atishp@atishpatra.org, mingo@redhat.com, jingzhangos@google.com, hpa@zytor.com, dave.hansen@linux.intel.com, kvmarm@lists.linux.dev, will@kernel.org, keisuke.nishimura@inria.fr, sebott@redhat.com, peterz@infradead.org, lishusen2@huawei.com, pbonzini@redhat.com, rdunlap@infradead.org, seanjc@google.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

nit: in keeping with the existing arm64 patches, please write the
subject as "KVM: arm64: Use ..."

On Wed, 30 Apr 2025 21:30:10 +0100,
Maxim Levitsky <mlevitsk@redhat.com> wrote:

[...]

> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 68fec8c95fee..d31f42a71bdc 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1914,49 +1914,6 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  	}
>  }
>  
> -/* unlocks vcpus from @vcpu_lock_idx and smaller */
> -static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
> -{
> -	struct kvm_vcpu *tmp_vcpu;
> -
> -	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
> -		tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
> -		mutex_unlock(&tmp_vcpu->mutex);
> -	}
> -}
> -
> -void unlock_all_vcpus(struct kvm *kvm)
> -{
> -	lockdep_assert_held(&kvm->lock);

Note this assertion...

> -
> -	unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
> -}
> -
> -/* Returns true if all vcpus were locked, false otherwise */
> -bool lock_all_vcpus(struct kvm *kvm)
> -{
> -	struct kvm_vcpu *tmp_vcpu;
> -	unsigned long c;
> -
> -	lockdep_assert_held(&kvm->lock);

and this one...

> -
> -	/*
> -	 * Any time a vcpu is in an ioctl (including running), the
> -	 * core KVM code tries to grab the vcpu->mutex.
> -	 *
> -	 * By grabbing the vcpu->mutex of all VCPUs we ensure that no
> -	 * other VCPUs can fiddle with the state while we access it.
> -	 */
> -	kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
> -		if (!mutex_trylock(&tmp_vcpu->mutex)) {
> -			unlock_vcpus(kvm, c - 1);
> -			return false;
> -		}
> -	}
> -
> -	return true;
> -}
> -
>  static unsigned long nvhe_percpu_size(void)
>  {
>  	return (unsigned long)CHOOSE_NVHE_SYM(__per_cpu_end) -

[...]

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 69782df3617f..834f08dfa24c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1368,6 +1368,40 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
>  	return 0;
>  }
>  
> +/*
> + * Try to lock all of the VM's vCPUs.
> + * Assumes that the kvm->lock is held.

Assuming is not enough. These assertions have caught a number of bugs,
and I'm not prepared to drop them.

> + */
> +int kvm_trylock_all_vcpus(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i, j;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		if (!mutex_trylock_nest_lock(&vcpu->mutex, &kvm->lock))
> +			goto out_unlock;
> +	return 0;
> +
> +out_unlock:
> +	kvm_for_each_vcpu(j, vcpu, kvm) {
> +		if (i == j)
> +			break;
> +		mutex_unlock(&vcpu->mutex);
> +	}
> +	return -EINTR;
> +}
> +EXPORT_SYMBOL_GPL(kvm_trylock_all_vcpus);
> +
> +void kvm_unlock_all_vcpus(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		mutex_unlock(&vcpu->mutex);
> +}
> +EXPORT_SYMBOL_GPL(kvm_unlock_all_vcpus);

I don't mind you not including the assertions in these helpers, but
then the existing primitives have to stay and call into the new stuff.
Which, from a simple patch volume, would be far preferable and help
with managing backports.

I'd also expect the introduction of these new helpers to be done in
its own patch, so that we don't get cross architecture dependencies if
something needs to be backported for a reason or another.

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.

