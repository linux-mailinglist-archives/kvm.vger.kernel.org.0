Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67D03A4704
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 18:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhFKQw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 12:52:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56268 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230136AbhFKQw1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 12:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623430229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NUXh46A0h7qJaIjW8suCksiqunmp4+htb+hRkA5j//Q=;
        b=KKgdvRNQ3W+5xAG/W/RhKsYcS4zzgzoQYU0CW7XppN8yMR+eVMN//rPtazRomhNBanV8br
        fE3hzPBQgRd5iKr3f40rZAy7hgTt2F+nyzjaqJRtyV2HPuQ3BaaoDrpPOLhgv0yiXLNdR3
        jxKcvpWbuOYJEQ9v/elDPDfzlLpGsoM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-R3AXkPThONexW8TXUDSMAQ-1; Fri, 11 Jun 2021 12:50:28 -0400
X-MC-Unique: R3AXkPThONexW8TXUDSMAQ-1
Received: by mail-wr1-f69.google.com with SMTP id g14-20020a5d698e0000b0290117735bd4d3so2865785wru.13
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 09:50:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NUXh46A0h7qJaIjW8suCksiqunmp4+htb+hRkA5j//Q=;
        b=mqo2czvFw+xYJWPp3PerXt9/9gRgXcwEgPzzJGOzti89Q1I3FLsiTeJfXwZhpsgFYW
         reRBInsuIsG9JCM7ZuVK3QxDSHdzFuBAxyYB5Q8XUwroRQm6jADPWn3F4KB2swwMXu8h
         Nlf2qo+Wk8msmcLyHnE/EFIX9lIT9GAdVI9UvxN6cUR05wfyf/io1hb/UlerI1xfGIfu
         wpSeWrYF9gqFbraUQ4xCFClFURuizIfegpDT9ZJ9C5IXoxQveGggImN20vsrJj1giO+T
         UcbmtZk6dYxLwcizIUKY3UYt4KA75Ow7BPsxzM7OdwDNCcRJxmInahBIHp0Ffg2/exy8
         O7GQ==
X-Gm-Message-State: AOAM533wXm7LNn9Phio3Dd7ImLihIcMRXd5dXrfs6dGR7A8Ks/yZFN43
        koTpWPl8crZlVbbEbSNCcq4LDbAkSTaA4XlmGs4U3OebKtrWQXPVXxv0aTHC5PDhxD6/cpkY0Hm
        EI5wQkWGLDGeX
X-Received: by 2002:adf:b64a:: with SMTP id i10mr5132689wre.169.1623430226944;
        Fri, 11 Jun 2021 09:50:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6zRcQeuuMtwyv2neqXVjF8SplY1Jwqd6ObDXG0vNraRMJmFoKk/XSTVs4MuV2/BFxKCCsGw==
X-Received: by 2002:adf:b64a:: with SMTP id i10mr5132666wre.169.1623430226727;
        Fri, 11 Jun 2021 09:50:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z5sm7979188wrv.67.2021.06.11.09.50.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 09:50:26 -0700 (PDT)
Subject: Re: [PATCH v5 0/7] Hyper-V nested virt enlightenments for SVM
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
References: <cover.1622730232.git.viremana@linux.microsoft.com>
 <5af1ccce-a07d-5a13-107b-fc4c4553dd4d@redhat.com>
 <683fa50765b29f203cb4b0953542dc43226a7a2f.camel@redhat.com>
 <878s3gybuk.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <50dea657-ef03-4bde-b9c7-75d9e18157ea@redhat.com>
Date:   Fri, 11 Jun 2021 18:50:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <878s3gybuk.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/06/21 11:44, Vitaly Kuznetsov wrote:
> Yea, reported already:
> 
> https://lore.kernel.org/kvm/683fa50765b29f203cb4b0953542dc43226a7a2f.camel@redhat.com/T/#mf732ba9567923d800329f896761e4ee104475894

And that's how I learnt that 1) IS_ENABLED != #ifdef for modules 2) 
CONFIG_HYPERV=m is possible.  Sorry Vineeth for clobbering your 
perfectly fine patch!

Paolo

