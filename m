Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D241E11BDCB
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 21:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfLKUXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 15:23:01 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33818 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfLKUXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 15:23:01 -0500
Received: by mail-io1-f66.google.com with SMTP id z193so219959iof.1
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 12:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IKRIXWRJNR/et1ORAaFvhmZJFe5scHCBMbx4VrCqp2w=;
        b=RSiPCeGsHxOpGzSzI1iKMCLJA8BbxqIaDPf41YD6z/lwA6bcXinfh2UWwtTQD6/Roi
         Sbul1zpqtHeBm/uKr7khJD1dPfCGOIilAL6/ZJl+iJRqkxeUYOAHhwgjWSOwx5S3rE3c
         95bcPYV38LyOI9I9VMqmGbnRW37B0qqpNVnFiYSLUF3MeMY/wS1JTvvrZdnAqdQ60sCk
         KhYW5tQBRgPqap3zj7TBwE+bzXUlJMED4Ym+1lzSyrqhy/e0csOiqnmO3q7x95Hps1ZU
         XNdkQfaWAxhGsLY+E7x5o9nZkp924D0FKZ8//8Dbh8H67nuRVO2pfqG6eyYPUbNI+mTa
         jClw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IKRIXWRJNR/et1ORAaFvhmZJFe5scHCBMbx4VrCqp2w=;
        b=THQjNWmBX5STZR8ATTFLvLSTzn4tOieXfSqtstLIibpzbW+K4CNr2/OCUGTfTPJ8Fq
         EK5K+QsY3Vs7URHb9l5qOQW1iDgwFmNglaXY90TRohyw260fzDzg6QdUqMENLUXSw/S2
         vmIoPMZkWVYtXcQvGJjnqKFhxoTIaFlEGEOtCaxuIk+UXL9LB+oajdyg/Ekp5Z+W33Rn
         QlgX9olxX1byAvqyb+GOf0jE9sU+wcLCyg9BmrKEl/hUuRp1dzlItnqylfpr14UOdy2S
         WYebMTDnjtQfDICfiAVRMdF2m1PNJiyGccR0Rz5OBBIHOmSYwXHxpRLiKsrmlxrsIp0m
         fseA==
X-Gm-Message-State: APjAAAXN+nVq9j3dZvyQ3Yy2k5Etc61kTKlGQCZ7CZHeRFhv4+RKFou3
        bI+InP+tbifuPfEu7B4VJJZYkcu3V2hSU5gYUiHmkg==
X-Google-Smtp-Source: APXvYqz0XMTQRjsAcJT7qleb0nHWKF4Jr1rC4NJJg9TYZd8SXVWZDiojyQOvm4O8X+FK9scVGDM2xTSG2p3dyEurFZ4=
X-Received: by 2002:a5d:9904:: with SMTP id x4mr2531718iol.119.1576095780017;
 Wed, 11 Dec 2019 12:23:00 -0800 (PST)
MIME-Version: 1.0
References: <20190220202442.145494-1-pshier@google.com>
In-Reply-To: <20190220202442.145494-1-pshier@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 11 Dec 2019 12:22:49 -0800
Message-ID: <CALMp9eRMbht+7xHXJV90MSs52LtjjdCtVeCdd_=5nqeSms8VxQ@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] Update AMD instructions to conform to LLVM assembler
To:     Peter Shier <pshier@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, drjones@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 20, 2019 at 12:25 PM Peter Shier <pshier@google.com> wrote:
>
> The GNU assembler (gas) allows omitting operands where there is only a
> single choice e.g. "VMRUN rAX".The LLVM assembler requires those operands
> even though they are the default and only choice.
>
> In addition, LLVM does not allow a CLGI instruction with a terminating
> \n\t. Adding a ; separator after the instruction is a workaround.
>
> Signed-off-by: Peter Shier <pshier@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  x86/svm.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/x86/svm.c b/x86/svm.c
> index bc74e7c690a8..e5cb730b08cb 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -154,7 +154,7 @@ static void vmcb_ident(struct vmcb *vmcb)
>      struct descriptor_table_ptr desc_table_ptr;
>
>      memset(vmcb, 0, sizeof(*vmcb));
> -    asm volatile ("vmsave" : : "a"(vmcb_phys) : "memory");
> +    asm volatile ("vmsave %0" : : "a"(vmcb_phys) : "memory");
>      vmcb_set_seg(&save->es, read_es(), 0, -1U, data_seg_attr);
>      vmcb_set_seg(&save->cs, read_cs(), 0, -1U, code_seg_attr);
>      vmcb_set_seg(&save->ss, read_ss(), 0, -1U, data_seg_attr);
> @@ -262,20 +262,20 @@ static void test_run(struct test *test, struct vmcb *vmcb)
>      do {
>          tsc_start = rdtsc();
>          asm volatile (
> -            "clgi \n\t"
> -            "vmload \n\t"
> +            "clgi;\n\t" // semi-colon needed for LLVM compatibility
> +            "vmload %0\n\t"
>              "mov regs+0x80, %%r15\n\t"  // rflags
>              "mov %%r15, 0x170(%0)\n\t"
>              "mov regs, %%r15\n\t"       // rax
>              "mov %%r15, 0x1f8(%0)\n\t"
>              LOAD_GPR_C
> -            "vmrun \n\t"
> +            "vmrun %0\n\t"
>              SAVE_GPR_C
>              "mov 0x170(%0), %%r15\n\t"  // rflags
>              "mov %%r15, regs+0x80\n\t"
>              "mov 0x1f8(%0), %%r15\n\t"  // rax
>              "mov %%r15, regs\n\t"
> -            "vmsave \n\t"
> +            "vmsave %0\n\t"
>              "stgi"
>              : : "a"(vmcb_phys)
>              : "rbx", "rcx", "rdx", "rsi",
> @@ -330,7 +330,7 @@ static bool check_no_vmrun_int(struct test *test)
>
>  static void test_vmrun(struct test *test)
>  {
> -    asm volatile ("vmrun" : : "a"(virt_to_phys(test->vmcb)));
> +    asm volatile ("vmrun %0" : : "a"(virt_to_phys(test->vmcb)));
>  }
>
>  static bool check_vmrun(struct test *test)
> @@ -1241,7 +1241,7 @@ static bool lat_svm_insn_finished(struct test *test)
>
>      for ( ; runs != 0; runs--) {
>          tsc_start = rdtsc();
> -        asm volatile("vmload\n\t" : : "a"(vmcb_phys) : "memory");
> +        asm volatile("vmload %0\n\t" : : "a"(vmcb_phys) : "memory");
>          cycles = rdtsc() - tsc_start;
>          if (cycles > latvmload_max)
>              latvmload_max = cycles;
> @@ -1250,7 +1250,7 @@ static bool lat_svm_insn_finished(struct test *test)
>          vmload_sum += cycles;
>
>          tsc_start = rdtsc();
> -        asm volatile("vmsave\n\t" : : "a"(vmcb_phys) : "memory");
> +        asm volatile("vmsave %0\n\t" : : "a"(vmcb_phys) : "memory");
>          cycles = rdtsc() - tsc_start;
>          if (cycles > latvmsave_max)
>              latvmsave_max = cycles;

Ping.
