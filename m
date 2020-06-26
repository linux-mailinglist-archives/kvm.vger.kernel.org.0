Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DE420AFEB
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 12:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgFZKlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 06:41:22 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26922 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726311AbgFZKlW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Jun 2020 06:41:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593168081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HAA1tYEQvthq8kiiCAXUQaqKd3nI+j2M1lHuIgWZ290=;
        b=NyccBrYlLmbwfYzK0pOVOHKmXlZeHq8aPARGZfLwqq4awv31YCBvtpNgxlIC2orMnGiOK9
        xD21l1AqRqa1vzYcrpDfnHaALaXANt+NNEs0PeuLDsbZ46/GaLGi1fPEuRT7B0pbz6uJWC
        aizO98kIDvt7NQQEPa7RlmSesqptBqM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-HPQ3LhoqOkyuKQgkCwpUXw-1; Fri, 26 Jun 2020 06:41:19 -0400
X-MC-Unique: HPQ3LhoqOkyuKQgkCwpUXw-1
Received: by mail-wr1-f70.google.com with SMTP id d6so10232101wrn.1
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 03:41:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HAA1tYEQvthq8kiiCAXUQaqKd3nI+j2M1lHuIgWZ290=;
        b=QDsqCR5yAwjZed6fUgI34gYHjuUKwLuKcWLg0hiTMsM4h3gGpVH9N9jawpOObtqy1u
         AWuYyg9ZK1MsBJ4f6luDfX5fwdf1i/cASEvKKAvlszrjvsSm3SyBF7u0+XxWz8YFulo3
         d/vLbaWhabqFRsf3BrHJSCmRgPfO+yR//10QJdKfmo/YaKUFwIa6nJE9H6/I7DJoO7eI
         TsQyw6cai0Qe9/ABxIQ2wagelH5FDoAFPp78g9kMl4/ftmb1UGoYnjrA5T9SgI3bC0TI
         2z7HLxs+I3Oudjtf+w8HAN0tLe0C8vZpGEfhIpxlY8P2WqlseMH+WwmOKiyeXkPUCZoC
         L44A==
X-Gm-Message-State: AOAM532xBsjyQTB0p9T34T2mUAxttbQMkpAwedZdae0gfD3txdMVRkt4
        9hldAAO0DZLonO/ybTf2L2leTGLNNjmK32QBbntFJQV17N3J8gLVVASaYbV7y6T6ANxHsUkcHd3
        9whoIf6c5i/mP
X-Received: by 2002:a05:600c:60f:: with SMTP id o15mr648688wmm.30.1593168078193;
        Fri, 26 Jun 2020 03:41:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOLRxR6PAS2jnLKlyyYYc4JQ+70ysou8wbQAx8ntPCOhFsmPNng3hHXVjhtNzNBJYiWvEZEg==
X-Received: by 2002:a05:600c:60f:: with SMTP id o15mr648664wmm.30.1593168077935;
        Fri, 26 Jun 2020 03:41:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.gmail.com with ESMTPSA id c2sm36710081wrv.47.2020.06.26.03.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 03:41:17 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/3] x86: realmode: initialize idtr
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org
References: <20200626092333.2830-1-namit@vmware.com>
 <20200626092333.2830-2-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <305a746a-95d4-e5b9-9aa6-812f7acb554d@redhat.com>
Date:   Fri, 26 Jun 2020 12:41:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200626092333.2830-2-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/06/20 11:23, Nadav Amit wrote:
> The realmode test does not initialize the IDTR, assuming that its base
> is zero and its limit 0x3ff. Initialize it, as the BIOS might not set it
> as such.

Rather the bootloader: realmode.flat is started as multiboot, that is in
a 32-bit protected mode environment---which includes an IDT.

Paolo

> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  x86/realmode.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/x86/realmode.c b/x86/realmode.c
> index 234d607..ef79f7e 100644
> --- a/x86/realmode.c
> +++ b/x86/realmode.c
> @@ -1799,6 +1799,7 @@ void realmode_start(void)
>  unsigned long long r_gdt[] = { 0, 0x9b000000ffff, 0x93000000ffff };
>  
>  struct table_descr r_gdt_descr = { sizeof(r_gdt) - 1, &r_gdt };
> +struct table_descr r_idt_descr = { 0x3ff, 0 };
>  
>  asm(
>  	".section .init \n\t"
> @@ -1819,6 +1820,7 @@ asm(
>  	".text \n\t"
>  	"start: \n\t"
>  	"lgdt r_gdt_descr \n\t"
> +	"lidt r_idt_descr \n\t"
>  	"ljmp $8, $1f; 1: \n\t"
>  	".code16gcc \n\t"
>  	"mov $16, %eax \n\t"
> 

