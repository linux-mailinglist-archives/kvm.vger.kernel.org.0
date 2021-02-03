Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F124A30E155
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 18:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhBCRpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 12:45:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49779 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229731AbhBCRpE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 12:45:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612374217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FxOm0qfOZ5QeUqZ9bk91/6UdZPlXoRGgsnEFAEYrFd8=;
        b=iZGYu5qC7ftPKKNuzVbEla5qUOpjYVawTAUZW0ZHT3s0KvXs8hs+2uaQurk235LSfBjKGM
        NOON/cNqYPWhGdiA6NFeAFYo0gNqWzYXhlpUVxbz6krmEfYWEj+jNTX82eDjGD5M54YVTF
        L+K2ccEe/sMMHrLA7msGOPPLk+QWHH4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-Q5LtFXYuPp-XLp1elwq4_Q-1; Wed, 03 Feb 2021 12:43:36 -0500
X-MC-Unique: Q5LtFXYuPp-XLp1elwq4_Q-1
Received: by mail-ej1-f69.google.com with SMTP id bx12so157850ejc.15
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 09:43:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FxOm0qfOZ5QeUqZ9bk91/6UdZPlXoRGgsnEFAEYrFd8=;
        b=sW06LPQozxE2+2vybUHzsp0EMr6xLKS9tPJ6tziq95OzNskI7odcFyat+233gaiKhB
         BrcGDriaZMJG0uwwuoWBD4AzuRy4lZHMpukLzb75zQxBo8rL8vqfGOBLb1Kmy+kNFZYr
         XOcbvIAcX3Lzfly2ugutaa9XCQq/alSh1vMhA5caNlFFO+cQJlW9qDmY7kNIWb+uXiM5
         10hxIM7zwO2owqTAbKR/59ag9tmu04qwrYGLWQ67w6aNvgslmyVVcc4xBgpdTL35CPmM
         lBlO1pTOQfQVHENBxJgEsOjEO9Ede00+LrbTvwSOhIcjlnvNefdYjDbFh+Ubm4UI/3v/
         jGCA==
X-Gm-Message-State: AOAM532D9rdTa/C06A12osC3hRAUx1InIUKgRj3Izsx3e04y3osaBxor
        Jhc7K+c2dQxoKIsV1Dp4Sm8jBSozhI/bayhw1g2YjzAK/2N2q4djtxU0Ir5O9HXMGEBvacZKesf
        CUIdaPEf1T3Wh
X-Received: by 2002:a17:906:7cd8:: with SMTP id h24mr4183081ejp.511.1612374214793;
        Wed, 03 Feb 2021 09:43:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyXEqUh4gg0Bh1nnw22nR0czOY2y9xiy7RtEw61PiRhc5QN5xq9nhgJrs58247HV+BswkTifA==
X-Received: by 2002:a17:906:7cd8:: with SMTP id h24mr4183058ejp.511.1612374214638;
        Wed, 03 Feb 2021 09:43:34 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i21sm1225393edy.9.2021.02.03.09.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 09:43:33 -0800 (PST)
Subject: Re: [RFC PATCH v3 00/27] KVM SGX virtualization support
To:     Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Huang, Haitao" <haitao.huang@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <4b4b9ed1d7756e8bccf548fc41d05c7dd8367b33.camel@intel.com>
 <YBnTPmbPCAUS6XNl@google.com>
 <99135352-8e10-fe81-f0dc-8d552d73e3d3@intel.com>
 <YBnmow4e8WUkRl2H@google.com>
 <f50ac476-71f2-60d4-5008-672365f4d554@intel.com>
 <YBrfF0XQvzQf9PhR@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <475c5f8b-efb7-629d-b8d2-2916ee150e4f@redhat.com>
Date:   Wed, 3 Feb 2021 18:43:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBrfF0XQvzQf9PhR@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/21 18:36, Sean Christopherson wrote:
> I'm not at all opposed to preventing KVM from accessing EPC, but I 
> really don't want to add a special check in KVM to avoid reading EPC. 
> KVM generally isn't aware of physical backings, and the relevant KVM 
> code is shared between all architectures.

Yeah, special casing KVM is almost always the wrong thing to do. 
Anything that KVM can do, other subsystems will do as well.

Paolo

