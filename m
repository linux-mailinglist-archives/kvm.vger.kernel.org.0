Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7362539040C
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 16:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbhEYOhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 10:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbhEYOgn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 10:36:43 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C30C06138A;
        Tue, 25 May 2021 07:35:10 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0c1b002b4a52bfc593708c.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:1b00:2b4a:52bf:c593:708c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 60C951EC0249;
        Tue, 25 May 2021 16:35:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621953309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=PAgkolG6DwD2zkh8EhJ7Cl3z5HYEPXeJDA7oj+WGRBs=;
        b=pZlQRin5CVsOAPH7z1HRDPPBveVQ4hT7RktkSGY/sLjQeUL6MWc54Bc0w1wTtqDAJgvJs+
        Xjj4p18JOPK9aOzyusQzt9IX5UrtE2d+iuY8hhLnjycw4AIM0b5JglxBP0OHNqK9NZGANp
        eHIlOHnFXP4GpTTitpk6kC7TrpUvi9Y=
Date:   Tue, 25 May 2021 16:35:02 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 13/20] x86/sev: Register GHCB memory when
 SEV-SNP is active
Message-ID: <YK0LFk3xMjfirG9E@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-14-brijesh.singh@amd.com>
 <YKzbfwD6nHL7ChcJ@zn.tnic>
 <b15cd25b-ee69-237d-9044-84fba2cf4bb2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b15cd25b-ee69-237d-9044-84fba2cf4bb2@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021 at 09:28:14AM -0500, Brijesh Singh wrote:
> I am not ignoring your valuable feedback; I am sorry if I came across
> like that.

Sure, no worries, but you have to say something when you don't agree
with the feedback. How am I supposed to know?

> In this particular case, the snp_register_ghcb() is shared between the
> decompress and main kernel. The variable data->snp_ghcb_registered is
> not visible in the decompressed path,

Why is it not visible?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
