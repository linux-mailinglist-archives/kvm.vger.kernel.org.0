Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5A7678DC9
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 02:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjAXBz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 20:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbjAXBzZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 20:55:25 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC83A39BB0;
        Mon, 23 Jan 2023 17:55:18 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P195w0QYwz4y0b;
        Tue, 24 Jan 2023 12:55:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1674525317;
        bh=rLr8aNWpAvzsI7md2WKojTQKhRKqCAHRFhoPjyjTTPw=;
        h=Date:From:To:Cc:Subject:From;
        b=Jj/OuACAGsEArT8YAF8cG+M2Zb7PVGLixMQMfcJOyr0Hx5SjMwX/r3vdUYQPfCI4H
         rQtN7FpymKSUCjVlZ30ACAqT8AUBcT8jwAOVeCWZjIyHgKHuphmEjezAiuWposQVoj
         MumMKAsqNpYLbOlvqoAupHWVpUh5Hnt8i7q6VvF3ksnoestGlRc4GKtNqbRFFjurYF
         JUnpE5dGJIddv/pYy9acVnf2raT8RxWH+65IlKO1UjKx4Ih3Bov+2fupTgYUaiA+eL
         PYu/4RG+MOMRtQYM8ETVTOD/KDEG2uYSwvxHLUhcOgGEZol9akEejxgSwc9VZPlXnw
         maAi//282TY5A==
Date:   Tue, 24 Jan 2023 12:55:15 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: duplicate patches in the kvm-x86 tree
Message-ID: <20230124125515.7c88c9fb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/F9_+EbpUUc98WzqgCd/YGzx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/F9_+EbpUUc98WzqgCd/YGzx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The following commits are also in other tree(s?) as different
commits (but the same patches):

  0b6639e8ed87 ("KVM: s390: Move hardware setup/unsetup to init/exit")
  0c2be59e0b53 ("KVM: x86: Use KBUILD_MODNAME to specify vendor module name=
")
  1334f214d19f ("KVM: s390: Unwind kvm_arch_init() piece-by-piece() if a st=
ep fails")
  145648f3d255 ("KVM: x86: Serialize vendor module initialization (hardware=
 setup)")
  1b2d6f07a3bf ("KVM: Drop arch hardware (un)setup hooks")
  1f930fb59c72 ("KVM: x86: Do VMX/SVM support checks directly in vendor cod=
e")
  260a8c61527e ("KVM: x86: Do compatibility checks when onlining CPU")
  27c87909f037 ("KVM: arm64: Simplify the CPUHP logic")
  3f1e7970df4a ("KVM: VMX: Reset eVMCS controls in VP assist page during ha=
rdware disabling")
  474856bad921 ("KVM: PPC: Move processor compatibility check to module ini=
t")
  4e27b7e44713 ("KVM: VMX: Don't bother disabling eVMCS static key on modul=
e exit")
  546df64b3d07 ("KVM: Ensure CPU is stable during low level hardware enable=
/disable")
  6391320c531e ("KVM: VMX: Use current CPU's info to perform "disabled by B=
IOS?" checks")
  65d06a60543d ("KVM: Clean up error labels in kvm_init()")
  6705b876091e ("KVM: VMX: Shuffle support checks and hardware enabling cod=
e around")
  6c5d2dbcc71c ("KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE secti=
on")
  6e9f5ebba4c4 ("KVM: arm64: Mark kvm_arm_init() and its unique descendants=
 as __init")
  714d938385ce ("KVM: x86: Move guts of kvm_arch_init() to standalone helpe=
r")
  71875bd668c7 ("KVM: VMX: Move Hyper-V eVMCS initialization to helper")
  772bb3ffe6e0 ("KVM: Opt out of generic hardware enabling on s390 and PPC")
  784277da2097 ("KVM: Teardown VFIO ops earlier in kvm_exit()")
  79e49a0fa367 ("KVM: s390: Do s390 specific init without bouncing through =
kvm_init()")
  81566442e4bf ("KVM: Make hardware_enable_failed a local variable in the "=
enable all" path")
  8d040a03e829 ("KVM: x86: Move CPU compat checks hook to kvm_x86_ops (from=
 kvm_x86_init_ops)")
  8e868404d176 ("KVM: MIPS: Hardcode callbacks to hardware virtualization e=
xtensions")
  9316983f4605 ("KVM: Drop kvm_count_lock and instead protect kvm_usage_cou=
nt with kvm_lock")
  aa899f4725e8 ("KVM: Drop kvm_arch_{init,exit}() hooks")
  af5b59ac929b ("KVM: Remove on_each_cpu(hardware_disable_nolock) in kvm_ex=
it()")
  b23df1859468 ("KVM: MIPS: Setup VZ emulation? directly from kvm_mips_init=
()")
  b38c794ec895 ("KVM: x86: Move hardware setup/unsetup to init/exit")
  b89f7faedfa3 ("KVM: x86: Unify pr_fmt to use module name for all KVM modu=
les")
  ba3ad92110a6 ("KVM: s390: Mark __kvm_s390_init() and its descendants as _=
_init")
  c017865c7cbc ("KVM: x86: Do CPU compatibility checks in x86 code")
  c2330114638a ("KVM: VMX: Do _all_ initialization before exposing /dev/kvm=
 to userspace")
  c7e997d0e9f3 ("KVM: MIPS: Register die notifier prior to kvm_init()")
  c9d8dd2372a3 ("KVM: Register syscore (suspend/resume) ops early in kvm_in=
it()")
  cc565465bb27 ("KVM: Drop kvm_arch_check_processor_compat() hook")
  d3174cf0ec90 ("KVM: arm64: Free hypervisor allocations if vector slot ini=
t fails")
  d4739c7e93de ("KVM: SVM: Check for SVM support in CPU compatibility check=
s")
  d64252c198aa ("KVM: Register /dev/kvm as the _very_ last thing during ini=
tialization")
  d80071eb35d8 ("KVM: x86: Do timer initialization after XCR0 configuration=
")
  da8de651943a ("KVM: Allocate cpus_hardware_enabled after arch hardware se=
tup")
  da8efe2b928d ("KVM: Use a per-CPU variable to track which CPUs have enabl=
ed virtualization")
  dacd86171174 ("KVM: arm64: Do arm/arch initialization without bouncing th=
rough kvm_init()")
  de2646ea615e ("KVM: RISC-V: Do arch init directly in riscv_kvm_init()")
  dff01c0d47f9 ("KVM: Initialize IRQ FD after arch hardware setup")
  e3785ed68b99 ("KVM: arm64: Unregister perf callbacks if hypervisor finali=
zation fails")
  e9c576b0f8bc ("KVM: Disable CPU hotplug during hardware enabling/disablin=
g")
  ebb10d254041 ("KVM: VMX: Make VMCS configuration/capabilities structs rea=
d-only after init")
  ef307e18c456 ("KVM: RISC-V: Tag init functions and data with __init, __ro=
_after_init")

I guess someone has rebased one of the kvm trees and it had already been
merged into another (like the kvm or kvm-arm trees).

--=20
Cheers,
Stephen Rothwell

--Sig_/F9_+EbpUUc98WzqgCd/YGzx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPPOoMACgkQAVBC80lX
0GxUpQf+NU/z0ZA9Oe7/WLaVEij+9B2nnJLFei0CIBRediSs3TXwhBmQ6EjTkCje
TRxr+F06gRQvxsTOJp8MqfOem8wIXGymre6wqqNJJ6MkwHgg1Oxlqg9Uc+jyPvBJ
dBO/2yxCyFgjzAsYNi0L1eFSyKnbQ0QZndHT2QYOQuCl+yD4WNS1DZza1z/epfW+
O9BtcpUZDs8swqOQ1vjegqtegZca4tsxxjFExcEpVIu7uSOIa76UCjug89saARca
sfuk4bA4c+7cSXf0XAnkzTLyDv6HLwxmSvyswsVd9mT4u7vfX7EGhv8JK9mgVGNl
TdDjV8MvtOouSP8uf4aKpdr8aSC4Lw==
=QvdF
-----END PGP SIGNATURE-----

--Sig_/F9_+EbpUUc98WzqgCd/YGzx--
