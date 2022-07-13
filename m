Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD56C572BC4
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 05:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiGMDLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 23:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiGMDLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 23:11:13 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C49D7A51;
        Tue, 12 Jul 2022 20:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657681871; x=1689217871;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=WY0QeqI2LkFQ/1FYacsuMGmEIf3sMDNCrKPzdMAOBVE=;
  b=egpFAlrSiakiEbFvC//4PoUWr9okGtQYWyl86J5UMwIVl4kZfPqvEyGi
   Ku+Fox+54mOWOWIJBSEJgr4CvzvhJ+q/GUYPI9eyZogoN2FzxE60714pK
   lBySg2RN/pHOkJzqNCsckOQnvloxJoo2cZSOsUUMear0T/IHX7VFS7amX
   Ad3RScIxh+PI1AhY9wawgvprtsIUlaGLHcCeT0o4dQc/DnH8nitPzjoI2
   6W5UutfW4mTeQlt96igCiAU+R+RLsENfVXVg1/beaExEQHeOikBemzM26
   WlzDe4tH7x1mWGB6tVMPDczgCA6Urr9DWp3nt2zwuXbXnEqWZZ70xSr9O
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="285842641"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="285842641"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 20:11:11 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="622760946"
Received: from ifatima-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.1.196])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 20:11:09 -0700
Message-ID: <a62d58d0c388ff1e20453517c83bb8268dc02a8e.camel@intel.com>
Subject: Re: [PATCH v7 003/102] KVM: Refactor CPU compatibility check on
 module initialiization
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Jul 2022 15:11:07 +1200
In-Reply-To: <e1f72040effd7b4ed31f9941e009f959d6345129.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <e1f72040effd7b4ed31f9941e009f959d6345129.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:52 -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> Although non-x86 arch doesn't break as long as I inspected code, it's by
> code inspection.  This should be reviewed by each arch maintainers.

This first paragraph doesn't make sense to me.  At this moment, we don't kn=
ow
why you need this patch at all.

>=20
> kvm_init() checks CPU compatibility by calling
> kvm_arch_check_processor_compat() on all online CPUs. =C2=A0
>=20

What's the problem here which requires you need to do ..

> Move the callback
> to hardware_enable_nolock() and add hardware_enable_all() and
> hardware_disable_all().

.. this?


> Add arch specific callback kvm_arch_post_hardware_enable_setup() for arch
> to do arch specific initialization that required hardware_enable_all().
> This makes a room for TDX module to initialize on kvm module loading.  TD=
X
> module requires all online cpu to enable VMX by VMXON.

So to me this is the reason why you need to do hardware_enable_all() in
kvm_init().  There's nothing wrong with "kvm_init() checks CPU compatibilit=
y by
calling kvm_arch_check_processor_compat() on all online CPUs", right?

In this case, shouldn't we say something like "opportunistically move
kvm_arch_check_processor_compat() to hardware_enable_nolock()" because this=
 is
not the reason that you want this patch, correct?

Also, maybe I am missing something obviously, but why do you need to do
hardware_disable_all() right after hardware_enable_all() in kvm_init()?  Co=
uld
you at least put some explanation in the changelog?

And again, it's better to add one sentence or so to explain why do you want=
 to
init TDX module during module loading time.

>=20
> If kvm_arch_hardware_enable/disable() depend on (*) part, such dependency
> must be called before kvm_init(). =C2=A0
>=20

I don't follow the logic here. =C2=A0If kvm_arch_hardware_enable() depends =
on
something, then you need to put kvm_arch_hardware_enable() after that, or m=
ove
that forward.  But why such dependency must be called "before kvm_init()"?

Also, I think you are talking about the problem that _after_ you move
hardware_enable_all() to kvm_init(), but not problem in existing code, righ=
t?


> In fact kvm_intel() does. =C2=A0
>=20

No such function kvm_intel().

Again, what's the issue here? Can you add more sentences to explain the
_problem_, or _why_?


> Although
> other arch doesn't as long as I checked as follows, it should be reviewed
> by each arch maintainers.
>=20
> Before this patch:
> - Arch module initialization
>   - kvm_init()
>     - kvm_arch_init()
>     - kvm_arch_check_processor_compat() on each CPUs
>   - post arch specific initialization ---- (*)
>=20
> - when creating/deleting first/last VM
>    - kvm_arch_hardware_enable() on each CPUs --- (A)
>    - kvm_arch_hardware_disable() on each CPUs --- (B)
>=20
> After this patch:
> - Arch module initialization
>   - kvm_init()
>     - kvm_arch_init()
>     - kvm_arch_hardware_enable() on each CPUs  (A)
>     - kvm_arch_check_processor_compat() on each CPUs

Even with this patch, unless I am seeing mistakenly, kvm_arch_hardware_enab=
le()
is called _after_ kvm_arch_check_processor_compat().

>     - kvm_arch_hardware_disable() on each CPUs (B)
>   - post arch specific initialization  --- (*)
>=20
> Code inspection result:
> (A)/(B) can depend on (*) before this patch. =C2=A0If there is dependency=
, such
> initialization must be moved before kvm_init() with this patch. =C2=A0
>=20

Must be moved to before (A)/(B), right?

> VMX does
> in fact. =C2=A0
>=20

More details will help, please.

> As long as I inspected other archs and find only mips has it.
>=20
> - arch/mips/kvm/mips.c
>   module init function, kvm_mips_init(), does some initialization after
>   kvm_init().  Compile test only.  Needs review.

Is "Needs review" changelog material?

>=20
> - arch/x86/kvm/x86.c
>   - uses vm_list which is statically initialized.

I can hardly see how "vm_list is statically initialized" is causing any pro=
blem
here.  Exactly what's the problem here??

>   - static_call(kvm_x86_hardware_enable)();
>     - SVM: (*) is empty.
>     - VMX: needs fix

What's the problem, and how are you going to fix?  Shouldn't this be in
changelog?

>=20
> - arch/powerpc/kvm/powerpc.c
>   kvm_arch_hardware_enable/disable() are nop
>=20
> - arch/s390/kvm/kvm-s390.c
>   kvm_arch_hardware_enable/disable() are nop
>=20
> - arch/arm64/kvm/arm.c
>   module init function, arm_init(), calls only kvm_init().
>   (*) is empty
>=20
> - arch/riscv/kvm/main.c
>   module init function, riscv_kvm_init(), calls only kvm_init().
>   (*) is empty
>=20
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/mips/kvm/mips.c     | 12 +++++++-----
>  arch/x86/kvm/vmx/vmx.c   | 15 +++++++++++----
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/kvm_main.c      | 25 ++++++++++++++++++-------
>  4 files changed, 37 insertions(+), 16 deletions(-)
>=20
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 092d09fb6a7e..17228584485d 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -1643,11 +1643,6 @@ static int __init kvm_mips_init(void)
>  	}
> =20
>  	ret =3D kvm_mips_entry_setup();
> -	if (ret)
> -		return ret;
> -
> -	ret =3D kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
> -
>  	if (ret)
>  		return ret;
> =20
> @@ -1656,6 +1651,13 @@ static int __init kvm_mips_init(void)
> =20
>  	register_die_notifier(&kvm_mips_csr_die_notifier);
> =20
> +	ret =3D kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
> +
> +	if (ret) {
> +		unregister_die_notifier(&kvm_mips_csr_die_notifier);
> +		return ret;
> +	}
> +

I don't understand how moving "hardware_enable_all()/hardware_disable_all()=
" to
kvm_init() is related to this change.

Anyway, at least some comments?

>  	return 0;
>  }
> =20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 31e7630203fd..d3b68a6dec48 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8372,6 +8372,15 @@ static void vmx_exit(void)
>  }
>  module_exit(vmx_exit);
> =20
> +/* initialize before kvm_init() so that hardware_enable/disable() can wo=
rk. */

There's no function named hardware_enable() or hardware_disable().

> +static void __init vmx_init_early(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> +}
> +

Perhaps I am missing something, but I couldn't see why this must be done be=
fore
kvm_init().  Please give some comments?

>  static int __init vmx_init(void)
>  {
>  	int r, cpu;
> @@ -8409,6 +8418,7 @@ static int __init vmx_init(void)
>  	}
>  #endif
> =20
> +	vmx_init_early();
>  	r =3D kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
>  		     __alignof__(struct vcpu_vmx), THIS_MODULE);
>  	if (r)
> @@ -8427,11 +8437,8 @@ static int __init vmx_init(void)
>  		return r;
>  	}
> =20
> -	for_each_possible_cpu(cpu) {
> -		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> -
> +	for_each_possible_cpu(cpu)
>  		pi_init_cpu(cpu);
> -	}
> =20
>  #ifdef CONFIG_KEXEC_CORE
>  	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d4f130a9f5c8..79a4988fd51f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1441,6 +1441,7 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *=
vcpu, struct dentry *debugfs_
>  int kvm_arch_hardware_enable(void);
>  void kvm_arch_hardware_disable(void);
>  int kvm_arch_hardware_setup(void *opaque);
> +int kvm_arch_post_hardware_enable_setup(void *opaque);
>  void kvm_arch_hardware_unsetup(void);
>  int kvm_arch_check_processor_compat(void);
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a5bada53f1fe..cee799265ce6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4899,8 +4899,13 @@ static void hardware_enable_nolock(void *junk)
> =20
>  	cpumask_set_cpu(cpu, cpus_hardware_enabled);
> =20
> +	r =3D kvm_arch_check_processor_compat();
> +	if (r)
> +		goto out;
> +
>  	r =3D kvm_arch_hardware_enable();
> =20
> +out:
>  	if (r) {
>  		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
>  		atomic_inc(&hardware_enable_failed);
> @@ -5697,9 +5702,9 @@ void kvm_unregister_perf_callbacks(void)
>  }
>  #endif
> =20
> -static void check_processor_compat(void *rtn)
> +__weak int kvm_arch_post_hardware_enable_setup(void *opaque)
>  {
> -	*(int *)rtn =3D kvm_arch_check_processor_compat();
> +	return 0;
>  }
> =20
>  int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
> @@ -5732,11 +5737,17 @@ int kvm_init(void *opaque, unsigned vcpu_size, un=
signed vcpu_align,
>  	if (r < 0)
>  		goto out_free_1;
> =20
> -	for_each_online_cpu(cpu) {
> -		smp_call_function_single(cpu, check_processor_compat, &r, 1);
> -		if (r < 0)
> -			goto out_free_2;
> -	}
> +	/* hardware_enable_nolock() checks CPU compatibility on each CPUs. */
> +	r =3D hardware_enable_all();
> +	if (r)
> +		goto out_free_2;
> +	/*
> +	 * Arch specific initialization that requires to enable virtualization
> +	 * feature.  e.g. TDX module initialization requires VMXON on all
> +	 * present CPUs.
> +	 */
> +	kvm_arch_post_hardware_enable_setup(opaque);

So after digging history and looking at the code again, I guess perhaps it'=
s
also fine to introduce this __weak version here (since you have given the r=
eason
to do so in changelog), but in this way perhaps it's better to put this pat=
ch
and the patch to load TDX module closely so it's easier to review.

Or to me it's also fine to move this chunk to the patch to init TDX module =
as I
replied before.

> +	hardware_disable_all();

IMO needs a comment why do we need to do hardware_disable_all() here.  It
doesn't make a lot sense to me.

> =20
>  	r =3D cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:startin=
g",
>  				      kvm_starting_cpu, kvm_dying_cpu);

