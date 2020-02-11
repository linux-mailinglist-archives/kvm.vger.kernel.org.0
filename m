Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7DC1594E7
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 17:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730828AbgBKQ12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 11:27:28 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:40503 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbgBKQ12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 11:27:28 -0500
Received: by mail-oi1-f196.google.com with SMTP id a142so13338035oii.7
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 08:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yVHXsm2IYBbO0NyhRrtnF1/ntngEqGjIm7d0F0XQrvk=;
        b=zgDrvETeZ98ubY0HRNgI2g9jEA8jJoX/ED4+UpFR+atEhYr56+2n8NOg6kMLgv3Rnr
         4n5nnpYPG0cXSdVX49tRS/ufUSm1llmPiSvhrGu+uhyJokufZD0gPCfLV1rN0EjA2/F+
         7ZYg5KHJTUZQRZ0I2+WAKQ1bpvITGMsZmdTRxFkJ0ruKftoWC/OF/JRQjtdOooStvflb
         Ud8hY87RyjXX16e3GoZkH/Og2IFdB+Dd5gxqGkulEj9QE01t0D1HXpJXcvPl+fr/iFhO
         6oK208vi8WL/kuS8J5phalnb6fuMwPpENxZRLIVpeOnZ+hhClUWqo83ltw1HGhGlrqKC
         Yi5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yVHXsm2IYBbO0NyhRrtnF1/ntngEqGjIm7d0F0XQrvk=;
        b=I/rD9JW8NrspiNcJ0uo+cniQvKzY7ca5FwpbcwNMRmzfKcK4S05CcqkLS/Y5vX8OPq
         4Hmf/BOIs+FNS4uGniywUJ5LGLvkImKe5xVKEFZ8TCfzmie7bzBBT3NZ0k7+ZfpGtYmJ
         0m8YeHKBBEoB6T+Nb/BErKt4cPGDGt1P1/S5IB8z9ILBL5kIiL66xyHlJaBzxXJtPSlg
         za9CIKbQ7min/wOrEPz2d4KQERXmgPb3UXKa3xEdljXt8bBb/yT8OiN2a2hrX7MxNrM8
         e5AebsfhQaJwpjNkBhhugWZItV0PJzhHkODTYevXafTJLph29d+OFSjoHHDvQdVvZfqS
         GgFw==
X-Gm-Message-State: APjAAAVt+MYleWORDMhqWC3/H5yiEzA2xXYnPDxigcbBnanlSs5HGFgV
        L35ZG7HRfvJjFst7EfnDMVwR8hAfjTP7sblrbYuU6olw
X-Google-Smtp-Source: APXvYqxxECM3fLexhrufeAZhTAqwZXYeTdHgsZFsgc6CnwRsYHiLW7ZwJQkutazw5wzjwg+heCPClWtjmUZZrlaigT8=
X-Received: by 2002:aca:3d7:: with SMTP id 206mr3432708oid.98.1581438447073;
 Tue, 11 Feb 2020 08:27:27 -0800 (PST)
MIME-Version: 1.0
References: <20200130112510.15154-1-eric.auger@redhat.com> <20200130112510.15154-6-eric.auger@redhat.com>
In-Reply-To: <20200130112510.15154-6-eric.auger@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 11 Feb 2020 16:27:16 +0000
Message-ID: <CAFEAcA9Yc9dKTCcP3fP93tQU62Q=2FYOoYGvUqfiOMY=pYV_RA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 5/9] arm: pmu: Basic event counter Tests
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
> Adds the following tests:
> - event-counter-config: test event counter configuration
> - basic-event-count:
>   - programs counters #0 and #1 to count 2 required events
>   (resp. CPU_CYCLES and INST_RETIRED). Counter #0 is preset
>   to a value close enough to the 32b
>   overflow limit so that we check the overflow bit is set
>   after the execution of the asm loop.
> - mem-access: counts MEM_ACCESS event on counters #0 and #1
>   with and without 32-bit overflow.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

> +static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
> +{
> +       int i;
> +
> +       if (pmu.nb_implemented_counters < nb_events) {
> +               report_skip("Skip test as number of counters is too small (%d)",
> +                           pmu.nb_implemented_counters);
> +               return false;
> +       }
> +
> +       for (i = 0; i < nb_events; i++) {
> +               if (!is_event_supported(events[i], false)) {
> +                       report_skip("Skip test as event %d is not supported",
> +                                   events[i]);

Event numbers are given in hex in the Arm ARM and also
specified in hex in your test source code. I think it
would be more helpful if the message here used "0x%x", to
save the reader having to do the decimal-to-hex conversion
to find the event in the spec or the test case.

thanks
-- PMM
