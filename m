Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFDD4630E4
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 11:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhK3KX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 05:23:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55391 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231878AbhK3KXY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 05:23:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638267605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OzpFcvBbG6u7p5sms8xWPW9jQykzma+4R9XPG4RPkT8=;
        b=QGcJDTHEsdPuSndCabyaFABHr25+UExI+b17KRrvuQCDzJpQmsnod/61SNNh/jpJ19kFOh
        aowPh94PN2L2MjNeDOBR4PKBphpVUB/5d0C6oGAnmUevb6lCQLqwdFgkoezGNEEXMQiRR8
        RRQXqEgKlQpDBCVbTMh+G4ypOVbDtjw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-293-R55lZ5vGMYmIwieTWBoV5w-1; Tue, 30 Nov 2021 05:20:03 -0500
X-MC-Unique: R55lZ5vGMYmIwieTWBoV5w-1
Received: by mail-ed1-f70.google.com with SMTP id a3-20020a05640213c300b003e7d12bb925so16575075edx.9
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 02:20:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OzpFcvBbG6u7p5sms8xWPW9jQykzma+4R9XPG4RPkT8=;
        b=7eo9O27W5161KbcsGifX/7BT2cjd+4vzo9XoCUwI856XxbVFrfObOhoZvA/nKe8kYv
         oMBRej0umMKU62PZfDTieX3um+rWffwd1yn8DpcwWU63ez49f2C/CG0HXeDKO01sXbPu
         7D0bhDJgO0qCSZ5Ij75Uxiz0SRum00K5eA6WAp1bkhoo4EWfLd/8fOtGVjItt9cYsNMf
         G6agK9x7Rg3Z0rQiPOmIW2qnwIfc80dXRyFYHNGDi+e2WvZ9vrYaZ3WDcHl24MW7t6Wd
         GDt0zftYQAFZUAAIVQyQ/RkqIs3TVC6u2wzYF3ltJY1tRgs1c691v4nVkoYBKh7M+IU6
         Zp3w==
X-Gm-Message-State: AOAM531vjNZp4rBCUr+wbFg/8JxN755/ukxSG48RYRJ1wAxCGR66Qi/Y
        YMH5brFlSDRs2MMSFPYwjcIXcgPnVdpp45kDs/YBzt0lkTVhgnYbT3rtcpRf9z/CCp3INAnO4AT
        3aw3MxUecr8J2
X-Received: by 2002:a05:6402:41a:: with SMTP id q26mr83741470edv.387.1638267601484;
        Tue, 30 Nov 2021 02:20:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwO8sb5ZfWXTnqbvi0ESAmSaw67WDhY9GecOv8WBkx4Pl8wWeORH68lUXXPC0xdOlbVtjRQhg==
X-Received: by 2002:a05:6402:41a:: with SMTP id q26mr83741439edv.387.1638267601229;
        Tue, 30 Nov 2021 02:20:01 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id sh33sm9409065ejc.56.2021.11.30.02.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 02:20:00 -0800 (PST)
Date:   Tue, 30 Nov 2021 11:19:58 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 04/11] KVM: arm64: Setup a framework for hypercall
 bitmap firmware registers
Message-ID: <20211130101958.fcdqthphyhxzvzla@gator.home>
References: <20211113012234.1443009-1-rananta@google.com>
 <20211113012234.1443009-5-rananta@google.com>
 <87wnl0cdfn.wl-maz@kernel.org>
 <CAJHc60ydffBkqqb6xyObiK-66psaPODsOo0DpLFv7thx=zHjZw@mail.gmail.com>
 <20211127172720.zte6wfdguoyi3gd6@gator.home>
 <CAJHc60x=Egb=vRu1JHNK6f1ep+t+gDSKxJyfH88-w=v9pwsRsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60x=Egb=vRu1JHNK6f1ep+t+gDSKxJyfH88-w=v9pwsRsQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 04:56:19PM -0800, Raghavendra Rao Ananta wrote:
> On Sat, Nov 27, 2021 at 9:27 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Tue, Nov 23, 2021 at 10:34:23AM -0800, Raghavendra Rao Ananta wrote:
> > > On Mon, Nov 22, 2021 at 9:23 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > I keep being baffled by this. Why should we track the VMM accesses or
> > > > the VMM writeback? This logic doesn't seem to bring anything useful as
> > > > far as I can tell. All we need to ensure is that what is written to
> > > > the pseudo-register is an acceptable subset of the previous value, and
> > > > I cannot see why this can't be done at write-time.
> > > >
> > > > If you want to hide this behind a capability, fine (although my guts
> > > > feeling is that we don't need that either). But I really want to be
> > > > convinced about all this tracking.
> > > >
> > > The tracking of each owner register is necessary here to safe-guard
> > > the possibility that the user-space may not be aware of a newly
> > > introduced register, and hence, hasn't accessed it. If it had at least
> > > read the register, but not write-back, we assume that the user-space
> > > is happy with the configuration. But the fact that the register has
> > > not even been read would state that user-space is unaware of the
> > > existence of this new register. In such a case, if we don't sanitize
> > > (clear all the bits) this register, the features will be exposed
> > > unconditionally to the guest.
> > >
> > > The capability is introduced here to make sure that this new
> > > infrastructure is backward compatible with old VMMs. If the VMMs don't
> > > enable this capability, they are probably unaware of this, and this
> > > will work as it always has- expose new services to the guest
> > > unconditionally as and when they are introduced.
> >
> > Hi Raghavendra,
> >
> > I don't think we need a CAP that has to be enabled or to make any
> > assumptions or policy decisions in the kernel. I think we just need to
> > provide a bit more information to the VMM when it checks if KVM has the
> > CAP. If KVM would tell the VMM how may pseudo registers there are, which
> > can be done with the return value of the CAP, then the VMM code could be
> > something like this
> >
> >   r = check_cap(KVM_CAP_ARM_HVC_FW_REG_BMAP);
> >   if (r) {
> >     num_regs = r;
> >
> >     for (idx = 0; idx < num_regs; ++idx) {
> >       reg = hvc_fw_reg(idx);
> >
> >       if (idx > vmm_last_known_idx) {
> >         ...
> >       } else {
> >         ...
> >       }
> >     }
> >   }
> >
> > With this, the VMM is free to decide if it wants to clear all registers
> > greater than the last index it was aware of or if it wants to let those
> > registers just get exposed to the guest without knowing what's getting
> > exposed. Along with documenting that by default everything gets exposed
> > by KVM, which is the backwards compatible thing to do, then the VMM has
> > been warned and given everything it needs to manage its guests.
> >
> Hi Andrew,
> 
> Thanks for your comments and suggestions!
> 
> I like the idea of sharing info via a read of the CAP, and not having
> to explicitly sanitize/clear the registers before the guest begins to
> run.
> However the handshake is done over an API doc, which is a little
> concerning. The user-space must remember and explicitly clear any new
> register that it doesn't want to expose to the guest, while the
> current approach does this automatically.
> Any bug in VMM's implementation could be risky and unintentionally
> expose features to the guest. What do you think?

The VMM can mess things up in many ways. While KVM should protect itself
from the VMM, it shouldn't try to protect the VMM from the VMM itself. In
this case, the risk here isn't that we allow the VMM to do something that
can harm KVM, or even the guest. The risk is only that the VMM fails to do
what it wanted to do (assuming it didn't want to expose unknown features
to the guest). I.e. the risk here is only that the VMM has a bug, and it's
an easily detectable bug. I say let the VMM developers manage it.

> 
> > Another thing that might be nice is giving userspace control of how many
> > pseudo registers show up in get-reg-list. In order to migrate from a host
> > with a more recent KVM to a host with an older KVM[*] we should only
> > expose the number of pseudo registers that the older host is aware of.
> > The VMM would zero these registers out anyway, in order to be compatible
> > for migration, but that's not enough when they also show up in the list
> > (at least not with QEMU that aborts migration when the destination
> > expects less registers than what get-reg-list provides)
> >
> > [*] This isn't a great idea, but it'd be nice if we can make it work,
> > because users may want to rollback upgrades or, after migrating to a
> > host with a newer kernel, they may want to migrate back to where they
> > started.
> >
> Good point. But IIUC, if the user-space is able to communicate the
> info that it's expecting a certain get-reg-list, do you think it can
> handle it at its end too, rather than relying on the kernel to send a
> list back?

Yes, I think we can probably manage this in the VMM, and maybe/probably
that's the better place to manage it.

> 
> My assumption was that VMM would statically maintain a known set of
> registers that it wants to work with and are to be modified by hand,
> rather than relying on get-reg-list. This could be the least common
> set of registers that are present in all the host kernels (higher or
> lower versions) of the migration fleet. This config doesn't change
> even with get-reg-list declaring a new register as the features
> exposed by it could still be untested. Although, migrating to a host
> with a missing register shouldn't be possible in this setting, but if
> it encounters the scenario, it should be able to avoid migration to
> the host (similar to QEMU).
> 
> Please correct me if you think it's a false assumption to proceed with.

Your assumptions align with mine. It seems as we move towards CPU models,
get-reg-list's role will likely only be to confirm a host supports the
minimum required. We should probably implement/change the VMM to allow
migrating from a host with more registers to one with less as long as
the one with less includes all the required registers. Of course we
also need to ensure that any registers we don't want to require are
not exposed to the guest, but I guess that's precisely what we're trying
to do with this series for at least some pseudo registers.

Thanks,
drew

