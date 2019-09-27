Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4118BC0633
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 15:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfI0NTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 09:19:45 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36506 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfI0NTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 09:19:45 -0400
Received: by mail-oi1-f194.google.com with SMTP id k20so5169658oih.3
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 06:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kau7tqDv4N5BfV3Vw5Rek2SevsQVcXfTdIXf3HFT2yo=;
        b=cCX1WO/bNqbsVLei5AA6tys+J9PQMz1GCTn1ofd38X9yeB/fkI6TGDTPGAovh1gxGJ
         zIGgaNSH3KW4LZLhHdSL7SW3IkKPLQQsZ9cI6spH+4/CRcYEGOykEIJT8bShZ+GDlW4o
         b0kEQDvOms3LGJDEgJHj+O8DyaMzVBc1S9zGk9ZPfwSYtL9s50mUBfR4VRQKmM4DFHST
         vFgJYE7O3m4pTQWNgqexAgCt6S4epYt3IsrczSUcQ8ZKZKa+sb4j+dTClfYstJyKBJSx
         CtJw7FsCAuzm+ipAFreRZqtIRDMxlbBHuiZe58JntnoPNM+gS3QfEkbKM19+iDlMj/P1
         M3NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kau7tqDv4N5BfV3Vw5Rek2SevsQVcXfTdIXf3HFT2yo=;
        b=AdELT6bWd3HkdeyGvHEZe4JF3KCiMfNg9kT6sNMqaIHeVbZnXea6STlWVYFJwjKXlG
         p3VZs7hsHh5XfZS3pfqMfEWHmb/4WD/YgBQtp3ZASjlm9Z4X4PmA6YYGXbu8188TZsEG
         loWIwOl5BhSn0gpoqaNTXumaSns6Pjc1Qk2MsT2/Y4YWHOznggBt5VXMmLkspFUDraTY
         bYLz2NGUU10cFtAIC0Kx/2n2ZMA8GX5yltI9Lagqpvj71gWq8l7WLvE+e6qAtu+4HtJz
         k6jpWZ6gzxBhC6V2tQleGz0N+QedVXfijANs+PThCtLROg6Prme9ia0383inwLwHcFpm
         ZNPg==
X-Gm-Message-State: APjAAAXNZXNk16kpvq/8x1ihvvm183gICD20corbSLlJY0EOuuZFeALo
        pI2uMKRT1B4ClsVRmumu0yQERZkGn9acPChlyYHHcw==
X-Google-Smtp-Source: APXvYqzXs1mVapIpMEL6Y2Ngi/4ZduF5Yd6EaPkjfeAoYTmuJS+fshgQqDDsgxIcpLAb2p6CPEx1T1EC892RovR100c=
X-Received: by 2002:aca:f54d:: with SMTP id t74mr7264630oih.170.1569590383304;
 Fri, 27 Sep 2019 06:19:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190906083152.25716-1-zhengxiang9@huawei.com> <20190906083152.25716-5-zhengxiang9@huawei.com>
In-Reply-To: <20190906083152.25716-5-zhengxiang9@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 27 Sep 2019 14:19:32 +0100
Message-ID: <CAFEAcA_o6NkOGptWFOoVt4pUgHU+dNyWQ9h_VfNweR17CtHSnw@mail.gmail.com>
Subject: Re: [Qemu-arm] [PATCH v18 4/6] KVM: Move hwpoison page related
 functions into include/sysemu/kvm_int.h
To:     Xiang Zheng <zhengxiang9@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Morse <james.morse@arm.com>,
        gengdongjiu <gengdongjiu@huawei.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>, kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, Linuxarm <linuxarm@huawei.com>,
        wanghaibin.wang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Sep 2019 at 09:33, Xiang Zheng <zhengxiang9@huawei.com> wrote:
>
> From: Dongjiu Geng <gengdongjiu@huawei.com>
>
> kvm_hwpoison_page_add() and kvm_unpoison_all() will both be used by X86
> and ARM platforms, so moving them into "include/sysemu/kvm_int.h" to
> avoid duplicate code.
>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> ---
>  accel/kvm/kvm-all.c      | 33 +++++++++++++++++++++++++++++++++
>  include/sysemu/kvm_int.h | 23 +++++++++++++++++++++++
>  target/arm/kvm.c         |  3 +++
>  target/i386/kvm.c        | 34 ----------------------------------
>  4 files changed, 59 insertions(+), 34 deletions(-)

>  static uint32_t adjust_ioeventfd_endianness(uint32_t val, uint32_t size)
>  {
>  #if defined(HOST_WORDS_BIGENDIAN) != defined(TARGET_WORDS_BIGENDIAN)
> diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
> index 72b2d1b3ae..3ad49f9a28 100644
> --- a/include/sysemu/kvm_int.h
> +++ b/include/sysemu/kvm_int.h
> @@ -41,4 +41,27 @@ typedef struct KVMMemoryListener {
>  void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
>                                    AddressSpace *as, int as_id);
>
> +/**
> + * kvm_hwpoison_page_add:
> + *
> + * Parameters:
> + *  @ram_addr: the address in the RAM for the poisoned page
> + *
> + * Add a poisoned page to the list
> + *
> + * Return: None.
> + */
> +void kvm_hwpoison_page_add(ram_addr_t ram_addr);
> +
> +/**
> + * kvm_unpoison_all:
> + *
> + * Parameters:
> + *  @param: some data may be passed to this function
> + *
> + * Free and remove all the poisoned pages in the list
> + *
> + * Return: None.
> + */
> +void kvm_unpoison_all(void *param);
>  #endif
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index b2eaa50b8d..3a110be7b8 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -20,6 +20,7 @@
>  #include "sysemu/sysemu.h"
>  #include "sysemu/kvm.h"
>  #include "sysemu/kvm_int.h"
> +#include "sysemu/reset.h"
>  #include "kvm_arm.h"
>  #include "cpu.h"
>  #include "trace.h"
> @@ -195,6 +196,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>
>      cap_has_mp_state = kvm_check_extension(s, KVM_CAP_MP_STATE);
>
> +    qemu_register_reset(kvm_unpoison_all, NULL);
> +

Rather than registering the same reset handler in
all the architectures, we could register it in the
generic kvm_init() function. (For architectures that
don't use the poison-list functionality the reset handler
will harmlessly do nothing, because there will be nothing
in the list.)

This would allow you to not have to make the
kvm_unpoison_all() function global -- it can be static
in accel/tcg/kvm-all.c.

>      return 0;
>  }

thanks
-- PMM
