Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D2B539DAB
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 09:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350168AbiFAHEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 03:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348130AbiFAHEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 03:04:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510B08BD3D
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 00:04:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09E88B8182D
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 07:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8713FC3411F
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 07:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654067046;
        bh=87+gM974u7b+3eue4+nZRhhBytDK8yK8dF3I9L19lyA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=X0wQUbV56IigCerYXfrougNRmnxxSuGqMBXX5ZBh7G37LnLuLs/XI0eHjvrska4ML
         sN5iyXaA3j2Q073RcQa2Ou+FM8wRxgQpmWW/6RI60GTKMWiGcsbJzNFukm0j9PMVrD
         mOkroL55TLne/uAcBYhUuXPmNW3gDCooWP1M2nkn5/WFX35S8p9ZXYHTa7s11Pid8h
         qV0uPxWtUcvVg9gUOFQ1bUXpSGk3Srw7k7QTLHgHLNVisUxIbu4OHYG3pUBndQYBkv
         f+m0TCJWh6lCa1DLWMOtW1O7+GVUK24aUK82OebZc4QgvEhV7Uckejz+XQ3Ep2L6fI
         9o/CqsJy6Untg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6F25DC05FD5; Wed,  1 Jun 2022 07:04:06 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Wed, 01 Jun 2022 07:04:06 +0000
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
Message-ID: <bug-216026-28872-NwtfXO32yw@https.bugzilla.kernel.org/>
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

--- Comment #13 from Robert Dinse (nanook@eskimo.com) ---
Well if the developers used modern tools I expect this sort of thing would =
be
resolved before the kernel was ever kicked out.  But the e-mails I had rece=
ived
led me to believe the patches would be committed, apparently not.

I just hope they don't EOL 5.17 before this is fixed.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
