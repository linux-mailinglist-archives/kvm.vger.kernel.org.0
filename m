Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F216251707
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 13:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbgHYLEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 07:04:49 -0400
Received: from mail.skyhub.de ([5.9.137.197]:54788 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729529AbgHYLEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 07:04:47 -0400
Received: from zn.tnic (p200300ec2f0c5a0001535c65a93122e2.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:5a00:153:5c65:a931:22e2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AEAED1EC0299;
        Tue, 25 Aug 2020 13:04:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598353485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=M3DtE2HDJMaftMHgyeELlhmPqaW7/VgBKsyLltgJBkY=;
        b=bLUbdTQqHXoJunltKk2lQ/8OSisXCWByt7CjiA/EG6fD8SiJ5w8owNkA/vwdkjt0o4JFdA
        hGvlX4TGZXnuGdSGbqcreYTAKxVCmwrnxnfiD+buOP9AE9EAlLGjP+eSW+W3udaoPbTYYn
        Xst5bBJiQsVyCEm46KyE3CCo0pkdJqA=
Date:   Tue, 25 Aug 2020 13:04:46 +0200
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
Subject: Re: [PATCH v6 02/76] KVM: SVM: Add GHCB definitions
Message-ID: <20200825110446.GC12107@zn.tnic>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-3-joro@8bytes.org>
 <20200824104451.GA4732@zn.tnic>
 <20200825092224.GF3319@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200825092224.GF3319@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 25, 2020 at 11:22:24AM +0200, Joerg Roedel wrote:
> I don't think so, if I look at the history of these checks their whole
> purpose seems to be to alert the developer/maintainer when their size
> changes and that they might not fit on the stack anymore. But that is
> taken care of in patch 1.

Why? What's wrong with:

	BUILD_BUG_ON(sizeof(struct vmcb_save_area) != VMCB_SAVE_AREA_SIZE);
	BUILD_BUG_ON(sizeof(struct vmcb_control_area) != VMCB_CONTROL_AREA_SIZE);
	BUILD_BUG_ON(sizeof(struct ghcb) != PAGE_SIZE);

?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
