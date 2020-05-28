Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93EF1E6114
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 14:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389788AbgE1MjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 08:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389734AbgE1Mit (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 08:38:49 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9669C05BD1E;
        Thu, 28 May 2020 05:38:49 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0be200b0299b2dfed8209e.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:e200:b029:9b2d:fed8:209e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 076D81EC02CF;
        Thu, 28 May 2020 14:38:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590669528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=0opdngyx2K/yyYLMUGP93EKBwY9KCD9g0UxDDXfrvcQ=;
        b=OTstkblyMvF224WY8T7jjseB4wM38dKW4H4F/RPxzwKpxlwqaUV8iXiCvcpbsYrOZlNn7p
        063TkMHt3P+ev+xJU6BTFKFiV7r5lABDEarM088hPKFm2ruuj0wHKLlSV/6wSVcYKcB6nw
        0T4+F+gnvXWLVPJcyikeGbz1M+l6ZTU=
Date:   Thu, 28 May 2020 14:38:42 +0200
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
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Doug Covelli <dcovelli@vmware.com>
Subject: Re: [PATCH v3 67/75] x86/vmware: Add VMware specific handling for
 VMMCALL under SEV-ES
Message-ID: <20200528123842.GA382@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-68-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-68-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:17:17PM +0200, Joerg Roedel wrote:
> From: Doug Covelli <dcovelli@vmware.com>
> 
> This change adds VMware specific handling for #VC faults caused by

s/This change adds/Add/

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
