Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A387F43B60B
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 17:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237100AbhJZPvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 11:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237094AbhJZPvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 11:51:25 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F3EC061243
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 08:49:00 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id y80so18080899ybe.12
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 08:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9bVpuD1Y0J9AqmF+3g16iWc8OCZsFp8I5PNhkQ+ZVF8=;
        b=ETLLMFRoQJtWWgBJT0RT3eQfsBfYysOXlgNe2DEvEZ1QazSwauaMIoM44pYme32Cmf
         5wDxSE86ikalKtUTF8YaP1Vkcs/bOKBzt0fci7rR3EbizNznCCEx/0w0v70ni5jpJVBn
         Sh62U8y41huL0JAATtLmBuahL1Xvkh1iSGtriC0Ko45kmdHgePn3PtuEZZHBjRrSzBBJ
         dGjnlJj7MYVxr1qqvL87tedwzYyPKh3xKjvudUVGo7CSSjA3VfLQ9uqL4RjTuNMod5w7
         zMBED7gaNA16iIjHd5Hnj6vSRP7OvuF+zHyueWTRLv5g9HUUT/3huLUFxWp7eKQl28lK
         6V9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9bVpuD1Y0J9AqmF+3g16iWc8OCZsFp8I5PNhkQ+ZVF8=;
        b=nt0nCwoX+ElE+nuw/iTMqd5Kcj6PdtwtRys+fnm5z8b0Wr4vkS0ri5HJvCQEsAexVn
         4iQQzcnKUNc0svm6lABWx/VIUvDtxzucAcUCm43FxY++5Bb+NTVRcf8kL3NnFEtpPH1j
         HhTHtBKTsxLajzr2btoFYnF1UjqKDBlFliDYHedcUK3ZkXshQEWttiqS7iCv5A5GtHta
         k5ADf997DMn5FXgQMEvp1AlzLubR3nAwWQo5kwz7st6cCa6p/uro4MHZTc0z9wVWTBfr
         47C1/rba7PKTvChnRI0N5oP8WknxSwnaKAzGsrQKE7UxkO16pac3nA3OZRwUy9QOXSlk
         WoRg==
X-Gm-Message-State: AOAM533cLwuxHNT3FcBMjdp85S44GAHnMmX0nZNmdnC5Vfg2iWpTmNk4
        cFM3Eygo+SgK4s2yEIUbyZrYU4Ua6DKoSnLR6fpggg==
X-Google-Smtp-Source: ABdhPJxkAfBCqV5ai6x0PYyirty5FemxittcYFhZ6c9nyXWtlQOHD/jYuUO4dkRqgU2YSYIgmFfT9YLe/rbjhyI0rAo=
X-Received: by 2002:a25:2514:: with SMTP id l20mr26110968ybl.30.1635263339751;
 Tue, 26 Oct 2021 08:48:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211005234459.430873-1-michael.roth@amd.com> <20211005234459.430873-3-michael.roth@amd.com>
 <CAL715W+-H7ZSQZeZmAbbJNGKaZCNqf4VdLismivxux=gerFuDw@mail.gmail.com> <20211021033723.tfnhazbnlz4z5czl@amd.com>
In-Reply-To: <20211021033723.tfnhazbnlz4z5czl@amd.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 26 Oct 2021 08:48:48 -0700
Message-ID: <CAL715W+kJpnx5Jax2-vtFRDNrQFsc6+YT+q5ZkWbBM7gFVKjkg@mail.gmail.com>
Subject: Re: [RFC 02/16] KVM: selftests: add hooks for managing encrypted
 guest memory
To:     Michael Roth <michael.roth@amd.com>
Cc:     linux-kselftest@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Nathan Tempelman <natet@google.com>,
        Marc Orr <marcorr@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Shuah Khan <shuah@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Ricardo Koller <ricarkol@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021 at 8:46 PM Michael Roth <michael.roth@amd.com> wrote:
>
> On Mon, Oct 18, 2021 at 08:00:00AM -0700, Mingwei Zhang wrote:
> > > +void vm_set_memory_encryption(struct kvm_vm *vm, bool enc_by_default, bool has_enc_bit,
> > > +                             uint8_t enc_bit)
> > > +{
> > > +       vm->memcrypt.enabled = true;
> > > +       vm->memcrypt.enc_by_default = enc_by_default;
> > > +       vm->memcrypt.has_enc_bit = has_enc_bit;
> > > +       vm->memcrypt.enc_bit = enc_bit;
> > > +}
> > > +
> > > +struct sparsebit *
> > > +vm_get_encrypted_phy_pages(struct kvm_vm *vm, int slot, vm_paddr_t *gpa_start,
> > > +                          uint64_t *size)
> > > +{
> > > +       struct userspace_mem_region *region;
> > > +       struct sparsebit *encrypted_phy_pages;
> > > +
> > > +       if (!vm->memcrypt.enabled)
> > > +               return NULL;
> > > +
> > > +       region = memslot2region(vm, slot);
> > > +       if (!region)
> > > +               return NULL;
> > > +
> > > +       encrypted_phy_pages = sparsebit_alloc();
> > > +       sparsebit_copy(encrypted_phy_pages, region->encrypted_phy_pages);
> >
> > Do we have to make a copy for the sparsebit? Why not just return the
> > pointer? By looking at your subsequent patches, I find that this data
> > structure seems to be just read-only?
>
> Yes, it's only intended to be used for read access. But I'll if I can
> enforce that without the need to use a copy.
>

Understood. Thanks for the clarification. Yeah, I think both making a
copy and returning a const pointer should work. I will leave that to
you then.

Thanks.
-Mingwei
