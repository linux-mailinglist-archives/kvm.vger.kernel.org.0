Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA872333FF
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 16:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgG3OLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 10:11:45 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37765 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728092AbgG3OLo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 10:11:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596118302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=M/MKoN5ftJyqkVEAH2Oa2uf/QsJbrQHtaLoe10pA/v4=;
        b=NMwjlrnQ8L33P3yshPiFtXglpuWO8ihD3QdWbxAoN/L2b9+uvj1yF07+NPfr0n1qDM6A4X
        80T1zUmcVWsWh5PsYzp1dAymH2xlgQ9p/kMcv4txuzWOG2Lq0tmiG3svU6obfADyR5Zu15
        VhLJcVsv/emL028p4xKZTOauLaPFxHY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-dFasVKRYN-CNhblKcEdYwQ-1; Thu, 30 Jul 2020 10:11:41 -0400
X-MC-Unique: dFasVKRYN-CNhblKcEdYwQ-1
Received: by mail-wm1-f71.google.com with SMTP id h205so2283769wmf.0
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 07:11:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=M/MKoN5ftJyqkVEAH2Oa2uf/QsJbrQHtaLoe10pA/v4=;
        b=ZceFNikaOgETy4vLeIgIx8/QQ6sydrEyY1nzUsjrXcCfNtsp+A5f8UwtwFRLoUY7uC
         nvgKIwJcnCOCao9G2CkExAzeEDxdIsIgqe5+XHS7SLS9slp+KryOzBH10F3I+amEqHm1
         aF7T+mqk+9l2OBCuA+XTBvPhwJxFwuQGfcWL4TifdHxXxDyOJxMMZvCkz/RC45vj26HS
         TTB/hIk18yzvpkcdhBCpM+lQsao6r4ZU5NhVZ/uqvZFVDSHD7XTEf8rI9sHaO5v17T0z
         z1ILTeO41aAetdMubPTClyl0P1x1qW07ePP7zKcY7EBtex0OUxcgUHhnnQNmv7X3GKXb
         Lk0w==
X-Gm-Message-State: AOAM531GS/DswNUGrsyI/cSUgVLu+TzDdiKJGHqsOQy1+xX1bKwrhx3x
        aguZVioaLDb77fmXD7oyoKLRPWkVYzUMyBFRFD5ZnR2qGk4z8sh5DXYn1+nXRlFzFk9yRtpHN3E
        f6bMY9hNDKjph
X-Received: by 2002:a5d:54ca:: with SMTP id x10mr2943535wrv.36.1596118299782;
        Thu, 30 Jul 2020 07:11:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZwcbwVI0C3+XBjW9I05DrW5l3wm/NJIdp9/MWFuXSUQ1G3q3E7UZmPoXLtu6BhBR2MJK61Q==
X-Received: by 2002:a5d:54ca:: with SMTP id x10mr2943520wrv.36.1596118299596;
        Thu, 30 Jul 2020 07:11:39 -0700 (PDT)
Received: from [192.168.1.39] (214.red-88-21-68.staticip.rima-tde.net. [88.21.68.214])
        by smtp.gmail.com with ESMTPSA id c4sm9628192wrt.41.2020.07.30.07.11.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 07:11:39 -0700 (PDT)
Subject: Re: [PATCH-for-5.1?] util/pagesize: Make qemu_real_host_page_size of
 type size_t
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Kaige Li <likaige@loongson.cn>, qemu-block@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, qemu-ppc@nongnu.org,
        Bruce Rogers <brogers@suse.com>
References: <20200730135935.23968-1-philmd@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Autocrypt: addr=philmd@redhat.com; keydata=
 mQINBDXML8YBEADXCtUkDBKQvNsQA7sDpw6YLE/1tKHwm24A1au9Hfy/OFmkpzo+MD+dYc+7
 bvnqWAeGweq2SDq8zbzFZ1gJBd6+e5v1a/UrTxvwBk51yEkadrpRbi+r2bDpTJwXc/uEtYAB
 GvsTZMtiQVA4kRID1KCdgLa3zztPLCj5H1VZhqZsiGvXa/nMIlhvacRXdbgllPPJ72cLUkXf
 z1Zu4AkEKpccZaJspmLWGSzGu6UTZ7UfVeR2Hcc2KI9oZB1qthmZ1+PZyGZ/Dy+z+zklC0xl
 XIpQPmnfy9+/1hj1LzJ+pe3HzEodtlVA+rdttSvA6nmHKIt8Ul6b/h1DFTmUT1lN1WbAGxmg
 CH1O26cz5nTrzdjoqC/b8PpZiT0kO5MKKgiu5S4PRIxW2+RA4H9nq7nztNZ1Y39bDpzwE5Sp
 bDHzd5owmLxMLZAINtCtQuRbSOcMjZlg4zohA9TQP9krGIk+qTR+H4CV22sWldSkVtsoTaA2
 qNeSJhfHQY0TyQvFbqRsSNIe2gTDzzEQ8itsmdHHE/yzhcCVvlUzXhAT6pIN0OT+cdsTTfif
 MIcDboys92auTuJ7U+4jWF1+WUaJ8gDL69ThAsu7mGDBbm80P3vvUZ4fQM14NkxOnuGRrJxO
 qjWNJ2ZUxgyHAh5TCxMLKWZoL5hpnvx3dF3Ti9HW2dsUUWICSQARAQABtDJQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoUGhpbCkgPHBoaWxtZEByZWRoYXQuY29tPokCVQQTAQgAPwIbDwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQSJweePYB7obIZ0lcuio/1u3q3A3gUCXsfWwAUJ
 KtymWgAKCRCio/1u3q3A3ircD/9Vjh3aFNJ3uF3hddeoFg1H038wZr/xi8/rX27M1Vj2j9VH
 0B8Olp4KUQw/hyO6kUxqkoojmzRpmzvlpZ0cUiZJo2bQIWnvScyHxFCv33kHe+YEIqoJlaQc
 JfKYlbCoubz+02E2A6bFD9+BvCY0LBbEj5POwyKGiDMjHKCGuzSuDRbCn0Mz4kCa7nFMF5Jv
 piC+JemRdiBd6102ThqgIsyGEBXuf1sy0QIVyXgaqr9O2b/0VoXpQId7yY7OJuYYxs7kQoXI
 6WzSMpmuXGkmfxOgbc/L6YbzB0JOriX0iRClxu4dEUg8Bs2pNnr6huY2Ft+qb41RzCJvvMyu
 gS32LfN0bTZ6Qm2A8ayMtUQgnwZDSO23OKgQWZVglGliY3ezHZ6lVwC24Vjkmq/2yBSLakZE
 6DZUjZzCW1nvtRK05ebyK6tofRsx8xB8pL/kcBb9nCuh70aLR+5cmE41X4O+MVJbwfP5s/RW
 9BFSL3qgXuXso/3XuWTQjJJGgKhB6xXjMmb1J4q/h5IuVV4juv1Fem9sfmyrh+Wi5V1IzKI7
 RPJ3KVb937eBgSENk53P0gUorwzUcO+ASEo3Z1cBKkJSPigDbeEjVfXQMzNt0oDRzpQqH2vp
 apo2jHnidWt8BsckuWZpxcZ9+/9obQ55DyVQHGiTN39hkETy3Emdnz1JVHTU0Q==
Message-ID: <eace8e92-febd-ded9-9f2f-b90f574b1510@redhat.com>
Date:   Thu, 30 Jul 2020 16:11:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200730135935.23968-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/30/20 3:59 PM, Philippe Mathieu-Daudé wrote:
> We use different types to hold 'qemu_real_host_page_size'.
> Unify picking 'size_t' which seems the best candidate.
> 
> Doing so fix a format string issue in hw/virtio/virtio-mem.c
> reported when building with GCC 4.9.4:
> 
>   hw/virtio/virtio-mem.c: In function ‘virtio_mem_set_block_size’:
>   hw/virtio/virtio-mem.c:756:9: error: format ‘%x’ expects argument of type ‘unsigned int’, but argument 7 has type ‘uintptr_t’ [-Werror=format=]
>          error_setg(errp, "'%s' property has to be at least 0x%" PRIx32, name,
>          ^
> 
> Fixes: 910b25766b ("virtio-mem: Paravirtualized memory hot(un)plug")
> Reported-by: Bruce Rogers <brogers@suse.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  include/exec/ram_addr.h  | 4 ++--
>  include/qemu/osdep.h     | 2 +-
>  accel/kvm/kvm-all.c      | 3 ++-
>  block/qcow2-cache.c      | 2 +-
>  exec.c                   | 8 ++++----
>  hw/ppc/spapr_pci.c       | 2 +-
>  hw/virtio/virtio-mem.c   | 2 +-
>  migration/migration.c    | 2 +-
>  migration/postcopy-ram.c | 2 +-
>  monitor/misc.c           | 2 +-
>  util/pagesize.c          | 2 +-
>  11 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
> index 3ef729a23c..e07532266e 100644
> --- a/include/exec/ram_addr.h
> +++ b/include/exec/ram_addr.h
> @@ -93,8 +93,8 @@ static inline unsigned long int ramblock_recv_bitmap_offset(void *host_addr,
>  
>  bool ramblock_is_pmem(RAMBlock *rb);
>  
> -long qemu_minrampagesize(void);
> -long qemu_maxrampagesize(void);
> +size_t qemu_minrampagesize(void);
> +size_t qemu_maxrampagesize(void);
>  
>  /**
>   * qemu_ram_alloc_from_file,
> diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
> index 20872e793e..619b8a7a8c 100644
> --- a/include/qemu/osdep.h
> +++ b/include/qemu/osdep.h
> @@ -635,10 +635,10 @@ char *qemu_get_pid_name(pid_t pid);
>   */
>  pid_t qemu_fork(Error **errp);
>  
> +extern size_t qemu_real_host_page_size;
>  /* Using intptr_t ensures that qemu_*_page_mask is sign-extended even
>   * when intptr_t is 32-bit and we are aligning a long long.
>   */
> -extern uintptr_t qemu_real_host_page_size;
>  extern intptr_t qemu_real_host_page_mask;
>  

This is incomplete as I missed to make QEMU_VMALLOC_ALIGN unsigned...

I'll respin.

