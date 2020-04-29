Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56471BD936
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 12:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgD2KMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 06:12:08 -0400
Received: from mail.skyhub.de ([5.9.137.197]:53634 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgD2KMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 06:12:08 -0400
Received: from zn.tnic (p200300EC2F0B9500F107CEE1E1E2B6BF.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:9500:f107:cee1:e1e2:b6bf])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C04EA1EC0C77;
        Wed, 29 Apr 2020 12:12:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1588155126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=UviBV7inINNgWwyNlp0J3VsTpyBiFbzHdo8Vf/vD5Ms=;
        b=gm8lL11K9imgad9xdruO0T6EvtM5bgwa+iYNLuRFe+vyt4TK07Vasbu5aghGPXtOYje5yK
        1FA/b1KbL4VVezoyfBQljRRz1XFjqcAbojUYHC+BOlfO+9OM6V6wqpDH99Ofy4YKsycO7r
        OGJmHhbmfWv0aeUs2uginzoK7FgdecY=
Date:   Wed, 29 Apr 2020 12:12:01 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 03/75] KVM: SVM: Use __packed shorthand
Message-ID: <20200429101201.GB16407@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-4-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-4-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:13PM +0200, Joerg Roedel wrote:
> From: Borislav Petkov <bp@alien8.de>
> 
> I guess we can do that ontop.

The proper commit message was:

"... to make it more readable.

No functional changes."

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
