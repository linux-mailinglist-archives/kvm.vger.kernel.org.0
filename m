Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5963D5D2F
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 17:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhGZO6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 10:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbhGZO6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 10:58:38 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6ECC061757
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 08:39:05 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id y34so16217413lfa.8
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 08:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dwCNRftHYWD7NBIw4r5A0Mq9O67sJnz6m1wxSVXTL24=;
        b=rtCk4LuGqVRFIWSl8BsirXDUKgvnyH312m4S4+Vi5kpXl/UhXHDa51h4u7ytxjeDwr
         vcjerLkauIKKUWRVEslY1ofBVKuWCC/cxtFQe+eqWAPgyz+0xMt4Pzbz1Ik8c5yX8nPI
         PXTWIL4ppLe8nG9fH+Fw2oY4Lj6pC5+dyC1RrsLP9IxPHzUhKwngcQ7/Rmuu9ttIhAKr
         l987vjAswxdRce3VTzSEH2LXzhbG3ySUBpTl3HBP0OJtktHhWs+gigzYGeDAomAPnn0V
         0kS/bezrG3msGZERFNMmgu9RIvmsPaCGv8omISuYYpISSoEGLp1MDfqX+gu6ITjiqxDP
         GHlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dwCNRftHYWD7NBIw4r5A0Mq9O67sJnz6m1wxSVXTL24=;
        b=Xu8NEb5NxjOokFe4wHgMzGUInKJzgT/FLr9KcWDMd9nAbu1qGlehJA/PmBqE7YKWBx
         xtu5u11LrN/o+Z3vAmLvTpdNcwqtKnDXQjCoC/wI+rVS+50Bq8QlKy0NSJ3lguQD++3g
         sOEjX+ZzxcniVX7kFMxHzjQe/d8fd+HmcY+vhEtTmjpaFw9P2IpTsLp6bP8TpAO6nz7B
         XUMZOIdQOtl9vZKP9wcp2s2CTGx8qqB9F+xkQ8DOddXuRn1qBcXkId2QGVBihuQj0Vp1
         Te1ZBdDXXtcozPPEmQTzAsIDKocEdMtPe6Nu5vKuxFW/GLxvHyUCNjaKQKavlz1Y4N24
         y1vw==
X-Gm-Message-State: AOAM531JNx4OVRL3GWB8YeIUmxW/g4xi7vc/hjlTDesaJwnnYeyPWHGB
        T89zaSYL5jjN/0wFbdaPyquAwDSf1EWtalZRW4qgJQ==
X-Google-Smtp-Source: ABdhPJxtkcChthiqrs9wxSrfaxczEI5NW8lXOwcniuaKHt59WPJSB+hL6q0tu0MyZlUNL5Z3DnAZeobZhtPptRdeUPY=
X-Received: by 2002:a19:6b14:: with SMTP id d20mr13503027lfa.359.1627313943898;
 Mon, 26 Jul 2021 08:39:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210726150108.5603-1-borntraeger@de.ibm.com>
In-Reply-To: <20210726150108.5603-1-borntraeger@de.ibm.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 26 Jul 2021 08:38:52 -0700
Message-ID: <CAAdAUthKpk1W130zGyjstic1qGB2qrkidZaNOWCh1Yii-o+EwQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: s390: restore old debugfs names
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021 at 8:01 AM Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
> commit bc9e9e672df9 ("KVM: debugfs: Reuse binary stats descriptors")
> did replace the old definitions with the binary ones. While doing that
> it missed that some files are names different than the counters. This
> is especially important for kvm_stat which does have special handling
> for counters named instruction_*.
>
> Fixes: commit bc9e9e672df9 ("KVM: debugfs: Reuse binary stats descriptors")
> CC: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 18 +++++++++---------
>  arch/s390/kvm/diag.c             | 18 +++++++++---------
>  arch/s390/kvm/kvm-s390.c         | 18 +++++++++---------
>  3 files changed, 27 insertions(+), 27 deletions(-)
>
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 3a5b5084cdbe..f1a202327ebd 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -446,15 +446,15 @@ struct kvm_vcpu_stat {
>         u64 instruction_sigp_init_cpu_reset;
>         u64 instruction_sigp_cpu_reset;
>         u64 instruction_sigp_unknown;
> -       u64 diagnose_10;
> -       u64 diagnose_44;
> -       u64 diagnose_9c;
> -       u64 diagnose_9c_ignored;
> -       u64 diagnose_9c_forward;
> -       u64 diagnose_258;
> -       u64 diagnose_308;
> -       u64 diagnose_500;
> -       u64 diagnose_other;
> +       u64 instruction_diagnose_10;
> +       u64 instruction_diagnose_44;
> +       u64 instruction_diagnose_9c;
> +       u64 diag_9c_ignored;
> +       u64 diag_9c_forward;
> +       u64 instruction_diagnose_258;
> +       u64 instruction_diagnose_308;
> +       u64 instruction_diagnose_500;
> +       u64 instruction_diagnose_other;
>         u64 pfault_sync;
>  };
>
> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
> index 02c146f9e5cd..807fa9da1e72 100644
> --- a/arch/s390/kvm/diag.c
> +++ b/arch/s390/kvm/diag.c
> @@ -24,7 +24,7 @@ static int diag_release_pages(struct kvm_vcpu *vcpu)
>
>         start = vcpu->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
>         end = vcpu->run->s.regs.gprs[vcpu->arch.sie_block->ipa & 0xf] + PAGE_SIZE;
> -       vcpu->stat.diagnose_10++;
> +       vcpu->stat.instruction_diagnose_10++;
>
>         if (start & ~PAGE_MASK || end & ~PAGE_MASK || start >= end
>             || start < 2 * PAGE_SIZE)
> @@ -74,7 +74,7 @@ static int __diag_page_ref_service(struct kvm_vcpu *vcpu)
>
>         VCPU_EVENT(vcpu, 3, "diag page reference parameter block at 0x%llx",
>                    vcpu->run->s.regs.gprs[rx]);
> -       vcpu->stat.diagnose_258++;
> +       vcpu->stat.instruction_diagnose_258++;
>         if (vcpu->run->s.regs.gprs[rx] & 7)
>                 return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>         rc = read_guest(vcpu, vcpu->run->s.regs.gprs[rx], rx, &parm, sizeof(parm));
> @@ -145,7 +145,7 @@ static int __diag_page_ref_service(struct kvm_vcpu *vcpu)
>  static int __diag_time_slice_end(struct kvm_vcpu *vcpu)
>  {
>         VCPU_EVENT(vcpu, 5, "%s", "diag time slice end");
> -       vcpu->stat.diagnose_44++;
> +       vcpu->stat.instruction_diagnose_44++;
>         kvm_vcpu_on_spin(vcpu, true);
>         return 0;
>  }
> @@ -169,7 +169,7 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
>         int tid;
>
>         tid = vcpu->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
> -       vcpu->stat.diagnose_9c++;
> +       vcpu->stat.instruction_diagnose_9c++;
>
>         /* yield to self */
>         if (tid == vcpu->vcpu_id)
> @@ -192,7 +192,7 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
>                 VCPU_EVENT(vcpu, 5,
>                            "diag time slice end directed to %d: yield forwarded",
>                            tid);
> -               vcpu->stat.diagnose_9c_forward++;
> +               vcpu->stat.diag_9c_forward++;
>                 return 0;
>         }
>
> @@ -203,7 +203,7 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
>         return 0;
>  no_yield:
>         VCPU_EVENT(vcpu, 5, "diag time slice end directed to %d: ignored", tid);
> -       vcpu->stat.diagnose_9c_ignored++;
> +       vcpu->stat.diag_9c_ignored++;
>         return 0;
>  }
>
> @@ -213,7 +213,7 @@ static int __diag_ipl_functions(struct kvm_vcpu *vcpu)
>         unsigned long subcode = vcpu->run->s.regs.gprs[reg] & 0xffff;
>
>         VCPU_EVENT(vcpu, 3, "diag ipl functions, subcode %lx", subcode);
> -       vcpu->stat.diagnose_308++;
> +       vcpu->stat.instruction_diagnose_308++;
>         switch (subcode) {
>         case 3:
>                 vcpu->run->s390_reset_flags = KVM_S390_RESET_CLEAR;
> @@ -245,7 +245,7 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
>  {
>         int ret;
>
> -       vcpu->stat.diagnose_500++;
> +       vcpu->stat.instruction_diagnose_500++;
>         /* No virtio-ccw notification? Get out quickly. */
>         if (!vcpu->kvm->arch.css_support ||
>             (vcpu->run->s.regs.gprs[1] != KVM_S390_VIRTIO_CCW_NOTIFY))
> @@ -299,7 +299,7 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>         case 0x500:
>                 return __diag_virtio_hypercall(vcpu);
>         default:
> -               vcpu->stat.diagnose_other++;
> +               vcpu->stat.instruction_diagnose_other++;
>                 return -EOPNOTSUPP;
>         }
>  }
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 7675b72a3ddf..01925ef78518 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -163,15 +163,15 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>         STATS_DESC_COUNTER(VCPU, instruction_sigp_init_cpu_reset),
>         STATS_DESC_COUNTER(VCPU, instruction_sigp_cpu_reset),
>         STATS_DESC_COUNTER(VCPU, instruction_sigp_unknown),
> -       STATS_DESC_COUNTER(VCPU, diagnose_10),
> -       STATS_DESC_COUNTER(VCPU, diagnose_44),
> -       STATS_DESC_COUNTER(VCPU, diagnose_9c),
> -       STATS_DESC_COUNTER(VCPU, diagnose_9c_ignored),
> -       STATS_DESC_COUNTER(VCPU, diagnose_9c_forward),
> -       STATS_DESC_COUNTER(VCPU, diagnose_258),
> -       STATS_DESC_COUNTER(VCPU, diagnose_308),
> -       STATS_DESC_COUNTER(VCPU, diagnose_500),
> -       STATS_DESC_COUNTER(VCPU, diagnose_other),
> +       STATS_DESC_COUNTER(VCPU, instruction_diagnose_10),
> +       STATS_DESC_COUNTER(VCPU, instruction_diagnose_44),
> +       STATS_DESC_COUNTER(VCPU, instruction_diagnose_9c),
> +       STATS_DESC_COUNTER(VCPU, diag_9c_ignored),
> +       STATS_DESC_COUNTER(VCPU, diag_9c_forward),
> +       STATS_DESC_COUNTER(VCPU, instruction_diagnose_258),
> +       STATS_DESC_COUNTER(VCPU, instruction_diagnose_308),
> +       STATS_DESC_COUNTER(VCPU, instruction_diagnose_500),
> +       STATS_DESC_COUNTER(VCPU, instruction_diagnose_other),
>         STATS_DESC_COUNTER(VCPU, pfault_sync)
>  };
>  static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
> --
> 2.31.1
>
Reviewed-by: Jing Zhang <jingzhangos@google.com>

Thanks,
Jing
