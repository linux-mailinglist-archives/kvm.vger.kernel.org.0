Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45599552171
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 17:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243626AbiFTPoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 11:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbiFTPoN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 11:44:13 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B431AD8F
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 08:44:11 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id a17so8118832pls.6
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 08:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UF07x+KnC24YwAp8Zs4wTUOe9n56U36o0sDtsdMKcd8=;
        b=Y8eqlHQkFI6Q7/UGjenXvlQi5VFjn2bOO+EB4M6bkbVpQp5Feutj2lG2yJAlO2tva5
         6mWHpvRhz7WQuOaqNRspQjyloBLJMiZJz6zlk0SRN4MuqlZ+EvZ1ih4AIlwGId0CvBrs
         7QOkdjtsuKU4gVduY0wlBbwACw1l52voPohchtPGrrnvQYLH83OFXOc2Eglg+siP7woh
         Hmk8o2gAKYI6PG1fxoPAxf1MdmTU/EljkqwlhNfMpRWmeSkRsy9hvn+EwqywbNYOlhp+
         ukq7JDLv53AL+1NxEZ3rSWztWILGbj6q2nTOVxtTdVr4LyMYUI9DFCfGby5WMdqTFxhd
         Bbsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UF07x+KnC24YwAp8Zs4wTUOe9n56U36o0sDtsdMKcd8=;
        b=byZgdDbeh40epjIUdAaSqNk2Bzi8sBOyU1C2Ma8sP+PyziUZfCdYOD+g8CnC2roNma
         OtlcaryH9FygvyAAcQ6Qx39lrO+yYqR5hie9zk3fHliXG0GW3x4dlUHpVhjjqDQEVLBg
         mLtAuVT2/+10zXda42qEZyFSQr4qE9bYKEYK55aOcuJIaTYxmYA6WHfG//mgHV3iYLfi
         b4YnHn8P8Jahcoz9xgRXd5EkV1TIhq83F7CuxUfpQk4whOLnt7RRzsINRnVL7C11YEzi
         uuqAX8zsOjDRQWVaDkiTnfOYbU8ckT14kAqcayXtOSX3qBQ0aiz0fwRQpPQFA9VcGBzB
         XTNQ==
X-Gm-Message-State: AJIora/JfKJgeKSQPIFLeSvVQdz40JnCxzSOK9uToEUJovrmJfrZbFDU
        RyzBvDIzWtyCySx8G6EvHeI0knhAEsG0j80ATl/8Fw==
X-Google-Smtp-Source: AGRyM1v15k9qrsixLm6raqv4MPyHwRjWVANU3gzBqV102eylPn2lN/jX0JMnapEC7t0R2BZSaQGds5zvTzoNauNdUKA=
X-Received: by 2002:a17:90b:3e8a:b0:1ec:c09d:7963 with SMTP id
 rj10-20020a17090b3e8a00b001ecc09d7963mr667756pjb.199.1655739850930; Mon, 20
 Jun 2022 08:44:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220609110337.1238762-1-jaz@semihalf.com> <20220609110337.1238762-2-jaz@semihalf.com>
 <YqIJ8HtdqnoVzfQD@google.com> <CAH76GKNRDXAyGYvs2ji5Phu=5YPW8+SV8-6TLjizBRzTCnEROg@mail.gmail.com>
 <YqNVYz4+yVbWnmNv@google.com> <CAH76GKNSfaHwpy46r1WWTVgnsuijqcHe=H5nvUTUUs1UbdZvkQ@mail.gmail.com>
 <Yqtez/J540yD7VdD@google.com> <2201fe5f-5bd8-baaf-aad5-eaaea2f1e20e@amd.com>
In-Reply-To: <2201fe5f-5bd8-baaf-aad5-eaaea2f1e20e@amd.com>
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
Date:   Mon, 20 Jun 2022 17:43:59 +0200
Message-ID: <CAH76GKP=2wu4+eqLCFu1F5a4rHhReUT_7N89K8xbO-gSqEQ-3w@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: notify hypervisor about guest entering s2idle state
To:     "Limonciello, Mario" <mario.limonciello@amd.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Dmytro Maluka <dmy@semihalf.com>,
        Zide Chen <zide.chen@intel.corp-partner.google.com>,
        Peter Fang <peter.fang@intel.corp-partner.google.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
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
        Ashish Kalra <ashish.kalra@amd.com>,
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
        <linux-pm@vger.kernel.org>, Dominik Behr <dbehr@google.com>,
        Dmitry Torokhov <dtor@google.com>
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

czw., 16 cze 2022 o 18:58 Limonciello, Mario
<mario.limonciello@amd.com> napisa=C5=82(a):
>
> On 6/16/2022 11:48, Sean Christopherson wrote:
> > On Wed, Jun 15, 2022, Grzegorz Jaszczyk wrote:
> >> pt., 10 cze 2022 o 16:30 Sean Christopherson <seanjc@google.com> napis=
a=C5=82(a):
> >>> MMIO or PIO for the actual exit, there's nothing special about hyperc=
alls.  As for
> >>> enumerating to the guest that it should do something, why not add a n=
ew ACPI_LPS0_*
> >>> function?  E.g. something like
> >>>
> >>> static void s2idle_hypervisor_notify(void)
> >>> {
> >>>          if (lps0_dsm_func_mask > 0)
> >>>                  acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT_HYPERVISOR_NO=
TIFY
> >>>                                          lps0_dsm_func_mask, lps0_dsm=
_guid);
> >>> }
> >>
> >> Great, thank you for your suggestion! I will try this approach and
> >> come back. Since this will be the main change in the next version,
> >> will it be ok for you to add Suggested-by: Sean Christopherson
> >> <seanjc@google.com> tag?
> >
> > If you want, but there's certainly no need to do so.  But I assume you =
or someone
> > at Intel will need to get formal approval for adding another ACPI LPS0 =
function?
> > I.e. isn't there work to be done outside of the kernel before any patch=
es can be
> > merged?
>
> There are 3 different LPS0 GUIDs in use.  An Intel one, an AMD (legacy)
> one, and a Microsoft one.  They all have their own specs, and so if this
> was to be added I think all 3 need to be updated.

Yes this will not be easy to achieve I think.

>
> As this is Linux specific hypervisor behavior, I don't know you would be
> able to convince Microsoft to update theirs' either.
>
> How about using s2idle_devops?  There is a prepare() call and a
> restore() call that is set for each handler.  The only consumer of this
> ATM I'm aware of is the amd-pmc driver, but it's done like a
> notification chain so that a bunch of drivers can hook in if they need to=
.
>
> Then you can have this notification path and the associated ACPI device
> it calls out to be it's own driver.

Thank you for your suggestion, just to be sure that I've understand
your idea correctly:
1) it will require to extend acpi_s2idle_dev_ops about something like
hypervisor_notify() call, since existing prepare() is called from end
of acpi_s2idle_prepare_late so it is too early as it was described in
one of previous message (between acpi_s2idle_prepare_late and place
where we use hypercall there are several places where the suspend
could be canceled, otherwise we could probably try to trap on other
acpi_sleep_run_lps0_dsm occurrence from acpi_s2idle_prepare_late).

2) using newly introduced acpi_s2idle_dev_ops hypervisor_notify() call
will allow to register handler from Intel x86/intel/pmc/core.c driver
and/or AMD x86/amd-pmc.c driver. Therefore we will need to get only
Intel and/or AMD approval about extending the ACPI LPS0 _DSM method,
correct?

I wonder if this will be affordable so just re-thinking loudly if
there is no other mechanism that could be suggested and used upstream
so we could notify hypervisor/vmm about guest entering s2idle state?
Especially that such _DSM function will be introduced only to trap on
some fake MMIO/PIO access and will be useful only for guest ACPI
tables?

Thank you,
Grzegorz
