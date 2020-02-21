Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5530F167FA0
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 15:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgBUOHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 09:07:46 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45658 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgBUOHp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 09:07:45 -0500
Received: by mail-oi1-f193.google.com with SMTP id v19so1641181oic.12
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 06:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jRrCY8ivewk2YPDDhcTANhN06ruxAxSf+AS7eQGMH4k=;
        b=wTnUuK2EkkmDJZpLj4tmgHEqKVPhULq+9DKBHUK9iU38rUMNmOc/I4zk9rDHhxEFuq
         O/1uQiBW33+L9XDt7L+lOx+RfvBiKxJteC/df5Ub/RpCDiUgBoI9htfYdyQsRX3nA0pO
         IhTWX3XyCBr+PFR5vOzZJT1aH96Vty28jyER/5U5p9W0xUCr9udL/jjr6F8hmNXVfnYQ
         +gZPfYOkd77DeI9TVzjuCqDwF7nAPjYnDNnycJM7hDII9KRT4tx9hNKZ3JvIP9DQAM4E
         FhCu1om59A5iQYmeHYP4ZYQVF58PY7JpQlCv+fFLWIJvQi3ObOsitNgfTf51YPOUz1XP
         qcjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jRrCY8ivewk2YPDDhcTANhN06ruxAxSf+AS7eQGMH4k=;
        b=P4bvzlcqS8bb8b9wQuSbbEOFvtHIRetZINnfyzcP332wCeBDmDYFe9guIBOto7qVs4
         uo9V6dllkR+ZYetQRTKOaM97fEdCUsVxTG+AK/kXdmskpBKGnL4k6AEks5123VvMK+D0
         Mjga7Tne9qEHXShh2qh+rBTXB9iZRyzCbiBZYgA7PYcaAvqED5VKBYeSZZjSfJBI5G0W
         zwExoQ+sLKEHOOHwioob2MTezMS2Fx9eQKnSpSM3quL8fSQ9oNNUmsw1kawqXIB1rwT6
         5DYUaWW7YcH5Ie6peQvXgTJk7o++J3HabcqTabjEXJ+amQ3WAHoIACH3Q0CNUc1hGViS
         +6Ng==
X-Gm-Message-State: APjAAAXB6SuYIDsS9JfjYrbAgqPf7Gt5mAE7srYZuUFt8+ktBOr304xS
        V8nfntf8pUVuRo3MNMN38V2F2ZPz/WixTPMXjAsX9w==
X-Google-Smtp-Source: APXvYqwjXmjS0kIXrAdxCSwzyqX9j8aeVXh4lRUHp81kHrvWmlE7IV/sUVn+HHmyAzzQD2/6b57aeS2rRsDlIs/+2YA=
X-Received: by 2002:aca:b2c5:: with SMTP id b188mr2127351oif.163.1582294064908;
 Fri, 21 Feb 2020 06:07:44 -0800 (PST)
MIME-Version: 1.0
References: <20200217131248.28273-1-gengdongjiu@huawei.com> <20200217131248.28273-2-gengdongjiu@huawei.com>
In-Reply-To: <20200217131248.28273-2-gengdongjiu@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 21 Feb 2020 14:07:34 +0000
Message-ID: <CAFEAcA_smgw3cg=jqh_xRU1N+mYB1B6qR75EP14SNgZ4aa0zxg@mail.gmail.com>
Subject: Re: [PATCH v24 01/10] acpi: nvdimm: change NVDIMM_UUID_LE to a common macro
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Fam Zheng <fam@euphon.net>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Zheng Xiang <zhengxiang9@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Feb 2020 at 13:10, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>
> The little end UUID is used in many places, so make
> NVDIMM_UUID_LE to a common macro to convert the UUID
> to a little end array.
>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Reviewed-by: Xiang Zheng <zhengxiang9@huawei.com>
> ---
>  hw/acpi/nvdimm.c    | 8 ++------
>  include/qemu/uuid.h | 5 +++++
>  2 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/hw/acpi/nvdimm.c b/hw/acpi/nvdimm.c
> index 9fdad6d..232b701 100644
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
> @@ -60,17 +61,12 @@ static GSList *nvdimm_get_device_list(void)
>      return list;
>  }
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
> +      UUID_LE(0x66f0d379, 0xb4f3, 0x4074, 0xac, 0x43, 0x0d, 0x33,
>                       0x18, 0xb7, 0x8c, 0xdb);

You need to fix up the indentation on this following line.

>
>  /*
> diff --git a/include/qemu/uuid.h b/include/qemu/uuid.h
> index 129c45f..bd38af5 100644
> --- a/include/qemu/uuid.h
> +++ b/include/qemu/uuid.h
> @@ -34,6 +34,11 @@ typedef struct {
>      };
>  } QemuUUID;
>
> +#define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)             \
> +  { (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
> +     (b) & 0xff, ((b) >> 8) & 0xff, (c) & 0xff, ((c) >> 8) & 0xff,          \
> +     (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }
> +

If you want to make this a macro in a visible-to-the-rest-of-QEMU
header file, can you provide a documentation comment please that
describes what the macro is for? It would also be useful to
give the arguments (which should be documented in the doc comment)
more descriptive names than a, b, c...

>  #define UUID_FMT "%02hhx%02hhx%02hhx%02hhx-" \
>                   "%02hhx%02hhx-%02hhx%02hhx-" \
>                   "%02hhx%02hhx-" \
> --
> 1.8.3.1


thanks
-- PMM
