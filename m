Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B1C28343B
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 12:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgJEKxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 06:53:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44814 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725843AbgJEKxI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 06:53:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601895187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kbiHNjQke6HODK9Aq4q/LEwhaKtx/GjpAuwA6iwInj8=;
        b=GxLYpJY3LVYVld/qE2/5OZh/7QF0TlOGnH4KznP8UTKMtLpknVN89MuZ9B10huygDUzrDS
        /chFKEmJIadrzq6s5ErDEPURt6knOWUviM3AI3mT8B4xCrU6Kdqr1k3HO3QiQyGbRNfS34
        FP2SQaGt/SKtCc+VHXlgOR5hF8FtAj0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-EIGFn4zINamc7hqx0oxxEA-1; Mon, 05 Oct 2020 06:53:05 -0400
X-MC-Unique: EIGFn4zINamc7hqx0oxxEA-1
Received: by mail-wm1-f69.google.com with SMTP id v14so679029wmj.6
        for <kvm@vger.kernel.org>; Mon, 05 Oct 2020 03:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kbiHNjQke6HODK9Aq4q/LEwhaKtx/GjpAuwA6iwInj8=;
        b=laVB1EMjrYGtnlQ688F9Zje1Hr5tkx9ggRZOXA24nDu39ySklmQIg0QAtC3ouGwRLg
         kUiKcaQoAavq6jbuiH7KA2Ge0hrwXSPXzDMjYYHXShs/dyZquaTMZjAyZMprWPLNmNf1
         KgpmbG2bwmr6TR6B1JBYUhnMrRjmdh0RSvpRwHK7MlluRC226tvFs8Q/QPDPjt+sigYy
         HhRB20xbQ4uWms1qHP2b9An1rTqF4/zVGlEiruLFTHaPixe9fJaEf9pEPBRSPSWHbbwa
         W/CchvoDSRGvQ7E7zOd5lGZtC2I7eop/+8XrXPQi2DoUNtlBoTEu42TAQdwJmvfgGeXo
         b+PA==
X-Gm-Message-State: AOAM532T2qKoQUD+xW8ZcfoIuWXJPQzqsFBO2tbUYcsbDlwlY9Hg99DO
        y7TtIzY2DVw+WDyNM5pQ8RV4B8tXEHTDXXrW+o3QTijTUjErmSpxKFcibbMX7qysSgvz6ARw9mr
        1CjpXgqHU1TbE
X-Received: by 2002:a1c:111:: with SMTP id 17mr15948749wmb.126.1601895184070;
        Mon, 05 Oct 2020 03:53:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy30tyA/gUzbfN4GfzcirYYgq3wPlEjkNGuczMbEveLo5Ma7OijnoB+fYprt4GnFnU65+AICg==
X-Received: by 2002:a1c:111:: with SMTP id 17mr15948727wmb.126.1601895183801;
        Mon, 05 Oct 2020 03:53:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:2e86:3d8b:8b70:920c? ([2001:b07:6468:f312:2e86:3d8b:8b70:920c])
        by smtp.gmail.com with ESMTPSA id k190sm8882949wme.33.2020.10.05.03.53.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 03:53:03 -0700 (PDT)
Subject: Re: [PATCH v3 17/19] hw/arm: Automatically select the 'virt' machine
 on KVM
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>, Fam Zheng <fam@euphon.net>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-18-philmd@redhat.com>
 <CAFEAcA-Rt__Du0TqqVFov4mNoBvC9hTt7t7e-3G45Eck4z94tQ@mail.gmail.com>
 <CAFEAcA-u53dVdv8EJdeeOWxw+SfPJueTq7M6g0vBF5XM2Go4zw@mail.gmail.com>
 <c7d07e18-57dd-7b55-f3dc-283c9d13e4b5@redhat.com>
 <8253ddd7-3149-17d9-1174-6474c4bde605@redhat.com>
 <36629bed-9b32-01a0-fdc2-831b10e4bad9@redhat.com>
 <f3b931f5-c785-1d98-edd1-e5fcc91ff0ce@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4c371698-b41a-82ba-9fe9-022a37a86a01@redhat.com>
Date:   Mon, 5 Oct 2020 12:53:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <f3b931f5-c785-1d98-edd1-e5fcc91ff0ce@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/10/20 11:22, Philippe Mathieu-Daudé wrote:
> List of arch-indep Kconfig using arch-defined selectors:
> 
> hw/acpi/Kconfig:42:    depends on PC
> hw/intc/Kconfig:31:    depends on ARM_GIC && KVM
> hw/intc/Kconfig:36:    depends on OPENPIC && KVM
> hw/intc/Kconfig:40:    depends on POWERNV || PSERIES
> hw/intc/Kconfig:49:    depends on XICS && KVM
> hw/intc/Kconfig:60:    depends on S390_FLIC && KVM
> hw/mem/Kconfig:11:    depends on (PC || PSERIES || ARM_VIRT)
> hw/pci-bridge/Kconfig:8:    default y if Q35
> hw/timer/Kconfig:14:    default y if PC
> hw/tpm/Kconfig:18:    depends on TPM && PC
> hw/tpm/Kconfig:24:    depends on TPM && PSERIES
> hw/vfio/Kconfig:16:    depends on LINUX && S390_CCW_VIRTIO
> hw/vfio/Kconfig:38:    depends on LINUX && S390_CCW_VIRTIO
> 

I don't think that's a problem, and also I'm not sure this patch is a
good idea.

See docs/devel/kconfig.rst: "Boards default to false; they are enabled
by the ``default-configs/*.mak`` for the target they apply to".

Paolo

