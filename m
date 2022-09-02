Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE5D5AA75F
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 07:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbiIBFq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 01:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbiIBFqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 01:46:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727B7B6D68
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 22:46:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AA0661FC7
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 05:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80A8CC433C1
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 05:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662097608;
        bh=bxzZUIeCVOuvbmGySzJK8mXWDB89zrXykldD1a7RKto=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=p+dCmiWwlhx6BgB97gLvRVNEuTUu+XpcWCz8/C3/TFhFr0RINVFnXucQrw1zGfiUx
         8JX9S5CGZPCuo+0tMM0pEOgx8cy6H59t06E3fezsksiKy7zUq9CcFCkDVA8wb91TPR
         RxA888CKCMjnlqbFyq2EwLXzLdoI7AArDznPKwXGOgWPZy2OtRl2dH6jxynVyDt5aP
         TIFDoJGQVMJr8eowGxjIyl+jAvlV+lDCx9JJbprqkMFUWj17qBjDsxqftUXaAx8c7B
         TLF12k4LtGE+hniUjyXcygjDwl5UATTBNpYPTRLnwcgIjFsjv2GFGIH5HS3m3jOy5v
         AZ3A4CHjEuPJQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6860DC433E9; Fri,  2 Sep 2022 05:46:48 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Fri, 02 Sep 2022 05:46:48 +0000
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
Message-ID: <bug-216388-28872-tk14vk80D8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216388-28872@https.bugzilla.kernel.org/>
References: <bug-216388-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216388

--- Comment #10 from Robert Dinse (nanook@eskimo.com) ---
This >MAY< be a compiler issue.  I was wondering why I seem to be the only =
one
having this problem.  Given how frequently it occurs to me, I would expect a
gazillion me too's, but so far none.

I know very few seem to be using gcc 12.1.0, which I was using, because I s=
eem
to be the only person who had problems compiling 5.18 with it.

Since gcc 12.2.0 was out, I built it today and rebuilt a kernel using it, so
far that kernel has not produced any cpu-stall reports.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
