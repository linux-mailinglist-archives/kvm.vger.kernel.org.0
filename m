Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C8758EE50
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 16:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbiHJO3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 10:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbiHJO3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 10:29:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651CB24BD5
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:29:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F406D6151F
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 14:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5DC29C433D6
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 14:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660141744;
        bh=uOSvgRyCcjVjHBn8MZAW7p76m1aNldmcUUkUJlfqYp4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=EqPGy/Dxmfd3TIqqiMEfHk5CVfnRcP4FINPn+C2HwV5QJ4ixWeyxDMfWyV2LxkJX6
         EHbgdzjOAEfyZrN0Rt18wV/eI2SU68XUgqkjz2cBbcniw2g3rY1ZZRF0sIvAJUPfEE
         5MUO68YaP7HU72kqE7ZzAK6xIkBJfosbZFwVkMgJWn9Y3Fe830j3WELsZXCHrZhzXE
         ajcztEQoShCpHCHJqxPSk+r5Gb2D2gNjO3TqpxMGjWpj3+tfK/8rovFqvZPiwxh0Hw
         RHlleTzSWLVY2IMnVOf+5ROQwgqm+SOJQ+zNcwz5LB4vvA5XIRmSqs8wiyf7lL52mq
         mUTuFnXWLQizA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4778AC433E9; Wed, 10 Aug 2022 14:29:04 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] Kernel panic in a Ubuntu VM running on Proxmox
Date:   Wed, 10 Aug 2022 14:29:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dgilbert@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216349-28872-Eqm5ZdyPG6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216349-28872@https.bugzilla.kernel.org/>
References: <bug-216349-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216349

Dr. David Alan Gilbert (dgilbert@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dgilbert@redhat.com

--- Comment #2 from Dr. David Alan Gilbert (dgilbert@redhat.com) ---
Are you doing live migration? And if so, between which host CPUs?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
