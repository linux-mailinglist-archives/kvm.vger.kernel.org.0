Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1037C3EB1A9
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbhHMHjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:39:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239505AbhHMHjL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:39:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628840324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SvXxk+Bwl8PSRfSCw5jxJaxQNQ1yN0WrjeALiehgCJU=;
        b=NHcPanYWAoS0PXE+Z/WC/t6sH5v4oLx1MveyM8NhZK/5Ym8aHLMUC7Cw1opaqoUdadsXnE
        K7A6zRu+AicMvqxrF2AlDLq91UFZ7o+aLkpMWh7JhUyfdMtxn+W8VtY+rST4Gsw6Nc8KpQ
        p/Iaiik0Z5mg2E6myK1Qc/8817BUVpw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-mqj-FTK3OAayiJ1Z5tX-RQ-1; Fri, 13 Aug 2021 03:38:43 -0400
X-MC-Unique: mqj-FTK3OAayiJ1Z5tX-RQ-1
Received: by mail-ej1-f70.google.com with SMTP id h13-20020a1709062dcdb02905aec576a827so2653319eji.23
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 00:38:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SvXxk+Bwl8PSRfSCw5jxJaxQNQ1yN0WrjeALiehgCJU=;
        b=QOiQQdCVIQpD0AJz9AMF5MEhQdiIGW/qtTvT2R6Xoxrd+V6TFNw6UK+b1ng+ZwjwgI
         pIYy7AwHXxbyFmgtgn2uIVg+ehX3hetubReO+3iMK6/+JXI5aU3hMYHBh6e2e+bsvXCB
         bNYFR12p5QeVALOzBgwkwcdEZyinwCaZ1p4BuZRYWvqlrNrA5cqp/AI8jHoIS0KUjZ05
         mpiqxY4L0mSR5hX9EOPfipvlm7ttdtpPZRUIKYXU3eY67S6zSGMaf32wf4uprY+VhUsa
         rB1IAnWkwtQncS8hdzWvG1hZoOB+0CNj5HGP4eh50ObqXEQisbog1nf0PEPIs6atCFOz
         p++A==
X-Gm-Message-State: AOAM532eX8hHc/p5PRdi13K0G/T5xKIjVrPEhfGvzOsBj+Ck7N+3KSEZ
        GXjUi7KmFpjcEQ9JLRiUEoKQ8XuoL3ZcPocF4yNxJZrjiVHJwR1huPmylP4vqLfHonyWe4ZauHe
        B5LtNWR0SvY33
X-Received: by 2002:aa7:c952:: with SMTP id h18mr1492223edt.18.1628840321567;
        Fri, 13 Aug 2021 00:38:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMBnpwhnGL9v9XN0Q0Cm//1oQz0wrxlCELXtuPLvzh4SzzKejsQT7MxAxkU+ZpHiU4y+TQxQ==
X-Received: by 2002:aa7:c952:: with SMTP id h18mr1492212edt.18.1628840321422;
        Fri, 13 Aug 2021 00:38:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l19sm431732edb.86.2021.08.13.00.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 00:38:40 -0700 (PDT)
Subject: Re: [PATCH] KVM: Move binary stats helpers to header to effectively
 export them
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>
References: <20210811165346.3110715-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <198b5907-2f65-d469-fad5-04b2369f4e33@redhat.com>
Date:   Fri, 13 Aug 2021 09:38:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210811165346.3110715-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/08/21 18:53, Sean Christopherson wrote:
> Move kvm_stats_linear_hist_update() and kvm_stats_log_hist_update() to
> kvm_host.h as static inline helpers to resolve a linker error on PPC,
> which references the latter from module code.  This also fixes a goof
> where the functions are tagged as "inline", despite being externs and
> thus not inline-friendy.
> 
>    ERROR: modpost: ".kvm_stats_log_hist_update" [arch/powerpc/kvm/kvm-hv.ko] undefined!
> 
> Fixes: c8ba95948182 ("KVM: stats: Support linear and logarithmic histogram statistics")
> Cc: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   include/linux/kvm_host.h | 38 +++++++++++++++++++++++++++++++++++---
>   virt/kvm/binary_stats.c  | 34 ----------------------------------
>   2 files changed, 35 insertions(+), 37 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d447b21cdd73..e4d712e9f760 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1467,9 +1467,41 @@ ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
>   		       const struct _kvm_stats_desc *desc,
>   		       void *stats, size_t size_stats,
>   		       char __user *user_buffer, size_t size, loff_t *offset);
> -inline void kvm_stats_linear_hist_update(u64 *data, size_t size,
> -				  u64 value, size_t bucket_size);
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
> +						u64 value, size_t bucket_size)
> +{
> +	size_t index = div64_u64(value, bucket_size);
> +
> +	index = min(index, size - 1);
> +	++data[index];
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
> +	size_t index = fls64(value);
> +
> +	index = min(index, size - 1);
> +	++data[index];
> +}
> +
>   #define KVM_STATS_LINEAR_HIST_UPDATE(array, value, bsize)		       \
>   	kvm_stats_linear_hist_update(array, ARRAY_SIZE(array), value, bsize)
>   #define KVM_STATS_LOG_HIST_UPDATE(array, value)				       \
> diff --git a/virt/kvm/binary_stats.c b/virt/kvm/binary_stats.c
> index 9bd595c92d3a..eefca6c69f51 100644
> --- a/virt/kvm/binary_stats.c
> +++ b/virt/kvm/binary_stats.c
> @@ -142,37 +142,3 @@ ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
>   	*offset = pos;
>   	return len;
>   }
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
> -				  u64 value, size_t bucket_size)
> -{
> -	size_t index = div64_u64(value, bucket_size);
> -
> -	index = min(index, size - 1);
> -	++data[index];
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
> -	size_t index = fls64(value);
> -
> -	index = min(index, size - 1);
> -	++data[index];
> -}
> 

Squashed, thanks.

Paolo

