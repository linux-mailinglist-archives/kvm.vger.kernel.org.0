Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C2A2B1A1D
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 12:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgKMLcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 06:32:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726374AbgKMLbJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 06:31:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605267062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZX7ay2VwMvfSJ5+6tIQGuldDMeDU11P6MjKLtsymonc=;
        b=giRorWjZTr3VB2N1ZP7108Ml+0WlID6Afx2+O/J63jA0zg6taEDuKBfxXyXUC1WcfiBD0S
        PfKMfSZW/kJsg9WPdMEpakZpr/60GNHlEOZxUYeBPJgF0UI5vFSGP/E5vTf0iVB5+CR1++
        wpGPk2VjLB8qvZvjHHVTxNmnSktVZ5o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-aRxBSeOzP1uqZ6wVskDSMg-1; Fri, 13 Nov 2020 06:31:01 -0500
X-MC-Unique: aRxBSeOzP1uqZ6wVskDSMg-1
Received: by mail-wm1-f69.google.com with SMTP id 8so3061385wmg.6
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 03:31:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZX7ay2VwMvfSJ5+6tIQGuldDMeDU11P6MjKLtsymonc=;
        b=P6wPitnueS70S7wCfFBXSKPrGjIkNJFkic55TDEPYAOm7IwlnWR3a9VjL4B2ol5cmk
         2wPrqKDLtFUgRJr99fUlpRrIkimdVDMETYA+n01PpQv9A/f5nK+CS6H2mL+HIRlTp4ev
         1cvKLsQ5zlHSrqZTSTw+rchk4ZETnzBoXF1eiZIAxc7Bn10kHfES9MPTM8AGYNNrH9e7
         9ZN3XB/FCpBTVY0gEyvCw65d1c3VenTQvyQumDJ8MBl89RU8rjVUSm5759+DxYnkbM6z
         OEy3mjsyhY74WWyDmV1vluCPkTvjwVgetU1QVNRRAqcfM1Lsvqj2TMJ/k455TAHYXv18
         lzOw==
X-Gm-Message-State: AOAM5324f1YHRkHBe8FwJ1kTERP8f2pZhB4Qr1kiLPtuwB9K8tMX845c
        9gl5wII1c0pLKoHyt6JDcKkjT74605eFVuIIuJby+APOF6k/rQZnJYSnjNXi5a+CAh6lD9yupr1
        cV8wJA3FxKOSy
X-Received: by 2002:a05:6000:c7:: with SMTP id q7mr2776321wrx.137.1605267059746;
        Fri, 13 Nov 2020 03:30:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwqNr4OI1Ne3dhDwut6kst5dnN1YE8myWel2KXy4k6OjbSjLC01gPLn9+blQIrtYrf27gQJmw==
X-Received: by 2002:a05:6000:c7:: with SMTP id q7mr2776309wrx.137.1605267059583;
        Fri, 13 Nov 2020 03:30:59 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a15sm10842492wrn.75.2020.11.13.03.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 03:30:58 -0800 (PST)
Subject: Re: [PATCH v2 2/2] KVM:SVM: Update cr3_lm_rsvd_bits for AMD SEV
 guests
To:     Babu Moger <babu.moger@amd.com>
Cc:     junaids@google.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de, vkuznets@redhat.com,
        jmattson@google.com
References: <160521930597.32054.4906933314022910996.stgit@bmoger-ubuntu>
 <160521948301.32054.5783800787423231162.stgit@bmoger-ubuntu>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f9910665-8330-6db6-ee0a-2db9a69d6c95@redhat.com>
Date:   Fri, 13 Nov 2020 12:30:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <160521948301.32054.5783800787423231162.stgit@bmoger-ubuntu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/20 23:18, Babu Moger wrote:
> +	/*
> +	 * For sev guests, update the cr3_lm_rsvd_bits to mask the memory
> +	 * encryption bit from reserved bits
> +	 */

Say why in the comment, don't repeat what the code already says (ok, 
technically the code didn't say that CPUID[0x8000001F].ebx hosts the 
memory encryption bit).  I changed this to:

/* For sev guests, the memory encryption bit is not reserved in CR3.  */

and queued the patches,

Paolo

> +	if (sev_guest(vcpu->kvm)) {
> +		best = kvm_find_cpuid_entry(vcpu, 0x8000001F, 0);
> +		if (best)
> +			vcpu->arch.cr3_lm_rsvd_bits &= ~(1UL << (best->ebx & 0x3f));
> +	}
> +

