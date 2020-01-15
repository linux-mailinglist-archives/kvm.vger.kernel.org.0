Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F12413CB9B
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 19:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgAOSFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 13:05:21 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43098 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbgAOSFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 13:05:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579111520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c69WbVq5j2P1XNGy+IhxAunAcPYacDdAW3b2A1FRx4E=;
        b=hFWb4WBX35x42I7Xz8tyqVeYqh1IM1SzAbsa7IPlr+p0M7qJdVr2JEiPb0J1xp1MURmjEZ
        TuTRqrkRyH9f6dkD7XV1vVKkNvy0F/l65yLfS88WtuqmArvg/uPfBpdZ4H88auFAkF2tj0
        3+Z7gtQFjbzVGoADCft0TdgavmCxOrI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-gLsfsjcaP1Grsyv9OU3GQg-1; Wed, 15 Jan 2020 13:05:19 -0500
X-MC-Unique: gLsfsjcaP1Grsyv9OU3GQg-1
Received: by mail-wr1-f70.google.com with SMTP id f10so8322249wro.14
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 10:05:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c69WbVq5j2P1XNGy+IhxAunAcPYacDdAW3b2A1FRx4E=;
        b=mPtLdn6fR60Tq5KuEvwvYj77emJintwrCO4EKLHD64YWQ7eDo0kvlYul5td+RHZix4
         I+qp3vvSCf9teQfFrUtRZenG/bCT92e3Y8qCoOwWLeyhBMs8Shp7/Xly8tFBm4X3QInh
         noxyjDV55q4PlTiWxP6yrPTZVyMi98tDAQ4Jj2elu5aAlNMfhCeR2ubFbx+HQ/W1jOFQ
         xa8DnXdFa9Qlx5nG7zkLWgedRmCG2G3oHV+TXoDiTBG7USf1nWe5TcP78iICrGVuytZM
         3MBOYNDaRGRTUIxH6sODoo8s4fGvXoeAiq6I08BkSyDzP4VelIRsObIfOiqQx8WvgpPo
         8sdw==
X-Gm-Message-State: APjAAAU5rkCmJmi7wlDesZ0D6dpC33EkAyoplJ9c3Rb4q8ws7Q1LaPsD
        jz+7484Wcr5ECrmNJbiBF5Zrq5/ShziICOr4Bwyqps8C1BSDijyKl+TZojWo/x8ffxSZC+3FURa
        +bp7yWKefU4tu
X-Received: by 2002:a1c:7918:: with SMTP id l24mr1242903wme.125.1579111517300;
        Wed, 15 Jan 2020 10:05:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqwhZlrV31iytYOe/i6rKaJ0a5p5+NIIM2FKS1E+7bLOwxTRHWKblRQPEorgppp4hxakTRh1tA==
X-Received: by 2002:a1c:7918:: with SMTP id l24mr1242868wme.125.1579111517074;
        Wed, 15 Jan 2020 10:05:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:436:e17d:1fd9:d92a? ([2001:b07:6468:f312:436:e17d:1fd9:d92a])
        by smtp.gmail.com with ESMTPSA id z123sm905364wme.18.2020.01.15.10.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 10:05:16 -0800 (PST)
Subject: Re: [PATCH 0/4] KVM: x86: Add checks on host-reserved cr4 bits
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jun Nakajima <jun.nakajima@intel.com>
References: <20191210224416.10757-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0c7a9237-14fd-ff66-0c28-e979f7f7edd6@redhat.com>
Date:   Wed, 15 Jan 2020 19:05:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191210224416.10757-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/19 23:44, Sean Christopherson wrote:
> KVM currently doesn't incorporate the platform's capabilities in its cr4
> reserved bit checks and instead checks only whether KVM is aware of the
> feature in general and whether or not userspace has advertised the feature
> to the guest.
> 
> Lack of checking allows userspace/guest to set unsupported bits in cr4.
> For the most part, setting unsupported bits will simply cause VM-Enter to
> fail.  The one existing exception is OSXSAVE, which is conditioned on host
> support as checking only guest_cpuid_has() would result in KVM attempting
> XSAVE, leading to faults and WARNs.
> 
> 57-bit virtual addressing has introduced another case where setting an
> unsupported bit (cr4.LA57) can induce a fault in the host.  In the LA57
> case, userspace can set the guest's cr4.LA57 by advertising LA57 support
> via CPUID and abuse the bogus cr4.LA57 to effectively bypass KVM's
> non-canonical address check, ultimately causing a #GP when VMX writes
> the guest's bogus address to MSR_KERNEL_GS_BASE during VM-Enter.
> 
> Given that the best case scenario is a failed VM-Enter, there's no sane
> reason to allow setting unsupported bits in cr4.  Fix the LA57 bug by not
> allowing userspace or the guest to set cr4 bits that are not supported
> by the platform.
> 
> Sean Christopherson (4):
>   KVM: x86: Don't let userspace set host-reserved cr4 bits
>   KVM: x86: Ensure all logical CPUs have consistent reserved cr4 bits
>   KVM: x86: Drop special XSAVE handling from guest_cpuid_has()
>   KVM: x86: Add macro to ensure reserved cr4 bits checks stay in sync
> 
>  arch/x86/kvm/cpuid.h   |  4 ---
>  arch/x86/kvm/svm.c     |  1 +
>  arch/x86/kvm/vmx/vmx.c |  1 +
>  arch/x86/kvm/x86.c     | 65 +++++++++++++++++++++++++++++-------------
>  4 files changed, 47 insertions(+), 24 deletions(-)
> 

Queued, thanks.

Paolo

