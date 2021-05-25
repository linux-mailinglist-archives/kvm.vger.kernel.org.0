Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA0D38FFDD
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 13:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhEYLWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 07:22:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229819AbhEYLWQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 07:22:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621941646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=65FnAA3WH54ZOxvJt+P34jBai9dAjFV0gIwV3QSKVls=;
        b=cXxEiCs93EKlH11i1xbrVgvqF7wNr3t+qUNUNgJeyfpGdPamwgGUHo/mCKgO2CwQfiB9+9
        p3UA/leDkgCyb+ymBPQOEN/wIz0bfzLyuD8GgXTlyBJVmqI2KYSA4eYz0NwjVer+1EeomT
        hnHeiU8F3Z+tcPqORxpJD7qVQ3DKSh0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-fdvZfHQvNYiySdKY9BEoow-1; Tue, 25 May 2021 07:20:45 -0400
X-MC-Unique: fdvZfHQvNYiySdKY9BEoow-1
Received: by mail-ej1-f69.google.com with SMTP id gf21-20020a170906e215b02903dfa2e85ff7so1819761ejb.15
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 04:20:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=65FnAA3WH54ZOxvJt+P34jBai9dAjFV0gIwV3QSKVls=;
        b=aO0tcuKwcHcASAx9+k7qIfTILmCSF02dcy+QO1XSQEjApmVxA3/puZYG+sdua64od9
         tmsJf5l2PJBPSExcL5VF28PZjlw+Snft/MluZn4XVIkiQs5+RgVr+tqmmV4n77XuZZia
         MfaLDoLqB9mA0QC9mMW16dnHXMLBk4RJtUQIm4A/rQIe2CmwnH/Wqqjh6s0G/EX4a3S5
         9LjkONfg67CdCpRFMJytma+PMOc+9QooYixRZL7KMriNRMScouGo0sumN5rsqD8PD8lE
         6EuwkiVfO8e5jG7TJ05GIHlYy7Lgx+lmmSCFFn9SLso5HllrqF7z599gGX/v85sh7wNy
         zqfw==
X-Gm-Message-State: AOAM533AoWctDLdsuuP/gIIff9ulnl8fYH3w3esqAnKgQuDkMFs0iHP1
        4lEO5z4D7LfT4ZWKG3Bj0JZTqk1StuG4I8pciy+3JEQpp17ka/SZJuygj0egUEwRh2nDuBwid/A
        zdSlMAv/v9FFnbwvh25OTnirvgUhV/9NHXymH/WJBIo6Ac+KoKdRNP1kUyNHot0Cl
X-Received: by 2002:a17:906:f2ca:: with SMTP id gz10mr29046367ejb.317.1621941643899;
        Tue, 25 May 2021 04:20:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3r+S0pXgo7THwTP1FnYJEelbvKLgeE3jCcgxoX+XtNU7sI4OXaJuvOBo7CiKeI0DQuzj+Dw==
X-Received: by 2002:a17:906:f2ca:: with SMTP id gz10mr29046328ejb.317.1621941643637;
        Tue, 25 May 2021 04:20:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y27sm8948476ejf.104.2021.05.25.04.20.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 04:20:43 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] KVM: hyper-v: Advertise support for fast XMM
 hypercalls
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <cover.1618349671.git.sidcha@amazon.de>
 <33a7e27046c15134667ea891feacbe3fe208f66e.1618349671.git.sidcha@amazon.de>
 <17a1ab38-10db-4fdf-411e-921738cd94e1@redhat.com>
 <20210525085708.GA26335@uc8bbc9586ea454.ant.amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7fb8d792-e6e5-c241-6903-2a8c66fc2268@redhat.com>
Date:   Tue, 25 May 2021 13:20:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210525085708.GA26335@uc8bbc9586ea454.ant.amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/05/21 11:00, Siddharth Chandrasekaran wrote:
> Have you already picked these? Or can you still wait for v4? I can send
> send separate patches too if it is too late to drop them. I had one
> minor fixup and was waiting for Vitaly's changes to get merged as he
> wanted me to add checks on the guest exposed cpuid bits before handling
> XMM args.

You can still send v4.

Paolo

