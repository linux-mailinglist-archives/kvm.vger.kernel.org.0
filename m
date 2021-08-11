Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB623E971B
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 19:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhHKRzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 13:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhHKRzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 13:55:42 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF849C0613D3
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 10:55:17 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id d4so7449944lfk.9
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 10:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rUQ8qsIKb0jmCsRmsVCtriK4A1g1bFbYlRoFYCo5voI=;
        b=tB+KQZXOO/VH5k3iAwjO8zaROvEBWLxhaHcvF8J4B6HMrT5mcLQpfeUn7rFKhP6lXx
         ABM692/sdKIwnqLA/uEEgEnXR+tOFI2w/3881DfTJzLkkUCI26k03ZwtMKGZ+JGFLrHz
         Ko3FtGy6dP3iv8mPDngC0kTs6tdUolYWHbNF7fxYIY31v92IPXhTnHUsLkLlGL2OAVEX
         tZ+mgPOO35Vn1xKgA0c+cP4u/cMuX4r2aiWTfyV/URnd7KulJPMykio09WEW5s9Cn6n5
         lZ1431DDXbaQR6h7zYECFo8VOqWeIa58nPTfxPsXbd8rjMk/GyWyW47cflLc0SKidBFY
         Xdlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rUQ8qsIKb0jmCsRmsVCtriK4A1g1bFbYlRoFYCo5voI=;
        b=YFAMrvKSaWFChPBEUky/7vFMbnSl4fwK975u7qmFFrle2Ny85SGA8cufd0CzIRn5eq
         r+44UdTDs6ZEXxxqmuN0by/hAWXc+bXM1Vy4Qn4SOwaWOob+F1OjdH4/epdMuiIL4aHQ
         xQjAtVcBiCJ4O/KbfFYDvco4OfkDbnYfzssV9e/3IvcJOho9kAWkRQL17Tv8rRqG4FQ+
         HDAJ6IKUsVphj5JkPj7xyqh3a7qSfsbJbRGVGr+cfVVrj2ddaZziu6BbeLqjpe3rkELi
         vab35MTEopb2I0W5DafLeWBMT1XTLwyrZ0BdnTt8HK735jNVwLzGc8UyqFAQg4oysc0k
         gODg==
X-Gm-Message-State: AOAM533IdkvDxHQVCU9pz7Z1riFfQCS6EnDsDro7effEi7KYJfSC/oB1
        JRQgxt+5niwxg6SH0ZF4eEBZtvv/zz2lIEIvBg/dJg==
X-Google-Smtp-Source: ABdhPJz4sn6z0hn6iEjFcj8jNAMZoZDN1Uqdg5ZO3o3HkdepqXhwm3XmqEoL1r6GVFLrdLDhckiTkFGeYyC9ZO39ydc=
X-Received: by 2002:ac2:5324:: with SMTP id f4mr37199lfh.106.1628704515892;
 Wed, 11 Aug 2021 10:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210811165346.3110715-1-seanjc@google.com>
In-Reply-To: <20210811165346.3110715-1-seanjc@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 11 Aug 2021 10:55:05 -0700
Message-ID: <CAAdAUti5N=AZgrhTvtwvX=q9ci2bgJqqya8tuM1+vD8YkhFtMw@mail.gmail.com>
Subject: Re: [PATCH] KVM: Move binary stats helpers to header to effectively
 export them
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021 at 9:53 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Move kvm_stats_linear_hist_update() and kvm_stats_log_hist_update() to
> kvm_host.h as static inline helpers to resolve a linker error on PPC,
> which references the latter from module code.  This also fixes a goof
> where the functions are tagged as "inline", despite being externs and
> thus not inline-friendy.
>
>   ERROR: modpost: ".kvm_stats_log_hist_update" [arch/powerpc/kvm/kvm-hv.ko] undefined!
>
> Fixes: c8ba95948182 ("KVM: stats: Support linear and logarithmic histogram statistics")
> Cc: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  include/linux/kvm_host.h | 38 +++++++++++++++++++++++++++++++++++---
>  virt/kvm/binary_stats.c  | 34 ----------------------------------
>  2 files changed, 35 insertions(+), 37 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d447b21cdd73..e4d712e9f760 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1467,9 +1467,41 @@ ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
>                        const struct _kvm_stats_desc *desc,
>                        void *stats, size_t size_stats,
>                        char __user *user_buffer, size_t size, loff_t *offset);
> -inline void kvm_stats_linear_hist_update(u64 *data, size_t size,
> -                                 u64 value, size_t bucket_size);
> -inline void kvm_stats_log_hist_update(u64 *data, size_t size, u64 value);
> +
> +/**
> + * kvm_stats_linear_hist_update() - Update bucket value for linear histogram
> + * statistics data.
> + *
> + * @data: start address of the stats data
> + * @size: the number of bucket of the stats data
> + * @value: the new value used to update the linear histogram's bucket
> + * @bucket_size: the size (width) of a bucket
> + */
> +static inline void kvm_stats_linear_hist_update(u64 *data, size_t size,
> +                                               u64 value, size_t bucket_size)
> +{
> +       size_t index = div64_u64(value, bucket_size);
> +
> +       index = min(index, size - 1);
> +       ++data[index];
> +}
> +
> +/**
> + * kvm_stats_log_hist_update() - Update bucket value for logarithmic histogram
> + * statistics data.
> + *
> + * @data: start address of the stats data
> + * @size: the number of bucket of the stats data
> + * @value: the new value used to update the logarithmic histogram's bucket
> + */
> +static inline void kvm_stats_log_hist_update(u64 *data, size_t size, u64 value)
> +{
> +       size_t index = fls64(value);
> +
> +       index = min(index, size - 1);
> +       ++data[index];
> +}
> +
>  #define KVM_STATS_LINEAR_HIST_UPDATE(array, value, bsize)                     \
>         kvm_stats_linear_hist_update(array, ARRAY_SIZE(array), value, bsize)
>  #define KVM_STATS_LOG_HIST_UPDATE(array, value)                                       \
> diff --git a/virt/kvm/binary_stats.c b/virt/kvm/binary_stats.c
> index 9bd595c92d3a..eefca6c69f51 100644
> --- a/virt/kvm/binary_stats.c
> +++ b/virt/kvm/binary_stats.c
> @@ -142,37 +142,3 @@ ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
>         *offset = pos;
>         return len;
>  }
> -
> -/**
> - * kvm_stats_linear_hist_update() - Update bucket value for linear histogram
> - * statistics data.
> - *
> - * @data: start address of the stats data
> - * @size: the number of bucket of the stats data
> - * @value: the new value used to update the linear histogram's bucket
> - * @bucket_size: the size (width) of a bucket
> - */
> -inline void kvm_stats_linear_hist_update(u64 *data, size_t size,
> -                                 u64 value, size_t bucket_size)
> -{
> -       size_t index = div64_u64(value, bucket_size);
> -
> -       index = min(index, size - 1);
> -       ++data[index];
> -}
> -
> -/**
> - * kvm_stats_log_hist_update() - Update bucket value for logarithmic histogram
> - * statistics data.
> - *
> - * @data: start address of the stats data
> - * @size: the number of bucket of the stats data
> - * @value: the new value used to update the logarithmic histogram's bucket
> - */
> -inline void kvm_stats_log_hist_update(u64 *data, size_t size, u64 value)
> -{
> -       size_t index = fls64(value);
> -
> -       index = min(index, size - 1);
> -       ++data[index];
> -}
> --
> 2.32.0.605.g8dce9f2422-goog
>
Thanks for fixing it, Sean!

Reviewed-by: Jing Zhang <jingzhangos@google.com>
