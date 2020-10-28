Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EAB29D2DE
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 22:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgJ1VhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 17:37:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45488 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726920AbgJ1VhU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Oct 2020 17:37:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603921039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yWKAPwBUoPgI6EJOuZWsiOI74npdzvybwgezGLfhqpU=;
        b=Bb7IdGTI/JAyIWDUnBF+cc34XjALpJMdRnemuaPADI3aDSS8xPJ9VHOKky1/1QyxsZdaxo
        Fl+d/N3YIPMvbitggC/+8s+VS+QRMo5m9WG9fuEu1UIN1Uy/G7sDyzeG3khOYqEpokKbyp
        OAOclNGSZBfGjpsEc20QV9NJjlBV7nE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-NOuIrg5SP5erwZQ3z_izQA-1; Wed, 28 Oct 2020 13:36:09 -0400
X-MC-Unique: NOuIrg5SP5erwZQ3z_izQA-1
Received: by mail-wm1-f70.google.com with SMTP id u207so86268wmu.4
        for <kvm@vger.kernel.org>; Wed, 28 Oct 2020 10:36:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yWKAPwBUoPgI6EJOuZWsiOI74npdzvybwgezGLfhqpU=;
        b=KjRnwL1ALYGNg4a/abELSVrQrwVAjFkLCyl/lRrBnmYQySePx6cYMt7mF+NlkGk+Z7
         dDA7pBl3kFHZKRB76eqz6qTvzjPH2GCwn6NkPAt24PSjaiuNWebM5f1WsyVivO0p4jpA
         lMdQWbZuW0tFL4gLj5O0GNiylm8PHRWqRqam4F8RTogRygqW7o3D+J/KDxZ4DgQCpWBq
         HMqzup5WmHIUw2QYq3JPVfWTqdoCWyrzzV1h6YqHUhLqbcsetp9T542pJ4qmRXGKKPN+
         Cf6HWlni5yiFtlm6yzSEZq/ZVI3GlVjihh/C+SYuHVxlLyOORQDK09MZ5grpsVnzxyEL
         gvig==
X-Gm-Message-State: AOAM530UF70g0l6+0knEQhtiL3o54w6BLfToZN29hG1CdOFtcEP5P0bM
        bNr7i2pfqTEDfiM5xXig7RpWGm007MNltMufM5bDItfQQ3Xxdk6IUMNNIWNB9/bVMsX8EphwjsI
        N5y5HQPRQOfzO
X-Received: by 2002:a5d:6cc8:: with SMTP id c8mr392702wrc.233.1603906568304;
        Wed, 28 Oct 2020 10:36:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyN5YJ8bQgAFXKiKvR2vcMikhRl0VHDB3m0a4fmBv6O53sWV3OReU6ichoRNmYjB8EMqGr9rw==
X-Received: by 2002:a5d:6cc8:: with SMTP id c8mr392681wrc.233.1603906568089;
        Wed, 28 Oct 2020 10:36:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x81sm146652wmb.11.2020.10.28.10.36.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 10:36:07 -0700 (PDT)
To:     =?UTF-8?Q?Valdis_Kl=c4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        bgardon@google.com
References: <20201023163024.2765558-1-pbonzini@redhat.com>
 <20201023163024.2765558-5-pbonzini@redhat.com>
 <120363.1603809997@turing-police>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 04/22] KVM: mmu: extract spte.h and spte.c
Message-ID: <91b1053c-c711-c9e9-0c27-0466f089f30e@redhat.com>
Date:   Wed, 28 Oct 2020 18:36:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <120363.1603809997@turing-police>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/10/20 15:46, Valdis Klētnieks wrote:
> This died a horrid death on my laptop when building with W=1.
> 
>   CC      arch/x86/kvm/mmu/tdp_iter.o
> In file included from arch/x86/kvm/mmu/tdp_iter.c:5:
> arch/x86/kvm/mmu/spte.h:120:18: error: 'shadow_nonpresent_or_rsvd_mask_len' defined but not used [-Werror=unused-const-variable=]
>   120 | static const u64 shadow_nonpresent_or_rsvd_mask_len = 5;
>       |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> arch/x86/kvm/mmu/spte.h:115:18: error: 'shadow_acc_track_saved_bits_shift' defined but not used [-Werror=unused-const-variable=]
>   115 | static const u64 shadow_acc_track_saved_bits_shift = PT64_SECOND_AVAIL_BITS_SHIFT;
>       |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> arch/x86/kvm/mmu/spte.h:113:18: error: 'shadow_acc_track_saved_bits_mask' defined but not used [-Werror=unused-const-variable=]
>   113 | static const u64 shadow_acc_track_saved_bits_mask = PT64_EPT_READABLE_MASK |
>       |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
> make[2]: *** [scripts/Makefile.build:283: arch/x86/kvm/mmu/tdp_iter.o] Error 1
> make[1]: *** [scripts/Makefile.build:500: arch/x86/kvm] Error 2
> make: *** [Makefile:1799: arch/x86] Error 2
> 
> Do we really need to define 3 static variables in every .c file that includes
> this .h file, directly or not?

I'd expect the compiler to get rid of them, but I will change them to
#defines to fix the warnings.

Paolo

