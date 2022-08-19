Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D3D59953E
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 08:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346621AbiHSGNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 02:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiHSGNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 02:13:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D9B272C
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 23:13:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32F7A61635
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 06:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9543BC433D7
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 06:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660889592;
        bh=bDhEWTwLKd3SnbKUtP9JL5DZn/z7448Sj88Zr4Od8xY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AlWblbPVO4MnYU44xvXfKqm8wDsr3MCTC6pUa/2UukfZjpP2LcALUrPneyx1G8wA7
         0xTmluYEk9ecH2LmO8PFdkOZ7pZnCSZCTC1XGkxMrmu+kEK3o7HRSql1uFPhuR9loj
         ZZKDI8YCyNp+4gQVqXNR5oDSCa7YIMC6tSzqjCxn6nxqm7QL6zMtVk63SGLgeYvET5
         zWwuQbUuqOHtPKTNAh7/tXBnnP2KWKPp3EEHB/htnkXWkGtiR8Yd154ibjVP4GsWrT
         v9+DQUkLCHn7exK1ejD90UMqXjErDrjS9eDXhQ94Vh8AB9Mhp8flyp5gCH8lvbs7Cj
         4b6ZVrc5+oinQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7E622C433E9; Fri, 19 Aug 2022 06:13:12 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216364] [Kernel IBT][kvm] There was "Missing ENDBR" in kvm when
 syzkaller tests
Date:   Fri, 19 Aug 2022 06:13:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: pengfei.xu@intel.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216364-28872-m4bwCx9VXT@https.bugzilla.kernel.org/>
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

xupengfe (pengfei.xu@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
