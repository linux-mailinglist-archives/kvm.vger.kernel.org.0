Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2867CD9BB
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 12:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjJRKx6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 18 Oct 2023 06:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjJRKx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 06:53:57 -0400
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A24F92;
        Wed, 18 Oct 2023 03:53:56 -0700 (PDT)
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6bc57401cb9so1585914a34.0;
        Wed, 18 Oct 2023 03:53:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697626435; x=1698231235;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NYY4jvU/GmQ+pjSvZRmMeEBW6ckaypbqHe2z9FZpfJY=;
        b=GwCDJ31Ysc3IaRDfo73x5c6c2dX227x0pU1CoBU+36DsZkILyBA2m+Q/L0oDUUGKjM
         R6CiAKB+wPVknGMSzh1b8tfL6d9xhYtFHW4OMMRyZE1ZiPfICSadvCUudcsgvCkY636n
         7ic4qfqJcuIomFwN0AlUJC15s/QTvhMxG2hrQPUbnwj9Yu6Drr4zcMhuvSQOWbb5+5rL
         5++xaCkoRlxC8JUR6u+Z5xLTVVsc+fPgy0HjinttUHIrC1185v8sTu4eRVtPae+gKXZw
         JLsYFJeSKBmzm4Hv2d/GnkS/ykq4Onu9gVC92cb4czkdlVR7cv3ODbrjiS49LFpTMFpT
         oJWg==
X-Gm-Message-State: AOJu0YwXu9DwOjh6zn2/+BNpwwTv83fEol57nSWDAMD8JgC+i5sy14mf
        4wUC/1t/wkQfk01ogd3mIT/wVftZznVBTKvLyf4=
X-Google-Smtp-Source: AGHT+IGzo7yqbK4KO0OjXQa3nkvUe1eXlALQ3BN5T1K888NE7vhcqXtsu0fPzQbJd2QGSyyRMh0UO0WU2LqbumyyctE=
X-Received: by 2002:a4a:b304:0:b0:581:d5df:9cd2 with SMTP id
 m4-20020a4ab304000000b00581d5df9cd2mr4418799ooo.0.1697626435161; Wed, 18 Oct
 2023 03:53:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1697532085.git.kai.huang@intel.com> <7daec6d20bf93c2ff87268866d112ee8efd44e01.1697532085.git.kai.huang@intel.com>
 <CAJZ5v0ifJ5G7yOidiADkbwvuttVAVhVx6eSoJqBDeacZiGXZDg@mail.gmail.com>
 <0d5769002692aa5e2ba157b0bd47526dc0b738fb.camel@intel.com>
 <CAJZ5v0jd0_bsFHTQ_5jo3chxFvEvfiPkmi0w31DGHeSWQNuWow@mail.gmail.com> <1c118d563ead759d65ebd33ecee735aaff2b7630.camel@intel.com>
In-Reply-To: <1c118d563ead759d65ebd33ecee735aaff2b7630.camel@intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 18 Oct 2023 12:53:44 +0200
Message-ID: <CAJZ5v0jy0MR-VyQHQt9-zAhHoTDp-xHtFnDOre3BPmT+FNgjCQ@mail.gmail.com>
Subject: Re: [PATCH v14 21/23] x86/virt/tdx: Handle TDX interaction with ACPI
 S3 and deeper states
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "rafael@kernel.org" <rafael@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 12:51 PM Huang, Kai <kai.huang@intel.com> wrote:
>
> On Wed, 2023-10-18 at 12:15 +0200, Rafael J. Wysocki wrote:
> > On Wed, Oct 18, 2023 at 5:22 AM Huang, Kai <kai.huang@intel.com> wrote:
> > >
> > > Hi Rafael,
> > > Thanks for feedback!
> > > >
> > >
> > >
> > > > > @@ -1427,6 +1429,22 @@ static int __init tdx_init(void)
> > > > >                 return -ENODEV;
> > > > >         }
> > > > >
> > > > > +#define HIBERNATION_MSG                \
> > > > > +       "Disable TDX due to hibernation is available. Use 'nohibernate'
> > > command line to disable hibernation."
> > > >
> > > > I'm not sure if this new symbol is really necessary.
> > > >
> > > > The message could be as simple as "Initialization failed: Hibernation
> > > > support is enabled" (assuming a properly defined pr_fmt()), because
> > > > that carries enough information about the reason for the failure IMO.
> > > >
> > > > How to address it can be documented elsewhere.
> > >
> > >
> > > The last patch of this series is the documentation patch to add TDX host.  We
> > > can add a sentence to suggest the user to use 'nohibernate' kernel command line
> > > when one sees TDX gets disabled because of hibernation being available.
> > >
> > > But isn't better to just provide such information together in the dmesg so the
> > > user can immediately know how to resolve this issue?
> > >
> > > If user only sees "... failed: Hibernation support is enabled", then the user
> > > will need additional knowledge to know where to look for the solution first, and
> > > only after that, the user can know how to resolve this.
> >
> > I would expect anyone interested in a given feature to get familiar
> > with its documentation in the first place.  If they neglect to do that
> > and then find this message, it is absolutely fair to expect them to go
> > and look into the documentation after all.
>
> OK.  I'll remove HIBERNATION_MSG and just print the message suggested by you.
>
> And in the documentation patch, add one sentence to tell user when this happens,
> add 'nohibernate' to resolve.
>
>
> [...]
>
> > >
> > > -/* Low-level suspend routine. */
> > > -extern int (*acpi_suspend_lowlevel)(void);
> > > +typedef int (*acpi_suspend_lowlevel_t)(void);
> > > +
> > > +/* Set up low-level suspend routine. */
> > > +void acpi_set_suspend_lowlevel(acpi_suspend_lowlevel_t func);
> >
> > I'm not sure about the typededf, but I have no strong opinion against it either.
> >
> > >
> > >  /* Physical address to resume after wakeup */
> > >  unsigned long acpi_get_wakeup_address(void);
> > > diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> > > index 2a0ea38955df..95be371305c6 100644
> > > --- a/arch/x86/kernel/acpi/boot.c
> > > +++ b/arch/x86/kernel/acpi/boot.c
> > > @@ -779,11 +779,17 @@ int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
> > >  void (*__acpi_unregister_gsi)(u32 gsi) = NULL;
> > >
> > >  #ifdef CONFIG_ACPI_SLEEP
> > > -int (*acpi_suspend_lowlevel)(void) = x86_acpi_suspend_lowlevel;
> > > +static int (*acpi_suspend_lowlevel)(void) = x86_acpi_suspend_lowlevel;
> > >  #else
> > > -int (*acpi_suspend_lowlevel)(void);
> > > +static int (*acpi_suspend_lowlevel)(void);
> >
> > For the sake of consistency, either use the typedef here, or don't use
> > it at all.
>
> Ah right.
>
> Since you don't prefer the typedef, I'll abandon it:
>
> E.g,:
>
> void acpi_set_suspend_lowlevel(int (*suspend_lowlevel)(void))
> {
>         acpi_suspend_lowlevel = suspend_lowlevel;
> }
>
> Let me know whether this looks good to you?

Yes, this is fine with me.

> [...]
>
> >
> > Otherwise LGTM.
>
> Thanks. I'll split the helper patch out and include it to the next version of
> this series.
>
