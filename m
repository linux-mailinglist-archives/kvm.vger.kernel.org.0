Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8995380458
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 09:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbhENHe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 03:34:56 -0400
Received: from mail.skyhub.de ([5.9.137.197]:58480 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230268AbhENHe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 03:34:56 -0400
Received: from zn.tnic (p200300ec2f0b2c00f343c5c4aba7bf62.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:2c00:f343:c5c4:aba7:bf62])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 17C141EC04DA;
        Fri, 14 May 2021 09:33:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1620977624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=6YHheJrR0MVNkYYmjJk9WVsrgasiEluyOrr1L77kfxU=;
        b=qEa7GwAyKjQPYHDVZCVUQusCEMY2bwpsDZIFQ1zOjASxNqnP0X1Yw58Ig0ewDk+zJpUUMu
        KkEByeipbkGdVAswkaalOCryTWG+PR7thYH8KwCtcslDd4P33l8Nt8zj2n5Rkxo1Qr67hT
        ThtrW35pEF07JyqALoRDtvViZJPaKRg=
Date:   Fri, 14 May 2021 09:33:45 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <YJ4n2Ypmq/7U1znM@zn.tnic>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic>
 <20210513043441.GA28019@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210513043441.GA28019@ashkalra_ubuntu_server>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 13, 2021 at 04:34:41AM +0000, Ashish Kalra wrote:
> What's the use of notification of a partial page list, even a single
> incorrect guest page encryption status can crash the guest/migrated
> guest.

Ok, so explain to me how this looks from the user standpoint: she starts
migrating the guest, it fails to lookup an address, there's nothing
saying where it failed but the guest crashed.

Do you think this is user-friendly?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
