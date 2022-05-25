Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF010533890
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 10:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbiEYIep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 04:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbiEYIek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 04:34:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF2B10FEF
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 01:34:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13CA7B81CEF
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 08:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6C3AC34116
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 08:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653467675;
        bh=98sBrVn7WbWvJwh9T0GkP7jVOA6sH0F6X98j0pB9I2M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OBZCw4ErpXFk1SyTHehymcx+2E0vdIJhIvD23w5Sj5VmNRFlNTZZaNCS0KpvIF3xv
         FpsQY+JGBbOn53ESJj50cGi2xLySlq/HQ5UGwWAlYNzT7IQlpW/qxhKayC1FZ8NbNy
         yW/aS+hTMk4+YFuJIrzS1adFThlXzWeDsjXeeHQY+z6bPmyczlID2iJBuEeu24OAn8
         ikrjAQqSJivDVYCp2nIf8XPFWjIvi9V5cyaM64XVT7xJarmeN/QLCZf6Zr1oT1jpme
         c40lHSjABT6dBSXkrPnvlfp0QEJs3/jZ4FDnfckUlFUTIgGv7CbnzwBW1s18kd9W4b
         TJpb1dQVovyjA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7F337C05FD5; Wed, 25 May 2022 08:34:35 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Wed, 25 May 2022 08:34:34 +0000
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
Message-ID: <bug-216026-28872-C6lhVUND1T@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216026-28872@https.bugzilla.kernel.org/>
References: <bug-216026-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216026

--- Comment #2 from Robert Dinse (nanook@eskimo.com) ---
The fact that this was released from a release candidate into mainstream be=
fore
fixing major compile errors is just screwed up.  What is this Microsoft?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
