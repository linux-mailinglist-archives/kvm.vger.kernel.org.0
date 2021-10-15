Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C3842F76D
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 17:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241067AbhJOP4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 11:56:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40962 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241061AbhJOPz7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 11:55:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634313232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L1ebZTRDtvYaS1oh3yKgiezKno+o3JSTu41X1RB0t/A=;
        b=cu7BI9A5vWyZRjdJASq863DU8d79ttspJP1n36PLI/QQ3jI0vyN4NBPMyDp17yDN1x7y1h
        fr3+eAjbLBzk9x998o9yguUYV1tcD6WpLiKpnGfEO4dOS3SlJXal0pNg5VoiG/Ed3h/7tM
        7nLDWOkpNkPmn0+olgo+lQijBMVgpm8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-EkqPMo9JNBGgY4qIbbkwlQ-1; Fri, 15 Oct 2021 11:53:51 -0400
X-MC-Unique: EkqPMo9JNBGgY4qIbbkwlQ-1
Received: by mail-ed1-f71.google.com with SMTP id u23-20020a50a417000000b003db23c7e5e2so8647046edb.8
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 08:53:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=L1ebZTRDtvYaS1oh3yKgiezKno+o3JSTu41X1RB0t/A=;
        b=B46HopFvVTY2SPqN4Tu06RM3bjF7KzL+ReR4Qz8kq4AJmpHgYI5SDAi1B/QBasW/uQ
         OP4TMTZoemvywEwzjqVsOAYBQFQRwNC8gaCcxSiPfDNZ3BMa8TGmI8xk6eXkBlYPWCmH
         EvKRIK47QXT53KrAd2oY3t3yfDKiaeWBP1qplhYts3xHMi3vikdfNzc/Ch+Wh57djU4e
         4+OAlcPj92Vo5/hWaydQduDHl8jEdVp4PqIj2ZRaWW8noCnt3L65OSFfXlazs3Aiaj5O
         Wj4C/aXCTF1XsxJctZTkzWK2n9ctdatQfGwkrE8iWlfvbab78jvdzgkEvRdUfGsHtM8L
         eJaw==
X-Gm-Message-State: AOAM531gBIvDkxxRz2Rq/t5jL7917dOvXyAng8lQJgBfu1fUhXdDVe2H
        K/tk2/oNLnBUfkRAKmpMXrc+YQpFeUDD1DaMyJpmrYIg9rM+uAlmvObnlJ8FJ1yrgQrvfdajaVe
        DXHUwqRF5sayV
X-Received: by 2002:a17:906:b782:: with SMTP id dt2mr8125145ejb.310.1634313229575;
        Fri, 15 Oct 2021 08:53:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy62GL1pasUanwiI/flEzTGOV8RVWPvZh1VUyETyszJmioLKXqT8Zc+p5y0zX8PPTgQkB7DfQ==
X-Received: by 2002:a17:906:b782:: with SMTP id dt2mr8125105ejb.310.1634313229351;
        Fri, 15 Oct 2021 08:53:49 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b2sm4510545ejj.124.2021.10.15.08.53.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 08:53:48 -0700 (PDT)
Message-ID: <689cf4f5-6004-de51-f5ca-9a7acee37499@redhat.com>
Date:   Fri, 15 Oct 2021 17:53:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Content-Language: en-US
To:     "Liu, Jing2" <jing2.liu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com> <87wnmf66m5.ffs@tglx>
 <3997787e-402d-4b2b-0f90-4a672c77703f@redhat.com> <87lf2v5shb.ffs@tglx>
 <87a6ja6352.ffs@tglx>
 <BYAPR11MB3256B3120DEB5FE0DD53B5B9A9B99@BYAPR11MB3256.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BYAPR11MB3256B3120DEB5FE0DD53B5B9A9B99@BYAPR11MB3256.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/21 16:24, Liu, Jing2 wrote:
>> fpu_swap_kvm_fpu(bool enter_guest, u64 guest_needs_features) {
>>          possibly_reallocate(enter_guest, guest_needs_features);
> When KVM traps guest wrmsr XFD in #NM, I think KVM need allocate
> fpstate buffer for full features.

You mean XCR0 and XFD (not XFD in #NM), but yeah at the point of 
fpu_swap_kvm_fpu we are in atomic context.

Still, for now the first pass of AMX implementation doesn't need to do 
anything but swap the pointers, and it can simply allocate the full 
buffer at vCPU creation.

Paolo

> Because in next vmexit, guest might have dynamic state and KVM
> can be preempted before running fpu_swap_kvm_fpu().
> Thus, here the current->thread.fpu.fpstate already has enough space
> for saving guest.

