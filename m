Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A070570D55C
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 09:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbjEWHja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 03:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjEWHj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 03:39:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD4F19D
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 00:38:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C926262FFD
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 07:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39607C433EF
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 07:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684827534;
        bh=3SeLssZGhYAmJ9troD0uCU3zGfgg74E08IRO4bcmYfg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FHwFdNUeHO9ptWqW9Fb1QXCZYdzbUAs+Lyvns92VkC/NEEVg3AYlTfED1XVObWNZl
         QjjTcoLwlgMowsx+GGPqdLn7AYk8JmCOOqL5au/o5E1Pp0LM99O84oOxpGA18F0goe
         91HbxthbArmo2dZ/FlwwDLJfIcXRTQRaNuz1+4QPyBSTn9RdnklFbSzUUAk64/3wLN
         aXQUYYhZdEcU9m+gYOm0IwvR/0Z+cuxQAPmWJS+SSWjMZTfi4Hr5nHR1RnhZhdGTHs
         HSR8OEd1CmHtdpmRVfTu4AP002GyOwPeS+7TakRcjVH0d5jKmSealbmVfwC4xZ7vfX
         necmqlMfZyn8A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1B236C43144; Tue, 23 May 2023 07:38:54 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Tue, 23 May 2023 07:38:53 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217307-28872-EXFXpGLVtg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217307-28872@https.bugzilla.kernel.org/>
References: <bug-217307-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217307

--- Comment #5 from Micha=C5=82 Zegan (webczat@outlook.com) ---
Hello.
It's sad that it's not that easy to figure out what the ... is going on her=
e.
The problem with using qemu debugger is that it probably? doesn't really al=
low
me to break anywhere. but even with a non qemu debugger, I am unsure how wo=
uld
I debug that usefully, that is stop at the right moment to capture anything
useful...? of course the best would be if someone with necessary skills cou=
ld
repro it.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
