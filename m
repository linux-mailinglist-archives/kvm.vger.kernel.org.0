Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5485E1A75BE
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 10:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436540AbgDNIVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 04:21:50 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55893 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2436524AbgDNIVD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 04:21:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586852461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TtBLM3c8JTLmBP2uDmSrWuT9/+Pwll6JJwpjBt6QX00=;
        b=Gp1QYLF1PrEgX3vAu+dXARdbbNzC1ycYKeG+e0+OpE4vNR7LX6VMIJvieYXs4I87X9JUX/
        gzuj5HEc/iaB6nLYR4Z289isVPNRjpA/FaBzKZI6u0tRNFN9Hc5SnZ4PMicCjfqTZnyeXs
        lgf+SPEheVAIOy5fbj3vM1Ma0KNTWZQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-OAndxNigPj6VBEmV5oAqqA-1; Tue, 14 Apr 2020 04:19:02 -0400
X-MC-Unique: OAndxNigPj6VBEmV5oAqqA-1
Received: by mail-wr1-f71.google.com with SMTP id o10so8242702wrj.7
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 01:19:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TtBLM3c8JTLmBP2uDmSrWuT9/+Pwll6JJwpjBt6QX00=;
        b=Y4mdaLC6tyu/Qx8M9LtEYaATiC7KwKs23f3WD98v1iMjwqbOwjrdueHUjCJWpXvhWm
         mpSWG3A/jnNcuQSrrMA8L6ddaquGunVzdHUq0Yx9yDQIjsW9oroawx85KwEbp1rOCfaj
         OSJkKZUF0bPL1SB1hBYZP6l7yIzPhLlsBdCxqARDfmGOT6DrirOd5/N8J+adUBkowj7H
         hQEWxI60ouxsyNuTfq4rOLE7nOEYdMftdF5V8qf5f0Vo1x/JV3BPniwdcgpcLFJW0aAo
         yGvHgIFCja14dEydhZHjp1XZ95KtQFsrsHqOfJaRvlwy1FhlkisX0AtM4kq+iX4IxavM
         VO6g==
X-Gm-Message-State: AGi0PuaFjf42ikk+7T0J8LWOQwNAauV08nu/B/6irXfDilhmQ1nfgX1M
        t00O21wMs1n6KSVB0L5jxUUzlGHARM6/kBuBkzbT/GroHt5oU3dq340mg43LE7Svxkz6eV6PWDr
        YM/57vGO78we7
X-Received: by 2002:a05:6000:8b:: with SMTP id m11mr8390704wrx.168.1586852341227;
        Tue, 14 Apr 2020 01:19:01 -0700 (PDT)
X-Google-Smtp-Source: APiQypKNVMzJLyv+Go05DzXWcde1VJnPobjfS5TpC3OSGCsAYJkHQBkL4kr8iyDzRWBXP64iQWFZGA==
X-Received: by 2002:a05:6000:8b:: with SMTP id m11mr8390681wrx.168.1586852340970;
        Tue, 14 Apr 2020 01:19:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e159:eda1:c472:fcfa? ([2001:b07:6468:f312:e159:eda1:c472:fcfa])
        by smtp.gmail.com with ESMTPSA id o28sm3426907wra.84.2020.04.14.01.18.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 01:19:00 -0700 (PDT)
Subject: Re: [PATCH] kvm_host: unify VM_STAT and VCPU_STAT definitions in a
 single place
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bf870876-9f9a-7ba8-d941-a3883e519eed@redhat.com>
Date:   Tue, 14 Apr 2020 10:18:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <03a481a8-bcf2-8755-d113-71ef393508bf@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/04/20 23:34, Philippe Mathieu-Daudé wrote:
>> +#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
>> +#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
> I find this macro expanding into multiple fields odd... Maybe a matter
> of taste. Sugggestion, have the macro define the full structure, as in
> the arm64 arch:
> 
> #define VM_STAT(n, x, ...) { n, offsetof(struct kvm, stat.x),
> KVM_STAT_VM, ## __VA_ARGS__ }
> 
> Ditto for VCPU_STAT().
> 

Yes, that's a good idea.  Emanuele, can you switch it to this format?

Thanks,

Paolo

