Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA9C3DC26F
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 12:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633332AbfJRKN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 06:13:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45452 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633317AbfJRKN2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 06:13:28 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E9AEC50F63
        for <kvm@vger.kernel.org>; Fri, 18 Oct 2019 10:13:27 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id 7so2419016wrl.2
        for <kvm@vger.kernel.org>; Fri, 18 Oct 2019 03:13:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TtpeVOU0CB3Z5Pi14TfQb3eoNoka1C+7OsdVoDAEyJQ=;
        b=LJPdukgL7joLreu3JdbMYVgNnh26jqgOADsSGCiEdoIOuw5c2zBWLuSFln/J3OUb1j
         X4+QdpzZW0ixJid73JxHgYogxVUJugUQ7GcAI1KyQT8R0i+3j4iQqEaoLwvoQxd8fvJP
         5/SRNSpfCQ8q88gIv7WhLhaawzx8739Pa58GFd3VZLs7YoxaW2EMCujZFvLVeGfUW2lD
         B4JddTPRXqYwQocB+pSfVELlZ7ZjRsaM/WMYW+jqgPiW+9++Bl89u3Yas5cfnkn2JUA1
         KE42OxBrjHmJevxyff2rMR8LxD+8k6PGkDpf+4RhrofQ/AZ33CeBI7MATYqZ2WYl7sck
         Mnow==
X-Gm-Message-State: APjAAAULtDeogazhfgH4IbKIyF38q4y5NaRWXpMhC7MkklvMRCZ0UOM9
        7qeKAn/OT6fXz9TPSfAcPx14+4zRQOQC7C8NhQyDXusy7vM7HkxZtLsjcW7cQIr9cGPot76CDjD
        HQUf6LaJjEbMv
X-Received: by 2002:adf:f342:: with SMTP id e2mr7526489wrp.61.1571393606546;
        Fri, 18 Oct 2019 03:13:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz+3NzNQn9FvsIQOtta1OOWdkuNxGj4MR/rBLllahR05nKUHca1ThqhXDg1PMLWRrtb4OsFgQ==
X-Received: by 2002:adf:f342:: with SMTP id e2mr7526470wrp.61.1571393606316;
        Fri, 18 Oct 2019 03:13:26 -0700 (PDT)
Received: from [192.168.1.36] (14.red-88-21-201.staticip.rima-tde.net. [88.21.201.14])
        by smtp.gmail.com with ESMTPSA id y3sm9244642wro.36.2019.10.18.03.13.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Oct 2019 03:13:25 -0700 (PDT)
Subject: Re: [PATCH 26/32] hw/pci-host/piix: Move RCR_IOPORT register
 definition
To:     Aleksandar Markovic <aleksandar.m.mail@gmail.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paul Durrant <paul@xen.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Richard Henderson <rth@twiddle.net>
References: <20191015162705.28087-1-philmd@redhat.com>
 <20191015162705.28087-27-philmd@redhat.com>
 <CAL1e-=jVr+idQKNdOGSrODeq7XU-0JcCFTwapqk9-JvAKxk6Pw@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <e149d24f-8d77-4126-8fc8-012b114dfe37@redhat.com>
Date:   Fri, 18 Oct 2019 12:13:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAL1e-=jVr+idQKNdOGSrODeq7XU-0JcCFTwapqk9-JvAKxk6Pw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/19 11:19 AM, Aleksandar Markovic wrote:
> On Tuesday, October 15, 2019, Philippe Mathieu-Daudé <philmd@redhat.com 
> <mailto:philmd@redhat.com>> wrote:
> 
>     From: Philippe Mathieu-Daudé <f4bug@amsat.org <mailto:f4bug@amsat.org>>
> 
>     The RCR_IOPORT register belongs to the PIIX chipset.
>     Move the definition to "piix.h".
> 
>     Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com
>     <mailto:philmd@redhat.com>>
>     ---
>       hw/pci-host/piix.c            | 1 +
>       include/hw/i386/pc.h          | 6 ------
>       include/hw/southbridge/piix.h | 6 ++++++
>       3 files changed, 7 insertions(+), 6 deletions(-)
> 
> 
> Does it make sense to add prefix PIIX_ or a similar one to the register 
> name?

Good idea, it will make the comment in hw/i386/acpi-build.c:213 cleaner:

     /* The above need not be conditional on machine type because the 
reset port
      * happens to be the same on PIIX (pc) and ICH9 (q35). */
     QEMU_BUILD_BUG_ON(ICH9_RST_CNT_IOPORT != RCR_IOPORT);

> 
> In any case:
> 
> Reviewed-by: Aleksandar Markovic <amarkovic@wavecomp.com 
> <mailto:amarkovic@wavecomp.com>>

Thanks!

> 
>     diff --git a/hw/pci-host/piix.c b/hw/pci-host/piix.c
>     index 3292703de7..3770575c1a 100644
>     --- a/hw/pci-host/piix.c
>     +++ b/hw/pci-host/piix.c
>     @@ -27,6 +27,7 @@
>       #include "hw/irq.h"
>       #include "hw/pci/pci.h"
>       #include "hw/pci/pci_host.h"
>     +#include "hw/southbridge/piix.h"
>       #include "hw/qdev-properties.h"
>       #include "hw/isa/isa.h"
>       #include "hw/sysbus.h"
>     diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
>     index 183326d9fe..1c20b96571 100644
>     --- a/include/hw/i386/pc.h
>     +++ b/include/hw/i386/pc.h
>     @@ -257,12 +257,6 @@ typedef struct PCII440FXState PCII440FXState;
> 
>       #define TYPE_IGD_PASSTHROUGH_I440FX_PCI_DEVICE
>     "igd-passthrough-i440FX"
> 
>     -/*
>     - * Reset Control Register: PCI-accessible ISA-Compatible Register
>     at address
>     - * 0xcf9, provided by the PCI/ISA bridge (PIIX3 PCI function 0,
>     8086:7000).
>     - */
>     -#define RCR_IOPORT 0xcf9
>     -
>       PCIBus *i440fx_init(const char *host_type, const char *pci_type,
>                           PCII440FXState **pi440fx_state, int *piix_devfn,
>                           ISABus **isa_bus, qemu_irq *pic,
>     diff --git a/include/hw/southbridge/piix.h
>     b/include/hw/southbridge/piix.h
>     index add352456b..79ebe0089b 100644
>     --- a/include/hw/southbridge/piix.h
>     +++ b/include/hw/southbridge/piix.h
>     @@ -18,6 +18,12 @@ I2CBus *piix4_pm_init(PCIBus *bus, int devfn,
>     uint32_t smb_io_base,
>                             qemu_irq sci_irq, qemu_irq smi_irq,
>                             int smm_enabled, DeviceState **piix4_pm);
> 
>     +/*
>     + * Reset Control Register: PCI-accessible ISA-Compatible Register
>     at address
>     + * 0xcf9, provided by the PCI/ISA bridge (PIIX3 PCI function 0,
>     8086:7000).
>     + */
>     +#define RCR_IOPORT 0xcf9
>     +
>       extern PCIDevice *piix4_dev;
> 
>       DeviceState *piix4_create(PCIBus *pci_bus, ISABus **isa_bus,
>     -- 
>     2.21.0
> 
> 
