Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E482A243F23
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 21:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgHMTFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 15:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgHMTFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 15:05:06 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB4FC061383
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 12:05:06 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id e6so6028848oii.4
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 12:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HuU3ViDe278lSw17ntg5nYTRmQsPcKzMV9Ui8nZNn08=;
        b=qvaTnGMy76pjktYEEGGOjwXIxyF2kIjefRgdP+5JsqhJredrqmgG7skH2KAZVGTbvD
         z5SdDkFCim3I4rnr+fbmjxB6H2bLvTgDt49fkIHsrxbfOq6GKLIjdbXBs41nBCA5Jknt
         wy+JHUbBYqzKHlS0u96hvD22PQ8nVP/Ncx4R8r3KDyHp4OxyPLhcPcQCgSKIFFNkM9bX
         g0KzOa6EiX7NGGUTrufTxlWTWED7H7KueZLP0PM6Qn8wi3okUzROr5WZfymEUO5g/+cD
         XkFYwzcdwMnWaXq5nrtgY0ipfOE07HHR2L84EDV84QVFPRogQpzl+r0Tgis/jvszYiLQ
         YAeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HuU3ViDe278lSw17ntg5nYTRmQsPcKzMV9Ui8nZNn08=;
        b=mqNbT5WYq5hj+VUkYRuWileK/NNRC3qhN1683WIy9wqR9/0a/5q+0XV5c0SStt8shP
         b4385Xh7D3K3xqbhGV8etxaGe/5Ytf/vB9J5meYED/SJYN/YhTty9Y28P8dRmsdNJ4/v
         5Ho55+hGG4Gz5iRYhZkrv0jJeN1U7Fp2UvEXHBathMeVAYAI2IKN4+AzVcRGSMgu4+5u
         s3947qXnSmJjGzm7qQ/MTJKaNKwSl7H7xnZeMdTDl8oQnxF5+7MMjqEse7BOoRI6qP/Z
         OXcXKRIHRIRUNnwkLwF0VSj4z6Pj4YzC37G7Ocx9AZVtq7es7ULE7pLDmRtHThRLUZja
         KLQw==
X-Gm-Message-State: AOAM530PRolIEuzWH0It0B5EwzDjhKgDKNWpjoRVCUiMa3NNEsrNCaCp
        X4zZsUhJy7qEt2KxEqad3j9PqQccTcAkYgfxIg/Kfw==
X-Google-Smtp-Source: ABdhPJw5GaSIUEoCWxPsJEVVeiZAPfCUlXhncfV64G1JdmV9HhjG2Do+1NwYTyMZ14oLQH/ODwFBeqECOj8WongeEVQ=
X-Received: by 2002:aca:b942:: with SMTP id j63mr4518741oif.28.1597345505789;
 Thu, 13 Aug 2020 12:05:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200807084841.7112-1-chenyi.qiang@intel.com> <20200807084841.7112-7-chenyi.qiang@intel.com>
In-Reply-To: <20200807084841.7112-7-chenyi.qiang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 13 Aug 2020 12:04:54 -0700
Message-ID: <CALMp9eQ=QUZ04_26eXBGHqvQYnsN6JEgiV=ZSSrE395KLX-atA@mail.gmail.com>
Subject: Re: [RFC 6/7] KVM: X86: Expose PKS to guest and userspace
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 7, 2020 at 1:47 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>
> Existence of PKS is enumerated via CPUID.(EAX=7H,ECX=0):ECX[31]. It is
> enabled by setting CR4.PKS when long mode is active. PKS is only
> implemented when EPT is enabled and requires the support of VM_{ENTRY,
> EXIT}_LOAD_IA32_PKRS currently.
>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

> @@ -967,7 +969,8 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  {
>         unsigned long old_cr4 = kvm_read_cr4(vcpu);
>         unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
> -                                  X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
> +                                  X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE |
> +                                  X86_CR4_PKS;

This list already seems overly long, but I don't think CR4.PKS belongs
here. In volume 3 of the SDM, section 4.4.1, it says:

- If PAE paging would be in use following an execution of MOV to CR0
or MOV to CR4 (see Section 4.1.1) and the instruction is modifying any
of CR0.CD, CR0.NW, CR0.PG, CR4.PAE, CR4.PGE, CR4.PSE, or CR4.SMEP;
then the PDPTEs are loaded from the address in CR3.

CR4.PKS is not in the list of CR4 bits that result in a PDPTE load.
Since it has no effect on PAE paging, I would be surprised if it did
result in a PDPTE load.

>         if (kvm_valid_cr4(vcpu, cr4))
>                 return 1;
> @@ -1202,7 +1205,7 @@ static const u32 msrs_to_save_all[] = {
>         MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
>         MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
>         MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
> -       MSR_IA32_UMWAIT_CONTROL,
> +       MSR_IA32_UMWAIT_CONTROL, MSR_IA32_PKRS,

Should MSR_IA32_PKRS be added to the switch statement in
kvm_init_msr_list()? Something like...

case MSR_IA32_PKRS:
        if (!kvm_cpu_cap_has(X86_FEATURE_PKRS))
                continue;
        break;
