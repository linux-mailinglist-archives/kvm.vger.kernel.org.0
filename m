Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768B9546EE8
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 23:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347518AbiFJVB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 17:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244872AbiFJVBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 17:01:55 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5680201A5
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 14:01:53 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j7so471164pjn.4
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 14:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9j+lUZ+Mcfs1Jcoa4etI2TPzedTT1LtFJEr4fDqaygA=;
        b=NKflmcL3DRRoEVI9aA2myzxnaV92k/hIea6L4aJUQzCGDuHMfvHPgs1/rD0/Vm7kOy
         ZTQxPAjfe1ez1G30H2jihUbHdbUmFFXTAmnEYfpv2Nrs8pSzHaktoorFzSEvDx13LGG6
         UkPqWHPJiteD974QKgN0Tq5hW/vfR9VBK4nDGXkd4ymYHM1wEZ0IG2QZSq6d720hjieK
         TBepncYM2w+AqxgoR/le9W1+ez7DFwX0gcDPeo3JWb0yCnkE1FiidcdGAskXT7g3L5ia
         jvDiTdAx3e9ZCPlt3uX1o7eE7x+2h6VjNxbWH5BbvnNP3NNWqZO+PUjGttxVaxnRNLTU
         +9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9j+lUZ+Mcfs1Jcoa4etI2TPzedTT1LtFJEr4fDqaygA=;
        b=NLjfDgFlzxvvYg67y+qZAjbvT+fTnRubDwgoFT8+iNN0CJyG9QvPfxrwDuuhgmHm3A
         yA/b3gzfg1XLXaS5qIO54/lqMNKUO1SbXObqyJFSztri1ZMyvHFlC7g2OjyZdSc/qUqb
         WdlonuoXzJjteJcMMu+rt4pfEITTo7cw2t44uFwDwWqw2ObFiSJn4HV0EIGfGKC0gkRh
         GEmURK0ALgW/YfeUvbsQlktUWgVjMF6qBJlhv/23PJ6UVwfu8DHld61iEeEc7m7RTwcX
         YLlZFRIAoIZgM5waVDLGgqfVh2o5/Cs8g3bEvB3S53zZNTh3dAjGav8Fcz65g5GplUn9
         LK6g==
X-Gm-Message-State: AOAM5306twGyHx8O3y4I1E6QzCVsPswVuGVcL5jhFEF+vo1LI2w53Zrv
        7dBbzme88qJ1IPFxUvUW7MfsZO7TnXEwYUefq9Xe5A==
X-Google-Smtp-Source: ABdhPJwvRGSfjW+BQVoBdbJMFI3SGm9Mmrx5BjmO46SgVdtXKMaXbKuqMg2V/NxgtH3LSYo3AH35O1L6keWUVQOdZgw=
X-Received: by 2002:a17:90b:3806:b0:1e2:adc5:d192 with SMTP id
 mq6-20020a17090b380600b001e2adc5d192mr1581921pjb.223.1654894912870; Fri, 10
 Jun 2022 14:01:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220524205646.1798325-1-vannapurve@google.com> <20220610010510.vlxax4g3sgvsmoly@amd.com>
In-Reply-To: <20220610010510.vlxax4g3sgvsmoly@amd.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Fri, 10 Jun 2022 14:01:41 -0700
Message-ID: <CAGtprH92PVtCDGrtwcvfrsKokFbYrqXqtH6D_aUrYXvHYyWpyQ@mail.gmail.com>
Subject: Re: [RFC V1 PATCH 0/3] selftests: KVM: sev: selftests for fd-based
 approach of supporting private memory
To:     Michael Roth <michael.roth@amd.com>
Cc:     x86 <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        dave.hansen@linux.intel.com, "H . Peter Anvin" <hpa@zytor.com>,
        shuah <shuah@kernel.org>, yang.zhong@intel.com,
        drjones@redhat.com, Ricardo Koller <ricarkol@google.com>,
        Aaron Lewis <aaronlewis@google.com>, wei.w.wang@intel.com,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Andi Kleen <ak@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Marc Orr <marcorr@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Peter Gonda <pgonda@google.com>,
        "Nikunj A. Dadhania" <nikunj@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Austin Diviness <diviness@google.com>, maz@kernel.org,
        dmatlack@google.com, axelrasmussen@google.com,
        maciej.szmigiero@oracle.com, Mingwei Zhang <mizhang@google.com>,
        bgardon@google.com
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

....
>
> I ended up adding a KVM_CAP_UNMAPPED_PRIVATE_MEM to distinguish between the
> 2 modes. With UPM-mode enabled it basically means KVM can/should enforce that
> all private guest pages are backed by private memslots, and enable a couple
> platform-specific hooks to handle MAP_GPA_RANGE, and queries from MMU on
> whether or not an NPT fault is for a private page or not. SEV uses these hooks
> to manage its encryption bitmap, and uses that bitmap as the authority on
> whether or not a page is encrypted. SNP uses GHCB page-state-change requests
> so MAP_GPA_RANGE is a no-op there, but uses the MMU hook to indicate whether a
> fault is private based on the page fault flags.
>
> When UPM-mode isn't enabled, MAP_GPA_RANGE just gets passed on to userspace
> as before, and platform-specific hooks above are no-ops. That's the mode
> your SEV self-tests ran in initially. I added a test that runs the
> PrivateMemoryPrivateAccess in UPM-mode, where the guest's OS memory is also
> backed by private memslot and the platform hooks are enabled, and things seem
> to still work okay there. I only added a UPM-mode test for the
> PrivateMemoryPrivateAccess one though so far. I suppose we'd want to make
> sure it works exactly as it did with UPM-mode disabled, but I don't see why
> it wouldn't.

Thanks Michael for the update. Yeah, using the bitmap to track
private/shared-ness of gfn ranges should be the better way to go as
compared to the limited approach I used to just track a single
contiguous pfn range.
I spent some time in getting the SEV/SEV-ES priv memfd selftests to
execute from private fd as well and ended up doing similar changes as
part of the github tree:
https://github.com/vishals4gh/linux/commits/sev_upm_selftests_rfc_v2.

>
> But probably worth having some discussion on how exactly we should define this
> mode, and whether that meshes with what TDX folks are planning.
>
> I've pushed my UPM-mode selftest additions here:
>   https://github.com/mdroth/linux/commits/sev_upm_selftests_rfc_v1_upmmode
>
> And the UPM SEV/SEV-SNP tree I'm running them against (DISCLAIMER: EXPERIMENTAL):
>   https://github.com/mdroth/linux/commits/pfdv6-on-snpv6-upm1
>

Thanks for the references here. This helps get a clear picture around
the status of priv memfd integration with Sev-SNP VMs and this work
will be the base of future SEV specific priv memfd selftest patches as
things get more stable.

I see usage of pwrite to populate initial private memory contents.
Does it make sense to have SEV_VM_LAUNCH_UPDATE_DATA handle the
private fd population as well?
I tried to prototype it via:
https://github.com/vishals4gh/linux/commit/c85ee15c8bf9d5d43be9a34898176e8230a3b680#
as I got this suggestion from Erdem Aktas(erdemaktas@google) while
discussing about executing guest code from private fd.
Apart from the aspects I might not be aware of, this can have
performance overhead depending on the initial Guest UEFI boot memory
requirements. But this can allow the userspace VMM to keep most of the
guest vm boot memory setup the same and
avoid changing the host kernel to allow private memfd writes from userspace.

Regards,
Vishal
