Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AFB6CC944
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 19:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjC1RbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 13:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC1RbX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 13:31:23 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2399935B3
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:31:22 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id l12so13022499wrm.10
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680024680;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uAtXz3+z83jZ4XKxVvQOajUrR6GL+K0tj/4mml7wKes=;
        b=PMct70HWgBQSS8kPLkhk431pJ6oAQfReDZqw80n9NAlZF7OUqS5mrRxS0GnwL+u9Ar
         yDm2iJXKJF3/7z+HcT7TQsAsNczStWGo3hvm1ChBjCqp3NGIn/4RneXXD80OM5s5C+Ij
         KuG0UK0Kqj3vZNKjkQ0wGN8/G+itFD52lISzJEaEu/oXp80gR5r0nX5ft8YMmLaLo2LH
         dgnI1V0N/WmmnQCX0nroDrWTi2Uc6eaohp+eFkrm/d1sctxsfxoo0kUPqdPWuHyM+yzk
         5az0v9Lq78P/+QQuLr3b1ob1Dk6TugtlfBANBoKzIEvbd2213SUWsAaIC4njYEw1OxqQ
         zqFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680024680;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uAtXz3+z83jZ4XKxVvQOajUrR6GL+K0tj/4mml7wKes=;
        b=hS9b8fc7Q+Cm0JfHu0ASDM4aYrX8mVirfa2CIP5QZshJ5Upbe8pMq2w3LMi9kK/42L
         m80OamM2vSByEHAGwBrJlHHPtMEhFUIIPJ+xRcZoz8y3u9ONy/KsIVEfsXuZSUdHaSvy
         9LbXTEyGJla0gR2XFgRqMc26QvQa+upRzpxlqQMBR97j8kIU47AkWNSvyHPGTJSVR4pe
         1Z9WyojEP7gWCXmk42BhWpw1hgZ8EsWP/JD+4doXtncfMtX+8k4j0rKS5pqEgdxYhkLK
         DIHCLWBhZEXiTek/SDEfp/rTC8eQej5ra1t1dqWfA2MW/HkZb21pNXEkjRqjK5gX9jEV
         TeNg==
X-Gm-Message-State: AAQBX9c1C8QQrKfwD45oEd2FVxmMak29wyfFtbsgxGGxr8NhF+9gKDE5
        4+B8CV6Xvj6H51dpvACrigIDy7lFKl7Zx1nOT/0=
X-Google-Smtp-Source: AKy350Y0vKkd2d/Lw5hqDKOcKFrPz7QPtN81Whiu4WPgwDE9O5P8ogWhZfwvQ+iyCoJtHQ3Cm+wnZQ==
X-Received: by 2002:a5d:4848:0:b0:2ce:a9e9:490b with SMTP id n8-20020a5d4848000000b002cea9e9490bmr12156949wrs.31.1680024680638;
        Tue, 28 Mar 2023 10:31:20 -0700 (PDT)
Received: from localhost.localdomain ([176.187.210.212])
        by smtp.gmail.com with ESMTPSA id z8-20020adfec88000000b002c5691f13eesm28014319wrn.50.2023.03.28.10.31.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Mar 2023 10:31:20 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org, Yanan Wang <wangyanan55@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Fabiano Rosas <farosas@suse.de>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, qemu-arm@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH-for-8.0 v2 0/3] softmmu: Restore use of CPU watchpoint for non-TCG accelerators
Date:   Tue, 28 Mar 2023 19:31:14 +0200
Message-Id: <20230328173117.15226-1-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 2609ec2868 ("softmmu: Extract watchpoint API from physmem.c")
restricted CPU watchpoints to TCG accelerator. This is wrong, as
other accelerators such KVM do use watchpoints. Revert (partially)
this commit.

Since v1:
- Include "hw/core/tcg-cpu-ops.h" where cpu_check_watchpoint()
  and cpu_watchpoint_address_matches() are called.

Philippe Mathieu-Daudé (3):
  softmmu: Restrict cpu_check_watchpoint / address_matches to TCG accel
  softmmu/watchpoint: Add missing 'qemu/error-report.h' include
  softmmu: Restore use of CPU watchpoint for all accelerators

 include/hw/core/cpu.h         | 39 +------------------------------
 include/hw/core/tcg-cpu-ops.h | 43 +++++++++++++++++++++++++++++++++++
 softmmu/watchpoint.c          |  5 ++++
 target/arm/tcg/mte_helper.c   |  1 +
 target/arm/tcg/sve_helper.c   |  1 +
 target/s390x/tcg/mem_helper.c |  1 +
 softmmu/meson.build           |  2 +-
 7 files changed, 53 insertions(+), 39 deletions(-)

-- 
2.38.1

