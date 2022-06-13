Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5BE549C08
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 20:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244974AbiFMSoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 14:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345157AbiFMSok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 14:44:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AFB54F8D
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 08:16:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C332614BF
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA152C3411B
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655133369;
        bh=ZN+q5qvYRMaJSTivKmJJ8NyH6VQ/3DpIWDp7oTGLudk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=t7pF+3LLqeDlvvGW9zRooEnJBYTi83Wv6/BMeBqPM1KPYXMh8EfTU+Wrg0lRdxS/j
         hZElJNSEeDVHxyI9KmnbX4tYWoKcLIksGIp9LGYcvu3/E4CPjjABovuA3jr3V445gJ
         Ji9qSanWiVM4ywsrplsFjgooaAtbzUcCK7oo1M8T+hT3V0PX04ITU4aGYmXW5Mlphe
         7JahXlWidThKdjDDEAO5tfykBXL1M8sEORyfzQ0dM8kWrJj0LJIumY0hK8zcOPnd6k
         uplH/ey1Wb+uBebiQEPnCpwaJqjWHniXT2izMGp+ytyyN9lzaADSXKKz225hy1qCpB
         FahDjslys+uGw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9A4F3C05FD2; Mon, 13 Jun 2022 15:16:09 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Mon, 13 Jun 2022 15:16:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: alexander.warth@mailbox.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-yPlENnHagt@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216026-28872@https.bugzilla.kernel.org/>
References: <bug-216026-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216026

--- Comment #17 from Alexander Warth (alexander.warth@mailbox.org) ---
Yep, TBh I dont understand why the patch has not been merged yet. Meanwhile
other patches of Sean Christopherson had been merged already

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
