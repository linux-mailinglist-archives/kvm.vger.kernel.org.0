Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BCC58F8EB
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 10:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbiHKISM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 04:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbiHKISK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 04:18:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67B990187
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 01:18:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B27C61536
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 08:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D97ADC433C1
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 08:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660205888;
        bh=tAXY67C5rjw1mWX2P4Pz3srXVuIO2IQ3wxrf4FcXHWs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Gi1ZIihERKUznv3jO+UDLqx3GvbYwYNAnmajOiN1g0M/6h19Khqs0kzjAZnX/EZ/9
         DHDvCxWzKA3dwIeGC9ksDqkpeol76RvwYkklCcQCtCg9gyddq29JMbsAkITxeW4d6G
         oBZ4WXUngNJK900CWZ9JJqWyxozWAxyn0+4fDZpkgEsDA0N+BOLZ0oNcF6shhb0D58
         +RJV4PHKhj3aHojAig/AfHweOxMyouqpHl2gVqb7J4NC87ZGrbNdX/o5tRGzXRsJdb
         IuS6ZcmKszkEZ2/tlYe0T+fjL369k0PCd6ct/2k1JHJA20Zi9OodoAEoeF6C2tqCr5
         +ezBjVKTmNb8A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C5F13C433E4; Thu, 11 Aug 2022 08:18:08 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] Kernel panic in a Ubuntu VM running on Proxmox
Date:   Thu, 11 Aug 2022 08:18:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dgilbert@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216349-28872-Mpm4Dre2sy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216349-28872@https.bugzilla.kernel.org/>
References: <bug-216349-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216349

--- Comment #6 from Dr. David Alan Gilbert (dgilbert@redhat.com) ---
Hi John,
  Thanks - hmm ok, if it's not migration it's unlikely the one I'm working =
on.
I doubt changing to q35 will make much odds.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
