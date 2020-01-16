Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDB113E0F3
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 17:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgAPQql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 11:46:41 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:34822 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729078AbgAPQqk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 11:46:40 -0500
Received: by mail-oi1-f193.google.com with SMTP id k4so19464495oik.2
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 08:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wxJhezyPbBA8aRyd5KsJxa8feriOk3RYl1VYt4xENS8=;
        b=sPboryS+Y1MX0Z77vZGatNjzHp3t0nXB9UjJ04h3Q7e37bVjWw8WeIDTigI78YP6Rw
         JR0W8JiMRf1BJov7xZH9ZRdZXHJcQMofX6DX7Nm0oHmtAXwI8BJG0qV6zveLrERCUMTd
         P/5eOAdosZYZ/K4u2yshpSueAaX3h1QtwCnWf/A7SrZOkYHn4sTcQlnrc7NF/jEICOhZ
         TOAagZ0tuKM4i1xIPyRH51xx3xUsHofWpTxQQrJtddgoJsS1Rb1HHGyQeZxLtTKrBlQU
         YO0fLCOfgIXm05581uWKd/s83c4Bbi8MTvsPinv5e9dWhVq8YOGBIp4x/Av/4NZ8wOGy
         tEQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wxJhezyPbBA8aRyd5KsJxa8feriOk3RYl1VYt4xENS8=;
        b=NpKGmhPut76PRR5ZJ5AaJKFmad8oJQZOVVxWgl5Id4lxHaZ9R4W1icmO5iUmRmIrE9
         ZWH+AVwLMe5dpVlRGf7EooZ/HOq90Q1ar9BChahDgy6oo/z3lFDpldaJCRKpoHJRTId1
         VDVZtjKMKzAE9RLiM+o9MwdBW57eFvdFWp1peAebp4Jt1px8rtwocMa4fvELZsmbpCVy
         vuZjxYG8kiutXaUlTXh9q3BUSvuZpdPtOUG2zNSyLZaur9+yGUXiMci21Jl1I38OOqRe
         PWPXcFIsMFZEuo9Xb9tUUFXIlKX1cPxwrcXYYCOAYgr2blwwtrZ5GisdnjvKn2VEAkQF
         0Eqw==
X-Gm-Message-State: APjAAAWi5SP80PxB8MVZlZc4L1kv4F4u7RhC62CdCLnONEzw6VzrQFZh
        P8t9qwVzLmPzrLl8kwvUxBJENYECDZlU6IJailIs7Q==
X-Google-Smtp-Source: APXvYqzuSJa2ft4QBFw8JQgFAeiMrfvJSe3POoFV1RWg4NU1w13QbrmXUN23jsB4YutJckZJ+XkLKg+TjG9q253LEjM=
X-Received: by 2002:aca:d78b:: with SMTP id o133mr4869620oig.163.1579193199671;
 Thu, 16 Jan 2020 08:46:39 -0800 (PST)
MIME-Version: 1.0
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com> <1578483143-14905-10-git-send-email-gengdongjiu@huawei.com>
In-Reply-To: <1578483143-14905-10-git-send-email-gengdongjiu@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 16 Jan 2020 16:46:28 +0000
Message-ID: <CAFEAcA-mLgD8rQ211ep44nd8oxTKSnxc7YmY+nPtADpKZk5asA@mail.gmail.com>
Subject: Re: [PATCH v22 9/9] MAINTAINERS: Add ACPI/HEST/GHES entries
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

On Wed, 8 Jan 2020 at 11:32, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>
> I and Xiang are willing to review the APEI-related patches and
> volunteer as the reviewers for the HEST/GHES part.
>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> ---
>  MAINTAINERS | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 387879a..5af70a5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1423,6 +1423,15 @@ F: tests/bios-tables-test.c
>  F: tests/acpi-utils.[hc]
>  F: tests/data/acpi/
>
> +ACPI/HEST/GHES
> +R: Dongjiu Geng <gengdongjiu@huawei.com>
> +R: Xiang Zheng <zhengxiang9@huawei.com>
> +L: qemu-arm@nongnu.org
> +S: Maintained
> +F: hw/acpi/ghes.c
> +F: include/hw/acpi/ghes.h
> +F: docs/specs/acpi_hest_ghes.rst
> +
>  ppc4xx
>  M: David Gibson <david@gibson.dropbear.id.au>
>  L: qemu-ppc@nongnu.org
> --

Michael, Igor: since this new MAINTAINERS section is
moving files out of the 'ACPI/SMBIOS' section that you're
currently responsible for, do you want to provide an
acked-by: that you think this division of files makes sense?

thanks
-- PMM
