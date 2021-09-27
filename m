Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48CE4193CF
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 14:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbhI0MIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 08:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbhI0MI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 08:08:29 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3B3C061575;
        Mon, 27 Sep 2021 05:06:51 -0700 (PDT)
Received: from zn.tnic (p200300ec2f088a001ce91a9f1eb42005.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:8a00:1ce9:1a9f:1eb4:2005])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4652F1EC034B;
        Mon, 27 Sep 2021 14:06:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632744406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=fnzIy7z5nELIJDftnAE2ClbndYkwUROx0yEZJD+4zwQ=;
        b=D3aTcAETUPoOq5c3TFgiqcuq4KxHukT2QcueH57GbqCHU3+DrKErqTl/r074Ip8jvUkPM5
        1GXZw72qAAaEYJoAKUhM/pnUr/+tsxm+Qcy4+n8PQfDoOOQ3MEHWHnsd+TNcCSWAaP4+rr
        JSA0ZHh0PbjJY7ZNdn5KchDeMhk+Ufw=
Date:   Mon, 27 Sep 2021 14:06:40 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Babu Moger <babu.moger@amd.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tony.luck@intel.com, peterz@infradead.org,
        kyung.min.park@intel.com, wei.huang2@amd.com, jgross@suse.com,
        andrew.cooper3@citrix.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Expose Predictive Store Forwarding Disable
Message-ID: <YVGz0HXe+WNAXfdF@zn.tnic>
References: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
 <YVGkDPbQmdwSw6Ff@zn.tnic>
 <fcbbdf83-128a-2519-13e8-1c5d5735a0d2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fcbbdf83-128a-2519-13e8-1c5d5735a0d2@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 01:13:26PM +0200, Paolo Bonzini wrote:
> Because the guest kernel needs to know which MSRs to write when you touch
> the SSBD prctl, so that PSFD is properly disabled *inside the guest*.

It already knows which - the same one which disables SSB. PSF is
disabled *together* with SSB, for now...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
