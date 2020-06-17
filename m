Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2161FD940
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 00:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgFQWxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 18:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgFQWxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 18:53:02 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEB8C06174E
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 15:53:01 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x207so1858690pfc.5
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 15:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=jDsiGpHlHt3A6TlGq6foih1kuiL4GlYeWIrZSOkZpxY=;
        b=gzQGj00ueXc2W/kOiGPOcTIAbJbr/M/MLdgqTtuhg5grPOrTu3BaxWlh8qOcwEYPtj
         qe03kbeetPJMdpKWXdSYw0Ln/fx9cMl6bRF4zZ6alGlnV6HRhnHB+trO2CH/K2qV/gpS
         3NB8IJAhQw/Nvs7O7OFXgO56j6elETkFG+H0kzbZRn0JJ8Ojl3tyJLYdU8fjrsBMwGug
         PKlkZtp0fFdkyBfsIHsCui78044VbKGgQrlzz8hC3KW/Rjw7DeF/XFuLkcpIzzy610eT
         mGfCtn90i5IVz76mMYs+ZX9N8SbKCwhS6p1zBzFzWMY12QRrZ21+X78Sjh6+b6G40Onk
         6D/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=jDsiGpHlHt3A6TlGq6foih1kuiL4GlYeWIrZSOkZpxY=;
        b=cwy2ArR8S9Dronub+7fkc9HQD5COjTWYEqeDEaTmz25cC0eFWdMzGmrbrk8/NKBRyZ
         9wRQKXGg824II+ekOlwMjZnBv3OpgkhyvtYvGhlDMcrj5ZUyNpfAA5ZQeTFOGUHWcj0u
         DVPP34fBW1VlTkENCcmW0SnF6IJz8LvI3MeNhq06g2Ldrr3xWwKtCBRRDjBX0wiwp//9
         EwQr1Ou9MOpshf0HX4I3MDpx47Ijr2Kw7yRy3QsrFQsdFLJMFLOsVfSc7b7JoAtq64cp
         jTDMHSWW27Enb+by3wtHtE0IeE7H6qtjIuJDljhOGbiZA3t6mI0gD/1h7yt1uKpElJz8
         d9/A==
X-Gm-Message-State: AOAM530nt37/D6J8EoPdly1DPvNyc2MLjCa7gI/Zi5cPV357Erfp0qel
        gMDEwc3EhH8R3AEdqog07jhx4WkyMfA=
X-Google-Smtp-Source: ABdhPJx8Qbf49zWcMX8/NXw0QB3RvDxyw4NaaPU5k5Ty2ssb3CbYBVNbXy4fzd/ZWZlzMfKdx8wrmQ==
X-Received: by 2002:a63:1718:: with SMTP id x24mr916736pgl.72.1592434381286;
        Wed, 17 Jun 2020 15:53:01 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:1c36:bfc:73ae:1f3? ([2601:647:4700:9b2:1c36:bfc:73ae:1f3])
        by smtp.gmail.com with ESMTPSA id p19sm821798pff.116.2020.06.17.15.52.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jun 2020 15:53:00 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [kvm-unit-tests PATCH] x86: Add control register pinning tests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200617224606.27954-1-john.s.andersen@intel.com>
Date:   Wed, 17 Jun 2020 15:52:59 -0700
Cc:     corbet@lwn.net, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, mingo <mingo@redhat.com>,
        bp <bp@alien8.de>, hpa@zytor.com, shuah@kernel.org,
        sean.j.christopherson@intel.com, rick.p.edgecombe@intel.com,
        kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <ACCCF382-0077-4B08-8CF1-73C561F930CD@gmail.com>
References: <20200617224606.27954-1-john.s.andersen@intel.com>
To:     John Andersen <john.s.andersen@intel.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 17, 2020, at 3:46 PM, John Andersen <john.s.andersen@intel.com> =
wrote:
>=20
> Paravirutalized control register pinning adds MSRs guests can use to
> discover which bits in CR0/4 they may pin, and MSRs for activating
> pinning for any of those bits.
>=20

[ sni[

> +static void vmx_cr_pin_test_guest(void)
> +{
> +	unsigned long i, cr0, cr4;
> +
> +	/* Step 1. Skip feature detection to skip handling VMX_CPUID */
> +	/* nop */

I do not quite get this comment. Why do you skip checking whether the
feature is enabled? What happens if KVM/bare-metal/other-hypervisor that
runs this test does not support this feature?

