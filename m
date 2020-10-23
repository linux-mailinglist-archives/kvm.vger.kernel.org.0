Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAF82975A2
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 19:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753263AbgJWRQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 13:16:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S460729AbgJWRQs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 13:16:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603473406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R/cHvLWzMGMPGjQ5zpi3AHXgRU0M0geaUqAd4QVNRU0=;
        b=JU3EgxQ5LpKLoVb07KPLzQBtovkLn0HuTI/YqDwKTezb5KoPLclB9GwPJX36clyPtmHyy1
        RVMcbVTRhSlgXlkuNIoi7NPEscMKZwxMz5CQ6kRLZ2F5D7F53M78oZZUcvyV8gZX/LKZAa
        voXSdWxp0xS83Mk3Coge6LJ+DrE+DmE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-pGao9-OlPY2cQf665oidGQ-1; Fri, 23 Oct 2020 13:16:44 -0400
X-MC-Unique: pGao9-OlPY2cQf665oidGQ-1
Received: by mail-wr1-f70.google.com with SMTP id 33so809240wrf.22
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 10:16:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R/cHvLWzMGMPGjQ5zpi3AHXgRU0M0geaUqAd4QVNRU0=;
        b=XTBPnmHwc1atNAkWu5FZa1yvpQ00g1JWEXndSfk6dVyAf2cS2R/w9G7rUTQ5QfZQ7x
         RCDOjmJ0f5M5IN7HZdGIraoLVA4q0/7KrsK+K2GqpGyvm+T7/MxssOGtLY52Qaa+jB/7
         UMxahtdAD1sXA5bKVIZYTLTTNL3iPXb2okzLRCV8Bwo5Y7xiL6egJceCBJmkLDdRTmUo
         bJrV0fLAyKj+4a2aCPknwr0UONDw9L+Xps6wpfvIrZW77A8gkaEJGE+IhpBEWsgYA2hc
         L1OURb7MmWGNr30PaXVyNi6VdKM0mqZdagiEoR22kmBxEaFld+sFzQGSrqtVVcw6ibUz
         Noog==
X-Gm-Message-State: AOAM5336T7mj9joE+9ARHaj0ZqBohqnsFT1orciDyceZydNfZ0Hf8g2A
        a4qaA84fdNU7YrWs+f7qjkl9NYRGzJjhgRo8/q0E4RJpqHXUI1DX085+FFfZoNyEhChGieOR0hO
        nkhzDyCBPdSyP
X-Received: by 2002:adf:94e6:: with SMTP id 93mr3549303wrr.190.1603473403455;
        Fri, 23 Oct 2020 10:16:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweWKHpJ9UMric//7ibDgtHwen6W2t4r02W17Mt4X8j5J8RFELzbAIxL9XXMDAMSECFuTpHNg==
X-Received: by 2002:adf:94e6:: with SMTP id 93mr3549282wrr.190.1603473403249;
        Fri, 23 Oct 2020 10:16:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c130sm4318023wma.17.2020.10.23.10.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 10:16:42 -0700 (PDT)
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Mohammed Gamal <mgamal@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200710154811.418214-1-mgamal@redhat.com>
 <20200710154811.418214-8-mgamal@redhat.com>
 <CALMp9eSbY6FjZAXt7ojQrX_SC_Lyg24dTGFZdKZK7fARGA=3hg@mail.gmail.com>
 <CALMp9eTFzQMpsrGhN4uJxyUHMKd5=yFwxLoBy==2BTHwmv_UGQ@mail.gmail.com>
 <20201023031433.GF23681@linux.intel.com>
 <498cfe12-f3e4-c4a2-f36b-159ccc10cdc4@redhat.com>
 <CALMp9eQ8C0pp5yP4tLsckVWq=j3Xb=e4M7UVZz67+pngaXJJUw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 7/9] KVM: VMX: Add guest physical address check in EPT
 violation and misconfig
Message-ID: <f40e5d23-88b6-01c0-60f9-5419dac703a2@redhat.com>
Date:   Fri, 23 Oct 2020 19:16:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eQ8C0pp5yP4tLsckVWq=j3Xb=e4M7UVZz67+pngaXJJUw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/20 18:59, Jim Mattson wrote:
>> The problem is that page fault error code bits cannot be reconstructed
>> from bits 0..2 of the EPT violation exit qualification, if bit 8 is
>> clear in the exit qualification (that is, if the access causing the EPT
>> violation is to a paging-structure entry).  In that case bits 0..2 refer
>> to the paging-structure access rather than to the final access.  In fact
>> advanced information is not available at all for paging-structure access
>> EPT violations.
>
> True, but the in-kernel emulator can only handle a very small subset
> of the available instructions.
> 
> If bit 8 is set in the exit qualification, we should use the advanced
> VM-exit information. If it's clear, we should just do a software page
> walk of the guest's x86 page tables.

The information that we need is _not_ that provided by the advanced
VM-exit information (or by a page walk).  If a page is neither writable
nor executable, the advanced information doesn't say if the injected #PF
should be a W=1 or a F=1 fault.  We need the information in bits 0..2 of
the exit qualification for the final access, which however is not
available for the paging-structure access.

If bit 8 is set, however, we need not use the emulator indeed, as the
W/F/U bits are all available from either the exit qualification or in
the SS access rights.  The access.flat test in kvm-unit-tests covers all
this, so it will be easy to check the theory.

Paolo

> The in-kernel emulator should
> only be used as a last resort on hardware that doesn't support the
> advanced VM-exit information for EPT violations.
> 

