Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782E454EC65
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 23:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbiFPVW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 17:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiFPVWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 17:22:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4643460DAA
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 14:22:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCC6061ECD
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 21:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 444F6C341C0
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 21:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655414543;
        bh=UbgwbFDZFA5rn7GYhPvIwFQFcKUmmy/iWcIsMiWQCio=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=n7DRRZYM9btNxjtV0KpZiUsZ+10oQ1GYoQberleufMEI91FAb4/Z4g6jyVKkX3Y42
         ThXX+/JIENwMHCurKZMp/hRzKxp6fB2m9J7U1RqwS+9mwHRlSKARGG0GZKUHxxBzjY
         JVWgibBK6d4g4og306IOhxU8ogJAT7iOsOPxfPFrvl2z5ZFe0jL5NAnTb2k+clepon
         tnvg3FoUOsPctpoIAYKLVAm4Gh5PKj4eUCK5NEte38TN6CPSLT5NCUrZn7JRInuG7e
         B7yHdmcj9WcPZm7lO2tN9ZmxGWYDT07BagWz6jnZGspwVmLT/1e3+RusI1Ghjl29+O
         dWQ+7111kKIKw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2DE15CC13B4; Thu, 16 Jun 2022 21:22:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Thu, 16 Jun 2022 21:22:22 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-Q7fY6QszyZ@https.bugzilla.kernel.org/>
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

--- Comment #22 from Robert Dinse (nanook@eskimo.com) ---
Tried to compile 5.18.5, STILL BROKEN.  Same Error.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
