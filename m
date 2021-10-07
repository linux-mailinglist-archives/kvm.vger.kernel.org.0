Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB0C425802
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241144AbhJGQeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:34:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32778 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233594AbhJGQeS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:34:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633624343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wcPwfok7hlWw1u9zFYAktsrSD7Ftvy7NI8EcJaCkDRQ=;
        b=ZbWrX8BhnuZfcW2MKvWY+TPM3fuHC2B0tKRMdKosGa6YUsbg7sArw8dmbgP5XR3ObPQVWD
        ceh/VihLt3ArYZy/XU+dKjPV4z0KmVYe6D+7zDtr6kssyzKIo/qMwfDR6bxePZxifd9Ce5
        ps41O9IkVFN5VOBQq3rzBEKcXkeXXgk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-6sF5ifgAN8qXdQLGjwClBQ-1; Thu, 07 Oct 2021 12:32:22 -0400
X-MC-Unique: 6sF5ifgAN8qXdQLGjwClBQ-1
Received: by mail-wr1-f72.google.com with SMTP id v15-20020adfa1cf000000b00160940b17a2so5148052wrv.19
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:32:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=wcPwfok7hlWw1u9zFYAktsrSD7Ftvy7NI8EcJaCkDRQ=;
        b=A9yBB3tKdVpFPBwIr61Z+P6itRgqTbiBPmjUVXLlyUpKWq9UKY7v1KfVy4rmPEG8Aa
         R0wXid8E0su/IMRNAx/bBolCSYHqJCsCb0yov7KKcKloBsTgyW59illd6M1sNCSpDUU3
         Xuia50OJlU3LQF2lOj1V4x43ImbyMlHj/f1FykdvrkwvGCiX4hpPeHB6sOE3fmP8hpgY
         iwAZlTqq2IkABmJdzpKg+4OLe+35t1B1NcL3owm0lWO1dx5fY5sOuo//HYxIZaqc7CB/
         aypU9ZmrCzUT/ANxidbl8V+Ke9V0xrfF5vA76BTfc/x2Gnftjx71Um/uZ+a0+aumHI7A
         fDww==
X-Gm-Message-State: AOAM531lMxHUUJlkLpyJjLinAVZA2ZUN5vpnTwpw1ex/ZZAxvME8Mu3z
        e13iU3TKhO38Lz6lvOLFCwYZ5Mwvomu3LFgPpev3z4pe0EDTz4bQa0gyH5sk3CZRa6k7Rp9y7Ob
        D4Q5yy+5m4tJK
X-Received: by 2002:adf:a294:: with SMTP id s20mr6769417wra.34.1633624341053;
        Thu, 07 Oct 2021 09:32:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbefLzTot1ul3sotoGqiNbncTZrWTQb+yZf5dmOIwZNZOKtNSfLr3kHeEsTzv/598ehu+SmA==
X-Received: by 2002:adf:a294:: with SMTP id s20mr6769386wra.34.1633624340838;
        Thu, 07 Oct 2021 09:32:20 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id j1sm101316wrb.56.2021.10.07.09.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:32:20 -0700 (PDT)
Date:   Thu, 7 Oct 2021 17:32:18 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
Subject: Re: [PATCH v4 14/23] target/i386/sev: Rename sev_i386.h -> sev.h
Message-ID: <YV8hEmSI3Yyociat@work-vm>
References: <20211007161716.453984-1-philmd@redhat.com>
 <20211007161716.453984-15-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211007161716.453984-15-philmd@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Philippe Mathieu-Daudé (philmd@redhat.com) wrote:
> SEV is a x86 specific feature, and the "sev_i386.h" header
> is already in target/i386/. Rename it as "sev.h" to simplify.
> 
> Patch created mechanically using:
> 
>   $ git mv target/i386/sev_i386.h target/i386/sev.h
>   $ sed -i s/sev_i386.h/sev.h/ $(git grep -l sev_i386.h)
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  target/i386/{sev_i386.h => sev.h} | 0
>  hw/i386/x86.c                     | 2 +-
>  target/i386/cpu.c                 | 2 +-
>  target/i386/kvm/kvm.c             | 2 +-
>  target/i386/monitor.c             | 2 +-
>  target/i386/sev-stub.c            | 2 +-
>  target/i386/sev-sysemu-stub.c     | 2 +-
>  target/i386/sev.c                 | 2 +-
>  8 files changed, 7 insertions(+), 7 deletions(-)
>  rename target/i386/{sev_i386.h => sev.h} (100%)
> 
> diff --git a/target/i386/sev_i386.h b/target/i386/sev.h
> similarity index 100%
> rename from target/i386/sev_i386.h
> rename to target/i386/sev.h
> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> index 0c7c054e3a0..76de7e2265e 100644
> --- a/hw/i386/x86.c
> +++ b/hw/i386/x86.c
> @@ -47,7 +47,7 @@
>  #include "hw/i386/fw_cfg.h"
>  #include "hw/intc/i8259.h"
>  #include "hw/rtc/mc146818rtc.h"
> -#include "target/i386/sev_i386.h"
> +#include "target/i386/sev.h"
>  
>  #include "hw/acpi/cpu_hotplug.h"
>  #include "hw/irq.h"
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index b54b98551e9..8289dc87bd5 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -26,7 +26,7 @@
>  #include "sysemu/reset.h"
>  #include "sysemu/hvf.h"
>  #include "kvm/kvm_i386.h"
> -#include "sev_i386.h"
> +#include "sev.h"
>  #include "qapi/error.h"
>  #include "qapi/qapi-visit-machine.h"
>  #include "qapi/qmp/qerror.h"
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index f25837f63f4..a5f6ff63c81 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -28,7 +28,7 @@
>  #include "sysemu/kvm_int.h"
>  #include "sysemu/runstate.h"
>  #include "kvm_i386.h"
> -#include "sev_i386.h"
> +#include "sev.h"
>  #include "hyperv.h"
>  #include "hyperv-proto.h"
>  
> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
> index ea836678f51..109e4e61c0a 100644
> --- a/target/i386/monitor.c
> +++ b/target/i386/monitor.c
> @@ -32,7 +32,7 @@
>  #include "sysemu/kvm.h"
>  #include "sysemu/sev.h"
>  #include "qapi/error.h"
> -#include "sev_i386.h"
> +#include "sev.h"
>  #include "qapi/qapi-commands-misc-target.h"
>  #include "qapi/qapi-commands-misc.h"
>  #include "hw/i386/pc.h"
> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
> index 170e9f50fee..7e8b6f9a259 100644
> --- a/target/i386/sev-stub.c
> +++ b/target/i386/sev-stub.c
> @@ -13,7 +13,7 @@
>  
>  #include "qemu/osdep.h"
>  #include "qapi/error.h"
> -#include "sev_i386.h"
> +#include "sev.h"
>  
>  bool sev_enabled(void)
>  {
> diff --git a/target/i386/sev-sysemu-stub.c b/target/i386/sev-sysemu-stub.c
> index d556b4f091f..8082781febf 100644
> --- a/target/i386/sev-sysemu-stub.c
> +++ b/target/i386/sev-sysemu-stub.c
> @@ -14,7 +14,7 @@
>  #include "qemu/osdep.h"
>  #include "qapi/qapi-commands-misc-target.h"
>  #include "qapi/error.h"
> -#include "sev_i386.h"
> +#include "sev.h"
>  
>  SevInfo *sev_get_info(void)
>  {
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 5cbbcf0bb93..e43bbf3a17d 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -25,7 +25,7 @@
>  #include "qemu/uuid.h"
>  #include "crypto/hash.h"
>  #include "sysemu/kvm.h"
> -#include "sev_i386.h"
> +#include "sev.h"
>  #include "sysemu/sysemu.h"
>  #include "sysemu/runstate.h"
>  #include "trace.h"
> -- 
> 2.31.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

