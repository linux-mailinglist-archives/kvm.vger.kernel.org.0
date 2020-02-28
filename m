Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620A2173186
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 08:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgB1HEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 02:04:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57234 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726407AbgB1HET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 02:04:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582873457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+wDK5v3JELBYbzScP70VagskcY+TULqJ1040U3p5KyU=;
        b=Ntip+hGgUQm3X/lKY9vp1x2jLOebitXXlMcUNQt5PcPSxw+9MC8IjTfw/XGeqR5RnpVkKc
        +PWMvuYmrZJY9uxKdzwl6qWy2fxGOaaBZwqTqp22Vkv3JTPix7TURycEwo9B1V/MCOFHIR
        zksSodY3Qi2ZFXVy3BRKbdfbNWZBzx8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-sup6OJoPMLuse5iwgQ6plA-1; Fri, 28 Feb 2020 02:04:15 -0500
X-MC-Unique: sup6OJoPMLuse5iwgQ6plA-1
Received: by mail-wm1-f69.google.com with SMTP id m4so768464wmi.5
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 23:04:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+wDK5v3JELBYbzScP70VagskcY+TULqJ1040U3p5KyU=;
        b=LWDTiyIpMcDiIHcyGOwF8PrAUfkAW3T0AHQoeMdL6Zvao5gfLj7sXui48YxzLU0sfc
         KA8qf21MMTTR7dBwAC49FtgVs9X1VQa89G6YVFiWzcI6qzrMWiO/TeWglXNlxSw65izh
         4CtZEu/wBx2IakSd581J3j1y1vdwFWZvrZDeCR1u1FXNA8rTRyx4tgSx1j11PhsDVHXM
         iTxhyDpbkBhEwlQNZ89Xeya9kjBDzxHHI4F2nLvFMtBFNw6iHFbgq+ssE3Bu7Xb0pLxX
         r6DmehIUbSS4NE7D+oZr7RlktCpWgkkRDCII0CMhV1HJUZeTFLp1CEVOZdsB20i7m/BH
         jStA==
X-Gm-Message-State: APjAAAXIuv9UlA1x8Xvvr5D0ACVnPOT7Bxf9GMOFzPdXQPMfRcZsRkXI
        A/rfCi/3eWodp0k7iGCgLd5bWheizqHBt2k33CVBoZQmdkfo/Z3H5aGBavnC+tBA4uqPmcUqiIc
        QYj011HEDYRfa
X-Received: by 2002:a5d:4a84:: with SMTP id o4mr3281414wrq.396.1582873454828;
        Thu, 27 Feb 2020 23:04:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqzQVZ/7fZL2ZzN/bDi6zA7jOHNwrZ0h3OSN8bKNmZ3Le37bG23FEb+zNCXuFX3S311ukX0aLA==
X-Received: by 2002:a5d:4a84:: with SMTP id o4mr3281394wrq.396.1582873454605;
        Thu, 27 Feb 2020 23:04:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:30cb:d037:e500:2b47? ([2001:b07:6468:f312:30cb:d037:e500:2b47])
        by smtp.gmail.com with ESMTPSA id o18sm6214853wrv.60.2020.02.27.23.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2020 23:04:13 -0800 (PST)
Subject: Re: [PATCH 00/61] KVM: x86: Introduce KVM cpu caps
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <87wo8ak84x.fsf@vitty.brq.redhat.com>
 <a52b3d92-5df6-39bd-f3e7-2cdd4f3be6cb@redhat.com>
 <20200228013724.GD30452@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <67038178-623d-3e66-a0e4-f57610f2a5d5@redhat.com>
Date:   Fri, 28 Feb 2020 08:04:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200228013724.GD30452@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/02/20 02:37, Sean Christopherson wrote:
>>> Would it be better or worse if we eliminate set_supported_cpuid() hook
>>> completely by doing an ugly hack like (completely untested):
>> Yes, it makes sense.
> Works for me, I'll tack it on.  I think my past self kept it because I was
> planning on using vmx_set_supported_cpuid() for SGX, which adds multiple
> sub-leafs, but I'm pretty sure I can squeeze them into kvm_cpu_caps with
> a few extra shenanigans.
> 

We can add it back for full CPUID leaves; it may even make sense to move
PT processing there (but not in this series).

Paolo

