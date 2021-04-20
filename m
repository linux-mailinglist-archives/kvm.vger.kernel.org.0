Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB96365632
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhDTKdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 06:33:08 -0400
Received: from mail.skyhub.de ([5.9.137.197]:45190 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231483AbhDTKdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 06:33:07 -0400
Received: from zn.tnic (p200300ec2f0e52003145dfcc247b909a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:5200:3145:dfcc:247b:909a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B14571EC0493;
        Tue, 20 Apr 2021 12:32:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618914754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=LGlj8lRJz+SPsOL8uJcJVyAOvDYjlgCJmNEQuzlGc/E=;
        b=FxuVjro6e1oHuXB+ZgbsmiMNF90SvQSSIXUMTqoy9Bg7t6+ujwIZWRqzRW0oJQJWeOS7iX
        xGypOF48vkaGHVTHSvrUChLx4lvzIdCF0Q939Hi3k6LCE7tuPD8KsedH34uHFRuJKt6e6t
        UH5SztOjCJYOY3aHEZ16KD2deNBpNW8=
Date:   Tue, 20 Apr 2021 12:32:32 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak@linux.intel.com,
        herbert@gondor.apana.org.au, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 05/30] x86: define RMP violation #PF error code
Message-ID: <20210420103232.GG5029@zn.tnic>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-6-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324170436.31843-6-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 12:04:11PM -0500, Brijesh Singh wrote:

Btw, for all your patches where the subject prefix is only "x86:":

The tip tree preferred format for patch subject prefixes is
'subsys/component:', e.g. 'x86/apic:', 'x86/mm/fault:', 'sched/fair:',
'genirq/core:'. Please do not use file names or complete file paths as
prefix. 'git log path/to/file' should give you a reasonable hint in most
cases.

The condensed patch description in the subject line should start with a
uppercase letter and should be written in imperative tone.

Please go over them and fix that up.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
