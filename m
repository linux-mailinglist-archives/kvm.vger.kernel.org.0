Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9624536D5E6
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 12:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239520AbhD1Kox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 06:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhD1Kox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 06:44:53 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736FBC061574;
        Wed, 28 Apr 2021 03:44:07 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0c1700f2e32bd17c928af7.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:1700:f2e3:2bd1:7c92:8af7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C20C51EC0322;
        Wed, 28 Apr 2021 12:44:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1619606645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=lBrju1qbixnLlI1V4uj5L7FO3iwVy9ft7r7H5DCKOTA=;
        b=NzvtHNxDXt6FWeOuS/gtoH8QcJOCgowzZo6y7N1uPSJjGNlGMl/XCpna/hMTV0sum2obua
        fLMVvEU6jPi77x4LLmKtBT6ra5TV5ysQGg50vSCNuIS1IXs6JtQMmvYGNyyEbqtF8HshA4
        vBn0sTMLOudDkjf+2Hrp5DEsszpIhl4=
Date:   Wed, 28 Apr 2021 12:44:03 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     x86@kernel.org, tglx@linutronix.de, jroedel@suse.de,
        thomas.lendacky@amd.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 3/3] x86/msr: Rename MSR_K8_SYSCFG to MSR_AMD64_SYSCFG
Message-ID: <YIk8c+/Vwf30Fh6G@zn.tnic>
References: <20210427111636.1207-1-brijesh.singh@amd.com>
 <20210427111636.1207-4-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210427111636.1207-4-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 06:16:36AM -0500, Brijesh Singh wrote:
> The SYSCFG MSR continued being updated beyond the K8 family; drop the K8
> name from it.
> 
> Suggested-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---

Thanks, looks good.

>  Documentation/virt/kvm/amd-memory-encryption.rst | 2 +-
>  Documentation/x86/amd-memory-encryption.rst      | 6 +++---
>  arch/x86/include/asm/msr-index.h                 | 6 +++---
>  arch/x86/kernel/cpu/amd.c                        | 4 ++--
>  arch/x86/kernel/cpu/mtrr/cleanup.c               | 2 +-
>  arch/x86/kernel/cpu/mtrr/generic.c               | 4 ++--
>  arch/x86/kernel/mmconf-fam10h_64.c               | 2 +-
>  arch/x86/kvm/svm/svm.c                           | 4 ++--
>  arch/x86/kvm/x86.c                               | 2 +-

The kvm side needs sync with Paolo on how to handle so that merge
conflicts are minimized.

Paolo, thoughts?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
