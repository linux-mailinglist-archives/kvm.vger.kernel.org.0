Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB925546FF
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbiFVJyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 05:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbiFVJyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 05:54:01 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619B13A18D
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 02:53:55 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id i64so15612088pfc.8
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 02:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JRDDa19/V45DwVNKWWlivh1c2U4yhYbqsPjFmKAFcC0=;
        b=oCbFF8GITK0WLSNS996UukaQQxuW5VMs1JWv2/z4ZDj53CBVxVgSvP1BZWSyaQ2GkT
         oX4HcC6+Hde6lQYcZIz3g2pAo4gHbPX/iqoaNzOIgqf2zxOfCm+tVqKLVFI7RKpNDjvA
         sXBZAuwmt3W7e3Q1XFknYcyW3SqJvCud2SydZIk+euKIODjVj30FSlasx09FTl9GrZRB
         Xs7tHZddYGZGDmXcjY1ad1I04G9u1GiFAPs7+3H6/84YE/8PwZKQI3ithWaRtQVdeLDX
         9Un2fwGKiy/9sr29uCz/weploPlRk9GjQ3YOIjHDYM2GzY6Gh02wkYt4LslCGwCtoGJB
         02OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JRDDa19/V45DwVNKWWlivh1c2U4yhYbqsPjFmKAFcC0=;
        b=X0ZmzdlB2gPDZ0Vde8T26Dws6UrEeLhg4G1XvzGpHNn2GJlAKm4F/l1dIHyDhNqNuj
         PBJrHwfTcGXOP1c78OBYBESxxYd1riW2drzDvUrCEsU1TiA9XGiNqjYU681++hKklAx8
         HJ4aIa72EnXV/pZQ37VvyXQBKotLeY8x+umPnm3HqDXhDPFIaHCCqGzZalUrw76ixIUy
         wQ15gt+mBwWglJk/v+8GDHjbQqatAxiwCni8NkeidIJDdMMRkdkZuSoRCldId9U68LET
         Ma+AD1DW+3LiJQ9XceT6NbbODGHRipq8OPiadCQTJn7mrV1VGUeBLfZ02BQlILiSY7Wk
         sg0w==
X-Gm-Message-State: AJIora/d1LH720+wfvVJNHQ0/t9Kh18ftT+xm13feYhTJsYEdrZnq4qd
        ZLH1nZ7QysVH3kAVi8Y1rEQjDgGlrNUs5QlH91T4qw==
X-Google-Smtp-Source: AGRyM1uQo6daJYtS5ejR5Y/X9OxYYqtlJ3QuYGsgKTVwSdlFfEIAk4PqNE1UhZuwF2CF5RwzGbOWGTczmXlHTHZzmBc=
X-Received: by 2002:a63:7a11:0:b0:40c:fbcb:2f12 with SMTP id
 v17-20020a637a11000000b0040cfbcb2f12mr2244262pgc.180.1655891634647; Wed, 22
 Jun 2022 02:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220609110337.1238762-1-jaz@semihalf.com> <20220609110337.1238762-2-jaz@semihalf.com>
 <YqIJ8HtdqnoVzfQD@google.com> <CAH76GKNRDXAyGYvs2ji5Phu=5YPW8+SV8-6TLjizBRzTCnEROg@mail.gmail.com>
 <YqNVYz4+yVbWnmNv@google.com> <CAH76GKNSfaHwpy46r1WWTVgnsuijqcHe=H5nvUTUUs1UbdZvkQ@mail.gmail.com>
 <Yqtez/J540yD7VdD@google.com> <2201fe5f-5bd8-baaf-aad5-eaaea2f1e20e@amd.com>
 <CAH76GKP=2wu4+eqLCFu1F5a4rHhReUT_7N89K8xbO-gSqEQ-3w@mail.gmail.com> <88344644-44e1-0089-657a-2e34316ea4b4@amd.com>
In-Reply-To: <88344644-44e1-0089-657a-2e34316ea4b4@amd.com>
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
Date:   Wed, 22 Jun 2022 11:53:43 +0200
Message-ID: <CAH76GKMKjogX9kE5jch+LqkGswGAmyOdu5sOdY_G23Dqpf0puA@mail.gmail.com>
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

pon., 20 cze 2022 o 18:32 Limonciello, Mario
<mario.limonciello@amd.com> napisa=C5=82(a):
>
> On 6/20/2022 10:43, Grzegorz Jaszczyk wrote:
> > czw., 16 cze 2022 o 18:58 Limonciello, Mario
> > <mario.limonciello@amd.com> napisa=C5=82(a):
> >>
> >> On 6/16/2022 11:48, Sean Christopherson wrote:
> >>> On Wed, Jun 15, 2022, Grzegorz Jaszczyk wrote:
> >>>> pt., 10 cze 2022 o 16:30 Sean Christopherson <seanjc@google.com> nap=
isa=C5=82(a):
> >>>>> MMIO or PIO for the actual exit, there's nothing special about hype=
rcalls.  As for
> >>>>> enumerating to the guest that it should do something, why not add a=
 new ACPI_LPS0_*
> >>>>> function?  E.g. something like
> >>>>>
> >>>>> static void s2idle_hypervisor_notify(void)
> >>>>> {
> >>>>>           if (lps0_dsm_func_mask > 0)
> >>>>>                   acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT_HYPERVISOR=
_NOTIFY
> >>>>>                                           lps0_dsm_func_mask, lps0_=
dsm_guid);
> >>>>> }
> >>>>
> >>>> Great, thank you for your suggestion! I will try this approach and
> >>>> come back. Since this will be the main change in the next version,
> >>>> will it be ok for you to add Suggested-by: Sean Christopherson
> >>>> <seanjc@google.com> tag?
> >>>
> >>> If you want, but there's certainly no need to do so.  But I assume yo=
u or someone
> >>> at Intel will need to get formal approval for adding another ACPI LPS=
0 function?
> >>> I.e. isn't there work to be done outside of the kernel before any pat=
ches can be
> >>> merged?
> >>
> >> There are 3 different LPS0 GUIDs in use.  An Intel one, an AMD (legacy=
)
> >> one, and a Microsoft one.  They all have their own specs, and so if th=
is
> >> was to be added I think all 3 need to be updated.
> >
> > Yes this will not be easy to achieve I think.
> >
> >>
> >> As this is Linux specific hypervisor behavior, I don't know you would =
be
> >> able to convince Microsoft to update theirs' either.
> >>
> >> How about using s2idle_devops?  There is a prepare() call and a
> >> restore() call that is set for each handler.  The only consumer of thi=
s
> >> ATM I'm aware of is the amd-pmc driver, but it's done like a
> >> notification chain so that a bunch of drivers can hook in if they need=
 to.
> >>
> >> Then you can have this notification path and the associated ACPI devic=
e
> >> it calls out to be it's own driver.
> >
> > Thank you for your suggestion, just to be sure that I've understand
> > your idea correctly:
> > 1) it will require to extend acpi_s2idle_dev_ops about something like
> > hypervisor_notify() call, since existing prepare() is called from end
> > of acpi_s2idle_prepare_late so it is too early as it was described in
> > one of previous message (between acpi_s2idle_prepare_late and place
> > where we use hypercall there are several places where the suspend
> > could be canceled, otherwise we could probably try to trap on other
> > acpi_sleep_run_lps0_dsm occurrence from acpi_s2idle_prepare_late).
> >
>
> The idea for prepare() was it would be the absolute last thing before
> the s2idle loop was run.  You're sure that's too early?  It's basically
> the same thing as having a last stage new _DSM call.
>
> What about adding a new abort() extension to acpi_s2idle_dev_ops?  Then
> you could catch the cancelled suspend case still and take corrective
> action (if that action is different than what restore() would do).

It will be problematic since the abort/restore notification could
arrive too late and therefore the whole system will go to suspend
thinking that the guest is in desired s2ilde state. Also in this case
it would be impossible to prevent races and actually making sure that
the guest is suspended or not. We already had similar discussion with
Sean earlier in this thread why the notification have to be send just
before swait_event_exclusive(s2idle_wait_head, s2idle_state =3D=3D
S2IDLE_STATE_WAKE) and that the VMM have to have control over guest
resumption.

Nevertheless if extending acpi_s2idle_dev_ops is possible, why not
extend it about the hypervisor_notify() and use it in the same place
where the hypercall is used in this patch? Do you see any issue with
that?

>
> > 2) using newly introduced acpi_s2idle_dev_ops hypervisor_notify() call
> > will allow to register handler from Intel x86/intel/pmc/core.c driver
> > and/or AMD x86/amd-pmc.c driver. Therefore we will need to get only
> > Intel and/or AMD approval about extending the ACPI LPS0 _DSM method,
> > correct?
> >
>
> Right now the only thing that hooks prepare()/restore() is the amd-pmc
> driver (unless Intel's PMC had a change I didn't catch yet).
>
> I don't think you should be changing any existing drivers but rather
> introduce another platform driver for this specific case.
>
> So it would be something like this:
>
> acpi_s2idle_prepare_late
> -> prepare()
> --> AMD: amd_pmc handler for prepare()
> --> Intel: intel_pmc handler for prepare() (conceptual)
> --> HYPE0001 device: new driver's prepare() routine
>
> So the platform driver would match the HYPE0001 device to load, and it
> wouldn't do anything other than provide a prepare()/restore() handler
> for your case.
>
> You don't need to change any existing specs.  If anything a new spec to
> go with this new ACPI device would be made.  Someone would need to
> reserve the ID and such for it, but I think you can mock it up in advance=
.

Thank you for your explanation. This means that I should register
"HYPE" through https://uefi.org/PNP_ACPI_Registry before introducing
this new driver to Linux.
I have no experience with the above, so I wonder who should be
responsible for maintaining such ACPI ID since it will not belong to
any specific vendor? There is an example of e.g. COREBOOT PROJECT
using "BOOT" ACPI ID [1], which seems similar in terms of not
specifying any vendor but rather the project as a responsible entity.
Maybe you have some recommendations?

I am also not sure if and where a specification describing such a
device has to be maintained. Since "HYPE0001" will have its own _DSM
so will it be required to document it somewhere rather than just using
it in the driver and preparing proper ACPI tables for guest?

>
> > I wonder if this will be affordable so just re-thinking loudly if
> > there is no other mechanism that could be suggested and used upstream
> > so we could notify hypervisor/vmm about guest entering s2idle state?
> > Especially that such _DSM function will be introduced only to trap on
> > some fake MMIO/PIO access and will be useful only for guest ACPI
> > tables?
> >
>
> Do you need to worry about Microsoft guests using Modern Standby too or
> is that out of the scope of your problem set?  I think you'll be a lot
> more limited in how this can behave and where you can modify things if so=
.
>

I do not need to worry about Microsoft guests.

[1] https://uefi.org/acpi_id_list

Thank you,
Grzegorz
