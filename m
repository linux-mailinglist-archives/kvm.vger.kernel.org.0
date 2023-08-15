Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37C177D162
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 19:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238973AbjHORxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 13:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbjHORxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 13:53:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF80293
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 10:53:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC0EC625F8
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 17:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 486D2C433C9
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 17:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692121984;
        bh=jDNTi4q0rIB5/8n+VdKmEtkpEYx/ZrxLujosSIO3DZc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IM1+0wrQ43tamfCnwHN92xp4HFYSB3pooxhxE9g0QeSnjs12VV+3EVyk5+MsU7MoW
         wVvDdMjD7pxlCTIcBxGdh1RPX7ZmqR+jWXPOVGPuNsudf92hm4iy447tza6m5XUvEJ
         g+XK6Nr39fWEOWKVXa0uKeTCWEmJTMHzTRNkHD2RqDFwc5OVk4DxwjRLOC6vAcZ9Q7
         IzjsICokxU+FjBrz8K2cOUc9X1baW7lKiMagMMmCf3y2a7B91bWwyVADbSDSILcKyr
         0yBo5J8ycw3mS6p70i1/xTb4ITfPuCYIdsKxLma+lPjI6LclxLwrWpGi7sV3vbMHFc
         /Mc/e/km30oSA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2A1B3C53BD3; Tue, 15 Aug 2023 17:53:04 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217796] latest Zen Inception fixes breaks nested kvm
 virtualization on AMD
Date:   Tue, 15 Aug 2023 17:53:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: sonst+kernel@o-oberst.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217796-28872-jhwONZyvXD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217796-28872@https.bugzilla.kernel.org/>
References: <bug-217796-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217796

--- Comment #1 from sonst+kernel@o-oberst.de ---
Note, adding spec_rstack_overflow=3Doff as a kernel command line makes nest=
ed VM
boot properly again without problems:
https://bugs.archlinux.org/task/79384

So, spec_rstack_overflow=3Dsafe-ret is breaking nested KVM virtualization.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
