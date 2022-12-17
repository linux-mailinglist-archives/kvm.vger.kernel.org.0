Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8EB64F809
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 08:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiLQHAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 02:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiLQHAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 02:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153001DA52
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 23:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0134A60A09
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 07:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49C40C433F1
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 07:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671260416;
        bh=3FH8eh49pJ4NFlc9Ej7hqV/mcLcPWzhuKMnmG8rJFn4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FS/HxA2hpPz/ba3W2JjAq+qS4PByP7WV4aLgVvCdtxCSS8uUN+SHJuX2Lrim5fOaD
         ao7IEDGzRrM2pYyq23tVTQSj8qvujBP+91EaxVfkqjgxYSrHbILkGMJj/+78Zm1fDu
         HnuXAY4thD9WaFPi/ytfphbWFqWmbxQQW6Ek1meVPxVHDHqnlkXUe/iIA3ryChnYyh
         s0c+fXqusd3+9v7C+J+tnJvPalLEoVHNlWqgYn+kU6U56HDZa/63B47fc8KS2+AgnO
         3gBmLbS13BeVDFRi6BRv8Jj6QXpMUiLmYNpNYSsDwxv/83kowgtsQjcWbc0z4CN53U
         o6dFdA3BZwedQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 37891C05FD2; Sat, 17 Dec 2022 07:00:16 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216812] kvm-unit-test xapic failed on linux 6.1 release kernel
Date:   Sat, 17 Dec 2022 07:00:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixiao.yang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216812-28872-xJBKmwPbdw@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216812-28872@https.bugzilla.kernel.org/>
References: <bug-216812-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216812

--- Comment #2 from Yang Lixiao (lixiao.yang@intel.com) ---
(In reply to Sean Christopherson from comment #1)
> KVM-unit-tests got ahead of KVM proper.  The test will fail until the KVM
> fixes[*] land.  That should happen sooner than later.
>=20
> [*] https://lore.kernel.org/all/20221001005915.2041642-1-seanjc@google.com

Thanks! We'll test this again when the fix patch gets merged.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
