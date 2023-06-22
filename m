Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BD173A2DA
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 16:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjFVOQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 10:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbjFVOQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 10:16:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA391BC5
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 07:16:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51D5D61874
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 14:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8073C433CD
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 14:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687443403;
        bh=JyzNFaSo1Bt3Wiikno2NJdsrKOO7j9rDRIsyAfRsIps=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=o/59RKcNpHeuwBQV5vHjLbB7eqMnTmJropo2oLojv6XGsa5zhXd+V4ONWxkwJDf6d
         yL28mwE2U+xv/q2m3th5ixl8IYoih+pBuE7FJEOo0QRwBRI22OHE1wFBlzYbAJsOAT
         Me46mCxUKlzGpe9lTIJojB4LG7Wdzmg8jSJmQNncJdDZ4QZfepAAu2t0eVYo86ZmX7
         1O1fhmobey2p9rm1HrUqqRBjs+SyVgOw4e48nBnpHkzbqMPZPwIZeyp53JOeX5EJu8
         AClqeiov9FIKFc656/xD9Ms27TtnbF9PU6xmdJBEvJw7WPZ6lFgir7QPK77FCPOo5F
         wT8Puo8AZNLZA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9A575C53BD4; Thu, 22 Jun 2023 14:16:43 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date:   Thu, 22 Jun 2023 14:16:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: patryk.piotrowski@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217558-28872-gxSj3ncRf1@https.bugzilla.kernel.org/>
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

--- Comment #6 from Patryk Piotrowski (patryk.piotrowski@intel.com) ---
Hello Fan,
Could you please try to reproduce the issue with the newest net next Kernel?
I'm asking due to reason that the issue is not present there on our setups

Thank you,
Patryk Piotrowski
Intel Technology Poland

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
