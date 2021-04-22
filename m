Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026E4367E5D
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 12:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbhDVKMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 06:12:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25636 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230285AbhDVKMh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 06:12:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619086322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+aeiQ2wP3MQzn5UUW9bu6SAY99XMK2mlrjIQFoCkleU=;
        b=DuY0cR5gxda3iWP8KK/sTlL1JzV1I6uJd44bVidN3eAdZAqF67QDFTB28KgbcctMZRq6V6
        hEXqXe7dM0J+WXZbRvo+158hOnzOwzxn0sT0SPNLKt9VTZX9kGuYvD9xvVZlkuIHA3eUvf
        ZmapCk260dIZxUJ7MPBzPcpVF5a0oOs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-l4-X5YYjPOee27xCkapHsA-1; Thu, 22 Apr 2021 06:11:46 -0400
X-MC-Unique: l4-X5YYjPOee27xCkapHsA-1
Received: by mail-ed1-f70.google.com with SMTP id c13-20020a05640227cdb0290385526e5de5so6411443ede.21
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 03:11:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+aeiQ2wP3MQzn5UUW9bu6SAY99XMK2mlrjIQFoCkleU=;
        b=sky8m7v6NoC3MChaegDWtzLZCIIvmkZfsW2DY9JYOeZmaajEdvoq+leohCo65QIQrP
         aRlul5RPca6X0xyEwVy6hoJq/OSvOPF7EzsswotvnvJrRh8fysLLM0OvSjrRitFhZpnz
         wndcjCdImIxPK1INdg+p7BQ6kUeAPLOc2omBWdeXY9mBSQRQpa7bmBCeXiBHvDFqgLTE
         AIQaWNrj30SKaRTbb5xUxLFk0JztPH8M0rYbPqeiOYJKdzveE9ThdueNU7T5o6aDKcDq
         1xdal8O0sfiMAv5HEOdYvKEwM7rnZbsfzP6rnfWpFTVzPjyRfRdO/NVx+M2GBISf+Vlq
         Stew==
X-Gm-Message-State: AOAM531W+kaNYzlelkluY6HqzDt5zA9M3edeA5FgYT2HbQnD62ri8sa5
        aW5J/OWtS1Aj2xttN35/aRj60waN+zoZ0oHZQxJ/yH3HCZPM8Ss8wW9txnxwgnhmZliNCEGh2Ie
        ahTgrDLtJGJij8DVQyf5XoIu6FiECJHGDDpvBhLUFj/XO9rwzUBQnk1MBaVk+7pmG
X-Received: by 2002:a50:ed10:: with SMTP id j16mr2825224eds.29.1619086304730;
        Thu, 22 Apr 2021 03:11:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDuQ++8RqrXPHVrR03Lo/QGDIq9bdoT/SJAvgjk8HXEn4lLbotRazLnq//1RMmM04vbUSd1w==
X-Received: by 2002:a50:ed10:: with SMTP id j16mr2825208eds.29.1619086304520;
        Thu, 22 Apr 2021 03:11:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a21sm1568992ejk.15.2021.04.22.03.11.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 03:11:43 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 03/14] x86: msr: Advertise GenuineIntel as
 vendor to play nice with SYSENTER
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20210422030504.3488253-1-seanjc@google.com>
 <20210422030504.3488253-4-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9d9c3e07-ac69-7236-e58c-d4623a23a3a6@redhat.com>
Date:   Thu, 22 Apr 2021 12:11:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210422030504.3488253-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 05:04, Sean Christopherson wrote:
> Run msr.flat as vendor GenuineIntel so that KVM SVM will intercept
> SYSENTER_ESP and SYSENTER_EIP in order to preserve bits 63:32.
> Alternatively, this could be handled in the test, but fudging the
> config is easier and it also adds coverage for KVM's aforementioned
> emulation.

Oops, I actually had a patch for this but forgot to send it.  I'll queue 
yours instead.

Paolo

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   x86/unittests.cfg | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 0698d15..c2608bc 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -167,7 +167,10 @@ extra_params = -cpu max
>   arch = x86_64
>   
>   [msr]
> +# Use GenuineIntel to ensure SYSENTER MSRs are fully preserved, and to test
> +# SVM emulation of Intel CPU behavior.
>   file = msr.flat
> +extra_params = -cpu qemu64,vendor=GenuineIntel
>   
>   [pmu]
>   file = pmu.flat
> 

