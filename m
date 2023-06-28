Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5191774130F
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 15:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjF1Nxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 09:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjF1Nxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 09:53:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF3C211D
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 06:53:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96A7C6133F
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 13:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0362DC433C9
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 13:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687960422;
        bh=TgIe8+gzsxAbaSfie/e+pQ/iB1lpI5RdqfL9zc6qzuw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fgoY48c3d0zCC0/9XYLSTGupOt3jjI/2rD3WvYF9IZP71vE7Utng+Q6tTqzdWBzYn
         PXK5x4Xgvsk+ShDFpjfCuD/+mvUaL17fGx7Rn1z8YM1fnqv6T4ygzICCCC6Y722R3J
         jU31CVNvx4UvfpuY0wIEUK7Ns958I2UkpzkD4iCA1cpE8Cxb/OC3F6zC1CiqR5FGHF
         jFWl6y9Owct8IFUhkz/t+5ViPCWa94elcGabP1ukFOXr7VXujdG5iut5BhG6xwiDFl
         crMWqPEM6TEdJgd/n36AqJhHa8ofhjbGxTuEif55lbumFf3TasQCJCYG/CCzwbzbIy
         eEaRzNQcDZ/rg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DDB82C53BD3; Wed, 28 Jun 2023 13:53:41 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217574] kvm_intel loads only after suspend
Date:   Wed, 28 Jun 2023 13:53:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: chao.gao@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217574-28872-ji0QcCwd2G@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217574-28872@https.bugzilla.kernel.org/>
References: <bug-217574-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217574

--- Comment #8 from Chao Gao (chao.gao@intel.com) ---
Yes. MSR 0x48b is inconsistent.

Your microcode is too old; according to [1], the latest one for your system
(Family-Model-Stepping: 06-3f-02) is 0x49. Could you update the microcode a=
nd
retry?

[1]:
https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/blob/ma=
in/releasenote.md

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
