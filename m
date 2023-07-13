Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD2F752D2D
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 00:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbjGMWqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 18:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjGMWqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 18:46:14 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C038271C
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 15:46:13 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b8a7734734so5887405ad.2
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 15:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689288373; x=1691880373;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jlviYcHwsz3zgb3Z/9cmi+oU98mhelhtL3RDJqVwSjc=;
        b=xxlwEtmNqK7eSUJEB804Hz+q428CMYwEVKko8eWqMrpf0Ahj2+mrxahB7oMV/O4F5B
         1XkCBi7KaovT4IE3C8X4aIQGrmiTvatUY/8Xf6/qJc4BcV+GWzNm5A2vdtPdFC8YE3rx
         uoLxvosGJYNIykJioP74J4N2k9ScDen4Q8n+BhhU2sPI4CDXdMU18dYIhyACkr14SsNW
         AWL/CQ1xt1A9wb/F3APVRGFN5zyyX+fD3h69y84wsDocJjRjzwR7OdOrYeeKDzvbavxR
         Zkrgboh6E8Xe+g9wgMutsgOqEsrJyoNdXJjUHU/V46/BOTbRkoMJ4ikKVK6ve7skAqvB
         SGhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689288373; x=1691880373;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jlviYcHwsz3zgb3Z/9cmi+oU98mhelhtL3RDJqVwSjc=;
        b=VrNxJbcmEi9hokyBj9uQ+V3oemEMGkkKJ8syqrAW87MwYs0cdhy2O0FzRC8vUSBcSu
         VQVO3Lm2ihv2jwzX3P0crMAkN1gvRLnpWHxL692vBZRoMQfp4paa4W9/myAakNixK3j9
         TRX9g37IlxzuaYdfBtsDRSLyJ0LA7Dbk1QKhpR8PEZTNXevk4xKlYoIvYRB/heE/1SMj
         uB2t1DBlCrVNki7A0QvBc+uWMtZosCkqfD4Om0/G4pceSEYSac5VxaU8fzLtkkt7tv5R
         NDTYmscfAYWr203G/lxYb7Yd2S1cE28SInTsO0D8B/MPAfPyMO4sDEc4yqFTHvxztFVj
         P1nA==
X-Gm-Message-State: ABy/qLZS6yWz54XRoa4BE3DgxU0Bk4u/4t1ldWbeiQV+W1Y5iFsGLNLy
        r0NbkGBUQzP3/qsj/NeVjSyKHe8JrJ83ASfZsQ==
X-Google-Smtp-Source: APBJJlERPG/+eayyUgcaUIRW0xWDavYekBKC7TcOLS/MzLmlBQovbnx1yFNwnYhI8Hf1GI05Y3XFjgiX1sbGXMahCw==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a17:902:e9c6:b0:1a6:4ce8:3ed5 with
 SMTP id 6-20020a170902e9c600b001a64ce83ed5mr8890plk.4.1689288373014; Thu, 13
 Jul 2023 15:46:13 -0700 (PDT)
Date:   Thu, 13 Jul 2023 22:46:11 +0000
In-Reply-To: <ZFWli2/H5M8MZRiY@google.com> (message from Sean Christopherson
 on Fri, 5 May 2023 17:55:39 -0700)
Mime-Version: 1.0
Message-ID: <diqzr0pb2zws.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
From:   Ackerley Tng <ackerleytng@google.com>
To:     Sean Christopherson <seanjc@google.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Fri, May 05, 2023, Ackerley Tng wrote:
>>
>> Hi Sean,
>>
>> Thanks for implementing this POC!
>>
>> ... snip ...
>>
>
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
>
> ... snip ...
>
> My preference is to make it a VM-scoped ioctl(), if it ends up being a KV=
M ioctl()
> and not a common syscall.  If the file isn't tightly coupled to a single =
VM, then
> punching a hole is further complicated by needing to deal with invalidati=
ng multiple
> regions that are bound to different @kvm instances.  It's not super compl=
ex, but
> AFAICT having the ioctl() be system-scoped doesn't add value, e.g. I don'=
t think
> having one VM own the memory will complicate even if/when we get to the p=
oint where
> VMs can share "private" memory, and the gmem code would still need to dea=
l with
> grabbing a module reference.

I=E2=80=99d like to follow up on this discussion about a guest_mem file
outliving the VM and whether to have a VM-scoped ioctl or a KVM ioctl.

Here's a POC of delayed binding of a guest_mem file to a memslot, where
the guest_mem file outlives the VM [1].

I also hope to raise some points before we do the first integration of
guest_mem patches!


A use case for guest_mem inodes outliving the VM is when the host VMM
needs to be upgraded. The guest_mem inode is passed between two VMs on
the same host machine and all memory associated with the inode needs to
be retained.

To support the above use case, binding of memslots is delayed until
first use, so that the following inode passing flow can be used:

1. Source (old version of host VMM) process passes guest_mem inodes to
   destination (new version of host VMM) process via unix sockets.
2. Destination process initializes memslots identical to source process.
3. Destination process invokes ioctl to migrate guest_mem inode over to
   destination process by unbinding all memslots from the source VM and
   binding them to the destination VM. (The kvm pointer is updated in
   this process)

Without delayed binding, step 2 will fail since initialization of
memslots would check and find that the kvm pointer in the guest_mem
inode points to the kvm in the source process.


These two patches contain the meat of the changes required to support
delayed binding:

https://github.com/googleprodkernel/linux-cc/commit/93b31a006ef2e4dbe1ef0ec=
5d2534ca30f3bf60c
https://github.com/googleprodkernel/linux-cc/commit/dd5ac5e53f14a1ef9915c9c=
1e4cc1006a40b49df

Some things to highlight for the approach set out in these two patches:

1. Previously, closing the guest_mem file in userspace=C2=A0is taken to mea=
n
   that all associated memory is to be removed and cleared. With these
   two patches, each memslot also holds a reference to the file (and
   therefore inode) and so even if the host VMM closes the fd, the VM
   will be able to continue to function.

   This is desirable to userspace since closing the file should not be
   interpreted as a command to clear memory. This is aligned with the
   way tmpfs=C2=A0files are used with KVM before guest_mem: when the file i=
s
   closed in userspace, the memory contents are still mapped and can
   still be used by the VM. fallocate(PUNCH_HOLE) is how userspace
   should command memory to be removed, just like munmap() would be used
   to remove memory from use by KVM.

2. Creating a guest mem file no longer depends on a specific VM and
   hence the guest_mem creation ioctl can be a system ioctl instead of a
   VM specific ioctl. This will also address Chao's concern at [3].


I also separated cleaning up files vs inodes in
https://github.com/googleprodkernel/linux-cc/commit/0f5aa18910c515141e57e05=
c4cc791022047a242,
which I believe is more aligned with how files and inodes are cleaned up
in FSes. This alignment makes it easier to extend gmem=C2=A0to hugetlb, for
one. While working on this, I was also wondering if we should perhaps be
storing the inode pointer in slot->gmem instead of the file pointer? The
memory is associated with an inode->mapping rather than the file. Are we
binding to a userspace handle on the inode (store file pointer), or are
we really referencing the inode (store inode pointer)?

The branch [1] doesn't handle the bug Sean previously mentioned at [2]:
Need to take a reference on the KVM module, so that even if guest_mem
files are not bound to any VM, the KVM module cannot be unloaded. If the
KVM module can be unloaded while guest_mem files are open, then
userspace may be able to crash the kernel by invoking guest_mem
functions that had been unloaded together with KVM.


[1] https://github.com/googleprodkernel/linux-cc/tree/gmem-delayed-binding
[2] https://lore.kernel.org/lkml/ZFWli2%2FH5M8MZRiY@google.com/
[3] https://lore.kernel.org/lkml/20230509124428.GA217130@chaop.bj.intel.com=
/
