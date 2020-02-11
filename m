Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060F11594F1
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 17:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbgBKQ2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 11:28:45 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33254 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729102AbgBKQ2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 11:28:44 -0500
Received: by mail-ot1-f67.google.com with SMTP id b18so10720110otp.0
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 08:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sBL1pdvCcbU5vh2MRuYeHAqsYDWdsnFmPWD7z1MAFS8=;
        b=SoHdSL0v6iKBaL8zgd+lCUElYoaXsAfUEXa9LewiooAA5sfD7WLzJr/zUAq9inb3HN
         g9KiANDepXgVQcQML6UQoWdxX/zCH7k5u/cQJb++myJJll2u1soQx+bX3bgsEogEyYwT
         o98FqckKC1IhQGCE3z3WZHOMPuGB8UU2meAF8cGqSkqAshTrVWdNtyg65J2bHeD0z3AG
         LH8pUj+bixTPli6OWfF6iNF+dspoPIks04pG2OV9Re/uPltKscvyX9FfW6qXZfK/hE4Q
         DwsGFLAMTwyXlci8q0KGniQs9daCRGj+ie2k3v81msJ7xmG5YCS5YkqCUHbx8lobeQuZ
         r3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sBL1pdvCcbU5vh2MRuYeHAqsYDWdsnFmPWD7z1MAFS8=;
        b=XqXWyC1xtc+13F/wQLRR05eUW1A17ax/CSPLCQ2mWejcolYoUHQvO/dEIHk744CyEX
         9/7fC4jlDAxPXLAOsr9FM1wftdOv7GjT5zyxSLiwkW0T7Oj/IAszbCAcZ+EjjW0FuNx3
         dEullYDYl8xF83uJvHs1hQVzLIQJ5Ux8hsjZytK27rUGa/o5b+eLsJv9keGzcIUx+WkZ
         QgWKQOxOZ110PMzrbrY/PXAwTu2UWV7pgcPT2lLoqEDv31PsnX2DPwmXLzOasCJKxn8L
         hniJZch3szTLGeFP2ogBFWPuZvN9azPAltDuNKZbjiP1FGkC+rzidZdN/HGx417NhTr4
         Ktbg==
X-Gm-Message-State: APjAAAXMW6jXrKN6RD3+4tifyozqfW/yW0PBtbSF/MgmSoy9DL9aEO9r
        W//04Gl+Ockt/+RlqwwA1h30BrSjhpgojWMwFhwo3lTQ
X-Google-Smtp-Source: APXvYqwMDFOjjhVbQZtRmwikjYOZ3DieS0MB81Yf/FbcjGebMqahe3qweuGumfab9jxqW2C9ue8obJUgmNf0Y4w4xC8=
X-Received: by 2002:a05:6830:4a4:: with SMTP id l4mr5921019otd.91.1581438522842;
 Tue, 11 Feb 2020 08:28:42 -0800 (PST)
MIME-Version: 1.0
References: <20200130112510.15154-1-eric.auger@redhat.com> <20200130112510.15154-5-eric.auger@redhat.com>
In-Reply-To: <20200130112510.15154-5-eric.auger@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 11 Feb 2020 16:28:32 +0000
Message-ID: <CAFEAcA_V3rT+C1FCPPyjmQ8svxF1tMWWOLgZ1Vn_CNQ3N0x-KA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/9] arm: pmu: Check Required Event Support
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Eric Auger <eric.auger.pro@gmail.com>,
        Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jan 2020 at 11:25, Eric Auger <eric.auger@redhat.com> wrote:
>
> If event counters are implemented check the common events
> required by the PMUv3 are implemented.
>
> Some are unconditionally required (SW_INCR, CPU_CYCLES,
> either INST_RETIRED or INST_SPEC). Some others only are
> required if the implementation implements some other features.
>
> Check those wich are unconditionally required.
>
> This test currently fails on TCG as neither INST_RETIRED
> or INST_SPEC are supported.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>

> +static bool is_event_supported(uint32_t n, bool warn)
> +{
> +       uint64_t pmceid0 = read_sysreg(pmceid0_el0);
> +       uint64_t pmceid1 = read_sysreg_s(PMCEID1_EL0);
> +       bool supported;
> +       uint64_t reg;
> +
> +       /*
> +        * The low 32-bits of PMCEID0/1 respectly describe
> +        * event support for events 0-31/32-63. Their High
> +        * 32-bits describe support for extended events
> +        * starting at 0x4000, using the same split.
> +        */
> +       if (n >= 0x0  && n <= 0x3F)
> +               reg = (pmceid0 & 0xFFFFFFFF) | ((pmceid1 & 0xFFFFFFFF) << 32);
> +       else if  (n >= 0x4000 && n <= 0x403F)
> +               reg = (pmceid0 >> 32) | ((pmceid1 >> 32) << 32);
> +       else
> +               abort();
> +
> +       supported =  reg & (1UL << (n & 0x3F));
> +
> +       if (!supported && warn)
> +               report_info("event %d is not supported", n);

As with satisfy_prerequisites(), printing this with "0x%x"
would probably be more helpful to most users.

thanks
-- PMM
