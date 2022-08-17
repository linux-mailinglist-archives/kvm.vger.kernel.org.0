Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444B3596D4C
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 13:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238887AbiHQLFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 07:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbiHQLFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 07:05:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09BF72B44
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 04:05:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9888EB81C06
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 11:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B808C433B5
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 11:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660734314;
        bh=RP0iQ1apF025ttgn+RRqOdh7N02gw4MUArby4XUXw1k=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NqQ2ybGaHyptdNRSIipR+RiXv6t8pf/pNsyqVcDrIiHWGwae8AGU3iqyEQLRAWgDs
         lzwOqYyw2Wzs1Ou1HCpGbiuNUfrbCh6kMc8kVG+N6i7lIm6GiRYpzSK5cBr/N12K2F
         CLurflrEwr9gUzRqs3NJIPAt88VvhI3I3BcWbzdcelG6+DbmN7omZPoC5PvGsCc8sK
         KsCciauU8vUm7pR7g8SncCJrriNORupJNtcSmjbhNvAuIYAWU5irGJK5JF4tEa+JPN
         wPykXyL6nwnaomwFTwWjd9NHqQeiUP71esdD+GGc1oF8eFFPfkmwQH4dSCwQE6odSH
         YAdhLL6+3fOLQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2D5D4C433E4; Wed, 17 Aug 2022 11:05:14 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216364] [Kernel IBT][kvm] There was "Missing ENDBR" in kvm when
 syzkaller tests
Date:   Wed, 17 Aug 2022 11:05:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: pengfei.xu@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216364-28872-FGnN5mF9Tm@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216364-28872@https.bugzilla.kernel.org/>
References: <bug-216364-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216364

--- Comment #1 from xupengfe (pengfei.xu@intel.com) ---
Created attachment 301591
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301591&action=3Dedit
Fixed_patch_from_Peter_Z

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
