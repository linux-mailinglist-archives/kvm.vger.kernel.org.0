Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF49F64AA81
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 23:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbiLLWnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 17:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiLLWmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 17:42:55 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDD9FAFB
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 14:42:54 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3c090251d59so168277947b3.4
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 14:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xlakFXRE5WR+eI81tSHGT8mBX3C2kTQwJgOLsFBL4OY=;
        b=ndwFSRoXLSuq0mtL5gu3GohHZTtCmsXoG5LnB+4W5ntMQyw7hg7yWmVnEVKI/CMMjq
         KrRV2sbCGqD+H+xzIvKYj1uByps5sG637+06KzojhBb8JdEZSaKaduwj2AG/udwtUpyt
         ek+ZoO9A0+tsd50WkNyDpm1NuAuM3Y5dUIJvdzOEDIi6I+KRA7WOdHGwAFMZnvKcKJm8
         sMmoQVLveW58rH19lDfr14dd1014L5iT8SfRCYVc1nc0+/mzoEy8/Q6/90V5+D11cSnV
         VR0IEIuzVXTRNeTb22H3kEKuvjJHEQSBOYF1lXueeHZG7VZeReMvOUQqeeOQrxzxcfeM
         2TJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xlakFXRE5WR+eI81tSHGT8mBX3C2kTQwJgOLsFBL4OY=;
        b=cz0dtNy4JH56s+TcnMqxjHKjMjabAicbGI7Ud7Leefte0gJunUTV2GhXitBuvmcRZF
         fosy146Yr8gQ9OSs3GfRXaUkDqsG3HrCqNdfW/ufHpAJakckkBu6SAas2mGq2ardWtGi
         JhnFp1wFQ4M4Oqwq6idy8257BY/5stfS6j0TC8mOWPxsaD1vRIYqJLwPyC7VMhwwdxdr
         59gGythutyb08BaH73QL9mP1NtQswdre2pRReau/GkBrTOtEksQDNmw6MzOeOfAWLKpD
         NvYca4LmS1/sm83/4QJgQHJvvnWo4zikWE8sCiE9n8BoniUi9EOSESsDLrcEGtEt0tHE
         N/8Q==
X-Gm-Message-State: ANoB5pnGCl8ZTpNlcmGV+P11xNKpw8+5YSHwRCw7proJlKwcFYptxUG3
        1PlnKobGoVmdzPdEzaetRo9UNkS5xlop3l5l9KD2+A==
X-Google-Smtp-Source: AA0mqf44l006Q6QVS5WsjpiBIi3T4SW6bvJpPAfR1juAzLaGPOaG7kqLyOnkKrJsuk2Vx7E4bBJKqTB5CVZjDntvdQc=
X-Received: by 2002:a0d:df0a:0:b0:35f:9c14:144a with SMTP id
 i10-20020a0ddf0a000000b0035f9c14144amr26604984ywe.209.1670884973326; Mon, 12
 Dec 2022 14:42:53 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-34-dmatlack@google.com>
 <CANgfPd_069QPNby+mR4GuOWDNJtFk_=9EOffb0=2_V5TH-ZCDA@mail.gmail.com>
In-Reply-To: <CANgfPd_069QPNby+mR4GuOWDNJtFk_=9EOffb0=2_V5TH-ZCDA@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 12 Dec 2022 14:42:27 -0800
Message-ID: <CALzav=fMX0g_n9pVFsLShZjEkPLquo2u_QpPMPzUMAGYtjZFOw@mail.gmail.com>
Subject: Re: [RFC PATCH 33/37] KVM: Move kvm_arch_flush_remote_tlbs_memslot()
 to common code
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
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

On Mon, Dec 12, 2022 at 2:03 PM Ben Gardon <bgardon@google.com> wrote:
>
> On Thu, Dec 8, 2022 at 11:40 AM David Matlack <dmatlack@google.com> wrote:
> >
> > Move kvm_arch_flush_remote_tlbs_memslot() to common code and drop
> > "arch_" from the name. kvm_arch_flush_remote_tlbs_memslot() is just a
> > range-based TLB invalidation where the range is defined by the memslot.
> > Now that kvm_flush_remote_tlbs_range() can be called from common code we
> > can just use that and drop a bunch of duplicate code from the arch
> > directories.
> >
> > Note this adds a lockdep assertion for slot_lock being held when calling
> > kvm_flush_remote_tlbs_memslot(), which was previously only asserted on
> > x86.
>
> Besides the one lockdep assertion, is there any benefit to having this
> wrapper function? Open-coding "kvm_flush_remote_tlbs_range(kvm,
> memslot->base_gfn, memslot->npages);" is only a slightly longer line
> and, IMO, just as readable. I'm happy to see this cleanup, but it
> might be just as easy to drop the function.

The wrapper makes lines shorter, adds a lockdep assertion, and is just
as readable. What's the reason to drop it?
