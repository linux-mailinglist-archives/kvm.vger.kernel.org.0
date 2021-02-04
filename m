Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE73D30FA7C
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 19:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbhBDR7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 12:59:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30168 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238234AbhBDR60 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 12:58:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612461420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s5YZVkjCD5/C4ET3SX6EfcYxaF5+N4XQ299/ZHaz3F4=;
        b=I4jL+vj7G8xoDeKZ60g5PjT7bv2wcnmF7X/3pkUSNWcfV39D10JWHtJPSvct4eSajX6cMp
        PSA34hDtu38MVc3MFYWmOgVOthNCU0kigeTh0SxCO+iymfw+L2/YD1O/jBfx1hbZ6zjlbg
        kqKZh/ugaRadUauxN14+fdCOr9GNwT8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-EJVXo-OQPeCnwvo8b2h4kg-1; Thu, 04 Feb 2021 12:56:56 -0500
X-MC-Unique: EJVXo-OQPeCnwvo8b2h4kg-1
Received: by mail-wr1-f71.google.com with SMTP id n18so3281238wrm.8
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 09:56:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s5YZVkjCD5/C4ET3SX6EfcYxaF5+N4XQ299/ZHaz3F4=;
        b=QG8cTtDjSQIZnQQDDgHC7/Pphw1XJh8SR49+hw7ZhxNcrYuTckAo3VUwmIy9owm1Go
         AKiD9U7GBj30ZKYdFMUWiP43P9qXGxJJcR6yPYCNP47FaVbR2dJL1nHp00ZPSkw+4Nd3
         gbcoS59iYbGYKKk9pFFLSeUYxO/k1bunrWGsmh8j0TVn/UaWPDdPRX8ZKsaGEtbQFjvl
         1kjI+8yU4e8UU/CIRLsYfau4XUsIJ/R9+VWYb170QR2FeocDwcguA5sRg95FdQBdXIRG
         hdvdaJXgbGk4gTQbWdu0nqI2Cdk/GAOePXOxm89113YpSvMxsPSOHO2Qn9h2s9CxQy0D
         pRkQ==
X-Gm-Message-State: AOAM53251PPg/WanTsaixx1lQLf2tVxaqtwrD0abciNqBhqbQdBoAx08
        ndtsvOumia/wDFvkZ6yfHHPiB+U30Ed56vMkjXgNAe51o1rrEH9wpaXLZnJRs5yC6ngJNaIXt+K
        5KWXGwbIiF4mv
X-Received: by 2002:a1c:e905:: with SMTP id q5mr335381wmc.84.1612461415359;
        Thu, 04 Feb 2021 09:56:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdM3Fux/LZYeI1PRL6P2CnPpwWo90HoYMM+BJpvd4gVKVgraKOTq986c9dJjLBOB4uFSVNNg==
X-Received: by 2002:a1c:e905:: with SMTP id q5mr335372wmc.84.1612461415198;
        Thu, 04 Feb 2021 09:56:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i7sm9116584wru.49.2021.02.04.09.56.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 09:56:54 -0800 (PST)
Subject: Re: [PATCH 07/12] KVM: x86: SEV: Treat C-bit as legal GPA bit
 regardless of vCPU mode
To:     Sean Christopherson <seanjc@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>
References: <20210204000117.3303214-1-seanjc@google.com>
 <20210204000117.3303214-8-seanjc@google.com>
 <5fa85e81a54800737a1417be368f0061324e0aec.camel@intel.com>
 <YBtZs4Z2ROeHyf3m@google.com>
 <f1d2f324-d309-5039-f4f6-bbec9220259f@redhat.com>
 <e68beed4c536712ddf28cdd8296050222731415e.camel@intel.com>
 <YBw0a5fFvtOrDwOR@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c16cbc1c-a834-edd4-bfdf-753ec07c7008@redhat.com>
Date:   Thu, 4 Feb 2021 18:56:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBw0a5fFvtOrDwOR@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/02/21 18:52, Sean Christopherson wrote:
>> Alternatively there could be something like a is_rsvd_cr3_bits() helper that
>> just uses reserved_gpa_bits for now. Probably put the comment in the wrong
>> place.  It's a minor point in any case.
> That thought crossed my mind, too.  Maybe kvm_vcpu_is_illegal_cr3() to match
> the gpa helpers?

Yes, that's certainly a good name but it doesn't have to be done now. 
Or at least, if you do it, somebody is guaranteed to send a patch after 
one month because the wrapper is useless. :)

Paolo


