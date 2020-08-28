Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B501255D94
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 17:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgH1PQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 11:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgH1PQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 11:16:20 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9DBC061264;
        Fri, 28 Aug 2020 08:16:19 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ba600cd7838aec083f6d5.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:a600:cd78:38ae:c083:f6d5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 944A81EC02B9;
        Fri, 28 Aug 2020 17:16:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598627777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=meDwPOYTdd66T0vfwRFtMe688dT0+BMttG7+4yclsTQ=;
        b=XUALlOcx2zHv1DJKkc6oXIOLCMHUY1mZHaAjbPaB7YVQdNjsJLwQgJzU5K5CRagOMDH3hl
        3FsyQfYAAmB+9nG4T0bEp6DVzI9Oil9Dc+/F/hkJ+LzDJBEn2ptVVXoBtmZaaZC+AEjoFJ
        eGyvtTUPt0etAek6KaT7XY8gDWITvIk=
Date:   Fri, 28 Aug 2020 17:16:20 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 29/76] x86/idt: Split idt_data setup out of
 set_intr_gate()
Message-ID: <20200828151620.GA19342@zn.tnic>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-30-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824085511.7553-30-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 10:54:24AM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The code to setup idt_data is needed for early exception handling, but
> set_intr_gate() can't be used that early because it has pv-ops in its
> code path, which don't work that early.
> 
> Split out the idt_data initialization part from set_intr_gate() so
> that it can be used separatly.

"separately"

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
