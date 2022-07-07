Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7651C56AB93
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 21:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236780AbiGGTNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 15:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236771AbiGGTNB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 15:13:01 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9291B2E6B2;
        Thu,  7 Jul 2022 12:13:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id B6250784;
        Thu,  7 Jul 2022 19:12:57 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net B6250784
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1657221177; bh=qL7VYc78jVx9LMUHDXqpy7ynrmJbVJjFrUcf+/qpMfw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=nrAEjPsYMAonbvJuC5YoW3yDogJZcXDdnd8l3mRPhFnO+1P55b8PQFEydP6TlfPKW
         P9c62CfudiR5PQ0WARL0qnFasbGpO3qRfpNhDsuUEetRSA6MS4WRKizlsJXL8XRbp1
         7nHGX5+wy9QA0A/SvcUg6HsfSRFg2Eft0xz28d0IhNlw5jZiXmvzaJ+szEmbATd2Bz
         N1NTtsTqZSpbvdpDqZdXQypCLfOUUea3tD4qA877k0354N7yRxc0ncIrOtPTF5LITW
         cE1r/DSQvMdfkvWdEEP7MkwATZQgPnRdhMhN4OpinbLGZEUQupaRX69j+jRbjjWr4U
         NVSpHy4P0hJrg==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alex Shi <alexs@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dipen Patel <dipenp@nvidia.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yanteng Si <siyanteng@loongson.cn>, devicetree@vger.kernel.org,
        keyrings@vger.kernel.org, kvm@vger.kernel.org,
        linux-cachefs@redhat.com, linux-input@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-riscv@lists.infradead.org,
        linux-tegra@vger.kernel.org, rust-for-linux@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v2 00/20] Update Documentation/ cross-references
In-Reply-To: <cover.1656234456.git.mchehab@kernel.org>
References: <cover.1656234456.git.mchehab@kernel.org>
Date:   Thu, 07 Jul 2022 13:12:57 -0600
Message-ID: <87a69kbuti.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mauro Carvalho Chehab <mchehab@kernel.org> writes:

> Fix most broken documentation file cross references on next-20220624.
>
> After this series, only 3 references will be broken:

OK, I've applied everything except parts 4, 9, and 20.

Thanks,

jon
