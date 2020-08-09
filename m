Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1079823FD74
	for <lists+kvm@lfdr.de>; Sun,  9 Aug 2020 10:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgHIIyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Aug 2020 04:54:43 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:41429 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgHIIyn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Aug 2020 04:54:43 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BPXwG0lqgz9sPC;
        Sun,  9 Aug 2020 18:54:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1596963279;
        bh=QoCThBV9jXzeJGtXYb+HPe7DiyK6LoCJaB12gQ9BX7I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J1l/BUZDO3Lc0uxcxB3nPrS2iGokt6LJPqzKDBaMslGCNmVOVB8r1ojVUpRxUIHal
         vRY2Ya2lby4qJFRtxW6MBzBF3shsSBT0eFPlqP9mmf/oSx091OMMMldY0TPlkZR5kJ
         X21q8H+gjfApVY5f2/tVU2QkC4Ualgn9w+j6WllnMhQUhxDBV1aQZUqtSO6daqgwRP
         E4CwQ/btNbIr3DVAeas3TEt2QZW6yiHUlEDqm3r/pa4KKtQmWNCQv7v/XHimLWlYEU
         x0sjo1rixKFsTbH9Szw7m/P7109+wA6BAV+/F+Udzq49kG3ycQhsfzW9LIMCQxT77k
         v8Ps5xTnCX1vw==
Date:   Sun, 9 Aug 2020 18:54:36 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        James Morse <james.morse@arm.com>,
        Gavin Shan <gshan@redhat.com>
Subject: Re: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20200809185436.5b6e2887@canb.auug.org.au>
In-Reply-To: <20200713143935.799861b9@canb.auug.org.au>
References: <20200713143935.799861b9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/vOK2jNuyntu8DxC1ELqBGrA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/vOK2jNuyntu8DxC1ELqBGrA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 13 Jul 2020 14:39:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> Today's linux-next merge of the kvm-arm tree got conflicts in:
>=20
>   arch/arm64/include/asm/kvm_coproc.h
>   arch/arm64/kvm/handle_exit.c
>=20
> between commit:
>=20
>   74cc7e0c35c1 ("KVM: arm64: clean up redundant 'kvm_run' parameters")
>=20
> from the kvm tree and commits:
>=20
>   6b33e0d64f85 ("KVM: arm64: Drop the target_table[] indirection")
>   750ed5669380 ("KVM: arm64: Remove the target table")
>   3a949f4c9354 ("KVM: arm64: Rename HSR to ESR")
>=20
> from the kvm-arm tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> diff --cc arch/arm64/include/asm/kvm_coproc.h
> index 454373704b8a,147f3a77e6a5..000000000000
> --- a/arch/arm64/include/asm/kvm_coproc.h
> +++ b/arch/arm64/include/asm/kvm_coproc.h
> @@@ -19,20 -19,12 +19,12 @@@ struct kvm_sys_reg_table=20
>   	size_t num;
>   };
>  =20
> - struct kvm_sys_reg_target_table {
> - 	struct kvm_sys_reg_table table64;
> - 	struct kvm_sys_reg_table table32;
> - };
> -=20
> - void kvm_register_target_sys_reg_table(unsigned int target,
> - 				       struct kvm_sys_reg_target_table *table);
> -=20
>  -int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *r=
un);
>  -int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  -int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  -int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  -int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  -int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  +int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu);
>  +int kvm_handle_cp14_32(struct kvm_vcpu *vcpu);
>  +int kvm_handle_cp14_64(struct kvm_vcpu *vcpu);
>  +int kvm_handle_cp15_32(struct kvm_vcpu *vcpu);
>  +int kvm_handle_cp15_64(struct kvm_vcpu *vcpu);
>  +int kvm_handle_sys_reg(struct kvm_vcpu *vcpu);
>  =20
>   #define kvm_coproc_table_init kvm_sys_reg_table_init
>   void kvm_sys_reg_table_init(void);
> diff --cc arch/arm64/kvm/handle_exit.c
> index 1df3beafd73f,98ab33139982..000000000000
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@@ -87,9 -87,9 +87,9 @@@ static int handle_no_fpsimd(struct kvm_
>    * world-switches and schedule other host processes until there is an
>    * incoming IRQ or FIQ to the VM.
>    */
>  -static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  +static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
>   {
> - 	if (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
> + 	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
>   		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
>   		vcpu->stat.wfe_exit_stat++;
>   		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
> @@@ -114,12 -115,11 +114,12 @@@
>    * guest and host are using the same debug facilities it will be up to
>    * userspace to re-inject the correct exception for guest delivery.
>    *
>  - * @return: 0 (while setting run->exit_reason), -1 for error
>  + * @return: 0 (while setting vcpu->run->exit_reason), -1 for error
>    */
>  -static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu, struct kvm_run=
 *run)
>  +static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
>   {
>  +	struct kvm_run *run =3D vcpu->run;
> - 	u32 hsr =3D kvm_vcpu_get_hsr(vcpu);
> + 	u32 esr =3D kvm_vcpu_get_esr(vcpu);
>   	int ret =3D 0;
>  =20
>   	run->exit_reason =3D KVM_EXIT_DEBUG;
> @@@ -144,12 -144,12 +144,12 @@@
>   	return ret;
>   }
>  =20
>  -static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu, struct kvm_run =
*run)
>  +static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
>   {
> - 	u32 hsr =3D kvm_vcpu_get_hsr(vcpu);
> + 	u32 esr =3D kvm_vcpu_get_esr(vcpu);
>  =20
> - 	kvm_pr_unimpl("Unknown exception class: hsr: %#08x -- %s\n",
> - 		      hsr, esr_get_class_string(hsr));
> + 	kvm_pr_unimpl("Unknown exception class: esr: %#08x -- %s\n",
> + 		      esr, esr_get_class_string(esr));
>  =20
>   	kvm_inject_undefined(vcpu);
>   	return 1;
> @@@ -237,12 -237,11 +237,12 @@@ static int handle_trap_exceptions(struc
>    * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason)=
 on
>    * proper exit to userspace.
>    */
>  -int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  -		       int exception_index)
>  +int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
>   {
>  +	struct kvm_run *run =3D vcpu->run;
>  +
>   	if (ARM_SERROR_PENDING(exception_index)) {
> - 		u8 hsr_ec =3D ESR_ELx_EC(kvm_vcpu_get_hsr(vcpu));
> + 		u8 esr_ec =3D ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
>  =20
>   		/*
>   		 * HVC/SMC already have an adjusted PC, which we need

This is now a conflict between the kvm-arm tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/vOK2jNuyntu8DxC1ELqBGrA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8vucwACgkQAVBC80lX
0GyP2wf8C/+tpoblHMl88gR6IlUCPHb2h3iARfy/I3njm8B5vZw+84a70RBAO+e1
JBM7hAaVX04j+piyATCP8O9Dwdx9R6FKYsUloXqRD0akb4SeJBK7Y56ijMNP0Ss5
0qqJlJt5Rt1iwBE4UpSgLj5YpJQ1Nu5poWMmUhqVKINmgkVo1h/3/ofDJrMvZAK6
p2YsZwcee7bHQsC2vbsfODQ8fuwfgs4juYe4VvnHXlzbqqZ80FSkYz05j9+Phlf5
gAGHLGFn1AQHeoLmsyNyp1M/WFhRBHLTNyCLEsyejBhB63KYwrgkWRT3Ssnd554S
I+e5UOhnxROejMwvT+i0kHobOS2+UQ==
=Dxv0
-----END PGP SIGNATURE-----

--Sig_/vOK2jNuyntu8DxC1ELqBGrA--
