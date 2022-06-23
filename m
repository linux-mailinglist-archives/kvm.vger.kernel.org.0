Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553DE558088
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 18:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiFWQwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 12:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbiFWQvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 12:51:47 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E538E0BD
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 09:50:25 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id k127so95587pfd.10
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 09:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iHGQo8n7YvLNBvLE4NVsSO6cnf5/UHppvYlhS4a8gzU=;
        b=KniG4lYmb6irhrKZuLDwj7Hu+t3xX06RePanu66W0WBdEVBcM2JbUb0LMJMmK23Saz
         UPanC1tOErDQAIpkS4g5DI4jfsuDGZ2YOuaIROvp8AAK/6T/YF5fDGZkWxANVD2JmVNT
         JB1dSmqvmIBBklkpaE62fncviybGsxxJxxxm+PYNdGwxcC6Bex6168HCNt2XagiVCVsJ
         ONlz2TqgEhZOk5IOxEdmQ1K02PYdkb1NwN95r6ZHd4mBOcPQCVb6jrAGQsDBmRJR95Dh
         VS58+aQ1OzNTbzR2KVG7RJfuuTCVEGXYBnOREby9s3+eDicD5waFjMFpDa5D5NBAYe6i
         8Q4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iHGQo8n7YvLNBvLE4NVsSO6cnf5/UHppvYlhS4a8gzU=;
        b=LZZYnPIGXUWzhcbkDD4sx9wyl2nwbAia9uQuH51aqZJF9pE1Vs0hlHngOoNULYfaxB
         kDQxDtJ3lRoixo8y0iJm5LdA4lDvou8jk3pB9zyF8B94igPQpZ7KbwjotRyRJtiXHDKI
         aYHx5rVU8iPoZSzePHAtDceFZcwUh59serCdF+d/0sn0fM6MGWIw+Nkxt5jWIAgI8c0n
         voRy8iNk93CIRwVySnSL1o4VUPO14vADjC9CXbZlrebnQ3giDG6qS4wxtMCkpVvUik7E
         gcNisMZfQZvK14NXAY9iEpO0Ms+a181aQgmaxWPITCvGbKPN85PhujUeZILxIQ9+6Z/t
         h3DQ==
X-Gm-Message-State: AJIora+3mFxGaMgsGyn8eewWdWpezQVKhkej3ATlFtrlC0PYYSzHsZzq
        qmL8I+WQZQmqT9tSJYqbz+9BNiO6dln66BX8pvGRXQ==
X-Google-Smtp-Source: AGRyM1sFfaOqL2HdnxucLgEOkBEM7aGY23Z175naYW75TFj3yECd0KJc/SUgnBMnYGUQWDWrYWdH0EU5GMQkKPqVsdw=
X-Received: by 2002:a63:8341:0:b0:40d:2430:8fa1 with SMTP id
 h62-20020a638341000000b0040d24308fa1mr8449233pge.85.1656003024428; Thu, 23
 Jun 2022 09:50:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220609110337.1238762-1-jaz@semihalf.com> <20220609110337.1238762-2-jaz@semihalf.com>
 <YqIJ8HtdqnoVzfQD@google.com> <CAH76GKNRDXAyGYvs2ji5Phu=5YPW8+SV8-6TLjizBRzTCnEROg@mail.gmail.com>
 <YqNVYz4+yVbWnmNv@google.com> <CAH76GKNSfaHwpy46r1WWTVgnsuijqcHe=H5nvUTUUs1UbdZvkQ@mail.gmail.com>
 <Yqtez/J540yD7VdD@google.com> <2201fe5f-5bd8-baaf-aad5-eaaea2f1e20e@amd.com>
 <CAH76GKP=2wu4+eqLCFu1F5a4rHhReUT_7N89K8xbO-gSqEQ-3w@mail.gmail.com>
 <88344644-44e1-0089-657a-2e34316ea4b4@amd.com> <CAH76GKMKjogX9kE5jch+LqkGswGAmyOdu5sOdY_G23Dqpf0puA@mail.gmail.com>
 <7c428b03-261f-78cb-4ce3-5949ac93f028@amd.com>
In-Reply-To: <7c428b03-261f-78cb-4ce3-5949ac93f028@amd.com>
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
Date:   Thu, 23 Jun 2022 18:50:13 +0200
Message-ID: <CAH76GKNB0V+-Ky6bfhX6Kzudyn6zJW42iSWfRkfbo9C-eKdo-w@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=C5=9Br., 22 cze 2022 o 23:50 Limonciello, Mario
<mario.limonciello@amd.com> napisa=C5=82(a):
>
> On 6/22/2022 04:53, Grzegorz Jaszczyk wrote:
> > pon., 20 cze 2022 o 18:32 Limonciello, Mario
> > <mario.limonciello@amd.com> napisa=C5=82(a):
> >>
> >> On 6/20/2022 10:43, Grzegorz Jaszczyk wrote:
> >>> czw., 16 cze 2022 o 18:58 Limonciello, Mario
> >>> <mario.limonciello@amd.com> napisa=C5=82(a):
> >>>>
> >>>> On 6/16/2022 11:48, Sean Christopherson wrote:
> >>>>> On Wed, Jun 15, 2022, Grzegorz Jaszczyk wrote:
> >>>>>> pt., 10 cze 2022 o 16:30 Sean Christopherson <seanjc@google.com> n=
apisa=C5=82(a):
> >>>>>>> MMIO or PIO for the actual exit, there's nothing special about hy=
percalls.  As for
> >>>>>>> enumerating to the guest that it should do something, why not add=
 a new ACPI_LPS0_*
> >>>>>>> function?  E.g. something like
> >>>>>>>
> >>>>>>> static void s2idle_hypervisor_notify(void)
> >>>>>>> {
> >>>>>>>            if (lps0_dsm_func_mask > 0)
> >>>>>>>                    acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT_HYPERVI=
SOR_NOTIFY
> >>>>>>>                                            lps0_dsm_func_mask, lp=
s0_dsm_guid);
> >>>>>>> }
> >>>>>>
> >>>>>> Great, thank you for your suggestion! I will try this approach and
> >>>>>> come back. Since this will be the main change in the next version,
> >>>>>> will it be ok for you to add Suggested-by: Sean Christopherson
> >>>>>> <seanjc@google.com> tag?
> >>>>>
> >>>>> If you want, but there's certainly no need to do so.  But I assume =
you or someone
> >>>>> at Intel will need to get formal approval for adding another ACPI L=
PS0 function?
> >>>>> I.e. isn't there work to be done outside of the kernel before any p=
atches can be
> >>>>> merged?
> >>>>
> >>>> There are 3 different LPS0 GUIDs in use.  An Intel one, an AMD (lega=
cy)
> >>>> one, and a Microsoft one.  They all have their own specs, and so if =
this
> >>>> was to be added I think all 3 need to be updated.
> >>>
> >>> Yes this will not be easy to achieve I think.
> >>>
> >>>>
> >>>> As this is Linux specific hypervisor behavior, I don't know you woul=
d be
> >>>> able to convince Microsoft to update theirs' either.
> >>>>
> >>>> How about using s2idle_devops?  There is a prepare() call and a
> >>>> restore() call that is set for each handler.  The only consumer of t=
his
> >>>> ATM I'm aware of is the amd-pmc driver, but it's done like a
> >>>> notification chain so that a bunch of drivers can hook in if they ne=
ed to.
> >>>>
> >>>> Then you can have this notification path and the associated ACPI dev=
ice
> >>>> it calls out to be it's own driver.
> >>>
> >>> Thank you for your suggestion, just to be sure that I've understand
> >>> your idea correctly:
> >>> 1) it will require to extend acpi_s2idle_dev_ops about something like
> >>> hypervisor_notify() call, since existing prepare() is called from end
> >>> of acpi_s2idle_prepare_late so it is too early as it was described in
> >>> one of previous message (between acpi_s2idle_prepare_late and place
> >>> where we use hypercall there are several places where the suspend
> >>> could be canceled, otherwise we could probably try to trap on other
> >>> acpi_sleep_run_lps0_dsm occurrence from acpi_s2idle_prepare_late).
> >>>
> >>
> >> The idea for prepare() was it would be the absolute last thing before
> >> the s2idle loop was run.  You're sure that's too early?  It's basicall=
y
> >> the same thing as having a last stage new _DSM call.
> >>
> >> What about adding a new abort() extension to acpi_s2idle_dev_ops?  The=
n
> >> you could catch the cancelled suspend case still and take corrective
> >> action (if that action is different than what restore() would do).
> >
> > It will be problematic since the abort/restore notification could
> > arrive too late and therefore the whole system will go to suspend
> > thinking that the guest is in desired s2ilde state. Also in this case
> > it would be impossible to prevent races and actually making sure that
> > the guest is suspended or not. We already had similar discussion with
> > Sean earlier in this thread why the notification have to be send just
> > before swait_event_exclusive(s2idle_wait_head, s2idle_state =3D=3D
> > S2IDLE_STATE_WAKE) and that the VMM have to have control over guest
> > resumption.
> >
> > Nevertheless if extending acpi_s2idle_dev_ops is possible, why not
> > extend it about the hypervisor_notify() and use it in the same place
> > where the hypercall is used in this patch? Do you see any issue with
> > that?
>
> If this needs to be a hypercall and the hypercall needs to go at that
> specific time, I wouldn't bother with extending acpi_s2idle_dev_ops.
> The whole idea there was that this would be less custom and could follow
> a spec.

Just to clarify - it probably doesn't need to be a hypercall. I've
probably misled you with copy-pasting a handler name from the current
patch but aiming your and Sean ACPI like approach. What I meant is
something like:
- extend acpi_s2idle_dev_ops with notify()
- implement notify() handler for acpi_s2idle_dev_ops in HYPE0001
driver (without hypercall):
static void s2idle_notify(void)
{
        acpi_evaluate_dsm(acpi_handle, guid_of_HYPE0001, 0,
ACPI_HYPE_NOTIFY, NULL);
}

- register it via acpi_register_lps0_dev() from HYPE0001 driver
- use it just before swait_event_exclusive(s2idle_wait_head..) as it
is with original patch (the name of the function will be different):
static void s2idle_hypervisor_notify(void)
{
         struct acpi_s2idle_dev_ops *handler;
...
         list_for_each_entry(handler, &lps0_s2idle_devops_head, list_node) =
{
                  if (handler->notify)
                          handler->notify();
          }
}

so it will be like:
-> s2idle_enter (just before swait_event_exclusive(s2idle_wait_head,.. )
--> s2idle_hypervisor_notify (as platform_s2idle_ops)
---> notify (as acpi_s2idle_dev_ops)
----> HYPE0001 device driver's notify () routine

It will probably be easier to understand it if I actually implement
it. Nevertheless this way we ensure that:
- notification will be triggered at very last command before actually
entering s2idle
- we can trap on MMIO/PIO by implementing HYPE0001 specific  _DSM
method and therefore this implementation will not become hypervisor
specific and also not use KVM as "dumb pipe out to userspace" as Sean
suggested
- we will not have to change existing Intel/AMD/Window spec (3
different LPS0 GUIDs) but thanks to HYPE0001's acpi_s2idle_dev_ops
involvment, only care about new HYPE0001 spec

>
> TBH - given the strong dependency on being the very last command and
> this being all Linux specific (you won't need to do something similar
> with Windows) - I think the way you already did it makes the most sense.
> It seems to me the ACPI device model doesn't really work well for this
> scenario.
>
> >
> >>
> >>> 2) using newly introduced acpi_s2idle_dev_ops hypervisor_notify() cal=
l
> >>> will allow to register handler from Intel x86/intel/pmc/core.c driver
> >>> and/or AMD x86/amd-pmc.c driver. Therefore we will need to get only
> >>> Intel and/or AMD approval about extending the ACPI LPS0 _DSM method,
> >>> correct?
> >>>
> >>
> >> Right now the only thing that hooks prepare()/restore() is the amd-pmc
> >> driver (unless Intel's PMC had a change I didn't catch yet).
> >>
> >> I don't think you should be changing any existing drivers but rather
> >> introduce another platform driver for this specific case.
> >>
> >> So it would be something like this:
> >>
> >> acpi_s2idle_prepare_late
> >> -> prepare()
> >> --> AMD: amd_pmc handler for prepare()
> >> --> Intel: intel_pmc handler for prepare() (conceptual)
> >> --> HYPE0001 device: new driver's prepare() routine
> >>
> >> So the platform driver would match the HYPE0001 device to load, and it
> >> wouldn't do anything other than provide a prepare()/restore() handler
> >> for your case.
> >>
> >> You don't need to change any existing specs.  If anything a new spec t=
o
> >> go with this new ACPI device would be made.  Someone would need to
> >> reserve the ID and such for it, but I think you can mock it up in adva=
nce.
> >
> > Thank you for your explanation. This means that I should register
> > "HYPE" through https://nam11.safelinks.protection.outlook.com/?url=3Dht=
tps%3A%2F%2Fuefi.org%2FPNP_ACPI_Registry&amp;data=3D05%7C01%7Cmario.limonci=
ello%40amd.com%7C49512293908e4ee17e8c08da54351ed5%7C3dd8961fe4884e608e11a82=
d994e183d%7C0%7C0%7C637914884458918039%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4w=
LjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;=
sdata=3Dv5VsnxAINiJhOMLpwORLHd13WcYBHf%2FGSNv8Bjhyino%3D&amp;reserved=3D0 b=
efore introducing
> > this new driver to Linux.
> > I have no experience with the above, so I wonder who should be
> > responsible for maintaining such ACPI ID since it will not belong to
> > any specific vendor? There is an example of e.g. COREBOOT PROJECT
> > using "BOOT" ACPI ID [1], which seems similar in terms of not
> > specifying any vendor but rather the project as a responsible entity.
> > Maybe you have some recommendations?
>
> Maybe LF could own a namespace and ID?  But I would suggest you make a
> mockup that everything works this way before you go explore too much.

Yeah, sure.

>
> Also make sure Rafael is aligned with your mockup.

Agree.

>
> >
> > I am also not sure if and where a specification describing such a
> > device has to be maintained. Since "HYPE0001" will have its own _DSM
> > so will it be required to document it somewhere rather than just using
> > it in the driver and preparing proper ACPI tables for guest?
> >
> >>
> >>> I wonder if this will be affordable so just re-thinking loudly if
> >>> there is no other mechanism that could be suggested and used upstream
> >>> so we could notify hypervisor/vmm about guest entering s2idle state?
> >>> Especially that such _DSM function will be introduced only to trap on
> >>> some fake MMIO/PIO access and will be useful only for guest ACPI
> >>> tables?
> >>>
> >>
> >> Do you need to worry about Microsoft guests using Modern Standby too o=
r
> >> is that out of the scope of your problem set?  I think you'll be a lot
> >> more limited in how this can behave and where you can modify things if=
 so.
> >>
> >
> > I do not need to worry about Microsoft guests.
>
> Makes life a lot easier :)

Agree :) and thank you for all your feedback,
Grzegorz
