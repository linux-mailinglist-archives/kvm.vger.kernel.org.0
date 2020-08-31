Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FA2257DE2
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 17:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgHaPr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 11:47:27 -0400
Received: from mail.skyhub.de ([5.9.137.197]:54564 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726927AbgHaPr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 11:47:26 -0400
Received: from zn.tnic (p200300ec2f085000329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:5000:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ABBFA1EC0428;
        Mon, 31 Aug 2020 17:47:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598888843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=rWtRZ4hfzr7qKnP/HFeh64B+sglziA9JXIexmTro33Y=;
        b=CAU0FQ0B1Tz+HDK12bpJUpmpyUbpMGCmGPg+UgsIIQtXUhRXxJ80MSIt0uMvMTdu9H3VSx
        +udnSPwHwwiXAKFZJTnB6Ww89cVrHYMNIyAuy7YPSVJ8ssDKbroIBNch+C24/R4nh5vxmr
        HI6S0W3EQ3P6uGg3Tsq8M6+CUEdi2Lk=
Date:   Mon, 31 Aug 2020 17:47:19 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 52/76] x86/sev-es: Handle MMIO events
Message-ID: <20200831154719.GI27517@zn.tnic>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-53-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824085511.7553-53-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 10:54:47AM +0200, Joerg Roedel wrote:
> +		if (bytes == 4)
> +			*reg_data = 0;  /* Zero-extend for 32-bit operation */

Please put all side-comments over the respective line. There are a
couple in this patch.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
