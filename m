Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53E854CAD9
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 16:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356055AbiFOOFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 10:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355950AbiFOOFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 10:05:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982EF4925A
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:05:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 352A361B86
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 14:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93BF9C341C0
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 14:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655301946;
        bh=m6pmLVU0vmDEkH5n4vvNA/A2hwKLqadawsuVXVVSguY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=P4or6jQ55pMCnMxc020yxqwmS55whXl923g/RoPEEMWl36HXv8ZFmwIMHwSq7ZZSJ
         IBYSf5OTvchJ+3VlWzINBd7UwJ6EDu8Dn7VJnizRsdqKsOo/d7+fX6r0EUvoKAMmcs
         gvqaEqmzL+KsNXM0hMFade3HH3X7tQ0EG8370XBFZB7QKtazdEYE7eL574tqSQIU9J
         DODsJKzP1rH9LNPBqXHgOJXhB+JL1mMC60Hk5/NR39x0z2nvizycNVjFa7gnB+IbFs
         XIZxUzGcZcLxS3nlySeIrDcjNE/oO2TXa7xQnERwhZxXoiZqLPw/HSb4rkoRmFAUdn
         k8gqbAvSVgArg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7AE58CC13B1; Wed, 15 Jun 2022 14:05:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216137] Kernel Will Not Compile using GCC 12.1
Date:   Wed, 15 Jun 2022 14:05:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216137-28872-PCIbD12eiD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216137-28872@https.bugzilla.kernel.org/>
References: <bug-216137-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216137

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |DUPLICATE

--- Comment #2 from Artem S. Tashkinov (aros@gmx.com) ---


*** This bug has been marked as a duplicate of bug 216026 ***

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
