Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739535A9D5F
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 18:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbiIAQoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 12:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235110AbiIAQo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 12:44:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C8F98353
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 09:44:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ADDC61FBC
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 16:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 091E3C433B5
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 16:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662050663;
        bh=ZaNBOwOeRhtaWwjNFN88fKlW+mcdTmPIHIX+XQ3hcO8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ltVdE1BShiRVkoUDFwbtaUIHeTNQdGLqmCfbpb9SrIFsXc6kitpts0z3jmg8CXHwL
         aOqijl4AlELSmGhfjlaeuZXDoZCBje+gwLu5rEJQ9D3IRKdlDcGIAF/olpEm1ruQfF
         knn8R3dmTheP+sPJCmOX1IMf+5tPVZoQU+Px2HrFkFrn06XdXqx+ol3SEkHQwy8I3I
         za9VImIFJUWJ2h5HRJlkWaHhpGKV8uBdDx9GYD4sE+NCEVMeTrHcQNDz6NPLrr6JWP
         1PO3hklGv7V9Zrk9Hh7yAtsQb4POabSsZt33DHp1r/BbtqTCHfVB+hJ3PwIRorsIqk
         fZAjNW8hIo9Ew==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E92D6C433EA; Thu,  1 Sep 2022 16:44:22 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216388] On Host, kernel errors in KVM, on guests, it shows CPU
 stalls
Date:   Thu, 01 Sep 2022 16:44:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216388-28872-RARR7zoOz0@https.bugzilla.kernel.org/>
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

--- Comment #7 from Sean Christopherson (seanjc@google.com) ---
On Thu, Sep 01, 2022, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216388
>=20
> --- Comment #6 from Robert Dinse (nanook@eskimo.com) ---
> Installed 5.19.6 on a couple of machines today, still getting CPU stalls =
but
> in
> random locations:

...

>      Are these related or should I open a new ticket?  These occurred rig=
ht
> after boot.

Odds are very good that all of the stalls are due to one bug.  Stall warnin=
gs
fire
when a task or CPU waiting on an RCU grace period hasn't made forward progr=
ess
in
a certain amount of time.  In both cases, many times the CPU yelling that i=
t's
stalled is a victim and not the culprit, i.e. a stalled task/CPU often
indicates
that something is broken elsewhere in the system that is preventing forward
progress
on _this_ task/CPU.

Normally I would suggest bisecting, but given that v5.18 is broken for you =
that
probably isn't an option.

In the logs, are there any common patterns (beyond running KVM)?  E.g. any
functions
that show up in stack traces in all instances?  If nothing obvious jumps ou=
t,
it
might be worth uploading a pile of (compressed) traces somewhere so that ot=
hers
can
poke through them; maybe someone will find the needle.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
