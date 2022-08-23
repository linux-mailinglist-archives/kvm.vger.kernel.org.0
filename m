Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0DF559CD6D
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 02:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbiHWA5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 20:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiHWA52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 20:57:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC91113EB5
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 17:57:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A15A60B19
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 00:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9FB67C433B5
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 00:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661216246;
        bh=/gqQOjqVgvWMlI4myARVlqfNbqC20zqx+ab/jEOrj6M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Z1AIt13+r8nvfnlle07nMKUyeD+ONAZ59u++hPudBTdl7aiG1EmQrMigElkfBpCBK
         /SiB06XeBv3Dx8cqHYyQPCOSUjM+FR8ZsVEJZoYx7bCSQ+CWI/BrqXGwcxW3/1aeMI
         wqh3sMOlIRNq10qLnDnOUqaz2C2sZjmoOtga5jX2vntT9v4UdIqZAjtxARERcYUFp+
         ORLEccJHZeJEU1scvDajMIWmcAhwGFZ5XTeNROePGqt2FN4ob8rfECCByhqaVtEGiX
         e/y+g/tPnVX+inOHZAInAqidLvsCcwDacFi2mAmb2dExrr1mNfisdEk1kSotiQXx4i
         LRjPQFj0uFb/g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 87F5EC433E9; Tue, 23 Aug 2022 00:57:26 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Tue, 23 Aug 2022 00:57:26 +0000
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
Message-ID: <bug-216388-28872-9D22Z9Dmlo@https.bugzilla.kernel.org/>
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

--- Comment #3 from Robert Dinse (nanook@eskimo.com) ---
     Regarding this being a KVMGT and NOT a KVM problem, while this report =
does
come from a machine where I have Intel GPU virtualization in use, it has al=
so
occurred on three machines i7-6700k and i7-6850k machines with no GPU
virtualization although it is configured into the kernel simply because I u=
sed
the same config file for all of the machines.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
