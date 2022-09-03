Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7255ABC37
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 04:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbiICCDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 22:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiICCDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 22:03:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F57C8754
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 19:03:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2235B82D27
        for <kvm@vger.kernel.org>; Sat,  3 Sep 2022 02:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4727EC433B5
        for <kvm@vger.kernel.org>; Sat,  3 Sep 2022 02:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662170610;
        bh=eCnuWO6em7D7wd9WOAgqzFC+YjCjqQY+NkysN88di38=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZgvABs4t5VyHQJJNKJGCtsjQS6A4SAeMTrULkrEkQwECHCXKY8mnVF1LD0x6YhC3F
         dJa0IGu6rzmqzY8ov6rXNEtaaSuLjVUYGPghZuTvGIC41ZZXIVkfQ0cLcgKDpNo0F7
         jIDnErGaXrsp15I/vOz4bRH4fM/2qT+FpeCShuw+gaSGJgG8fOyMI0b5WELuslTKYz
         OKCVT0L2m7Nhcc9xhhyAj5OW64dNJ3b7q+NYQhK5nKgtR04Y0b8e7SoNg3mVN/uKkr
         JFCfelIYAEK70NuApARs1wFtLUQ1arXMnqx8vFcRUws6QJvw9PNCv38wU7i1VEEiQR
         xDyh99AByfKwQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2C88DC433E6; Sat,  3 Sep 2022 02:03:30 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Sat, 03 Sep 2022 02:03:29 +0000
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
Message-ID: <bug-216388-28872-zAe5Rl4PkB@https.bugzilla.kernel.org/>
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

--- Comment #13 from Robert Dinse (nanook@eskimo.com) ---
I am going to 'five' meant to say 'give' but given there is no edit function
here...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
