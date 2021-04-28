Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7A136D684
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 13:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239098AbhD1Ldq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 07:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhD1Ldq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 07:33:46 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979ABC061574;
        Wed, 28 Apr 2021 04:33:01 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0c1700f2e32bd17c928af7.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:1700:f2e3:2bd1:7c92:8af7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 313591EC01A8;
        Wed, 28 Apr 2021 13:33:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1619609580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=8LlAlHYiEHvMeLvZuxUAy4pQdQCjs4uJqF+0x/JuK4A=;
        b=SoxO9toNPDi6HVVTVwhiXU5zYoEmrjmLJzfc0UxT0369B83l7wkQdj6C/3p8C+SlRgSXJ9
        91TE+LJTfhhfQ8DaPSX/8cKyP36aPfh2QB2ZQqCpgM/vLu0Gm98U+1UNHLRb4Ofu3++wtI
        VFZIjaC3OisatjRRyghEhVo1iT30nCs=
Date:   Wed, 28 Apr 2021 13:33:03 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/3] x86/msr: Rename MSR_K8_SYSCFG to MSR_AMD64_SYSCFG
Message-ID: <YIlH79b1KSHbSYSI@zn.tnic>
References: <20210427111636.1207-1-brijesh.singh@amd.com>
 <20210427111636.1207-4-brijesh.singh@amd.com>
 <YIk8c+/Vwf30Fh6G@zn.tnic>
 <9e687194-5b68-9b4c-bf7f-0914e656d08f@redhat.com>
 <YIlGvdxZVa0kiJf4@zn.tnic>
 <8dee542f-889f-ab38-80cf-214af2fcd369@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8dee542f-889f-ab38-80cf-214af2fcd369@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 01:30:38PM +0200, Paolo Bonzini wrote:
> Yes, upstream.

Ok, I'll send it to Linus for -rc2.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
