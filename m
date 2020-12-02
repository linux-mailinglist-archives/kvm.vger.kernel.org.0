Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B5C2CB8A4
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 10:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgLBJVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 04:21:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725933AbgLBJVo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Dec 2020 04:21:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606900818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gB2nKuaq2TSTSf4FOqLPJgDC/FIIcQPOncac30ZtyEw=;
        b=it6uMJwnUzSM3b+ZWy3/cx3AOL9G0rtV5m2uNo+BRTznCMsZ9xcJVqeuLgT9+w6RnbYrHZ
        lAC55OOsEfVCVAVUgJfQ60qidamjEHTV42TAB+ERr5N7KG0LzXywFNaKcauHWJEAZ3I0x0
        VLBi2855t3cH3L4mSS5lp/hakUXJKTQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-HNYvCPoyO7itf5FAlhTOIA-1; Wed, 02 Dec 2020 04:20:16 -0500
X-MC-Unique: HNYvCPoyO7itf5FAlhTOIA-1
Received: by mail-ej1-f72.google.com with SMTP id 2so2185509ejv.4
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 01:20:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gB2nKuaq2TSTSf4FOqLPJgDC/FIIcQPOncac30ZtyEw=;
        b=r3vb8YnNVx/DUM6B3qfyOVHb+uaRGnfOVJVrSpWOGFC1nT+IjFE2SIIZflKx+31OQ8
         t/TkVg8s3Wc6kDAS4+MudIWEUl8Zg8XkoHmM51zp8Yd/Y60/oDCzgHHAJddP3iq08M4Q
         bh7TNYokBNl2WlD5+Mff1486SOcQRX52WaaXo3tm4btHFiC7Wl9bfaV0qiOV/Q4ZzCJx
         JxonSHO0qDi3aFjYiS5qEi/BXelZEYoEfhSFI7XlD02m80N5fEOgGY067CPwCRBfneym
         HVZldhlp81WixL/9aZjCsqd61ePXLTnk/IMojqJilklamG4Rmbeh1FRtv25IpG91dun9
         Zvpg==
X-Gm-Message-State: AOAM533RhtWN4rp+D8b1sFQZX9Rj7b1E1rg6GrzjnZO56NKxUU6ZqfJz
        s1eUApyL5agjlM5rhRzl11Hm7uZ08kVa4fshbTjcHqKsspxpZ0GNH5Jyg6KuHkiLEYk7msNibEB
        5UbXs887C2aiP
X-Received: by 2002:a17:906:660b:: with SMTP id b11mr1459085ejp.190.1606900814955;
        Wed, 02 Dec 2020 01:20:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwx3E0owqMs8Bt+7CLCVhnMmFoJVXu0IOpTL/Dtr5g/rsB+KPror3+OWlUuBNVRF2Er6DdzlQ==
X-Received: by 2002:a17:906:660b:: with SMTP id b11mr1459073ejp.190.1606900814717;
        Wed, 02 Dec 2020 01:20:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d9sm754265edk.86.2020.12.02.01.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 01:20:13 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Reinstate userspace hypercall support
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Joao Martins <joao.m.martins@oracle.com>
References: <1bde4a992be29581e559f7a57818e206e11f84f5.camel@infradead.org>
 <X8VaO9DxaaKP7PFl@google.com>
 <64d5fc26a0b5ccb7592f924aa61068e6ee55955f.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <56ef38fe-e976-229c-9215-8ddce8d5f9e1@redhat.com>
Date:   Wed, 2 Dec 2020 10:20:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <64d5fc26a0b5ccb7592f924aa61068e6ee55955f.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/11/20 23:42, David Woodhouse wrote:
> Yes, good point.
> 
> Xen*does*  allow one hypercall (HVMOP_guest_request_vm_event) from
> !CPL0 so I don't think I can get away with allowing only CPL0 like
> kvm_hv_hypercall() does.
> 
> So unless I'm going to do that filtering in kernel (ick) I think we do
> need to capture and pass up the CPL, as you say. Which means it doesn't
> fit in the existing kvm_run->hypercall structure unless I'm prepared to
> rename/abuse the ->hypercall.pad for it.
> 
> I'll just use Joao's version of the hypercall support, and add cpl to
> struct kvm_xen_exit.hcall. Userspace can inject the UD# where
> appropriate.

Or you can use sync regs perhaps.  For your specific use I don't expect 
many exits to userspace other than Xen hypercalls, so it should be okay 
to always run with KVM_SYNC_X86_REGS|KVM_SYNC_X86_SREGS in 
kvm_run->kvm_valid_regs.

Paolo

