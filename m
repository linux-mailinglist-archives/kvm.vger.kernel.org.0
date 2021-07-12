Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEFF3C6038
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 18:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhGLQRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 12:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhGLQRC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 12:17:02 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78684C0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 09:14:13 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id a7so807748iln.6
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 09:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fdjvaDbIe1cuT0lGGP897G0jqvlO4g1BkN6i6kX1L6M=;
        b=GkL3CQU7IJT7LXNunEhxrksJkLMLkVx1N4XQKNfd4VReU7/zGhCgf8mNVIcKggLCQk
         GTG8o0YFZ7Ye6jlpoS0WRO/nIsWuHfpN37BPbfM6n3RKV/Bqdxr8TUzrWA3y8NHZtygM
         YE2IaOKic8fo7jFLFGpV1v7VqWWvzVRIiRoVDu4uihh1xyCP5bOGsdTkbHkghwaON7pj
         MSlEau6Lq5+lgMECVHSoPS7/OIryx3LZl28xxy8okSpBQrjw37OgNn8/avCzn244GfQi
         oP+sbVJvZ9GOsbmHDERXt3zqPkL0ZZo+ufyN/E5U864K0WNNcySVBuprVyZxszDZSCzN
         aG6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fdjvaDbIe1cuT0lGGP897G0jqvlO4g1BkN6i6kX1L6M=;
        b=NCbitTRUmFqEJkZgD95S3DayRO7+aAoS6VT+IdOWKK0xBFKqB5TNW1s2pNJC9X/LPr
         EgBeQc6YlbFWkQ9Uw8Hyx0AKIKeD3jqn9GMM0CKv560zY9srTP+Xh+vdyAU/gfywtbR+
         HqI8e8LWVObppewcg2qqpRAD4itpQ5/icACdtliX0AaaX87tjaVdPEIKFbl9tSKEZkGP
         vuR0VSzOG3yZwLEJBbrAXTXgTp3l9QMOwBy0imf7A/IpT9q8C2T3sHLcgE3K503y8Iy+
         t2seMw1Xhox1E7tJFzAvIHB1w/HeJEZMoZA+ySSuqYybW/I93Ebga8lHN1ndytcHQv4Z
         SJeQ==
X-Gm-Message-State: AOAM533gY74uY+jYbgRuTdH1MqEVcXTwN5dLZ2WAiH/1plb2ZNZfYU2a
        HIr8/914II/LOy8S4FQOLrLzhE3VFSeBuxmJUZV3Fg83brN/9w==
X-Google-Smtp-Source: ABdhPJzThPFOQY5k68zWQqJZXYB0Ci5KXC5VnGkaicxqo6rPbEyNGW10nQV34mMlJNISBGAEbZA27E+YmvjATATofqI=
X-Received: by 2002:a92:dc87:: with SMTP id c7mr21860087iln.306.1626106452776;
 Mon, 12 Jul 2021 09:14:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210630214802.1902448-1-dmatlack@google.com> <20210630214802.1902448-3-dmatlack@google.com>
In-Reply-To: <20210630214802.1902448-3-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 12 Jul 2021 09:14:01 -0700
Message-ID: <CANgfPd8zqOKjLeFCcYR-waHhDxb_6LX113o6Dv5uip8R_G3e8g@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] KVM: x86/mmu: Fix use of enums in trace_fast_page_fault
To:     David Matlack <dmatlack@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 30, 2021 at 2:48 PM David Matlack <dmatlack@google.com> wrote:
>
> Enum values have to be exported to userspace since the formatting is not
> done in the kernel. Without doing this perf maps RET_PF_FIXED and
> RET_PF_SPURIOUS to 0, which results in incorrect output:
>
>   $ perf record -a -e kvmmmu:fast_page_fault --filter "ret==3" -- ./access_tracking_perf_test
>   $ perf script | head -1
>    [...] new 610006048d25877 spurious 0 fixed 0  <------ should be 1
>
> Fix this by exporting the enum values to userspace with TRACE_DEFINE_ENUM.
>
> Fixes: c4371c2a682e ("KVM: x86/mmu: Return unique RET_PF_* values if the fault was fixed")
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmutrace.h | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
> index efbad33a0645..55c7e0fcda52 100644
> --- a/arch/x86/kvm/mmu/mmutrace.h
> +++ b/arch/x86/kvm/mmu/mmutrace.h
> @@ -244,6 +244,9 @@ TRACE_EVENT(
>                   __entry->access)
>  );
>
> +TRACE_DEFINE_ENUM(RET_PF_FIXED);
> +TRACE_DEFINE_ENUM(RET_PF_SPURIOUS);
> +

If you're planning to send out a v3 anyway, it might be worth adding
all the PF return code enums:

enum {
RET_PF_RETRY = 0,
RET_PF_EMULATE,
RET_PF_INVALID,
RET_PF_FIXED,
RET_PF_SPURIOUS,
};

Just so that no one has to worry about this in the future.

>  TRACE_EVENT(
>         fast_page_fault,
>         TP_PROTO(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u32 error_code,
> --
> 2.32.0.93.g670b81a890-goog
>
