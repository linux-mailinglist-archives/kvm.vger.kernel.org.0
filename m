Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B755C73CB71
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 16:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbjFXOr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Jun 2023 10:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjFXOr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Jun 2023 10:47:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC49E49
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 07:47:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CFEB6097A
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 14:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8726CC433CB
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 14:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687618046;
        bh=V/ekUiZMQabzhddUfFOdEkX7Cl8cTQEfXght+6Fou0g=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hZB3QbVLa+IpaF8ne9vqeL8PKM7EGJLoj++NkEowQg35ApYbhYk673BtdsAe8gh5O
         RWQJ8dCkR3/rIdZ6qjKal8CR+N030dkjJ02kp7RSpRwQN3erK7MO/LCkH0ZF4bFzgz
         QWeA74Riu0mJXKewVIIOUjPrWILPiJHC98H7XINcFW7bEz2RtO27MWS3k/RAtL8fw7
         RgQ6wmQLcPWoSfPX/my7810z2GOVWv7TBFBbemBESdIBy0K3dy2g6y0SCPunrOTPKO
         cWYsrvv8ppBNco9FBMFLnvuA0pYv7gBE743ObDzR7MTQWCpl9veaiiY+Sy2NlNOimU
         HZTgMNlw/SODQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 68259C53BD2; Sat, 24 Jun 2023 14:47:26 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date:   Sat, 24 Jun 2023 14:47:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217558-28872-FoQhIw5BjU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217558-28872@https.bugzilla.kernel.org/>
References: <bug-217558-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217558

--- Comment #7 from Chen, Fan (farrah.chen@intel.com) ---
Hello Patryk

We can reproduce this issue on the latest commit in next branch of
https://git.kernel.org/pub/scm/virt/kvm/kvm.git, actually we struggled with
this problem for a long time, no fix found in this repo, so we bisect and f=
ound
the first commit.
Do you mean we can try the latest commit in master branch of
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git?

Thanks
Fan

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
