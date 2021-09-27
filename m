Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC5D419535
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 15:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbhI0Nkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 09:40:41 -0400
Received: from mail.skyhub.de ([5.9.137.197]:55702 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234557AbhI0Nkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 09:40:40 -0400
Received: from zn.tnic (p200300ec2f088a003e7a3db711c29d58.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:8a00:3e7a:3db7:11c2:9d58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 15AF71EC013E;
        Mon, 27 Sep 2021 15:38:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632749937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=VSilXSaUsjcqTdHj0wHV0zcv+Rs1cnoXDIbeePx4zfM=;
        b=hzSAi7KRv/M0gqs5truYx7MvEqByYxNidg7nQzGNSiJY0Yu7bvX+aMb4IImeIMFAKXG2hA
        1X6s6lkqvrO6mDD0WYPYOWUg382xagbGwTjiiqc7H8wbE+2J71JGzRga7uf97IH5TlMop4
        +rGksarvdVyDi2H3n9gEWAfqQ6D/uBE=
Date:   Mon, 27 Sep 2021 15:38:51 +0200
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
Message-ID: <YVHJa63c4eFygCOg@zn.tnic>
References: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
 <YVGkDPbQmdwSw6Ff@zn.tnic>
 <fcbbdf83-128a-2519-13e8-1c5d5735a0d2@redhat.com>
 <YVGz0HXe+WNAXfdF@zn.tnic>
 <bcd40d94-2634-a40c-0173-64063051a4b2@redhat.com>
 <YVG46L++WPBAHxQv@zn.tnic>
 <afc34b38-5596-3571-63e5-55fe82e87f6c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <afc34b38-5596-3571-63e5-55fe82e87f6c@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 02:54:08PM +0200, Paolo Bonzini wrote:
> There are other guests than Linux.  This patch is just telling userspace
> that KVM knows what the PSFD bit is.  It is also possible to expose the bit
> in KVM without having any #define in cpufeatures.h

Ok, then there's no need for the cpufeatures.h hunk.

> or without the kernel using it. For example KVM had been exposing
> FSGSBASE long before Linux supported it.

Ok, please do that for now then, if you want to expose it to other
guests. I'm sceptical they will have a use case for it either but I'm
always open to suggestions.

For the same reason as for baremetal, though, I wouldn't do that and do
that solely through the SSBD control but that's your call.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
