Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE446F8D42
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 02:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbjEFAzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 20:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjEFAzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 20:55:44 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B075FD6
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 17:55:41 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-643b490e744so399139b3a.3
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 17:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683334540; x=1685926540;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zRRGoezVjrIJz5N+FioPcqJbdxQwzqiRfGJICB0gSl0=;
        b=UpYChMPZgxXrJfH4l23tzDktWdIvotKB1GRwqdFqf1JDxIi4hdLP0ldcQ3FF1NGMm9
         +/7uxZwEgtPYCovDakapcgTqrnMQzFHr1QDL9SrQrcj/2MpwGWyL1PAKFtpdP551l+ce
         QDy6oQs+dcn96UWmheECM7So3pZG7H16crEQpkCq8iDvMEMqdNXbsf1iVtl/ue3iWn8i
         RqWmSxKcnhpvWPeN/mpjYZu+xPxp7B57d0RzKnI7WuVpP7HlnLPG+m5vl1H9OY+0ugOf
         ppaxx7+Buq7V7Q6W2pnmVI9t3ROgDdkQhChQu8oyDuqgeY4UArPb39lI1P392oDmLKmO
         FnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683334540; x=1685926540;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zRRGoezVjrIJz5N+FioPcqJbdxQwzqiRfGJICB0gSl0=;
        b=MafI+ifi8OouOUGsE6jIIoQgEuzV0XjxNCGiwTlQGc209CsW/t7xd4EjePUwnqftuk
         WCAWG83+HLKUAj63Jpox2beTfkoTiOfM3aLU8P9H5oet9n1YbshD2ZcAElARueilq2A/
         h5lE7Id7gie0mZScs+EBnXKj/lWpGiCzWArVI/yxy0J5JoLY9pgbCaZUTF7hYcNmCajD
         r8dyQENKZg+DdCNCISKY6WylfwibT3srfWE3I5WM4sKT8+Yy1/5lOYMVtd4exMbwVcjr
         +E9K0C5KsRroPHvzikkOvgO8YVSbo5YThQwA43iiF6i2/3lbRx2GVnuRK+S+/a1GdGkQ
         4MBg==
X-Gm-Message-State: AC+VfDwXrWHl8q0gAQ06QP5K79P06wQ8oF7sr7OWqI01ivoR0NPJKad3
        5KS2K5qrr+u35MfwM1RPbjpvKLIe+Zw=
X-Google-Smtp-Source: ACHHUZ5t1L56HilEp1RyedgEx7HTDhX3hmEqxAK4trb2yBcM7c0Gmtr2ABkxUAvvOv8dHcwHX/8vCAiPVuE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:d68:b0:643:6fa8:e7f4 with SMTP id
 n40-20020a056a000d6800b006436fa8e7f4mr981901pfv.0.1683334540635; Fri, 05 May
 2023 17:55:40 -0700 (PDT)
Date:   Fri, 5 May 2023 17:55:39 -0700
In-Reply-To: <diqz8re2ftzb.fsf@ackerleytng-ctop.c.googlers.com>
Mime-Version: 1.0
References: <ZEM5Zq8oo+xnApW9@google.com> <diqz8re2ftzb.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <ZFWli2/H5M8MZRiY@google.com>
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

On Fri, May 05, 2023, Ackerley Tng wrote:
>=20
> Hi Sean,
>=20
> Thanks for implementing this POC!
>=20
> I=E2=80=99ve started porting the selftests (both Chao=E2=80=99s and those=
 I added [1]).
>=20
> guest mem seems to cover the use cases that have been discussed and
> proposed so far, but I still need to figure out how gmem can work with
>=20
> + hugetlbfs
> + specification of/storing memory policy (for NUMA node bindings)
> + memory accounting - we may need to account for memory used separately,
>   so that guest mem shows up separately on /proc/meminfo and similar
>   places.
>=20
> One issue I=E2=80=99ve found so far is that the pointer to kvm (gmem->kvm=
) is
> not cleaned up, and hence it is possible to crash the host kernel in the
> following way
>=20
> 1. Create a KVM VM
> 2. Create a guest mem fd on that VM
> 3. Create a memslot with the guest mem fd (hence binding the fd to the
>    VM)
> 4. Close/destroy the KVM VM
> 5. Call fallocate(PUNCH_HOLE) on the guest mem fd, which uses gmem->kvm
>    when it tries to do invalidation.
>=20
> I then tried to clean up the gmem->kvm pointer during unbinding when the
> KVM VM is destroyed.
>=20
> That works, but then I realized there=E2=80=99s a simpler way to use the =
pointer
> after freeing:
>=20
> 1. Create a KVM VM
> 2. Create a guest mem fd on that VM
> 3. Close/destroy the KVM VM
> 4. Call fallocate(PUNCH_HOLE) on the guest mem fd, which uses gmem->kvm
>    when it tries to do invalidation.
>=20
> Perhaps binding should mean setting the gmem->kvm pointer in addition to
> gmem->bindings. This makes binding and unbinding symmetric and avoids
> the use-after-frees described above.

Hrm, that would work, though it's a bit convoluted, e.g. would require dete=
cting
when the last binding is being removed.  A similar (also ugly) solution wou=
ld be
to nullify gmem->kvm when KVM dies.

I don't love either approach idea because it means a file created in the co=
ntext
of a VM can outlive the VM itself, and then userspace ends up with a file d=
escriptor
that it can't do anything with except close().  I doubt that matters in pra=
ctice
though, e.g. when the VM dies, all memory can be freed so that the file end=
s up
being little more than a shell.  And if we go that route, there's no need t=
o grab
a reference to the file during bind, KVM can just grab a longterm reference=
 when
the file is initially created and then drop it when KVM dies (and nullifies=
 gmem->kvm).

Blech, another wart is that I believe gmem would need to do __module_get() =
during
file creation to prevent kvm.ko from being unloaded after the last VM dies.=
  Ah,
but that'd also be true if we went with a system-scoped KVM ioctl(), so I s=
uppose
it's not _that_ ugly.

Exchanging references (at binding or at creation) doesn't work, because tha=
t
creates a circular dependency, i.e. gmem and KVM would pin each other.=20

A "proper" refcounting approach, where the file pins KVM and not vice versa=
, gets
nasty because of how KVM's memslots work.  The least awful approach I can t=
hink of
would be to delete the associated memslot(s) when the file is released, pos=
sibly
via deferred work to avoid deadlock issues.  Not the prettiest thing ever a=
nd in
some ways that'd yield an even worse ABI.

Side topic, there's a second bug (and probably more lurking): kvm_swap_acti=
ve_memslots()'s
call to synchronize_srcu_expedited() is done _before_ the call to kvm_gmem_=
unbind(),
i.e. doesn't wait for readers in kvm_gmem_invalidate_begin() to go away.  T=
he easy
solution for that one is to add another synchronize_srcu_expedited() after =
unbinding.

> This also means that creating a guest mem fd is no longer dependent on
> the VM. Perhaps we can make creating a gmem fd a system ioctl (like
> KVM_GET_API_VERSION and KVM_CREATE_VM) instead of a vm ioctl?

My preference is to make it a VM-scoped ioctl(), if it ends up being a KVM =
ioctl()
and not a common syscall.  If the file isn't tightly coupled to a single VM=
, then
punching a hole is further complicated by needing to deal with invalidating=
 multiple
regions that are bound to different @kvm instances.  It's not super complex=
, but
AFAICT having the ioctl() be system-scoped doesn't add value, e.g. I don't =
think
having one VM own the memory will complicate even if/when we get to the poi=
nt where
VMs can share "private" memory, and the gmem code would still need to deal =
with
grabbing a module reference.
