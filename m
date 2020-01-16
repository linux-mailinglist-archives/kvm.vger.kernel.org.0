Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75EC113D24C
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 03:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgAPCtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 21:49:06 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:38455 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgAPCtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 21:49:06 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47ypYS49Njz9sR0;
        Thu, 16 Jan 2020 13:49:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1579142943;
        bh=pOkguxtakW7odgcyaEbAn/6knPxLxlPQVmo68XZDtCo=;
        h=Date:From:To:Cc:Subject:From;
        b=leyAg/8DW7ay+aNLPmZjNSzU286S50440mIwwQJEyVWhqed7pedb+12yFfHF5ho2o
         +AbAov3T/Vqc0bMnVyUFDc4ohXQBOQUXFnWHWkMqT4akhDwj3WLIY6WaegZ1Cbc/uP
         KUaE1bwtaEbZLzj3ziARkZHOethZ6qM6mQdK5XpxbpRNJiuIOtuOxP7M3nnhy6Fqrj
         n60/9zxPDQwY1XtlJyzvgTuMDTVyKkt6OwGckDRfnQJKsJXOjscSoRazT4oipfAL8d
         1VJx07TQc7lNKmfP2geeWdylS+nQpL8h9RC6fusnwPMqxdRL0H/s+UiFNDVRV/xU8T
         TKaHBPkHlooZQ==
Date:   Thu, 16 Jan 2020 13:48:59 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <20200116134859.36d203de@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/NtwKBjK.BWs6ckv++FgVmkE";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/NtwKBjK.BWs6ckv++FgVmkE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/include/asm/vmx.h

between commit:

  b39033f504a7 ("KVM: VMX: Use VMX_FEATURE_* flags to define VMCS control b=
its")

from the tip tree and commits:

  9dadc2f918df ("KVM: VMX: Rename INTERRUPT_PENDING to INTERRUPT_WINDOW")
  4e2a0bc56ad1 ("KVM: VMX: Rename NMI_PENDING to NMI_WINDOW")
  5e3d394fdd9e ("KVM: VMX: Fix the spelling of CPU_BASED_USE_TSC_OFFSETTING=
")

from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/x86/include/asm/vmx.h
index 9fbba31be825,d716fe938fc0..000000000000
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@@ -22,27 -19,27 +22,27 @@@
  /*
   * Definitions of Primary Processor-Based VM-Execution Controls.
   */
- #define CPU_BASED_VIRTUAL_INTR_PENDING          VMCS_CONTROL_BIT(VIRTUAL_=
INTR_PENDING)
- #define CPU_BASED_USE_TSC_OFFSETING             VMCS_CONTROL_BIT(TSC_OFFS=
ETTING)
 -#define CPU_BASED_INTR_WINDOW_EXITING           0x00000004
 -#define CPU_BASED_USE_TSC_OFFSETTING            0x00000008
 -#define CPU_BASED_HLT_EXITING                   0x00000080
 -#define CPU_BASED_INVLPG_EXITING                0x00000200
 -#define CPU_BASED_MWAIT_EXITING                 0x00000400
 -#define CPU_BASED_RDPMC_EXITING                 0x00000800
 -#define CPU_BASED_RDTSC_EXITING                 0x00001000
 -#define CPU_BASED_CR3_LOAD_EXITING		0x00008000
 -#define CPU_BASED_CR3_STORE_EXITING		0x00010000
 -#define CPU_BASED_CR8_LOAD_EXITING              0x00080000
 -#define CPU_BASED_CR8_STORE_EXITING             0x00100000
 -#define CPU_BASED_TPR_SHADOW                    0x00200000
 -#define CPU_BASED_NMI_WINDOW_EXITING		0x00400000
 -#define CPU_BASED_MOV_DR_EXITING                0x00800000
 -#define CPU_BASED_UNCOND_IO_EXITING             0x01000000
 -#define CPU_BASED_USE_IO_BITMAPS                0x02000000
 -#define CPU_BASED_MONITOR_TRAP_FLAG             0x08000000
 -#define CPU_BASED_USE_MSR_BITMAPS               0x10000000
 -#define CPU_BASED_MONITOR_EXITING               0x20000000
 -#define CPU_BASED_PAUSE_EXITING                 0x40000000
 -#define CPU_BASED_ACTIVATE_SECONDARY_CONTROLS   0x80000000
++#define CPU_BASED_INTR_WINDOW_EXITING           VMCS_CONTROL_BIT(VIRTUAL_=
INTR_PENDING)
++#define CPU_BASED_USE_TSC_OFFSETTING            VMCS_CONTROL_BIT(TSC_OFFS=
ETTING)
 +#define CPU_BASED_HLT_EXITING                   VMCS_CONTROL_BIT(HLT_EXIT=
ING)
 +#define CPU_BASED_INVLPG_EXITING                VMCS_CONTROL_BIT(INVLPG_E=
XITING)
 +#define CPU_BASED_MWAIT_EXITING                 VMCS_CONTROL_BIT(MWAIT_EX=
ITING)
 +#define CPU_BASED_RDPMC_EXITING                 VMCS_CONTROL_BIT(RDPMC_EX=
ITING)
 +#define CPU_BASED_RDTSC_EXITING                 VMCS_CONTROL_BIT(RDTSC_EX=
ITING)
 +#define CPU_BASED_CR3_LOAD_EXITING		VMCS_CONTROL_BIT(CR3_LOAD_EXITING)
 +#define CPU_BASED_CR3_STORE_EXITING		VMCS_CONTROL_BIT(CR3_STORE_EXITING)
 +#define CPU_BASED_CR8_LOAD_EXITING              VMCS_CONTROL_BIT(CR8_LOAD=
_EXITING)
 +#define CPU_BASED_CR8_STORE_EXITING             VMCS_CONTROL_BIT(CR8_STOR=
E_EXITING)
 +#define CPU_BASED_TPR_SHADOW                    VMCS_CONTROL_BIT(VIRTUAL_=
TPR)
- #define CPU_BASED_VIRTUAL_NMI_PENDING		VMCS_CONTROL_BIT(VIRTUAL_NMI_PENDI=
NG)
++#define CPU_BASED_NMI_WINDOW_EXITING		VMCS_CONTROL_BIT(VIRTUAL_NMI_PENDIN=
G)
 +#define CPU_BASED_MOV_DR_EXITING                VMCS_CONTROL_BIT(MOV_DR_E=
XITING)
 +#define CPU_BASED_UNCOND_IO_EXITING             VMCS_CONTROL_BIT(UNCOND_I=
O_EXITING)
 +#define CPU_BASED_USE_IO_BITMAPS                VMCS_CONTROL_BIT(USE_IO_B=
ITMAPS)
 +#define CPU_BASED_MONITOR_TRAP_FLAG             VMCS_CONTROL_BIT(MONITOR_=
TRAP_FLAG)
 +#define CPU_BASED_USE_MSR_BITMAPS               VMCS_CONTROL_BIT(USE_MSR_=
BITMAPS)
 +#define CPU_BASED_MONITOR_EXITING               VMCS_CONTROL_BIT(MONITOR_=
EXITING)
 +#define CPU_BASED_PAUSE_EXITING                 VMCS_CONTROL_BIT(PAUSE_EX=
ITING)
 +#define CPU_BASED_ACTIVATE_SECONDARY_CONTROLS   VMCS_CONTROL_BIT(SEC_CONT=
ROLS)
 =20
  #define CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR	0x0401e172
 =20

--Sig_/NtwKBjK.BWs6ckv++FgVmkE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4fzxsACgkQAVBC80lX
0GxBewf/SkwUpGnobAk1as6az5NdudN61GnARdOiac3VXERb9UtgT6t7LvsvTo7z
SSHn4fPIOUMooEmsk0f22E6b4QPUYDmqUpWqUerUquQps9wtink5qvo7+Dae8fKO
g9tZucPQkjknE7Sgyojt9w0V34qEVWlFhrT+dT5m/cbsB8RHgS3Llv1QenYg3gL0
C+C3h4DiY/0WDMkQebZOIXCH7gbRz3CoJgFNwxzYjyz+z68tlurmv1YviwjIweKt
znaPCQuYk7yvBAZ3Ayit1p9wMWLkiG7j1OzlrKbIXMnY95WToXEHwhMZ7E1RkF4Y
EzgldM8Uu1rLa/8paq79OPd9xYVLfQ==
=fFyn
-----END PGP SIGNATURE-----

--Sig_/NtwKBjK.BWs6ckv++FgVmkE--
