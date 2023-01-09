Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715646632BF
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 22:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbjAIVWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 16:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237975AbjAIVVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 16:21:52 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B478B15F1F
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 13:20:21 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id v25so15051618lfe.12
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 13:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FNC2XSpBLRS3auEEG3PVbMVZdtlR6ps1ItMrpT1MBag=;
        b=D07B9HycUls6seaOKG+Dy6GfEllCheSXDZmORRHsJbzO4NPQGyfHgvWtSrc5KNgipL
         Ms0+9utOu08Ne/59DrU8PVnTQ55Jg8KHVUmlD0KTBj7spLLI+iOaekkNHWaezk/8sYNt
         Jqj7XfNUYmYuJhf7SAo3/eeCy/TWuAgJOi6QVmwZcc7eE/nJrwQa0fpVMczeMRfdi7Tu
         IPzg1vVyvJcnNFcH7XBsFn5Ndme7R9wMLZvjhHlxr7TpqVJxVcJBIxZ+WGWJgWnAz3oV
         WTVrCTqlxsuJcSRRL65s0SWN9QxjEA9OsY2ywoApCWvD/q8xxoR7kcejKu5cowq+tMFO
         kl2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FNC2XSpBLRS3auEEG3PVbMVZdtlR6ps1ItMrpT1MBag=;
        b=1Rha6GdJ8qHDlE7Dh9kuXyxdsHti5dxAY3OwNmh9vF6Jju4YCDurp1URE4hJNX6F7w
         6Gr/aG+sHjk2YenqDnuWAURS7y8sSMi3I/JULqxIHWp/E2QmUEiCGsOMC4bTxQ16A/TB
         lXIqWi95a8m6LuJFSNBl2p7zyU0flSNXlBhd0quJAe0PolqHn7eni5qGyfqITkRei+00
         YduGCZOE/odRmJ8mWBC2+42m84nFprOtlbKfyME/QGcQwiH3oo63c1ljO1iIsMLtXofw
         0n51N9OmVe+ex7wuRLKZg/j13v0U544qpc7XKb8HRSz4rYrcOFcn0lAI/AkcyJan1f3h
         Wqdg==
X-Gm-Message-State: AFqh2kqYQk3kTprekXs1j/cY49pD6JCPVE2jUZcEMXzgM/FjbMwundwc
        dd52qG/bUkoR8MOhWb6eo+al2jyUOt8Gfn1FzVD/+Q==
X-Google-Smtp-Source: AMrXdXtQTExd65/VakEAByPpVZZhe+N/UBYY4KOIABLMFWNhF3MDFAdQLeBqljHDyHGWhFLioRvQ1LsfQ3V1CDTxsWc=
X-Received: by 2002:ac2:58f4:0:b0:4cb:d9d:df5f with SMTP id
 v20-20020ac258f4000000b004cb0d9ddf5fmr4817329lfo.313.1673299219794; Mon, 09
 Jan 2023 13:20:19 -0800 (PST)
MIME-Version: 1.0
References: <20221018205845.770121-1-pgonda@google.com> <20221018205845.770121-6-pgonda@google.com>
 <CAGtprH8wfYk05+yfzngHJ99ESwjhDf-sRaLO3AT2x1VyFQ6pvw@mail.gmail.com>
In-Reply-To: <CAGtprH8wfYk05+yfzngHJ99ESwjhDf-sRaLO3AT2x1VyFQ6pvw@mail.gmail.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 9 Jan 2023 14:20:07 -0700
Message-ID: <CAMkAt6pLFO0ZAnQ23ZUX3MdtFpcb69kwW79JDn=_5b7a48rtHg@mail.gmail.com>
Subject: Re: [PATCH V5 5/7] KVM: selftests: add library for
 creating/interacting with SEV guests
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, seanjc@google.com, michael.roth@amd.com,
        thomas.lendacky@amd.com, joro@8bytes.org, mizhang@google.com,
        pbonzini@redhat.com, andrew.jones@linux.dev
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

On Thu, Dec 22, 2022 at 3:19 PM Vishal Annapurve <vannapurve@google.com> wrote:
>
> On Tue, Oct 18, 2022 at 1:59 PM Peter Gonda <pgonda@google.com> wrote:
> >
> > ...
> > +
> > +static void configure_sev_pte_masks(struct kvm_vm *vm)
> > +{
> > +       uint32_t eax, ebx, ecx, edx, enc_bit;
> > +
> > +       cpuid(CPUID_MEM_ENC_LEAF, &eax, &ebx, &ecx, &edx);
> > +       enc_bit = ebx & CPUID_EBX_CBIT_MASK;
> > +
> > +       vm->arch.c_bit = 1 << enc_bit;
>
> This should be 1ULL << enc_bit as the overall result overflows 32 bits.
>
> > +       vm->arch.pte_me_mask = vm->arch.c_bit | vm->arch.s_bit;
>
> Maybe the role of pte_me_mask needs to be discussed in more detail. If
> pte_me_mask is to be used only for maintaining/manipulating encryption
> of page table memory then maybe it should be just set as
> vm->arch.c_bit or better yet replaced with vm->arch.c_bit.
>
> gpa_protected_mask also needs to be set here so that vm_untag_gpa
> works as expected.

Thanks for speaking with me offline about TDX. I have removed
pte_me_mask entirely and set gpa_protected_mask here in my V6.

>
> > +       vm->protected = true;
> > +}
> > +
> > ...
> > +}
>
> > --
> > 2.38.0.413.g74048e4d9e-goog
> >
