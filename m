Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BD93C61AD
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 19:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhGLRPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 13:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235525AbhGLRPV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 13:15:21 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC3CC0613E8;
        Mon, 12 Jul 2021 10:12:33 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id a2so18940934pgi.6;
        Mon, 12 Jul 2021 10:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=d/B8JhWrn+P+yWZ6A7daQWqsVya17WmZTHfEtvqYBfI=;
        b=hjTL7bTAdN4wcNkHBK9e23RjGwMSI3zDECVWUCkJjSvAfRPg27gXedUHbesheDmWbh
         Cz951EsDV6FeAp8J3fWXAskm+sH81BpBYFGgUZQ1RBRZRI1zh3Vw0R6jHsMBvZ5l0hhz
         zKazvU+1fvn+1OWHy4UanPXk9vz/2+LhUOR5KnwuAh5kfgZdhLISDqEXs67iB8s69Ywp
         zrFiOz78XMjFd8BP5N1GjxX1ITPzIL1fG09Jy2JMPos6B2w3NJKT8soFJ24B2UORGJhF
         EP7YJgCennpf5s5uP+uYm7y5BItu0jPfxW7CZZHWW/fOZsgZRIVvctzGsEtDdY7PKugY
         S9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=d/B8JhWrn+P+yWZ6A7daQWqsVya17WmZTHfEtvqYBfI=;
        b=hztIfcZfmhBTDgSp6Lk5hY7JTce04BoI+5T1T/9xwouVwIaOLC8/p2RcoMyF1By2wd
         Ezvr5O7dJOC5sZivYpWqKjre5T5eKsoZwBAYLdQAXYFcQ5v0FSmDyybX0v7lACku3CAP
         Oarm+gNpdT4rj9gVAUGWx6kWatnO9s7NpHAojns/kOye0kQz9ashBYzjgK+vLnLeQ5lA
         nGqNDGx1hH7W95nZplTAIL0AID+gy7AvhupJs20CDL3PrEzjcF9SD5z6eha4s9cdybmw
         NRxtQw8Bb9RIQfBA9gZHext9XQC71G1Ng7y6xzFV3kOdA9uU+6lBpOX9bi2O5Jw8Nglk
         fORA==
X-Gm-Message-State: AOAM533qHwXKyp+LMCw09zeuMQj5vR3HymX94Uxr8Wq+/gTBHR5dmmLb
        5UxdekRGSMhaPcvbOMVIGSI=
X-Google-Smtp-Source: ABdhPJw8dktYBLoO8NebmN3gh5UlbpP9aIxWwZiONjNtgpy7m0NOs/lG3v6o29Rd6bkdRGQNPmk+UA==
X-Received: by 2002:a63:67c5:: with SMTP id b188mr122427pgc.333.1626109952779;
        Mon, 12 Jul 2021 10:12:32 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id t2sm16281610pfg.73.2021.07.12.10.12.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Jul 2021 10:12:31 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
Message-Id: <442EEB37-C289-4CB5-8161-71A54A350FEE@gmail.com>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_DFB43D18-AF75-4226-A207-864049DAB84E";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [kvm-unit-tests RFC PATCH 1/5] lib: arm: Print test exit status
 on exit if chr-testdev is not available
Date:   Mon, 12 Jul 2021 10:12:29 -0700
In-Reply-To: <20210712170745.wz2jewomlqchmhhb@gator>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm-ppc@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, cohuck@redhat.com,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        maz@kernel.org, vivek.gautam@arm.com
To:     Andrew Jones <drjones@redhat.com>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-2-alexandru.elisei@arm.com>
 <20210712175155.7c6f8dc3@slackpad.fritz.box>
 <20210712170745.wz2jewomlqchmhhb@gator>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Apple-Mail=_DFB43D18-AF75-4226-A207-864049DAB84E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Jul 12, 2021, at 10:07 AM, Andrew Jones <drjones@redhat.com> wrote:
>=20
> On Mon, Jul 12, 2021 at 05:51:55PM +0100, Andre Przywara wrote:
>> On Fri,  2 Jul 2021 17:31:18 +0100
>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>=20
>> Hi,
>>=20
>>> The arm64 tests can be run under kvmtool, which doesn't emulate a
>>> chr-testdev device. In preparation for adding run script support for
>>> kvmtool, print the test exit status so the scripts can pick it up =
and
>>> correctly mark the test as pass or fail.
>>>=20
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>> lib/chr-testdev.h |  1 +
>>> lib/arm/io.c      | 10 +++++++++-
>>> lib/chr-testdev.c |  5 +++++
>>> 3 files changed, 15 insertions(+), 1 deletion(-)
>>>=20
>>> diff --git a/lib/chr-testdev.h b/lib/chr-testdev.h
>>> index ffd9a851aa9b..09b4b424670e 100644
>>> --- a/lib/chr-testdev.h
>>> +++ b/lib/chr-testdev.h
>>> @@ -11,4 +11,5 @@
>>>  */
>>> extern void chr_testdev_init(void);
>>> extern void chr_testdev_exit(int code);
>>> +extern bool chr_testdev_available(void);
>>> #endif
>>> diff --git a/lib/arm/io.c b/lib/arm/io.c
>>> index 343e10822263..9e62b571a91b 100644
>>> --- a/lib/arm/io.c
>>> +++ b/lib/arm/io.c
>>> @@ -125,7 +125,15 @@ extern void halt(int code);
>>>=20
>>> void exit(int code)
>>> {
>>> -	chr_testdev_exit(code);
>>> +	if (chr_testdev_available()) {
>>> +		chr_testdev_exit(code);
>>> +	} else {
>>> +		/*
>>> +		 * Print the test return code in the format used by =
chr-testdev
>>> +		 * so the runner script can parse it.
>>> +		 */
>>> +		printf("\nEXIT: STATUS=3D%d\n", ((code) << 1) | 1);
>>=20
>> It's more me being clueless here rather than a problem, but where =
does
>> this "EXIT: STATUS" line come from? In lib/chr-testdev.c I see "%dq",
>> so it this coming from QEMU (but I couldn't find it in there)?
>>=20
>> But anyways the patch looks good and matches what PPC and s390 do.
>=20
> I invented the 'EXIT: STATUS' format for PPC, which didn't/doesn't =
have an
> exit code testdev. Now that it has also been adopted by s390 I guess =
we've
> got a kvm-unit-tests standard to follow for arm :-)

I was unaware of this =E2=80=9Cstandard=E2=80=9D and I mistakenly used a =
different format
for x86, in case someone wants to fix it. [1]

[1] =
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/commit/5747945371b47c51=
cb16187a26111d06f58f06b2

--Apple-Mail=_DFB43D18-AF75-4226-A207-864049DAB84E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEESJL3osl5Ymx/w9I1HaAqSabaD1oFAmDsd/0ACgkQHaAqSaba
D1qcGg//YR7HD5To5tLeXN8Sr9qEqR48YInrt1N2wDkBtgLyixAUA6PPVBfKGPA+
pbV06doi6bj9rF1eHSF/hz2XX3KFp2Z7pmn072Rg3uNMoX857kVJtv+mcPePLsEE
eQ7AZ2ofYf/Oo/xeQI14uoeHOLz276s962h6Vz5+dwfodFSOZ5Q4S2n3BZIkdSVJ
Y1ieWWIlMrerYnIUYJ5yF4yG+PtUFhE7KHoXOhoDFKXlZJ/c/fHZiuA43DlrrSEl
0ycMcKRzdgqyLE3Kd4mvi6A8kKr0piZCABGlrgGib4duoFGyUxkjgDWUqRrnebRr
f6OR57XzMAdnic8MbqdKIvC+Z8LYbE/vOBSrKj3yvjQvXvwbIgZr5tejIutIT7jD
EIVBbqemZ5eKPN3bqIHArNB4t+eO6kroSCgeQVQ0fcg06r/5mxow2qTSt9BQ+DdG
gnSbSugOfdBCnVw6ZC16oR8uxRUcF3UTAfG1SyDAMC9IX9ZbMPpOo9vNhizdUrrV
EU4sc2WVDH5qgr5LYTEm3G+iaBJd8P6JF/qa+2V6dq0UsZTB1OPTUA95zPLRubZ2
PjfZuoxVwx9g9yPDVQaCIicO461N0o92gxfU4pYAST3tNhO1/AcELzUsphDi8eQ8
nAOl4nmKoOVkWpEsy4YQ89o5C7R4zF1lhyfIAAcEM40rZjw8AKw=
=tyb3
-----END PGP SIGNATURE-----

--Apple-Mail=_DFB43D18-AF75-4226-A207-864049DAB84E--
