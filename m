Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7749C13E091
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 17:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgAPQoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 11:44:12 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:46186 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729261AbgAPQoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 11:44:11 -0500
Received: by mail-oi1-f193.google.com with SMTP id 13so19395241oij.13
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 08:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nbt9ZpWqqdD6vIQRKy1qyLMQca6b/HxDSA+FsokmcTw=;
        b=Ze19MaB/y1XsL4yRJAYS7+aOJ29PUXv+3+2hmEqRDnag03+g1ye3cgUk7xQcL0z7Pf
         TlNX68znKCEYKCfow5hxU6VaTzw1i6KdPA/nB9h2H2P8z8BO0CncLNsMvxjdPU8QI0Cu
         AWKu15pI+kuTXZKA9AJtmfk6xPJIOrxvOsMA+ATDNwHDvqT8BxqsAN1uo0ANE/q6gWzY
         ANkjYzCzeq7V/JsFD8tay9ko/THXZO6gxV8rxKD4BZ1Jp+dISbjr1Sn9LfpfCZK3E1Pu
         7gXzmonJl+xa8QW281fmbxr9EhWik8NrHPvDiIkmm8AxdxGUfP6Ffg2qpDOtLbCI5RO0
         Ii5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nbt9ZpWqqdD6vIQRKy1qyLMQca6b/HxDSA+FsokmcTw=;
        b=U4Ztko0DbEboqIE3yllaM/K8k0iurpzpTA+EmDkhHxmOFukzGfMhVYLXwCMXeA5kT1
         ZaWgWaDoA8KLwxCJNpFg5DpSTTvqRl96MO9WRxCCRzZ/gTWGBK6AeuGoXR2Bi3V8gJfy
         0ZbwtaAOtXG2YseeDt0Es93XZDheW7ejPzkLsK1aBwXuQeSDFdAvY3wIcxU7TccZiqrP
         nDwzAXp9jkxnUHa70aTKy6Chvz4awPgCq42gCytHFXy8BEFzmumvJEHHEzNCO9gDLgRC
         9lQ2f6Bey0I7MTDpUmbRRGVVUnxmCjUHcb6wLjIsdXCYe32qaZGMfGHhU0NvhHghIEiv
         653w==
X-Gm-Message-State: APjAAAXf68s2xcnfJf4NFK2SbLL4EXTO8AZ0OI3MjOS+4AAflWXH96yE
        wsUgJUQq2qfEyNLIXfnScdL48lLcvZk2EbSc5piINg==
X-Google-Smtp-Source: APXvYqy2Ea0ZSpaXvRx0kSDWa4cAPhZR203J8lHCxJ4EET5zN+o2QBNrDh+pFMTnItNoG/JnqzuXjV62Cr3+/XULQqo=
X-Received: by 2002:aca:d78b:: with SMTP id o133mr4860165oig.163.1579193051335;
 Thu, 16 Jan 2020 08:44:11 -0800 (PST)
MIME-Version: 1.0
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com> <1578483143-14905-6-git-send-email-gengdongjiu@huawei.com>
In-Reply-To: <1578483143-14905-6-git-send-email-gengdongjiu@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 16 Jan 2020 16:44:00 +0000
Message-ID: <CAFEAcA9z9KDHmvh6WsrCPj_FTvNmOfhatxNQDftNG+ZKZN0wAA@mail.gmail.com>
Subject: Re: [PATCH v22 5/9] ACPI: Record the Generic Error Status Block address
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Fam Zheng <fam@euphon.net>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "xuwei (O)" <xuwei5@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        James Morse <james.morse@arm.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>,
        Zheng Xiang <zhengxiang9@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Jan 2020 at 11:33, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>
> Record the GHEB address via fw_cfg file, when recording
> a error to CPER, it will use this address to find out
> Generic Error Data Entries and write the error.
>
> Make the HEST GHES to a GED device.
>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> ---
>  hw/acpi/generic_event_device.c         | 15 ++++++++++++++-
>  hw/acpi/ghes.c                         | 16 ++++++++++++++++
>  hw/arm/virt-acpi-build.c               | 13 ++++++++++++-
>  include/hw/acpi/generic_event_device.h |  2 ++
>  include/hw/acpi/ghes.h                 |  6 ++++++
>  5 files changed, 50 insertions(+), 2 deletions(-)
>
> diff --git a/hw/acpi/generic_event_device.c b/hw/acpi/generic_event_device.c
> index 9cee90c..9bf37e4 100644
> --- a/hw/acpi/generic_event_device.c
> +++ b/hw/acpi/generic_event_device.c
> @@ -234,12 +234,25 @@ static const VMStateDescription vmstate_ged_state = {
>      }
>  };
>
> +static const VMStateDescription vmstate_ghes_state = {
> +    .name = "acpi-ghes-state",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .fields      = (VMStateField[]) {
> +        VMSTATE_UINT64(ghes_addr_le, AcpiGhesState),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
>  static const VMStateDescription vmstate_acpi_ged = {
>      .name = "acpi-ged",
>      .version_id = 1,
>      .minimum_version_id = 1,
>      .fields = (VMStateField[]) {
> -        VMSTATE_STRUCT(ged_state, AcpiGedState, 1, vmstate_ged_state, GEDState),
> +        VMSTATE_STRUCT(ged_state, AcpiGedState, 1,
> +                       vmstate_ged_state, GEDState),
> +        VMSTATE_STRUCT(ghes_state, AcpiGedState, 1,
> +                       vmstate_ghes_state, AcpiGhesState),
>          VMSTATE_END_OF_LIST(),
>      },
>      .subsections = (const VMStateDescription * []) {

You can't just add fields to an existing VMStateDescription
like this -- it will break migration compatibility. Instead you
need to add a new subsection to this vmstate, with a '.needed'
function which indicates when the subsection should be present.

thanks
-- PMM
