Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC284DE82D
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 14:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243057AbiCSNhl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 09:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbiCSNhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 09:37:38 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038C82AA856;
        Sat, 19 Mar 2022 06:36:16 -0700 (PDT)
Received: from zn.tnic (p2e55dff8.dip0.t-ipconnect.de [46.85.223.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A0A611EC066E;
        Sat, 19 Mar 2022 14:36:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1647696971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xEictqK1V+OBjlNczjwbgnx58hOyKDLuDwqBTIQK1nw=;
        b=GYTxM8PltBVwgxy7+MjsO7hsoPzDvHfdoc6wY6u7E9V+zzlotdPpgqZfxJz+NiFcORcZah
        DlixYt0pwO4gsccbMwiwsOAhcfEWiVFeU0QioSUPlgMjOyZfivbjOuyOwiWHr29YHwkcII
        5jR1U3/mw6anuyUmlYTX+edelCAPkKc=
Date:   Sat, 19 Mar 2022 14:36:06 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jamie Heilman <jamie@audible.transient.net>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH -v1.2] kvm/emulate: Fix SETcc emulation function offsets
 with SLS
Message-ID: <YjXcRsR2T8WGnVjl@zn.tnic>
References: <YjHYh3XRbHwrlLbR@zn.tnic>
 <YjIwRR5UsTd3W4Bj@audible.transient.net>
 <YjI69aUseN/IuzTj@zn.tnic>
 <YjJFb02Fc0jeoIW4@audible.transient.net>
 <YjJVWYzHQDbI6nZM@zn.tnic>
 <20220316220201.GM8939@worktop.programming.kicks-ass.net>
 <YjMBdMlhVMGLG5ws@zn.tnic>
 <YjMS8eTOhXBOPFOe@zn.tnic>
 <YjMVpfe/9ldmWX8W@hirez.programming.kicks-ass.net>
 <94df38ce-6bd7-a993-7d9f-0a1418a1c8df@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <94df38ce-6bd7-a993-7d9f-0a1418a1c8df@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 19, 2022 at 02:24:06PM +0100, Paolo Bonzini wrote:
> Sorry for responding late, I was sick the past few days.  Go ahead and apply
> it to tip/x86/core with the rest of the SLS and IBT patches.  If you place
> it in front of the actual insertion of the INT3 it will even be bisectable,
> but I'm not sure if your commit hashes are already frozen.

I think they are and we need this fix in 5.17 where the SLS stuff went
in. I'll send it to Linus tomorrow.

> Just one thing:

Yeah, peterz can then do this ontop, before sending the IBT pile.

Thx for letting us know!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
