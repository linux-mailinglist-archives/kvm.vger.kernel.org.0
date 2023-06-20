Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2A27366A1
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 10:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbjFTItc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 04:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbjFTItb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 04:49:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350ABC2
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 01:49:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B75CE61084
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 08:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D5E2C433CA
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 08:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687250969;
        bh=rnvrvjIFcfALbo+WYlx7uQ3mWjwSyDxZVJEqqTcMDXM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=d8iBXu/Kwbl6ppIf+byXPfmRXk6yb7b0o6m7TjVryfZJVUtcLKEBbWMTSbi28Oa0p
         uk0FoC6+YH6u7e+0iWJ/fg2ydNhL5ty0VI3HZir6l7NpD+w4w+bLnmvF6zU1cE8Jq/
         sTXUyHEP8fpKL8ZtRHdJkVoNbvV9KW5zTO2uur+MQO6YhvVFoHxMeSvik66r6GglM0
         yIiJu70DGMN2YPAUMHXGCsGRQF4UzTOrkyP13WxoS6dxtSkv0QlWvklBLmKWhxQHRc
         YvLi0DPTk2oE1dNAK5HrSM/2Gy+TJcdjqe8fJb8LgvtTEUuvK5ngBn7dUKSV7uwkUu
         oZ8d638x8un2w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0B77BC53BD0; Tue, 20 Jun 2023 08:49:29 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217574] kvm_intel loads only after suspend
Date:   Tue, 20 Jun 2023 08:49:28 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: chao.gao@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217574-28872-mN04YORl8q@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217574-28872@https.bugzilla.kernel.org/>
References: <bug-217574-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217574

Chao Gao (chao.gao@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |chao.gao@intel.com

--- Comment #1 from Chao Gao (chao.gao@intel.com) ---
Could you check if each MSR indexed from 0x480 to 0x492 is consistent across
all CPUs?


To read an MSR (e.g., 0x480) on all CPUs, run
$ sudo rdmsr -a 0x480


Please do the check after bootup and suspension.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
