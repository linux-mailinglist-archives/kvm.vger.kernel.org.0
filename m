Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771B934653E
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhCWQdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbhCWQdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:33:02 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FF6C061574;
        Tue, 23 Mar 2021 09:33:02 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0be1003a038ae7f2775171.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:e100:3a03:8ae7:f277:5171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 60A651EC0473;
        Tue, 23 Mar 2021 17:32:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616517179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ynniguAvocBA5TaZX6yhXh7I9tFvwuCf45CIvRLvQto=;
        b=dQ6yDPlDogaJF5WR37hi11J48ABmzpxWpsxDOBjR6ykFHO5C1U9GUuoMBGp/ee8gAzeaId
        M7zxsdU0/pDQCEnZHFApJX/SjXrC3+37Px8xw6VogO4ST7T3ToDK3aKlqfYQ1avrcLpi9i
        nJ0tnH5zH69UfjbEhv3sk4AAoSeM5PY=
Date:   Tue, 23 Mar 2021 17:32:58 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <20210323163258.GC4729@zn.tnic>
References: <YFjoZQwB7e3oQW8l@google.com>
 <20210322191540.GH6481@zn.tnic>
 <YFjx3vixDURClgcb@google.com>
 <20210322210645.GI6481@zn.tnic>
 <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
 <20210322223726.GJ6481@zn.tnic>
 <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
 <YFoNCvBYS2lIYjjc@google.com>
 <20210323160604.GB4729@zn.tnic>
 <YFoVmxIFjGpqM6Bk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YFoVmxIFjGpqM6Bk@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 04:21:47PM +0000, Sean Christopherson wrote:
> I like the idea of pointing at the documentation.  The documentation should
> probably emphasize that something is very, very wrong.

Yap, because no matter how we formulate the error message, it still ain't enough
and needs a longer explanation.

> E.g. if a kernel bug triggers EREMOVE failure and isn't detected until
> the kernel is widely deployed in a fleet, then the folks deploying the
> kernel probably _should_ be in all out panic. For this variety of bug
> to escape that far, it means there are huge holes in test coverage, in
> both the kernel itself and in the infrasturcture of whoever is rolling
> out their new kernel.

You sound just like someone who works at a company with a big fleet, oh
wait...

:-)

And yap, you big fleeted guys will more likely catch it but we do have
all these other customers who have a handful of servers only so they
probably won't be able to do such a wide coverage.

So I hope they'll appreciate this longer explanation about what to do
when they hit it. And normally I wouldn't even care but we almost never
tell people to reboot their boxes to fix sh*t - that's the other OS.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
