Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2395BB9F9
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 20:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiIQSrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Sep 2022 14:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiIQSre (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Sep 2022 14:47:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51712B1B9
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 11:47:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AB03B80DCD
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 18:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE7FFC433B5
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 18:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663440451;
        bh=5WoUXOVIfldbXQ1WcMmsqwAov3bmahVWkPVjpCyd0/o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=toqRwd+2UiapSMJ8Cu8/4LgRgRbGmBi7ANf2TDZDpcg/KNyLNDEMrVWgiw5eHx+47
         YlyLdFFFyzaD0jAXFN03uOwvPPkXXbfk+rsDcwh/+eVEr9CJS3zd5aTmaTduE2y7E9
         SWTalp/9j5t5YHVWVHbsjVa2Y45Uw5I14OEQ/TCKaD+NWesXhuoHkfbZK+0ic1cAic
         BD/efhLChWNPG9y5FJoRC9KMaINjK58Fib+sWX93o7/bwu3Qvl9T4XZ2QXEXlOitFQ
         ZfmykEHdXX6N8obBU2AK/rx2226vTDznoubIsP2KmSuYeqZH6Dq+VK41tQm+0P66H+
         CGwWu/CywwTdg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DE526C433EA; Sat, 17 Sep 2022 18:47:30 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216498] Can't load kvmgt anymore (works with 5.18)
Date:   Sat, 17 Sep 2022 18:47:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dion@inhex.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-216498-28872-oUNVfPlTgO@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216498-28872@https.bugzilla.kernel.org/>
References: <bug-216498-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216498

--- Comment #1 from Dmitry Nezhevenko (dion@inhex.net) ---
Created attachment 301821
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301821&action=3Dedit
5.18 dmesg after starting qemu with GVT-g

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
