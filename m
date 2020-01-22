Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7273F144A6D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 04:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgAVD3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 22:29:49 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:42735 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbgAVD3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 22:29:48 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 482W9j75b1z9sRs; Wed, 22 Jan 2020 14:29:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1579663786;
        bh=sn7xKkZ6SItaNbo3lEJZZA3KUS2uXO/WN/19CMVZwOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hhg46VNQxseDJKZbEu4w2qPWCbV5khGsoXPQ9sCoRvkzqti+FCinPnDVncC+Vgicw
         IuxWYcdaClGCGthT/xv0UGFBTzYEVinzMBsXi8YQBPkmIH/tj6BETd7Pjry4hS5cjC
         C6lgmjDOJ7LKU9okJFXR4l+0KPBtOBQJiL2Ns+cI=
Date:   Wed, 22 Jan 2020 14:28:56 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-s390x@nongnu.org,
        David Hildenbrand <david@redhat.com>, qemu-ppc@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        Like Xu <like.xu@linux.intel.com>,
        Markus Armbruster <armbru@redhat.com>, qemu-arm@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Alistair Francis <alistair.francis@wdc.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 09/10] accel: Replace current_machine->accelerator by
 current_accel() wrapper
Message-ID: <20200122032856.GI2347@umbus.fritz.box>
References: <20200121110349.25842-1-philmd@redhat.com>
 <20200121110349.25842-10-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X+nYw8KZ/oNxZ8JS"
Content-Disposition: inline
In-Reply-To: <20200121110349.25842-10-philmd@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--X+nYw8KZ/oNxZ8JS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2020 at 12:03:48PM +0100, Philippe Mathieu-Daud=E9 wrote:
> We actually want to access the accelerator, not the machine, so
> use the current_accel() wrapper instead.
>=20
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
> Signed-off-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>

ppc parts
Acked-by: David Gibson <david@gibson.dropbear.id.au>

> ---
> v2:
> - Reworded description
> - Remove unused include in arm/kvm64
> ---
>  accel/kvm/kvm-all.c | 4 ++--
>  accel/tcg/tcg-all.c | 2 +-
>  memory.c            | 2 +-
>  target/arm/kvm64.c  | 5 ++---
>  target/i386/kvm.c   | 2 +-
>  target/ppc/kvm.c    | 2 +-
>  vl.c                | 2 +-
>  7 files changed, 9 insertions(+), 10 deletions(-)
>=20
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 1ada2f4ecb..c111312dfd 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -164,7 +164,7 @@ static NotifierList kvm_irqchip_change_notifiers =3D
> =20
>  int kvm_get_max_memslots(void)
>  {
> -    KVMState *s =3D KVM_STATE(current_machine->accelerator);
> +    KVMState *s =3D KVM_STATE(current_accel());
> =20
>      return s->nr_slots;
>  }
> @@ -1848,7 +1848,7 @@ static int kvm_max_vcpu_id(KVMState *s)
> =20
>  bool kvm_vcpu_id_is_valid(int vcpu_id)
>  {
> -    KVMState *s =3D KVM_STATE(current_machine->accelerator);
> +    KVMState *s =3D KVM_STATE(current_accel());
>      return vcpu_id >=3D 0 && vcpu_id < kvm_max_vcpu_id(s);
>  }
> =20
> diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
> index 1dc384c8d2..1802ce02f6 100644
> --- a/accel/tcg/tcg-all.c
> +++ b/accel/tcg/tcg-all.c
> @@ -124,7 +124,7 @@ static void tcg_accel_instance_init(Object *obj)
> =20
>  static int tcg_init(MachineState *ms)
>  {
> -    TCGState *s =3D TCG_STATE(current_machine->accelerator);
> +    TCGState *s =3D TCG_STATE(current_accel());
> =20
>      tcg_exec_init(s->tb_size * 1024 * 1024);
>      cpu_interrupt_handler =3D tcg_handle_interrupt;
> diff --git a/memory.c b/memory.c
> index d7b9bb6951..854798791e 100644
> --- a/memory.c
> +++ b/memory.c
> @@ -3104,7 +3104,7 @@ void mtree_info(bool flatview, bool dispatch_tree, =
bool owner)
>          };
>          GArray *fv_address_spaces;
>          GHashTable *views =3D g_hash_table_new(g_direct_hash, g_direct_e=
qual);
> -        AccelClass *ac =3D ACCEL_GET_CLASS(current_machine->accelerator);
> +        AccelClass *ac =3D ACCEL_GET_CLASS(current_accel());
> =20
>          if (ac->has_memory) {
>              fvi.ac =3D ac;
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index 876184b8fe..e3c580e749 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -26,7 +26,6 @@
>  #include "sysemu/kvm.h"
>  #include "sysemu/kvm_int.h"
>  #include "kvm_arm.h"
> -#include "hw/boards.h"
>  #include "internals.h"
> =20
>  static bool have_guest_debug;
> @@ -613,14 +612,14 @@ bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatur=
es *ahcf)
> =20
>  bool kvm_arm_aarch32_supported(CPUState *cpu)
>  {
> -    KVMState *s =3D KVM_STATE(current_machine->accelerator);
> +    KVMState *s =3D KVM_STATE(current_accel());
> =20
>      return kvm_check_extension(s, KVM_CAP_ARM_EL1_32BIT);
>  }
> =20
>  bool kvm_arm_sve_supported(CPUState *cpu)
>  {
> -    KVMState *s =3D KVM_STATE(current_machine->accelerator);
> +    KVMState *s =3D KVM_STATE(current_accel());
> =20
>      return kvm_check_extension(s, KVM_CAP_ARM_SVE);
>  }
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 7ee3202634..eddb930065 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -147,7 +147,7 @@ bool kvm_allows_irq0_override(void)
> =20
>  static bool kvm_x2apic_api_set_flags(uint64_t flags)
>  {
> -    KVMState *s =3D KVM_STATE(current_machine->accelerator);
> +    KVMState *s =3D KVM_STATE(current_accel());
> =20
>      return !kvm_vm_enable_cap(s, KVM_CAP_X2APIC_API, 0, flags);
>  }
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index b5799e62b4..45ede6b6d9 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -258,7 +258,7 @@ static void kvm_get_smmu_info(struct kvm_ppc_smmu_inf=
o *info, Error **errp)
> =20
>  struct ppc_radix_page_info *kvm_get_radix_page_info(void)
>  {
> -    KVMState *s =3D KVM_STATE(current_machine->accelerator);
> +    KVMState *s =3D KVM_STATE(current_accel());
>      struct ppc_radix_page_info *radix_page_info;
>      struct kvm_ppc_rmmu_info rmmu_info;
>      int i;
> diff --git a/vl.c b/vl.c
> index 71d3e7eefb..a8ea36f4f8 100644
> --- a/vl.c
> +++ b/vl.c
> @@ -2812,7 +2812,7 @@ static void configure_accelerators(const char *prog=
name)
>      }
> =20
>      if (init_failed) {
> -        AccelClass *ac =3D ACCEL_GET_CLASS(current_machine->accelerator);
> +        AccelClass *ac =3D ACCEL_GET_CLASS(current_accel());
>          error_report("falling back to %s", ac->name);
>      }
> =20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--X+nYw8KZ/oNxZ8JS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl4nwXgACgkQbDjKyiDZ
s5KQjA/5AWHyv4v6rfJAATtSyWrFZBMM6JSp8t5nXhPeVMbRZJElTj+aZQlJnojH
S+d5VMUyzr1uv31BqsV69lL0mLlh9P/JDtmqFxA0sxQ+c3vSjQFcMTa9tpgaZtP7
CcgB2B3xU/FGn3D7Z+NeUvqhSON6Gz3Gf1+pHZVQNAC6CgGGIZl1BGaGZO8mh+HT
og9me7Latm/gyadx1C2t7XiqnI54aKFiA67H6ACROcmOJmXrUXfBE01hCoutAY64
xMJq250XMXj0Ug9rDRH29JfIAOMbHKPwBi8kOJu/21xtz0M2GqJRQ1AVWW0UuJ7U
t88m11vBAP/mjbtbcc00VOKuIvPNuodRYenraiIsBrdO05Pv32ug+NSNFK6kyhAv
CG7Z4pIQsLaqoLt16HbxCbrOPSZZY1i5e+MiLPs3kC+kcR9JVMxtAMybKbYQpnGE
lXp5pYiAx2ZRjgpPpCMmJ/RRDxHworeUu+8r95bBmYJiDsl+gFjCb2EyYIrU43NP
OVzla3QhyRF0I8m8SQFf6/QEN2OP3QQhNUscP4qXT7UOqttsRzPeKqhTqxM9RVUz
UQ/R+COp+4wvNuVWsPzF7ZpCeFNDzaXoYy3FYGNJqqGXlZUUectKrUiMx678D4f/
WgNH6A7V1i7Pf77T480gOkYCFz2sQoQTuOVqesfEFqisLEimELY=
=F7CM
-----END PGP SIGNATURE-----

--X+nYw8KZ/oNxZ8JS--
