Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B2E1A83E6
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 17:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732398AbgDNP5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 11:57:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52354 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387417AbgDNP5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 11:57:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586879830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+YYLNoHPS0R9msE++qaePEk7EKWnckmMQYzoCYqpJRk=;
        b=bgjArxnpbMoIRZl7u1dPldBVCHFegTIn/m8rOBEfyyeSLp5IajLTGMSXIe+aABYQsKcpUK
        JsqNxp86ludsnyhr0ntc84MhZaEnpUTiKd26iohjV3/FNkZmueEPi2f3HFTANfa6+Szlx0
        J1QJs9gYRMUZW41aX+al9YknWQw+TBM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-XMQRv82jPWSHl9ejeeOUoQ-1; Tue, 14 Apr 2020 11:57:09 -0400
X-MC-Unique: XMQRv82jPWSHl9ejeeOUoQ-1
Received: by mail-wm1-f71.google.com with SMTP id o5so4456496wmo.6
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 08:57:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+YYLNoHPS0R9msE++qaePEk7EKWnckmMQYzoCYqpJRk=;
        b=CPBpxfH6xd4zRWsrvo+VLyDOXpEK4hhTjDPnJQtCRj2jL+rJj5Q4K2Coin/A/sbUfd
         pWOi6ZwsbWSup5M01j/O3YR17A0okSNAruN4mF3mNf/33X3F93+DoIimrDLZD3fE7nw9
         er0Nr+RvJAtdWCL7branpCXL8P1xiyEZoUCGyQ+U20Narpptz+OVeK3lPfXNMVuURgSX
         gsPyHVwFIreoaFVEbMy+LW2ORpc0tNJmLPoej0nUIG0UXqALYHqqXX4figwnuVUbDmuF
         VkbUuDHwO2BMaRRwKe5qYuMmJeEyWBxydmShB4VqHXrjgzLpkkY5bO47KnJXsbv1NJRW
         s6DQ==
X-Gm-Message-State: AGi0Pub+NRFdV/uZH4VqIb3Hnp9E0Xa2iYwB4s1qNNuDKtet78/Dw2vi
        6S1nSwECx4fbD/bT6OAwdwDBwMcEOHRCtXSWtTKuygvZhaEJTAKmg7y0iyN1LAgSKo9thO8hp/1
        lhQ9nBCQ937BY
X-Received: by 2002:a1c:5502:: with SMTP id j2mr502962wmb.93.1586879825170;
        Tue, 14 Apr 2020 08:57:05 -0700 (PDT)
X-Google-Smtp-Source: APiQypK43hPUptF5L9yvQziVzJGJV/VyMhS23tlGH7dzBh06iijjr98+S1d6K1K1pTXXFtXi18cgZQ==
X-Received: by 2002:a1c:5502:: with SMTP id j2mr502914wmb.93.1586879824909;
        Tue, 14 Apr 2020 08:57:04 -0700 (PDT)
Received: from localhost.localdomain ([194.230.155.210])
        by smtp.gmail.com with ESMTPSA id j10sm16390309wmi.18.2020.04.14.08.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 08:57:04 -0700 (PDT)
Subject: Re: [PATCH] kvm_host: unify VM_STAT and VCPU_STAT definitions in a
 single place
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org
References: <20200413140332.22896-1-eesposit@redhat.com>
 <03a481a8-bcf2-8755-d113-71ef393508bf@amsat.org>
 <bf870876-9f9a-7ba8-d941-a3883e519eed@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <a5e9246e-2bf3-204e-b79b-0ed4c40fcc5d@redhat.com>
Date:   Tue, 14 Apr 2020 17:57:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <bf870876-9f9a-7ba8-d941-a3883e519eed@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/14/20 10:18 AM, Paolo Bonzini wrote:
> On 13/04/20 23:34, Philippe Mathieu-Daudé wrote:
>>> +#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
>>> +#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
>> I find this macro expanding into multiple fields odd... Maybe a matter
>> of taste. Sugggestion, have the macro define the full structure, as in
>> the arm64 arch:
>>
>> #define VM_STAT(n, x, ...) { n, offsetof(struct kvm, stat.x),
>> KVM_STAT_VM, ## __VA_ARGS__ }
>>
>> Ditto for VCPU_STAT().
>>
Hi Philippe and Paolo,
> 
> Yes, that's a good idea.  Emanuele, can you switch it to this format?

Sure, I just submitted the v2 version.

Thanks,

Emanuele

