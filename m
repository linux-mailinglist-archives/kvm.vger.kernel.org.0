Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C601EDB90
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 05:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgFDDJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 23:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgFDDJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 23:09:44 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E93C03E96D;
        Wed,  3 Jun 2020 20:09:44 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49crNj17htz9sRR;
        Thu,  4 Jun 2020 13:09:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591240182;
        bh=WasXvbcjLDtJ3mN2nmxy+c3tL5Uy8Yfu778Ic1/0hnc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V4DfANfgkgkDYklGhU+LRic7Ui2EG0PRc7Jp9t6MdE/tYGdw/i6//mO8nVzu9yyjA
         0fGmsFvnLih4I9nRNHQaV7lJhgem2EUyxuOhwbFySk+wyKba4I4hBh5kWsBTyp2Ryo
         E6Pn4nGnhmv3+TCmP/R3US6G52jD9Bnw+YfiCwRRxQC0SlBwaUe8HsDR7ALfAjK0ON
         KVmVU2z3f9CIqGxsca+xahes/wdBbY/Zwdn+Ukh9iv7u8hvWcOy9zr4zGp9h3ZQvWT
         rfj4oEVS5y+9Uu7iFyEHjpDv9io+KuMsH5aQwgYn8nD4qPErz0hxPQRkOuSO8BR5PD
         Ocju0xEY0MAlA==
Date:   Thu, 4 Jun 2020 13:09:40 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <20200604130940.043a0114@canb.auug.org.au>
In-Reply-To: <20200602145358.0a70f077@canb.auug.org.au>
References: <20200602145358.0a70f077@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.UNpn=_DPCExUn=LhpxjEeg";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/.UNpn=_DPCExUn=LhpxjEeg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 2 Jun 2020 14:53:58 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Hi all,
>=20
> Today's linux-next merge of the kvm tree got a conflict in:
>=20
>   arch/x86/kernel/kvm.c
>=20
> between commit:
>=20
>   a707ae1a9bbb ("x86/entry: Switch page fault exception to IDTENTRY_RAW")
>=20
> from the tip tree and commit:
>=20
>   68fd66f100d1 ("KVM: x86: extend struct kvm_vcpu_pv_apf_data with token =
info")
>=20
> from the kvm tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc arch/x86/kernel/kvm.c
> index 07dc47359c4f,d6f22a3a1f7d..000000000000
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@@ -217,23 -218,23 +217,23 @@@ again
>   }
>   EXPORT_SYMBOL_GPL(kvm_async_pf_task_wake);
>  =20
> - u32 noinstr kvm_read_and_reset_pf_reason(void)
>  -u32 kvm_read_and_reset_apf_flags(void)
> ++u32 noinstr kvm_read_and_reset_apf_flags(void)
>   {
> - 	u32 reason =3D 0;
> + 	u32 flags =3D 0;
>  =20
>   	if (__this_cpu_read(apf_reason.enabled)) {
> - 		reason =3D __this_cpu_read(apf_reason.reason);
> - 		__this_cpu_write(apf_reason.reason, 0);
> + 		flags =3D __this_cpu_read(apf_reason.flags);
> + 		__this_cpu_write(apf_reason.flags, 0);
>   	}
>  =20
> - 	return reason;
> + 	return flags;
>   }
> - EXPORT_SYMBOL_GPL(kvm_read_and_reset_pf_reason);
> + EXPORT_SYMBOL_GPL(kvm_read_and_reset_apf_flags);
>  -NOKPROBE_SYMBOL(kvm_read_and_reset_apf_flags);
>  =20
>  -bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
>  +noinstr bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
>   {
> - 	u32 reason =3D kvm_read_and_reset_pf_reason();
> + 	u32 reason =3D kvm_read_and_reset_apf_flags();
>  +	bool rcu_exit;
>  =20
>   	switch (reason) {
>   	case KVM_PV_REASON_PAGE_NOT_PRESENT:

This is now a conflict between the tip tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/.UNpn=_DPCExUn=LhpxjEeg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7YZfQACgkQAVBC80lX
0Gzq9QgAlC6NJO8vZwPcrH3/CnWSJ5Et+xi5g3SSqEMKPNRU/nsMELn2im+IrDLb
AxDka6/hwlD51F9QK6/U27uoH2+aWzNIKpWt+yQDv7EYNB2Ybv0v1mdlk8TZ48de
oAcHJ2N2E56tbzKrqW8aFRat35VL3J8KF2miWxH7yol1I6ufNnobOuXv8+eowDPS
q5Bcot0rOJRdl+V7PNMkJOG5mO3gCJAPsd7Eq2cw6MdVLVU2jfwhUXBOC9rlOTjB
SK1ibwauQ2lXk8um9BAW8OXMcKCVrGSUsKLjgVN3Hrg5fwkJWWKC47kNzzTQdQJ5
a05NgneI+gyg4NVOa3UzaQd0hYYNLQ==
=D75x
-----END PGP SIGNATURE-----

--Sig_/.UNpn=_DPCExUn=LhpxjEeg--
