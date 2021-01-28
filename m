Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E18C307168
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 09:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhA1IZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 03:25:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34721 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231623AbhA1IZl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 03:25:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611822255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=86GGfjuYM3AI7mr7QU3sHTo8h+wDitIDwwAKJzsDkt4=;
        b=jVFZJXzar1VHdyDormgxxOK2X9zq4OA9ZzTTNhxjZHdSD6Y7DY7wTayVM1DamIBQpo7ezo
        FzqX7RjOndQSq7Oyn/KNUO0rAPulEmCLiGST5vadNU7pwvlCvIXdfjHK7ubtQA/Namm4bw
        48arkLphk68HDCr/qBHv45eELxq1h5g=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-LH4n-wnlP--FlTjKSh6pTQ-1; Thu, 28 Jan 2021 03:24:13 -0500
X-MC-Unique: LH4n-wnlP--FlTjKSh6pTQ-1
Received: by mail-ej1-f72.google.com with SMTP id by20so1849314ejc.1
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 00:24:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=86GGfjuYM3AI7mr7QU3sHTo8h+wDitIDwwAKJzsDkt4=;
        b=eKTzTAQajflb8EfLsl4gkdD3bLCmu24ifx+fVGr08l2kf1cLvjabyFtkFXO2owPUQ3
         fLTsuENVdVThG0GTupmc6MPlQNyD/x4aZhsE59wCXxEdTWLiAp+Zjaq7qox9+hGrnOHK
         zHthTPkd1ykoZYKeqXcTirNFo0w0zBUVC+ub0x/moaxup90LIgYavy17Wcbs7jkIT/s/
         0vd0NrTqieFjugEWfLw0972bxFU4g+g5lj4orEjKeGAR/4j4vlwOk68Jb5jvLy/xYmY/
         wGnDSClrS2h427+bPaFN06LyBlO+E2qVTAs5u8OskZhgn6B5y1E9eH8r3YYcestjfzeU
         ti0Q==
X-Gm-Message-State: AOAM531S+ceAMuxhpdJoQf8R3qbXJ6xu0xuyQT/gB7bykVGwLHG71fPJ
        aJi73ttByXT8+XLNtO+fJwWN94EfIT+M2HBsUlwd30KxpvIJ0t8B0UBI/Asrre7az6ypPxKLIL8
        8qojz+l8m3Zk/
X-Received: by 2002:a50:fc97:: with SMTP id f23mr13618233edq.307.1611822252285;
        Thu, 28 Jan 2021 00:24:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzKeyRQU9dTdlY4Nl3GONGetNGeiPQr74OAYJp5BcB/yhphlMwTsYUn9nYqkvL8aFBxIUZZSg==
X-Received: by 2002:a50:fc97:: with SMTP id f23mr13618213edq.307.1611822252108;
        Thu, 28 Jan 2021 00:24:12 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t11sm2496533edd.1.2021.01.28.00.24.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 00:24:11 -0800 (PST)
Subject: Re: [PATCH] KVM: x86/mmu: Add '__func__' in rmap_printk()
To:     Joe Perches <joe@perches.com>,
        Stephen Zhang <stephenzhangzsd@gmail.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1611713325-3591-1-git-send-email-stephenzhangzsd@gmail.com>
 <244f1c7f-d6ca-bd7c-da5e-8da3bf8b5aee@redhat.com>
 <cfb3699fc03cff1e4c4ffe3c552dba7b7727fa09.camel@perches.com>
 <854ee6dc-2299-3897-c4af-3f7058f195af@redhat.com>
 <10805faed4d19ce842cef277b74479a883514afe.camel@perches.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <409943d7-5917-9269-98eb-1a9ca704fda3@redhat.com>
Date:   Thu, 28 Jan 2021 09:24:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <10805faed4d19ce842cef277b74479a883514afe.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/01/21 19:28, Joe Perches wrote:
> It's not enabled unless DEBUG is defined (and it's not enabled by default)
> or CONFIG_DYNAMIC_DEBUG is enabled and then dynamic_debug jump points are
> used when not enabled so I think any slowdown, even when dynamic_debug is
> enabled is trivial.

Ah, I confused DEBUG with CONFIG_DEBUG_KERNEL.  I'll post a patch, thanks!

Paolo

