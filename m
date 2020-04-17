Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC17C1ADE16
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 15:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbgDQNPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 09:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729760AbgDQNPp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 09:15:45 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3924C061A0C
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 06:15:45 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id i22so1342627otp.12
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 06:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TboapKpbscmz855YSAFg2nIeGN97zkquFhVh21atq0U=;
        b=aNmEuET4pqkT1KkeKmgk6Cq9vBqgNu/ROxL2C7ezmo+e7TvlW/pt7eEDU2mGbKJOYa
         pd2IUEcQqcu4qx19uoBru9MI0rbUtrwjwrkXUi0Ao+bT9k5etlzBouSiftkQ6eyDLiCI
         kfDwLc5+qmzQPd+i133nQVievrA8CLz5BR0nFhlw01DpsQ3cus95k3U8AP+INw0F7ats
         tpVmUE1/T6IyhGtSyuHv5532KsG61E7Qyxpy4pOswNmwijgv3AE0FsuSUsoUL7C0gaet
         qpwFeJgOjQ532CXC3K6ADBOAEqxmh0qPU9rKOp7PwwVEFLHUzPx1/4TIDAXx3R/9a3pW
         GHjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TboapKpbscmz855YSAFg2nIeGN97zkquFhVh21atq0U=;
        b=Wdokz2IvGYwg94oZoMcBHhqzHoXlkLswd1khTWT12McOzgMwSDY15xo6oT87M9+dfj
         nqHJVHLwjr34n5wysV5yofI6SrigL6enWWtuuHZiJ4l+KtHwd4rNfXVUZesJ9wodr69K
         WW/HyHh5rWPeMo/xPO62XiYffUwyOj4Mu3wB89B74RmvaAP4QZvqzpLsfyu3YQTKRycc
         BEzhfhTrOl8cAX2VYPhwzqbZE9KbygOMLl8Ai+9oW7Micx/8tG57RobJqSy0wJqxSFHl
         HuxkxYTfLAZku9XhReajTOmKHMU/HGejV9HGh4600l+jTSb82BvMK6JFv1adgwIYKp6z
         l79w==
X-Gm-Message-State: AGi0PuZjCUqKoVl7hIOjvfUV3ZpJGDW849qfVGMnZcsYYCfWH2rBKOV/
        Y/r81H79oJyJf8pUhwyn3RNfOb615xwiJ5r9gc/wgA==
X-Google-Smtp-Source: APiQypJVaXiKK+fekesrRmbkfJcK99mF8Dr0rTE3xJsFEyEaAUaA62DI5BSqDrUkQBtY4+41nUKVJE9aSQIFgr7kBl8=
X-Received: by 2002:a05:6830:1e4e:: with SMTP id e14mr2432927otj.91.1587129345185;
 Fri, 17 Apr 2020 06:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200410114639.32844-1-gengdongjiu@huawei.com> <20200410114639.32844-2-gengdongjiu@huawei.com>
In-Reply-To: <20200410114639.32844-2-gengdongjiu@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 17 Apr 2020 14:15:33 +0100
Message-ID: <CAFEAcA_vqtFuoaLhczs-5ZXyjBWH4j4rF+5SUHMxVt_qTLyR5Q@mail.gmail.com>
Subject: Re: [PATCH v25 01/10] acpi: nvdimm: change NVDIMM_UUID_LE to a common macro
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Fam Zheng <fam@euphon.net>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zheng Xiang <zhengxiang9@huawei.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Apr 2020 at 12:45, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>
> The little end UUID is used in many places, so make
> NVDIMM_UUID_LE to a common macro to convert the UUID
> to a little end array.
>
> Reviewed-by: Xiang Zheng <zhengxiang9@huawei.com>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> ---
>  hw/acpi/nvdimm.c    | 10 +++-------
>  include/qemu/uuid.h |  9 +++++++++
>  2 files changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/hw/acpi/nvdimm.c b/hw/acpi/nvdimm.c
> index eb6a37b..a747c63 100644
> --- a/hw/acpi/nvdimm.c
> +++ b/hw/acpi/nvdimm.c
> @@ -27,6 +27,7 @@
>   */
>
>  #include "qemu/osdep.h"
> +#include "qemu/uuid.h"
>  #include "hw/acpi/acpi.h"
>  #include "hw/acpi/aml-build.h"
>  #include "hw/acpi/bios-linker-loader.h"
> @@ -34,18 +35,13 @@
>  #include "hw/mem/nvdimm.h"
>  #include "qemu/nvdimm-utils.h"
>
> -#define NVDIMM_UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)             \
> -   { (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
> -     (b) & 0xff, ((b) >> 8) & 0xff, (c) & 0xff, ((c) >> 8) & 0xff,          \
> -     (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }
> -
>  /*
>   * define Byte Addressable Persistent Memory (PM) Region according to
>   * ACPI 6.0: 5.2.25.1 System Physical Address Range Structure.
>   */
>  static const uint8_t nvdimm_nfit_spa_uuid[] =
> -      NVDIMM_UUID_LE(0x66f0d379, 0xb4f3, 0x4074, 0xac, 0x43, 0x0d, 0x33,
> -                     0x18, 0xb7, 0x8c, 0xdb);
> +      UUID_LE(0x66f0d379, 0xb4f3, 0x4074, 0xac, 0x43, 0x0d, 0x33,
> +              0x18, 0xb7, 0x8c, 0xdb);
>
>  /*
>   * NVDIMM Firmware Interface Table
> diff --git a/include/qemu/uuid.h b/include/qemu/uuid.h
> index 129c45f..c55541b 100644
> --- a/include/qemu/uuid.h
> +++ b/include/qemu/uuid.h
> @@ -34,6 +34,15 @@ typedef struct {
>      };
>  } QemuUUID;
>
> +/**
> + * convert UUID to little-endian array
> + * The input parameter is the member of  UUID
> + */

This isn't in the right form to be a proper doc-comment comment,
and it's too brief to really help somebody who doesn't already
know what the macro does.

The parameter names to the macro are still terrible, and
"member of UUID" doesn't help -- assuming you mean "members
of the QemuUUID struct, those are named 'time_low' , 'time_mid',
and so on, not this random selection of alphabetic and d0..d7.

> +#define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)             \
> +  { (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
> +     (b) & 0xff, ((b) >> 8) & 0xff, (c) & 0xff, ((c) >> 8) & 0xff,          \
> +     (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }
> +
>  #define UUID_FMT "%02hhx%02hhx%02hhx%02hhx-" \
>                   "%02hhx%02hhx-%02hhx%02hhx-" \
>                   "%02hhx%02hhx-" \
> --
> 1.8.3.1

thanks
-- PMM
