Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D92F6E7083
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 02:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbjDSArU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 20:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjDSArS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 20:47:18 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8585595
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 17:47:17 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1a69a078eefso11590725ad.2
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 17:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681865237; x=1684457237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BRhcoVi/so3GxRYGQIv2yienH23nZKhTwyow1BK26mo=;
        b=0vXk1nY8ogZSypVY8teXSisTQuRy9oa55TJG/XiVrwj+u/Qo0vg3WbKd21sInPPM2p
         2U8Ei744fYmWLekeuuqaQsfez5jYqrAmEtKYgF+hkdk0BNLxQZ2mFVoTeI/V/6dulELE
         NRtiyHOwatu0hPGrB2/VfmAVe7Zk2QYvzKeoXk0yT3aq44f5Gny2xFGOtnRivD1NmiEz
         MlJoyTup23WZKtf5Vz6YKH7BkJVmFDJM2Vc3sXBfYdlN6rev3D4m1x5QfVjDolxiMTTW
         aqVFmUhXajY9bcrElrubMdPq2YIq1Vsd8ZMsXi7TdlCfVdE8/GHcxz2w7x2TBJgc3dFQ
         SXZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681865237; x=1684457237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BRhcoVi/so3GxRYGQIv2yienH23nZKhTwyow1BK26mo=;
        b=HEUTRxvxMavEn0FIwLaH6U3a1rvSllHPQeaIVnRwOb8B8WGJHUwbLT38gxzN4UBDPm
         SjtySsMbOCxd6I5JHJArYmVzBIMy0AongXqvqXRUARN0yApFy3eeYjbeQSKb0BQvqM1W
         30HyThCZGorBNEXRV435aCEfrbnpgcV1NqJNYCJGJ8NabPP90Dto9JJC8hbTeBPJmSNh
         gRw0eQDCWYUyrhTGRhrOcP4d0+KOF9n35E3g4mBhHJ5uytc52rGanIzXzxh8zUCRRWzM
         8uD79Q2gNSrH97/GBoUGHQ/oIGhaQUjTFqfTzecEZFtcwZp0OhhHSvGLzGHONs48SmS5
         SDgg==
X-Gm-Message-State: AAQBX9d/ePG7YNrlpz3a7cbUQDcOg33i2yQaLw4EKfGxyb1tXazvx5me
        gfSqO8gqrC1gKqv9nEET6wEN9NbcUx8=
X-Google-Smtp-Source: AKy350at1UBX8RD7TMmqZ3VQjXQyrzp8DYlR0Mth2xOZ9GL7wA8Om61yEwOahqy7ThjKW9iBOw41knqnMxY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1251:b0:1a5:255d:efcc with SMTP id
 u17-20020a170903125100b001a5255defccmr1485258plh.13.1681865236871; Tue, 18
 Apr 2023 17:47:16 -0700 (PDT)
Date:   Tue, 18 Apr 2023 17:47:15 -0700
In-Reply-To: <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
Mime-Version: 1.0
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <ZD1oevE8iHsi66T2@google.com> <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <ZD12htq6dWg0tg2e@google.com> <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com> <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
Message-ID: <ZD86E23gyzF6Q7AF@google.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
From:   Sean Christopherson <seanjc@google.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        tabba@google.com, Michael Roth <michael.roth@amd.com>,
        wei.w.wang@intel.com, Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 18, 2023, David Hildenbrand wrote:
> On 17.04.23 21:16, Sean Christopherson wrote:
> > Hidden/Concealed/etc - Too close to secretmem, suffers the "hidden from whom" problem,
> > and depending on the use case, the memory may not actually be concealed from the
> > user that controls the VMM.
> > 
> > Restricted - "rmem" collides with "reserved memory" in code.
> > 
> > Guarded - Conflicts with s390's "guarded storage", has the "from whom" problem.
> > 
> > Inaccessible - Many of the same problems as "hidden".
> > 
> > Unmappable - Doesn't cover things like read/write, and is wrong in the sense that
> > the memory is still mappable, just not via mmap().
> > 
> > Secured - I'm not getting anywhere near this one :-)
> 
> The think about "secretmem" that I kind-of like (a little) is that it
> explains what it's used for: storing secrets. We don't call it "unmapped"
> memory because we unmap it from the directmap or "unpinnable" memory or
> "inaccessible" memory ... or even "restricted" because it has restrictions
> ... how the secrets are protected is kind of an implementation detail.
> 
> So instead of describing *why*/*how* restrictedmem is the weird kid
> (restricted/guarded/hidden/restricted/inaccessible/ ...), maybe rather
> describe what it's used for?
> 
> I know, I know, "there are other use cases where it will be used outside of
> VM context". I really don't care.

Heh, we originally proposed F_SEAL_GUEST, but that was also sub-optimal[1] ;-)

> "memfd_vm" / "vm_mem" would be sooo (feel free to add some more o's here)
> much easier to get. It's a special fd to be used to back VM memory. Depending
> on the VM type (encrypted/protected/whatever), restrictions might apply (not
> able to mmap, not able to read/write ...). For example, there really is no
> need to disallow mmap/read/write when using that memory to back a simple VM
> where all we want to do is avoid user-space page tables.

In seriousness, I do agree with Jason's very explicit objection[2] against naming
a non-KVM uAPI "guest", or any variation thereof.

An alternative that we haven't considered since the very early days is making the
uAPI a KVM ioctl() instead of a memfd() flag or dedicated syscall.  Looking at the
code for "pure shim" implementation[3], that's actually not that crazy of an idea.

I don't know that I love the idea of burying this in KVM, but there are benefits
to coupling restrictedmem to KVM (aside from getting out from behind this bikeshed
that I created).

The big benefit is that the layer of indirection goes away.  That simplifies things
like enhancing restrictedmem to allow host userspace access for debug purposes,
batching TLB flushes if a PUNCH_HOLE spans multiple memslots, enforcing exclusive
access, likely the whole "share with a device" story if/when we get there, etc.

The obvious downsides are that (a) maintenance falls under the KVM umbrella, but
that's likely to be true in practice regardless of where the code lands, and
(b) if another use case comes along, e.g. the Gunyah hypervisor[4][5], we risk
someone reinventing a similar solution.

If we can get Gunyah on board and they don't need substantial changes to the
restrictedmem implementation, then I'm all for continuing on the path we're on.
But if Gunyah wants to do their own thing, and the lightweight shim approach is
viable, then it's awfully tempting to put this all behind a KVM ioctl().

[1] https://lore.kernel.org/all/df11d753-6242-8f7c-cb04-c095f68b41fa@redhat.com
[2] https://lore.kernel.org/all/20211123171723.GD5112@ziepe.ca
[3] https://lore.kernel.org/all/ZDiCG%2F7OgDI0SwMR@google.com
[4] https://lore.kernel.org/all/Y%2FkI66qQFJJ6bkTq@google.com
[5] https://lore.kernel.org/all/20230304010632.2127470-13-quic_eberman@quicinc.com
