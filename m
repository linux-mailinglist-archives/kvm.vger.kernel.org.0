Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBCE533827
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 10:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiEYIRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 04:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiEYIR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 04:17:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B27021E26
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 01:17:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1F5FCE1E8C
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 08:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2637EC34117
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 08:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653466645;
        bh=9Uk9lE6+NuuF0LDZiwiy+j3RtfmOLKrnWP29IoHOP8w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jhFfNrBmUyRCFUb3RT89Uq9POOx4IbJ2mgxNloJ7riMowLjndnGGDYrFeflyXAII4
         /tovq2BJd1DRRRhrZqZpuR2bv6VkPQxJBBZ0a4VgZh2oFWlLaYLzAyjUf8Y9rcVM6s
         kl/KzUk2vv8aepD841Q+hwL3ufmBGR9SWA7dy9nr8eqv2HxP3R9i1Do1EpfW28Dtwl
         SR/TQ4OyVzUMs1UMaEdwYE0gwb4Zm3B5P5/7X5nfy10IpXoQxz52UNI1pqFAwtDgJ5
         nOzSnT65LIcy292oC7SxSl6C1TDOiF8sKaseU6+HorWZixevaBK8AAalIdt11hDSSZ
         3yUO8WkUVu48A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id F271FC05FD5; Wed, 25 May 2022 08:17:24 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Wed, 25 May 2022 08:17:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-RBOn8jmN6c@https.bugzilla.kernel.org/>
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

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---
This is expected, please check this:

https://bugzilla.kernel.org/show_bug.cgi?id=3D216020#c1

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
