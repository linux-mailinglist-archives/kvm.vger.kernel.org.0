Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7954558F90E
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 10:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbiHKI3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 04:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbiHKI3L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 04:29:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDD190822
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 01:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CEE861552
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 08:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5D77C433B5
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 08:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660206549;
        bh=kmyQ/Gpt0U7vfc4lH9Yd3x+ZvvV1TshIRnRXG4jlI70=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=U6JtltwxQWk7ZybPVQPF3jN9F9KDAfpYErsVXGWqkYmw/yqLfXpqP8FzLO4ndlcWl
         GzmkAxc7J9D2/r71O0HOfv4IjKMhr/qoOtM9hCvsO/BGcWu6UlSmgXXbFCGE5biS3b
         2wxXT8NSGmaygvU89gmxR8FhzCjnvVHGpgqTU4keMMEqRaNmgKogekhD9LLZt269mC
         9i6iL85Hrwxf3soPRny1221qOzxskwDw4rJBgwYHLC1lqL2hctzeBgVamwrq8E57PL
         4OYPh0W68nFAbja4PTymhlhCBwNlJ5dOKMpDB4V1R/bdu1ksViM5PKMCclr/SAJR36
         Bp7AovtfPZKsg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7EC09C433E9; Thu, 11 Aug 2022 08:29:09 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] Kernel panic in a Ubuntu VM running on Proxmox
Date:   Thu, 11 Aug 2022 08:29:09 +0000
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
Message-ID: <bug-216349-28872-HhuHfUThRJ@https.bugzilla.kernel.org/>
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

--- Comment #7 from John Park (jdpark.au@gmail.com) ---
(In reply to Dr. David Alan Gilbert from comment #6)
> Hi John,
>   Thanks - hmm ok, if it's not migration it's unlikely the one I'm working
> on.
> I doubt changing to q35 will make much odds.

OK, thanks anyway David.

Is there anything else I can do to help someone diagnose this issue? Should=
 I
keep uploading logs of kernel panics on the VM? I apologise if these are st=
upid
questions but I haven't logged any kernel bug reports and I want to provide=
 as
much information as possible.

There's quite a few people effected by this issue as demonstrated in the li=
nks
to the forum threads above.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
