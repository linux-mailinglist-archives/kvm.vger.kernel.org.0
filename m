Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4FA64EF27
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 17:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiLPQcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 11:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbiLPQb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 11:31:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F4BB8D
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:31:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9134262159
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 16:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC2ECC43392
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 16:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671208315;
        bh=LHc0p3+mpuWVU2+q+bsPc8wF6JIaODMtPdtztzqOKTc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=BPkXwuY9hoKodZzAB1ayHaYUZ4WLGxLTbyJIulUyEMFjkrM8L+G7l55aHF9nruVVJ
         REtLiixQuDJTIX1RRCaIFNMyyWzoDy5jAcXWD3tAGCaH3NxlyuSSaHk/IrUOc50oPx
         mj/tRjUzc5cIt7ypfYNAgYunoEqmEiYFbYHNZHFVwO31SOsF3nxvEZJeUmbRxEqfMM
         5G/Eauq6Gqv2IEVW7zTpa6YtPllWLyyraQ8HcZhB6IWS15wF1ONQAkIKUj005/232l
         ZWdVHGz9LHEh2WQpYUl8LQls6H/xvfu15q7reP5EmXEa772oky3T8xHV3eRF3i/7PW
         KgbJN+t4oYmfg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DA524C43143; Fri, 16 Dec 2022 16:31:54 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216812] kvm-unit-test xapic failed on linux 6.1 release kernel
Date:   Fri, 16 Dec 2022 16:31:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216812-28872-w6safiVsMA@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216812-28872@https.bugzilla.kernel.org/>
References: <bug-216812-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216812

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
KVM-unit-tests got ahead of KVM proper.  The test will fail until the KVM
fixes[*] land.  That should happen sooner than later.

[*] https://lore.kernel.org/all/20221001005915.2041642-1-seanjc@google.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
