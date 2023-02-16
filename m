Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BE8699C7B
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 19:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBPSkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 13:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBPSkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 13:40:41 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8043773A
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:40:38 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id s8so2959536ljp.2
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RnMIt9bnD7wu1F07oZKc3PilekU/6n+6FHRDumzc86Y=;
        b=Gc7PdyPlyXxguZiljzwytZvv24ednOVuDLzY6afquonF+u7ybs/MKVXMHiLjEdvLNl
         rdrqBaNqeCXfi+hUzhXqHyY0Mx9ZVQbMcJ4Y+yKDdqe5B3AJwjeEFt8SdV1c5jO9J8TS
         wn47Sv3woYnowMkEqYUPhhs+iaVxC8so3WnYHBpK+casd/rA6zLqRZ0PA0s3EEMMQ6Wn
         sDkB62VXNZQYBycJgOXGguCBQFs5eelaXn6s+1eO12ULsJfLE8uzOVcgAgnq67pWW6CJ
         gzyaqGHyDcfPgn4jwlTJHv3Q822gtaovw/1s1YzEGz5TAw8+4LexRHBgeIZbTEN7lJBK
         ftYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RnMIt9bnD7wu1F07oZKc3PilekU/6n+6FHRDumzc86Y=;
        b=LvIb+6uJi00tqCYOod4HzKxXfXsTK6NBEUfx7RrnQEasisTMVt2d72liSHmRyRUYba
         h7mcql1rwPx7FZS6WMoVmZTCeeWoFyDxC8sHZ5tsDWpb12Yw+24JE4jhLZWj9Or6eW5+
         ExfKUnXY1txDS0q8WBu5XY72N/P43kqRBOj0mZoFQnpJ4EtGzrgnzD6u8AT5yX+RPYCG
         OfUTf9Bd02is9B6nQA4eoGeQCwS0IM7gg5lCCfjsdj0oDSYzULZqzWzOmtN/vpq55Zvd
         f98NkcSum8dku5s2+ReZpHPg7egFNLnSoGOx8ftoMVzuIZ0fT8IG93F+nJI/Atn3zLtu
         +npQ==
X-Gm-Message-State: AO0yUKVE8xjdu5akTodeVHbpFNVgGeM7j5AfVr0ZZGgKWM/1BD05PCTp
        SclUVOZN6t/qI95YUsIF7xhS17jQ0IIGDmXzpm6bwA==
X-Google-Smtp-Source: AK7set8d1ow8EwFVcWsYe3UhF/Y/BVKZ+jmgNE4AHtQsnrzbBExG0wMqBkQiRH5Oea6ywGOdHY+k64dCkT9M35dUXVg=
X-Received: by 2002:a05:651c:1719:b0:293:4e6d:f4f7 with SMTP id
 be25-20020a05651c171900b002934e6df4f7mr1937041ljb.3.1676572836926; Thu, 16
 Feb 2023 10:40:36 -0800 (PST)
MIME-Version: 1.0
References: <CAAhR5DE4rYey42thw_4toKx0tEn5ZY3mRq8AJT=YQqemqvt7pw@mail.gmail.com>
 <CAMkAt6pTNZ2_+0RNZcPFHhG-9o2q0ew0Wgd=m_T6KfLSYJyB4g@mail.gmail.com> <Y+5zaeJxKr6hzp4w@google.com>
In-Reply-To: <Y+5zaeJxKr6hzp4w@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 16 Feb 2023 11:40:24 -0700
Message-ID: <CAMkAt6rq855c2691cqvPh6A7vj0qXWtgDNniL_s8ZqLmcsTJFw@mail.gmail.com>
Subject: Re: Issue with "KVM: SEV: Add support for SEV intra host migration"
To:     Sean Christopherson <seanjc@google.com>
Cc:     Sagi Shahar <sagis@google.com>, kvm@vger.kernel.org,
        Erdem Aktas <erdemaktas@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ryan Afranji <afranji@google.com>,
        Michael Sterritt <sterritt@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 16, 2023 at 11:18 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Feb 16, 2023, Peter Gonda wrote:
> > On Mon, Feb 13, 2023 at 1:07 PM Sagi Shahar <sagis@google.com> wrote:
> > >
> > > TL;DR
> > > Marking an SEV VM as dead after intra-host migration prevents cleanly tearing
> > > down said VM.
> > >
> > > We are testing our POC code for TDX copyless migration and notice some
> > > issues. We are currently using a similar scheme to the one used for
> > > SEV where the VM is marked as dead after the migration is completed
> > > which prevents any other IOCTLs from being triggered on the VM.
> > >
> > > From what we are seeing, there are at least 2 IOCTLs that VMM is
> > > issuing on the source VM after the migration is completed. The first
> > > one is KVM_IOEVENTFD for unwiring an eventfd used for the NVMe admin
> > > queue during the NVMe device unplug sequence. The second IOCTL is
> > > KVM_SET_USER_MEMORY_REGION for removing the memslots during VM
> > > destruction. Failing any of these IOCTLs will cause the migration to
> > > fail.
>
> Does the VMM _need_ to cleanly teardown the source VM?  If so, why?
>
> > > I can see 3 options:
> > >
> > > 1) If we want to keep the vm_dead logic as is, this means changing to
> > > VMM code in some pretty hacky way. We will need to distinguish between
> > > regular VM shutdown to VM shutdown after migration. We will also need
> > > to make absolutely sure that we don't leave any dangling data in the
> > > kernel by skipping some of the cleanup stages.
> > >
> > > 2) If we want to remove the vm_dead logic we can simply not mark the
> > > vm as dead after migration. It looks like it will just work but might
> > > create special cases where IOCTLs can be called on a TD which isn't
> > > valid anymore. From what I can tell, some of these code paths are
> > > already  protected by a check if hkid is assigned so it might not be a
> > > big issue. Not sure how this will work for SEV but I'm guessing
> > > there's a similar mechanism there as well.
> > >
> > > 3) We can also go half way and only block certain memory encryption
> > > related IOCTLs if the VM got migrated. This will likely require more
> > > changes when we try to push this ustream since it will require adding
> > > a new field for vm_mem_enc_dead (or something similar) in addition to
> > > the current vm_bugged and vm_dead.
> > >
> > > Personally, I don't want to go with option (1) since it sounds quite
> > > risky to make these kind of changes without fully understanding all
> > > the possible side effects.
> > >
> > > I prefer either option (2) or (3) but I don't know which one will be
> > > more acceptable by the community.
> >
> > I agree option 2 or 3 seem preferable. Option two sounds good to me, I
> > am not sure why we needed to disable all IOCLTs on the source VM after
> > the migration. I was just taking feedback on the review.
>
> I don't like #2.  For all intents and purposes, the source VM _is_ dead, or at
> least zombified.  It _was_ an SEV guest, but after migration it's no longer an
> SEV guest, e.g. doesn't have a dedicated ASID, etc.  But the CPUID state and a
> pile of register state won't be coherent, especially on SEV-ES where KVM doesn't
> have visibility into guest state.
>
> > We have the ASID similar to the HKID in SEV. I don't think the code
> > paths are already protected like you mention TDX is but that seems
> > like a simple enough fix. Or maybe it's better to introduce a new
> > VM_MOVED like VM_BUGGED and VM_DEAD which allows most IOCTLs but just
> > disables running vCPUs.
>
> I kinda like the idea of a VM_MOVED flag, but I'm a bit leary of it from a
> a maintenance and ABI perspective.  Definining and documenting what ioctls()
> are/aren't allowed would get rather messy.  The beauty of VM_DEAD is that it's
> all or nothing.
>
> > What about option 4. Remove the VM_DEAD on migration and do nothing
> > else.
>
> I'm strongly against doing nothing.  It _might_ be safe from KVM's perspective,
> but I would really prefer not to have to constantly think about whether or not a
> given change is safe in the context of a zombified SEV guest.

What if it was the responsibility of sev_vm_move_enc_context_from()
(and I assume tdx_vm_move_enc_context_from) to put the VM and its
vCPUs into a safe state with regard to KVM. That state can be
completely broken for running the VM though as it would need to be for
SEV-ES and TDX.


>
> > Userspace can easily make errors which cause the VM to be unusable. Does this
> > error path really need support from KVM?
>
> As above, I'm concerned with KVM's safety, not the guest's.
>
> Depending on why the source VM needs to be cleaned up, one thought would be add
> a dedicated ioctl(), e.g. KVM_DISMANTLE_VM, and make that the _only_ ioctl() that's
> allowed to operate on a dead VM.  The ioctl() would be defined as a best-effort
> mechanism to teardown/free internal state, e.g. destroy KVM_PIO_BUS, KVM_MMIO_BUS,
> and memslots, zap all SPTEs, etc...
