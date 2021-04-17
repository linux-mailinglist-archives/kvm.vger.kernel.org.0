Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C21363077
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbhDQN4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 09:56:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55549 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236058AbhDQN4Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 09:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618667749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y3zM8GNArDQFQU+fCtcRtFkotH8jOBWUvSl/L7VRU3Q=;
        b=JVRH9PoyWbNqfl8UkS/A+99fqlqrnw81qDw/JUC7I+Ze4DIMnU21rtzV1UoMRZlQ/zQQeT
        EZUr8jaBK8S1e9hchNr4T1qP95bTCnkgOZPj3Q+QjwTHZhtELPNepf8AO+ca85BpR4qTxg
        LTKe4sbV9/pYif3qN9xQD2wwHtegrRg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-WQv7xIZxP4aaO_p93eN3Sw-1; Sat, 17 Apr 2021 09:55:45 -0400
X-MC-Unique: WQv7xIZxP4aaO_p93eN3Sw-1
Received: by mail-ed1-f69.google.com with SMTP id bm19-20020a0564020b13b02903789d6e74b5so8622922edb.21
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 06:55:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y3zM8GNArDQFQU+fCtcRtFkotH8jOBWUvSl/L7VRU3Q=;
        b=nXOs1gcqqHNdT0yLrkPq34EDx+t+of7jYeoJ7UfXfSSraahxMZh5WFOUmMR1cLRPxO
         z2Hq2kjjpWRJgbK7bH8HaFlfoK7qTAdjwKl12eH2KxAkgoFO4v0l5ix1bn5JQX+Mq6Lt
         SZQHDqheCTHvF8ghYA+hhCMxFxPCRH+YMuWha8jELHyzeOrKET9vXC8GmvSzN8wEf5Et
         ZChSLeqQhUZj1k2Jl4jIpevTJ6cN5wj6esnY3T+PBkYY/9zbSMsjNzQdIAxEx2iHMiaI
         iaxV0wJrvUYi37xKXQsW14OaxkRF0jS0QcCzkRiB1dBo+jZlxqmen6PCMtahe7Uu5pFY
         9BCQ==
X-Gm-Message-State: AOAM532o0Lplx/17azxsekBfvPLYhy4zlAvCBx96ABtqyCce6n+eTcNP
        ZhJCLNBoutALuIjQd6URLaAUzYg5kaCh2q/kvAuGk4O4Qh389S0xVnalvAKxFEE+rMhSG9MVhe9
        CqMiwqaN3eFJL
X-Received: by 2002:a17:906:cc48:: with SMTP id mm8mr13615865ejb.58.1618667744684;
        Sat, 17 Apr 2021 06:55:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfCPABMiEfuYMcCF876MI75fGVSG83AMNlzATH77YxIJTywlQcOcLINn51+qGSh3mnpsJU5A==
X-Received: by 2002:a17:906:cc48:: with SMTP id mm8mr13615860ejb.58.1618667744555;
        Sat, 17 Apr 2021 06:55:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q12sm6432375ejy.91.2021.04.17.06.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 06:55:43 -0700 (PDT)
Subject: Re: [PATCH v5 08/11] KVM: VMX: Add emulation of SGX Launch Control LE
 hash MSRs
To:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
References: <cover.1618196135.git.kai.huang@intel.com>
 <c58ef601ddf88f3a113add837969533099b1364a.1618196135.git.kai.huang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0f4eaeb2-df66-af8e-d716-7060edf03e90@redhat.com>
Date:   Sat, 17 Apr 2021 15:55:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <c58ef601ddf88f3a113add837969533099b1364a.1618196135.git.kai.huang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/04/21 06:21, Kai Huang wrote:
> Note, KVM allows writes to the LE hash MSRs if IA32_FEATURE_CONTROL is
> unlocked.  This is technically not architectural behavior, but it's
> roughly equivalent to the arch behavior of the MSRs being writable prior
> to activating SGX[1].  Emulating SGX activation is feasible, but adds no
> tangible benefits and would just create extra work for KVM and guest
> firmware.
> 
> [1] SGX related bits in IA32_FEATURE_CONTROL cannot be set until SGX
>      is activated, e.g. by firmware.  SGX activation is triggered by
>      setting bit 0 in MSR 0x7a.  Until SGX is activated, the LE hash
>      MSRs are writable, e.g. to allow firmware to lock down the LE
>      root key with a non-Intel value.

I turned these into a comment in vmx_set_msr:

                 /*
                  * On real hardware, the LE hash MSRs are writable before
                  * the firmware sets bit 0 in MSR 0x7a ("activating" SGX),
                  * at which point SGX related bits in IA32_FEATURE_CONTROL
                  * become writable.
                  *
                  * KVM does not emulate SGX activation for simplicity, so
                  * allow writes to the LE hash MSRs if IA32_FEATURE_CONTROL
                  * is unlocked.  This is technically not architectural
                  * behavior, but close enough.
                  */

Paolo

