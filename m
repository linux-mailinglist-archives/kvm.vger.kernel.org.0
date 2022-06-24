Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF5A558C0A
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 02:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiFXAAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 20:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiFXAAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 20:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2B252E57
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 17:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A08CB8251D
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 00:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA661C341CC
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 00:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656028815;
        bh=ONSOyV4ca1W6XFBifSkqX1EgtG2uXuzjSeLTaejO7S4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Xyh+DkdLEOytvXCfmPKUP6np26GfdLyVdlvfnIMujN8p9xKKa+fHcbST4RPIFJCDg
         RV0CjswH9Pc0pEqOF5+cL1u8kp4R3q2y85BDf+BnQBnphFM9G4GZYdE9G7LgHFqDlK
         VAdGQtE29tSOA65N6b61IQn1pjkqU5R6RwVCx98wXrcNFwUsy2zezeVO9wgPhUVsKQ
         3oQf4CFA84yN3ooLS769xub6v4nhnNvVtFt0I3DC6iy1aMLLXow6yENwT0aOdyssMp
         WnoD5GDjyj6RQvGDpfZt+ECZxFNS/7yMqYU9S6M3Ft8N8Q0/WTfWqQurSlQnVKkBmy
         NVOjmC8clOOSQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B4923CC13B5; Fri, 24 Jun 2022 00:00:15 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Fri, 24 Jun 2022 00:00:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-o3UH1LEJE7@https.bugzilla.kernel.org/>
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

--- Comment #39 from Robert Dinse (nanook@eskimo.com) ---
5.18.6 compiled successfully using GCC 12.1 so this issue is fixed in the 5=
.18
line as well.  Much thanks to all involved.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
