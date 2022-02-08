Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51084ADE50
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 17:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383210AbiBHQ03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 11:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236721AbiBHQ02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 11:26:28 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4668C061576;
        Tue,  8 Feb 2022 08:26:27 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9CAFE1F387;
        Tue,  8 Feb 2022 16:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644337586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=kAqNmKM6l8koUfFIjfYay6nGji+PyjtAuRn/sApRYCg=;
        b=fkSVXB2YJoVIPvc/iVjce2eJzwZAl2gr+L4IS9q8DywrIuzbclc64q+LSiSEAKoM01NB4Z
        CEzksViqoCBOP0xcEpDNH2o17oKODrSboer5jynSGxGnN4R0mm5FzuWcxQFq8PNfwRUWLU
        NM3Dk1+Z+4wwr+s4MMvsIkjgyb1+rCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644337586;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=kAqNmKM6l8koUfFIjfYay6nGji+PyjtAuRn/sApRYCg=;
        b=L9pTqfo44Qtv7LrRqjH68lSOsvdQSpIonmhBmSCcklW0zGqXfQSlf6RHMCVyWGGmQJdFNB
        udz/yOMCSzb2v4Bg==
Received: from vasant-suse.fritz.box (unknown [10.163.24.178])
        by relay2.suse.de (Postfix) with ESMTP id 64B16A3B83;
        Tue,  8 Feb 2022 16:26:26 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     linux-kernel@vger.kernel.org
Cc:     bp@alien8.de, jroedel@suse.de, kvm@vger.kernel.org, x86@kernel.org,
        thomas.lendacky@amd.com, Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v5 0/1] x86/test: Add a test for AMD SEV-ES #VC handling
Date:   Tue,  8 Feb 2022 17:26:22 +0100
Message-Id: <20220208162623.18368-1-vkarasulli@suse.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello!

   This is the version 5 of the patch written to add a test for
   AMD SEV-ES #VC handling. This version attempts to
   address review comments to the previous version of the patch in 
   https://lore.kernel.org/kvm/YNRgHbPVGpLaByjH@zn.tnic/.
   
   Following changes have been made to address the comments: 
   1. Changed the subject to x86/test from x86.
   2. In file arch/x86/Kconfig.debug enclosed the config AMD_SEV_TEST_VC
      inside the guard X86_TESTS.
   3. Renamed the test file to sev-test-vc.c to indicate that
      file includes all the #VC handling related tests.
   4. Memory barries are apparently not necessary and have been removed.
 
Thanks,
Vasant

----------------------------------------------------------------------
 arch/x86/Kbuild              |   2 +
 arch/x86/Kconfig.debug       |  16 ++++
 arch/x86/kernel/Makefile     |   7 ++
 arch/x86/tests/Makefile      |   3 +
 arch/x86/tests/sev-test-vc.c | 154 +++++++++++++++++++++++++++++++++++
 5 files changed, 182 insertions(+)
 create mode 100644 arch/x86/tests/Makefile
 create mode 100644 arch/x86/tests/sev-test-vc.c


base-commit: dfd42facf1e4ada021b939b4e19c935dcdd55566
prerequisite-patch-id: 660950af15f9a972b1f71aa7702ebebe7dd9636b
prerequisite-patch-id: 9635b44cd178a2ee20d83acbc7a07101fd7e81a3
prerequisite-patch-id: 3a7cfa2a885ad20a9f325febcbe31ef53b41e0b1
prerequisite-patch-id: 5e48ede5d4df9de5df3d483874b4aa1711b5dcf0
prerequisite-patch-id: b66ebf185fceb6e8e98b466c974ed777f0200787
prerequisite-patch-id: d5bde21908fbada516dc757e29c6ad70926ab5bf
prerequisite-patch-id: ed38b7fc213fa66845dc25502f18b79e3dc907db
prerequisite-patch-id: 053546f9741643d742f5149c8441f8484e1918d1
prerequisite-patch-id: a20f9a6fd1ad2db0bae2550d5442d7275c481b01
prerequisite-patch-id: bde103392dd4c0a5c360446dbc8d2e5f82671575
prerequisite-patch-id: af44d5e0a6f51e1fe5cf6aef7d0be36e201663b4
prerequisite-patch-id: 952ebde20c8c084f43523f8230ced76beae08b3e
prerequisite-patch-id: 0b295c1545756626a9bca5bce8be4557742b7a56
prerequisite-patch-id: 98bf6777201eeab52938c28de1090387d454ef55
prerequisite-patch-id: d64628531375578e4bc6de3bcba1a3de658e28d8
prerequisite-patch-id: 752ea9954abeb624b803ad86e4974769f97ddd6e
-- 
2.32.0

