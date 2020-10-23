Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7462975F1
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 19:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464148AbgJWRnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 13:43:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S462067AbgJWRnY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 13:43:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603475002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Zu0LYwVSmEJWNT4NqggQbfAbgnLBnqlkd3v5H5H25w=;
        b=KIE4pJRHNWCgVK+SvyR8zeX5o5CYiOjapBmdiPtSJLMMLWZ81ugZ2JvYtTPH3XrdsxkIQR
        5L4/PbiyKaX0wyZoW0EThoVGZcSAcaE8apCiOO66Ifr+fnkBILnG6W1UbfjRGSU0Ue/Yhr
        ZzbrKe+vwbU7u2SQvMb3drTY9zdGibA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-dBW7116xNg2Ruek-s-AjHA-1; Fri, 23 Oct 2020 13:43:20 -0400
X-MC-Unique: dBW7116xNg2Ruek-s-AjHA-1
Received: by mail-wr1-f72.google.com with SMTP id 47so845685wrc.19
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 10:43:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+Zu0LYwVSmEJWNT4NqggQbfAbgnLBnqlkd3v5H5H25w=;
        b=SptBsfGY/DTeGTvz8EcfNlhqsP/buvWa/LlSb+QGOEYHeVRoQgS9+UOC64WdxsjvQv
         cqZfXgGeZUoyMnchQwr5kV/lHTVzNGurmZfDZjpdVQmIbyddCWj8Ljwmy8IQ816V2e9p
         P8ZAuLed4koHky9uldq5yMYlCaILqNhhw6CkpKrogo8Z6yVWSUrn56Do/NLtI1WIjN6m
         KvcJbMJteUmcuaY8NFVC7XvJ56wnviR3avZzyQ44HgG28VkLYDGEnnPDyGWxeJzzosCm
         JdJz5+zA0h0CpnfoMjvw1AEdBh8YSJJNJHb2eRVfm9n34C+lUVk8dbNoX7OsMLf604Cr
         5w1A==
X-Gm-Message-State: AOAM531kDBJhomquvn0Ry5DWXKHUjNQZGBN4mmAsmyKA/Ue+iLUZf6z9
        AhGiZ9rB9xCuHnLtBDDDm6815rS0H3zK7Bd/Uz1A0XsnQzLxm812o+1GedlsZXB11jnEtY7dEwu
        7CXkEKIWqgwf4
X-Received: by 2002:a1c:f719:: with SMTP id v25mr3424366wmh.186.1603474999601;
        Fri, 23 Oct 2020 10:43:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzwLsjkrDGdSh7CSlvmu3j7iiAz0uw3JwPZ5xYVRGX9FuRPgyfsFUeWf1AGU9SEtDN9fpA5w==
X-Received: by 2002:a1c:f719:: with SMTP id v25mr3424358wmh.186.1603474999410;
        Fri, 23 Oct 2020 10:43:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p21sm4586588wmc.28.2020.10.23.10.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 10:43:18 -0700 (PDT)
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Mohammed Gamal <mgamal@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200710154811.418214-1-mgamal@redhat.com>
 <20200710154811.418214-8-mgamal@redhat.com>
 <CALMp9eSbY6FjZAXt7ojQrX_SC_Lyg24dTGFZdKZK7fARGA=3hg@mail.gmail.com>
 <CALMp9eTFzQMpsrGhN4uJxyUHMKd5=yFwxLoBy==2BTHwmv_UGQ@mail.gmail.com>
 <20201023031433.GF23681@linux.intel.com>
 <498cfe12-f3e4-c4a2-f36b-159ccc10cdc4@redhat.com>
 <CALMp9eQ8C0pp5yP4tLsckVWq=j3Xb=e4M7UVZz67+pngaXJJUw@mail.gmail.com>
 <f40e5d23-88b6-01c0-60f9-5419dac703a2@redhat.com>
 <CALMp9eRGBiQDPr1wpAY34V=T6Jjij_iuHOX+_-QQPP=5SEw3GQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 7/9] KVM: VMX: Add guest physical address check in EPT
 violation and misconfig
Message-ID: <4463f391-0a25-017e-f913-69c297e13c5e@redhat.com>
Date:   Fri, 23 Oct 2020 19:43:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eRGBiQDPr1wpAY34V=T6Jjij_iuHOX+_-QQPP=5SEw3GQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/20 19:23, Jim Mattson wrote:
>> The information that we need is _not_ that provided by the advanced
>> VM-exit information (or by a page walk).  If a page is neither writable
>> nor executable, the advanced information doesn't say if the injected #PF
>> should be a W=1 or a F=1 fault.  We need the information in bits 0..2 of
>> the exit qualification for the final access, which however is not
>> available for the paging-structure access.
>>
> Are you planning to extend the emulator, then, to support all
> instructions? I'm not sure where you are going with this.

I'm going to fix the bit 8=1 case, but for bit 8=0 there's not much that
you can do.  In all likelihood the guest is buggy anyway.

It would be possible to only do the decode part of the emulator to get
the PFEC (matching the GVA from the vmexit to the memory operand, for
example, and retrying if the instruction is unexpected).  Then one would
only need enough VEX/EVEX parsing to process the decoding.

Paolo

