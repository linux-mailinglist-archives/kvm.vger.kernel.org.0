Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3955BBA4D
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 22:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiIQUX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Sep 2022 16:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiIQUXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Sep 2022 16:23:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FFE2A258
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 13:23:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FA08611D9
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 20:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 066F5C4347C
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 20:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663446203;
        bh=E99I61M1fVRz22cE0VG+zDtQp403elCkvvy3ci1F0yU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=HCYBt93o42YGMhDrHNDK0QiQm28+bwkgI99xzs40Qbhm6PDSvDPfeoKrpHw5xbEYS
         UQeXfBd1hDDBbi1y84gDDm4PFXn8Y9RiNZ+FEhgV6SQ9hRt8q2D9tfjIHDadvpNOxh
         3nS5hZjnJijxc1a/1rh9DMjPI13GRK0T7h0qm12xcSgM0aGNfB8ZpU18KnPFEI1mbL
         Qp9EYXI3Fd5wvX+jYjmUZN4GC6DnOvvFXS2d+aQ7Y+WrqbFdx7tlauF3hM6A7+Cf4e
         drWJognTT/By3O6/QEKf3WbPA7eAt+6aJ230Gg4Uuf+E4S/nf82+vQjXbrITElTQ8i
         DLom5XhFGttCQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E37E0C433E9; Sat, 17 Sep 2022 20:23:22 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Sat, 17 Sep 2022 20:23:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: MOVED
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216388-28872-zaTQQwPW6I@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216388-28872@https.bugzilla.kernel.org/>
References: <bug-216388-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216388

Robert Dinse (nanook@eskimo.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |MOVED

--- Comment #22 from Robert Dinse (nanook@eskimo.com) ---
Since this is happening all over not just KVM code AND since it's happening
even on machines with no KVM-QEMU guests, this ticket is targeting the wrong
code and so I'm closing it and opening up a new ticket with more current and
extensive details.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
