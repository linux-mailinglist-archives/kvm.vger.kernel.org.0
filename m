Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DD41BDA24
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 12:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgD2Kyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 06:54:45 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36008 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726519AbgD2Kyo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 06:54:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588157683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1cJOcsITeGuuFSmyQcAgzotWfzaSh5Zzyy+QRSPuMAQ=;
        b=LCtNWkBgY0tqPL41QJR/6ek4ZyyhLzU+cLNz7Qjm3+BC7FG1mo1ehUi+R7afuOwtSn0NfL
        9pdCqI1PXJAe20QI41EjqewpRviPQwYrA8eEW4xpYaOTnj/xOL7X6NLJeCmbiacja/3TBw
        DeAiimFXNytZGj5gSMJBlAxL8dHmvTw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-R4VDBfc8MI6xpurbv0R9MQ-1; Wed, 29 Apr 2020 06:54:42 -0400
X-MC-Unique: R4VDBfc8MI6xpurbv0R9MQ-1
Received: by mail-wr1-f72.google.com with SMTP id x15so1553117wrn.0
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 03:54:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1cJOcsITeGuuFSmyQcAgzotWfzaSh5Zzyy+QRSPuMAQ=;
        b=Y0nRYgMx7K+IjRS3j4L3Kw4CnjlRFDG9OFKF/Wy3yVqV21zIWmDS8X2khorkCGj/9F
         K+7BI1zztg6TYYpYMYNWBxxb49lr7OGwhRsWA/SnBMP08g6DxnuOfPdWrBrs2ta8bcLL
         7A5Gd4DeajRwlOwAiYU6D3OM+G7J2lcvd8qT8CGgXgpjt1ozMNkGgBP/sS586x0smjfW
         dNIF3u5u0Te7m5a0KADPUQNYAawOM+iDMO2RD4NIGYLCy+4+LbFauT5Dp4FJUoLnV0N9
         CniDUzWaENaCvorwfe9nrNBJLuRdwTbNvC5Uj1ZZCEB/CbHOCqPdbVm6BS1KxoOiF928
         1nrg==
X-Gm-Message-State: AGi0PuZ5FChhoNe6L90Bh5TY0v1EL/q8GKzYH6Hdt92GOS2hnNXE7RjI
        fKw4lUWCqXI3CBbYtnuIATWWS9Z/M+klWTywGhvr/BuSnDcg1XEhPxCHVlf4VYiyYgKEfq2kVkh
        gZSFBGlfUGW2l
X-Received: by 2002:a5d:694a:: with SMTP id r10mr38689762wrw.228.1588157680822;
        Wed, 29 Apr 2020 03:54:40 -0700 (PDT)
X-Google-Smtp-Source: APiQypJsj3uw9QwoYulMbmYbXR2zlrQYM4ikHzCxqwD+B6HI/f1xweUSyi8lML7WK+Ee38kRGCI1VA==
X-Received: by 2002:a5d:694a:: with SMTP id r10mr38689739wrw.228.1588157680633;
        Wed, 29 Apr 2020 03:54:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac19:d1fb:3f5f:d54f? ([2001:b07:6468:f312:ac19:d1fb:3f5f:d54f])
        by smtp.gmail.com with ESMTPSA id d5sm29819654wrp.44.2020.04.29.03.54.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 03:54:39 -0700 (PDT)
Subject: Re: [PATCH RFC 3/6] KVM: x86: interrupt based APF page-ready event
 delivery
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-4-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <546bb75a-ec00-f748-1f44-2b5299a3d3d7@redhat.com>
Date:   Wed, 29 Apr 2020 12:54:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200429093634.1514902-4-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/20 11:36, Vitaly Kuznetsov wrote:
> +
> +	Type 1 page (page missing) events are currently always delivered as
> +	synthetic #PF exception. Type 2 (page ready) are either delivered
> +	by #PF exception (when bit 3 of MSR_KVM_ASYNC_PF_EN is clear) or
> +	via an APIC interrupt (when bit 3 set). APIC interrupt delivery is
> +	controlled by MSR_KVM_ASYNC_PF2.

I think we should (in the non-RFC version) block async page faults
completely and only keep APF_HALT unless the guest is using page ready
interrupt delivery.

Paolo

