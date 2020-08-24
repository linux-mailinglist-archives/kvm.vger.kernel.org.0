Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07E724FBD5
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 12:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgHXKpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 06:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgHXKpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 06:45:03 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58A6C061573;
        Mon, 24 Aug 2020 03:45:02 -0700 (PDT)
Received: from zn.tnic (p200300ec2f07f0001d1adc8210ec988a.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:f000:1d1a:dc82:10ec:988a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D6E3B1EC0104;
        Mon, 24 Aug 2020 12:44:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598265899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=iXpxuVriWvU3M3aiYmzDwnWWzJtCErVklAPMKOlDAEk=;
        b=fS2e3eFO6CT56yvF10hoqjXs05VZge7E7YK1yU71Tg6skRgdi5uFdlZePV2aXb+A2JVG8w
        LyNrQAcyd0zTiPuZS95AOdUdLmUxPHPWU6WBmtTXBqKg/pnqunuyP9VEdcHY9yhudf1fd1
        xRi8B0HFEmL11S+NQIPPeaaVRUJeIPI=
Date:   Mon, 24 Aug 2020 12:44:51 +0200
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
Message-ID: <20200824104451.GA4732@zn.tnic>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-3-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824085511.7553-3-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 10:53:57AM +0200, Joerg Roedel wrote:
>  static inline void __unused_size_checks(void)
>  {
> -	BUILD_BUG_ON(sizeof(struct vmcb_save_area) != 0x298);
> +	BUILD_BUG_ON(sizeof(struct vmcb_save_area) != 1032);
>  	BUILD_BUG_ON(sizeof(struct vmcb_control_area) != 256);
> +	BUILD_BUG_ON(sizeof(struct ghcb) != 4096);

Could those naked numbers be proper, meaningfully named defines?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
