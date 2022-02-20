Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1984BD258
	for <lists+kvm@lfdr.de>; Sun, 20 Feb 2022 23:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243884AbiBTWnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 17:43:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbiBTWnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 17:43:00 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C855FD0C
        for <kvm@vger.kernel.org>; Sun, 20 Feb 2022 14:42:37 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id i21so7087840pfd.13
        for <kvm@vger.kernel.org>; Sun, 20 Feb 2022 14:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qR93sKQxIDc8X+WQelnnOUcjcy+2cWr8/Do473rSTLs=;
        b=gl4NiHwR3MxcpRho2xj8JAxTi6UMxa8meRfPTwLTEO7j7clSJwVEBgex4NIbKzBviR
         2Aa4faBDfeuaqE7W85J/EskOkcxDRnjRklIGHfQ4oWRzoisU40eoc818/uGHbPaWxnH6
         seMltOoKfaGVX0uR0is0DhIY/howAZ4w+e224dxu5Dcog6COthKHjrcWpb9APDgSfycy
         C31YAnRkafP/R7PG25z+JzvfzBGZrh+kggLaDkbEfb+0ZBWZqzKqr9llwp8JFuYCBHoV
         zaqdPoRSXSSPDJ1lqm0VzJnD1S06CJ/TzNi4FObgv701lUUHbH3mBZrTc+kLx5Ge9ym5
         TXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qR93sKQxIDc8X+WQelnnOUcjcy+2cWr8/Do473rSTLs=;
        b=ecll70TsjQF+3D/DACbgTtadtk3IXbB5i3Pg+CJZ5qMGNJ9Ee3dkyP2tES14j6QWY+
         y20fm/en/dl7aZIzVgrgTAn11vZTNEdofaghrzESYdlazId375FLP1JuZpiQNOkxfAOy
         uZAsOA+BceQXQ46Y0A8aFzLv2jq4vL+XiE3j7SAtTLyHHFFt4jy7MJOXikVt5zI4oC6T
         ChE4hUjCuVjU4J/T3JXjNOshkPk248Lm1tCCky9rXumdDTK7vXsOZkt2GOExOY7DuQkF
         rnwm+1iN6hCLPRu8GqyPAlyfg6Kj35FIOMRSgf9VRFGmv+DNgzJBvS7965Rk2Ti+A4Yj
         45oA==
X-Gm-Message-State: AOAM5324CLFpc5/j0PiniPjwDzGEqp0HlnWoirm647oqITOlU1RUD2RO
        oIaMfSpAL2t1y1gzpkv330jgR0fjoDQ=
X-Google-Smtp-Source: ABdhPJxJu7ybHk2mr9h+qv4ersO69NVvsQp0UFFVFF8317yDQinIy6qVafRUyzMNSBtnqfNNqQ55Xg==
X-Received: by 2002:a05:6a00:244f:b0:4df:82ad:447 with SMTP id d15-20020a056a00244f00b004df82ad0447mr17233636pfj.49.1645396956573;
        Sun, 20 Feb 2022 14:42:36 -0800 (PST)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id gk17sm605629pjb.15.2022.02.20.14.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 14:42:36 -0800 (PST)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v1 0/3] x86 UEFI: pass envs and args
Date:   Sun, 20 Feb 2022 14:42:31 -0800
Message-Id: <20220220224234.422499-1-zxwang42@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

This patch series enables kvm-unit-tests to get envs and args under
UEFI. The host passes envs and args through files:

1. The host stores envs into ENVS.TXT and args into ARGS.TXT
2. The guest boots up and reads data from these files through UEFI file
operation services
3. The file data is passed to corresponding setup functions

As a result, several x86 test cases (e.g., kvmclock_test and vmexit)
can now get envs/args from the host [1], thus do not report FAIL when
running ./run-tests.sh.

An alternative approach for envs/args passing under UEFI is to use
QEMU's -append/-initrd options. However, this approach requires EFI
binaries to be passed through QEMU's -kernel option. While currently,
EFI binaries are loaded from a disk image. Changing this bootup process
may make kvm-unit-tests (under UEFI) unable to run on bare-metal [2].
On the other hand, passing envs/args through files should work on
bare-metal because UEFI's file operation services do not rely on QEMU's
functionalities, thus working on bare-metal.

The summary of this patch series:

Patch #1 pulls Linux kernel's UEFI definitions for file operations.

Patch #2 implements file read functions and envs setup functions.

Patch #3 implements the args setup functions.

Best regards,
Zixuan

[1] https://github.com/TheNetAdmin/KVM-Unit-Tests-dev-fork/issues/8
[2] https://lore.kernel.org/kvm/CAEDJ5ZQLm1rz+0a7MPPz3wMAoeTq2oH9z92sd0ZhCxEjWMkOpg@mail.gmail.com

Zixuan Wang (3):
  x86 UEFI: pull UEFI definitions for file operations
  x86 UEFI: read envs from file
  x86 UEFI: read args from file

 lib/efi.c       | 150 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/linux/efi.h |  82 +++++++++++++++++++++++++-
 x86/efi/run     |  36 +++++++++++-
 3 files changed, 265 insertions(+), 3 deletions(-)

-- 
2.35.1

