Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A903A7DBA9
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 14:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbfHAMj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 08:39:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:58096 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730881AbfHAMj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 08:39:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D26CBB00E;
        Thu,  1 Aug 2019 12:39:54 +0000 (UTC)
Message-ID: <6d9e85ac5768e920805f121eeaff1360f3b257df.camel@suse.com>
Subject: Re: [PATCH] KVM: Disable wake-affine vCPU process to mitigate lock
 holder preemption
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date:   Thu, 01 Aug 2019 14:39:34 +0200
In-Reply-To: <19e0beb6-a732-ea1f-79a5-41be92569338@redhat.com>
References: <1564479235-25074-1-git-send-email-wanpengli@tencent.com>
         <19e0beb6-a732-ea1f-79a5-41be92569338@redhat.com>
Organization: SUSE
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-OoP9rETHtqYOrghGbkKn"
User-Agent: Evolution 3.32.3 
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-OoP9rETHtqYOrghGbkKn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-07-30 at 13:46 +0200, Paolo Bonzini wrote:
> On 30/07/19 11:33, Wanpeng Li wrote:
> > When qemu/other vCPU inject virtual interrupt to guest through
> > waking up one=20
> > sleeping vCPU, it increases the probability to stack vCPUs/qemu by
> > scheduler
> > wake-affine. vCPU stacking issue can greately inceases the lock
> > synchronization=20
> > latency in a virtualized environment. This patch disables wake-
> > affine vCPU=20
> > process to mitigtate lock holder preemption.
>=20
> There is no guarantee that the vCPU remains on the thread where it's
> created, so the patch is not enough.
>=20
> If many vCPUs are stacked on the same pCPU, why doesn't the wake_cap
> kick in sooner or later?
>=20
Assuming it actually is the case that vcpus *do* get stacked *and* that
wake_cap() *doesn't* kick in, maybe it could be because of this check?

        /* Minimum capacity is close to max, no need to abort wake_affine *=
/
        if (max_cap - min_cap < max_cap >> 3)
                return 0;

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)


--=-OoP9rETHtqYOrghGbkKn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAl1C3YYACgkQFkJ4iaW4
c+7Y7w/9FDc59iIus5zhBIvPf3Lieg7DPJpO7lV5BX3b9Aom3UVTDfgniByN88hC
hk4lyNnLozzX6zv8AiPtWCWdtvXnjLewY5Z0OSsmQyCL3TdX09h8FXiqfRkcrCQX
MJj81jMD8AHXQ1tRY5p+k653LpzFRQS4uckBgSklWr2ZAdfwNQLaHA2jdUQ4oatV
SLN07+3MQaKfea1rdhGCiD4ME+sdOBZO+gwVoosWIDMYKDevuVR54ghl6lBW98pR
dj+ZSVtlqFfSUYpjtL/l3P3+hHB7292OC+uh9T9ESGR0xk/ggCl7X1H5ELUL+wDG
M4CNTsr1Z5oihfFGpZk3hZk0qLfOOPDwxbT47tv/RsEqjMRcumkCaldweG6fS9oO
DUTqauzyAlRo9Ipt29BGRj7mpzd4y4+bZpJJedoql0Yhc4VP3brJneJxWqeNylBQ
EWtowwuc9hUnewZi2VHPCbAFPIwo2YLyqFApNDMjbtO/Ar6f04BrYwANKj96aOgI
T1yvC0Q2NaeYJ27wdpRo13TI4FXLVSJhKFEL/80Iw98xyAf6ZShr/Z0RHJbBMoPm
o2pVT27JwuVcsfM+79kRrN+AJCopRVEfZFpvZ7coLeyxwQKmgcRUTDjxlklJMvly
TTR5/8tyIA4kUW9ngTGEi4i7LWrMiMP7+tDeQJyZcqkOJ+SFyig=
=fjyt
-----END PGP SIGNATURE-----

--=-OoP9rETHtqYOrghGbkKn--

