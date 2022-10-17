Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517D96007F8
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 09:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiJQHoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 03:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiJQHo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 03:44:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539A562E0
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 00:44:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBA80B80FAF
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 07:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84B9BC43470
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 07:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665992662;
        bh=vLe6Q9rQwg4O1eVk99W+oBOkjLA6EbcfMjjm9O8mnZg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Uf5qR6az3ShArtULY+TFGyY1tiUIsJgVZE0PjxAUF/+EkkA47Q6+4DrFEsITTsMjk
         LNQFUhHtgdspEO7UuAGbpttnsKUDjCO5AdHaGKIGLFFUnRq2MnY0CpZc7GQevRj3Ka
         Q+NdEFqpEqrcW5TITwbFpfw1X0vrHYiy+ckUo3ISjbUlaj6ozB9kHg/Qa+9GkI4uYx
         mpPsR0YVrfb/ZS9zv81j1ylhn1Q8GMqymdzItGQtXeGrHCZbNOVSychtv8FD06TOZ0
         9yI1f/wVt9uQV+vog/ySBBvb8wviJB17W5ZMeohn/l1uU0nP72RfAocMU+dnNZ2Grx
         /FnG7Pf47uhJQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6B5D8C433E6; Mon, 17 Oct 2022 07:44:22 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216598] Assertion Failure in kvm selftest mmio_warning_test
Date:   Mon, 17 Oct 2022 07:44:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixiao.yang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_regression
Message-ID: <bug-216598-28872-2ctm3cqMPf@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216598-28872@https.bugzilla.kernel.org/>
References: <bug-216598-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216598

Yang Lixiao (lixiao.yang@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|No                          |Yes

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
