Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB25416F18
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 11:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245265AbhIXJjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 05:39:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245264AbhIXJjM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 05:39:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632476259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mVdM8wYZwavHDpZYTAlDU3s7u/oPTSxSJUQT4ioHIjw=;
        b=FMCDoCI7YN8lVP2o/CXdRg0uaL+NKK3m++FVSorx2W9vWZGcEqY7Jt1ZYTsfOm5BxJrIwh
        V5EmUx8Jd6ddarLTlS8GZgMo51CMLRS8Ki0eOB3sqv2jUVwUd6u89eajoiJyZr4cUv2/V8
        KVvQcOrq4fTxaWEtHQz698YRdCB2rYU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-UXZ41NW5PRm33eqCc6_fkw-1; Fri, 24 Sep 2021 05:37:38 -0400
X-MC-Unique: UXZ41NW5PRm33eqCc6_fkw-1
Received: by mail-ed1-f72.google.com with SMTP id r11-20020aa7cfcb000000b003d4fbd652b9so9630235edy.14
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 02:37:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mVdM8wYZwavHDpZYTAlDU3s7u/oPTSxSJUQT4ioHIjw=;
        b=jDZd1us+/iP/ZT67v9mE9gKyFlCKoWj8Elo2MBkONKDGFDwNbkl/j8jgI/AhIjcmrq
         0JYb+IeWohabp5qRXXjjh6dD4CBQTKDGmWjsYXSeNC+X+UYgGK4muF4XahqxbkRnX+Lg
         eAOz02uBDWfsgYCveK0ilQHU6Ds6YTkhtjud3qmeLc2DWznJC0Omc8xbKlQFoTDIjIx2
         OP30i+wex+g2xtv8EIeklhSrcosdfje/sJ8pBtPmRUWQon97neTdiIBVu3ePgxtwza4h
         oH1Aesz9+N1vnyZiQbQ2vgNWw3egnZABF7ut9CL6swjHDtCK4fW0X8mtnEaVW6kLm824
         hGgQ==
X-Gm-Message-State: AOAM532HIjDaq23O906mchwS1uXojrUvlIe1bv0MxurffIw6v5+EZE8M
        e02dh1dMy7W6qJ44ffIb1YbUcUHT5awC8vVfKF85Du1TDopo+da6S1iAxTXeXBDF6wH4yvk45Nx
        acTNlaNEGQEqR
X-Received: by 2002:a50:9d0e:: with SMTP id v14mr4043902ede.230.1632476253386;
        Fri, 24 Sep 2021 02:37:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZkSacCqJL3tWK5hFA76keUa8bWMvZzN8g3OZcTGo6nicS6mBmBx7Xef32GZ++57QFA2Cgvw==
X-Received: by 2002:a50:9d0e:: with SMTP id v14mr4043880ede.230.1632476253230;
        Fri, 24 Sep 2021 02:37:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q6sm4703492eju.45.2021.09.24.02.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 02:37:32 -0700 (PDT)
Message-ID: <d2e2d9a3-ac72-8891-4926-2f77ef3c64f3@redhat.com>
Date:   Fri, 24 Sep 2021 11:33:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH V3 1/2] KVM: x86/mmu: Verify shadow walk doesn't terminate
 early in page faults
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <YTE3bRcZv2BiVxzH@google.com>
 <20210906122547.263316-1-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210906122547.263316-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/09/21 14:25, Lai Jiangshan wrote:
> Opportunistically use fault->goal-level instead of it.level in
> FNAME(fetch) to further clarify that KVM always installs the leaf SPTE at
> the target level.

This argument will go away when mmu_set_spte starts fishing out the 
level from the kvm_mmu_page role, but it makes a good point for now.

Paolo

