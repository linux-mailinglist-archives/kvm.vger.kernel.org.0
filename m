Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB21636D66C
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 13:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238486AbhD1L2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 07:28:44 -0400
Received: from mail.skyhub.de ([5.9.137.197]:33800 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230420AbhD1L2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 07:28:44 -0400
Received: from zn.tnic (p200300ec2f0c1700f2e32bd17c928af7.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:1700:f2e3:2bd1:7c92:8af7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 868B61EC01A8;
        Wed, 28 Apr 2021 13:27:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1619609278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=wX0F+YaUrQZGJ7PeYw9w/V7McHBNPDBXSLDgSyYC7J0=;
        b=ZYf/SAZqE+aSmtpLJSFVWkaTmQ05yy0NKNXpwJgpmxxGUxOhpubhMst0d8XuV9RnNwkJ/p
        RJI5buJf0DqMmBHzk0OYqgrpxVeXpA7k5emgBYoFTH3qFRmK+vSMnY+TGWuLGk7qoIEmlM
        ZOjGoDexB+s7ejNsxmDbKwrfumLfDEc=
Date:   Wed, 28 Apr 2021 13:27:57 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/3] x86/msr: Rename MSR_K8_SYSCFG to MSR_AMD64_SYSCFG
Message-ID: <YIlGvdxZVa0kiJf4@zn.tnic>
References: <20210427111636.1207-1-brijesh.singh@amd.com>
 <20210427111636.1207-4-brijesh.singh@amd.com>
 <YIk8c+/Vwf30Fh6G@zn.tnic>
 <9e687194-5b68-9b4c-bf7f-0914e656d08f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9e687194-5b68-9b4c-bf7f-0914e656d08f@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 12:55:26PM +0200, Paolo Bonzini wrote:
> There shouldn't be any conflicts right now, but perhaps it's easiest to
> merge the whole series for -rc2.

You mean, merge it upstream or into tip? I think you mean upstream
because then it would be easy for everyone to base new stuff ontop.

> In any case,
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
