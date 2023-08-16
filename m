Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED5377E397
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 16:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbjHPO3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 10:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343624AbjHPO3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 10:29:18 -0400
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835A72715
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 07:29:08 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9DA3140E0196;
        Wed, 16 Aug 2023 14:29:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jQmMiiMMq1-y; Wed, 16 Aug 2023 14:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1692196141; bh=1sKUdgXoUTJpuoi5n9A4j+BKFytAA60xeLBbqXRsoHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N/0TrEc+661lJfCOD2bnYVWQ7T5coXJhSJW+KWSjB+tXu+jLJo9+6s0R4prYr6O/B
         WzJ1cufIOF7OB08wcH0njq+SgZrwcLHfG1A+l58x32NGLbEfFU53ijOjlJMjc1dxqv
         WGTSHijlUfHItskuDCL+alwcv34xZLKBMMRDT6wK/g6XMz8EZ7xkOgIbqdHNrPzWn8
         lZWYvG5YRo87Wkz9G2G6QPewpefrnjUSHWKbx2baEwWnrEtn1yulWAhpSY5cvqGdvQ
         7ZXHaLVt4GyU0R/KTlgcFHHbr7T5B0Pyk3ojVTpR1OLLsCc94KK0HBIf+IGy0JhExT
         SudR+7kPW90ttHzwPtHrfR0OxqQO+gle/WLZiniZezyjft8cM/blfjsIlEZDOTz3/k
         GYwR66M9278UXAFa5nnN1kqfSNUv7HMi1eEGxm6i12aAYuOTL6BnksNCpsc954kf1p
         7p+ql/4LJKhwtrLcWpGQJgRCDT8TUARDALs4dM3WE/Po6ROZ04Wh4AkNB7zQEq8g8+
         DXYfZ54xDhBMfF8P0r8M6a5zcvWx94J1A8Dzm1yZUP5pSEnsI4CqbrwILwBTVMGFBG
         Su5kkf5dzAypHUvJISrXUQU1iCyoHYHlatLW3U/wHVg6ADvKSvPdj1x/2KrziYbJKV
         CRx5ZcAfDTrJLoayL/e8zJKk=
Received: from zn.tnic (pd9530d32.dip0.t-ipconnect.de [217.83.13.50])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BDBA940E0193;
        Wed, 16 Aug 2023 14:28:57 +0000 (UTC)
Date:   Wed, 16 Aug 2023 16:28:52 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mohammad Natiq Khan <natiqk91@gmail.com>, tglx@linutronix.de,
        kvm@vger.kernel.org
Subject: Re: [PATCH] kvm/mmu: fixed coding style issues
Message-ID: <20230816142852.GHZNzdJPS3JboQqwmT@fat_crate.local>
References: <20230815114448.14777-1-natiqk91@gmail.com>
 <ZNvIRS/YExLtGO2B@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZNvIRS/YExLtGO2B@google.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_BLOCKED,T_SPF_HELO_TEMPERROR,T_SPF_TEMPERROR,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023 at 11:47:33AM -0700, Sean Christopherson wrote:
> First and foremost, don't pack a large pile of unrelated changes into one large
> patch, as such a patch is annoyingly difficult to review and apply, e.g. this will
> conflict with other in-flight changes.
> 
> Second, generally speaking, the value added by cleanups like this aren't worth
> the churn to the code, e.g. it pollutes git blame.
> 
> Third, checkpatch is not the ultimately authority, e.g. IMO there's value in
> explicitly initializing nx_huge_pages_recovery_ratio to zero because it shows
> that it's *intentionally* zero for real-time kernels.
> 
> I'm all for opportunistically cleaning up existing messes when touching adjacent
> code, or fixing specific issues if they're causing actual problems, e.g. actively
> confusing readers.  But doing a wholesale cleanup based on what checkpatch wants
> isn't going to happen.

I think you should can this reply as is and paste it each time stuff
like that comes up. This is exactly what I'm preaching each time but
explained much better than me.

I'd even ask you for permission to quote it each time I get such
"cleanup" patches. :-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
