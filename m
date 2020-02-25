Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57D9816E9D3
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 16:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbgBYPRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 10:17:30 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36252 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730616AbgBYPR3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 10:17:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582643848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b/yFAqfpxVmH5UTQfRfW6zAd8tz7j2iw367lWQfVNPk=;
        b=AXBsPQorYB1F3aL9JYgnf6dcwwkSQpXVhWE1AyPsGX2soRAxymVOUcKHcag3Hq04TfZbX8
        r6MtEdD7DhfG2qzRKhWcWe4QKgba8VLSFk2yT7uVr7iJ4z+q7gv6NXcORRUvn1kp98fHzt
        IIUN2u0146Y8l6o/w+ngacLz8bsaPwI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-ulCYYpBiPOeItAP2Sg9s5A-1; Tue, 25 Feb 2020 10:17:26 -0500
X-MC-Unique: ulCYYpBiPOeItAP2Sg9s5A-1
Received: by mail-wm1-f69.google.com with SMTP id f207so991925wme.6
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 07:17:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b/yFAqfpxVmH5UTQfRfW6zAd8tz7j2iw367lWQfVNPk=;
        b=H31xycmkuVzHm8CgDzLLQErnkl+vH0EHYujGhX3DuOQ7NZ5OR3USUKZeare8La2fbs
         i1eGQpM0JIXnYpEgEaOQ5WO05X243yDkKFwTe3cWXYu0Dd4Ixe/7iCNWSgLepGxrf9CJ
         d/8mU5QIOfDBpCFKr6p3sAiP3TLdOtwEY/876sGUNC3zjcJMXRIzMpgVDP2GQ1GuJNAK
         vFZJ1s2pdlYt2Zv1u05oEh3efhjkem+6rx5PlYo7TMULRX88Qx0AYNqMV7wBDxhtnemS
         q4bSqMBRButRGwoc8uDJvprFu1cjM8pSBI2X1ake21z6cXHnrGqSbaX2t+H+eNsHkZal
         1nMA==
X-Gm-Message-State: APjAAAWQRf5J1BmtfDyx9x+7Sd3bl9wij/l0gOlcFiEsCovL9zq0g64c
        5LOQEdDtyVTusbEXHE9AUs0PcYP6o1lK5PI0qlFkDz45RVYauPnNI2KARk4SaiYZBeAKqfd5BBS
        YwlJgmtYxT1VA
X-Received: by 2002:a7b:ce8b:: with SMTP id q11mr5936230wmj.100.1582643845564;
        Tue, 25 Feb 2020 07:17:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqwnv2zkbFggigvr5DyT5aMoH4G11gKX7bHhsbezuWPB5EkRH1YMqErhxeP/eJJb9QJJcdcNjA==
X-Received: by 2002:a7b:ce8b:: with SMTP id q11mr5936205wmj.100.1582643845295;
        Tue, 25 Feb 2020 07:17:25 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:3577:1cfe:d98a:5fb6? ([2001:b07:6468:f312:3577:1cfe:d98a:5fb6])
        by smtp.gmail.com with ESMTPSA id e1sm23938141wrt.84.2020.02.25.07.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 07:17:24 -0800 (PST)
Subject: Re: [PATCH 47/61] KVM: x86: Squash CPUID 0x2.0 insanity for modern
 CPUs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-48-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <21b4346e-def0-9343-3368-e81b89ffb152@redhat.com>
Date:   Tue, 25 Feb 2020 16:17:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200201185218.24473-48-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/20 19:52, Sean Christopherson wrote:
> Although it's _extremely_ tempting to yank KVM's stateful code, leave it
> in for now but annotate all its code paths as "unlikely".  The code is
> relatively contained, and if by some miracle there is someone running KVM
> on a CPU with a stateful CPUID 0x2, more power to 'em.

I suppose the only way that could happen is with nested virtualization.
 I would just drop it.

Paolo

