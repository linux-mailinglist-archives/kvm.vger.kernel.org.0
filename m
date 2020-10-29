Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6975E29F6F7
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 22:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgJ2VfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 17:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJ2VfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 17:35:18 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78F8C0613CF;
        Thu, 29 Oct 2020 14:35:16 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id u62so5270256iod.8;
        Thu, 29 Oct 2020 14:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o/fZRhurDRoh3x2KXwZGFT2Yi8JsbQLcBDCy2LAivAY=;
        b=gGuTqV/6UjMeGtDxjXYhwQPHTl/X7tzC8nyDkopIigNmkrO3mCPbuH/1MhlZEXs368
         ilsmPmjF8/8PcamJS4tzXcIssUUJKuowmvAaZpvnATyfAuLpyzByye2ob5V27GVE8qIT
         KZP17N/xFAWoIKkVe0RuMkFayeP8BWuJYRQfihoxN9IcITuyVnsNMyFFHot0k3ChkDxn
         nFZSLwwceJfQxsoqw1O2SZk7WDZNX5WeTFIk5dkyBtO3OtvmEbw8mG/eVrbi8eoLhfOn
         0GZOx0BOnNgBQieydv87h3zVPKI0C/CSIt6VEOi3C7rjEkzw5bkznPJoY5+aGh/Uu3xA
         /g8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=o/fZRhurDRoh3x2KXwZGFT2Yi8JsbQLcBDCy2LAivAY=;
        b=KinZ6hrbkXJ3h3DclDuBAp8Nhpaw739QgjhpYXN2kOq16mF6EKn8Ncz8nxq1cB+RdC
         loTEqq5lPm4snNchDLwNgIUKdnDY5cHv1ycThuX+/LrmKeNpMBzlZD88dUtS8DRtT0fS
         O1WK6EcWuJg5q8WjYvucVAqpNoOV23EL3FR22XeNqy3YpSc45KlMYLS6anuZH/AbWyao
         HIC/o+eJgLkW6NEezx/TYHyDJpi9pUkGguel+AXgTrEL14OcltJbt+1MeSDaBytRBaLM
         2Og8NWATW8Ty1bf4EMJL9uBGBpDN6puw4xlIk1fX0FCDL3Y3UVJeo0WcBT3Ak+eGyphi
         48Uw==
X-Gm-Message-State: AOAM530rBehHEPLKdCyAg69CswAyeQ1Lz1y2STmerKwBdnO3UkUCVFrP
        9pbUYcrhb5F1jAkIq7T++vY=
X-Google-Smtp-Source: ABdhPJyTkgnuu9ypsiIO3xCkmwdOh4o3IIPvbsxF62gfZSdk4g2zCe1B1vFwKdXsPs4FzLAVBSR7HA==
X-Received: by 2002:a05:6602:22cf:: with SMTP id e15mr5087695ioe.1.1604007316212;
        Thu, 29 Oct 2020 14:35:16 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id r3sm3065346iog.55.2020.10.29.14.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 14:35:15 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Thu, 29 Oct 2020 17:35:12 -0400
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        David Laight <David.Laight@ACULAB.COM>,
        'Arnd Bergmann' <arnd@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH] [v2] x86: apic: avoid -Wshadow warning in header
Message-ID: <20201029213512.GA34524@rani.riverdale.lan>
References: <20201028212417.3715575-1-arnd@kernel.org>
 <38b11ed3fec64ebd82d6a92834a4bebe@AcuMS.aculab.com>
 <20201029165611.GA2557691@rani.riverdale.lan>
 <93180c2d-268c-3c33-7c54-4221dfe0d7ad@redhat.com>
 <87v9esojdi.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87v9esojdi.fsf@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 29, 2020 at 09:41:13PM +0100, Thomas Gleixner wrote:
> On Thu, Oct 29 2020 at 17:59, Paolo Bonzini wrote:
> > On 29/10/20 17:56, Arvind Sankar wrote:
> >>> For those two just add:
> >>> 	struct apic *apic = x86_system_apic;
> >>> before all the assignments.
> >>> Less churn and much better code.
> >>>
> >> Why would it be better code?
> >> 
> >
> > I think he means the compiler produces better code, because it won't
> > read the global variable repeatedly.  Not sure if that's true,(*) but I
> > think I do prefer that version if Arnd wants to do that tweak.
> 
> It's not true.
> 
>      foo *p = bar;
> 
>      p->a = 1;
>      p->b = 2;
> 
> The compiler is free to reload bar after accessing p->a and with
> 
>     bar->a = 1;
>     bar->b = 1;
> 
> it can either cache bar in a register or reread it after bar->a
> 
> The generated code is the same as long as there is no reason to reload,
> e.g. register pressure.
> 
> Thanks,
> 
>         tglx

It's not quite the same.

https://godbolt.org/z/4dzPbM

With -fno-strict-aliasing, the compiler reloads the pointer if you write
to the start of what it points to, but not if you write to later
elements.
