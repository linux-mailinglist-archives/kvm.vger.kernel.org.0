Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6843A337EB6
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 21:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbhCKUIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 15:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhCKUID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 15:08:03 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FD3C061574;
        Thu, 11 Mar 2021 12:08:03 -0800 (PST)
Received: from zn.tnic (p200300ec2f0e1f00a86a11edd1796e13.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1f00:a86a:11ed:d179:6e13])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AAED31EC041D;
        Thu, 11 Mar 2021 21:08:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1615493281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=AifDkVdF51jEbfvVL8EjUaOPPRYRFLaZSTcxmg+SPUY=;
        b=W/mJwjLffB7L7gKNyQe+BW1fdg3bxsPR3sNAPyMyuihHtspjZJNSzyJLVXM6J9rQDPqXzu
        Gd9n5qYt8MQjCyG2jOOLcIUo2U3KDKnCEzLiVCa0XG4DsQDOV8q3pJKnyk3TWKrh6Gc7Vb
        mozqcnBvs/yfRVAAEphZAukjbNiiGIY=
Date:   Thu, 11 Mar 2021 21:07:55 +0100
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
Message-ID: <20210311200755.GE5829@zn.tnic>
References: <84f42bad-9fb0-8a76-7f9b-580898b634b9@amd.com>
 <032386c6-4b4c-2d3f-0f6a-3d6350363b3c@amd.com>
 <CALMp9eTTBcdADUYizO-ADXUfkydVGqRm0CSQUO92UHNnfQ-qFw@mail.gmail.com>
 <0ebda5c6-097e-20bb-d695-f444761fbb79@amd.com>
 <0d8f6573-f7f6-d355-966a-9086a00ef56c@amd.com>
 <1451b13e-c67f-8948-64ff-5c01cfb47ea7@redhat.com>
 <3929a987-5d09-6a0c-5131-ff6ffe2ae425@amd.com>
 <7a7428f4-26b3-f704-d00b-16bcf399fd1b@amd.com>
 <78cc2dc7-a2ee-35ac-dd47-8f3f8b62f261@redhat.com>
 <d7c6211b-05d3-ec3f-111a-f69f09201681@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d7c6211b-05d3-ec3f-111a-f69f09201681@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 07:21:23PM -0600, Babu Moger wrote:
> # git bisect good
> 59094faf3f618b2d2b2a45acb916437d611cede6 is the first bad commit
> commit 59094faf3f618b2d2b2a45acb916437d611cede6
> Author: Borislav Petkov <bp@suse.de>
> Date:   Mon Dec 25 13:57:16 2017 +0100
> 
>     x86/kaiser: Move feature detection up

What is the reproducer?

Boot latest 4.9 stable kernel in a SEV guest? Can you send guest
.config?

Upthread is talking about PCID, so I'm guessing host needs to be Zen3
with PCID. Anything else?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
