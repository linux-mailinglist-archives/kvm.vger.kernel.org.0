Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3911921DE
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 08:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgCYHq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 03:46:57 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40966 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgCYHq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 03:46:57 -0400
Received: by mail-ed1-f65.google.com with SMTP id v1so1208943edq.8
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 00:46:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UaBcRiu0jhd+aZ3qoAfM9Jyg226NuZ7pG6QSrBAUzKE=;
        b=H0SgN0D5vxyrEoXtGEZ7G2Erjp7gjEESleD79MCln2h+7nGdrlgCTJnhc/56DZEpXx
         2JF+bvcT2B6NeQ0Yk3JNM8SQysELL2F47IhaqrELv37S21H9uX/A5k+0+YCMgMMeTs4u
         rR6ucSJgPCZg1IV/DO9YuVepXgezwjih2etXIrHytlWaGFWX8v1suYCiPr2xwUhMAGOM
         xBQsr1BDb7t9niL9gegy3MwH8eXcYAX8MRNRgu7K6JIa3DFja7CQ/so9ooz6GGlTCNoW
         2lvFT/sFR6BINyrDnZFJlmNTpj6Z9V3ANb0cFumqR7aGqLptGfMqyXvCCKB0LwxaHKgt
         w/bA==
X-Gm-Message-State: ANhLgQ0dw7uJe3wcKBqmFWcyLYlxhsi+gbj+1K496Ov6p7WWM7FrT1mo
        heNqIZM4j2cgiX0OGLHH7rU=
X-Google-Smtp-Source: ADFU+vtMcCFFhN/9DmhxAFJzYhIdK+iRP4YL5ukwhPlffOfTndxsoNgCwnBl7CzNaMJbVvRaQUDS1w==
X-Received: by 2002:a17:906:c4f:: with SMTP id t15mr2040012ejf.193.1585122414316;
        Wed, 25 Mar 2020 00:46:54 -0700 (PDT)
Received: from kozik-lap ([194.230.155.125])
        by smtp.googlemail.com with ESMTPSA id b5sm1497332edk.72.2020.03.25.00.46.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 25 Mar 2020 00:46:53 -0700 (PDT)
Date:   Wed, 25 Mar 2020 08:46:49 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stefan Agner <stefan@agner.ch>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Takashi Yoshi <takashi@yoshi.email>,
        Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH v2 1/7] arm: Unplug KVM from the build system
Message-ID: <20200325074649.GA4640@kozik-lap>
References: <20200324103350.138077-1-maz@kernel.org>
 <20200324103350.138077-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200324103350.138077-2-maz@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 24, 2020 at 10:33:44AM +0000, Marc Zyngier wrote:
> As we're about to drop KVM/arm on the floor, carefully unplug
> it from the build system.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Olof Johansson <olof@lixom.net>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Will Deacon <will@kernel.org>
> Acked-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  arch/arm/Kconfig             | 2 --
>  arch/arm/Makefile            | 1 -
>  arch/arm/mach-exynos/Kconfig | 2 +-

For Exynos:
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
