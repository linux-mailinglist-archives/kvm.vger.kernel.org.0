Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B04304C82
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbhAZWqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:46:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391884AbhAZS0V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 13:26:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611685495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=riHUl91cW/42T1v9JhfI+l/08ntS4eF8eLyqTUMJMu4=;
        b=JpHbu8bxE8sVp50Bpt7SqaycT4WT+JneUToGyd1CFqfzVMSGal8gf1iWoMIZBdifNpVb36
        IY4Lm5Vi4VnC7mwdn2jmpamnAUcQrB4KJUgZDrRM6esyRGXruQCn7bSy5/mnjwnMSXOxGW
        tm3P6ehJBwyssPBE91MjhUct7l+9ypk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-UXZaHEO2M0q-LWBjh0_DHw-1; Tue, 26 Jan 2021 13:24:53 -0500
X-MC-Unique: UXZaHEO2M0q-LWBjh0_DHw-1
Received: by mail-ej1-f71.google.com with SMTP id h18so5292325ejx.17
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 10:24:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=riHUl91cW/42T1v9JhfI+l/08ntS4eF8eLyqTUMJMu4=;
        b=uYA0quTbPNHCdiC68r7z53nW++FBYoR8WjGec+Q3z3GsDb+LcfqINS1zrg14E/u0U0
         ukbJ3yQX+J5ss4ergP677UQfC6+O73H62LD+C48TzIIASgYf1DOKkJW6d//OkhhMml95
         dxr43+zASDehC+Er8bPZJohtPWFv49D3lZcpf0WKhcvrXIIA0ubFp+0AK9dE0BV/y0PA
         aE4AAHy4aEzdsGeQB2pxFp34SkvrnkSR562XSoJbyWuxVY0zXrYjLahJcJS3UdTIQimY
         cyMLs8II/QQDlV6+HQFu85jc/lkr+kxB7iAIrmMAT4EXYP8IpuHzBZ48nwhtoqutmDjo
         o07g==
X-Gm-Message-State: AOAM5308bZ3+RSF2tGr+MRqxy6hY2rPGYpyhIcEASJTaNUmQqqZjGMtA
        t+M9s6SwI0G7NFRIueEj04ifOhik3ZQX8v/nLXetN7ns8xpxjuJGFjLvlWyWbU83SNmqYzVhWuQ
        Gpjy7No7FRkBn
X-Received: by 2002:a17:906:3885:: with SMTP id q5mr4344915ejd.105.1611685492180;
        Tue, 26 Jan 2021 10:24:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwzrSowQL+1Z10SlL4q0SQgPmEnQ/PkqXDrQg5FyswihXa/Niodq3FbdFKDjpHV3/ddu4Sc5Q==
X-Received: by 2002:a17:906:3885:: with SMTP id q5mr4344905ejd.105.1611685492040;
        Tue, 26 Jan 2021 10:24:52 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t19sm9966098ejc.62.2021.01.26.10.24.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 10:24:51 -0800 (PST)
Subject: Re: [RFC 6/7] KVM: X86: Expose PKS to guest and userspace
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
 <20200807084841.7112-7-chenyi.qiang@intel.com>
 <CALMp9eQ=QUZ04_26eXBGHqvQYnsN6JEgiV=ZSSrE395KLX-atA@mail.gmail.com>
 <20200930043634.GA29319@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c8f39e4e-75e1-8089-f8ef-9931ce14339f@redhat.com>
Date:   Tue, 26 Jan 2021 19:24:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20200930043634.GA29319@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/20 06:36, Sean Christopherson wrote:
>> CR4.PKS is not in the list of CR4 bits that result in a PDPTE load.
>> Since it has no effect on PAE paging, I would be surprised if it did
>> result in a PDPTE load.
> It does belong in the mmu_role_bits though;-)
> 

Does it?  We don't support PKU/PKS for shadow paging, and it's always 
zero for EPT.  We only support enough PKU/PKS for emulation.

Paolo

