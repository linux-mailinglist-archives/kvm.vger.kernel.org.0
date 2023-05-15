Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9137B70417D
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 01:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243399AbjEOXrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 19:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240909AbjEOXqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 19:46:55 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8595269
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 16:46:54 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba712bb7b28so1532398276.1
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 16:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684194413; x=1686786413;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hKsIhDAHTI5ZGBx0uDNeQEoycM9HPHgfOdTtTFPu9+s=;
        b=hWjyFiegM0tb/GaofgR7rRw3hIZNOV9FsPrhVWxTiKhHWqy6v0SUvlAjliF0ErVHJ7
         Kz36gSecGJfOx5lmd37GnYQIXY/kt0kRwLdgrudskRZUGCpWfbBYEW/aGMIBWFsIIdNf
         Bv2GFO7D0fLJlIBVO20wFzOmQoSqdIVKUUFDY6qv0gMzhzh6cYjrnbd0laa41ocCHvee
         fStSOpGtclJAFcmhRcdWCFBM2yx94S5r0pXRzqTLnPqrgVOvUHR9nJoAG13J3sKPm6Vm
         ss5vrtADrgVIer0DCcDTdGWmk927umJkQYXu71KPAD7Anf9kWBmf6BqmQUqhQINReCVR
         iLFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684194413; x=1686786413;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hKsIhDAHTI5ZGBx0uDNeQEoycM9HPHgfOdTtTFPu9+s=;
        b=HIpnmmPrjuS27Cwv4XvhwEcvmkdwDcqoXCQd7G8Dsx1Z9t+AmsaBkb8BVQp3zlFDj8
         +YzklBicww3kYSkePUJRp1IUhRCMvb1sPH7bORuf2KFDrEBeMjDMETyldHDEPMgvlKLD
         xAYcBqsjCPw/fDXauyLUM5MzFa7KNL6WBvfvkdNCqB4oz/ZDJh4cxH7/4ZJrWE26Jltz
         KapmujjXEmm/Ij0OCWJ2SUiIezBwHq6EoJ1Q4uERIjeQmmZkIC/MokSv/2iPVLf6MLXI
         UEOhFt2F/s5jgCwhDU1vwGItIs1hkpCI/erCsKfMFNXDym2Ty/WawohGpqiVNOMAIth5
         XJqw==
X-Gm-Message-State: AC+VfDyDJM6ZqwP/hTzXY6/eMNAQaxw8gd0bes5a88CSB6/FMMno2lwc
        xK/7/ts8SnlCf5WI0/fOw6Aw4+lnCF0=
X-Google-Smtp-Source: ACHHUZ5nKlYqg8fqkFRiAsU+szzbdXJrcWjwocU8iSc7OEG0O5T8XFggiMvHTBNDo9CrEEoZ2dw4RNcURAY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9290:0:b0:ba8:1e5f:8514 with SMTP id
 y16-20020a259290000000b00ba81e5f8514mr184923ybl.5.1684194413294; Mon, 15 May
 2023 16:46:53 -0700 (PDT)
Date:   Mon, 15 May 2023 16:46:51 -0700
In-Reply-To: <ZFWli2/H5M8MZRiY@google.com>
Mime-Version: 1.0
References: <ZEM5Zq8oo+xnApW9@google.com> <diqz8re2ftzb.fsf@ackerleytng-ctop.c.googlers.com>
 <ZFWli2/H5M8MZRiY@google.com>
Message-ID: <ZGLEa2j4wi0t4xLI@google.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
From:   Sean Christopherson <seanjc@google.com>
To:     Ackerley Tng <ackerleytng@google.com>
Cc:     david@redhat.com, chao.p.peng@linux.intel.com, pbonzini@redhat.com,
        vkuznets@redhat.com, jmattson@google.com, joro@8bytes.org,
        mail@maciej.szmigiero.name, vbabka@suse.cz, vannapurve@google.com,
        yu.c.zhang@linux.intel.com, kirill.shutemov@linux.intel.com,
        dhildenb@redhat.com, qperret@google.com, tabba@google.com,
        michael.roth@amd.com, wei.w.wang@intel.com, rppt@kernel.org,
        liam.merwick@oracle.com, isaku.yamahata@gmail.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com, brauner@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 05, 2023, Sean Christopherson wrote:
> On Fri, May 05, 2023, Ackerley Tng wrote:
> > One issue I=E2=80=99ve found so far is that the pointer to kvm (gmem->k=
vm) is
> > not cleaned up, and hence it is possible to crash the host kernel in th=
e
> > following way
> >=20
> > 1. Create a KVM VM
> > 2. Create a guest mem fd on that VM
> > 3. Create a memslot with the guest mem fd (hence binding the fd to the
> >    VM)
> > 4. Close/destroy the KVM VM
> > 5. Call fallocate(PUNCH_HOLE) on the guest mem fd, which uses gmem->kvm
> >    when it tries to do invalidation.
> >=20
> > I then tried to clean up the gmem->kvm pointer during unbinding when th=
e
> > KVM VM is destroyed.
> >=20
> > That works, but then I realized there=E2=80=99s a simpler way to use th=
e pointer
> > after freeing:
> >=20
> > 1. Create a KVM VM
> > 2. Create a guest mem fd on that VM
> > 3. Close/destroy the KVM VM
> > 4. Call fallocate(PUNCH_HOLE) on the guest mem fd, which uses gmem->kvm
> >    when it tries to do invalidation.
> >=20
> > Perhaps binding should mean setting the gmem->kvm pointer in addition t=
o
> > gmem->bindings. This makes binding and unbinding symmetric and avoids
> > the use-after-frees described above.
>=20
> Hrm, that would work, though it's a bit convoluted, e.g. would require de=
tecting
> when the last binding is being removed.  A similar (also ugly) solution w=
ould be
> to nullify gmem->kvm when KVM dies.
>=20
> I don't love either approach idea because it means a file created in the =
context
> of a VM can outlive the VM itself, and then userspace ends up with a file=
 descriptor
> that it can't do anything with except close().  I doubt that matters in p=
ractice
> though, e.g. when the VM dies, all memory can be freed so that the file e=
nds up
> being little more than a shell.  And if we go that route, there's no need=
 to grab
> a reference to the file during bind, KVM can just grab a longterm referen=
ce when
> the file is initially created and then drop it when KVM dies (and nullifi=
es gmem->kvm).
>=20
> Blech, another wart is that I believe gmem would need to do __module_get(=
) during
> file creation to prevent kvm.ko from being unloaded after the last VM die=
s.  Ah,
> but that'd also be true if we went with a system-scoped KVM ioctl(), so I=
 suppose
> it's not _that_ ugly.
>=20
> Exchanging references (at binding or at creation) doesn't work, because t=
hat
> creates a circular dependency, i.e. gmem and KVM would pin each other.=20
>=20
> A "proper" refcounting approach, where the file pins KVM and not vice ver=
sa, gets
> nasty because of how KVM's memslots work.  The least awful approach I can=
 think of
> would be to delete the associated memslot(s) when the file is released, p=
ossibly
> via deferred work to avoid deadlock issues.  Not the prettiest thing ever=
 and in
> some ways that'd yield an even worse ABI.

Circling back to this.  Pending testing, the "proper" refcounting approach =
seems
to be the way to go.  KVM's existing memslots actually work this way, e.g. =
if
userspace does munmap() on an active memslot, KVM zaps any PTEs but the mem=
slot
stays alive.  A similar approach can be taken here, the only wrinkle is tha=
t the
association between gmem and the memslot is stronger than between VMAs and =
memslots,
specifically KVM binds the file and not simply the file descriptor.  This i=
s
necessary because not binding to an exact file would let userspace install =
a
different file at the file descriptor.

That's solvable without having to delete memslots though, e.g. by protectin=
g the
file pointer in the memslot with RCU and directly bumping the refcount in t=
he two
places where KVM needs to get at gmem (the file) via the memslot (unbind an=
d
faulting in a page).  E.g.

  static struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
  {
	struct file *file;

	rcu_read_lock();

	file =3D rcu_dereference(slot->gmem.file);
	if (file && !get_file_rcu(file))
		file =3D NULL;
	rcu_read_unlock();

	return file;
  }

The gotcha is that ->release could race with memslot deletion, as kvm_gmem_=
unbind()
won't be able to differentiate between "file was deleted" and "file is curr=
ently
being deleted".  That's easy enough to deal with though, kvm_gmem_release()=
 can
take slots_lock to prevent the memslot from going away when nullifying and
invalidating ranges for the memslot.

> Side topic, there's a second bug (and probably more lurking): kvm_swap_ac=
tive_memslots()'s
> call to synchronize_srcu_expedited() is done _before_ the call to kvm_gme=
m_unbind(),
> i.e. doesn't wait for readers in kvm_gmem_invalidate_begin() to go away. =
 The easy
> solution for that one is to add another synchronize_srcu_expedited() afte=
r unbinding.

There's a bug here, but not the one I pointed out.  Acquiring kvm->srcu doe=
sn't
provide any protection, the binding already has a pointer to the memslot, i=
.e.
isn't doing an SRCU-protected lookup in the memslots.  The actual protectio=
n is
provided by the filemap invalidate lock, which prevents unbinding a memslot=
 until
all invalidations complete, i.e. acquiring kvm->srcu in the punch hole path=
 is
completely unnecessary.
