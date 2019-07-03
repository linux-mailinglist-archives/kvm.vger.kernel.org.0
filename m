Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC9C45ED27
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 22:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfGCUEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 16:04:41 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35516 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCUEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 16:04:41 -0400
Received: by mail-qk1-f195.google.com with SMTP id r21so3576935qke.2;
        Wed, 03 Jul 2019 13:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nLV0SgYCElDGpuVWKTt1nkFCDhoVGHSVjtI/YSUZbZA=;
        b=JyGnagavsq+kKQ6HXvWgqguYiSxbAUytbFWkTz0t3dIjuZn1LF/Qozd9txVarWupmV
         q3r4Tpt6MkozMl6Re7V6B5UI71J7nupMZJylssZ2x/ZrSoVugdwPwK330DcnuSVVvj7A
         EWiXHRPWOU5gye/hqpiKwiQv97lxYbVLxlnUZG51upTRYyQSAUv6i0BkS+YW7WihYals
         4tsIM93X/L00Bam9vqlrf04sO6fqMfhoetk2m2iBwUS7JPKcLPO6+wgRpM7Xh9oPxQK/
         JBg7qi5L44U+Tma7Z/JzQkR1EbAOcOsJVpIcehixEL2qVjVW5d+VkSSM95W49+KNK73A
         XQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nLV0SgYCElDGpuVWKTt1nkFCDhoVGHSVjtI/YSUZbZA=;
        b=twQazOb+/gNcPm8jdCVYv891bL2ThdznO9kRj4NxYHeFeUOJ0+3wcdnX1knu6wDFLu
         VwDKaYyUs0/qTlJPQJfA83PtEVu9JNmR3o4qWSgy/QMPKzgjtpFo57hGWQYRFsgVRBZy
         kgFT9SZD+Q86iZ/+M3kzjb0mCy48ak3vJi3e0LqB54KBNZiwckS5Ijm6cVo21H/s6YyL
         4/5AkgPIJTq4ndUopvBwAMrW5uwEl7GW3bDoAP+GW62d2vRLyP4h/5LgQbp8oTkKePh3
         k2gR061vu5I37+Wwm6Ksp6TSAGzJoZFIIFXEEfASGpc/HkV626/crh3kNaHY9lRA4HRY
         1vFw==
X-Gm-Message-State: APjAAAUMbrB9rj3fHFzxK/5fhxSuF9Xw4Sk1SM6/pikYOkImqp2T0liK
        mhPkA6DRmgz1Dq+scB0rOlE=
X-Google-Smtp-Source: APXvYqxA1dLShpdJy5ZGDfd19ia0mtHsXt5qyHBflFWCqqOiy4wmlsjO00M8DyJv55d3Af2BmI7lAQ==
X-Received: by 2002:a37:354:: with SMTP id 81mr32690349qkd.378.1562184279714;
        Wed, 03 Jul 2019 13:04:39 -0700 (PDT)
Received: from eis-macbook.hsd1.ma.comcast.net (c-24-61-97-214.hsd1.ma.comcast.net. [24.61.97.214])
        by smtp.gmail.com with ESMTPSA id 15sm1687168qtf.2.2019.07.03.13.04.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 13:04:38 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v4 0/5] x86 instruction emulator fuzzing
From:   Sam Caccavale <samcaccavale@gmail.com>
In-Reply-To: <537c4950-8b22-c28f-c248-504f8396dd5a@redhat.com>
Date:   Wed, 3 Jul 2019 16:04:36 -0400
Cc:     Alexander Graf <graf@amazon.com>, nmanthey@amazon.de,
        wipawel@amazon.de, dwmw@amazon.co.uk, mpohlack@amazon.de,
        karahmed@amazon.de, andrew.cooper3@citrix.com, JBeulich@suse.com,
        rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, paullangton4@gmail.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <95CA4688-4658-4993-9949-5B6C10882613@gmail.com>
References: <20190628092621.17823-1-samcacc@amazon.de>
 <caaeb546-9aa1-7fd5-496d-a0ec1f759d10@amazon.com>
 <537c4950-8b22-c28f-c248-504f8396dd5a@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3273)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Jul 3, 2019, at 12:20 PM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 28/06/19 11:33, Alexander Graf wrote:
>>=20
>>=20
>> On 28.06.19 11:26, Sam Caccavale wrote:
>>> Dear all,
>>>=20
>>> This series aims to provide an entrypoint for, and fuzz KVM's x86
>>> instruction
>>> emulator from userspace.  It mirrors Xen's application of the AFL
>>> fuzzer to
>>> it's instruction emulator in the hopes of discovering =
vulnerabilities.
>>> Since this entrypoint also allows arbitrary execution of the =
emulators
>>> code
>>> from userspace, it may also be useful for testing.
>>>=20
>>> The current 4 patches build the emulator and 2 harnesses:
>>> simple-harness is
>>> an example of unit testing; afl-harness is a frontend for the AFL =
fuzzer.
>>> The fifth patch contains useful scripts for development but is not
>>> intended
>>> for usptream consumption.
>>>=20
>>> Patches
>>> =3D=3D=3D=3D=3D=3D=3D
>>>=20
>>> - 01: Builds and links afl-harness with the required kernel objects.
>>> - 02: Introduces the minimal set of emulator operations and =
supporting
>>> code
>>> to emulate simple instructions.
>>> - 03: Demonstrates simple-harness as a unit test.
>>> - 04: Adds scripts for install and building.
>>> - 05: Useful scripts for development
>>>=20
>>>=20
>>> Issues
>>> =3D=3D=3D=3D=3D=3D=3D
>>>=20
>>> Currently, fuzzing results in a large amount of FPU related crashes.=20=

>>> Xen's
>>> fuzzing efforts had this issue too.  Their (temporary?) solution was =
to
>>> disable FPU exceptions after every instruction iteration?  Some =
solution
>>> is desired for this project.
>>>=20
>>>=20
>>> Changelog
>>> =3D=3D=3D=3D=3D=3D=3D
>>>=20
>>> v1 -> v2:
>>>   - Moved -O0 to ifdef DEBUG
>>>   - Building with ASAN by default
>>>   - Removed a number of macros from emulator_ops.c and moved them as
>>>     static inline functions in emulator_ops.h
>>>   - Accidentally changed the example in simple-harness (reverted in =
v3)
>>>   - Introduced patch 4 for scripts
>>>=20
>>> v2 -> v3:
>>>   - Removed a workaround for printf smashing the stack when compiled
>>>     with -mcmodel=3Dkernel, and stopped compiling with =
-mcmodel=3Dkernel
>>>   - Added a null check for malloc's return value
>>>   - Moved more macros from emulator_ops.c into emulator_ops.h as
>>>     static inline functions
>>>   - Removed commented out code
>>>   - Moved changes to emulator_ops.h into the first patch
>>>   - Moved addition of afl-many script to the script patch
>>>   - Fixed spelling mistakes in documentation
>>>   - Reverted the simple-harness example back to the more useful
>>> original one
>>>   - Moved non-essential development scripts from patch 4 to new =
patch 5
>>>=20
>>> v3 -> v4:
>>>   - Stubbed out all unimplemented emulator_ops with a =
unimplemented_op
>>> macro
>>>   - Setting FAIL_ON_UNIMPLEMENTED_OP on compile decides whether
>>> calling these
>>>     is treated as a crash or ignored
>>>   - Moved setting up core dumps out of the default build/install =
path and
>>>     detailed this change in the README
>>>   - Added a .sh extention to afl-many
>>>   - Added an optional timeout to afl-many.sh and made =
deploy_remote.sh
>>> use it
>>>   - Building no longer creates a new .config each time and does not
>>> force any
>>>     config options
>>>   - Fixed a path bug in afl-many.sh
>>>=20
>>> Any comments/suggestions are greatly appreciated.
>>>=20
>>> Best,
>>> Sam Caccavale
>>>=20
>>> Sam Caccavale (5):
>>>    Build target for emulate.o as a userspace binary
>>>    Emulate simple x86 instructions in userspace
>>>    Demonstrating unit testing via simple-harness
>>>    Added build and install scripts
>>>    Development scripts for crash triage and deploy
>>>=20
>>>   tools/Makefile                                |   9 +
>>>   tools/fuzz/x86ie/.gitignore                   |   2 +
>>>   tools/fuzz/x86ie/Makefile                     |  54 ++
>>>   tools/fuzz/x86ie/README.md                    |  21 +
>>>   tools/fuzz/x86ie/afl-harness.c                | 151 +++++
>>>   tools/fuzz/x86ie/common.h                     |  87 +++
>>>   tools/fuzz/x86ie/emulator_ops.c               | 590 =
++++++++++++++++++
>>>   tools/fuzz/x86ie/emulator_ops.h               | 134 ++++
>>>   tools/fuzz/x86ie/scripts/afl-many.sh          |  31 +
>>>   tools/fuzz/x86ie/scripts/bin.sh               |  49 ++
>>>   tools/fuzz/x86ie/scripts/build.sh             |  34 +
>>>   tools/fuzz/x86ie/scripts/coalesce.sh          |   5 +
>>>   tools/fuzz/x86ie/scripts/deploy.sh            |   9 +
>>>   tools/fuzz/x86ie/scripts/deploy_remote.sh     |  10 +
>>>   tools/fuzz/x86ie/scripts/gen_output.sh        |  11 +
>>>   tools/fuzz/x86ie/scripts/install_afl.sh       |  15 +
>>>   .../fuzz/x86ie/scripts/install_deps_ubuntu.sh |   5 +
>>>   tools/fuzz/x86ie/scripts/rebuild.sh           |   6 +
>>>   tools/fuzz/x86ie/scripts/run.sh               |  10 +
>>>   tools/fuzz/x86ie/scripts/summarize.sh         |   9 +
>>>   tools/fuzz/x86ie/simple-harness.c             |  49 ++
>>>   tools/fuzz/x86ie/stubs.c                      |  59 ++
>>>   tools/fuzz/x86ie/stubs.h                      |  52 ++
>>=20
>> Sorry I didn't realize it before. Isn't that missing a patch to the
>> MAINTAINERS file?

It is, I will add that. =20

> Yeah, and the directory should probably be tools/fuzz/kvm_emulate so =
as
> not to puzzle people.  Also:
>=20
> - let's limit the scripts to the minimum, i.e. only the run script =
which
> should be something like
>=20
> #!/bin/bash
> # SPDX-License-Identifier: GPL-2.0+
>=20
> FUZZDIR=3D"${FUZZDIR:-$(pwd)/fuzz}"
>=20
> mkdir -p $FUZZDIR/in
> cp tools/fuzz/kvm_emulate/rand_sample.bin $FUZZDIR/in
> mkdir -p $FUZZDIR/out
>=20
> ${TIMEOUT:+TIMEOUT=3D$TIMEOUT} ${AFL_FUZZ-afl-fuzz} "$@" \
>  -i $FUZZDIR/in -o $FUZZDIR/out tools/fuzz/kvm_emulate/afl-harness @@
>=20
> where people can substitute afl-many.sh or add their own options using
> the AFL_FUZZ variable or the command line.  Likewise for screen.

Yep, both of those are sensible.  I=E2=80=99ll update with next patch.

> - the build should be just "make -C tools/fuzz/kvm_emulate" and it
> should just work.  Feel free to steal the Makefile magic from other
> tools/ directories.

Yeah, the build is a bit of a sore point.  I=E2=80=99ll reach out if I =
can=E2=80=99t get it to work.

> - finally, rand_sample.bin is missing.
>=20
> Otherwise, it looks very nice.
>=20
> Paolo

Thanks for the feedback. =20

Per the email=E2=80=99s bouncing, I=E2=80=99ve removed my @amazon.de =
email and will be using this one going forward.

- Sam

