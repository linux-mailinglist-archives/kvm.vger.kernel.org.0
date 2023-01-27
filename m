Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FA367E64A
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 14:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbjA0NNH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 08:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234512AbjA0NM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 08:12:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7987EFFA
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 05:12:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E1ED61C36
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A5B3C4339B
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674825093;
        bh=1FM1vgN201CM28VKNEVZQeS50rhBKOt1/BAsAa15hCE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=SowhgeonKzeoTDgLOlMuWuj/si/EDTP4feGMQTFWkxgFCyPYiL7+8PZjWUDM1YFoC
         SmhcI6M0Rw42Bmz12dvGYpCh2jQahiNhE08tuC9DZFW5dbEsZmZvXlIwrhosWWQonH
         GXf/3aFwLewzGRBKh6ZEsVbKyUIMhR1i6XFxwDLiAO/Fkic2QziEJrjvOUlPZ/jrDR
         5kk1Js1CGG3W7nh+90+AUwni8kIc2O2WJf/8/NwnR9noga2ELowGTY1iCAJb3q8XIx
         TRXMf6Iv8LrJqSlZihKWd/rclknApqkepcavWivytjEt2tGMj3rjYHkD2V0bC4RpFV
         sX/nUg9Nmwm7Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DDC17C43141; Fri, 27 Jan 2023 13:11:32 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215459] VM freezes starting with kernel 5.15
Date:   Fri, 27 Jan 2023 13:11:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: devzero@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215459-28872-HhxYX8PQ3j@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215459-28872@https.bugzilla.kernel.org/>
References: <bug-215459-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D215459

Roland Kletzing (devzero@web.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |devzero@web.de

--- Comment #12 from Roland Kletzing (devzero@web.de) ---
also see https://forum.proxmox.com/threads/vm-freezes-irregularly.111494/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
