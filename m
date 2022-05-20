Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F7252E292
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 04:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiETClc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 22:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbiETCla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 22:41:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B70B95DCF
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 19:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5E7361C17
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 02:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4DC37C34116
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 02:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653014488;
        bh=rxL+B88S2kYTTDCmOPLVCzRpHP3zoq2pqLa9WzX/kmg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RbKW+bC23gNW5uTMAT6X1+suYvqyz1lthu3p8cNc6AG7Jdig2auv0YwBVb/9kK+sk
         JFTTbHxyZ+YVM/Vuo2C44WE3DbovBydCbI1QJ/4rOYPT/MhInAIqZwDisoet3TaiBh
         P23OfSWXlQ8YCzOY/Se6x+u/xiwuHtaed60cxJ9/RPFg6HdSLdxGp3lvGF7J65CdjO
         sjxucjQsBIw/n1TQlKpqwDPKG6LV70y3MbRDcY+GzB7/fyD43O9ODv7AEFqhK2R3O5
         BYbY7lS6qfbevDBUWjyVUFHfd9C+qZTuFfkRVxaZ2Udg91phvPSbrHhBlRvINcxj5j
         uCYIwJdGZvveg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 33B63C05FD5; Fri, 20 May 2022 02:41:28 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216002] When a break point is set, nested virtualization sees
 "kvm_queue_exception: Assertion `!env->exception_has_payload' failed."
Date:   Fri, 20 May 2022 02:41:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jmattson@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216002-28872-9glE23UJ11@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216002-28872@https.bugzilla.kernel.org/>
References: <bug-216002-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216002

Jim Mattson (jmattson@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jmattson@google.com

--- Comment #1 from Jim Mattson (jmattson@google.com) ---
KVM did not crash. Had it crashed, it would have brought your host down with
it. The failing assertion is in qemu. Qemu crashed.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
