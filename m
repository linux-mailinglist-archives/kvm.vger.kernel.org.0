Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B24E37DBFF
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 14:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731449AbfHAM5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 08:57:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:38418 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730887AbfHAM5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 08:57:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C1A5DAD17;
        Thu,  1 Aug 2019 12:57:51 +0000 (UTC)
Message-ID: <04700afaf68114b5ab329f5a5182e21578c15795.camel@suse.com>
Subject: Re: [PATCH] KVM: Disable wake-affine vCPU process to mitigate lock
 holder preemption
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date:   Thu, 01 Aug 2019 14:57:50 +0200
In-Reply-To: <1564479235-25074-1-git-send-email-wanpengli@tencent.com>
References: <1564479235-25074-1-git-send-email-wanpengli@tencent.com>
Organization: SUSE
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-vBZfl3lnf5iunDc9R2jw"
User-Agent: Evolution 3.32.3 
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-vBZfl3lnf5iunDc9R2jw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-07-30 at 17:33 +0800, Wanpeng Li wrote:
> However, in multiple VMs over-subscribe virtualization scenario, it
> increases=20
> the probability to incur vCPU stacking which means that the sibling
> vCPUs from=20
> the same VM will be stacked on one pCPU. I test three 80 vCPUs VMs
> running on=20
> one 80 pCPUs Skylake server(PLE is supported), the ebizzy score can
> increase 17%=20
> after disabling wake-affine for vCPU process.=20
>=20
Can't we achieve this by removing SD_WAKE_AFFINE from the relevant
scheduling domains? By acting on
/proc/sys/kernel/sched_domain/cpuX/domainY/flags, I mean?

Of course this will impact all tasks, not only KVM vcpus. But if the
host does KVM only anyway...

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)


--=-vBZfl3lnf5iunDc9R2jw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAl1C4c4ACgkQFkJ4iaW4
c+7UHg/+P8QYc8TBLL2Cq4O4prnodY1NuKoDBoyLlSg+nYJ19AbFovcVqlKwx9BM
laUFBLg9B5WaqEk6aoT9TSuzvsAagZYOqLBP8m1JtweVUa3anBeTYZ8qKgyP96tZ
zTUt/xjUyIJ6PWnSbhqB6umvkugVH+o5YZPWjWc1oVPxV+PwXdsSLZt3sjYIcsVJ
Gb7NAZIM7nSyoFdiwcC5D42frnVaLzNz1w70tlOJ0h4BP+SAk+7A5x32JtHTIOo6
YJETylcZwSqxDaONxOE83T8xOmCnL+zmAsKz0zlg+6gVfEjNwgZxfG3acGLxjMJR
K9garfWrSsp5WHDnx5eGXjA82ZlOdtdv34h7O9YWBvmqrpXGVogMJObbAw3PTLWz
4LPFtkS3ZMF2LuL+wpFDiZyw1Powk2yBbgNQIn6R0cESp4hgk9FxTDIddzOZnrak
GCb7Tnlx4i3onGD4oSQ4+K8b56c0isVzUL4vusXbYj0u5O+j/uv/DfS2njH3eLgX
36QXdnqgzjTPvKuWW01PIbx0dKUYPfRI4oSzXd3WdvNjUZkLvIn9HBOGQQesXfBe
FERg8UEO6TV0mvPCtdAygqreZ67yDKzEi+cjw3st1B6C9lqo4uy7dirKESoSBzC4
tJ/s9r2771rl33lkhqzJFxB9FqI0ycZUKq/rWeXJZGJGjP7DM/Y=
=/DLl
-----END PGP SIGNATURE-----

--=-vBZfl3lnf5iunDc9R2jw--

