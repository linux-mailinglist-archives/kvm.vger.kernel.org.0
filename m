Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D832537B160
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 00:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhEKWLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 18:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEKWLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 18:11:13 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A238C061574
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 15:10:05 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m10-20020a170902f20ab02900ed7e32ff42so8183977plc.19
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 15:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=13xt/09p3n54kTsPIZnNmQLqQsy13uIdS7rJhB8C15Q=;
        b=pi9W/sfCZjmPScfx6I0ku6MpZrlLYMFTiAzsXMHhcv/fR/XEf+qt+YLy6+4XvpCMFA
         ru9JFmL2W2Q5Y8Et9inbzTKU1FKjyr7nadWr0wBWDpckQkNzHTaXaA5YNMLyGidbhxDY
         pSRDPe10193rG7lb8AkVaIShKbrJYDNR/F3cNnY93ltVsWPyhH4dVEBSJbN79nNKuqju
         5HU5KVAZrrbSKyPkUkR6Jzt0N7iHMb1A4zTziEHyjZRzNIA9HeuwdiJ2HTWQMC1aIljf
         mA4cZDjLjK2r33spzAe1UfAGVFGeZSJvOfKG3IINeW+RG159Xs99TcVu5aMc2JOxxKn4
         0k7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=13xt/09p3n54kTsPIZnNmQLqQsy13uIdS7rJhB8C15Q=;
        b=XBmKFn8n3ggN1zpgf/3gdHfYAyVj1i/cXlaNy32988kv3yfYuyc++Yrhhavozp9K/A
         y9Q2Rs2NNdGdBpQGB1VCD9xMhvuIdxCgsOCKCeFMwY5acxNXACDacAs+cdsQ1eJ8+gQ2
         gs5Q+gdHp3KfMHzkd3144a4vQ7+lUanu2gI+nUpO5Vx4gtIBVq8ZqWwxoSZYnaKZUhJw
         JyGVotm6vjtfZUAFgvRdxfpk29I3AfztwraKUUEjicaSaqv9v9s1Mr7JvYR7guThA5kM
         MOA38H3IhCvfC1dhZVP7Ysh7CuSZDnSQdZuzrKSOP+NLOeSxprs8RLCkCzCqYywgXtEQ
         orEA==
X-Gm-Message-State: AOAM531q9gvPJvZ65KSewAGsIy6rxhYBdlHTzTQITqdIWghVB1H8AQXD
        ot7U/3WFtiCMnYRSGxXyL2sbFNLoeICAqA==
X-Google-Smtp-Source: ABdhPJyBsk58YHK/PF5rVmpWXRhXJI7AiVbtXSxPdhecd7QZZS3o5VrxYcaziJeOl2266byaHKmvEohkY8u55g==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:aa7:96ea:0:b029:28c:e131:f0f with SMTP id
 i10-20020aa796ea0000b029028ce1310f0fmr32910200pfq.11.1620771004724; Tue, 11
 May 2021 15:10:04 -0700 (PDT)
Date:   Tue, 11 May 2021 15:09:49 -0700
Message-Id: <20210511220949.1019978-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [kvm-unit-tests PATCH] x86: Convert vmx_tests.c comments to ASCII
From:   Jim Mattson <jmattson@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some strange characters snuck into this file. Convert them to ASCII
for better readability.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 x86/vmx_tests.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 2eb5962..179a55b 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4049,13 +4049,13 @@ static void test_pi_desc_addr(u64 addr, bool ctrl)
 }
=20
 /*
- * If the =C3=A2=E2=82=AC=C5=93process posted interrupts=C3=A2=E2=82=AC VM=
-execution control is 1, the
+ * If the "process posted interrupts" VM-execution control is 1, the
  * following must be true:
  *
- *	- The =C3=A2=E2=82=AC=C5=93virtual-interrupt delivery=C3=A2=E2=82=AC VM=
-execution control is 1.
- *	- The =C3=A2=E2=82=AC=C5=93acknowledge interrupt on exit=C3=A2=E2=82=AC=
 VM-exit control is 1.
+ *	- The "virtual-interrupt delivery" VM-execution control is 1.
+ *	- The "acknowledge interrupt on exit" VM-exit control is 1.
  *	- The posted-interrupt notification vector has a value in the
- *	- range 0=C3=A2=E2=82=AC=E2=80=9C255 (bits 15:8 are all 0).
+ *	- range 0 - 255 (bits 15:8 are all 0).
  *	- Bits 5:0 of the posted-interrupt descriptor address are all 0.
  *	- The posted-interrupt descriptor address does not set any bits
  *	  beyond the processor's physical-address width.
@@ -4179,7 +4179,7 @@ static void test_apic_ctls(void)
 }
=20
 /*
- * If the =C3=A2=E2=82=AC=C5=93enable VPID=C3=A2=E2=82=AC VM-execution con=
trol is 1, the value of the
+ * If the "enable VPID" VM-execution control is 1, the value of the
  * of the VPID VM-execution control field must not be 0000H.
  * [Intel SDM]
  */
@@ -4263,7 +4263,7 @@ static void test_invalid_event_injection(void)
 	vmcs_write(ENT_INTR_ERROR, 0x00000000);
 	vmcs_write(ENT_INST_LEN, 0x00000001);
=20
-	/* The field=E2=80=99s interruption type is not set to a reserved value. =
*/
+	/* The field's interruption type is not set to a reserved value. */
 	ent_intr_info =3D ent_intr_info_base | INTR_TYPE_RESERVED | DE_VECTOR;
 	report_prefix_pushf("%s, VM-entry intr info=3D0x%x",
 			    "RESERVED interruption type invalid [-]",
@@ -4480,7 +4480,7 @@ skip_unrestricted_guest:
 	/*
 	 * If the interruption type is software interrupt, software exception,
 	 * or privileged software exception, the VM-entry instruction-length
-	 * field is in the range 0=E2=80=9315.
+	 * field is in the range 0 - 15.
 	 */
=20
 	for (cnt =3D 0; cnt < 3; cnt++) {
@@ -4686,8 +4686,8 @@ out:
  *  VM-execution control must be 0.
  *  [Intel SDM]
  *
- *  If the =E2=80=9Cvirtual NMIs=E2=80=9D VM-execution control is 0, the =
=E2=80=9CNMI-window
- *  exiting=E2=80=9D VM-execution control must be 0.
+ *  If the "virtual NMIs" VM-execution control is 0, the "NMI-window
+ *  exiting" VM-execution control must be 0.
  *  [Intel SDM]
  */
 static void test_nmi_ctrls(void)
@@ -5448,14 +5448,14 @@ static void test_vm_execution_ctls(void)
   * the VM-entry MSR-load count field is non-zero:
   *
   *    - The lower 4 bits of the VM-entry MSR-load address must be 0.
-  *      The address should not set any bits beyond the processor=C3=A2=E2=
=82=AC=E2=84=A2s
+  *      The address should not set any bits beyond the processor's
   *      physical-address width.
   *
   *    - The address of the last byte in the VM-entry MSR-load area
-  *      should not set any bits beyond the processor=C3=A2=E2=82=AC=E2=84=
=A2s physical-address
+  *      should not set any bits beyond the processor's physical-address
   *      width. The address of this last byte is VM-entry MSR-load address
   *      + (MSR count * 16) - 1. (The arithmetic used for the computation
-  *      uses more bits than the processor=C3=A2=E2=82=AC=E2=84=A2s physic=
al-address width.)
+  *      uses more bits than the processor's physical-address width.)
   *
   *
   *  [Intel SDM]
@@ -5574,14 +5574,14 @@ static void test_vm_entry_ctls(void)
  * the VM-exit MSR-store count field is non-zero:
  *
  *    - The lower 4 bits of the VM-exit MSR-store address must be 0.
- *      The address should not set any bits beyond the processor=E2=80=99s
+ *      The address should not set any bits beyond the processor's
  *      physical-address width.
  *
  *    - The address of the last byte in the VM-exit MSR-store area
- *      should not set any bits beyond the processor=E2=80=99s physical-ad=
dress
+ *      should not set any bits beyond the processor's physical-address
  *      width. The address of this last byte is VM-exit MSR-store address
  *      + (MSR count * 16) - 1. (The arithmetic used for the computation
- *      uses more bits than the processor=E2=80=99s physical-address width=
.)
+ *      uses more bits than the processor's physical-address width.)
  *
  * If IA32_VMX_BASIC[48] is read as 1, neither address should set any bits
  * in the range 63:32.
@@ -7172,7 +7172,7 @@ static void test_ctl_reg(const char *cr_name, u64 cr,=
 u64 fixed0, u64 fixed1)
  *    operation.
  * 3. On processors that support Intel 64 architecture, the CR3 field must
  *    be such that bits 63:52 and bits in the range 51:32 beyond the
- *    processor=C3=A2=E2=82=AC=E2=84=A2s physical-address width must be 0.
+ *    processor's physical-address width must be 0.
  *
  *  [Intel SDM]
  */
@@ -7940,11 +7940,11 @@ static void test_load_guest_pat(void)
 #define MSR_IA32_BNDCFGS_RSVD_MASK	0x00000ffc
=20
 /*
- * If the =C3=A2=E2=82=AC=C5=93load IA32_BNDCFGS=C3=A2=E2=82=AC VM-entry c=
ontrol is 1, the following
+ * If the "load IA32_BNDCFGS" VM-entry control is 1, the following
  * checks are performed on the field for the IA32_BNDCFGS MSR:
  *
- *   =C3=A2=E2=82=AC=E2=80=9D  Bits reserved in the IA32_BNDCFGS MSR must =
be 0.
- *   =C3=A2=E2=82=AC=E2=80=9D  The linear address in bits 63:12 must be ca=
nonical.
+ *   - Bits reserved in the IA32_BNDCFGS MSR must be 0.
+ *   - The linear address in bits 63:12 must be canonical.
  *
  *  [Intel SDM]
  */
@@ -8000,9 +8000,9 @@ do {									\
 /*
  * The following checks are done on the Selector field of the Guest Segmen=
t
  * Registers:
- *    =E2=80=94 TR. The TI flag (bit 2) must be 0.
- *    =E2=80=94 LDTR. If LDTR is usable, the TI flag (bit 2) must be 0.
- *    =E2=80=94 SS. If the guest will not be virtual-8086 and the "unrestr=
icted
+ *    - TR. The TI flag (bit 2) must be 0.
+ *    - LDTR. If LDTR is usable, the TI flag (bit 2) must be 0.
+ *    - SS. If the guest will not be virtual-8086 and the "unrestricted
  *	guest" VM-execution control is 0, the RPL (bits 1:0) must equal
  *	the RPL of the selector field for CS.
  *
--=20
2.31.1.607.g51e8a6a459-goog

