Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C894E167FB0
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 15:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgBUOKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 09:10:07 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38443 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgBUOKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 09:10:07 -0500
Received: by mail-oi1-f194.google.com with SMTP id r137so1677540oie.5
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 06:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FWVDkmsgLpByHs3eCi6sKclY4YV1R37ovc1jJnUhQAE=;
        b=sYZNsPMdslZdcvPHvQQcr0WltYjiT/Uxn2SLB7obLof1d3EgJ7b4163UoteGPlJyI1
         +s03NrPStjcs/pVGnIHr9ChIdcfXtK6BRPBd1Cp+mL8gjozESrb3QD8N1Fx1nL/MwLKa
         pAzdzPqEtcG6RROcunEocDFvsspFUuVkJZd73lXwyt5e0llpr8oyujVqnZGKseJXdE7s
         16ZFclOcmt6UjH8NLi0wkdjpxq76TL/EdfKJbXfCUIy88AC2t2O9c54P4yRnRISlE7eD
         mx3AOfZ/SmkSaZOefFkfg3yyxutIppFJXE/2zrjoZtoAVP7kultq2C0dsqJzbVNwGtkJ
         WYNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FWVDkmsgLpByHs3eCi6sKclY4YV1R37ovc1jJnUhQAE=;
        b=HgVmE+EC5zazPil2i1WNTJitMq23qen1DZFBwWPlmDYRGibrEd6h1KPDPE1RpXes1j
         vl2+No16LAkjUSyo2kfYrm7T4GUiizB0XFGva73IwoVm8BpPqhAR9oESfZZdz3wusWgG
         uwsdYbGHb42OidNUGL7B0HVJZ811dQDAjR1aPhAATT8MNC62UoVHs8aWJTiUafG2Gtzu
         +QrR0a5X34NkrmO82MEkNXhEFWqavoV1xroD9W163NVXWFrCvv2YFjKiRwHaCMueLUN+
         g7jdD5/fpr5656cAvNa1EQr6vsgaaVgrQVC8zKIAo/JhRc9bXV5otOnRlyiYdnhwnB2x
         F0nQ==
X-Gm-Message-State: APjAAAUAGO1Rh88CA7U+WE8mRSAKzwUGp5tmdChB4XXR4fk/SIbr1J4v
        ac7jHfOeoFAgvWo+5Wa9DdhI/ixM7IM+ek2kHX4r1Q==
X-Google-Smtp-Source: APXvYqyX9eeSuvuFP09qcS1lkRxxupztYJ917FYlclPxtdjWxmrxfdLsQF2GBc3ux1gL+c/jP6I4magBfiAsdoLFwbE=
X-Received: by 2002:a05:6808:289:: with SMTP id z9mr2098991oic.48.1582294206446;
 Fri, 21 Feb 2020 06:10:06 -0800 (PST)
MIME-Version: 1.0
References: <20200217131248.28273-1-gengdongjiu@huawei.com>
In-Reply-To: <20200217131248.28273-1-gengdongjiu@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 21 Feb 2020 14:09:55 +0000
Message-ID: <CAFEAcA9xd8fHiigZFFM7Symh0Mkm-jQ_aGJ7ifRCrXZvFY4DqQ@mail.gmail.com>
Subject: Re: [PATCH v24 00/10] Add ARMv8 RAS virtualization support in QEMU
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
> In the ARMv8 platform, the CPU error types includes synchronous external abort(SEA) and SError Interrupt (SEI). If exception happens in guest, host does not know the detailed information of guest, so it is expected that guest can do the recovery.
> For example, if an exception happens in a guest user-space application, host does
> not know which application encounters errors, only guest knows it.
>
> For the ARMv8 SEA/SEI, KVM or host kernel delivers SIGBUS to notify userspace.
> After user space gets the notification, it will record the CPER into guest GHES
> buffer and inject an exception or IRQ to guest.
>
> In the current implementation, if the type of SIGBUS is BUS_MCEERR_AR, we will
> treat it as a synchronous exception, and notify guest with ARMv8 SEA
> notification type after recording CPER into guest.

Hi; I have reviewed the remaining arm bit of this series (patch 9),
and made some comments on patch 1. Still to be reviewed are
patches 4, 5, 6, 8: I'm going to assume that Michael or Igor
will look at those.

thanks
-- PMM
