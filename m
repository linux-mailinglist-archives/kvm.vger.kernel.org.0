Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0AC7CD8F3
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 12:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjJRKQU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 18 Oct 2023 06:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjJRKQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 06:16:16 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DCF106;
        Wed, 18 Oct 2023 03:16:12 -0700 (PDT)
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6c61dd1c229so1191832a34.0;
        Wed, 18 Oct 2023 03:16:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697624171; x=1698228971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wmq6BIoQQGWZuB7EAXNojI52R+YVoXIyi6ZE7ml8OAU=;
        b=fWlPsgYXax57lMZu8p/TPuYZD7i2TPTcmQSGKFJ2/w7SMdacsPJRjeLtBcMXAwT7yk
         r8BIr26CUAcIOEokg3j4QjlthZi3c2tFvog40cg6jdY8ppDM/FJd6cvaWtrJNf84ubPE
         9JCujO2epV18iMpI7SYdyqjaCw4ZiSZwOmjn8tWAPbaqSVv18EVlK8b0QitzZ0es3qRH
         5/MZb3+fpq4oquWkamoZ3dHkLfsUVJWI6vdStdSxqWfaOK7kgc8J9g/MI1iT1or90aqG
         B/w1pfBPZSpYkKLxijSysZzzzhUWaZ31YtXQtYzBfelV9u7bEO8UMbZ0A4sl6SZzBkfx
         BHBA==
X-Gm-Message-State: AOJu0YwH61QxBSXVgSOzqXFlvpGobpRo5v+xlQ7WPL4XMQlk9j8lom/F
        p3JIqEZ7H3Pu5yxVWvPcNxCmAWbYINIvE6pHVck=
X-Google-Smtp-Source: AGHT+IGGzuA6TqO+n3Y1Z8GuC1NfrQtYJNzE9ouYQJ7Q0GH3K/RwNhM+EeWfzHqmvOjDV42BRUhgN7oY2x9SYFoOWtg=
X-Received: by 2002:a4a:d897:0:b0:581:ed38:5505 with SMTP id
 b23-20020a4ad897000000b00581ed385505mr2683879oov.0.1697624171051; Wed, 18 Oct
 2023 03:16:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1697532085.git.kai.huang@intel.com> <7daec6d20bf93c2ff87268866d112ee8efd44e01.1697532085.git.kai.huang@intel.com>
 <CAJZ5v0ifJ5G7yOidiADkbwvuttVAVhVx6eSoJqBDeacZiGXZDg@mail.gmail.com> <0d5769002692aa5e2ba157b0bd47526dc0b738fb.camel@intel.com>
In-Reply-To: <0d5769002692aa5e2ba157b0bd47526dc0b738fb.camel@intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 18 Oct 2023 12:15:59 +0200
Message-ID: <CAJZ5v0jd0_bsFHTQ_5jo3chxFvEvfiPkmi0w31DGHeSWQNuWow@mail.gmail.com>
Subject: Re: [PATCH v14 21/23] x86/virt/tdx: Handle TDX interaction with ACPI
 S3 and deeper states
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "rafael@kernel.org" <rafael@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 5:22 AM Huang, Kai <kai.huang@intel.com> wrote:
>
> Hi Rafael,
> Thanks for feedback!
> >
>
>
> > > @@ -1427,6 +1429,22 @@ static int __init tdx_init(void)
> > >                 return -ENODEV;
> > >         }
> > >
> > > +#define HIBERNATION_MSG                \
> > > +       "Disable TDX due to hibernation is available. Use 'nohibernate'
> command line to disable hibernation."
> >
> > I'm not sure if this new symbol is really necessary.
> >
> > The message could be as simple as "Initialization failed: Hibernation
> > support is enabled" (assuming a properly defined pr_fmt()), because
> > that carries enough information about the reason for the failure IMO.
> >
> > How to address it can be documented elsewhere.
>
>
> The last patch of this series is the documentation patch to add TDX host.  We
> can add a sentence to suggest the user to use 'nohibernate' kernel command line
> when one sees TDX gets disabled because of hibernation being available.
>
> But isn't better to just provide such information together in the dmesg so the
> user can immediately know how to resolve this issue?
>
> If user only sees "... failed: Hibernation support is enabled", then the user
> will need additional knowledge to know where to look for the solution first, and
> only after that, the user can know how to resolve this.

I would expect anyone interested in a given feature to get familiar
with its documentation in the first place.  If they neglect to do that
and then find this message, it is absolutely fair to expect them to go
and look into the documentation after all.

> >
> > > +       /*
> > > +        * Note hibernation_available() can vary when it is called at
> > > +        * runtime as it checks secretmem_active() and cxl_mem_active()
> > > +        * which can both vary at runtime.  But here at early_init() they
> > > +        * both cannot return true, thus when hibernation_available()
> > > +        * returns false here, hibernation is disabled by either
> > > +        * 'nohibernate' or LOCKDOWN_HIBERNATION security lockdown,
> > > +        * which are both permanent.
> > > +        */
> >
> > IIUC, the role of the comment is to document the fact that it is OK to
> > use hiberation_available() here, because it cannot return "false"
> > intermittently at this point, so I would just say "At this point,
> > hibernation_available() indicates whether or not hibernation support
> > has been permanently disabled", without going into all of the details
> > (which are irrelevant IMO and may change in the future).
>
>
> Agreed.  Will do.  Thanks.
>
> >
> > > +       if (hibernation_available()) {
> > > +               pr_err("initialization failed: %s\n", HIBERNATION_MSG);
> > > +               return -ENODEV;
> > > +       }
> > > +
> > >         err = register_memory_notifier(&tdx_memory_nb);
> > >         if (err) {
> > >                 pr_err("initialization failed: register_memory_notifier()
> failed (%d)\n",
> > > @@ -1442,6 +1460,11 @@ static int __init tdx_init(void)
> > >                 return -ENODEV;
> > >         }
> > >
> > > +#ifdef CONFIG_ACPI
> > > +       pr_info("Disable ACPI S3 suspend. Turn off TDX in the BIOS to use
> ACPI S3.\n");
> > > +       acpi_suspend_lowlevel = NULL;
> > > +#endif
> >
> > It would be somewhat nicer to have a helper for setting this pointer.
> >
>
>
> OK.  Currently Xen PV dom0 also overrides the acpi_suspend_lowlevel.
>
> Do you want the helper introduced now together with this series, or it is
> acceptable to have a patch later after TDX gets merged to add a helper and
> change both Xen and TDX code to use the helper?
>
> Anyway, I suppose you mean we provide a helper in the ACPI code, and call that
> helper here in TDX code.

Yes, I do.

> Just in case you want the helper now, then I think it's better to have two
> patches to do below ?
>
>  1) A patch to introduce the helper, and change the Xen code to use it.
>  2) The current TDX patch here, but change to use the new helper to set the
>     acpi_suspend_lowlevel

Yes, this makes sense to me.

> I made the incremental diff to cover above based on this patch (see below,
> compile tested only).  And the TDX part change will be split out as mentioned
> above.
>
> Do you have any comments?
>
> diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
> index c8a7fc23f63c..e71bff60d647 100644
> --- a/arch/x86/include/asm/acpi.h
> +++ b/arch/x86/include/asm/acpi.h
> @@ -60,8 +60,10 @@ static inline void acpi_disable_pci(void)
>         acpi_noirq_set();
>  }
>
> -/* Low-level suspend routine. */
> -extern int (*acpi_suspend_lowlevel)(void);
> +typedef int (*acpi_suspend_lowlevel_t)(void);
> +
> +/* Set up low-level suspend routine. */
> +void acpi_set_suspend_lowlevel(acpi_suspend_lowlevel_t func);

I'm not sure about the typededf, but I have no strong opinion against it either.

>
>  /* Physical address to resume after wakeup */
>  unsigned long acpi_get_wakeup_address(void);
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index 2a0ea38955df..95be371305c6 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -779,11 +779,17 @@ int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
>  void (*__acpi_unregister_gsi)(u32 gsi) = NULL;
>
>  #ifdef CONFIG_ACPI_SLEEP
> -int (*acpi_suspend_lowlevel)(void) = x86_acpi_suspend_lowlevel;
> +static int (*acpi_suspend_lowlevel)(void) = x86_acpi_suspend_lowlevel;
>  #else
> -int (*acpi_suspend_lowlevel)(void);
> +static int (*acpi_suspend_lowlevel)(void);

For the sake of consistency, either use the typedef here, or don't use
it at all.

>  #endif
>
> +/* To override the default acpi_suspend_lowlevel */
> +void acpi_set_suspend_lowlevel(acpi_suspend_lowlevel_t func)
> +{
> +       acpi_suspend_lowlevel = func;
> +}
> +
>  /*
>   * success: return IRQ number (>=0)
>   * failure: return < 0
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 38ec6815a42a..c8586bee4650 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1565,7 +1565,7 @@ static int __init tdx_init(void)
>
>  #ifdef CONFIG_ACPI
>         pr_info("Disable ACPI S3 suspend. Turn off TDX in the BIOS to use ACPI
> S3.\n");
> -       acpi_suspend_lowlevel = NULL;
> +       acpi_set_suspend_lowlevel(NULL);
>  #endif
>
>         /*
> diff --git a/include/xen/acpi.h b/include/xen/acpi.h
> index b1e11863144d..81a1b6ee8fc2 100644
> --- a/include/xen/acpi.h
> +++ b/include/xen/acpi.h
> @@ -64,7 +64,7 @@ static inline void xen_acpi_sleep_register(void)
>                 acpi_os_set_prepare_extended_sleep(
>                         &xen_acpi_notify_hypervisor_extended_sleep);
>
> -               acpi_suspend_lowlevel = xen_acpi_suspend_lowlevel;
> +               acpi_set_suspend_lowlevel(xen_acpi_suspend_lowlevel);
>         }
>  }
>  #else

Otherwise LGTM.
