Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F1D18398E
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 20:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgCLTe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 15:34:58 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39487 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgCLTe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 15:34:58 -0400
Received: by mail-ed1-f68.google.com with SMTP id df19so2758564edb.6;
        Thu, 12 Mar 2020 12:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tjc8SoLQ0iPPs5R6tqoI7FEpA5bssvpFOpirSCG9AUo=;
        b=CFZ1HPm0mxFV0beitDy0baFDD/IA1iQOtNcX1sDKDUi2JvKxVFWtJv64b1wCvb+L2+
         4Vlei0IZRqkcHMyais94mQH/rseflDbTa3yLUqm1ZBp+ni9gJM8D2ek7r5bjejHJYcz6
         z3JGe09vZUpswT4lHddMzyq2cy/pJyFz0Xgk/NEdOrYVIfbDIeSEL+mvF3ttCxElcun1
         n0hDLu3eomFsKuI6PnEIhRkNcGoyBsMvMC/1Es7U+bhA/vhB057W1+Jst8rlibJAtfBR
         x2IJIKwTglXpJfyxEQvk56g/Ft8kNy97UpmgnRA22JtO4eAD1lWB4gRoTAWuGJlIZTvx
         xCmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tjc8SoLQ0iPPs5R6tqoI7FEpA5bssvpFOpirSCG9AUo=;
        b=NOFpgO5c4aDUVc1i3NAypZhUFZhTW7Uw7oUabKTKjuNt9rTEj3XRwO4W7M71GEn9X0
         7t6a9AFXg6hIVNgn6QFAzIM32fhqYN8kcuwiAPh9Uy129I2DohV4VaLP2SlotzEcTJbk
         ePamlK0yRS1u4XpGkPlRWevU69O4yMTLRNp9721eAboLtGX8pI7+1Cr41Mjj5TV5emJa
         LJT5NwCqw0Z6c9t9LzFDQ5G77HYs6CMJI1e8fSUtBVabv+Rx0seInC7yuJHy9tDAiOdx
         7Ez3azlzpsvjR/V8hJbBo7L6EppF+3TLBGhIsQFESK5LvI77HKTDHTxw3Kpxc3g33CrN
         86iQ==
X-Gm-Message-State: ANhLgQ09E7Dcpdh2m4byOr/bIodBld/MlE4VMkox4896bfObH+mZ3Ni1
        BKXxAIDhtvCZpfMz/DMqVtAR+hBWHr1KPjlpE3ZAKb/N
X-Google-Smtp-Source: ADFU+vtUp1Wbm3wLnbEbvXOKoGZ7oChMTHWtz3SGgqckSy0cx/rsf5so0GzY5TvzZqr/Qc3C0E/ssx8h2eE+BcXyKMc=
X-Received: by 2002:a50:8d11:: with SMTP id s17mr8282457eds.243.1584041695236;
 Thu, 12 Mar 2020 12:34:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200309182017.3559534-1-arilou@gmail.com> <20200309182017.3559534-3-arilou@gmail.com>
 <DM5PR2101MB104761F98A44ACB77DA5B414D7FE0@DM5PR2101MB1047.namprd21.prod.outlook.com>
 <20200310032453.GC3755153@jondnuc> <MW2PR2101MB10522800EB048383C227F556D7FF0@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <87d09hr89w.fsf@vitty.brq.redhat.com> <MW2PR2101MB10527BA547449B34FEC65C1FD7FD0@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <20200312191216.GA2950@jondnuc> <MW2PR2101MB1052572531F218BF7DAFBA2AD7FD0@MW2PR2101MB1052.namprd21.prod.outlook.com>
In-Reply-To: <MW2PR2101MB1052572531F218BF7DAFBA2AD7FD0@MW2PR2101MB1052.namprd21.prod.outlook.com>
From:   Jon Doron <arilou@gmail.com>
Date:   Thu, 12 Mar 2020 21:34:43 +0200
Message-ID: <CAP7QCogGPQTzEJDAeJGvJT3FBr2BQ9QvCJYGoQ12W99JqdjrtA@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] x86/hyper-v: Add synthetic debugger definitions
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     vkuznets <vkuznets@redhat.com>, Wei Liu <wei.liu@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sure thing

On Thu, Mar 12, 2020 at 9:32 PM Michael Kelley <mikelley@microsoft.com> wrote:
>
> From: Jon Doron <arilou@gmail.com>  Sent: Thursday, March 12, 2020 12:12 PM
> >
> > On 12/03/2020, Michael Kelley wrote:
> > >From: Vitaly Kuznetsov <vkuznets@redhat.com>  Sent: Thursday, March 12, 2020 6:51 AM
> > >>
> > >> Michael Kelley <mikelley@microsoft.com> writes:
> > >>
> > >> > I'm flexible, and trying to not be a pain-in-the-neck. :-)  What would
> > >> > the KVM guys think about putting the definitions in a KVM specific
> > >> > #include file, and clearly marking them as deprecated, mostly
> > >> > undocumented, and used only to support debugging old Windows
> > >> > versions?
> > >>
> > >> I *think* we should do the following: defines which *are* present in
> > >> TLFS doc (e.g. HV_FEATURE_DEBUG_MSRS_AVAILABLE,
> > >> HV_STATUS_OPERATION_DENIED, ...) go to asm/hyperv-tlfs.h, the rest
> > >> (syndbg) stuff goes to kvm-specific include (I'd suggest we just use
> > >> hyperv.h we already have).
> > >>
> > >> What do you think?
> > >>
> > >
> > >I could live with this proposal, since they *are* in the TLFS v6.0 as it
> > >exists today. However, v6.0 seems inconsistent in what parts of this
> > >debugging functionality it exposes, probably just because someone
> > >hasn't thought comprehensively about the topic across the whole
> > >document.   I'll make sure that it gets looked at in the next revision
> > >(which should be a lot sooner that the 2+ years it took to get the v6.0
> > >revision done).   But I won't be surprised if the remaining vestiges are
> > >removed at that time, in which case we would want to move the
> > >definitions from hyperv-tlfs.h to KVM's hyper.h.
> > >
> > >Michael
> >
> > Hi guys, just a quick note I went over the old HyperV TLFS and it seems
> > like all the Syndbg MSRs are documented (under Appendix F: Hypervisor
> > Synthetic MSRs, from v5.0b).
> >
> > It seems like the undocumented stuff is HV_X64_MSR_SYNDBG_OPTIONS which
> > seems kinda odd because that's how you enable the hypercalls debugging
> > interface which is documented.
> >
> > And the syndbg CPUID leafs are not documented as well.
> >
> > So would you like me to put all the MSRs in the tlfs omitting the
> > HV_X64_MSR_SYNDBG_OPTIONS.
> >
> > So in hyperv.h we will have HV_X64_MSR_SYNDBG_OPTIONS and the CPUID
> > leafs.
> >
>
> Could you make the decision based on the new v6.0 of the Hyper-V TLFS?
> See https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/reference/tlfs
> to get a copy.  I think some of the synthetic debugger stuff has been dropped
> from the v6.0 version compared with the earlier v5.0 versions, and I'd like the
> updates to hyperv-tlfs.h to reflect that newest version.
>
> Michael
