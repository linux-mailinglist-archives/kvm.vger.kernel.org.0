Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A417D1F7896
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 15:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgFLNN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jun 2020 09:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgFLNN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jun 2020 09:13:27 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C15C03E96F;
        Fri, 12 Jun 2020 06:13:27 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0af400dccdc80c995f3217.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:f400:dccd:c80c:995f:3217])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 894911EC01A9;
        Fri, 12 Jun 2020 15:13:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1591967604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=DsvqJyEz3c+fQ4fmS3IX+gLIofqDO5nOeVm97sEGSH8=;
        b=RPbVDGwr/yzQzyYkPbghXlo+7iL+8yyNf7noWO/fmGVTLdUqkaVwfBP6LzQOnaOTvJaryV
        r5ezwR4WDXFDbN2NrwxXc1D7MashxM3lO8irNJBHvjtSe0gKW15CArzWVJ9BdAGti5mDgl
        jdtLCJrP0WHvVVYW8e/PjGcTWptmQfI=
Date:   Fri, 12 Jun 2020 15:13:19 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 47/75] x86/sev-es: Add Runtime #VC Exception Handler
Message-ID: <20200612131310.GB22660@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-48-joro@8bytes.org>
 <20200523075924.GB27431@zn.tnic>
 <20200611114831.GA11924@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200611114831.GA11924@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 01:48:31PM +0200, Joerg Roedel wrote:
> The most important use-case is #VC->NMI->#VC. When an NMI hits while the
> #VC handler uses the GHCB and the NMI handler causes another #VC, then
> the contents of the GHCB needs to be backed up, so that it doesn't
> destroy the GHCB contents of the first #VC handling path.

That's a good example, please add it to the next version of the patch,
preferrably in a comment somewhere.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
