Return-Path: <kvm+bounces-73115-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aEGWKa4Lq2k/ZgEAu9opvQ
	(envelope-from <kvm+bounces-73115-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:15:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AC110225C62
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:15:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BD0533006807
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4963426D07;
	Fri,  6 Mar 2026 17:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hc0EW6sr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE9D40FDB7;
	Fri,  6 Mar 2026 17:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817023; cv=none; b=Zw+Yq4wdKUkQC3o1QpZtbcNyYZ5M622IgoaRvF/3f+jJbbc/Az08AUc0w0BkX5QXOdHrE8oO1mOX5bppYzW3GL07KXWT5LVcfoccx1hk2qjcAXMxrB7K6MWIISaua5W+xgWReedhd0YKsd0xbOppDI7DnAEzdMB4wjM4U8miugM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817023; c=relaxed/simple;
	bh=QfA3C9hX9svrq1a6kngrY8lUw+xs7XQfPovswqDFzt0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V04BShNJG4Us4G8I4cmn+j7NQvMvHK54F/T702ewCCgS1MUtYe/6uGFVTz6J3WBJNVctYRNreb6oN2plWnOasRb/Pi0BIatY2aTlJuUySfVQL+d2Xvrsa8SmTagHDzfHgXgSe7FOKCJlOqIvcKS1ce9t3Dbhy5MuCHwLRHdptng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hc0EW6sr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE19AC19425;
	Fri,  6 Mar 2026 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817022;
	bh=QfA3C9hX9svrq1a6kngrY8lUw+xs7XQfPovswqDFzt0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=hc0EW6srRYmwa5hoe2O4Tc6N3rp6EOyon0oNfK5hpLVVlshOaZRzHDL4JYdcsPr+o
	 qSIU72ISt866rFpvT9fGvru4tBr01LdWQUXFsr2lymdwzOPEhRpC3Zi2Y8QEldaJYE
	 1CEe859wquK6vXoGykatprPfOX+oN8Y50448LnwJPsTWz8zvyixZs2F0wQTXoI0R0y
	 Aok/G/4RkrtRJ6ggTeGvtJxJOHLcSsUATR63pED7Psz/sfzIf2E+qmatuh8E6j+zJc
	 gzRsGxQRNqnyszbJ+JEbp9z5osnioURP0LkjZfbquaB3BHeVgPKFiodGaZfoFOn611
	 CxCEe5PwzunOw==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:05 +0000
Subject: [PATCH v10 13/30] KVM: arm64: Document the KVM ABI for SME
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-13-43f7683a0fb7@kernel.org>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
In-Reply-To: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-6ac23
X-Developer-Signature: v=1; a=openpgp-sha256; l=12325; i=broonie@kernel.org;
 h=from:subject:message-id; bh=QfA3C9hX9svrq1a6kngrY8lUw+xs7XQfPovswqDFzt0=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhszVXEbfri5TTJrIN++/vmtL9YwPCx9UxRR1zlxx//LlP
 xv/e2u3dDIaszAwcjHIiimyrH2WsSo9XGLr/EfzX8EMYmUCmcLAxSkAE+m5zf6btbBET1Ti/ZH8
 iwru7/UideYnKYcIxTzPE1iX63vrnJO2/bzXespSaeZ1Vg31NsfcdvnNCVkWfmM5W/vB3Mhcj7e
 n09wyXdc4/P55c2O5rmpR+dzvzBbzpzjoMl0RWGttUeu2LDT+XYuC68XAmgqJxEZ/gb/G1RNbO6
 wP5GTcN+UNUEpw0gs22374Vdbcf35cd4U6z2c/Zd1XlsjlrHDkp1Mqs32znb+G2efnF51XJhzLP
 x+n+XNG1P2dS81NtzKlrDwffop1Ce/XgwGh/cX5gbsc1DQ+xNwOPKr4oL/BmznW6HXz7HuF2yzs
 du5ymliXO9k2k3n9DBbOTqcbrz/emGP2NUl3f+HLrNs2AA==
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: AC110225C62
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73115-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[broonie@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.938];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,svcr.sm:url]
X-Rspamd-Action: no action

SME, the Scalable Matrix Extension, is an arm64 extension which adds
support for matrix operations, with core concepts patterned after SVE.

SVE introduced some complication in the ABI since it adds new vector
floating point registers with runtime configurable size, the size being
controlled by a parameter called the vector length (VL). To provide control
of this to VMMs we offer two phase configuration of SVE, SVE must first be
enabled for the vCPU with KVM_ARM_VCPU_INIT(KVM_ARM_VCPU_SVE), after which
vector length may then be configured but the configurably sized floating
point registers are inaccessible until finalized with a call to
KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE) after which the configurably sized
registers can be accessed.

SME introduces an additional independent configurable vector length
which as well as controlling the size of the new ZA register also
provides an alternative view of the configurably sized SVE registers
(known as streaming mode) with the guest able to switch between the two
modes as it pleases.  There is also a fixed sized register ZT0
introduced in SME2. As well as streaming mode the guest may enable and
disable ZA and (where SME2 is available) ZT0 dynamically independently
of streaming mode. These modes are controlled via the system register
SVCR.

We handle the configuration of the vector length for SME in a similar
manner to SVE, requiring initialization and finalization of the feature
with a pseudo register controlling the available SME vector lengths as for
SVE. Further, if the guest has both SVE and SME then finalizing one
prevents further configuration of the vector length for the other.

Where both SVE and SME are configured for the guest we present the SVE
registers to userspace as having the maximum vector length of the
currently active vector type as configured via SVCR.SM, imposing an
ordering requirement on userspace.

Userspace access to ZA and (if configured) ZT0 is only available when
SVCR.ZA is 1.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 Documentation/virt/kvm/api.rst | 124 +++++++++++++++++++++++++++++------------
 1 file changed, 89 insertions(+), 35 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6f85e1b321dd..2ed08bd03a34 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -406,7 +406,7 @@ Errors:
              instructions from device memory (arm64)
   ENOSYS     data abort outside memslots with no syndrome info and
              KVM_CAP_ARM_NISV_TO_USER not enabled (arm64)
-  EPERM      SVE feature set but not finalized (arm64)
+  EPERM      SVE or SME feature set but not finalized (arm64)
   =======    ==============================================================
 
 This ioctl is used to run a guest virtual cpu.  While there are no
@@ -2605,11 +2605,11 @@ Specifically:
 ======================= ========= ===== =======================================
 
 .. [1] These encodings are not accepted for SVE-enabled vcpus.  See
-       :ref:`KVM_ARM_VCPU_INIT`.
+       :ref:`KVM_ARM_VCPU_INIT`.  They are also not accepted when SME is
+       enabled without SVE and the vcpu is in streaming mode.
 
        The equivalent register content can be accessed via bits [127:0] of
-       the corresponding SVE Zn registers instead for vcpus that have SVE
-       enabled (see below).
+       the corresponding SVE Zn registers in these cases (see below).
 
 arm64 CCSIDR registers are demultiplexed by CSSELR value::
 
@@ -2640,24 +2640,40 @@ arm64 SVE registers have the following bit patterns::
   0x6050 0000 0015 060 <slice:5>        FFR bits[256*slice + 255 : 256*slice]
   0x6060 0000 0015 ffff                 KVM_REG_ARM64_SVE_VLS pseudo-register
 
-Access to register IDs where 2048 * slice >= 128 * max_vq will fail with
-ENOENT.  max_vq is the vcpu's maximum supported vector length in 128-bit
-quadwords: see [2]_ below.
+arm64 SME registers have the following bit patterns:
 
-These registers are only accessible on vcpus for which SVE is enabled.
+  0x6080 0000 0017 00 <n:5> <slice:5>   ZA.H[n] bits[2048*slice + 2047 : 2048*slice]
+  0x6060 0000 0017 0100                 ZT0
+  0x6060 0000 0017 fffe                 KVM_REG_ARM64_SME_VLS pseudo-register
+
+Access to Z, P, FFR or ZA register IDs where 2048 * slice >= 128 *
+max_vq will fail with ENOENT.  max_vq is the vcpu's current maximum
+supported vector length in 128-bit quadwords: see [2]_ below.
+
+Changing the value of SVCR.SM will result in the contents of
+the Z, P and FFR registers being reset to 0.  When restoring the
+values of these registers for a VM with SME support it is
+important that SVCR.SM be configured first.
+
+Access to the ZA and ZT0 registers is only available if SVCR.ZA is set
+to 1.
+
+These registers are only accessible on vcpus for which SME is enabled.
 See KVM_ARM_VCPU_INIT for details.
 
-In addition, except for KVM_REG_ARM64_SVE_VLS, these registers are not
-accessible until the vcpu's SVE configuration has been finalized
-using KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE).  See KVM_ARM_VCPU_INIT
-and KVM_ARM_VCPU_FINALIZE for more information about this procedure.
+In addition, except for KVM_REG_ARM64_SVE_VLS and
+KVM_REG_ARM64_SME_VLS, these registers are not accessible until the
+vcpu's SVE and SME configuration has been finalized using
+KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_VEC).  See KVM_ARM_VCPU_INIT and
+KVM_ARM_VCPU_FINALIZE for more information about this procedure.
 
-KVM_REG_ARM64_SVE_VLS is a pseudo-register that allows the set of vector
-lengths supported by the vcpu to be discovered and configured by
-userspace.  When transferred to or from user memory via KVM_GET_ONE_REG
-or KVM_SET_ONE_REG, the value of this register is of type
-__u64[KVM_ARM64_SVE_VLS_WORDS], and encodes the set of vector lengths as
-follows::
+KVM_REG_ARM64_SVE_VLS and KVM_REG_ARM64_SME_VLS are
+pseudo-registers that allows the set of vector lengths supported by
+the vcpu to be discovered and configured by userspace.  When
+transferred to or from user memory via KVM_GET_ONE_REG or
+KVM_SET_ONE_REG, the value of this register is of type
+__u64[KVM_ARM64_SVE_VLS_WORDS], and encodes the set of vector lengths
+as follows::
 
   __u64 vector_lengths[KVM_ARM64_SVE_VLS_WORDS];
 
@@ -2669,19 +2685,25 @@ follows::
 	/* Vector length vq * 16 bytes not supported */
 
 .. [2] The maximum value vq for which the above condition is true is
-       max_vq.  This is the maximum vector length available to the guest on
-       this vcpu, and determines which register slices are visible through
-       this ioctl interface.
+       max_vq.  This is the maximum vector length currently available to
+       the guest on this vcpu, and determines which register slices are
+       visible through this ioctl interface.
+
+       If SME is supported then the max_vq used for the Z and P registers
+       while SVCR.SM is 1 this vector length will be the maximum SME
+       vector length max_vq_sme available for the guest, otherwise it
+       will be the maximum SVE vector length max_vq_sve available.
 
 (See Documentation/arch/arm64/sve.rst for an explanation of the "vq"
 nomenclature.)
 
-KVM_REG_ARM64_SVE_VLS is only accessible after KVM_ARM_VCPU_INIT.
-KVM_ARM_VCPU_INIT initialises it to the best set of vector lengths that
-the host supports.
+KVM_REG_ARM64_SVE_VLS and KVM_REG_ARM64_SME_VLS are only accessible
+after KVM_ARM_VCPU_INIT.  KVM_ARM_VCPU_INIT initialises them to the
+best set of vector lengths that the host supports.
 
-Userspace may subsequently modify it if desired until the vcpu's SVE
-configuration is finalized using KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE).
+Userspace may subsequently modify these registers if desired until the
+vcpu's SVE and SME configuration is finalized using
+KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_VEC).
 
 Apart from simply removing all vector lengths from the host set that
 exceed some value, support for arbitrarily chosen sets of vector lengths
@@ -2689,8 +2711,8 @@ is hardware-dependent and may not be available.  Attempting to configure
 an invalid set of vector lengths via KVM_SET_ONE_REG will fail with
 EINVAL.
 
-After the vcpu's SVE configuration is finalized, further attempts to
-write this register will fail with EPERM.
+After the vcpu's SVE or SME configuration is finalized, further
+attempts to write these registers will fail with EPERM.
 
 arm64 bitmap feature firmware pseudo-registers have the following bit pattern::
 
@@ -3489,6 +3511,7 @@ The initial values are defined as:
 	- General Purpose registers, including PC and SP: set to 0
 	- FPSIMD/NEON registers: set to 0
 	- SVE registers: set to 0
+	- SME registers: set to 0
 	- System registers: Reset to their architecturally defined
 	  values as for a warm reset to EL1 (resp. SVC) or EL2 (in the
 	  case of EL2 being enabled).
@@ -3532,7 +3555,7 @@ Possible features:
 
 	- KVM_ARM_VCPU_SVE: Enables SVE for the CPU (arm64 only).
 	  Depends on KVM_CAP_ARM_SVE.
-	  Requires KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE):
+	  Requires KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_VEC):
 
 	   * After KVM_ARM_VCPU_INIT:
 
@@ -3540,7 +3563,7 @@ Possible features:
 	        initial value of this pseudo-register indicates the best set of
 	        vector lengths possible for a vcpu on this host.
 
-	   * Before KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE):
+	   * Before KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_VEC):
 
 	      - KVM_RUN and KVM_GET_REG_LIST are not available;
 
@@ -3553,11 +3576,41 @@ Possible features:
 	        KVM_SET_ONE_REG, to modify the set of vector lengths available
 	        for the vcpu.
 
-	   * After KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE):
+	   * After KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_VEC):
 
 	      - the KVM_REG_ARM64_SVE_VLS pseudo-register is immutable, and can
 	        no longer be written using KVM_SET_ONE_REG.
 
+	- KVM_ARM_VCPU_SME: Enables SME for the CPU (arm64 only).
+	  Depends on KVM_CAP_ARM_SME.
+	  Requires KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_VEC):
+
+	   * After KVM_ARM_VCPU_INIT:
+
+	      - KVM_REG_ARM64_SME_VLS may be read using KVM_GET_ONE_REG: the
+	        initial value of this pseudo-register indicates the best set of
+	        vector lengths possible for a vcpu on this host.
+
+	   * Before KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_VEC):
+
+	      - KVM_RUN and KVM_GET_REG_LIST are not available;
+
+	      - KVM_GET_ONE_REG and KVM_SET_ONE_REG cannot be used to access
+	        the scalable architectural SVE registers
+	        KVM_REG_ARM64_SVE_ZREG(), KVM_REG_ARM64_SVE_PREG() or
+	        KVM_REG_ARM64_SVE_FFR, the matrix register
+		KVM_REG_ARM64_SME_ZAHREG() or the LUT register
+		KVM_REG_ARM64_SME_ZTREG();
+
+	      - KVM_REG_ARM64_SME_VLS may optionally be written using
+	        KVM_SET_ONE_REG, to modify the set of vector lengths available
+	        for the vcpu.
+
+	   * After KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_VEC):
+
+	      - the KVM_REG_ARM64_SME_VLS pseudo-register is immutable, and can
+	        no longer be written using KVM_SET_ONE_REG.
+
 	- KVM_ARM_VCPU_HAS_EL2: Enable Nested Virtualisation support,
 	  booting the guest from EL2 instead of EL1.
 	  Depends on KVM_CAP_ARM_EL2.
@@ -5142,11 +5195,12 @@ Errors:
 
 Recognised values for feature:
 
-  =====      ===========================================
-  arm64      KVM_ARM_VCPU_SVE (requires KVM_CAP_ARM_SVE)
-  =====      ===========================================
+  =====      ==============================================================
+  arm64      KVM_ARM_VCPU_VEC (requires KVM_CAP_ARM_SVE or KVM_CAP_ARM_SME)
+  arm64      KVM_ARM_VCPU_SVE (alias for KVM_ARM_VCPU_VEC)
+  =====      ==============================================================
 
-Finalizes the configuration of the specified vcpu feature.
+Finalizes the configuration of the specified vcpu features.
 
 The vcpu must already have been initialised, enabling the affected feature, by
 means of a successful :ref:`KVM_ARM_VCPU_INIT <KVM_ARM_VCPU_INIT>` call with the

-- 
2.47.3


