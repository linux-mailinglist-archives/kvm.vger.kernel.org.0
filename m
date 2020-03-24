Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBAB4190D5C
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 13:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgCXM0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 08:26:12 -0400
Received: from mail.skyhub.de ([5.9.137.197]:43740 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727405AbgCXM0M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 08:26:12 -0400
Received: from zn.tnic (p200300EC2F0BC80031BBC3D65DB1D839.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:c800:31bb:c3d6:5db1:d839])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7F95F1EC0CE5;
        Tue, 24 Mar 2020 13:26:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1585052770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=EvmDuxiEfERPSqBbso520E6sI1h5GzZBXkFBzhDHVnA=;
        b=mqdDvsTwQjUWDIGUcDr1DDVg2lETqWtz3WNyWw2T2a3b972zUndoX8/EZ5tLo8wz6sw9Dt
        ooEZq3SMDFphzGwWef0Lm+gzciAX0HSEW9cXFwSfkLbKVPEAVazrY/D+a4LFzWX9C3AEcA
        wxv2bno1sT1nuVZQT8tlUNuANNQccgc=
Date:   Tue, 24 Mar 2020 13:26:03 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Paul McKenney <paulmck@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [RESEND][patch V3 03/23] vmlinux.lds.h: Create section for
 protection against instrumentation
Message-ID: <20200324122603.GD22931@zn.tnic>
References: <20200320175956.033706968@linutronix.de>
 <20200320180032.708673769@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200320180032.708673769@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just typos:

On Fri, Mar 20, 2020 at 06:59:59PM +0100, Thomas Gleixner wrote:
> Some code pathes, especially the low level entry code, must be protected

s/pathes/paths/

> against instrumentation for various reasons:
> 
>  - Low level entry code can be a fragile beast, especially on x86.
> 
>  - With NO_HZ_FULL RCU state needs to be established before using it.
> 
> Having a dedicated section for such code allows to validate with tooling
> that no unsafe functions are invoked.
> 
> Add the .noinstr.text section and the noinstr attribute to mark
> functions. noinstr implies notrace. Kprobes will gain a section check
> later.
> 
> Provide also two sets of markers:
> 
>  - instr_begin()/end()
> 
>    This is used to mark code inside in a noinstr function which calls

s/in //

>    into regular instrumentable text section as safe.
> 
>  - noinstr_call_begin()/end()
> 
>    Same as above but used to mark indirect calls which cannot be tracked by
>    tooling and need to be audited manually.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
