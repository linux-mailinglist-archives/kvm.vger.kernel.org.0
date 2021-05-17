Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915683838AD
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 18:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243200AbhEQP6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 11:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345306AbhEQPy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 11:54:58 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705C8C026CD6;
        Mon, 17 May 2021 07:40:50 -0700 (PDT)
Received: from zn.tnic (p200300ec2f061b008001bc91326b1fbb.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:1b00:8001:bc91:326b:1fbb])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BBC131EC0283;
        Mon, 17 May 2021 16:40:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621262448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hHiDOVzxirtXGCtnHRuuwKdYkuJC05LNwuTeUETutu0=;
        b=JJ1rKql39gX9kS9AD4praXlW6NJxUt9ALeDSOxmfrRdy/sA3JmjEWsG6tjd+KiH5Vy8a/z
        SFCUsL9HbCK5p2OTLMx7OjVsJEjk6ZWucCPE3aWzpleaAX9oF9X1QPcfIz2asb47cd+hpw
        GySEaCiXA9D8PAxyU+Is3JfXpiVMoi0=
Date:   Mon, 17 May 2021 16:40:44 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 03/20] x86/sev: Add support for hypervisor
 feature VMGEXIT
Message-ID: <YKKAbMIRCVKjB+MU@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-4-brijesh.singh@amd.com>
 <YJpWAY+ayATSn6nN@zn.tnic>
 <bb512f58-be1d-d6ae-41e3-0fc95a01a95d@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bb512f58-be1d-d6ae-41e3-0fc95a01a95d@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 01:53:53PM -0500, Brijesh Singh wrote:
> I am fine with the reduced name, I just hope that "TMR" does not create
> confusion with "Trusted Memory Region" documented in  SEV-ES firmware
> specification. Since I am working on both guest and OVMF patches
> simultaneously so its possible that I just worked on this code after
> OVMF and used the same mouthful name ;)

I'm not surprised :-)

But sure, call this

GHCB_SNP_RESTRICTED_INJ_TIMER

Still short enough.

>   I apologies for those nits.

Oh, it's not a nit - it pays off later when chasing bugs and one is
trying to swap in the whole situation back into her/his L1. :-)

> Sure, I will send prepatch.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
