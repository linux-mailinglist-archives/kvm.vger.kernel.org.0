Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB5D553754
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353485AbiFUQGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 12:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353456AbiFUQGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 12:06:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE3463B4
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D50EB8199C
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 16:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4774CC341C0
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 16:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655827606;
        bh=i+DQA1zNbx3aPLqHMsZZI9mHKKZssg+1pW6P0IQOI9A=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=MimI8IE/PRp09ymWyMp8Szc8VY/Ov4cZ+W47MB6NmjeIqIr58XyIPuS8x5UEHHO2K
         dMqd5JFm41hPJBW1zo/Lsa/u9SW6wbp6o1LAuqIlJ44ZuuTpe3e5O0O1gML5LOHSlV
         qfzDj8mB2Y7mVPwJDVaxtmFEgYxUkDHR4T/sTcrN83EzNsqrfhM8RLNXI9eAbvkBog
         OkfWmxot+lRrBudj8WquaTDINN1Ui49398m/UAhR2rnBCLmOYIBQ+JdDzqFNYHBb4w
         G/dSHXlfeiOcDGnxrSVISVkZojoj8j66gbwkVymZzNCaHzwLAkp8kv5qowp8wV3IEW
         sao8Zc8BbtVTA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 37C36CC13B4; Tue, 21 Jun 2022 16:06:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Tue, 21 Jun 2022 16:06:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: alexander.warth@mailbox.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-XAzdMJDJyH@https.bugzilla.kernel.org/>
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

--- Comment #37 from Alexander Warth (alexander.warth@mailbox.org) ---
And great that we have reached tech focused rational ground again.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
