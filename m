Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D12337FAD
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 22:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhCKVge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 16:36:34 -0500
Received: from mail.skyhub.de ([5.9.137.197]:32908 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhCKVgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 16:36:05 -0500
Received: from zn.tnic (p200300ec2f0e1f00f0a77a9e991aa23f.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1f00:f0a7:7a9e:991a:a23f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5881D1EC0242;
        Thu, 11 Mar 2021 22:36:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1615498564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=vnZJA6bwJwMv01XB1ZyoXIa36BjZyTIdjNPd4yfcLT8=;
        b=Qsr1w0kwmjO1dpdQLr+FTbdPgambIX9k3iIcVJddRq0KLv/ieI+nG9ahQNkQ5CGJFDUEjz
        XRvT56w34NI4QpANIziElbJ0mVh7pHn8ZyF7Fk+lOQzZCY72OQ/EvuqpN5UYRpn6GOvC8K
        5024rJ6A1njuPQARe+H93qkklfdM6SQ=
Date:   Thu, 11 Mar 2021 22:36:00 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jim Mattson <jmattson@google.com>
Cc:     Babu Moger <babu.moger@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Message-ID: <20210311213600.GG5829@zn.tnic>
References: <0ebda5c6-097e-20bb-d695-f444761fbb79@amd.com>
 <0d8f6573-f7f6-d355-966a-9086a00ef56c@amd.com>
 <1451b13e-c67f-8948-64ff-5c01cfb47ea7@redhat.com>
 <3929a987-5d09-6a0c-5131-ff6ffe2ae425@amd.com>
 <7a7428f4-26b3-f704-d00b-16bcf399fd1b@amd.com>
 <78cc2dc7-a2ee-35ac-dd47-8f3f8b62f261@redhat.com>
 <d7c6211b-05d3-ec3f-111a-f69f09201681@amd.com>
 <20210311200755.GE5829@zn.tnic>
 <20210311203206.GF5829@zn.tnic>
 <CALMp9eQC5V_FQWGLUjc3pMziPeO0it_Mcm=L3bYcTMSEuFdGrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALMp9eQC5V_FQWGLUjc3pMziPeO0it_Mcm=L3bYcTMSEuFdGrA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 01:23:47PM -0800, Jim Mattson wrote:
> I would expect kaiser_enabled to be false (and PCIDs not to be used),
> since AMD CPUs are not vulnerable to Meltdown.

Ah, of course. The guest dmesg should have

"Kernel/User page tables isolation: disabled."

Lemme see if I can reproduce.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
