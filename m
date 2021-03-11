Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F50337FCC
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 22:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhCKVkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 16:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbhCKVkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 16:40:13 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BD5C061574;
        Thu, 11 Mar 2021 13:40:13 -0800 (PST)
Received: from zn.tnic (p200300ec2f0e1f00f0a77a9e991aa23f.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1f00:f0a7:7a9e:991a:a23f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C61701EC0324;
        Thu, 11 Mar 2021 22:40:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1615498811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=OtXM/2jJOcgC79Wplu1CqVJJao4RuO3TzJVik1mXAr8=;
        b=fE1YvmBU8rfJYcpy3CscSv9D/WZvkvXdkTRR0EVYfYPqPodusUHFwUFjc3eVOHfZaFw70Z
        SzlRCgSp5Fg2gVvYEcaIkn8UlpE+3NBLGmfPKk0JTUlg1tkrwDEXvOIM9wFEwymjlIs2Se
        /dqtLOnQClOv3PPRU16MV87smfo12nQ=
Date:   Thu, 11 Mar 2021 22:40:13 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
Message-ID: <20210311214013.GH5829@zn.tnic>
References: <0ebda5c6-097e-20bb-d695-f444761fbb79@amd.com>
 <0d8f6573-f7f6-d355-966a-9086a00ef56c@amd.com>
 <1451b13e-c67f-8948-64ff-5c01cfb47ea7@redhat.com>
 <3929a987-5d09-6a0c-5131-ff6ffe2ae425@amd.com>
 <7a7428f4-26b3-f704-d00b-16bcf399fd1b@amd.com>
 <78cc2dc7-a2ee-35ac-dd47-8f3f8b62f261@redhat.com>
 <d7c6211b-05d3-ec3f-111a-f69f09201681@amd.com>
 <20210311200755.GE5829@zn.tnic>
 <20210311203206.GF5829@zn.tnic>
 <2ca37e61-08db-3e47-f2b9-8a7de60757e6@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2ca37e61-08db-3e47-f2b9-8a7de60757e6@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 02:57:04PM -0600, Babu Moger wrote:
>  It is related PCID and INVPCID combination. Few more details.
>  1. System comes up fine with "noinvpid". So, it happens when invpcid is
> enabled.

Which system, host or guest?

>  2. Host is coming up fine. Problem is with the guest.

Aha, guest.

>  3. Problem happens with Debian 9. Debian kernel version is 4.9.0-14.
>  4. Debian 10 is fine.
>  5. Upstream kernels are fine. Tried on v5.11 and it is working fine.
>  6. Git bisect pointed to commit 47811c66356d875e76a6ca637a9d384779a659bb.
> 
>  Let me know if want me to try something else.

Yes, I assume host has the patches which belong to this thread?

So please describe:

1. host has these patches, cmdline params, etc.
2. guest is a 4.9 kernel, cmdline params, etc.

Please be exact and specific so that I can properly reproduce.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
