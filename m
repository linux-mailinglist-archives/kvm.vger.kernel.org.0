Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E101D11B5
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 13:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbgEMLqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 07:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgEMLqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 07:46:39 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505A8C061A0C;
        Wed, 13 May 2020 04:46:39 -0700 (PDT)
Received: from zn.tnic (p200300EC2F0AC300A0B029A08DBD019D.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:c300:a0b0:29a0:8dbd:19d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 473AC1EC0330;
        Wed, 13 May 2020 13:46:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1589370397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=euj2zi24Uj3leIrpx0insV4176ao8ao6nc3wRKwDosc=;
        b=ArE0U+8MeibbTsaC8/2kOx7cnQiO9Cv2Cp0QzXJfoHMCFkiSp0a15+38EqiJNMgzw11Xn0
        y+D7M3OHFL/8Jbj9aVmU6vvmkxeCEOXoViqE54KJI3pHn8sctpNby9E8L//MUXeh/7MgyI
        PmlIWGJtrSTKzuvUhODOpsyRRMUzaRc=
Date:   Wed, 13 May 2020 13:46:33 +0200
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
Subject: Re: [PATCH v3 24/75] x86/boot/compressed/64: Unmap GHCB page before
 booting the kernel
Message-ID: <20200513114633.GE4025@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-25-joro@8bytes.org>
 <20200513111340.GD4025@zn.tnic>
 <20200513113011.GG18353@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200513113011.GG18353@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 13, 2020 at 01:30:11PM +0200, Joerg Roedel wrote:
> Yeah, I had this this way in v2, but changed it upon you request[1] :)

Yeah, I was wondering why this isn't a separate function - you like them
so much. :-P

> [1] https://lore.kernel.org/lkml/20200402114941.GA9352@zn.tnic/

But that one didn't have the ghcb_fault check. Maybe it was being added
later... :)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
