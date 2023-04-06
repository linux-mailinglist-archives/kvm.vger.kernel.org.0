Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D726D94D2
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 13:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbjDFLOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 07:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbjDFLOL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 07:14:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DDBE6
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 04:14:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A73360C89
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 11:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97993C433D2
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 11:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680779649;
        bh=8PFzkut61wXrcP7yWvRX+QBG0wh2Ky5XyoAjeXv+e9o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=BZRnlPPasvm/LlEFOEy3QRe6eAmMfDjcM4aZQNHv09UDB/7gPLWKE2xY1YYZGoFTB
         /1QFnrb4mOkZLEistxppiBEg7w9rpu7N0n8ni1MaQw1IHvhFbjCXLut4Xsy/X2GzFz
         KRasY4/BSTvAJ92IbWtGrA3ifWmyKo3CIQjmUzt2TenduFNqA7Ew8ANQC01TpcK7gm
         ojSnzVK+H9Uh1wMPvhAIDgvRS8vdetSDWpjM4jVFwz4htHcWeox5bd4nRVKU1HJo+z
         O+ceUXrS38+zl3VKXFCFnm8+Bj6Xeq9TFmeflwOwoqyCyqyYKNIl91CD4I4UniCmMN
         NgrpFEuBlU7Lw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 809E6C43141; Thu,  6 Apr 2023 11:14:09 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Thu, 06 Apr 2023 11:14:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: webczat@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-217307-28872-fDlgoTTH0j@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217307-28872@https.bugzilla.kernel.org/>
References: <bug-217307-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217307

--- Comment #3 from Micha=C5=82 Zegan (webczat@outlook.com) ---
Created attachment 304093
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D304093&action=3Dedit
This is a partial kvm trace for the vm's reboot, i set it to shutdown after
reboot.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
