Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A550F6A63D3
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 00:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjB1XfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 18:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjB1XfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 18:35:18 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7833B22DE2;
        Tue, 28 Feb 2023 15:35:17 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id i5so10494892pla.2;
        Tue, 28 Feb 2023 15:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e4zYd/om/0vBkL4x55q7/7LukdZ/UT4v5ORbkIxAbcQ=;
        b=nNJQX9hYnw3FX8YKTaDXEAIS+z4fPv8Bw+B8qr6ckPjb8pFiYXJ7RiGVqtKr/keDNd
         GHwOhj9tlgJjLU/U20MXO8fQKHuOdeKGrg2eToL9nDAbiCvFdqud9l6fOuVKo0baxp7t
         5FVPg/CUTGadEIP2mUpz3gWuG6560mb6D/o5pIVzm6rRVozf7pBSd3DFDEuXckZBA1OR
         wnNpxgtjEvF/TswNsBSQ8hBWnHeKrYoekuzxHeICMr4siBBpNcT8MrJWADmUM92DmGVN
         zsKkZkGc1Ez+ceo4mMkEpvaZAfJIiM7PDPrPH2zOGLVkBHL4KoIYnCweaSc3laUK7hCX
         oIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e4zYd/om/0vBkL4x55q7/7LukdZ/UT4v5ORbkIxAbcQ=;
        b=pTW7m7cX1grhM1SVhGXz96Ma7uzncn8WS0nSrY0Gcfz4GZXi9MHFpgJ2J5OfC8EWJx
         OD2oSSGqN2nlpFtqRfC3oFur1XKTauN9LlQ/G2dfErAflQMKyGx+/L1/NSbNnTDnEQ3b
         KtlxtcSX2ZgMVluZ55GQqV6M/KViISrPkkfkGI1P+BmF8iT3fFqSUprZYv7KCaxIDjz9
         b1VN8++I9npswxYYnz/cQsWwS1RmqIvhjGo9/vvrNA0SAXqh+vA52iZrwTQ+xUj+3FMS
         bVef3RmMG5QMdCCg/IOThcgo9WGQBRHm7FqEb+uwXbYS/x4EX2MUtY1OarpgIptRAuma
         BSeQ==
X-Gm-Message-State: AO0yUKXajxetdDV0wAszgR96H/qMCowoFxHA7sbZVpxm8bMHfUzDhXYB
        hNJVrqFVQPG6KrS+LraUllwebiajIChuH7h7rXU=
X-Google-Smtp-Source: AK7set/h/6S+CfhMlSvBaTTgOBE4PVtAkXHS+ngdIcxOP2Zb8jQT9r+uwE43NbtTp5RsatSeptHrwizOBS6NcjndHi0=
X-Received: by 2002:a17:90a:ad8a:b0:234:1fac:f291 with SMTP id
 s10-20020a17090aad8a00b002341facf291mr1861292pjq.8.1677627316752; Tue, 28 Feb
 2023 15:35:16 -0800 (PST)
MIME-Version: 1.0
References: <20230127112248.136810-1-suzuki.poulose@arm.com> <Y9PtKJ3Wicc19JF1@myrica>
In-Reply-To: <Y9PtKJ3Wicc19JF1@myrica>
From:   Itaru Kitayama <itaru.kitayama@gmail.com>
Date:   Wed, 1 Mar 2023 08:35:05 +0900
Message-ID: <CANW9uyud8RTkqgiL=64wV712QMxtAyubqeyCJ0vpcADJ42VqJA@mail.gmail.com>
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 28, 2023 at 12:30 AM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> On Fri, Jan 27, 2023 at 11:22:48AM +0000, Suzuki K Poulose wrote:
> > We are happy to announce the early RFC version of the Arm
> > Confidential Compute Architecture (CCA) support for the Linux
> > stack. The intention is to seek early feedback in the following areas:
> >  * KVM integration of the Arm CCA
> >  * KVM UABI for managing the Realms, seeking to generalise the operations
> >    wherever possible with other Confidential Compute solutions.
>
> A prototype for launching Realm VMs with QEMU is available at:
> https://lore.kernel.org/qemu-devel/20230127150727.612594-1-jean-philippe@linaro.org/
>
> Thanks,
> Jean

Hi Jean,
I've tried your series in Real on CCA Host, but the KVM arch init
emits an Invalid argument error and terminates.
I configure it with the aarch64-softmmu target only and built, any
other steps I should worry?

Itaru.

>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
