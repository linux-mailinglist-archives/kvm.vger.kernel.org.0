Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC2D3A6BD0
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 18:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhFNQcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 12:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbhFNQcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 12:32:42 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803BEC061574;
        Mon, 14 Jun 2021 09:30:39 -0700 (PDT)
Received: from zn.tnic (p200300ec2f09b900f41fb76786649a77.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:b900:f41f:b767:8664:9a77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0F3931EC04AD;
        Mon, 14 Jun 2021 18:30:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1623688238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=tVybpe3ScAdNUEPVEjHH5nE/bvfaoZC3CtL5wDnzh28=;
        b=GKv0VXZC8ntKpjSsSrPflcEj52On4dvo1oJIDtfRolgHrzN6dG5gdL9wTmcr4hlZ5a7RqJ
        AhBlZTQtj71lZYFdWOrrC737EXu9VLbqgCnDVQLdoo9ePecNx+as7DiJVCtQKa/wljqLfR
        jJR1zbJGXhnLi3x5TUT1Zgw8XWRwR8g=
Date:   Mon, 14 Jun 2021 18:30:35 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v5 2/6] x86/sev-es: Make sure IRQs are disabled while
 GHCB is active
Message-ID: <YMeEK5fiGA3QncAC@zn.tnic>
References: <20210614135327.9921-1-joro@8bytes.org>
 <20210614135327.9921-3-joro@8bytes.org>
 <YMeC7vJxm0OVJJhr@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YMeC7vJxm0OVJJhr@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 06:25:18PM +0200, Borislav Petkov wrote:
> ** underscored to mean, that callers need to disable local locks. There's
							     ^^^^^^

"interrupts" ofc.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
