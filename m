Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D60C373DE9
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 16:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhEEOtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 10:49:05 -0400
Received: from shelob.surriel.com ([96.67.55.147]:38488 "EHLO
        shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbhEEOtF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 10:49:05 -0400
Received: from imladris.surriel.com ([96.67.55.152])
        by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <riel@shelob.surriel.com>)
        id 1leIgA-00064I-FN; Wed, 05 May 2021 10:39:10 -0400
Message-ID: <eb62d635e3e6408247923e90eb7a47271e72e1f8.camel@surriel.com>
Subject: Re: [PATCH 2/6] sched: Rename sched_info_{queued,dequeued}
From:   Rik van Riel <riel@surriel.com>
To:     Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, pbonzini@redhat.com,
        maz@kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        hannes@cmpxchg.org
Date:   Wed, 05 May 2021 10:39:09 -0400
In-Reply-To: <20210505111525.061402904@infradead.org>
References: <20210505105940.190490250@infradead.org>
         <20210505111525.061402904@infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-xmFicWXjWbCqR9zb6bcb"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Sender: riel@shelob.surriel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-xmFicWXjWbCqR9zb6bcb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-05-05 at 12:59 +0200, Peter Zijlstra wrote:
> For consistency, rename {queued,dequeued} to {enqueue,dequeue}.
>=20
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Ohhh nice.

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

--=-xmFicWXjWbCqR9zb6bcb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAmCSrg4ACgkQznnekoTE
3oOInggAgDct8qVUfTm3PaF4Yfb1MLm47e62yy69vk+aKoJ25rn7U3vZLxjZpTD6
4E2ok7S3vk/B+aiuKnTEO+4PikRtsq2gCD9nQfG07LdeXOpEpDxUmZBNJ7ESKwoU
lpb/ZV65ut/IoCRr98bHq+TTiHibJYEDrNwoSJQMNtIeyurXbSO/t25ha0nUBER9
aZsB7y+Ulwab520ZsTw6osNOoz7O7U2WOOy+hRAI35mO6u5eVW96IgKhHK3mlUmL
AIihADWqGLGeb864bZL2lJWLRn2Jr0bSjvZsP8E3Pto68h19nhNfhSQ06ddSiyeS
gbHq06y1bnWI7QMKb3QRDJWfyxaiYQ==
=iZNc
-----END PGP SIGNATURE-----

--=-xmFicWXjWbCqR9zb6bcb--

