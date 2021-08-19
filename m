Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AAE3F2309
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 00:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235989AbhHSWW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 18:22:26 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42295 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233263AbhHSWW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 18:22:26 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GrK4W6hHqz9sWq;
        Fri, 20 Aug 2021 08:21:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629411708;
        bh=ih9GzC7aT5ldVZBLq+qhG2HopKLJfSbTSOMck1JCNc4=;
        h=Date:From:To:Cc:Subject:From;
        b=BLCAxz1x/NgM6xI2zuNlc0lG0Emf9y5k0sse979sfisGLRqlC02C30zB37glEfUf/
         2uKE2i06LbsI+CO6vXzCMs0iROspotY7st2+C70BQaq3UUfdkvwE7LISDPpZFt58CK
         EpRLRl3QpNeqTCEfylsQTTkbE5F8hDQJQJkjp2UiGz0wtYCfJvzVMP/r80W3cip5M+
         M9VJsWxFd0Qt3yOo5hroIgvrmx+QhPzdp0ODhIP4m4OXCO/zEIKBXd+fuL2a0VsrHa
         qTTtewObTHEnlAMtiRKA/hKtHN0ScRZ0nPeqjhEuXEAhGTWaSDfbVHc0wucL94mP3M
         uPOgxD1rlgzeQ==
Date:   Fri, 20 Aug 2021 08:21:47 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commits in the kvm tree
Message-ID: <20210820082147.5fcc36b8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/HvBC8pNB2hPZNoVrbDcW7qu";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/HvBC8pNB2hPZNoVrbDcW7qu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commits

  5ac66856417a ("KVM: SVM: AVIC: drop unsupported AVIC base relocation code=
")
  6b0f5cfa6207 ("KVM: SVM: call avic_vcpu_load/avic_vcpu_put when enabling/=
disabling AVIC")
  28471728a851 ("KVM: SVM: move check for kvm_vcpu_apicv_active outside of =
avic_vcpu_{put|load}")
  5f3c6f56ad99 ("KVM: SVM: avoid refreshing avic if its state didn't change=
")
  2c8c05f69ac3 ("KVM: SVM: remove svm_toggle_avic_for_irq_window")
  11d9e063e484 ("KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feat=
ure is in use")
  46cd27246e22 ("KVM: SVM: add warning for mistmatch between AVIC vcpu stat=
e and AVIC inhibition")
  626fcb4e640e ("KVM: x86: APICv: fix race in kvm_request_apicv_update on S=
VM")
  049e1cd8365e ("KVM: x86: don't disable APICv memslot when inhibited")
  6ca19df1ae70 ("KVM: x86/mmu: allow APICv memslot to be enabled but invisi=
ble")
  359a029cf50e ("KVM: x86/mmu: allow kvm_faultin_pfn to return page fault h=
andling code")
  d67c15c4ac94 ("KVM: x86/mmu: rename try_async_pf to kvm_faultin_pfn")
  b04260e0857d ("KVM: x86/mmu: bump mmu notifier count in kvm_zap_gfn_range=
")
  7b03fdb9eba6 ("KVM: x86/mmu: add comment explaining arguments to kvm_zap_=
gfn_range")
  cb3b2438457d ("KVM: x86/mmu: fix parameters to kvm_flush_remote_tlbs_with=
_address")
  175c4f82f59f ("Revert "KVM: x86/mmu: Allow zap gfn range to operate under=
 the mmu read lock"")

are missing a Signed-off-by from their committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/HvBC8pNB2hPZNoVrbDcW7qu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEe2XsACgkQAVBC80lX
0GyDPAf8DPFWV90VNumtC3XrWznuY9fRl/QsUBoGO1zv8AUehEM5siSd988TcSZl
Zs9P+dq7MR4L1xDeqrt5jUDxnc6Poj62jLgnA4KbLVnW3XDy6F/Qto7Hx69EV7Lo
Vw5Ea1ZeCXOBroi1ZYQyKO2rtUivoPO5hUuqwjfXezI+s8sypg5EZIto3DVB9+cJ
c2YHf+wPiXsk5TdoTrAciijxFx02vT8quP/potnULip+oddJnvxDphYy1O0BeqSE
QrpT2k13OBNyr1z7VRrwKecZ9mtJhZHadokoZueFns6rsgQYx38Gtcc4QgNTZENZ
7DaHQ/+PnSj+RpAFSZyT6T7akpy2iw==
=/O09
-----END PGP SIGNATURE-----

--Sig_/HvBC8pNB2hPZNoVrbDcW7qu--
