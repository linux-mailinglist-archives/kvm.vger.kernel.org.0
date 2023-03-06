Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62876ACF3F
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 21:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCFUeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 15:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjCFUeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 15:34:17 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54DE392A5
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 12:34:15 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id n17-20020a056a000d5100b005e5e662a4ccso6012096pfv.4
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 12:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678134855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IO/IPOM+7z+TthmIwkyRbXTYScu6FAx2J2T5Y3exvW0=;
        b=iF099/KgN5YuGpSeUk8zAZ36CLRlI5owJ1YiAGxvYsitF/zw/RdlTK0222r1RQduoe
         dVAUIN4YY2F0gS8Ie1Z9r/UFZeBCecfDMfLY77tIbjF1HpymOu4PfOmIKQ35wPcB3AO/
         xuyn0SQF21B27j1YzZ8kQ4yZuKMLJrMaV809Nm+iCTfRTRemnsa3ZFBqF+diBUNmltWp
         rlopQtybj6FGXtiaLUggnCittXo77mj1racJ4kS+CIU3UeabGqVk5PwMvujkXVco8kNv
         yb3SjwH2l5kZwrTCtYQHY593J034W9WSa7gU+xselMY38dF6/SG2DiyBEsACsWjNeJzh
         lx8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678134855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IO/IPOM+7z+TthmIwkyRbXTYScu6FAx2J2T5Y3exvW0=;
        b=p2qcx/95QWlPCaKh2kR8Wh8WC+DGD8reNjLj0rszKzBeqBxPJS6SxkXColDgU8VT4d
         i2i4MT3WCrJd6LdeBxuPbZfOYmHZLeUFAWz10xFoQAc9Y4XbojMQdzhcX8lP4CVSQyLY
         Ral6JGkrOz2+U8dKvsIVQwYL6+mjN0RTziGfzpAK1O2WjUpP90eJSWwYwLNiW8Rvyvn8
         F5ZLvUoDOCbkcw5wWXw7p8ONMvA2K80pUcfNAGZjU/8Wnzrq4dK+9wTOycN+hnFF5xAY
         3xy3rUtk6Su/RwwKdF+bBOpnVa3RfRTjKSHRl0Au8sdBxOYvNDs/aZUSocSkTh5S+S6o
         1pag==
X-Gm-Message-State: AO0yUKX8YPCFx989nNvl8TX5rmM8DRuZsmXuc28GkVwPVZN5/CM8iVWP
        pkKykuJ1borOfqGiashdWpB39zhWALY=
X-Google-Smtp-Source: AK7set/c+ryOkqfjCmpCf2GuTepFvKVkqw1Ws5fzt4IpHoAq1tAYwPgE2ls9KQCP0l0XQwooW+qh88JYhdo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:8645:0:b0:5a8:9872:2b9b with SMTP id
 x66-20020a628645000000b005a898722b9bmr5138153pfd.1.1678134855360; Mon, 06 Mar
 2023 12:34:15 -0800 (PST)
Date:   Mon, 6 Mar 2023 12:34:13 -0800
In-Reply-To: <DS0PR11MB6373C317B71C7B1BABB9BED2DCB09@DS0PR11MB6373.namprd11.prod.outlook.com>
Mime-Version: 1.0
References: <20230301133841.18007-1-wei.w.wang@intel.com> <CALzav=eRYpnfg7bVQpVawAMraFdHu3OzqWr55Pg1SJC_Uh8t=Q@mail.gmail.com>
 <DS0PR11MB637348F1351260F8B7E97A15DCB29@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZAAsIBUuIIO1prZT@google.com> <DS0PR11MB6373DAA05CEF9AB8A83A6499DCB29@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CAL715WLo90-JkJe6=GfX755t1jvaW-kqD_w++hv3Ed53fhLC3w@mail.gmail.com>
 <DS0PR11MB63735E9AC8F4636AF27DAA4ADCB39@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CAL715WJsV3tPkMDK0exgHeuKOP9kJtc62Ra0jnRhT1Gd6AiEWg@mail.gmail.com>
 <ZAIwEZdYcrs5EcHE@google.com> <DS0PR11MB6373C317B71C7B1BABB9BED2DCB09@DS0PR11MB6373.namprd11.prod.outlook.com>
Message-ID: <ZAZM7z2O1vV5MZjn@google.com>
Subject: Re: [PATCH v1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 04, 2023, Wang, Wei W wrote:
> On Saturday, March 4, 2023 1:36 AM, David Matlack wrote:
> > > > On Friday, March 3, 2023 2:12 AM, Mingwei Zhang wrote:
> > > > > > On Thursday, March 2, 2023 12:55 PM, Mingwei Zhang wrote:
> > > > > > > I don't get it. Why bothering the type if we just do this?
> > > > > > >
> > > > > > > diff --git a/include/linux/kvm_host.h
> > > > > > > b/include/linux/kvm_host.h index 4f26b244f6d0..10455253c6ea
> > > > > > > 100644
> > > > > > > --- a/include/linux/kvm_host.h
> > > > > > > +++ b/include/linux/kvm_host.h
> > > > > > > @@ -848,7 +848,7 @@ static inline void kvm_vm_bugged(struct
> > > > > > > kvm
> > > > > > > *kvm)
> > > > > > >
> > > > > > >  #define KVM_BUG(cond, kvm, fmt...)                           \
> > > > > > >  ({                                                           \
> > > > > > > -     int __ret = (cond);                                     \
> > > > > > > +     int __ret = !!(cond);                                   \
> > > > > >
> > > > > > This is essentially "bool __ret". No biggie to change it this way.
> > > > >
> > > > > !! will return an int, not a boolean, but it is used as a boolean.
> > > >
> > > > What's the point of defining it as an int when actually being used as a
> > Boolean?
> > > > Original returning of an 'int' is a bug in this sense. Either
> > > > returning a Boolean or the same type (length) as cond is good way to me.
> > >
> > > What's the point of using an integer? I think we need to ask the
> > > original author. But I think one of the reasons might be convenience
> > > as the return value. I am not sure if we can return a boolean in the
> > > function. But it should be fine here since it is a macro.
> > >
> > > Anyway, returning an 'int' is not a bug. The bug is the casting from
> > > 'cond' to the integer that may lose information and this is what you
> > > have captured.
> > 
> > typeof() won't work if cond is a bitfield. See commit 8d4fbcfbe0a4 ("Fix
> > WARN_ON() on bitfield ops") from Linus from back in 2007:
> 
> Yes, this seems to be a good reason for not going for typeof. Thanks for sharing.

Ya, just make __ret a bool.  I'm 99% certain I just loosely copied from WARN_ON(),
but missed the !!.
