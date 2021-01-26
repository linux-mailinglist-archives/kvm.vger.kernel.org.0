Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C7A304C88
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbhAZWrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:47:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40091 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405276AbhAZUH3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 15:07:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611691561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fm6++ANnZe9IDQ9KscAGZIuA0pCFUfZXiHtKeS4n2T4=;
        b=bduLbsuP4MGSnffVyePQCa5Q+SoG1D7/mJltQu3M4CUBzn4BljrRT7UBlfDes4ZOcOgRBs
        UDAwaWzntucV2yGI2H57OdPFHuOMeTDYCgPoU14mD+zjjTPWW6ClEB2pbmXFNR0fthphhu
        RTu3rLpWff9WXKYFS3w58acmVKS2DNo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-7_sn0f0pNzCccRxsUrRK3A-1; Tue, 26 Jan 2021 15:05:59 -0500
X-MC-Unique: 7_sn0f0pNzCccRxsUrRK3A-1
Received: by mail-ej1-f72.google.com with SMTP id q11so5392456ejd.0
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 12:05:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fm6++ANnZe9IDQ9KscAGZIuA0pCFUfZXiHtKeS4n2T4=;
        b=CcqaymIlYrnvusTxH5zFO6qT+o3s+CIHg0NJ4e1f8IHC7G8KklwVqG74vN6FVQLS1g
         MM1wnNDtPfvM8IDrEQ6Jije7cpx+SUri7vUMrQKGSa0C301KdRXFZa7iTL1potW2N0gL
         6e3uOsXkmqiI4DQGuRvHhJTYfX/XjEikucV1zUMUw+aHV7f2qFhU4B8x7Wf7cXxO6Mjx
         +Xkm1Wz8LK7ElPumlxYRj+jfom73nawXvxd/Vum5gGsoh0iUFh/tuq8/DO3qoip+BV5Z
         WI4RnBuBHOpwKq1Q+ro+Yuo1/5N3pAuAT0+qyrxdHcFmdXvvDpqcRJtMSk9hmYNF4n+3
         4vMg==
X-Gm-Message-State: AOAM53381+ieWelQnv6CG8yJLcZxciFnXhkAZ4IOhDjum3ObVnpUC0zU
        tkbmpYyWtffY2teS04HtXAQSDrSxV2Hx3R7NtfKS1fTE+CxplYowom0HK10ver3PhFFILoUeSxy
        6mvdfFT58xe/Z
X-Received: by 2002:aa7:d0d4:: with SMTP id u20mr5619182edo.203.1611691558328;
        Tue, 26 Jan 2021 12:05:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyBEhTyu8DhAS9s2x0+O49a/nKL+15oROg7kqWOc36XP1JWY1jrOPOKIWUaxI0eA6I6ObZsZw==
X-Received: by 2002:aa7:d0d4:: with SMTP id u20mr5619170edo.203.1611691558136;
        Tue, 26 Jan 2021 12:05:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gb13sm7076891ejc.81.2021.01.26.12.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 12:05:56 -0800 (PST)
Subject: Re: [RFC 6/7] KVM: X86: Expose PKS to guest and userspace
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
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
 <c8f39e4e-75e1-8089-f8ef-9931ce14339f@redhat.com>
 <YBB0AT6xfObR7A5l@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3c87cd73-82c4-f849-5223-6b6e3a4e5adc@redhat.com>
Date:   Tue, 26 Jan 2021 21:05:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBB0AT6xfObR7A5l@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/01/21 20:56, Sean Christopherson wrote:
>>> It does belong in the mmu_role_bits though;-)
>>
>> Does it?  We don't support PKU/PKS for shadow paging, and it's always zero
>> for EPT.  We only support enough PKU/PKS for emulation.
>
> As proposed, yes. The PKU/PKS mask is tracked on a per-mmu basis, e.g. 
> computed in update_pkr_bitmask() and consumed in permission_fault() 
> during emulation. Omitting CR4.PKS from the extended role could let KVM 
> reuse an MMU with the wrong pkr_mask.

Right, not for the hash table key but for reuse.

> IIUC, the logic is PKU|PKS, with pkr_mask generation being PKU vs. PKS agnostic.

Not in the patches as submitted, but it's what I suggested indeed (using 
one bit of the PFEC to pick one of CR4.PKE and CR4.PKS).

> Another option would be to move the tracking out of the MMU, e.g. make pkr_mask
> per-vCPU and recalculate when CR4 changes.  I think that would "just work", even
> when nested VMs are in play?

Yeah, pkr_mask is basically one of four constants (depending on CR4.PKE 
and CR4.PKS) so recalculating when CR4 changes would work too.  But I'm 
okay with doing that later, too.

Paolo

