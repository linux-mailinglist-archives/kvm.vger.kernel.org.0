Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070E4437AF3
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 18:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbhJVQdb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 12:33:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34456 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233538AbhJVQd1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 12:33:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634920269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n/eK/Q0sUb0isw4uCVZWU+zVv806HjFFB2ffIfJ7LWo=;
        b=aT2EGHz6gJ2dqNogJ7xttGADp2i+Sj8eJpW10tbyom3lmbBnlbm8CFgmoHtg4q73zN3pzK
        9g+qymSQ2/NlTe2lBWQBnwEczEDJ6zwQmnOmRMpEjsSiTpNkzkFYckSm9C75mf3dElxIWg
        HsP2Z2I5B0EPbmLJvKy9EfwiyLff6sQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-1AOkN1QXOPa5flUYoSbPZQ-1; Fri, 22 Oct 2021 12:31:07 -0400
X-MC-Unique: 1AOkN1QXOPa5flUYoSbPZQ-1
Received: by mail-ed1-f71.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so4225334edi.12
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 09:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=n/eK/Q0sUb0isw4uCVZWU+zVv806HjFFB2ffIfJ7LWo=;
        b=OX0ZlzSrmlT5CiSCsZt4Ia/FJOcDRICW9ewoudEjHYFH1ZUb7/sL0gwpEaFEYSwUqP
         khNx3/Byx10UPi4XdTG/eNPDvwtDfjYMr4LO/WEArvjxnGguu4gdtCeQfFxdxEoAmxOU
         n9GcF+bl5gqongtxN2MelyZTSO3CFNqBd+bTZ3BA4EnGvbmd35zc4r8RByflQwMML6Sy
         SBaZdxF0iIch5DAy4BnBypdfdiBpwpU+vH24iksTZG4y98tYw6qS86w1yIk1HP0yEFOt
         FfZ1nLRe008VDHVl0M5jYLDeoY0I4AduBep6B66cWWaeXpVbBeEn4YG3mo5jPkibEaIf
         uVUA==
X-Gm-Message-State: AOAM53187KtbwE5wAirGbhUCHQaKBWFvRRyrP6qefQ6HxzHJuKas4ZVt
        op7FLPSZeokfTzDW2SC/YX1Fhp38nPqp8oe7KfKvJvYZ+gT0tPE22O9PJs1Rp9FxzNoDoBnVPVB
        vaGAMm+kJT9Ef
X-Received: by 2002:a05:6402:5189:: with SMTP id q9mr1319817edd.94.1634920266360;
        Fri, 22 Oct 2021 09:31:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFf2ARdxVTBE+4xCNMGhCEtBXmLBuP233sDWRgIfbEeL/Gw1yeWc27lCIYD0Fk5HpBH5qyvQ==
X-Received: by 2002:a05:6402:5189:: with SMTP id q9mr1319764edd.94.1634920266047;
        Fri, 22 Oct 2021 09:31:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w3sm4915436edj.63.2021.10.22.09.31.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 09:31:05 -0700 (PDT)
Message-ID: <0eab7a31-53e0-2899-76d7-3e9c0be76fad@redhat.com>
Date:   Fri, 22 Oct 2021 18:31:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 4/8] KVM: SEV-ES: clean up kvm_sev_es_ins/outs
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
References: <20211013165616.19846-1-pbonzini@redhat.com>
 <20211013165616.19846-5-pbonzini@redhat.com>
 <1ae6a54626342dd2391d04a3566bd680c6831e93.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1ae6a54626342dd2391d04a3566bd680c6831e93.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/21 01:14, Maxim Levitsky wrote:
>>   
>>   	vcpu->arch.pio.count = 0;
> ^^^
> I wonder what the rules are for clearing vcpu->arch.pio.count for userspace PIO vm exits.
> Looks like complete_fast_pio_out clears it, but otherwise the only other place
> that clears it in this case is x86_emulate_instruction when it restarts the instuction.
> Do I miss something?

For IN, it is cleared by the completion callback.

For OUT, it can be cleared either by the completion callback or before 
calling it, because the completion callback will not need it.  I would 
like to standardize towards clearing it in the callback for out, too, 
even if sometimes it's unnecessary to have a callback in the first 
place; this is what patch 8 does for example.  This way 
vcpu->arch.pio.count > 0 tells you whether the other fields have a 
recent value.

Paolo

