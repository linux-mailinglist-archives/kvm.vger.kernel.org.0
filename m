Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C1B6D948C
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 12:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236814AbjDFK6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 06:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjDFK6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 06:58:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CDB72A0
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 03:58:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C090F61CDB
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 10:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2830BC433B4
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 10:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680778717;
        bh=Zql3XjsZ6YnqfAJISb+Pdtv9UPDSDWrSVf0diRkeY6A=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZMK5yTKLWSn0z+ZaMwXiwZwlMeDQbhRfJkOYiwXrIuQDSEM/Ei36qRygXmF+fc8FJ
         0Xep1EeSDaJbHoDDcRgIEdD5OP3XVRrox9Z4D13ezIr3PTHqpGuXn/p1iEox2C6+PZ
         TD9lJT4ZUVgT+qU89ut5ot/09HUAsxovFIh/F+1AxexzKq0Ev0jkR6hxqa32PPkc/X
         X1AEeAql8HdWgY/Y1Pq9nchngRa1NoiG3boiSASWXOWn876oZBlTgVxrEwEplH4um9
         S6od1ek9hrJQ2196aCyCfArYwTMwh+zlqSlxqhXXXVocV7EiupWpdzY1zvZK0w1XpN
         UVpwOfJ1MOddw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0CDCEC43142; Thu,  6 Apr 2023 10:58:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Thu, 06 Apr 2023 10:58:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: webczat@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-217307-28872-cKjdIRpI83@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217307-28872@https.bugzilla.kernel.org/>
References: <bug-217307-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217307

--- Comment #1 from Micha=C5=82 Zegan (webczat@outlook.com) ---
Created attachment 304091
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D304091&action=3Dedit
This is a qemu command line for the vm which experiences the problem

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
