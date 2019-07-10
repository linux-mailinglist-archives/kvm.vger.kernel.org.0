Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C7D64A7E
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 18:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfGJQIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 12:08:52 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41356 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbfGJQIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 12:08:51 -0400
Received: by mail-lj1-f194.google.com with SMTP id d24so2653186ljg.8
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 09:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CJxDK0esYDmjL/x+EJnp4IaaO5P+avYidSceeJgeGcw=;
        b=gI/2tbgSPjjheRJ2a4h2ciKlGGl0WrtFshGXu/LbFkKSOXhOT2X3jI4061owuxH+1x
         UIuhHxaf2RtPHqZ5wwPb/Ank1hQ5cLcKJh76E4QjotkfegYO4CKW2ygvQCnb5KWkjan2
         BnD9Q0+70JRi7nGh4jOmQLWKFS0RndhH/lHRCHyKp3gI1CLIh/+FN44EQbPSM4IK6fgj
         rXFMuZPNHKAsDc0X7VBWomBn3mtjw1e9Y+8VJ9am6gdSz9xaQqKZvE2YkCoLipcLcO3X
         B8cVu2gHksfU2Tz7lG6ijpblSky69mr0JN7FEyz6apW1fMoDKOPr1YQvgHOQSR+1YZoH
         Zc8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CJxDK0esYDmjL/x+EJnp4IaaO5P+avYidSceeJgeGcw=;
        b=tVacszRr8vCCBVjhClAKKmZj9ggsa4i0XhjCEZMNI0PMkpKpZTHOpa6yMlLauUIIZo
         T83jx/YKuzRHb/4TXnb1fsNFeqvjiWKyFDrqtj0o2bVKeRif5FVitINUM7HF9nTsfmN0
         5h5IQcK6UZIkLNQbnE5kbMwuocepEAi+A0vKuKHC5i63ynDHSlZKcdHbHU9R8pdFn44B
         ZMu2WZT1vGX1TB7Ooi03Pa+hbV5ASWwY37vlriS0YVcBTOTlMs8y+MWUEv9FBcxozRFD
         a5RSa0sgbZxidjhv0fSd5JuRtmYvTWmsdgtSg+o4SJGiT6TZvHc/albaWTqt4H+3HZgk
         DziQ==
X-Gm-Message-State: APjAAAX+nNILi4WJdnpA66x8kQLrxj5o6vfc3XXGY5m1Y/2rK5ZCba0J
        c2pXRx5WpfSdvc042QoZT0hOGeMxtX7tBwcL5DXM+g==
X-Google-Smtp-Source: APXvYqyB+5RE84bmLW/RlASH7H8mOMybWgdfdvsV63IUZqq3Z5jPxdqYRuL2Un76XxWcV7OctrCK+3PUqBkL6mr4Gt8=
X-Received: by 2002:a2e:96d0:: with SMTP id d16mr18212808ljj.14.1562774928875;
 Wed, 10 Jul 2019 09:08:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190531184159.260151-1-aaronlewis@google.com>
 <4b50c550-308e-2b88-053e-c6933f9ed320@oracle.com> <CAAAPnDGbyVcxwGYcvZG2PJKxWSgJzHXV+q3uvH3mg6dmggBFyA@mail.gmail.com>
In-Reply-To: <CAAAPnDGbyVcxwGYcvZG2PJKxWSgJzHXV+q3uvH3mg6dmggBFyA@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 10 Jul 2019 09:08:37 -0700
Message-ID: <CAAAPnDF5zfWMn4VBhjdkMj+r3BAvd_x8mWzazjJ8cz8cSePeyw@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: nVMX: Enforce must-be-zero bits in the
 IA32_VMX_VMCS_ENUM MSR
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Marc Orr <marcorr@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 18, 2019 at 7:15 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> On Tue, Jun 4, 2019 at 10:52 AM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
> >
> >
> > On 5/31/19 11:41 AM, Aaron Lewis wrote:
> > > According to the SDM, bit 0 and bits 63:10 of the IA32_VMX_VMCS_ENUM
> > > MSR are reserved and are read as 0.
> > >
> > > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > > Reviewed-by: Jim Mattson <jmattson@google.com>
> > > Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > > ---
> > >   arch/x86/kvm/vmx/nested.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index 6401eb7ef19c..3438279e76bb 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -1219,6 +1219,8 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
> > >       case MSR_IA32_VMX_EPT_VPID_CAP:
> > >               return vmx_restore_vmx_ept_vpid_cap(vmx, data);
> > >       case MSR_IA32_VMX_VMCS_ENUM:
> > > +             if (data & (GENMASK_ULL(63, 10) | BIT_ULL(0)))
> > > +                     return -EINVAL;
> > >               vmx->nested.msrs.vmcs_enum = data;
> > >               return 0;
> > >       default:
> >
> >
> > Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> >
>
> ping


ping
