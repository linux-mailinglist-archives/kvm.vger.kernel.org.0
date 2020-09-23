Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCB2275825
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 14:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgIWMox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 08:44:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726574AbgIWMow (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 08:44:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600865091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2zhUb9o8dmSTPl1fvZJjR7IlhrbCzI/VzKj45MO8cQo=;
        b=DkzHMk6ndRsBPXFDJbYtTYFszXyQM6nFmgWrC4XL339w5FET+sirksM8gdZtIBcGsZ+JpE
        oCp0mTc7mSTUjnlFVP2dSB7hy4fblTMZZDOe7hbrrxSuzFlCKGACrgYEEEagTi+K90ZY68
        yCtBV0QzN21Vo9O5CqqDuV+PwDV+1gI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-ErBTaUtdM9yJ9nn--yFEbQ-1; Wed, 23 Sep 2020 08:44:49 -0400
X-MC-Unique: ErBTaUtdM9yJ9nn--yFEbQ-1
Received: by mail-wm1-f69.google.com with SMTP id a7so2189077wmc.2
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 05:44:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2zhUb9o8dmSTPl1fvZJjR7IlhrbCzI/VzKj45MO8cQo=;
        b=IbWWaG/hva3Wd3ZsAeXn74qoELynwEFCHSpThBtpw6l0+aPwrQKfqnjZDMnHDh+qRH
         KArdfVvfv00x+f3zzuXngHq/7+FbaxkvkRKETWsPgR62PBdF4CV0+yg29NKDXxvj9PSa
         zGyqe5yd+iBOUlYiN4HDmKFKUCGWkVDpprXU7v2gbts7WGOlyVreGjWZAvuwYXqHQC4i
         bun+TnK5fhielLZ88Mvhs5V6aTHEOViLZjhhmywc+bLS9cj5POS7yQRsjrFGUuSCjFpe
         nt3GsXMjdDhpSjjGu/Tn8/9VIXSqyFDovzXneAC0Nr/q7QEfQVTUkoiPY9k0QQz/SRG4
         XrwA==
X-Gm-Message-State: AOAM532JMga17xJb+PPC8RlgaZ8MBRJcXIdsoX99v4M+VCKZRqM4i1Os
        WinEcIT/IuhKDVfnYjyG8Pau/35CJX9ByIlX4TcVDZ7aXMWQTFWk5rdez80Z8dB3XSnnCiAE0Se
        h3pGaKcPh7LKI
X-Received: by 2002:a1c:66c4:: with SMTP id a187mr6181414wmc.148.1600865087989;
        Wed, 23 Sep 2020 05:44:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyILtNWqnwQPNgzbrGn9kDtMaRXs25v9O+ykJGDejagoPmt1CBv53o2UpYfKbNOtsCDbmuZgw==
X-Received: by 2002:a1c:66c4:: with SMTP id a187mr6181406wmc.148.1600865087769;
        Wed, 23 Sep 2020 05:44:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id w7sm441258wmc.43.2020.09.23.05.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 05:44:46 -0700 (PDT)
Subject: Re: [PATCH] kvm: Correct documentation of kvm_irqchip_*()
To:     Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200922203612.2178370-1-ehabkost@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d42b6ba7-34cc-4d48-96c3-6d676fde24cb@redhat.com>
Date:   Wed, 23 Sep 2020 14:44:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922203612.2178370-1-ehabkost@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/20 22:36, Eduardo Habkost wrote:
> When split irqchip support was introduced, the meaning of
> kvm_irqchip_in_kernel() changed: now it only means the LAPIC is
> in kernel.  The PIC, IOAPIC, and PIT might be in userspace if
> irqchip=split was set.  Update the doc comment to reflect that.
> 
> While at it, remove the "the user asked us" part in
> kvm_irqchip_is_split() doc comment.  That macro has nothing to do
> with existence of explicit user-provided options.
> 
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
>  include/sysemu/kvm.h | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 5bbea538830..23fce48b0be 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -51,23 +51,22 @@ extern bool kvm_msi_use_devid;
>  /**
>   * kvm_irqchip_in_kernel:
>   *
> - * Returns: true if the user asked us to create an in-kernel
> - * irqchip via the "kernel_irqchip=on" machine option.
> + * Returns: true if an in-kernel irqchip was created.
>   * What this actually means is architecture and machine model
> - * specific: on PC, for instance, it means that the LAPIC,
> - * IOAPIC and PIT are all in kernel. This function should never
> - * be used from generic target-independent code: use one of the
> - * following functions or some other specific check instead.
> + * specific: on PC, for instance, it means that the LAPIC
> + * is in kernel.  This function should never be used from generic
> + * target-independent code: use one of the following functions or
> + * some other specific check instead.
>   */
>  #define kvm_irqchip_in_kernel() (kvm_kernel_irqchip)
>  
>  /**
>   * kvm_irqchip_is_split:
>   *
> - * Returns: true if the user asked us to split the irqchip
> - * implementation between user and kernel space. The details are
> - * architecture and machine specific. On PC, it means that the PIC,
> - * IOAPIC, and PIT are in user space while the LAPIC is in the kernel.
> + * Returns: true if the irqchip implementation is split between
> + * user and kernel space.  The details are architecture and
> + * machine specific.  On PC, it means that the PIC, IOAPIC, and
> + * PIT are in user space while the LAPIC is in the kernel.
>   */
>  #define kvm_irqchip_is_split() (kvm_split_irqchip)
>  
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

