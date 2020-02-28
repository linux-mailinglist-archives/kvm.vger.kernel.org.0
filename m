Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC3017356B
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 11:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgB1Khj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 05:37:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32795 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726614AbgB1Khj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 05:37:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582886259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mt6Lbh5dkQYRs/xWyErDmgV7Bs1CQ+l7mA9OrMtPMT8=;
        b=F2A2q3esQcNxQw3dDX9SeYex9dj1IW3fVPP07J7raSv4HpAWPBcrWgLESr2xBigYg6cTqC
        n2ax8SttoV0QTmCdExjuXefeXkYQl/Dfseq6r/vXLj2xAoH0Gy33OSfaRJ5W7wkFT1acT5
        n27jZVwyhmAaU6cTk/3UVtxgDZrpKlw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-5yWVxh7fM7iUzN5gpSoXiQ-1; Fri, 28 Feb 2020 05:37:37 -0500
X-MC-Unique: 5yWVxh7fM7iUzN5gpSoXiQ-1
Received: by mail-wr1-f71.google.com with SMTP id f10so1164042wrv.1
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 02:37:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mt6Lbh5dkQYRs/xWyErDmgV7Bs1CQ+l7mA9OrMtPMT8=;
        b=fneFWyuOkqvuSBbTQ7eL00HXSNu05Ktj1w3V5l3Axzbj0I4qwBK1zib06dVoGNoJSk
         iQcQe6tjtNQr705ejgbbgCHA6Yl+JqkPTazsbkAbP7Tm5tHGoGYANB7GY6Exl5dbRzi3
         od5u0wuaakF33QeHFBtny5nhlr8BKaToQEG2Bi3cAF9T21Q2ueZkJtK1En2H2w46J6HG
         aJZv5dQq1BIXt6Yp8eywjcypY1klqLByxt1sHR1wfCif7v3j3KZomNNP/rI5Arsnmg8y
         etOXB4C1HpIEL3aMjVP0/ypIm6W5DdBUnF7EkEaF4SgxOBI89Mjs5NK3uROxE2qzZor8
         P9CA==
X-Gm-Message-State: APjAAAU7RUu+qUMk7L9cv+CgOcli1qeNUpqGRC+TERzPAKJDmwuM2eDF
        0/W5sfWd+LYzAdMYme/6jpYWlyLO5zE+mFWYG14kR0CZsu74/weewblGFZA+I+G2oRW9yCpTuxQ
        2glNwHjALYjCa
X-Received: by 2002:a7b:c119:: with SMTP id w25mr4365874wmi.112.1582886256423;
        Fri, 28 Feb 2020 02:37:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqxO68+fSfsLzIp2GguTwy+MpiSH4P0lBmHz7MUOl2WGlMyLbizhSUbzh/reh6bCAI4UPdib8A==
X-Received: by 2002:a7b:c119:: with SMTP id w25mr4365851wmi.112.1582886256129;
        Fri, 28 Feb 2020 02:37:36 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:d0d9:ea10:9775:f33f? ([2001:b07:6468:f312:d0d9:ea10:9775:f33f])
        by smtp.gmail.com with ESMTPSA id y7sm15045583wmd.1.2020.02.28.02.37.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 02:37:35 -0800 (PST)
Subject: Re: [PATCH v2] kvm: x86: Limit the number of "kvm: disabled by bios"
 messages
To:     Erwan Velu <erwanaliasr1@gmail.com>
Cc:     Erwan Velu <e.velu@criteo.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20200214143035.607115-1-e.velu@criteo.com>
 <20200227180047.53888-1-e.velu@criteo.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dbcda2fb-2062-acdc-af03-fad5d667a742@redhat.com>
Date:   Fri, 28 Feb 2020 11:37:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200227180047.53888-1-e.velu@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/02/20 19:00, Erwan Velu wrote:
> In older version of systemd(219), at boot time, udevadm is called with :
> 	/usr/bin/udevadm trigger --type=devices --action=add"
> 
> This program generates an echo "add" in /sys/devices/system/cpu/cpu<x>/uevent,
> leading to the "kvm: disabled by bios" message in case of your Bios disabled
> the virtualization extensions.
> 
> On a modern system running up to 256 CPU threads, this pollutes the Kernel logs.
> 
> This patch offers to ratelimit this message to avoid any userspace program triggering
> this uevent printing this message too often.
> 
> This patch is only a workaround but greatly reduce the pollution without
> breaking the current behavior of printing a message if some try to instantiate
> KVM on a system that doesn't support it.
> 
> Note that recent versions of systemd (>239) do not have trigger this behavior.
> 
> This patch will be useful at least for some using older systemd with recent Kernels.
> 
> Signed-off-by: Erwan Velu <e.velu@criteo.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 359fcd395132..c8a90231befe 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7308,12 +7308,12 @@ int kvm_arch_init(void *opaque)
>  	}
>  
>  	if (!ops->cpu_has_kvm_support()) {
> -		printk(KERN_ERR "kvm: no hardware support\n");
> +		pr_err_ratelimited("kvm: no hardware support\n");
>  		r = -EOPNOTSUPP;
>  		goto out;
>  	}
>  	if (ops->disabled_by_bios()) {
> -		printk(KERN_ERR "kvm: disabled by bios\n");
> +		pr_err_ratelimited("kvm: disabled by bios\n");
>  		r = -EOPNOTSUPP;
>  		goto out;
>  	}
> 

Queued, thanks.

Paolo

