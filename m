Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABBFE54AEE7
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 12:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356033AbiFNK4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 06:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240063AbiFNK4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 06:56:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9568B3B3EC
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 03:56:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B2F96121C
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 10:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B39EC341C5
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 10:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655204166;
        bh=BUwjhyq7ylryteSi5TcJIWVCA0fmAn+JlZxI1vGQFmU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Oao908omHokHujqtR0mwV8d4uDxFaTa/qNc5D0mX76U937w3p25cegqWdQcF3WD5C
         Vs9BpXjCM+TQ4lHP+BHaxFxCC3xjcCtIg9kN7OB/Wt785a3ryYbHQrR/uN4/gNydPm
         DgGZP6QSS/dhG4F1nTs8rK0+Mkv+Nbzvb5pn1DZlf+ePKtZKLZykZ+ubmiyeaSNBPE
         rTEcwMWnjHpgT7rajKbgmbVWmBnfTYzzPD/xDIDCIKT47vm1paaG19WUYcw9GENSFk
         dWFCjxI1LX6ITiKQIgo7/08bkRqzFXLKB/GCvBjT5CFuyHKJMwgdw6n/0vGrlTGOS7
         +vRsaU9yr9A+g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 87FA8CC13B4; Tue, 14 Jun 2022 10:56:06 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Tue, 14 Jun 2022 10:56:06 +0000
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
Message-ID: <bug-216026-28872-YQR5PcZnFk@https.bugzilla.kernel.org/>
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

--- Comment #18 from Robert Dinse (nanook@eskimo.com) ---
Well again, if people stayed current with their development tools this never
would have happened as they would have seen and fixed this as soon as they
added the gcc flag to the Makefile.

This sort of thing is why I keep my own development tools up to date, which
unfortunately causes issues when others do not.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
