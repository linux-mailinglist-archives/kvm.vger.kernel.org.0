Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D0E3314D7
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 18:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhCHR2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 12:28:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55223 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230480AbhCHR23 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 12:28:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615224508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=68Q1xwUkanNcV5e2B7tNzGwWeOXg0fkQwRdlSBUoc5s=;
        b=U9gWc4gdxQcs+MJ/mo9lI0Bznf4Hom+rru504lpyQanR6OF1L6QULBulrQUVffWlpnURtp
        zyXPDOkEwGHDkeSQyjD3EeUmEDNjd86wnlO1JLFkc1Cxc4Eb3Dqe00iOqVKKxnU1xrwa35
        Hm/hO6NSmGUNkAxoYkZCvH2z84bfkhs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-zzM6bs1sMDO_9HfKdig8uA-1; Mon, 08 Mar 2021 12:28:27 -0500
X-MC-Unique: zzM6bs1sMDO_9HfKdig8uA-1
Received: by mail-ed1-f70.google.com with SMTP id t27so5362972edi.2
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 09:28:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=68Q1xwUkanNcV5e2B7tNzGwWeOXg0fkQwRdlSBUoc5s=;
        b=SbGOxX5mEiurhIZvPtuGbvs3w+tEHVgFV32h0Qw1HKW1c/v7UDVIbWC3lr5MlS+CR5
         IhJ4eOG+XAeF2t6tUtYuhLXhKPvuVMuOAzRCUKph0bS1adoT3ZBulSFeMPRdCOZnA7xV
         fJn8cAJNGWlimWBIi7ahUJRtbbEUvBQpt4BMurxCReTEZlZtKWNTBr3hREYA2puVGo/H
         tOy0j/kyQVg0X8dDJ+VG3F5aofN9whnClDJNGlKka7PL6Y5TT8/29SIRY6vc7AYK3xAq
         tvTTNaZru/7erzPfXhYuuHZWkGKJSpQnQBYQHVQe7rlrdXK2hlvY3/h1Pl/6VbINIqo2
         nTLQ==
X-Gm-Message-State: AOAM532VHaKYl/qDHKyS5ByZr+krI9DlqKk3bbP4gJH8ztGV4rtxeuiu
        4k6sg3b/VJXLLRIHbIOcT4wE+oY1DZYr6aK+FP004Z0kSODv48jubRx2QUHLY9PHvyyWZnv0XX1
        iAYmKPDNtNHmB
X-Received: by 2002:a50:fd15:: with SMTP id i21mr21495789eds.384.1615224505894;
        Mon, 08 Mar 2021 09:28:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy0Zyu+67mVRR61VYO+4Xe2/P4FYPxhpFhPj3T0/5mSt00vh1v0MKUMP1YkBf0lkUxJl9kuAQ==
X-Received: by 2002:a50:fd15:: with SMTP id i21mr21495773eds.384.1615224505712;
        Mon, 08 Mar 2021 09:28:25 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j14sm7353450eds.78.2021.03.08.09.28.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 09:28:25 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com,
        Jim Mattson <jmattson@google.com>
References: <YELdblXaKBTQ4LGf@google.com>
 <fc2b0085-eb0f-dbab-28c2-a244916c655f@redhat.com>
 <YEZUhbBtNjWh0Zka@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 03/28] KVM: nSVM: inject exceptions via
 svm_check_nested_events
Message-ID: <006be822-697e-56d5-84a7-fa51f5087a34@redhat.com>
Date:   Mon, 8 Mar 2021 18:28:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEZUhbBtNjWh0Zka@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/03/21 17:44, Sean Christopherson wrote:
> VMCALL is also probably ok
> in most scenarios, but patching L2's code from L0 KVM is sketchy.

I agree that patching is sketchy and I'll send a patch.  However...

>> The same is true for the VMware #GP interception case.
>
> I highly doubt that will ever work out as intended for the modified IO #GP
> behavior.  The only way emulating #GP in L2 is correct if L1 wants to pass
> through the capabilities to L2, i.e. the I/O access isn't intercepted by L1.
> That seems unlikely.

... not all hypervisors trap everything.  In particular in this case the 
VMCS12 I/O permission bitmap should be consulted (which we do in 
vmx_check_intercept_io), but if the I/O is not trapped by L1 it should 
bypass the IOPL and TSS-bitmap checks in my opinion.

Paolo

> If the I/O is is intercepted by L1, bypassing the IOPL and
> TSS-bitmap checks is wrong and will cause L1 to emulate I/O for L2 userspace
> that should never be allowed.  Odds are there isn't a corresponding emulated
> port in L1, i.e. there's no major security flaw, but it's far from good
> behavior.

