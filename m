Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D5B74CFD
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 13:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391826AbfGYLYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 07:24:30 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53887 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391814AbfGYLYa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 07:24:30 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so44645553wmj.3
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2019 04:24:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RjbdG3nViJvxOOUD7oJ8kV9hETSbuqoaOubZjfcu3IQ=;
        b=ccev3C8wX5Pen9K0NRAmNAesnFQUxAtecF2qlb+Gof6eoIVxhuuCgADExtEZZBJPda
         HMryY3czP/8AqfrJc/WGTe3combA765wHdtdgAY4PN1sj4R15yREPjKcvZ3H4R/Norhc
         gBx0zoIVLDo9RPQnfYpFQ/8tQtoYUTE5I+fJla31fDMwGfpQQ0DoIZ0otutEHv5bkhHv
         W6MGSsZUYCHzgsRviPXKmxCqvQqDCCBYecyJ99rciMWOujKzAri0L/rQS7XLZM6banOd
         44oyqWU3WkJugGhUh10FeiYr2e47qXtm0mb0XyJQzLxJsHZdVgvv1p+1ju0ItljMv2nm
         VJ0w==
X-Gm-Message-State: APjAAAX7KqQgCQMpNn4dadHpCmH3+AEWFqOcpNk8jLOIEZjbMKA1uOTa
        0es7+9mizKu8wpMLKSKgzqU1cw==
X-Google-Smtp-Source: APXvYqzdtuI6MnxEnBnPgCfGVAMefcNKRGR3/m2Mtw0Ia+Lfly9vb5NT90uj+luQR/pqs+tcN1zdRg==
X-Received: by 2002:a1c:3:: with SMTP id 3mr80318202wma.6.1564053868317;
        Thu, 25 Jul 2019 04:24:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:cc23:f353:392:d2ee? ([2001:b07:6468:f312:cc23:f353:392:d2ee])
        by smtp.gmail.com with ESMTPSA id k124sm79155642wmk.47.2019.07.25.04.24.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 04:24:27 -0700 (PDT)
Subject: Re: [PATCH stable-4.19 0/2] KVM: nVMX: guest reset fixes
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190725104645.30642-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b0ca6477-ac1e-bf92-3e3a-902243707f54@redhat.com>
Date:   Thu, 25 Jul 2019 13:24:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725104645.30642-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/07/19 12:46, Vitaly Kuznetsov wrote:
> Few patches were recently marked for stable@ but commits are not
> backportable as-is and require a few tweaks. Here is 4.19 stable backport.
> 
> Jan Kiszka (1):
>   KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested
> 
> Paolo Bonzini (1):
>   KVM: nVMX: do not use dangling shadow VMCS after guest reset
> 
>  arch/x86/kvm/vmx.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks Vitaly for helping out.

Paolo
