Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF5FE1206B3
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 14:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfLPNLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 08:11:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56115 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727782AbfLPNLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 08:11:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576501895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O9cATtB6pbYt1/J3PE5x5GGao7scjTW4c1UJnxl2UqM=;
        b=W/j+sjF6TYN3HD4fx8ALAbj/jQi14awOjjBZjpVJMyCDFKDqjlBb9MkcDEUfBkdlbe1QvA
        6ha1mukMIfHik6v2yGNHHc0E1YGVZn32EsAfHlUQb02xR7ue6Slyhxx04/dRUWSlvjAXmU
        ovHc070RgyByJludaKgXIuaF3FD/SI4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-RZ3ZNu5GMTaDeh7TLpkepg-1; Mon, 16 Dec 2019 08:11:34 -0500
X-MC-Unique: RZ3ZNu5GMTaDeh7TLpkepg-1
Received: by mail-wr1-f70.google.com with SMTP id z10so600879wrt.21
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 05:11:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O9cATtB6pbYt1/J3PE5x5GGao7scjTW4c1UJnxl2UqM=;
        b=AmfNfv6nwtDcwLFfNO5F2DOlB23ww7xoYWFZ8BoCIaNwhFFYW8uSU8QgiQibT3S5MM
         iJHKATzED9MH52pcLqwBuJ4+0RQd6c0LNtWjPseBc7t3vh5E9pjon5rdVs4fM6Hm8frS
         8inKvZ2i+z3iBWk1PxZsfQpT9gKrUz7kdJfZnm0khdY+dcOYTNkbrvdyT04+h+bHYmXf
         Vs58ENamxdgBT6OJPnyTDWxo6c7pcc3Rxyg9v93plvQKRd1BkKGKxBo/YRXLACpytxCV
         VDSX+SK6YuwVfW4OQkiEUcj//dS3kfE4ttljU8ka1QKgOqjzUMmSCXtKkakmk/26BQFQ
         bmJQ==
X-Gm-Message-State: APjAAAVMiJYU394zgZDs2+HHKNTgcOgEGdVEAUClDRYC97XlG+V2V1wA
        BOzV1FSas+a/pAvLL5omBQS1pnUYP+QfgiOP9BO/P3A/8/6rQaHDQAxyi5VB6TX1bwZIdqZYEOz
        PceGv0iIenDQ/
X-Received: by 2002:adf:df8e:: with SMTP id z14mr29964674wrl.190.1576501893619;
        Mon, 16 Dec 2019 05:11:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqzQRXuwtsErZVb6m+PpFDPU/O5P8Uccsrb7klFy/bxWKMqwMlqFrlhlnta+/vHq8ERR9JDVmQ==
X-Received: by 2002:adf:df8e:: with SMTP id z14mr29964634wrl.190.1576501893313;
        Mon, 16 Dec 2019 05:11:33 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:cde8:2463:95a9:1d81? ([2001:b07:6468:f312:cde8:2463:95a9:1d81])
        by smtp.gmail.com with ESMTPSA id b16sm22033755wrj.23.2019.12.16.05.11.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 05:11:32 -0800 (PST)
Subject: Re: [PATCH 06/12] hw/i386/ich9: Move unnecessary "pci_bridge.h"
 include
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     John Snow <jsnow@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-block@nongnu.org, Richard Henderson <rth@twiddle.net>,
        xen-devel@lists.xenproject.org, Sergio Lopez <slp@redhat.com>
References: <20191213161753.8051-1-philmd@redhat.com>
 <20191213161753.8051-7-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <622546ed-9117-0be8-1631-dfba81a9353d@redhat.com>
Date:   Mon, 16 Dec 2019 14:11:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191213161753.8051-7-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/12/19 17:17, Philippe Mathieu-Daudé wrote:
> While the ICH9 chipset is a 'South Bridge', it is not a PCI bridge.
> Nothing in "hw/i386/ich9.h" requires definitions from "pci_bridge.h"
> so move its inclusion where it is required.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  include/hw/i386/ich9.h    | 1 -
>  hw/i386/acpi-build.c      | 1 +
>  hw/pci-bridge/i82801b11.c | 1 +
>  3 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/hw/i386/ich9.h b/include/hw/i386/ich9.h
> index eeb79ac1fe..369bc64671 100644
> --- a/include/hw/i386/ich9.h
> +++ b/include/hw/i386/ich9.h
> @@ -7,7 +7,6 @@
>  #include "hw/isa/apm.h"
>  #include "hw/i386/ioapic.h"
>  #include "hw/pci/pci.h"
> -#include "hw/pci/pci_bridge.h"
>  #include "hw/acpi/acpi.h"
>  #include "hw/acpi/ich9.h"
>  #include "hw/pci/pci_bus.h"
> diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
> index 12ff55fcfb..291909fa05 100644
> --- a/hw/i386/acpi-build.c
> +++ b/hw/i386/acpi-build.c
> @@ -27,6 +27,7 @@
>  #include "qemu/bitmap.h"
>  #include "qemu/error-report.h"
>  #include "hw/pci/pci.h"
> +#include "hw/pci/pci_bridge.h"
>  #include "hw/core/cpu.h"
>  #include "target/i386/cpu.h"
>  #include "hw/misc/pvpanic.h"
> diff --git a/hw/pci-bridge/i82801b11.c b/hw/pci-bridge/i82801b11.c
> index 2b3907655b..033b3c43c4 100644
> --- a/hw/pci-bridge/i82801b11.c
> +++ b/hw/pci-bridge/i82801b11.c
> @@ -43,6 +43,7 @@
>  
>  #include "qemu/osdep.h"
>  #include "hw/pci/pci.h"
> +#include "hw/pci/pci_bridge.h"
>  #include "migration/vmstate.h"
>  #include "qemu/module.h"
>  #include "hw/i386/ich9.h"
> 

Queued, thanks.

Paolo

