Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2405419836
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbhI0PuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 11:50:04 -0400
Received: from mail.skyhub.de ([5.9.137.197]:46876 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235313AbhI0PuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 11:50:02 -0400
Received: from zn.tnic (p200300ec2f088a0026c8b82ffc70c2f8.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:8a00:26c8:b82f:fc70:c2f8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 791D51EC0345;
        Mon, 27 Sep 2021 17:48:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632757699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sXB97txbGpnndRLiF8a7c6AhXwkwZfB4h+OruKiOVBI=;
        b=OvgISGSXj2zbL3ZADKNFzZ7IzN588OYvgnYadirFN06DFJeAmH+bMcaSkWvDArys2SPDuP
        Rv3+CNZvch66OafJlP73tpJSJukKX00bjPHHxxbUNFdrz0yM9x6XNIWQ1ry5tikWaxwIJU
        o+cFdkRlL6Ycck9gMxDBuLyQkRzeCSs=
Date:   Mon, 27 Sep 2021 17:48:18 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tony.luck@intel.com, peterz@infradead.org,
        kyung.min.park@intel.com, wei.huang2@amd.com, jgross@suse.com,
        andrew.cooper3@citrix.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Expose Predictive Store Forwarding Disable
Message-ID: <YVHnwosFG5UbufEz@zn.tnic>
References: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
 <YVGkDPbQmdwSw6Ff@zn.tnic>
 <fcbbdf83-128a-2519-13e8-1c5d5735a0d2@redhat.com>
 <YVGz0HXe+WNAXfdF@zn.tnic>
 <bcd40d94-2634-a40c-0173-64063051a4b2@redhat.com>
 <YVG46L++WPBAHxQv@zn.tnic>
 <afc34b38-5596-3571-63e5-55fe82e87f6c@redhat.com>
 <14993859-b953-b833-cdf2-ff2e29e9044d@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <14993859-b953-b833-cdf2-ff2e29e9044d@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 10:47:01AM -0500, Babu Moger wrote:
> > There are other guests than Linux.  This patch is just telling userspace
> 
> Yes, That is the reason for this patch.

And can you share, per chance, what their use case is?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
