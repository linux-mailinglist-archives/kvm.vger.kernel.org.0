Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BF324184A
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 10:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgHKIcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 04:32:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58771 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728320AbgHKIcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 04:32:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597134741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=113l6rTObZmAfNhvroTdwAx0MPPacy2TWww2KjZvjFE=;
        b=Bu1id6STBDZHupKP9WghdjZGj32KVUbB7DJBKUjBfHgwzCTJ1biieEVVcRZJQk1sk2sgOY
        dIQ8hboBda+YANOBJx1Pxp3H4aZeFb/I3l3uk0Fj4ZBexXjsLeceSwr/pDdYXhOoMCLpjF
        GLJiTJ3sjTq/p9x356+JanyGzuACpm8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-yP0etY7POo2chh936vHttg-1; Tue, 11 Aug 2020 04:32:19 -0400
X-MC-Unique: yP0etY7POo2chh936vHttg-1
Received: by mail-ed1-f72.google.com with SMTP id x12so4347212eds.4
        for <kvm@vger.kernel.org>; Tue, 11 Aug 2020 01:32:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=113l6rTObZmAfNhvroTdwAx0MPPacy2TWww2KjZvjFE=;
        b=JOA/Rb2GxfeV3g1SyO5zGRiYiPAE3L8YAJhT4OYTLw/7bFudrNDI7IskkWkzBkwwBc
         Qyq0bqVHnaDQaNfNMvmFGidHrh5odC9byxp8vQvrmO/WP+uBU+d0YlpTQn1CLQUjz3az
         PflxOiXnMVnJBqLAFffnxKQbZQI/zhWmutCs41sgCIbWDG3c8ogR0fMFwCaqvO487YOU
         WYOAnyBhZATDe8jssdQWOGXcti5G4IR9RD87PwpjeNO96N2pOYqgwQUp7FSAW6FY9IpI
         qQxlEQa9af8Vd1yLb2TF2JSJWHJOXAQ2ihrA5+jEIv4enVGQkRl+X9lzEzoNOf7buj7N
         /4PQ==
X-Gm-Message-State: AOAM5331OQYJ/PPWqXsMnAav7KJw8+XmYqMlFQZENfBITVuTwkufdtpt
        F9rhRiMkuyiTrL56XXASweafV5UKpjpkcTnAO8zACd6o9O3CY5UYQKe/dsZPBYAxv/i075m77uc
        r3fmhYqRZC+AU
X-Received: by 2002:a17:906:1c0e:: with SMTP id k14mr24859823ejg.479.1597134738249;
        Tue, 11 Aug 2020 01:32:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybotlmCqqppRaJBarXLrP9vGvqFoSrT6KeBVeAUKEclQWSoGUzHpi4cyfpXTfE0GXpnUywlA==
X-Received: by 2002:a17:906:1c0e:: with SMTP id k14mr24859805ejg.479.1597134738030;
        Tue, 11 Aug 2020 01:32:18 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.12.249])
        by smtp.gmail.com with ESMTPSA id d11sm13983189edm.87.2020.08.11.01.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 01:32:17 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] x86/kvm: Expose new features for supported cpuid
To:     "Luck, Tony" <tony.luck@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Park, Kyung Min" <kyung.min.park@intel.com>,
        "ricardo.neri-calderon@linux.intel.com" 
        <ricardo.neri-calderon@linux.intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
References: <1596959242-2372-1-git-send-email-cathy.zhang@intel.com>
 <1596959242-2372-3-git-send-email-cathy.zhang@intel.com>
 <d7e9fb9a-e392-73b1-5fc8-3876cb30665c@redhat.com>
 <27965021-2ec7-aa30-5526-5a6b293b2066@intel.com>
 <e92df7bb267c478f8dfa28a31fc59d95@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <450cca92-259f-4fb5-1f95-596e8862ba3b@redhat.com>
Date:   Tue, 11 Aug 2020 10:32:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <e92df7bb267c478f8dfa28a31fc59d95@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/08/20 01:59, Luck, Tony wrote:
> 
> Part 1: Add TSXLDTRK to cpufeatures.h Part 2: Add TSXLDTRK to
> arch/x86/kvm/cpuid.c (on top of the version that Paolo committed with
> SERIALIZE)
> 
> Paolo: The 5.9 merge window is still open this week. Will you send
> the KVM serialize patch to Linus before this merge window closes?  Or
> do you have it queued for v5.10?

Yes, I am sending it today together with the bulk of ARM and PPC
changes.  I just wanted to soak the branch in linux-next for a day or
two, just in case I screwed up the ARM and PPC pull requests.

Paolo

