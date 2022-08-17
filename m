Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B40596D51
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 13:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbiHQLGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 07:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236234AbiHQLFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 07:05:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02AB80487
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 04:05:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1993B81C06
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 11:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FDDEC433D7
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 11:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660734350;
        bh=Qm289sdoW/u8YVsXOZimtsujaUvOuJIqjTyK13t7jWk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kmFJgaqEmfKFYn4N3iBmfpHQU6eJQHdVGiLF8+vsRcghtr9KIlAPskC0jssYP9KcB
         n/GTA8QJ511iO3/3DcgZHkedf8RotMPwFC5A5Qcpvrj5wnwL4HxETQu5bp14uLXb4l
         8SlLq/MUtPdUpUUTvp5HvVwJsYggjnuxjcP22MQmN4G0gzRJLIgTmRAKNf06Udqym8
         +eZF/0oFTmwjH3GUaoyZsDRe0zJA3lYPfOsIFNhcYbAU5db/nUlZJnZinRagLw8NSL
         k+5v/jjmDVVCFdm9tt/ZDuQ22IKVLYevPPAAvnvr8f5VnszYGu5wjYtaBo5M77Sami
         UDduqtYvucPLA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 615F8C433E6; Wed, 17 Aug 2022 11:05:50 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216364] [Kernel IBT][kvm] There was "Missing ENDBR" in kvm when
 syzkaller tests
Date:   Wed, 17 Aug 2022 11:05:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: pengfei.xu@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216364-28872-w7EOVbTkKl@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216364-28872@https.bugzilla.kernel.org/>
References: <bug-216364-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216364

--- Comment #2 from xupengfe (pengfei.xu@intel.com) ---
Peter Zijlstra <peterz@infradead.org> gave the fixed patch.
I will have a try to verify the fixed patch.

Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
