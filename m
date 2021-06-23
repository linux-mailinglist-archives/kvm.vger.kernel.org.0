Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1AA3B21D0
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 22:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFWUcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 16:32:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51164 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhFWUcU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 16:32:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624480202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VaT9/cb+GLJShXE53czRupxUnvB/ruHdggf72qjOwGc=;
        b=enUNhgke4jNWT6pIUeiNx8feeGyaQzU+al4bnNWb2BFiPEGCxWcdB2PzERHduBdiCWyrqi
        j0gDl5z+rGbae/s2uSceAzmHMMvD9OhOyccoHQ+JGJ+aBBqqCcd0/066gYGLwTFtVKzC3T
        K30Kf/xJNM9R915ktesFNRuso1bi73A=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-IpENq7kiPkKAjlcBdLJaDw-1; Wed, 23 Jun 2021 16:29:58 -0400
X-MC-Unique: IpENq7kiPkKAjlcBdLJaDw-1
Received: by mail-ej1-f69.google.com with SMTP id l6-20020a1709062a86b029046ec0ceaf5cso1410627eje.8
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:29:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VaT9/cb+GLJShXE53czRupxUnvB/ruHdggf72qjOwGc=;
        b=XdCRh4qCr13wtRfjDm2Oh+TZYQZHJmBNj/bz16uR6jMLjbmXVFhMOdk/fRfbqlzENi
         yB02F3/atpX0vdDHy4ajyziotf7KOWdO/VzT3+dqvUxtiOAeNXe+QhQMuRLQ/IT8SrRp
         Y0Q7SDvzEuDc+gS88UNyeVxUeJmyCqaEYNXhYJAsAfN7oNydrxJMSCcR1dTnsF9Znyks
         1ryLrWL9j9zohAnTTB+z+X+y43LwBczUnSQWS+ay3D9XnqE6sNvI11RHQK+O4yoxx+zm
         AzUV4aBFfaLJLJwXw+5WM2oC74FigrSo3zHXHmh2xwHdCzKxxfQP8S8cydZZg5Yv2tTK
         fmxw==
X-Gm-Message-State: AOAM531/vS6VzUTMK799QrOKzDGuuVSR3P1qqbSZ00hnw1jpKvHFEqz6
        CQTZ15TNK0FzkG/x+0kfuDtdYDGLGToPTAE3AACEk477bWU6EnattHVNV20GUSNYt7DFwAb09y4
        znHA6V0NFC9H9
X-Received: by 2002:a17:906:dbec:: with SMTP id yd12mr1844508ejb.102.1624480197623;
        Wed, 23 Jun 2021 13:29:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbVkZAo20CvntkRy1oPrkGLwNKkE7NFRMzmN1lfBgKChqUpS9dwOA5oGXy4HDg3ys1SiWrJg==
X-Received: by 2002:a17:906:dbec:: with SMTP id yd12mr1844483ejb.102.1624480197324;
        Wed, 23 Jun 2021 13:29:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p19sm576655edr.73.2021.06.23.13.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 13:29:56 -0700 (PDT)
Subject: Re: [PATCH 00/54] KVM: x86/mmu: Bug fixes and summer cleaning
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b4efb3fd-9591-3153-5a64-19afb12edb2b@redhat.com>
Date:   Wed, 23 Jun 2021 22:29:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 19:56, Sean Christopherson wrote:
> Patch 01 is the only patch that is remotely 5.13 worthy, and even then
> only because it's about as safe as a patch can be.  Everything else is far
> from urgent as these bugs have existed for quite some time.

Maybe patch 54 (not sarcastic), but I agree it's not at all necessary.

This is good stuff, I made a few comments but almost all of them (all 
except the last comment on patch 9, "Unconditionally zap unsync SPs") 
are cosmetic and I can resolve them myself.

I'd like your input on renaming is_{cr0,cr4,efer}_* to is_mmu_* (and 
possibly reduce the four underscores to two...).

If I get remarks by tomorrow, I'll get this into 5.14, otherwise 
consider everything but the first eight patches queued only for 5.15.

> I labeled the "sections" of this mess in the shortlog below.
> 
> P.S. Does anyone know how PKRU interacts with NPT?  I assume/hope NPT
>       accesses, which are always "user", ignore PKRU, but the APM doesn't
>       say a thing.  If PKRU is ignored, KVM has some fixing to do.  If PKRU
>       isn't ignored, AMD has some fixing to do:-)
> 
> P.S.S. This series pulled in one patch from my vCPU RESET/INIT series,
>         "Properly reset MMU context at vCPU RESET/INIT", as that was needed
>         to fix a root_level bug on VMX.  My goal is to get the RESET/INIT
>         series refreshed later this week and thoroughly bombard everyone.

Note that it won't get into 5.14 anyway, since I plan to send my first 
pull request to Linus as soon as Friday.

Paolo

