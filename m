Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C1955ED16
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 20:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbiF1SzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 14:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiF1SzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 14:55:07 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0040622BC8
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 11:55:05 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id v14so19006070wra.5
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 11:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tpoiNispwIfZZhtxwBOMhINQHk5v4AhSkJUslzUIPog=;
        b=H9I4TNnT0bAVKMPjSzohuSsXlSJcjCJM7+ONHRNnForyEJnYNNXksy4abney70RbjS
         zGBDNfKYq/KM1uEC1WLVnGftwgXAM+YzA09E/AH7m9lXUY3hvTWqLstAipEEs6xqtGQk
         CqfYvTih7VZx48LQT1vOdp0nm/b4clYT4cqJlgT+u3RjpVFvi+O9WJZk+unyaCKgLaSC
         GzahywbtilgoLkyi7neaONOp5s3CUeRpjzBsUycg3Yk7MQZLEfcUHZXwgvGIk9+N1Eol
         dT/a2EKdHhGaRZUNYMIoN6WkfQrT6+1UxkV71mawQi2QGYE491YOsF+9w6HwmxZw5mUT
         byig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tpoiNispwIfZZhtxwBOMhINQHk5v4AhSkJUslzUIPog=;
        b=zLtafDGyjsWUcKXY9rvLCr4AHV/xACJRldwaAbqNXGxc23oqq9d+RgAJXzsSMt4dqH
         VoGetsk877YbAJGvNzPFS5JFpB5YVH74DLX8IgijRb50VR8GejftNu7br61U6XPtsq4L
         jIH2vfsmQwPrXDykgyX7P6VjCrevrXw4xbUo2nKlFxVwD3zWZwREAR8gpUPOHLiTLASq
         xwVkMX5hV7K0TcYqZtC682Ti6h94SPebvuMuZiUzMoCq4r8G8njP8kgu9j2+z9K3BzzB
         41ZVwKOlWtU1O9DsNyE9zm7U3JmQrJpFSRMYmqAuWMvSeY2crYP4+U3mM2SJQXd8KBGy
         5nBw==
X-Gm-Message-State: AJIora8M5EpLHTd2d8ArEndwLYNUrtAZf67uiP0a428DLYVUOxBTUX17
        vgLqQ+fZGpkquczzRrbFFX1Yy1kiU1CjixAPdFX2tw==
X-Google-Smtp-Source: AGRyM1vBpkT8cTnWOhqG+SoV+E/4Ll9MLz0q+i3XnyBGLfvf7mC8nzjP85bkyJhsEYtGLfZd02HPtiYhxpdIeWgocYE=
X-Received: by 2002:a05:6000:1705:b0:21b:bcff:39d3 with SMTP id
 n5-20020a056000170500b0021bbcff39d3mr18228382wrc.502.1656442504268; Tue, 28
 Jun 2022 11:55:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220623234944.141869-1-pcc@google.com> <YrXu0Uzi73pUDwye@arm.com>
 <CAMn1gO7-qVzZrAt63BJC-M8gKLw4=60iVUo6Eu8T_5y3AZnKcA@mail.gmail.com>
 <YrmXzHXv4babwbNZ@arm.com> <CAMn1gO5s2m-AkoYpY0dcLkKVyEAGeC2borZfgT09iqc=w_LZxQ@mail.gmail.com>
 <YrtBIX0/0jyAdgnz@arm.com>
In-Reply-To: <YrtBIX0/0jyAdgnz@arm.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Tue, 28 Jun 2022 11:54:51 -0700
Message-ID: <CAMn1gO7aC1zqWDt1bAk_ds8ejuhx2obo-LE-2UwFXch=uNFoAA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Michael Roth <michael.roth@amd.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Steven Price <steven.price@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 10:58 AM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> On Mon, Jun 27, 2022 at 11:16:17AM -0700, Peter Collingbourne wrote:
> > On Mon, Jun 27, 2022 at 4:43 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > On Fri, Jun 24, 2022 at 02:50:53PM -0700, Peter Collingbourne wrote:
> > > > On Fri, Jun 24, 2022 at 10:05 AM Catalin Marinas
> > > > <catalin.marinas@arm.com> wrote:
> > > > > + Steven as he added the KVM and swap support for MTE.
> > > > >
> > > > > On Thu, Jun 23, 2022 at 04:49:44PM -0700, Peter Collingbourne wrote:
> > > > > > Certain VMMs such as crosvm have features (e.g. sandboxing, pmem) that
> > > > > > depend on being able to map guest memory as MAP_SHARED. The current
> > > > > > restriction on sharing MAP_SHARED pages with the guest is preventing
> > > > > > the use of those features with MTE. Therefore, remove this restriction.
> > > > >
> > > > > We already have some corner cases where the PG_mte_tagged logic fails
> > > > > even for MAP_PRIVATE (but page shared with CoW). Adding this on top for
> > > > > KVM MAP_SHARED will potentially make things worse (or hard to reason
> > > > > about; for example the VMM sets PROT_MTE as well). I'm more inclined to
> > > > > get rid of PG_mte_tagged altogether, always zero (or restore) the tags
> > > > > on user page allocation, copy them on write. For swap we can scan and if
> > > > > all tags are 0 and just skip saving them.
> > > >
> > > > A problem with this approach is that it would conflict with any
> > > > potential future changes that we might make that would require the
> > > > kernel to avoid modifying the tags for non-PROT_MTE pages.
> > >
> > > Not if in all those cases we check VM_MTE_ALLOWED. We seem to have the
> > > vma available where it matters. We can keep PG_mte_tagged around but
> > > always set it on page allocation (e.g. when zeroing or CoW) and check
> > > VM_MTE_ALLOWED rather than VM_MTE.
> >
> > Right, but for avoiding tagging we would like that to apply to as many
> > pages as possible. If we check VM_MTE_ALLOWED then the heap pages of
> > those processes that are not using MTE would not be covered, which on
> > a mostly non-MTE system would be a majority of pages.
>
> By non-MTE system, I guess you mean a system that supports MTE but most
> of the user apps don't use it.

Yes, that's what I meant.

> That's why it would be interesting to see
> the effect of using DC GZVA instead of DC ZVA for page zeroing.
>
> I suspect on Android you'd notice the fork() penalty a bit more with all
> the copy-on-write having to copy tags. But we can't tell until we do
> some benchmarks. If the penalty is indeed significant, we'll go back to
> assessing the races here.

Okay, I can try to measure it. I do feel rather strongly though that
we should try to avoid tagging pages as much as possible even ignoring
the potential performance implications.

Here's one more idea: we can tag pages eagerly as you propose, but
introduce an opt-out. For example, we introduce a MAP_NOMTE flag,
which would prevent tag initialization as well as causing any future
attempt to mprotect(PROT_MTE) to fail. Allocators that know that the
memory will not be used for MTE in the future can set this flag. For
example, Scudo can start setting this flag once MTE has been disabled
as it has no mechanism for turning MTE back on once disabled. And that
way we will end up with no tags on the heap in the processes with MTE
disabled. Mappings with MAP_NOMTE would not be permitted in the guest
memory space of MTE enabled guests. For executables mapped by the
kernel we may consider adding a bit to the ELF program headers to
enable MAP_NOMTE.

> Another thing that won't happen for PG_mte_tagged currently is KSM page
> merging. I had a patch to allow comparing the tags but eventually
> dropped it (can dig it out).
>
> > Over the weekend I thought of another policy, which would be similar
> > to your original one. We can always tag pages which are mapped as
> > MAP_SHARED. These pages are much less common than private pages, so
> > the impact would be less. So the if statement in
> > alloc_zeroed_user_highpage_movable would become:
> >
> > if ((vma->vm_flags & VM_MTE) || (system_supports_mte() &&
> >                                  (vma->vm_flags & VM_SHARED)))
> >
> > That would allow us to put basically any shared mapping in the guest
> > address space without needing to deal with races in sanitise_mte_tags.
>
> It's not just about VM_SHARED. A page can be effectively shared as a
> result of a fork(). It is read-only in all processes but still shared
> and one task may call mprotect(PROT_MTE).

I see, so VM_SHARED isn't that useful for this then.

> Another case of sharing is between the VMM and the guest though I think
> an mprotect() in the VMM would trigger the unmapping of the guest
> address and pages mapped into guests already have PG_mte_tagged set.
>
> We probably need to draw a state machine of all the cases. AFAICT, we
> need to take into account a few of the below (it's probably incomplete;
> I've been with Steven through most of them IIRC):
>
> 1. Private mappings with mixed PROT_MTE, CoW sharing and concurrent
>    mprotect(PROT_MTE). That's one of the things I dislike is that a late
>    tag clearing via set_pte_at() can happen without breaking the CoW
>    mapping. It's a bit counter-intuitive if you treat the tags as data
>    (rather than some cache), you don't expect a read-only page to have
>    some (tag) updated.
>
> 2. Shared mappings with concurrent mprotect(PROT_MTE).
>
> 3. Shared mapping restoring from swap.
>
> 4. Private mapping restoring from swap into CoW mapping.
>
> 5. KVM faults.
>
> 6. Concurrent ptrace accesses (or KVM tag copying)
>
> What currently risks failing I think is breaking a CoW mapping with
> concurrent mprotect(PROT_MTE) - we set PG_mte_tagged before zeroing the
> tags. A concurrent copy may read stale tags. In sanitise_mte_tags() we
> do this the other way around - clear tags first and then set the flag.
>
> I think using another bit as a lock may solve most (all) of these but
> another option is to treat the tags as data and make sure they are set
> before mapping.
>
> > We may consider going further than this and require all pages mapped
> > into guests with MTE enabled to be PROT_MTE.
>
> We discussed this when upstreaming KVM support and the idea got pushed
> back. The main problem is that the VMM may use MTE for itself but can no
> longer access the guest memory without the risk of taking a fault. We
> don't have a match-all tag in user space and we can't teach the VMM to
> use the PSTATE.TCO bit since driver emulation can be fairly generic.
> And, of course, there's also the ABI change now.

It sounds like MAP_NOMTE would solve this problem. Since tag
initialization becomes independent of the memory access attributes, we
don't have a risk of tag check faults in the VMM.

> > I think it would allow
> > dropping sanitise_mte_tags entirely. This would not be a relaxation of
> > the ABI but perhaps we can get away with it if, as Cornelia mentioned,
> > QEMU does not currently support MTE, and since crosvm doesn't
> > currently support it either there's no userspace to break AFAIK. This
> > would also address a current weirdness in the API where it is possible
> > for the underlying pages of a MAP_SHARED file mapping to become tagged
> > via KVM, said tags are exposed to the guest and are discarded when the
> > underlying page is paged out.
>
> Ah, good point, shared file mappings is another reason we did not allow
> MAP_SHARED and MTE for guest memory.
>
> BTW, in user_mem_abort() we should probably check for VM_MTE_ALLOWED
> irrespective of whether we allow MAP_SHARED or not.

Yes, that sounds like a good idea. If we made MAP_NOMTE clear
VM_MTE_ALLOWED then I think that's the only check we would need.

> > We can perhaps accomplish it by dropping
> > support for KVM_CAP_ARM_MTE in the kernel and introducing something
> > like a KVM_CAP_ARM_MTE_V2 with the new restriction.
>
> That's an option for the ABI upgrade but we still need to solve the
> potential races.

With MAP_NOMTE I think we wouldn't need an ABI change at all.

Peter
