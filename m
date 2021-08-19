Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAC33F2201
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 23:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhHSVBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 17:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhHSVBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 17:01:15 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A18FC061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 14:00:39 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id u22so15642661lfq.13
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 14:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AvQxXkt+Y6T63punRpouLEiLYsNbGvwmAz8WS2jurfQ=;
        b=ZHJEMjfbNtf35/3ppqO8FcW3EFGc2NwLvO7lliyfTYD1V0n6TJ5XeANhrwSukFXGOX
         GGgDsPfdM7qXmFqZDk2BDcVTdONCimPPNwcSKABKAFEJFgq9zbheE8v07glt5S1C9vt6
         bhSZgY58nsHjAKnWfCThu2+tIy3YFtK5xNiKCB5l2GwFwzu+EvCxTVpzUiaDpWP/z78p
         BLS4SkE+NV3yQ5n4FshQidB5qaRn5URGvO7sn7YsN6Zz44zkzUdl4y9VhDIPCouRcKdy
         DYM279xkUC8peyXwJarTC2OV+W8+KxfV5HMupHVWOzb448KigQIwDGtABxLM1uCErlhc
         2vzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AvQxXkt+Y6T63punRpouLEiLYsNbGvwmAz8WS2jurfQ=;
        b=FduYUOH4rV//PwOKqD1UCqRVxazM9pYEV9oEcMx7RCMuOEN8YTtwz1wP3nOIGXfbkd
         3nVDrnBO0G5zd9Lr9o7z9zewrmJ77sf+Fj9zEhLXZfvdSbGg90w6Z0fFM762RQ1sD9aS
         JfytWrsp4OZ91CVQ4ycctMXzJCjeODH+sr2gnxeW4hRCw6M+DOOqfZbd3EpQs2DssjBz
         1lr6I1T1MYPqWW+vjcrJZT7kU4Z6PXwlhKU6kBnEipsAVYwBPtICtWtiI92bTkkEnT44
         zVdN3P0caa/GfbZpY6txGhZrm2FjHkybpXUe8AvxsRprLPnl3eDqOwPWdNynXCub1yqP
         KjYg==
X-Gm-Message-State: AOAM5300rotIQTCxivm3CWo5wjBHAEhAwA/PicmWJ66Y7kuS2eDBsxLX
        LZFg/kLaqNrwdvEQcXDbfg8FC7qcGs2Jn+3CY17nSzDD9K27Ww==
X-Google-Smtp-Source: ABdhPJxp++TjNQXMJ8YzShPEqdPBvPvWAicd6N7rmRgG0JhAycXTuNBtCUcrdcmI3FunPK8cEQ8Mj7WKWWnhFK53gM4=
X-Received: by 2002:a19:6541:: with SMTP id c1mr11833577lfj.423.1629406836921;
 Thu, 19 Aug 2021 14:00:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210819154910.1064090-1-pgonda@google.com> <20210819154910.1064090-2-pgonda@google.com>
 <CAA03e5Gh0kJYHP1R3F7uh6x83LBFPp=af2xt7q3epgg+8XW53g@mail.gmail.com>
In-Reply-To: <CAA03e5Gh0kJYHP1R3F7uh6x83LBFPp=af2xt7q3epgg+8XW53g@mail.gmail.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 19 Aug 2021 15:00:25 -0600
Message-ID: <CAMkAt6oJcW3MHP3fod9RnRHCEYp-whdEtBTyfuqgFgATKa=3Hg@mail.gmail.com>
Subject: Re: [PATCH 1/2 V4] KVM, SEV: Add support for SEV intra host migration
To:     Marc Orr <marcorr@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> >
> > +static int svm_sev_lock_for_migration(struct kvm *kvm)
> > +{
> > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +       int ret;
> > +
> > +       /*
> > +        * Bail if this VM is already involved in a migration to avoid deadlock
> > +        * between two VMs trying to migrate to/from each other.
> > +        */
> > +       spin_lock(&sev->migration_lock);
> > +       if (sev->migration_in_progress)
> > +               ret = -EBUSY;
> > +       else {
> > +               /*
> > +                * Otherwise indicate VM is migrating and take the KVM lock.
> > +                */
> > +               sev->migration_in_progress = true;
> > +               mutex_lock(&kvm->lock);
> > +               ret = 0;
> > +       }
> > +       spin_unlock(&sev->migration_lock);
> > +
> > +       return ret;
> > +}
> > +
> > +static void svm_unlock_after_migration(struct kvm *kvm)
> > +{
> > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +
> > +       mutex_unlock(&kvm->lock);
> > +       WRITE_ONCE(sev->migration_in_progress, false);
> > +}
> > +
>
> This entire locking scheme seems over-complicated to me. Can we simply
> rely on `migration_lock` and get rid of `migration_in_progress`? I was
> chatting about these patches with Peter, while he worked on this new
> version. But he mentioned that this locking scheme had been suggested
> by Sean in a previous review. Sean: what do you think? My rationale
> was that this is called via a VM-level ioctl. So serializing the
> entire code path on `migration_lock` seems fine. But maybe I'm missing
> something?
>

Marc I think that only having the spin lock could result in
deadlocking. If userspace double migrated 2 VMs, A and B for
discussion, A could grab VM_A.spin_lock then VM_A.kvm_mutex. Meanwhile
B could grab VM_B.spin_lock and VM_B.kvm_mutex. Then A attempts to
grab VM_B.spin_lock and we have a deadlock. If the same happens with
the proposed scheme when A attempts to lock B, VM_B.spin_lock will be
open but the bool will mark the VM under migration so A will unlock
and bail. Sean originally proposed a global spin lock but I thought a
per kvm_sev_info struct would also be safe.
