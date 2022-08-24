Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B9059FA0E
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 14:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbiHXMdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 08:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235520AbiHXMdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 08:33:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F365853D
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 05:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 115F8619F3
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 12:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75422C433B5
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 12:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661344410;
        bh=Uv6izELzo+kcYx83JwavDIGN983PW2b9iQAfYCJez5w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Jl9Lb6EUDGqxA1uGbyqDt3O/u2X6Gk43mv8v+50C50L6MAeqsuUCgHFa03kQYNCCM
         jBxr0jb23srogFy1iaXtz6Fp6pCSijW0KDW3R+q0BX+LJnPGJI8/FfdwpQVUnEt+8k
         Qh/RGHurUKpPgpT6nEM6egNobK0x7qcdpOAzgvPNwLEWyQGAXh3PwlkkulH3msAc55
         S3f8cSOizm9ImsWqCl+T2ksIgEgJ4vNwIoGsS44hppY+IYlTRr/hahENeFWQuT7pZg
         EX5IPf78Dpsg13MTHdUAPZYjCpPXGokLcKbKgoetbSAGGFrqUC/avz9FwHiH/3uSQd
         oMkAyMnVefC7A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5FAD9C433EA; Wed, 24 Aug 2022 12:33:30 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] Kernel panics in VMs running on an Intel N5105 on
 Proxmox
Date:   Wed, 24 Aug 2022 12:33:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216349-28872-G8UEVUlmTK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216349-28872@https.bugzilla.kernel.org/>
References: <bug-216349-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216349

--- Comment #13 from The Linux kernel's regression tracker (Thorsten Leemhu=
is) (regressions@leemhuis.info) ---
If this turns out to be a regression, please let me know

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
