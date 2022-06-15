Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8ADF54D445
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 00:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346917AbiFOWLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 18:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345411AbiFOWLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 18:11:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6446454F88
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 15:11:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DB75B82186
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 22:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A69A2C3411E
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 22:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655331100;
        bh=I2pX/AlrBVDIdN5412/df79Uy2neoAE/cchaPAr4u/Y=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=snDdArWAk+77tZQgDObqUkamNkBNOFXFECJonmHbTQlHjVq7SgxpGOCLIgL8Tshlo
         4BV4lOUNw0fGqBsWWuFGeqOGRMqOaEsNScobx+dYjtum3srdf2p8f7S+jkHL5DtuJr
         1Ol4J/xGzCMcgjRcDzb7kuSI/LNgWBQUPaZhaawvWDV+j0fBHV5GCNMA+0WjnJqHLf
         QXzwDSgwfFR4Kq3w24ZGvbjRmkohCSHh2LbbxJi/bbNCoVFpA3wl4iUBzsgB/Xluwc
         mLhvkLpoBSl18S4gDlay3H4+IaCDTx26QCpfmuAD/O6vk6Cxqfr18kfwKFJx3oxvD6
         IOP4zyUtTQIgg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 910B2CC13B4; Wed, 15 Jun 2022 22:11:40 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Wed, 15 Jun 2022 22:11:40 +0000
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
X-Bugzilla-Changed-Fields: bug_severity
Message-ID: <bug-216026-28872-0GrMBKZISs@https.bugzilla.kernel.org/>
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

Robert Dinse (nanook@eskimo.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Severity|normal                      |high

--- Comment #20 from Robert Dinse (nanook@eskimo.com) ---
Still broken in 5.18.4 AND NOW YOU HAVE EOL'd 5.17 without 5.18 WORKING, NOT
OKAY!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
