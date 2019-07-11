Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 854A765359
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 10:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbfGKIvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 04:51:23 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33900 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfGKIvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 04:51:22 -0400
Received: by mail-oi1-f193.google.com with SMTP id l12so3913237oil.1
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 01:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k/zX7qRMlJI8fUYktt5/frIONjiVDpZRrgUUq3EkUTc=;
        b=s+p5Rqsk09xdh4xS0WW1f/H4FX3ewk3iHV3RN01z+R3dZhbTECk4DovbE5aSicjP1J
         jwKXyuonvUvH9IoB+hOY4ff0IkyqGiYn4pxGDbF3yb/GyzMIXohihhNAEI2mEOokYQvQ
         jhLhtPqDv3/rkhuoALCCdFHi3hCn4l1Tt5kWirDEL0v7Xrrj9kIMQmOL4NBkef493ivh
         0q4+hngG4T0asJ5oDFOc/FPhwhj7ehsqjwEZZOpQ4EPofT4ObRq84QOEsTpEx62v44Ll
         xGe+96g+swpR5I7BVk1zNb7ZGkpxbkgLEC3elu+RkrqH8C2f7FGzgWjCCICopT3HHxLD
         e2pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k/zX7qRMlJI8fUYktt5/frIONjiVDpZRrgUUq3EkUTc=;
        b=ryqVrriFLiz+mPJsdBk2YRJnW5y3AAWFZcPpG3sCDPtxJwwQCe1yBEW620yIsuFWkR
         5z/bE0j3xwEdMhla81v69iLpgtKq87IQcQ7LKlhbbr2rRSTvl4jM9lJEPMEHR5av04AO
         hogeGKNmzNOZ80xxMUZxOCV0KYzVJdAw8Afwbl7/43OfhziZwmcOT3pU0d002mM125N6
         nCTPie96per8oMP+7XHTaxVdHukciE5EikvgaueZezw+SRXTKgj5UV5EFtSIq9CUxSC3
         UiZMprSimNRJLccs/8HACUYBx2ngZLHUaOfUkXz5WY/d7CpJvDXwrTEzx0QhZish9sxv
         oVlA==
X-Gm-Message-State: APjAAAWCfLn9/tZtVtpZ0xbZ9xmC4efobW/dt88s4y33ZYDcJMcOl6pn
        vJS9H4yAE3oDaE5p6Cvs61xDeFNWrQMDaZ7EUjzI5g==
X-Google-Smtp-Source: APXvYqwN36w+hCesmo+OCwkoa7l8eUf1QaX3sqrlCqwBWedZ6AgvlD2qKx9fLYO82J5xohKuC9GzDxOHWqaxAbCxvEo=
X-Received: by 2002:a05:6808:d4:: with SMTP id t20mr65327oic.170.1562835081962;
 Thu, 11 Jul 2019 01:51:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190710132724.28350-1-graf@amazon.com>
In-Reply-To: <20190710132724.28350-1-graf@amazon.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 11 Jul 2019 09:51:10 +0100
Message-ID: <CAFEAcA81mQ780H5EY8uV6AvbXzeZA60eCHoE_n9yzeZgw+ru4w@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
To:     Alexander Graf <graf@amazon.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Jul 2019 at 14:35, Alexander Graf <graf@amazon.com> wrote:
>
> This patch adds a unit test for the PL031 RTC that is used in the virt machine.
> It just pokes basic functionality. I've mostly written it to familiarize myself
> with the device, but I suppose having the test around does not hurt, as it also
> exercises the GIC SPI interrupt path.


Have you tested this against a real hardware pl031? I appreciate
that the scaffolding to let you do that is probably pretty
painful, but it would be interesting to test, because I'm
not really all that confident in the accuracy of QEMU's
pl031 model. (Notably there are some places where it absolutely
does not work like the real h/w; in some ways it's a bit
like "a pl031 that some imaginary firmware has initialized
and enabled"...)

thanks
-- PMM
