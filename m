Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 576D95D3AF
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 17:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbfGBPzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 11:55:10 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55164 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfGBPzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 11:55:09 -0400
Received: by mail-wm1-f65.google.com with SMTP id g135so1360734wme.4
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 08:55:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v/nyHVzRNkjkeR9+rRmbl2bhoSk6yiX1HgjyGCHcOYM=;
        b=qj0DmEmEuy1XrxckdhRKB+zEl8flg4DYZM0/KQayHJEgSMJ7wcbWVIA0d49T7U7f5W
         U89oNxtAQjXrCKkbVUEkN+l/3bH3p8Q9guXITfYpjsTTrnxqJXLXhsyWHHL0mwn+oKo5
         +q4d77UoA2nPzICiQ0sS/sEPwep2QCoWjb/eltTzE7P4OXhNGxTJhZhKTY2BcgCIqe9D
         dkE0OV3jyKXFVKnfK0VxO9P153KUNEaHq6qSTbniX45iNC+HzkHEiizSNLF2fESsIr70
         TvceMITCdkrvosKwyELK5AavDQeTbYkB9QFygzT7Nj+GBstGUBbJ4ybMLGtBIuGXl8dX
         cT1Q==
X-Gm-Message-State: APjAAAWd9+Ot8my0zTKlsaSMxWiMclvh+aI7IaKRb0tT3Fuv47Wkw82r
        7LBX6G+mrnsV6HpdnU9uGLld1g==
X-Google-Smtp-Source: APXvYqw21Y0t19ZeYKXGJeBDuHKiMfMillDqTofWHZZz2kx3e1y2O1ejhaoBN7SlHr8LxpccmnmOVw==
X-Received: by 2002:a1c:9696:: with SMTP id y144mr3920754wmd.73.1562082907602;
        Tue, 02 Jul 2019 08:55:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id a64sm3775688wmf.1.2019.07.02.08.55.06
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:55:07 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Mark APR as reserved in x2APIC
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>
References: <20190625120627.8705-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <817117cb-1700-6772-14ac-7479284f00b7@redhat.com>
Date:   Tue, 2 Jul 2019 17:55:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190625120627.8705-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/19 14:06, Nadav Amit wrote:
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  lib/x86/apic.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/x86/apic.h b/lib/x86/apic.h
> index 537fdfb..b5bf208 100644
> --- a/lib/x86/apic.h
> +++ b/lib/x86/apic.h
> @@ -75,6 +75,7 @@ static inline bool x2apic_reg_reserved(u32 reg)
>  	switch (reg) {
>  	case 0x000 ... 0x010:
>  	case 0x040 ... 0x070:
> +	case 0x090:
>  	case 0x0c0:
>  	case 0x0e0:
>  	case 0x290 ... 0x2e0:
> 

Queued, thanks.

Paolo
