Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811D5373DE8
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 16:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhEEOtE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 10:49:04 -0400
Received: from shelob.surriel.com ([96.67.55.147]:38486 "EHLO
        shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbhEEOtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 10:49:03 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 May 2021 10:49:03 EDT
Received: from imladris.surriel.com ([96.67.55.152])
        by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <riel@shelob.surriel.com>)
        id 1leIhu-0006ci-GP; Wed, 05 May 2021 10:40:58 -0400
Message-ID: <9296a6244d4aada03633ae6e8a984df372089fff.camel@surriel.com>
Subject: Re: [PATCH 1/6] delayacct: Use sched_clock()
From:   Rik van Riel <riel@surriel.com>
To:     Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, pbonzini@redhat.com,
        maz@kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        hannes@cmpxchg.org
Date:   Wed, 05 May 2021 10:40:57 -0400
In-Reply-To: <20210505111525.001031466@infradead.org>
References: <20210505105940.190490250@infradead.org>
         <20210505111525.001031466@infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-4hXqd8YByiR6kjvdagQA"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Sender: riel@shelob.surriel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-4hXqd8YByiR6kjvdagQA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-05-05 at 12:59 +0200, Peter Zijlstra wrote:
> Like all scheduler statistics, use sched_clock() based time.
>=20
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Looks like this works even on messed up systems because
the delayacct code is called from the same CPU at sleep
time and wakeup time, before a task is migrated.

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

--=-4hXqd8YByiR6kjvdagQA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAmCSrnkACgkQznnekoTE
3oO6YQgAqiTwiWVDFt9ana4e9J7G4PRzEAbmg4QYW5bmmFRzmQQ/e1kcbPmC2MQ4
o0I5b14YBTIK64k8g+xE0kp3OBQPoXdeBHGTx94WU962lKyM0RkZ9kxC3XL282DB
7K+ikkM6VZFbStDDokJJi9GQazdmqRIXHDh2cI7xxElb9MMSSacYaj8Agh9w4tVU
U8xwJEd0UNMjEbT5E/CebWAJ1p+8p0vSKLLrIpVtEz97AsnsjgAkPWQuOIsZlNhR
wEYZc8R/4k9sFzQb7xsKnkXkFdBKBEJRo8ptyTDtPTJ0kbrW4Y1RgSzNY9seg88G
pEHk+DeB8wbzIEoJ+S8pnTL27cPheg==
=5CYx
-----END PGP SIGNATURE-----

--=-4hXqd8YByiR6kjvdagQA--

