Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D54D419438
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 14:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhI0MaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 08:30:14 -0400
Received: from mail.skyhub.de ([5.9.137.197]:45424 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234336AbhI0MaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 08:30:13 -0400
Received: from zn.tnic (p200300ec2f088a003e7a3db711c29d58.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:8a00:3e7a:3db7:11c2:9d58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 56BAE1EC034B;
        Mon, 27 Sep 2021 14:28:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632745710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=SgaMeX7xObXmRf9caHAL7p62gvmW25yv2YUmegEBHNg=;
        b=kKFoLugjA8HL+d62mLUdykCnB7hVZ5dch+yOqKvYIIwcHOjsD3qZc/XZ6lKmDwc2Tf6x+e
        Xdi9Sl0kUJU3F+HRn4CU/aGMsblGw9S1+aLc6wEeszbliWmM50gJXGVVdG+jWD6uint2T7
        b3Om/PysATOfZ82wHiYxkvMijyE80gM=
Date:   Mon, 27 Sep 2021 14:28:24 +0200
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
Message-ID: <YVG46L++WPBAHxQv@zn.tnic>
References: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
 <YVGkDPbQmdwSw6Ff@zn.tnic>
 <fcbbdf83-128a-2519-13e8-1c5d5735a0d2@redhat.com>
 <YVGz0HXe+WNAXfdF@zn.tnic>
 <bcd40d94-2634-a40c-0173-64063051a4b2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bcd40d94-2634-a40c-0173-64063051a4b2@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 02:14:52PM +0200, Paolo Bonzini wrote:
> Right, not which MSR to write but which value to write.  It doesn't know
> that the PSF disable bit is valid unless the corresponding CPUID bit is set.

There's no need for the separate PSF CPUID bit yet. We have decided for
now to not control PSF separately but disable it through SSB. Please
follow this thread:

https://lore.kernel.org/all/20210904172334.lfjyqi4qfzvbxef7@treble/T/#u

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
