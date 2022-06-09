Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526C9545190
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 18:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbiFIQIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 12:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbiFIQIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 12:08:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36857237941
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 09:08:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3A9CB82E54
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 16:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81CE4C341C6
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 16:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654790928;
        bh=ae4Mu5dTb//lyxWSNDOO245b8q9yL2jxrXcLMKYUhqo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LKiSNa734uc88G0DoiUaBvvcKK0mF+cIiRPHn375jJqT+9zJUNTEBpBYwyq+TUtzg
         SgUeBD02fsCPvvHEAPyDVxgd3KIQFKQuKnwAVpALdRvvAzBx8tn2OHfTQti4vjL8jU
         3YXqeMfmgd4nADSWkSEd0fLRnSeuFSWb8hszT61NqKciFWAgPLDlOJHl+HCxxZyEGa
         iTOVPJg7qT8G+AiFnQus73XcM4LlURi9mAAgyqRHnpgdh8qV6gJPOPuaSBwCqmb5N2
         Ke1WDRmHwVrQnle6/wJLiesOLBZwQdYNxaQFKEFZpWmu7jXwQCuRuZJsxQ5fRCuaU9
         7ndAGsZPlWP/w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 69357CC13B0; Thu,  9 Jun 2022 16:08:48 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216098] Assertion Failure in kvm selftest mmu_role_test
Date:   Thu, 09 Jun 2022 16:08:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216098-28872-oUfnynYGAW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216098-28872@https.bugzilla.kernel.org/>
References: <bug-216098-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216098

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #2 from Sean Christopherson (seanjc@google.com) ---
This test was made obsolete by disallowing CPUID changes after KVM_RUN.

https://lore.kernel.org/all/20220604012058.1972195-14-seanjc@google.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
