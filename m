Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5672C6AAEF
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 16:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387773AbfGPOvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 10:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728470AbfGPOvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 10:51:18 -0400
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3614B2173C;
        Tue, 16 Jul 2019 14:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563288677;
        bh=sonO2Wj/dB2WVkbnigGOIptZBiYzU9g2oAVvNNhm8N0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cJpVGUzwvpQrBfw5VxnjM7fZDMqN8buukyY5uNJV0ilBSNzK8xmxbSP8KeFgOPVGk
         CdhPYLcquPdpNPv9IfGMnbk93gK1YgS3rEW3NEieCmVZ/yyatbJnN9K/XZrO4tC0sv
         vpJ81lt0Z15VjbKndmSpPGS7eGfx6pNckGHuM6H8=
Received: by mail-oi1-f178.google.com with SMTP id w196so15751312oie.7;
        Tue, 16 Jul 2019 07:51:17 -0700 (PDT)
X-Gm-Message-State: APjAAAUzNDjM6CkTAVBj689g9/0ymmtl7lnTF+3weDk1ZY69iWxZD8Fb
        YeSU/Sse0VxX7EvIzce7nrEzXEfu1SiFQCQa6NU=
X-Google-Smtp-Source: APXvYqznotTEvyaymhJh/wAMu0w2H5gcuDv5j22SZvycyNMyxsk7XBmOnJ7QXnjodYkrV1FF1kduEHzUtbpafqpVCNU=
X-Received: by 2002:aca:1b0c:: with SMTP id b12mr2605814oib.123.1563288676578;
 Tue, 16 Jul 2019 07:51:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190712022018.27989-1-alex.shi@linux.alibaba.com> <20190712022018.27989-2-alex.shi@linux.alibaba.com>
In-Reply-To: <20190712022018.27989-2-alex.shi@linux.alibaba.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Tue, 16 Jul 2019 16:51:05 +0200
X-Gmail-Original-Message-ID: <CAJKOXPcnMM=h9-MW4qg4OTxaY5eBQ=4tH=Gbd3tSuckFvSOPcw@mail.gmail.com>
Message-ID: <CAJKOXPcnMM=h9-MW4qg4OTxaY5eBQ=4tH=Gbd3tSuckFvSOPcw@mail.gmail.com>
Subject: Re: [PATCH 02/12] Documentation/arm: repointer docs to Documentation/arch/arm
To:     Alex Shi <alex.shi@linux.alibaba.com>
Cc:     linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-sh@vger.kernel.org,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-input@vger.kernel.org, linux-serial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Jul 2019 at 04:20, Alex Shi <alex.shi@linux.alibaba.com> wrote:
>
> Since we move 'arm/arm64' docs to Documentation/arch/{arm,arm64} dir,
> redirect the doc pointer to them.
>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kukjin Kim <kgene@kernel.org>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-input@vger.kernel.org
> Cc: linux-serial@vger.kernel.org
> ---
>  Documentation/arch/arm/Samsung-S3C24XX/GPIO.txt    |  2 +-
>  .../arch/arm/Samsung-S3C24XX/Overview.txt          |  6 +++---
>  Documentation/arch/arm/Samsung/GPIO.txt            |  2 +-
>  Documentation/arch/arm/Samsung/Overview.txt        |  4 ++--
>  Documentation/devicetree/bindings/arm/xen.txt      |  2 +-
>  Documentation/devicetree/booting-without-of.txt    |  4 ++--
>  Documentation/translations/zh_CN/arm/Booting       |  4 ++--
>  .../translations/zh_CN/arm/kernel_user_helpers.txt |  4 ++--
>  MAINTAINERS                                        |  6 +++---

I assume it will go through doc tree, so for Samsung:
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
