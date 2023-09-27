Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86027B02A9
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 13:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbjI0LVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 07:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbjI0LVh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 07:21:37 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03408191
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 04:21:36 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59f2c7a4f24so199282837b3.0
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 04:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695813695; x=1696418495; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zaD4WiIBOhns66HLlNwPhIZILzh+g8xFeb6udRP8GRo=;
        b=ZSmV1aZGF7f48SiLNLsu8rpLtaOFYUi9aa5B+dBSoKFOblsOkIC+CKHHMIxb+W+g0g
         OYPVlCQQxMTpj2BAp4UIa2eQK6zr/iAW8m2F2eCX3PMvueqNCKxIQzzOfNl3DHjOzwt/
         zinlW6VDJJ6cqI9rzl8xLODjFqjodsFn0+1C4vAPKvJv3YsedP7TqtUdvJlL2bDxwOoV
         BnQX4lhKXqj/BaZgyIy49yOmuBWUVFBVC51hyURfhQuNIMHT50/8VSH6qC6HJuQGkl3H
         oAkpHYGbRRmhAjVK2Sh8NgZoZMmnXrO8kbZ5B9r3T35eR1Ogq8SmIJCkmccpI5fMhS1x
         ge/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695813695; x=1696418495;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zaD4WiIBOhns66HLlNwPhIZILzh+g8xFeb6udRP8GRo=;
        b=rgGTvZmeszKmB/25mKt3oGOQEIH3Fzq3azp6J7F0Z+wMkbtDhPnsbNHMiNxHOg1FbR
         nri0PeBKye6ToigUan/wH50Q1jWZ27xddsl+coKDbnx+/Mm1OuhdxVfIm9BagmlwV80V
         0IM7j+Cqww0MrHMi2sNObkGFfEgdtxje0hzhJqmSXrPQ4O6XhDz4cTphqFntMUVHvOwy
         OantYpJb/vyRlcqe9ElG4Ik4k2zJpW8+7v4GK024XKudh8pMZ4JAFLdRo4KRcR/E6BFI
         JK/Jj/d4beV9v/Y0v6OrDNUai+vesZyx6vpNIODy2GP/myCks6Ws8ISzN9pi2bLDD8qV
         JFDQ==
X-Gm-Message-State: AOJu0Yw0guhj8szwUNfNZQ97/hhMUi5RotzG6rJsukbdI1zsrY1CtYJN
        I5hRBRAecF2ufL2qNOQO+05WBKBLW5zMNCnfqRi3pxRGf9KJhFXeSqo9Z+Ep9zUF04U7s+wkM9T
        CirJ7k+4iUnAlqFt7+Kjj0zkm/ydhAECeO8DC1w/1uYCfJWH3vNK2FkqN6BY+GV4=
X-Google-Smtp-Source: AGHT+IH4R5000DRW0iO1yXRsb2eZnwJXxpAoH9diMo4eH9K3FpA1yqQ1gDuJFi3sn2uDqit5UWP1o8zMr7DHlQ==
X-Received: from mostafa.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:333c])
 (user=smostafa job=sendgmr) by 2002:a81:450f:0:b0:59b:c6bb:bab9 with SMTP id
 s15-20020a81450f000000b0059bc6bbbab9mr27676ywa.3.1695813695058; Wed, 27 Sep
 2023 04:21:35 -0700 (PDT)
Date:   Wed, 27 Sep 2023 11:21:17 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230927112117.3935537-1-smostafa@google.com>
Subject: [PATCH kvmtool] arm: Initialize target in kvm_cpu__arch_init
From:   Mostafa Saleh <smostafa@google.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After updating my toolchain to:
aarch64-linux-gnu-gcc (Debian 13.2.0-2) 13.2.0

I hit compilation error:
arm/kvm-cpu.c: In function =E2=80=98kvm_cpu__arch_init=E2=80=99:
arm/kvm-cpu.c:119:41: error: =E2=80=98target=E2=80=99 may be used uninitial=
ized [-Werror=3Dmaybe-uninitialized]
  119 |         vcpu->cpu_compatible    =3D target->compatible;
      |                                   ~~~~~~^~~~~~~~~~~~
arm/kvm-cpu.c:40:32: note: =E2=80=98target=E2=80=99 was declared here
   40 |         struct kvm_arm_target *target;
      |                                ^~~~~~

target is guaranteed to be initialized, as targets would be registered
from other compilation units (arm/aarch(32|64)/arm-cpu.c).

Initializing the variable to NULL is sufficient to silence the compiler.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arm/kvm-cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 98bc5fd..57f92ee 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -37,7 +37,7 @@ int kvm_cpu__register_kvm_arm_target(struct kvm_arm_targe=
t *target)
=20
 struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 {
-	struct kvm_arm_target *target;
+	struct kvm_arm_target *target =3D NULL;
 	struct kvm_cpu *vcpu;
 	int coalesced_offset, mmap_size, err =3D -1;
 	unsigned int i;
--=20
2.42.0.582.g8ccd20d70d-goog

