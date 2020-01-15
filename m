Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C2E13CB87
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 19:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgAOSAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 13:00:05 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29081 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726418AbgAOSAE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 13:00:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579111203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2XapLbaOtcjtrElHHMAQ6OSRlBJ67a4EYmsF6AdwXZg=;
        b=dRBbbcPZrzgky2JoOpuTTQUjxkjh3ez+SBUhUU+lWhw/Otl0+inHTPPAxGCS1CXABbD3BE
        cY9buOI56UJcdMMdG9Uq2ySDnHIrW9iuk7uCQbURU/q/9Clw2pkbZliqs7pMC9jNeXFsHg
        KzUSInuYK2/VPyudysu6XEeodTb4hhk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-QKRDAiquO3uja6CEj9rn-A-1; Wed, 15 Jan 2020 13:00:02 -0500
X-MC-Unique: QKRDAiquO3uja6CEj9rn-A-1
Received: by mail-wr1-f70.google.com with SMTP id d8so8227367wrq.12
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 10:00:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2XapLbaOtcjtrElHHMAQ6OSRlBJ67a4EYmsF6AdwXZg=;
        b=CYiPtflpAZAPv4sCVsbII7Mlci6Cv+XblUKoefjqMKK4opzfcP9h7ZMPJOWe3VrBFN
         d2O1t9SlCsHwDtCqkV40GkPJ+8Ey2YwD1MNPoWUzZwqxfcOoPV0lL2lCld9gQTApNJjr
         C5w4r5LFLWKVHZdCdbZpVWgjtDL4BEwJHae4ix59edk4nZAyVrey8i/DkwqpAMox/vH8
         n1vCiYnWfXQ+TzWwX1q7Wz8kepT9Vj4ckTOrI9rgzrswDYUIr07/VNObp91I8nkaBzYV
         HHVhgSJ7SwDE4ainjp09GqYxBxfDx35B1PBThhPfPuZGDtcm0T6YUBf2T6OLuvHijRKV
         T2wQ==
X-Gm-Message-State: APjAAAUP5bqNCWERyodwfhkmCavPAEW6VwgC99GV/9fFCuNCaTxNgh9T
        BRycWMoPuQAJ2jWaLQXjT1GcMlWn2BLX7JXYRtYhb92E+SWJigQ0vt9+RKiR/awhGnQBaqQx9oL
        Ar0xFsj3G85oK
X-Received: by 2002:a1c:ddc5:: with SMTP id u188mr1105003wmg.83.1579111200955;
        Wed, 15 Jan 2020 10:00:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqzdUK4jOChizY1OyBzEt6w49Iopmn3hI+6kXX9D66YP3w9/PZYQxXldJQx6hbbrlNINM/u8jw==
X-Received: by 2002:a1c:ddc5:: with SMTP id u188mr1104980wmg.83.1579111200755;
        Wed, 15 Jan 2020 10:00:00 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:436:e17d:1fd9:d92a? ([2001:b07:6468:f312:436:e17d:1fd9:d92a])
        by smtp.gmail.com with ESMTPSA id f17sm794870wmc.8.2020.01.15.09.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 09:59:59 -0800 (PST)
Subject: Re: [PATCH 0/2] KVM: VMX: PT (RTIT) bug fix and cleanup
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Luwei Kang <luwei.kang@intel.com>
References: <20191210232433.4071-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <697cee10-cd6e-9bb6-608b-a20fc0c39f7f@redhat.com>
Date:   Wed, 15 Jan 2020 18:59:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191210232433.4071-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/19 00:24, Sean Christopherson wrote:
> Add a missing non-canonical check on writes to the RTIT address MSRs
> and tack on a cleanup patch.
> 
> ** ALL PATCHES ARE COMPLETELY UNTESTED **
> 
> Untested due to lack of hardware.
> 
> Sean Christopherson (2):
>   KVM: VMX: Add non-canonical check on writes to RTIT address MSRs
>   KVM: VMX: Add helper to consolidate up PT/RTIT WRMSR fault logic
> 
>  arch/x86/kvm/vmx/vmx.c | 57 ++++++++++++++++++++++++------------------
>  1 file changed, 33 insertions(+), 24 deletions(-)
> 

Queued, thanks.

Paolo

