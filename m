Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6755520CC
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 17:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244576AbiFTP1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 11:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242349AbiFTP0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 11:26:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F1DC15
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 08:25:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69FA6B81211
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 15:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E96C1C341C5
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 15:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655738750;
        bh=ISXPhUBg6qQOCiqX/l88DDSasMb8lBnj2ojhuaqrzvk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=eu49XZhxfxApYqYvjAeOzpwPRpEug2GRWuGp9rW+N+dE3dtD7K0hgs7nwP7izoMSl
         QnXHITma2Gh7UU8oHwtvIVTw+X4Pjm5+HNlYfl50k93hdOZxiarPhmWS7pZFARKNYe
         XAXbkaRolmjICxQ+cH49FQdzRdOLcZ/Rg32uvC9je5WRATfsZTYvg2VbniziynPEiL
         B0IKl5YRy1zhDny/MD6xZGlSJkmBwbB/vfhNRSqJ6bThWG5uXIAPBtUDv3auQagYr3
         Sb64ZY4t+xPpyipPvnPtjGPgwHAo76LdCj1I159Q3qhXsEGazSWFeMBbVnfFzDgmiR
         yj8nY3iHK8F4g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D489AC05FD6; Mon, 20 Jun 2022 15:25:50 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Mon, 20 Jun 2022 15:25:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216026-28872-njUcH11dFN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216026-28872@https.bugzilla.kernel.org/>
References: <bug-216026-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216026

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |aros@gmx.com

--- Comment #33 from Artem S. Tashkinov (aros@gmx.com) ---
Let's be honestly brutal here for a second, shall we?

1. Do you pay for the Linux kernel or have any sort of contract/agreement w=
ith
Linux kernel developers? Absolutely no. There's a license attached to the
kernel, please read it carefully and thoroughly.

2. Do Linux kernel developers owe you anything? Absolutely no.

What makes you believe someone should suddenly give up on the pressing tasks
they are being paid for (and the failure to complete those tasks could also
mean a lost job) and pay attention to a random self-righteous guy who's
screaming his lungs out?

You're completely lost.

What's more you're _actively spamming_ a mailing list with dozens if not
hundreds of subscribers.

You don't add any new info, you just demand, demand and demand. Not only th=
at
you've already managed to create two duplicates as if it will suddenly make=
 the
people responsible for this kernel subsystem give up on their primary job a=
nd
rush to meet your demands.

Please stop. This message does _not_ need a reply. Keep this bug open for
Christ's sake if it makes you happy.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
