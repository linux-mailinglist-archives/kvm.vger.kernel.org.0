Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C6175B192
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 16:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjGTOst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 10:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbjGTOsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 10:48:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5157CE60
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 07:48:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7B4B61864
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 14:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45B24C433CB
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 14:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689864524;
        bh=kly4MbOqddh3u8QKXQaNlXrVGRQYX8LDjxxDS2BsRdU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=i7NrO7OYX8xu2pPLXxVqe7weROb4crjGwqbevcgymxGNdPuMvpmlME9cJ0SFuXpWK
         2E9JSRfweRfDCah8w2lB3FjFYjqcm+Bb2zI4rxnZWZRjhd8ha76ArOqQROA+jLGoDL
         NgTCKZJ+G/5tyGXS6irToFySRaLjXey2TVx5zbIrTAkdW72jHE/mVPRrpCPvsHcNdB
         ATmgrq2kOnuXGKsHlWpR84Y0YXpF12XiFWd09x8/PjX5eyTq/7HuASI8waQWjglSuw
         R/Azxj8TxB56i/6f5I46wKw4HwBMyPGBC+MJE/63uMPwGpOryIo9S/G2JY/u9wmyNX
         Xak7y5Dowchww==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 34AF6C4332E; Thu, 20 Jul 2023 14:48:44 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217688] Guest call trace during boot
Date:   Thu, 20 Jul 2023 14:48:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217688-28872-vCOZoWRX4a@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217688-28872@https.bugzilla.kernel.org/>
References: <bug-217688-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217688

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #2 from Sean Christopherson (seanjc@google.com) ---
Ya, and
ttps://lkml.kernel.org/r/CA%2BQYu4qSBdhEgFURu%2BouAf2d_JNPbZgCSUaxCLoGzMqDQ=
OLWsQ%40mail.gmail.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
