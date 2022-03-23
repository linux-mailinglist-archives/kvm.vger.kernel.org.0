Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58A84E4C17
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 06:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241702AbiCWFV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 01:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241242AbiCWFV1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 01:21:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D291470CD3
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 22:19:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E788615D3
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 05:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1913C340F2
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 05:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648012797;
        bh=Kx3c6GDQ4d7lJk95AXNLbWekkYdZgRy8ouHYEAO3A5M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WKQ/1WxC2JSbQGKmR1PIKHGhteOSA7uv4q9kun6GOQ/ACchyaFwJRZgIfGpDXLlU2
         DUxrwwubVaIOnK/SUUMdUNc/JMD7hzQ4h7nR/XWMkULYjxgzSUbjmhOtC0xRgYlU9p
         ViOXpUympj1c9oYYeTOftGGkz5PMH3rsU8FAr8llLl/IEMj7fD9fuvo5c3xp4b/ie+
         AN2mOYEQF2RHNGCz8/WXC1FgovFwUk7PmHr1K78az2hqllZnxwLJo+t2xueqlVyf7d
         g8kWCU0lCUHvxeCZcphx6EFXeRuRlxV9gTYeBVlzrERGtnLQvomcI8iUIDbOjrpejp
         zKxAJ50FBQr8g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id ACCA6C05FE2; Wed, 23 Mar 2022 05:19:57 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 205801] ignore_msrs =Y and report_ignored_msrs = N not working
Date:   Wed, 23 Mar 2022 05:19:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: mohdforever007@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-205801-28872-8I9UY6UBD6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205801-28872@https.bugzilla.kernel.org/>
References: <bug-205801-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D205801

mohdforever (mohdforever007@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mohdforever007@gmail.com

--- Comment #3 from mohdforever (mohdforever007@gmail.com) ---
echo 1 | sudo tee /sys/module/kvm/parameters/ignore_msrs

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
