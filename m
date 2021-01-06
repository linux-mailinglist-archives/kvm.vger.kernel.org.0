Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41012EBC13
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 11:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbhAFKD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 05:03:58 -0500
Received: from mail.skyhub.de ([5.9.137.197]:60010 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbhAFKD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 05:03:58 -0500
Received: from zn.tnic (p200300ec2f09690020b9eee96d74c6dd.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:6900:20b9:eee9:6d74:c6dd])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CE4281EC04F0;
        Wed,  6 Jan 2021 11:03:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1609927395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=iAfpaZseU8rtBfSQH6eBi47GvS0K9Dab1MU6EmvLzI4=;
        b=czQrmcoO22O7xdC9bFE4W9lPaNRZpf1Z2jpKUXdHJyQbbVDKBJGpJS1to4FH6VjI/6Qy6+
        56XCeScS3+yGMxXTpDcmKoGK4EgczE77stbxqRnJWO446dmnV5ONxt9cP+fdM67fBlkYrQ
        aVVK2zT/Xvgpdhch6r6/CPCc140lQtU=
Date:   Wed, 6 Jan 2021 11:03:13 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Deep Shah <sdeep@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [PATCH v3 06/15] x86/paravirt: switch time pvops functions to
 use static_call()
Message-ID: <20210106100313.GB5729@zn.tnic>
References: <20201217093133.1507-1-jgross@suse.com>
 <20201217093133.1507-7-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201217093133.1507-7-jgross@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 17, 2020 at 10:31:24AM +0100, Juergen Gross wrote:
> The time pvops functions are the only ones left which might be
> used in 32-bit mode and which return a 64-bit value.
> 
> Switch them to use the static_call() mechanism instead of pvops, as
> this allows quite some simplification of the pvops implementation.
> 
> Due to include hell this requires to split out the time interfaces
> into a new header file.

I guess you can add Peter's patch to your set, no?

https://lkml.kernel.org/r/20201110005609.40989-3-frederic@kernel.org

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
