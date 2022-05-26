Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA0E534854
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 03:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbiEZBsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 21:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiEZBsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 21:48:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC938DDD2
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 18:48:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADB2061856
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 01:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13112C34118
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 01:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653529681;
        bh=lBOkK18xtdBK2jRRe9N0qYP9iX2OtFI+cOJ28hlhuhs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ETToQilpstp13Bsg2aS7BctRhsNJuizKp+OqausNeNTO3glSl8/pkxUvIdri10uwt
         GqJxXYBG0J+oBCFd2WcBmp9M1H71YisBNvKtK6rgCortAhKVTZ4GqHItMivo3GEECx
         DURKgu7BkaMDOtUBpDm3qb93l7UTuBhRCB9SDnZlC60VMJfcg6Vz3TeAfMjqKIWlwA
         0qK7s013KPxWsfA7MAIgDmncb56QvhR8P+C1GS8JYevIxSHZyW8J870cNRsQx8QaPj
         IVSYC496aCt1Ypon2X4SN9zyR6R2S997QK8UxyT2fh2Rc4PsjWWmGBzIMlejbZ5OiN
         /zo6YuUcS2Oyw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id F2740CC13B0; Thu, 26 May 2022 01:48:00 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Thu, 26 May 2022 01:48:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-yF3BewXW97@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216026-28872@https.bugzilla.kernel.org/>
References: <bug-216026-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216026

--- Comment #6 from Robert Dinse (nanook@eskimo.com) ---
The patches that Sean Christopherson provided to me via e-mail did allow the
5.18 kernel to compile with gcc 12.1 without errors.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
