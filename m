Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130A61CD9DB
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 14:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgEKM3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 08:29:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24812 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729912AbgEKM3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 08:29:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589200176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L8L4dH79F/shaoDlU4MtTMVVRmb5egfDfK9KucJ74l8=;
        b=huSvlD/4V8ymdevWIYQxB6GpqBtcZbPNX5LSmWSo3UwqQp/l1xaYAXybWy1J/B3a2w3jft
        sR0UIdPsJzEwSdrFTZqLC2Jr9CDHT57qfIL+pdABTcB7AZqP17IHnR2dpAo9t6/VF4Dkva
        cDK0cRpiOHrU7LbtVRaNlA9tDDbFmAA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-3S5S_ZHHNHyUO1Z-WA_w4A-1; Mon, 11 May 2020 08:29:34 -0400
X-MC-Unique: 3S5S_ZHHNHyUO1Z-WA_w4A-1
Received: by mail-wr1-f69.google.com with SMTP id 90so5111512wrg.23
        for <kvm@vger.kernel.org>; Mon, 11 May 2020 05:29:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L8L4dH79F/shaoDlU4MtTMVVRmb5egfDfK9KucJ74l8=;
        b=XDsPnoHO5L4fMwckIQZxKK+0YPYeJ8kfGNmpTI4I30aOcJp7lWYWX+9GyLv7/TSFYc
         fKUjEH46rmwtStaui3AQKS4nfbLgJzGz2jUKCvnA42STr9brrw7KH7q8vkO+AFH44jPC
         FC82gX1iZlD31+OyGL1OCzOik8cC/jcdgIS+mcVUf02hEc0uhb17V8sFd3kDCqL98kUh
         TbIbrdKh8bYsIoY6WaXIaIHbxyvBfHsSZcWnc+RbkO4l/4UXtMr28Ly8tc+B/VNi3Lmh
         GqR2othFXAy6W+bGK3hbCqxlOkasc6a1noqCZd4u5+iq5oe6Xiur2KOEPdgmv22y1vbN
         NqIg==
X-Gm-Message-State: AGi0PuZPqcIyt/v5qE4IbfVu/5RQFCG7vvtqcTK651U0pRzRFXjDWYL1
        aozlgTJUPFZ3Y04kIXuDH1WqSGpE9u8hF5n0cgJ+MyuiVvO7P2m+ctrgWuLgSljRosR/u92Rcau
        hHFX5S2QBp48r
X-Received: by 2002:a5d:6b90:: with SMTP id n16mr439010wrx.220.1589200173501;
        Mon, 11 May 2020 05:29:33 -0700 (PDT)
X-Google-Smtp-Source: APiQypKcKEiOnqfAsZMxICoK31AGYiX38a3/H8tq8UPmIBsMSzRauMwJT4miSZdGi0Vew+lO78Z9xw==
X-Received: by 2002:a5d:6b90:: with SMTP id n16mr438995wrx.220.1589200173317;
        Mon, 11 May 2020 05:29:33 -0700 (PDT)
Received: from [192.168.1.38] (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id q17sm9650822wmk.36.2020.05.11.05.29.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 05:29:32 -0700 (PDT)
Subject: Re: [PATCH v26 01/10] acpi: nvdimm: change NVDIMM_UUID_LE to a common
 macro
To:     Dongjiu Geng <gengdongjiu@huawei.com>, imammedo@redhat.com,
        mst@redhat.com, xiaoguangrong.eric@gmail.com,
        peter.maydell@linaro.org, shannon.zhaosl@gmail.com,
        pbonzini@redhat.com, fam@euphon.net, rth@twiddle.net,
        ehabkost@redhat.com, mtosatti@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, qemu-arm@nongnu.org
Cc:     zhengxiang9@huawei.com, Jonathan.Cameron@huawei.com,
        linuxarm@huawei.com
References: <20200507134205.7559-1-gengdongjiu@huawei.com>
 <20200507134205.7559-2-gengdongjiu@huawei.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <4f29e19c-cb37-05e6-0ae3-c019370e090b@redhat.com>
Date:   Mon, 11 May 2020 14:29:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200507134205.7559-2-gengdongjiu@huawei.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/7/20 3:41 PM, Dongjiu Geng wrote:
> The little end UUID is used in many places, so make
> NVDIMM_UUID_LE to a common macro to convert the UUID
> to a little end array.
> 
> Reviewed-by: Xiang Zheng <zhengxiang9@huawei.com>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> ---
> Change since v25:
> 1. Address Peter's comments to add a proper doc-comment comment for
>     UUID_LE macros.
> ---
>   hw/acpi/nvdimm.c    | 10 +++-------
>   include/qemu/uuid.h | 26 ++++++++++++++++++++++++++
>   slirp               |  2 +-
>   3 files changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/hw/acpi/nvdimm.c b/hw/acpi/nvdimm.c
> index fa7bf8b..9316d12 100644
> --- a/hw/acpi/nvdimm.c
> +++ b/hw/acpi/nvdimm.c
> @@ -27,6 +27,7 @@
>    */
>   
>   #include "qemu/osdep.h"
> +#include "qemu/uuid.h"
>   #include "hw/acpi/acpi.h"
>   #include "hw/acpi/aml-build.h"
>   #include "hw/acpi/bios-linker-loader.h"
> @@ -34,18 +35,13 @@
>   #include "hw/mem/nvdimm.h"
>   #include "qemu/nvdimm-utils.h"
>   
> -#define NVDIMM_UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)             \
> -   { (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
> -     (b) & 0xff, ((b) >> 8) & 0xff, (c) & 0xff, ((c) >> 8) & 0xff,          \
> -     (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }
> -
>   /*
>    * define Byte Addressable Persistent Memory (PM) Region according to
>    * ACPI 6.0: 5.2.25.1 System Physical Address Range Structure.
>    */
>   static const uint8_t nvdimm_nfit_spa_uuid[] =
> -      NVDIMM_UUID_LE(0x66f0d379, 0xb4f3, 0x4074, 0xac, 0x43, 0x0d, 0x33,
> -                     0x18, 0xb7, 0x8c, 0xdb);
> +      UUID_LE(0x66f0d379, 0xb4f3, 0x4074, 0xac, 0x43, 0x0d, 0x33,
> +              0x18, 0xb7, 0x8c, 0xdb);
>   
>   /*
>    * NVDIMM Firmware Interface Table
> diff --git a/include/qemu/uuid.h b/include/qemu/uuid.h
> index 129c45f..2d17a90 100644
> --- a/include/qemu/uuid.h
> +++ b/include/qemu/uuid.h
> @@ -34,6 +34,32 @@ typedef struct {
>       };
>   } QemuUUID;
>   
> +/**
> + * @time_low: The low field of the timestamp
> + * @time_mid: The middle field of the timestamp
> + * @time_hi_and_version: The high field of the timestamp
> + *                       multiplexed with the version number
> + * @clock_seq_hi_and_reserved: The high field of the clock
> + *                             sequence multiplexed with the variant
> + * @clock_seq_low: The low field of the clock sequence
> + * @node0: The spatially unique node0 identifier
> + * @node1: The spatially unique node1 identifier
> + * @node2: The spatially unique node2 identifier
> + * @node3: The spatially unique node3 identifier
> + * @node4: The spatially unique node4 identifier
> + * @node5: The spatially unique node5 identifier
> + *
> + * This macro converts the fields of UUID to little-endian array
> + */
> +#define UUID_LE(time_low, time_mid, time_hi_and_version, \
> +  clock_seq_hi_and_reserved, clock_seq_low, node0, node1, node2, \
> +  node3, node4, node5) \
> +  { (time_low) & 0xff, ((time_low) >> 8) & 0xff, ((time_low) >> 16) & 0xff, \
> +    ((time_low) >> 24) & 0xff, (time_mid) & 0xff, ((time_mid) >> 8) & 0xff, \
> +    (time_hi_and_version) & 0xff, ((time_hi_and_version) >> 8) & 0xff, \
> +    (clock_seq_hi_and_reserved), (clock_seq_low), (node0), (node1), (node2),\
> +    (node3), (node4), (node5) }
> +
>   #define UUID_FMT "%02hhx%02hhx%02hhx%02hhx-" \
>                    "%02hhx%02hhx-%02hhx%02hhx-" \
>                    "%02hhx%02hhx-" \
> diff --git a/slirp b/slirp
> index 2faae0f..55ab21c 160000
> --- a/slirp
> +++ b/slirp
> @@ -1 +1 @@
> -Subproject commit 2faae0f778f818fadc873308f983289df697eb93
> +Subproject commit 55ab21c9a36852915b81f1b41ebaf3b6509dd8ba

The SLiRP submodule change is certainly unrelated.

