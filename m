Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6AC699BFE
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 19:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjBPSSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 13:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBPSSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 13:18:22 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F9938EBB
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:18:20 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-532e96672b3so29282717b3.13
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hwmYF9BE+Vb5rvMm8XzkOENwcPxeFWkR8ny19dfG8TQ=;
        b=qQsZ3PqwmpbP59R+Zq8SakSYF7eyOq22r2LgcPtaMR1Y94bEt6GExvcctJ/edemj08
         TuQkS3x9wzel10WGeMMfPjILicnwbgfSgiSGO+FNkGTO5gkeTLhbTf2gmdQdwM2PM9gj
         SYU+WSRFEWF9tYYafsk8gZymg+qrjzEX+tE1N5JnJMHfwW+jORhaNPESlVE3OCVnp2q+
         PNFBYcxrrcI6J675DGbx4lrvS7/kUc4u2Gjo1RsdakehLAVlD9i8n5c6++7KxvZ+IYj0
         Bz+UsY6Td/puUKxnTkcfcseK5P9J/1BStXY5fzv29TroX7HYr9I2d7sJTjH/xeWBD3nl
         lVWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hwmYF9BE+Vb5rvMm8XzkOENwcPxeFWkR8ny19dfG8TQ=;
        b=CBvvc7QA6klPyUuxE7Qoup0fe7tsulNyNwJkHR/BTS4H2Cln0wcBPX0Pdv7KJPisYQ
         M4XrFuKJ7XD8Y2tLjf5dSnQfwoznRUaqbuKhl1im/f/l64xcCIaCFLJ3WmEw7MKexNzs
         qGjleDNVcGbgv4oqzqroi057W09ayDg4MhZAOIK1iv8xlWdjbNYPeJ73NWQSmS70WQR7
         OnhqYoppgLX9uDcML4DQeoVemyplTHkG1twrHKzx7b5b3DFsqUy8+XzJwW6kX6OYCj03
         HrU9onYG0ANQbu4312wz6yYkhsbYDB0N2bTmQSOz9vshtu1Mo+EpSvN5rBg8jkJ7BDe3
         mr/g==
X-Gm-Message-State: AO0yUKUXNXtG1gPiBKgp9V+JVGaCiLtOMSRvOKK/0odhQfcMsX6ypOPQ
        q3f0JmtTYYbg+4NqaI7Uscg3ytCjB5o=
X-Google-Smtp-Source: AK7set/MGu365/vw9W/9cYHwD5TBnMq9AoLqcukIPi3DvKYTJ0/DS6rl25Hq2/CQN7Tt0XIyHZ72vqqUk48=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:114f:b0:855:fdcb:4467 with SMTP id
 p15-20020a056902114f00b00855fdcb4467mr80ybu.0.1676571499007; Thu, 16 Feb 2023
 10:18:19 -0800 (PST)
Date:   Thu, 16 Feb 2023 10:18:17 -0800
In-Reply-To: <CAMkAt6pTNZ2_+0RNZcPFHhG-9o2q0ew0Wgd=m_T6KfLSYJyB4g@mail.gmail.com>
Mime-Version: 1.0
References: <CAAhR5DE4rYey42thw_4toKx0tEn5ZY3mRq8AJT=YQqemqvt7pw@mail.gmail.com>
 <CAMkAt6pTNZ2_+0RNZcPFHhG-9o2q0ew0Wgd=m_T6KfLSYJyB4g@mail.gmail.com>
Message-ID: <Y+5zaeJxKr6hzp4w@google.com>
Subject: Re: Issue with "KVM: SEV: Add support for SEV intra host migration"
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     Sagi Shahar <sagis@google.com>, kvm@vger.kernel.org,
        Erdem Aktas <erdemaktas@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ryan Afranji <afranji@google.com>,
        Michael Sterritt <sterritt@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 16, 2023, Peter Gonda wrote:
> On Mon, Feb 13, 2023 at 1:07 PM Sagi Shahar <sagis@google.com> wrote:
> >
> > TL;DR
> > Marking an SEV VM as dead after intra-host migration prevents cleanly tearing
> > down said VM.
> >
> > We are testing our POC code for TDX copyless migration and notice some
> > issues. We are currently using a similar scheme to the one used for
> > SEV where the VM is marked as dead after the migration is completed
> > which prevents any other IOCTLs from being triggered on the VM.
> >
> > From what we are seeing, there are at least 2 IOCTLs that VMM is
> > issuing on the source VM after the migration is completed. The first
> > one is KVM_IOEVENTFD for unwiring an eventfd used for the NVMe admin
> > queue during the NVMe device unplug sequence. The second IOCTL is
> > KVM_SET_USER_MEMORY_REGION for removing the memslots during VM
> > destruction. Failing any of these IOCTLs will cause the migration to
> > fail.

Does the VMM _need_ to cleanly teardown the source VM?  If so, why?

> > I can see 3 options:
> >
> > 1) If we want to keep the vm_dead logic as is, this means changing to
> > VMM code in some pretty hacky way. We will need to distinguish between
> > regular VM shutdown to VM shutdown after migration. We will also need
> > to make absolutely sure that we don't leave any dangling data in the
> > kernel by skipping some of the cleanup stages.
> >
> > 2) If we want to remove the vm_dead logic we can simply not mark the
> > vm as dead after migration. It looks like it will just work but might
> > create special cases where IOCTLs can be called on a TD which isn't
> > valid anymore. From what I can tell, some of these code paths are
> > already  protected by a check if hkid is assigned so it might not be a
> > big issue. Not sure how this will work for SEV but I'm guessing
> > there's a similar mechanism there as well.
> >
> > 3) We can also go half way and only block certain memory encryption
> > related IOCTLs if the VM got migrated. This will likely require more
> > changes when we try to push this ustream since it will require adding
> > a new field for vm_mem_enc_dead (or something similar) in addition to
> > the current vm_bugged and vm_dead.
> >
> > Personally, I don't want to go with option (1) since it sounds quite
> > risky to make these kind of changes without fully understanding all
> > the possible side effects.
> >
> > I prefer either option (2) or (3) but I don't know which one will be
> > more acceptable by the community.
> 
> I agree option 2 or 3 seem preferable. Option two sounds good to me, I
> am not sure why we needed to disable all IOCLTs on the source VM after
> the migration. I was just taking feedback on the review.

I don't like #2.  For all intents and purposes, the source VM _is_ dead, or at
least zombified.  It _was_ an SEV guest, but after migration it's no longer an
SEV guest, e.g. doesn't have a dedicated ASID, etc.  But the CPUID state and a
pile of register state won't be coherent, especially on SEV-ES where KVM doesn't
have visibility into guest state.

> We have the ASID similar to the HKID in SEV. I don't think the code
> paths are already protected like you mention TDX is but that seems
> like a simple enough fix. Or maybe it's better to introduce a new
> VM_MOVED like VM_BUGGED and VM_DEAD which allows most IOCTLs but just
> disables running vCPUs.

I kinda like the idea of a VM_MOVED flag, but I'm a bit leary of it from a
a maintenance and ABI perspective.  Definining and documenting what ioctls()
are/aren't allowed would get rather messy.  The beauty of VM_DEAD is that it's
all or nothing.

> What about option 4. Remove the VM_DEAD on migration and do nothing
> else.

I'm strongly against doing nothing.  It _might_ be safe from KVM's perspective,
but I would really prefer not to have to constantly think about whether or not a
given change is safe in the context of a zombified SEV guest.

> Userspace can easily make errors which cause the VM to be unusable. Does this
> error path really need support from KVM?

As above, I'm concerned with KVM's safety, not the guest's.

Depending on why the source VM needs to be cleaned up, one thought would be add
a dedicated ioctl(), e.g. KVM_DISMANTLE_VM, and make that the _only_ ioctl() that's
allowed to operate on a dead VM.  The ioctl() would be defined as a best-effort
mechanism to teardown/free internal state, e.g. destroy KVM_PIO_BUS, KVM_MMIO_BUS,
and memslots, zap all SPTEs, etc...
