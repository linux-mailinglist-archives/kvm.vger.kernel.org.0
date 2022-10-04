Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9415E5F4B15
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 23:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbiJDVpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 17:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiJDVpa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 17:45:30 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412126DFBF
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 14:42:22 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id l5so15745298oif.7
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 14:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tUiG3KEdRdFU/79MvVCURB+qW7ZI0HS3P36OkLnQvtY=;
        b=ApIjn6ltK4LBXJDNcZazY7sJZVKwOyLX80i2EhcG8NiQplJonilZS0EoMLq7OFSRBG
         mkPI7hX3UMQY9vg0t9VzZUiHZmpdPugHfgU86s2kD771z/5IR+2ZpshkwhamwhJl3DOV
         o3/1YM6L7jigqxOgKFT9gVjxGw7thhj7/CmuQ7YCMIPuruF7/GXmsJvGx29ZyiQPTrUL
         p8DICzdfn2vzyo86cO6RxcwH0T/EmM97VrXsE0oK6dVhvGH8osdCqSNMVudpKV/Hav+/
         AzN4PP3y/mL9IeFanpK1GjCcPZN5louE+1EBeSRvMV+sFrHa4tk4NfHQnUcIbZJibqaO
         FKKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tUiG3KEdRdFU/79MvVCURB+qW7ZI0HS3P36OkLnQvtY=;
        b=mS0/UllTW9C8SZEWcn5oeQ3IIhVzBHgaDOTeLYDzRWaHwkDO3gBVfJzSlK1K3JB577
         IMMc+I4zLRX9rkdaVSweaMY5+aeRvJE4EAZB23sWhBtt+MqeYRTO4bLRR9BWpRk7bz6h
         3tZ//jxSfe82k4gULidS5AJGyrQo+xpOF3sfJjxx12M7ylk1iXxQto5RjUQA5XM/I6I2
         yIVE6L8h/3K+Bjd9/2GS59sMLb3b1HcZcmMki5/lQ7/v54lnIyEY+yunWXCryRcaX9jv
         foOfJtvRKDKklSS8T5A4nkiKZ4pFHILm1HEbI6dmA+xl1MWaE+UJGosxDyfU1hR5LfEJ
         W09A==
X-Gm-Message-State: ACrzQf3XbHdfRTGhO4SzQJu1pYE7MvI8/QDL1Ez99fO/ESEgSZeKom9o
        ghkcDnkhKeCdg/67sfkvd4K27eZeqivCOAPqWBXsnw==
X-Google-Smtp-Source: AMsMyM6nP3TVuTZp7jHtR6lvBOJl55g7MMgmZIt/mo+5Q6XPe7FrB/knilv+IV3GDMazhGdPLsW52EfhHDIkEeZQQjQ=
X-Received: by 2002:aca:180b:0:b0:352:8bda:c428 with SMTP id
 h11-20020aca180b000000b003528bdac428mr815670oih.13.1664919741054; Tue, 04 Oct
 2022 14:42:21 -0700 (PDT)
MIME-Version: 1.0
References: <547a1203-0339-7ad2-9505-eab027046298@intel.com>
 <CALMp9eRTp9Jemy91o0S9Fz4JYFdQ5rM36g4uWhp5LsncCQHRwA@mail.gmail.com> <c7a0b0f1-5a74-7f8c-b707-bce8086bc4c7@intel.com>
In-Reply-To: <c7a0b0f1-5a74-7f8c-b707-bce8086bc4c7@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 4 Oct 2022 14:42:10 -0700
Message-ID: <CALMp9eTD+GeiKK9E5_JUOy7YXPTq9z2f2LcyXZL5ypQ6vBHrHg@mail.gmail.com>
Subject: Re: Finish removing MPX from arch/x86?
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 4, 2022 at 2:07 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 10/4/22 11:21, Jim Mattson wrote:
> > On Tue, Oct 4, 2022 at 10:45 AM Dave Hansen <dave.hansen@intel.com> wrote:
> >>
> >> We zapped the userspace MPX ABIs and most of its supporting code in here:
> >>
> >>         45fc24e89b7c ("x86/mpx: remove MPX from arch/x86")
> >>
> >> But, the XSAVE enabling and KVM code were left in place.  This let folks
> >> at least keep running guests with MPX.
> >>
> >> It's been a couple of years and I don't think I've had a single person
> >> opine about the loss of MPX.  Intel also followed through and there's no
> >> MPX to be found on newer CPUs like my "Tiger Lake" 11th Gen Intel(R)
> >> Core(TM) i7-1165G7.
> >>
> >> Is it time to zap MPX from arch/x86/kvm/?
> >
> > Until Google Cloud retires all of our MPX-capable hardware, we will
> > require MPX support in KVM.
> >
> > Removing that support would leave VMs with MPX enabled in XCR0 with
> > nowhere to go.
>
> Is this because you migrate guest VMs between hosts?  A _potential_ VM
> migration target host is ineligible if it has a subset of the features
> of the source host?

Yes, we migrate between hosts. On a kernel upgrade, most VMs are
migrated. (Some, like those with pass-through GPUs, are terminated on
host maintenance.)

The problem is that KVM_SET_XCRS will fail on an MPX-incapable target
host if the vCPU has XCR0[4:3] set.

> Would it be _possible_ to leave existing VMs alone, but to stop
> enumerating MPX to newly-created VMs?  I don't know how long-lived your
> VMs are, but I'm hoping that the ones that know about MPX will all die
> naturally of old age at some point.

Once we get buy-in from all stakeholders, then we have to give
customers one year notice, and only then can we stop enumerating the
feature for newly created VMs.

While most of our VMs don't live long, there is a long, long tail. If
I had to guess, it might take anywhere from 5 to 10 years for the
remaining MPX VMs to die off.
