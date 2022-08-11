Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C0F58F764
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 07:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbiHKFuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 01:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiHKFuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 01:50:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E6732BAE
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 22:50:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31894B81EFE
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 05:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA5B4C433D7
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 05:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660197046;
        bh=5xJSXspv4HKb1uZdbq50haWAnvd3H1I2OeA05Xb+dNA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KEgiX7Ge+JfG7mdpqdtrjCUCVNuGyXZKtyJBRG8pAHlclvBSZwWO+aMsk6lz1M6u2
         3KDdB9VD+CL1E1hzz/909YE56IZWqBpaujpcktTt6aykR2+58AOfwI6Lm6EfXBBm9t
         Sq2Sw3LhwwOBoU0zpfC445qS+Op9HaP+fznGSfTz8uOEjxAWjGBQ+lodt9td7QuoEl
         V0W2yROwWWoj2+cL5Ni1iOEEizK+580qz0AOuaL899QOLNO+r9u7g1VnckNsujfQO6
         sLrPf1vTMwxyQ6cvMvQQaKCiEtfi83jwBIaSEi0mPTw2p7OWZTtWhWfBhPkpopanPb
         SAj+sCluIT4eQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C733DC433E9; Thu, 11 Aug 2022 05:50:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] Kernel panic in a Ubuntu VM running on Proxmox
Date:   Thu, 11 Aug 2022 05:50:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jdpark.au@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216349-28872-AZaPIhhGFa@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216349-28872@https.bugzilla.kernel.org/>
References: <bug-216349-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216349

--- Comment #4 from John Park (jdpark.au@gmail.com) ---
I'm not sure how verbose I should be in the bug report but I thought it wou=
ld
be worth mentioning that in attempting to troubleshoot, I changed the machi=
ne
type in Proxmox from i440fx to q35 but this made no difference, I got anoth=
er
kernel panic today using q35 but unfortunately I forgot to change the inter=
face
in my netconsole config so I didn't get any log of the panic. I've taken a
screenshot of the console and uploaded it anyway.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
