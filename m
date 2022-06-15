Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D9354D091
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 20:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357890AbiFOSAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 14:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349821AbiFOSAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 14:00:53 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F2F54004
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 11:00:51 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id o17so11054445pla.6
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 11:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aKVoJG94TlRK1lO5EtxaMQBi2kCbacnBTEUYcvXReYs=;
        b=FNCP2oYfZ40CEmxTy0qRZfyApcZ+1R96el63F2TOp0qXRzJnR18YS28i4ComAHwniE
         NzTpAhKsSs6GfhSpMAsAxbNJupjAtzYcPojh6rHDREBCcik6J0UGscpWefqG+eMOycrr
         aNexRCGLHPIzOHCw8RDDtF/Fgo2OCR6YPINhDQDEeoxo8cbnCZpBaY+kr2yrXknY/y1Z
         zfx+ItNutvYmKUljGz5VBNfeGRdgaNZ+CJnsAfAr6ZB+wBvlE7tz22gcnBLKKfCg1Vig
         RWkN5AS2C0LgtERETqvsbgVx5ftTRmODp8vNncg5KxCNG3Nyopz/Rx/p6HlmPiHQzMF9
         OMBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aKVoJG94TlRK1lO5EtxaMQBi2kCbacnBTEUYcvXReYs=;
        b=eMx0wqN8qKBYg4msKkCqUdFog0+L9O+DbSBYt//KxkTv63i//CLNPQBGBaryZpn8bP
         5fZFI9sW/Pu2wBkQR9RWOVHeasMq0m+RCES0MfW2hn8EY+afhpgo79/0N/MH0o8DBhJw
         5g4FdglpNX2xNLQhXeemEMR9ddPkbYQhXj68mBpsw2zHeQIYyRYJz+m6U7mC0+w/aRfd
         njYiF6WUCqnwm32ONtKEU96LTKH9TkhvwrHtSDwNBfiNE50Ir0vSNkE/o50SzDByoFoM
         fJlm+ejJ3f9vw5O2zDdXG+p8tdbkjiybDfwwWMhaRGhwIzPHybu3Fi0WT6fzKvXhGYNv
         c9CQ==
X-Gm-Message-State: AJIora/46bRnBoh1tybDJLyCZ/ThEHYfP1JZo4Sqg3Txm7+M3LXtEkAx
        y1K2uy6e6pZaju881sirLs65KGkfeIVJYeQB5SB1pg==
X-Google-Smtp-Source: AGRyM1sMkrDeId7x/50KkjN7iA2jK8X0btO6512sJN4xGHhvO2BWqk0v85/hMP7+RYjUk3yjrmwAVc2SnFWgd5AdlWU=
X-Received: by 2002:a17:90b:2247:b0:1e8:9f24:269a with SMTP id
 hk7-20020a17090b224700b001e89f24269amr11622697pjb.14.1655316051101; Wed, 15
 Jun 2022 11:00:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220609110337.1238762-1-jaz@semihalf.com> <20220609110337.1238762-2-jaz@semihalf.com>
 <f62ab257-b2e0-3097-e394-93a9e7a0d2bf@intel.com> <CAH76GKPo6VL33tBaZyszL8wvjpzJ7hjOg3o1JddaEnuGbwk=dQ@mail.gmail.com>
 <2854ae00-e965-ab0f-80dd-6012ae36b271@intel.com> <7eb5313e-dea0-c73e-5467-d01f0ca0fc2d@amd.com>
In-Reply-To: <7eb5313e-dea0-c73e-5467-d01f0ca0fc2d@amd.com>
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
Date:   Wed, 15 Jun 2022 20:00:39 +0200
Message-ID: <CAH76GKO-X-DrR=yAh3NpvAC_Spd_aJ8+yLTATm+c34iPShNttQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: notify hypervisor about guest entering s2idle state
To:     Mario Limonciello <mario.limonciello@amd.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     linux-kernel@vger.kernel.org, Dmytro Maluka <dmy@semihalf.com>,
        Zide Chen <zide.chen@intel.corp-partner.google.com>,
        Peter Fang <peter.fang@intel.corp-partner.google.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sachi King <nakato@nakato.io>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Dunn <daviddunn@google.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:ACPI" <linux-acpi@vger.kernel.org>,
        "open list:HIBERNATION (aka Software Suspend, aka swsusp)" 
        <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pon., 13 cze 2022 o 07:03 Mario Limonciello
<mario.limonciello@amd.com> napisa=C5=82(a):
>
> On 6/10/22 07:49, Dave Hansen wrote:
> > On 6/10/22 04:36, Grzegorz Jaszczyk wrote:
> >> czw., 9 cze 2022 o 16:27 Dave Hansen <dave.hansen@intel.com> napisa=C5=
=82(a):
> >>> On 6/9/22 04:03, Grzegorz Jaszczyk wrote:
> >>>> Co-developed-by: Peter Fang <peter.fang@intel.corp-partner.google.co=
m>
> >>>> Signed-off-by: Peter Fang <peter.fang@intel.corp-partner.google.com>
> >>>> Co-developed-by: Tomasz Nowicki <tn@semihalf.com>
> >>>> Signed-off-by: Tomasz Nowicki <tn@semihalf.com>
> >>>> Signed-off-by: Zide Chen <zide.chen@intel.corp-partner.google.com>
> >>>> Co-developed-by: Grzegorz Jaszczyk <jaz@semihalf.com>
> >>>> Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
> >>>> ---
> >>>>   Documentation/virt/kvm/x86/hypercalls.rst | 7 +++++++
> >>>>   arch/x86/kvm/x86.c                        | 3 +++
> >>>>   drivers/acpi/x86/s2idle.c                 | 8 ++++++++
> >>>>   include/linux/suspend.h                   | 1 +
> >>>>   include/uapi/linux/kvm_para.h             | 1 +
> >>>>   kernel/power/suspend.c                    | 4 ++++
> >>>>   6 files changed, 24 insertions(+)
> >>> What's the deal with these emails?
> >>>
> >>>          zide.chen@intel.corp-partner.google.com
> >>>
> >>> I see a smattering of those in the git logs, but never for Intel folk=
s.
> >> I've kept emails as they were in the original patch and I do not think
> >> I should change them. This is what Zide and Peter originally used.
> >
> > "Original patch"?  Where did you get this from?
>
> Is this perhaps coming from Chromium Gerrit?  If so, I think you should
> include a link to the Gerrit code review discussion.

Yes, the original patch comes from chromium gerrit:
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/=
3482475/4
and after reworking but before sending to the mailing list, I've asked
all involved guys for ack and it was done internally on gerrit:
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/=
3666997

>
> If it's not a public discussion/patch originally perhaps Suggested-by:
> might be a better tag to use.
>
> >
> >>> I'll also say that I'm a bit suspicious of a patch that includes 5
> >>> authors for 24 lines of code.  Did it really take five of you to writ=
e
> >>> 24 lines of code?
> >> This patch was built iteratively: original patch comes from Zide and
> >> Peter, I've squashed it with Tomasz later changes and reworked by
> >> myself for upstream. I didn't want to take credentials from any of the
> >> above so ended up with Zide as an author and 3 co-developers. Please
> >> let me know if that's an issue.
> >
> > It just looks awfully fishy.
> >
> > If it were me, and I'd put enough work into it to believe I deserved
> > credit as an *author* (again, of ~13 lines of actual code), I'd probabl=
y
> > just zap all the other SoB's and mention them in the changelog.  I'd
> > also explain where the code came from.
> >
> > Your text above wouldn't be horrible context to add to a cover letter.

Actually it may not be an issue for the next version since the
suggested by Sean approach is quite different so I would most likely
end up with reduced SoB/Co-dev-by in the next version.

Best regards,
Grzegorz
