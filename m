Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2360E6FCB4A
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 18:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjEIQ10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 12:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjEIQ1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 12:27:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEDA4216
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 09:27:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A7B76472C
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 16:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D2FDC433AF
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 16:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683649640;
        bh=ViUW8mWwrDwRKZ8xPyAf8z/I3QBz7wxMqzpFOS5TxHw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AIghkkE7TXjllNHjhNwGyDNov93Yqcqnw3qDjZLuYsMGaXgHY8CgPjNZzp8ZfkrbS
         6K+UkU/U1idSdPStqYzi6094rhIh9hM7C3ZAjzzsskIRgGainrPjXXhuqepdeSCNko
         8Et1TYMivsrIdMybZIzA6PzFoCWDyDoyX2bLt+E22odZuJHA7Jh3pRD1LDV9Uh/n8W
         GPjQ+z6PkzKyNUXueeR6/w45fIkhuFT0zmeywscyD7MavAPWD3Hhx5WU8OlCkOKy5W
         0KnUvLRrpC6V9gjyKK3U0NbRwwaHHlW7UPbZKdyDDrjIIfaLgCvjZibPiOUnxgejrC
         ZebaVsWuGSRpA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5F385C43142; Tue,  9 May 2023 16:27:20 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217423] TSC synchronization issue in VM restore
Date:   Tue, 09 May 2023 16:27:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217423-28872-LxkiOjvuxd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217423-28872@https.bugzilla.kernel.org/>
References: <bug-217423-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217423

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---
*** Bug 217424 has been marked as a duplicate of this bug. ***

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
