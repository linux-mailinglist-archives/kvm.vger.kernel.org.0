Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC70368F244
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 16:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjBHPmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 10:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjBHPmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 10:42:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76249AA
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 07:42:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11FF36166E
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 15:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6AE8FC4339B
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 15:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675870957;
        bh=JE6UvJwmhClRx/epkva5chD6f3YexbEBpUdkYUU3Chs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WtmJJgHz8SIMOpFQgCapAv/jMsRjbafbd8t1PpJuJ3bnVMn+19EB5oUavEFM5B5BJ
         drNlG9vhlb3XnBsp/aFOKOgyLk61CPHmYcOopR+8bCO2ZhZuVJl+2eh4p1odWMAvzb
         wO5Qr3w+rMA8lWqvuI96198LQvgjvNQEf3KvBQvwZsAXQ0orw4I0dWJL5hk7GIuM+4
         zqWwt64quHQ/EfEDd8bHTFmmZCIZKhKUOXd39j4DwOsU8uZAkR6DFUwOTJAh5vE1/4
         gxlE4DouYQUAStdS5ntbNBfJbs5qbY5uCiWAqNmb+mbgGUsE9JuPbca1YTLC19Bo4t
         KA9l/hVZ47L6w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 511EEC43144; Wed,  8 Feb 2023 15:42:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 75331] "soft lockup CPU#0 stuck for 23s" regression on 32bit
 3.13.0+ kernels.
Date:   Wed, 08 Feb 2023 15:42:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ikalvachev@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-75331-28872-PQmYokrs3i@https.bugzilla.kernel.org/>
In-Reply-To: <bug-75331-28872@https.bugzilla.kernel.org/>
References: <bug-75331-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D75331

--- Comment #3 from Ivan Kalvachev (ikalvachev@gmail.com) ---
(In reply to Roland Kletzing from comment #2)
> this may be caused by intense IO on the host if your VM is not using virt=
io
> dataplance.

Nothing intense was running at the time.
AFAIR It could happen when both guest&host were mostly idle.

The issue was also completely gone when using 64bit kernel/Slackware and the
same 32bit guest. I don't remember if I've tried the same qemu binary.

Unfortunately, I no longer have the kernel memory image dump.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
