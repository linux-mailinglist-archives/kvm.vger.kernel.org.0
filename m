Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C1E147724
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 04:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbgAXDW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 22:22:58 -0500
Received: from ozlabs.org ([203.11.71.1]:47565 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730663AbgAXDW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 22:22:58 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 483kww1TGtz9sRK;
        Fri, 24 Jan 2020 14:22:56 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1579836176;
        bh=2sPGsqE5OB51eFqVwD5UDfDAdnbKLq4sXdYZAO6lYlU=;
        h=Date:From:To:Cc:Subject:From;
        b=advaNJVgsET1zfgXk/WXmthsWp+TLSSlNFQaGq2rgmozrk4BzF2vk6RKRfuoyLugk
         p6brQmhKxESP7LB6RTeu/kU8T7KL6fAB3+1Rcr0p/3j+AR7MVA3gNVtwzbVGDHr+C9
         npuGfFQphZaGyp/J5MbMajWL7xa1KvVkfyCXrsNZaVGALqkjT3CWywIAuV+UWilMZu
         G6kxKHZ9RXe03iI8GwsWHaS1rANCm3qNMgLxter9pSveWvJRwM8t9Lpl/ZtEoPm2d8
         JK7URPg2Ywk4y81WQUI3WPwEUPE0Vztuak1AczdgSw+jztQ0PfLtU06PLEKOjnTfX3
         qP0lMGBUXqXlA==
Date:   Fri, 24 Jan 2020 14:22:55 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marios Pomonis <pomonis@google.com>,
        Nick Finco <nifi@google.com>
Subject: linux-next: Fixes tags need some work in the kvm tree
Message-ID: <20200124142255.3f4f2e5e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/K29qeSQD/+L=nzkCwqce.R7";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/K29qeSQD/+L=nzkCwqce.R7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  99a88de84ef9 ("KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks=
")

Fixes tag

  Fixes: commit 25462f7f5295 ("KVM: x86/vPMU: Define kvm_pmu_ops to support=
 vPMU function dispatch")

In commit

  fdf9f340769d ("KVM: x86: Protect DR-based index computations from Spectre=
-v1/L1TF attacks")

Fixes tag

  Fixes: commit 020df0794f57 ("KVM: move DR register access handling into g=
eneric code")

In commit

  649ea1dce49d ("KVM: x86: Protect exit_reason from being used in Spectre-v=
1/L1TF attacks")

Fixes tag

  Fixes: commit 55d2375e58a6 ("KVM: nVMX: Move nested code to dedicated fil=
es")

In commit

  202276f43207 ("KVM: x86: Protect MSR-based index computations from Spectr=
e-v1/L1TF attacks in x86.c")

Fixes tag

  Fixes: commit 890ca9aefa78 ("KVM: Add MCE support")

In commit

  5135ee39a7bf ("KVM: x86: Protect MSR-based index computations in pmu.h fr=
om Spectre-v1/L1TF attacks")

Fixes tag

  Fixes: commit 25462f7f5295 ("KVM: x86/vPMU: Define kvm_pmu_ops to support=
 vPMU function dispatch")

In commit

  fa8c3fb1c109 ("KVM: x86: Protect MSR-based index computations in fixed_ms=
r_to_seg_unit() from Spectre-v1/L1TF attacks")

Fixes tag

  Fixes: commit de9aef5e1ad6 ("KVM: MTRR: introduce fixed_mtrr_segment tabl=
e")

In commit

  6c7fe168f928 ("KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1=
TF attacks")

Fixes tag

  Fixes: commit 0105d1a52640 ("KVM: x2apic interface to lapic")

In commit

  c895c1d45f4f ("KVM: x86: Protect ioapic_write_indirect() from Spectre-v1/=
L1TF attacks")

Fixes tag

  Fixes: commit 70f93dae32ac ("KVM: Use temporary variable to shorten lines=
.")

In commit

  8174f8bb6866 ("KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L=
1TF attacks")

Fixes tag

  Fixes: commit a2c118bfab8b ("KVM: Fix bounds checking in ioapic indirect =
register reads (CVE-2013-1798)")

In commit

  b685a30c564c ("KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1=
TF attacks")

Fixes tag

  Fixes: commit 85f455f7ddbe ("KVM: Add support for in-kernel PIC emulation=
")

In commit

  f54ae8da934e ("KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data() from S=
pectre-v1/L1TF attacks")

Fixes tag

  Fixes: commit e7d9513b60e8 ("kvm/x86: added hyper-v crash msrs into kvm h=
yperv context")

In commit

  f4ff5079e328 ("KVM: x86: Protect x86_decode_insn from Spectre-v1/L1TF att=
acks")

Fixes tag

  Fixes: commit 045a282ca415 ("KVM: emulator: implement fninit, fnstsw, fns=
tcw")

In all these, the leading work 'commit' is unexpected.  The fixes tag
can be gernerated using

	git log -1 --format=3D'Fixes: %h ("%s")' <fixed commit>

Also, please keep all the commit message tags together at the end of
the commit message.

--=20
Cheers,
Stephen Rothwell

--Sig_/K29qeSQD/+L=nzkCwqce.R7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4qYw8ACgkQAVBC80lX
0GzmvQgAhWaiAHRVKC89slzpaQ994R3uQ4zPG3+KPPpMYxm5eMYFcVHY31Q9zJSc
MXeT3ilBFn5y5xgbSyqz+LvQ6MsR1HZD7mVK2iS124gfLpUFtcF+X1Rs2gQEtg28
rszbiVkaFAgjuNCnLKIXNo719SQ9cA10PI46WXa+VAdDI/J9UPWd0ekX0Tgi7OKA
JPVhMIQLS+n7Nx5WfQa2ktFmdsfGDf26fDM1KheStifB1Qg59V/nRFNFFI4BjB+l
ljTtafrCCgp8yOIjlU6zOhPxdpdRbHpql1t2KDPQlq9WMoDssw6Zy3gD2SQNwY6C
/Ek+sxWRIoYnMQwzYkUeppPIgfEsUQ==
=kFkQ
-----END PGP SIGNATURE-----

--Sig_/K29qeSQD/+L=nzkCwqce.R7--
