Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA6C2F8A71
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 02:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbhAPB0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 20:26:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:57304 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728207AbhAPB0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 20:26:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610760359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OgKrm1eUqKSfGn7bceu+w+8caqwlMsQwlQqrULX8q6w=;
        b=mtD+kkD8UO9uWv7cOM8yu1chHaje/GO3BvjGVG677fp3Umux44LwNyfD+g3zVSTwovTjdK
        9YrNEK2TjdZq2f9ZBknVOAXtML9B26GmiJ2yxTaYnhj3Lgbnt/f/1Pw7eTqgNIat7ruF+w
        GWmTdqa16RRza+ZFeFPOhV/sPmvuz/g=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D853EACAD;
        Sat, 16 Jan 2021 01:25:58 +0000 (UTC)
Message-ID: <0a32e141d8929f75025a0d9544a4552f2a916c5d.camel@suse.com>
Subject: Re: [PATCH] kvm: tracing: Fix unmatched kvm_entry and kvm_exit
 events
From:   Dario Faggioli <dfaggioli@suse.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lorenzo Brescia <lorenzo.brescia@edu.unito.it>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Date:   Sat, 16 Jan 2021 02:25:57 +0100
In-Reply-To: <160873470698.11652.13483635328769030605.stgit@Wayrath>
References: <160873470698.11652.13483635328769030605.stgit@Wayrath>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Qzk5xTc+W0ATjFC4asLe"
User-Agent: Evolution 3.38.3 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-Qzk5xTc+W0ATjFC4asLe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-12-23 at 14:45 +0000, Dario Faggioli wrote:
> From: Lorenzo Brescia <lorenzo.brescia@edu.unito.it>
>=20
> On VMX, if we exit and then re-enter immediately without leaving
> the vmx_vcpu_run() function, the kvm_entry event is not logged.
> That means we will see one (or more) kvm_exit, without its (their)
> corresponding kvm_entry, as shown here:
>=20
> =C2=A0CPU-1979 [002] 89.871187: kvm_entry: vcpu 1
> =C2=A0CPU-1979 [002] 89.871218: kvm_exit:=C2=A0 reason MSR_WRITE
> =C2=A0CPU-1979 [002] 89.871259: kvm_exit:=C2=A0 reason MSR_WRITE
>=20
> It also seems possible for a kvm_entry event to be logged, but then
> we leave vmx_vcpu_run() right away (if vmx->emulation_required is
> true). In this case, we will have a spurious kvm_entry event in the
> trace.
>=20
Gentle ping... :-)

Thanks and Regards

--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-Qzk5xTc+W0ATjFC4asLe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmACQKUACgkQFkJ4iaW4
c+5RKQ//a6ToUu0sWhqEUEfvtvWB92cs7qxz5G8NtccK1p/E8X28l8pTBxT7W37G
rH4hZ/0RKHFxlAxklRV4TFpNBHOQTTTCxPi2xmGachkQRbTRKrlldafgPUQH1SSO
hMkDCwYWiR97W3FnhXnTxOjWpBpDifGLRh4/y3f+2AYvNWTmRaf5FmKsitGHAq/W
MbNc6VASM+QoBIwJPaWbt/InvSOo5sX487fhbDixF1BDZR2ujVkCHvm/U+jp3fcs
8EwAxkOqQSiTmwge0fEhR6AEbTdUGqlE8Yx5jGN0gIbpRv2v5I8QfccicCPVH007
SIqlZIMEUvfMYzLZZATVg/gHeqs8p2FKgZ8YkIVmQ5rnwVhWvIyQOI4k+/LVVkYL
NeYMibnMBje9YqeRlGLMYqSRQigIhaIA0OUibldVx/HB/dIXDUK1Xg14a8Mggud8
kQ1+jfsPHV7jnngxCD7Un2S/ZIT20PsrtSSB1PLOjzszJIwZRnSOU0wtmC2lQF0l
hzcmlLRqq0md/5ZXdpJanLfG4QT/dqKmcrYYOfgOssdUH5c8b50EBVjPMwHI6rA/
vgCHLtN7k9sqfZMtC4SUTPN5QOFJJW4jbzOcAaDHaRvKcF5xv4YZKh7hcKDBGz/X
JuuTzoyaSiYV4ASf/VCgwbQlkXgoIhw4LCpzhh+x2z4zrDhXrfQ=
=L5Uz
-----END PGP SIGNATURE-----

--=-Qzk5xTc+W0ATjFC4asLe--

