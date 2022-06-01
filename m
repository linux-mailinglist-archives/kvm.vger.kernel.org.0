Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5064539D9A
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 08:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350022AbiFAG4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 02:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347983AbiFAG43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 02:56:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4ED57B10
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 23:56:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8D65B8182D
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 06:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A190C385B8
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 06:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654066585;
        bh=xZljNS9HOeHkpDE+d2u16/pthmDNrxZSdXNVns99WR4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=SCDNp3xB0qLvx54jMHOLI+GErAwWCHCYgJ0E0am+5rgPOxPffh7fU/0GA9foIZZO/
         mhjni03Xy8EWdymeST7PcROOubRbH8qigYxdOA2qq7D4P7+dowyv1sxWNCx4vV2gGB
         Jhjtq4tUbPKIh42zDfAg/H97JSq1x1y3+QWv3JQ2Gp71zmtKuEtLQGxej+VrLiXaxq
         oJmM+QmzRatufqaWG7cMBF3vVW0A0lTeqCKwGB4AH+HeFFqTP0C0p7A0z2Ogf3lwtD
         mlbYqRT7dG6WliLuWDz3UlUGfbgGxJ0UyI35+3MW2LIrZweHePF0DTzJ9RfxzH4s+J
         c+imELB07gtdg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5D113CC13B0; Wed,  1 Jun 2022 06:56:25 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216056] Kernel Fails to compile with GCC 12.1 different errors
 than 18.0
Date:   Wed, 01 Jun 2022 06:56:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status cf_kernel_version resolution
Message-ID: <bug-216056-28872-RFHuystLrj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216056-28872@https.bugzilla.kernel.org/>
References: <bug-216056-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216056

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
     Kernel Version|18.1                        |5.18.1
         Resolution|---                         |DUPLICATE

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---


*** This bug has been marked as a duplicate of bug 216026 ***

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
