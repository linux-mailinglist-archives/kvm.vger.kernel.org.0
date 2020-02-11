Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3531594D3
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 17:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbgBKQZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 11:25:05 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38546 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729281AbgBKQZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 11:25:05 -0500
Received: by mail-oi1-f193.google.com with SMTP id l9so13320462oii.5
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 08:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YTN1aAmP6lc4kQg/pEPrAXI0XAGYx4yNSmOlFp4FG4w=;
        b=lxQlVmvVZcKdKIQTir0FJwH3pOsXoSn5/Q4tMLOxZHb6vh+J078303Z8U7gab4r+M/
         u0nOHQOoM55bwBkguDId7rDWaUhv466UTLUufW9bMy1B2UPv0baZR4jth9eVclXQQlwg
         ns/Bj2RA4Mc3yHj7MRF0DLHPNIGqXe1YZu0Bbbq1edR2+mU0MmkhgL1aOcldQsKwV8ed
         sESHd3hfq2IdjbPTIszOs4y0I8vABsJnNUzB0AebGS13LE3Z2FsIDc0KX5fJA00RYefp
         WIzcZYtT0DlJm4TAufNiRZ8Zw0u5RNE3PAR11A/fvqPnpk/HJkWZe4i1Wrf64W3IomhD
         S4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YTN1aAmP6lc4kQg/pEPrAXI0XAGYx4yNSmOlFp4FG4w=;
        b=pF1YrGjRkXphAm6BYLeHbg5w8Q+PniDJZeEgmlt8yr+5U144azvhtGBxwC7LMNQcsG
         ymFgprFtj+SLzYWKGye7jdWbpOSly08g4fssPq9XQWV5ByqcXKGKyaQzCkr63CU3kIbK
         8wIregNeninB4h2K4rSRoHMXWuLJYeUeUhE8VcyYGEHtB025/8SnRGQDgOzKIApFk/Rs
         PemU6XvrevyTWZNlqdKQ247O9aqMjPel3dv5PtI9QM0yfbGTeC1Z74gi70ipQHPr4zhv
         4BgDg/ItU+qDTerXZg6Fbe+HuaEyFYkftEsGdKUwfE4mZ3RcaHKidiLRO0EJRuGLHc1r
         inNg==
X-Gm-Message-State: APjAAAV3WOrgng0R6AyujZ65jCqrAUV2m/MIDCXn7swXlyrsargfveSL
        ZdlBd+2B3Qjz+8eEnRwJKI0ZY+XJllJL+Mv7iVnQwQ==
X-Google-Smtp-Source: APXvYqzv/UP3M8yZMmNDzyJRIaKXistg0kt67KZIdKfe9JVAoy6ZnLkvmh7xAXkvGMtm+bCKNIS/Rzvw8t5EaSXvOXI=
X-Received: by 2002:aca:3d7:: with SMTP id 206mr3426415oid.98.1581438304306;
 Tue, 11 Feb 2020 08:25:04 -0800 (PST)
MIME-Version: 1.0
References: <20200130112510.15154-1-eric.auger@redhat.com> <20200130112510.15154-7-eric.auger@redhat.com>
In-Reply-To: <20200130112510.15154-7-eric.auger@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 11 Feb 2020 16:24:52 +0000
Message-ID: <CAFEAcA_jfZKjey8komTt97Mu-oFjWyFNG2cY4-o8yFAP1oGiug@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 6/9] arm: pmu: Test chained counter
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

On Thu, 30 Jan 2020 at 11:26, Eric Auger <eric.auger@redhat.com> wrote:
>
> Add 2 tests exercising chained counters. The first one uses
> CPU_CYCLES and the second one uses SW_INCR.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> +static void test_chained_sw_incr(void)
> +{
> +       uint32_t events[] = { 0x0 /* SW_INCR */, 0x0 /* SW_INCR */};

Cut-n-paste error? This test relies on the CHAIN event but it
isn't present in this list of events to pass to satisfy_prerequisites(),
so I suspect the second element should be "0x1e /* CHAIN */" ?

(This makes the test fail on QEMU TCG, because we don't implement
CHAIN.)

thanks
-- PMM
