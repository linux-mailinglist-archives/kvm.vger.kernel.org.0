Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801F96FCB49
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 18:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjEIQ1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 12:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEIQ1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 12:27:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EB635B8
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 09:27:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE89764724
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 16:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E66F9C4339E
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 16:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683649639;
        bh=nw+3xvxn3beTCkNv3ERnXh5b8Bd71g71tT0Vx2UEIZk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=O0BInNduUv9Pb/VxzqWLL3+EOjfVwX8IotYmjgsBNW+ZZllci3VWAwPOxCslEtYpY
         Kyo6ixT3uYz2sk8brl9M/5FQPYZ4UctCpSOAdtxft4OMFobjY9W7zxcZ2J9bz0/5x5
         B9Kck1qxOwj66ZMFFCLEijYvatN9ob7rJfElmK6fBLJUJL8st10nxTOV5ZjrmG1EdE
         tuMagRx7gCqSRivykeqpVCoI2KUO/IqP9bP5N5SHYZAXx6Aa/1eq7wZQM4XUXb+OCT
         yaCTQ2lKOE+OmLlih/oUWFSn2eIKvpu7Pih7swZGqBFHASx72Uej+vXL88YmkaEDSl
         y6YVjcPwuldLw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C7144C43141; Tue,  9 May 2023 16:27:19 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217424] TSC synchronization issue in VM restore
Date:   Tue, 09 May 2023 16:27:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-217424-28872-5KNo8AAGAe@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217424-28872@https.bugzilla.kernel.org/>
References: <bug-217424-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217424

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |DUPLICATE

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---
One open issue is enough.

*** This bug has been marked as a duplicate of bug 217423 ***

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
