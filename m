Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58309414538
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 11:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbhIVJgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 05:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbhIVJgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 05:36:17 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2CDC061762
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 02:34:48 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id x124so3515277oix.9
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 02:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/C5mpNbBmoPckO9Tuag0+wSlj6t5R7giav+EX45XDOs=;
        b=eHUe3bWDDn4qkPUZo4L4Z0fcAsB9+J9fwawyvO20NlVVljHF5Dtyq9mp40XzuCfugU
         NHEckbfbiVwqEWpnfEPq8bTt1o37LWXNGtrqfr0sFfYNgS8h8tWThWGcTQci4jAos33h
         n6Rkq9dFWSiwcS4K93c93eBqCfSRWtyHNFtUdbY9NhzsAtomPXkjDbXP75bohHWU5UKH
         kmPOTplel3Q/Av0SQdbKvDCGPHWq72z8LXny4D7Yp4kmDD+CCc+jkvB8PvBI5ZFiBmOC
         DnG/42K+/Kdmy0ACKkEn36FZY/SgTJaP857A2cCbQt5wvhCIh0HENe/1hFreclaSwL32
         rF1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/C5mpNbBmoPckO9Tuag0+wSlj6t5R7giav+EX45XDOs=;
        b=Y3lStEHVqledYahU4+pR52Gb5lK59rJUbzxIxUZAXFq9DdXADZr2vVjCo6tyvAUyTK
         Gulaj/iU4MJtNYFnD9af3mgg0RccqKUXduysiLg81PEwX6V4CvSgHIi6NjUbFjWpf+Yl
         gJS9O4m/h/7PxPVKmIzxnuxF/MIKrfaSyPSoJfxOWh57tvyff6QO126UJQu/5VaBdRvp
         IK5hlx+kvSnsrcdeSSlsR23lBGS1REHDcxdLsC9tKPy3WQR82EjXyE0fRTfL+1W/t6qC
         MK0JPH1qNnG5PGnAhd8aSMHTejMSVH+11PympaEQU58Au2OW7u7nFVsFsQ9OynJQX3k3
         69Fw==
X-Gm-Message-State: AOAM53016og0SrkcYPjtsaSwvoz12ki5DQPbYUxN0l8MABWOpfyhD1/Q
        LoOedsGH4fxvubVSCBhC+hihYUn27PcLBaCX8OBEEw==
X-Google-Smtp-Source: ABdhPJw2dFdgLvXM1SuivMLDkuM1fFDGcYbJFC1w6JcFr8gg6Ni02AGH23NLtCL/i+T7xPsvIBHzYOWc2NbQAOc7svQ=
X-Received: by 2002:aca:604:: with SMTP id 4mr265229oig.8.1632303287537; Wed,
 22 Sep 2021 02:34:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210827101609.2808181-1-tabba@google.com> <20210827101609.2808181-3-tabba@google.com>
 <20210908123837.exyhsn6t2c7nmbox@gator>
In-Reply-To: <20210908123837.exyhsn6t2c7nmbox@gator>
From:   Fuad Tabba <tabba@google.com>
Date:   Wed, 22 Sep 2021 10:34:11 +0100
Message-ID: <CA+EHjTx+Rfd4UXvNPnL8siGfM=7PuWxCtKuWOGDRyMqEQKgxPw@mail.gmail.com>
Subject: Re: [PATCH v5 2/8] KVM: arm64: Add missing field descriptor for MDCR_EL2
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

On Wed, Sep 8, 2021 at 1:38 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Aug 27, 2021 at 11:16:03AM +0100, Fuad Tabba wrote:
> > It's not currently used. Added for completeness.
> >
> > No functional change intended.
> >
> > Suggested-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_arm.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index 327120c0089f..a39fcf318c77 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -295,6 +295,7 @@
> >  #define MDCR_EL2_HPMFZO              (UL(1) << 29)
> >  #define MDCR_EL2_MTPME               (UL(1) << 28)
> >  #define MDCR_EL2_TDCC                (UL(1) << 27)
> > +#define MDCR_EL2_HLP         (UL(1) << 26)
> >  #define MDCR_EL2_HCCD                (UL(1) << 23)
> >  #define MDCR_EL2_TTRF                (UL(1) << 19)
> >  #define MDCR_EL2_HPMD                (UL(1) << 17)
> > --
> > 2.33.0.259.gc128427fd7-goog
> >
>
> If we're proactively adding bits per the most recent spec, then I guess we
> could also add HPMFZS (bit 36). Otherwise,

Seems someone has beaten me to it. HPMFZS is in 5.15-rc2 at least
(which I'm going to be rebasing on/respinning).

Thanks,
/fuad

>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
