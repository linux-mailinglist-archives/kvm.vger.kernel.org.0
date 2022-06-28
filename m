Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7F255EB80
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 19:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbiF1Rzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 13:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbiF1Rz3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 13:55:29 -0400
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E0EF0D;
        Tue, 28 Jun 2022 10:55:23 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id o19so16974547ybg.2;
        Tue, 28 Jun 2022 10:55:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d/K3uK9czM2AfMF4jLStX27UoeGzElv+mW5P0Wyew2s=;
        b=a6tmfx4RS91KbPPsEKSq9MW0EWhbaKIe3ABVmuLVOHMnw5Jd0uRfUzWpDX+Tc+RCvO
         mM/eniQBPGeoN7O5CkYMVxmpL3UCCSCjRWaE+aGC6I47spqtERjX5rLypUbXg1QU2NDz
         LcOkbYt8Q3cB9jd1JiBjCs5NEiBD5dHIuNsP6iSqxT8s653qO5/CReB9nRgMIzSCbtRx
         u6ty1V8R/lNApWK6rvqSKlezmPoByzVu3T1KnAC9awUVtErD/Sss7fd+mj/j7ZD+e6eK
         Qlm59GwN6W1NM1NuaQUH/4Kh68zWK7NRfn9GN4GQIjDnvc2NcitanpUNRLeyo+bz3D/F
         DJAw==
X-Gm-Message-State: AJIora/NJ7UhrPgB9sB1FlLEbDIX6mfKhrkClu2JH8Kqvec1MJXeM+pe
        ZE44rpwPb7Xn+ue6VDevLakve6ZoIT2/ZfWjoYQW8EU3
X-Google-Smtp-Source: AGRyM1v/ywFkJLLkjz7H/T/b6Mi1Mx+Iv51xRUVw/JSK0iYaV9iae+UatVM9VpQ65PphmXiAD0kj3ZYK9LpaZh7UZJk=
X-Received: by 2002:a25:ae26:0:b0:66d:1fdc:263c with SMTP id
 a38-20020a25ae26000000b0066d1fdc263cmr6540314ybj.137.1656438922500; Tue, 28
 Jun 2022 10:55:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655894131.git.kai.huang@intel.com> <87dc19c47bad73509359c8e1e3a81d51d1681e4c.1655894131.git.kai.huang@intel.com>
 <CAJZ5v0jEJNdmkidvcOiRn+OVt01D5095t+nyXaJHKsqEAOvcBQ@mail.gmail.com> <198860d65d277dbd30552526a707576db4281b29.camel@intel.com>
In-Reply-To: <198860d65d277dbd30552526a707576db4281b29.camel@intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 28 Jun 2022 19:55:11 +0200
Message-ID: <CAJZ5v0iyNZN2U+R3_X2vpsChjcufb=mcZrt3xR=oU0zsWcSufg@mail.gmail.com>
Subject: Re: [PATCH v5 03/22] cc_platform: Add new attribute to prevent ACPI
 memory hotplug
To:     Kai Huang <kai.huang@intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm-devel <kvm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Len Brown <len.brown@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        isaku.yamahata@intel.com, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 23, 2022 at 2:09 AM Kai Huang <kai.huang@intel.com> wrote:
>
> On Wed, 2022-06-22 at 13:45 +0200, Rafael J. Wysocki wrote:
> > On Wed, Jun 22, 2022 at 1:16 PM Kai Huang <kai.huang@intel.com> wrote:
> > >
> > > Platforms with confidential computing technology may not support ACPI
> > > memory hotplug when such technology is enabled by the BIOS.  Examples
> > > include Intel platforms which support Intel Trust Domain Extensions
> > > (TDX).
> > >
> > > If the kernel ever receives ACPI memory hotplug event, it is likely a
> > > BIOS bug.  For ACPI memory hot-add, the kernel should speak out this is
> > > a BIOS bug and reject the new memory.  For hot-removal, for simplicity
> > > just assume the kernel cannot continue to work normally, and just BUG().
> > >
> > > Add a new attribute CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED to indicate the
> > > platform doesn't support ACPI memory hotplug, so that kernel can handle
> > > ACPI memory hotplug events for such platform.
> > >
> > > In acpi_memory_device_{add|remove}(), add early check against this
> > > attribute and handle accordingly if it is set.
> > >
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > ---
> > >  drivers/acpi/acpi_memhotplug.c | 23 +++++++++++++++++++++++
> > >  include/linux/cc_platform.h    | 10 ++++++++++
> > >  2 files changed, 33 insertions(+)
> > >
> > > diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> > > index 24f662d8bd39..94d6354ea453 100644
> > > --- a/drivers/acpi/acpi_memhotplug.c
> > > +++ b/drivers/acpi/acpi_memhotplug.c
> > > @@ -15,6 +15,7 @@
> > >  #include <linux/acpi.h>
> > >  #include <linux/memory.h>
> > >  #include <linux/memory_hotplug.h>
> > > +#include <linux/cc_platform.h>
> > >
> > >  #include "internal.h"
> > >
> > > @@ -291,6 +292,17 @@ static int acpi_memory_device_add(struct acpi_device *device,
> > >         if (!device)
> > >                 return -EINVAL;
> > >
> > > +       /*
> > > +        * If the confidential computing platform doesn't support ACPI
> > > +        * memory hotplug, the BIOS should never deliver such event to
> > > +        * the kernel.  Report ACPI CPU hot-add as a BIOS bug and ignore
> > > +        * the memory device.
> > > +        */
> > > +       if (cc_platform_has(CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED)) {
> >
> > Same comment as for the acpi_processor driver: this will affect the
> > initialization too and it would be cleaner to reset the
> > .hotplug.enabled flag of the scan handler.
> >
> >
>
> Hi Rafael,
>
> Thanks for review.  The same to the ACPI CPU hotplug handling, this is illegal
> also during kernel boot.

What do you mean?

Is it not correct to enumerate any memory device through ACPI at all?

>  If we just want to disable, then perhaps something like below?
>
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -366,6 +366,9 @@ static bool __initdata acpi_no_memhotplug;
>
>  void __init acpi_memory_hotplug_init(void)
>  {
> +       if (cc_platform_has(CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED))
> +               acpi_no_memhotplug = true;
> +

This looks fine to me if the above is the case, but you need to modify
the changelog to match.

>         if (acpi_no_memhotplug) {
>                 memory_device_handler.attach = NULL;
>                 acpi_scan_add_handler(&memory_device_handler);
>
>
> --
