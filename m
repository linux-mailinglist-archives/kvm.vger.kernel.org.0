Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8037A1C3749
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 12:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgEDKyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 06:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726756AbgEDKyv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 06:54:51 -0400
X-Greylist: delayed 7673 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 04 May 2020 03:54:51 PDT
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D57C061A0E;
        Mon,  4 May 2020 03:54:51 -0700 (PDT)
Received: from zn.tnic (p200300EC2F08AF00A9258889345EFBFA.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:af00:a925:8889:345e:fbfa])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 186691EC01B7;
        Mon,  4 May 2020 12:54:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1588589689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=w0w3Aijj1ra8KuzYyt1lCImYJX1LTveNb8GK18SLIV8=;
        b=rqNi/B7JopqCWzjGwcJ5p0oW/TBH05ZbVhoihYn39t8uzH1svqnE+WbsRjmueARw0snG9X
        g8MoCy2QqIO3W8ZY1BmYKAHZBQHonH+4BnHd+hGZBog4Jj0/Eb2jL6peqM/RZWpBF5P28q
        bc0obY45bX1B8fyESNsvitlXbp6EVts=
Date:   Mon, 4 May 2020 12:54:45 +0200
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
Subject: Re: [PATCH v3 13/75] x86/boot/compressed/64: Add IDT Infrastructure
Message-ID: <20200504105445.GE15046@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-14-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-14-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:23PM +0200, Joerg Roedel wrote:
> diff --git a/arch/x86/boot/compressed/idt_handlers_64.S b/arch/x86/boot/compressed/idt_handlers_64.S
> new file mode 100644
> index 000000000000..f86ea872d860
> --- /dev/null
> +++ b/arch/x86/boot/compressed/idt_handlers_64.S
> @@ -0,0 +1,69 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Early IDT handler entry points
> + *
> + * Copyright (C) 2019 SUSE
> + *
> + * Author: Joerg Roedel <jroedel@suse.de>
> + */
> +
> +#include <asm/segment.h>
> +
> +#include "../../entry/calling.h"

Leftover from something? Commenting it out doesn't break the build here.

If needed, then we need to lift stuff in a separate header and share it
or so. I want to include as less as possible crap from kernel proper and
eventually untangle arch/x86/boot/ because include/linux/ definitions
are a real pain.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
