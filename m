Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589355383E5
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 17:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241526AbiE3PEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 11:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237077AbiE3PDs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 11:03:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB1E188E8F
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 07:05:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD5F06114F
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 14:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 156FDC3411C
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 14:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653919529;
        bh=9rFviF0V6RXJaLqk+W+aMfmcGIbDcNayJ2oJl87tMTY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ga+gknr49Dvgk3OxtnkcYL4TSV5e/AiECix56kF+zRoblFz+mbOSzYS1y98JZbqyg
         apGhuAEF/BL5dbtyzFQ6qrZ8zZawFYc2+ZT52/IbN0HPGT3qPVauhdP6FzJ8xy+GL8
         TXtRQap03TjbyPsXHD6ObzTsgmXA/7c3oACqLlBSKZoi2dF+9arnIqIb/97qgXeQRa
         PCJ4b5fKKWzcQQGLcidfCgwydlq/6e+9U5FjmLojoHiU/8NxM2ZQ2nWdyYyyUiV/eK
         G22ZgDgM0asVl/L296gbNyH/UrIK7wAvOUczTAgW9q4XJIAFh9vy5sxKf2N7ZiTW/W
         nXXAbzR0LKvNQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 016C8CC13B5; Mon, 30 May 2022 14:05:29 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216017] KVM: problem virtualization from kernel 5.17.9/5.18
Date:   Mon, 30 May 2022 14:05:28 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: opw
X-Bugzilla-Severity: high
X-Bugzilla-Who: borislav_ba@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216017-28872-Zabz8mzoNy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216017-28872@https.bugzilla.kernel.org/>
References: <bug-216017-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216017

Borislav Gerassimov (borislav_ba@hotmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |borislav_ba@hotmail.com

--- Comment #7 from Borislav Gerassimov (borislav_ba@hotmail.com) ---
I'm getting the exact same error on 5.17.9 and 5.18 too. The only differenc=
e is
the hardware:
[   32.571294] Hardware name: Hewlett-Packard HP Z600 Workstation/0AE8h, BI=
OS
786G4 v03.61 03/05/2018
with this processor: Intel(R) Xeon(R) CPU X5550

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
