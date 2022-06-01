Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3DC539DA6
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 08:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349826AbiFAG7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 02:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243981AbiFAG7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 02:59:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557E66543B
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 23:59:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07AAEB8182E
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 06:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D0FEC385B8
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 06:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654066776;
        bh=6cffWFoMtdnaChQqJ4B5m3zEg6X07XMj2pV08yKUIl4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=p8vT4tTNF6zzJ6tYyJKJx7KvSUOJLVfTP0FECuxxiFao1YtYc0KEhoURqEOckbL9K
         MHWLwD+1TcBMLLdBk6R79N4K8ZFQCcfU51GTk8JtE+REDcqF81vLxGAwRWpdrA5tbz
         IAfvSzJjSZCiNfl8nIsITboGfTXzB+LKm98Sr+uJZxM0jKYkRhQ2b7gnIr8W7H4d81
         AhzwRzbe/qfCzMKOZD4wQsqKr03jNF5I/mPBNqcdHv15WVhvRPHTVR8xIavhdtADf1
         Ayq6JLaINk5XDFVb7NWbKk/zijkk3iNrvMDLI1bAccdyMuUOcqpR1NEzwhI2+4r1v3
         APN87eS/SmwCQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 83237CC13B0; Wed,  1 Jun 2022 06:59:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216056] Kernel Fails to compile with GCC 12.1 different errors
 than 18.0
Date:   Wed, 01 Jun 2022 06:59:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216056-28872-Ridz4DUqAQ@https.bugzilla.kernel.org/>
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

--- Comment #2 from Robert Dinse (nanook@eskimo.com) ---
Not a duplicate, that bug report was on 5.18.0, which supposedly patches to=
 fix
were going to be committed to but apparently weren't as it is still broken =
in
5.18.1.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
