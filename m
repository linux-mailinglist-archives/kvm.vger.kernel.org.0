Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324515507B8
	for <lists+kvm@lfdr.de>; Sun, 19 Jun 2022 02:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbiFSAaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jun 2022 20:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbiFSAaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jun 2022 20:30:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B4512601
        for <kvm@vger.kernel.org>; Sat, 18 Jun 2022 17:30:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0540B60DF4
        for <kvm@vger.kernel.org>; Sun, 19 Jun 2022 00:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 675FAC341C5
        for <kvm@vger.kernel.org>; Sun, 19 Jun 2022 00:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655598628;
        bh=l129Vij5SjTeR2yScHFSn0gr7dP/rbLNQOr8oUSE9ho=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LhlpVlIzI9yZyZD+IQ/WLX4av9R/D6iFjgzi8BsXqL2XTDw7unDm1Sh6g8V/zRg1n
         S3Cs7HXrfEh6dzKxGkrJQmLMHll4GZ62L3vV0OPhSO1sxKIoiPOchX1yb0Wb8BJXv+
         CCP+nEnQ+TSF3rNPewjWug0aondQE6wPRcVraU4cD+NBN1VS70pW4lm81TIJA6qE+U
         BCgzbwjlDf37g5gEe/ODnv6pE9ohz6c2Zcpn5g1doD+zl8zHH/HC+5joGCqFkL15SY
         nl171sbdPZsta6DKOpAIo8ySrRg6T2YgFPAAIf0R5GadUDLQk9A8deOb07ZLyiisPm
         PD9Nvr3IOV6DQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 56E91CC13B4; Sun, 19 Jun 2022 00:30:28 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Sun, 19 Jun 2022 00:30:28 +0000
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
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-Vv4GIyaTeq@https.bugzilla.kernel.org/>
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

--- Comment #26 from Robert Dinse (nanook@eskimo.com) ---
And we're already WAY past "sooner".

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
