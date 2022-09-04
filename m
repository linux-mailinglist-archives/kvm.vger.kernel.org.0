Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8655AC2DA
	for <lists+kvm@lfdr.de>; Sun,  4 Sep 2022 07:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiIDFl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Sep 2022 01:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiIDFl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Sep 2022 01:41:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5D843615
        for <kvm@vger.kernel.org>; Sat,  3 Sep 2022 22:41:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E803B80D06
        for <kvm@vger.kernel.org>; Sun,  4 Sep 2022 05:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7464C433D6
        for <kvm@vger.kernel.org>; Sun,  4 Sep 2022 05:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662270082;
        bh=Io7lQTiYzIn0lehaAOSpi2fViSQ35zI0RkYdcxAS1No=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PHRORMmCsMkCnkdLiTx8IeFEAa7cm6xidTGTWvlexwWRyiiM/F0aAH4sXeg1EDp0e
         fa+MTe3SqvDM7LN6BJjYL5tHnhAuLLwyN+LrE5qSlRbesd/PZW1Z/82hlHkNg2xwR5
         J97LQNcLBFuRJrPOJs2SjC748uJaO9g6jcXE3lVzykFjsr4EzEWBhJVLA3K7YjxAs9
         EupCNfCBiOJHkNA/aCeX8y7/3PA3pror6P7ytvQ6DCFSXUai/Ey5D7a3NKZUnk7qBf
         TAkD6+irRbbAjqFHvxKgOuRnr04gixKh1QSS4VrmZAPzYRGhpeEoBR27QyTq2oLzcP
         eKns1S44Ba4/g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 881E9C433E9; Sun,  4 Sep 2022 05:41:22 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Sun, 04 Sep 2022 05:41:22 +0000
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
Message-ID: <bug-216388-28872-HdNTM93GRT@https.bugzilla.kernel.org/>
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

--- Comment #17 from Robert Dinse (nanook@eskimo.com) ---
5.18.19 has run for a day on my four busiest servers and on my workstation
without errors, where as 5.19.0 would generally generate cpu expedited stall
warnings within minutes of boot.  So definitely broken from 5.18.19 -> 5.19=
.0.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
