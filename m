Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C35BC06E0
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 16:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfI0OCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 10:02:14 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:34686 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfI0OCO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 10:02:14 -0400
Received: by mail-oi1-f195.google.com with SMTP id 83so5297511oii.1
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 07:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JNdVUv0zNXaOfCb4Gice9wMOQgdLgAnNhUj5m0MnIEY=;
        b=nqHE+bAYeccazvFVv4LtPzdLNeAZIaYIXaJeBGsztk/vijCrzp/x4/pOciFBNgWWty
         srCZWTEAJBBNAJbLoeqzhSTC8Ysao60knw8aGhi7JKL0NonKmbNeDDYt9xlLfeYheH3W
         Ik+SxOBPsV+IASTgEq6dYZOg51EBiqjUIsWOy9zr37Rhb56dB/gMHLHDe0vTmT13vJJk
         pMYt5c2m+c6jlRfO03Ea7rZp6vWsX20ovbG4Ujd4tQGvtWaI5RqtuZTUCG0ta2rzAzUI
         XAeLYq+FYk7FbxUNu8ekRv5b8LBENW7U5YgNzNMaxtw6K9w8PA9wdWykZM3JjBoOvYz5
         rASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JNdVUv0zNXaOfCb4Gice9wMOQgdLgAnNhUj5m0MnIEY=;
        b=swM9tLsUQ0csRAv75uOWc7F24o/DE0kHUPtmqei1dQ6TQgPTWiVc2A09yaNylsJMC1
         pq6OkbPw8H0sGuce7aeRZjxPQA6A3pMFWHqE5hfTtk5+9/SfW0W3QtQ1c2a73AU9xaX5
         vmWAy5Bx9wXzrp+PWhG0uzB+r6djLQuIvT+ZPrmybg5waJICeXQKv7PAfMnOfCkYW3hG
         7B3/gwyBVhGSY6emklMZNvI1nQXt9rT0uYkmW/c0qtSPMrRNHT3A7cm03dEeg1hceYrC
         h/clUOCGFT5476jTplmW3Itr05jSbZvcSBWPm1V98vCClSqz4q1X2HCz3r70EKOjkr9U
         X9eg==
X-Gm-Message-State: APjAAAVcDgZVe6GuTpHooB3pbxrFE7qNe1FN7WIYisShJd+v3cJLo6kg
        hrGKIVZKYqimCcG9i25Ozf8laPW0SQBzaIgaWsLTfA==
X-Google-Smtp-Source: APXvYqwr6tN8GXFQ7CSFaOjf/oLfGBMHKVf8cyd/Pii9KiQZKSXzWNxCXSDpmv1EfcdURgP92oDDz5CwwTPlogBzkDA=
X-Received: by 2002:aca:b646:: with SMTP id g67mr7302016oif.163.1569592933016;
 Fri, 27 Sep 2019 07:02:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190906083152.25716-1-zhengxiang9@huawei.com> <20190906083152.25716-2-zhengxiang9@huawei.com>
In-Reply-To: <20190906083152.25716-2-zhengxiang9@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 27 Sep 2019 15:02:02 +0100
Message-ID: <CAFEAcA9cQwAJfPBC9fRcxLZVzZqag0Si62nTBNwDPyQiPVwPcg@mail.gmail.com>
Subject: Re: [PATCH v18 1/6] hw/arm/virt: Introduce RAS platform version and
 RAS machine option
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
> Support RAS Virtualization feature since version 4.2, disable it by
> default in the old versions. Also add a machine option which allows user
> to enable it explicitly.
>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> ---
>  hw/arm/virt.c         | 33 +++++++++++++++++++++++++++++++++
>  include/hw/arm/virt.h |  2 ++
>  2 files changed, 35 insertions(+)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index d74538b021..e0451433c8 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1783,6 +1783,20 @@ static void virt_set_its(Object *obj, bool value, Error **errp)
>      vms->its = value;
>  }
>
> +static bool virt_get_ras(Object *obj, Error **errp)
> +{
> +    VirtMachineState *vms = VIRT_MACHINE(obj);
> +
> +    return vms->ras;
> +}
> +
> +static void virt_set_ras(Object *obj, bool value, Error **errp)
> +{
> +    VirtMachineState *vms = VIRT_MACHINE(obj);
> +
> +    vms->ras = value;
> +}
> +
>  static char *virt_get_gic_version(Object *obj, Error **errp)
>  {
>      VirtMachineState *vms = VIRT_MACHINE(obj);
> @@ -2026,6 +2040,19 @@ static void virt_instance_init(Object *obj)
>                                      "Valid values are none and smmuv3",
>                                      NULL);
>
> +    if (vmc->no_ras) {
> +        vms->ras = false;
> +    } else {
> +        /* Default disallows RAS instantiation */
> +        vms->ras = false;
> +        object_property_add_bool(obj, "ras", virt_get_ras,
> +                                 virt_set_ras, NULL);
> +        object_property_set_description(obj, "ras",
> +                                        "Set on/off to enable/disable "
> +                                        "RAS instantiation",
> +                                        NULL);
> +    }

For a property which is disabled by default, you don't need
to have a separate flag in the VirtMachineClass struct.
Those are only needed for properties where we need the old machine
types to have the property be 'off' but new machine types
need to default to it be 'on'. Since vms->ras is false
by default anyway, you can just have this part:

> +        /* Default disallows RAS instantiation */
> +        vms->ras = false;
> +        object_property_add_bool(obj, "ras", virt_get_ras,
> +                                 virt_set_ras, NULL);
> +        object_property_set_description(obj, "ras",
> +                                        "Set on/off to enable/disable "
> +                                        "RAS instantiation",
> +                                        NULL);

Compare the 'vms->secure' flag and associated property
for an example of this.

>      vms->irqmap = a15irqmap;
>
>      virt_flash_create(vms);
> @@ -2058,8 +2085,14 @@ DEFINE_VIRT_MACHINE_AS_LATEST(4, 2)
>
>  static void virt_machine_4_1_options(MachineClass *mc)
>  {
> +    VirtMachineClass *vmc = VIRT_MACHINE_CLASS(OBJECT_CLASS(mc));
> +
>      virt_machine_4_2_options(mc);
>      compat_props_add(mc->compat_props, hw_compat_4_1, hw_compat_4_1_len);
> +    /* Disable memory recovery feature for 4.1 as RAS support was
> +     * introduced with 4.2.
> +     */
> +    vmc->no_ras = true;
>  }
>  DEFINE_VIRT_MACHINE(4, 1)

thanks
-- PMM
