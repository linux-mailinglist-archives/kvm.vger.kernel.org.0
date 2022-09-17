Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3BA5BBA2F
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 21:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiIQTxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Sep 2022 15:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIQTxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Sep 2022 15:53:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328AB2CCA7
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 12:53:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0D19B80DF3
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 19:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A961C433D6
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 19:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663444398;
        bh=QESH6vqGn9sSv+nEET7383jyTJWpbY0Yi3H3+Hbr+fs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JbdV6W+RWZMLMYzQbiEaSywrjaLq0PWIUx4VA6SYDpP1HN0dFmF3rjZJ+ejByzMU3
         NWYaZhZzhCtCfAGJPy1rb+l8Mk5lXLUgcLkHO1ltm/wDgGyci/IePH8+NSyGEQar02
         vRLNZCgjnZxP6dGLNkK28UeuBfOJM0Om0GPmHUSUfIie6Hqirp+9ZSnOFbyX29lcSa
         a18mpMCfRLF3NX2jMkbNgEQJmVPRzioOMLueNZOxCR1xFI8ukpm3MNT4pjTQwR2uyp
         eaWwotaCu0lV5wHC0xzmGvzstrCuvy2tWHJwyx9NA+y4l27V3QosTJb80dHGE9QvZL
         rWQXGbrD+Z72g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 42F96C433E9; Sat, 17 Sep 2022 19:53:18 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Sat, 17 Sep 2022 19:53:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216388-28872-sxqBHpJlyX@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216388-28872@https.bugzilla.kernel.org/>
References: <bug-216388-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216388

--- Comment #21 from Robert Dinse (nanook@eskimo.com) ---
Well shite!  6.0rc4 ran perfectly, but 6.0rc5 is back to massive CPU stalls
just like 5.19.  AAAARRRRGGGGHHHH!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
