Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECFE1525986
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 03:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376411AbiEMBuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 21:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiEMBuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 21:50:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE23C28ED19
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 18:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 665DBB82AF4
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 01:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09FA6C34117
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 01:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652406605;
        bh=4cftrAKlZGfk/Cb1uCBuY1PSLp+yjLQERIPnNylWuwo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZytBKylmeuvWJlC3BAgerzx5H63UmC7AEJdfSYGYFFEjxr+xIMyYz20b/pc1/ha70
         uAEi8VhWZB2VOj2B7j30WQWJyg+z/Bs6y7uqRxJSqdhWLOY6xfQzrU8smRS0gFU3w4
         uHUnIyAdHjQIiLWBK/SAEgkQEJqqpDS3tuIcHF/Y6UsKQio1SdKlTCm9e2nCxvJDBP
         T6vgYBvsPnX8VgQ9s/4GjYOWnfX2WNCevz4QBLoP9s7KUfPExsUavvBGIscWQIZVT8
         qn4jRQaDvHoOf4bSeTIbgbb1mxV2fK6aUWtfkfqrLhgRDYeFr2oHeVc3oOgG70ZaxR
         yZhqaBQy2siJA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DAEFECC13B0; Fri, 13 May 2022 01:50:04 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215964] nVMX: KVM(L0) does not perform a platform reboot when
 guest(L2) trigger a reboot event through IO-Port-0xCF9
Date:   Fri, 13 May 2022 01:50:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: yadong.qi@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215964-28872-8sB0pugoiu@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215964-28872@https.bugzilla.kernel.org/>
References: <bug-215964-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215964

--- Comment #6 from Yadong Qi (yadong.qi@intel.com) ---
We are running on top of QEMU-6.0.0, and I also checked the source code of
QEMU, the code contains the commit you mentioned. Issue link for QEMU:
https://gitlab.com/qemu-project/qemu/-/issues/1021


$ qemu-system-x86_64 --version
QEMU emulator version 6.0.0
Copyright (c) 2003-2021 Fabrice Bellard and the QEMU Project developers

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
