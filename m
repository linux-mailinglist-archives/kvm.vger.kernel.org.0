Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC44437808
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 15:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbhJVNgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 09:36:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24712 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230342AbhJVNgM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 09:36:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634909634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Vg6punm34oYk+y9zl1LSGNiEzLmAAfArkoDnEvG2GI=;
        b=ax6nwbayyx7EwrV1nebh3uJfQYGV85CuFa9tc4GHyU8tajl38de7LbZhmdOR0pOlkivS/R
        LygjXl3eyGIBUSTlpwtwenD7/3AZjANi8miltLdF+RePGwgTTSUDec/BfbElm2/ZXzxoaM
        sylZWbrdhJFQzCdHdh8Smp9NfOQiaHo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-GTgcCGzeNs217F1moXsdsg-1; Fri, 22 Oct 2021 09:33:52 -0400
X-MC-Unique: GTgcCGzeNs217F1moXsdsg-1
Received: by mail-ed1-f71.google.com with SMTP id g6-20020a056402424600b003dd2b85563bso1015104edb.7
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 06:33:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3Vg6punm34oYk+y9zl1LSGNiEzLmAAfArkoDnEvG2GI=;
        b=XM8WEMkgn7RFJD6qLOfvYf+qb6mfMX88hwxywyEF4FUz+tZWRuV3o2dFunI3qfRSdZ
         mFdd6iereGxVeCyGSwy4mm+VWI0/o+/PruDRXfy1PYErGcdy834b4PMVMslnC/fO0rPJ
         6hlvk8bArKCtLSI2UcWG3xUwE33yhvZQhZlP63JWCpOTSdXNv96XtdjV+VCWi+ARJUtB
         xAdeN7hF7upUN5QsEEqe5At/qIJSC6SEZDWG5IFz+nxavwHiUdKDcTCj/n4KROGeQqie
         GqNPr4LtzUUSAKAt5nA+C9EHuyA040H6f0suRoE+Er851IIp9mGUQit+sEHx/hQ1ir44
         mY3Q==
X-Gm-Message-State: AOAM531lxSKgyBtC8CO2KUdtBam5NqIpQ0+enoZ+rkoMaUL3e2EZjXe9
        A47xZU+oozUvTiVhqjjX0Yw6lnC8KOz/xbhQr8fRA+nCEWFRHTzBwGa+qP5zE8J8Nt34ASYbAoB
        JjpmjuYCwUG0Y
X-Received: by 2002:a05:6402:1d49:: with SMTP id dz9mr25557edb.17.1634909631633;
        Fri, 22 Oct 2021 06:33:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYx1KIeAxL0rRpHT3vlVyvYf2GIBD9/4Aw8TmBkbWuyBpBvoIXF2O0dh8keeQzPCvsdCjZWw==
X-Received: by 2002:a05:6402:1d49:: with SMTP id dz9mr25536edb.17.1634909631427;
        Fri, 22 Oct 2021 06:33:51 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ku14sm490022ejc.30.2021.10.22.06.33.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 06:33:50 -0700 (PDT)
Message-ID: <43fd49ff-d54d-558f-f5c8-6dcc5dc726b2@redhat.com>
Date:   Fri, 22 Oct 2021 15:33:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 0/8] KVM: SEV-ES: fixes for string I/O emulation
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        fwilhelm@google.com, oupton@google.com
References: <20211013165616.19846-1-pbonzini@redhat.com>
 <YXH8hmB64gnwxIx6@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YXH8hmB64gnwxIx6@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/21 01:49, Sean Christopherson wrote:
> On Wed, Oct 13, 2021, Paolo Bonzini wrote:
>> Patches 2 to 7 are a bunch of cleanups to emulator_pio_in and
>> emulator_pio_in_out, so that the final SEV code is a little easier
>> to reason on.  Just a little, no big promises.
> IMO, this series goes in the wrong direction and doesn't make the mess any better,
> just different.
> 
> The underlying issue is that kernel_pio() does the completely horrendous thing
> of consuming vcpu->arch.pio.  That leads to the juggling that this series tries
> to clean up, but it's essentially an impossible problem to solve because the
> approach itself is broken.

I agree on this, but I disagree that the series does not make the mess 
any better.  At the very least, the new signatures for 
__emulator_pio_in, complete_emulator_pio_in and emulator_pio_in_out are 
improvements regarding the _role_ of vcpu->arch.pio*:

- complete_emulator_pio_in clearly takes the values from vcpu->arch.pio, 
which _is_ the right thing to do for a complete_userspace_io function. 
This is not clear of emulator_pio_in before the patch

- __emulator_pio_in and emulator_pio_in_out do not take anymore the 
buffer argument, making it clear that they operate on the internal 
pio_data buffer and only complete_emulator_pio_in copies out of it. 
Which yes is horrible, but at least it is clearly visible in the code now.

I managed to clean things up quite satisfactorily with just 6 patches on 
top of these eight, so I'll post the full series as soon as I finish 
testing them.  5.15 can then include these to fix the bug at hand.

Paolo

