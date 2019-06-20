Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB804CDB3
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 14:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731720AbfFTM03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 08:26:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33256 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfFTM03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 08:26:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so2869278wru.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 05:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QS3URIa94SoyJH8ha3lNwqgXEOsXkMKaiakNmwzqQxs=;
        b=d367JMC3gJITbHJaf1zoUiYyqTp1+gLRko6PyWRCrFUT6samp+USpglNtGDQs3oWmz
         m9vDRIyNca+zemSjMkM5XGrShRe1qyWZVvTo/9W3DPNOp3ctE8UaDwl8Ha3etBx7Ue2b
         m/BvQsx1jGxZTn1zkqVzvIKawZ+EfpQCPQs+h0/Oxkfx+ebdM2u4qzjoE7qRXVDxo3s5
         BD/Eaj/AAXPoQG6mekcrFzDKHSPQ6zwhC5nr6FEmmmypMwcxOhOxHGNiTYrco89l84mt
         VCPIXunm2biiRxnaMIJbL+vSuUOzEnmBvc2F4vVnCgJEH4u2OzAbC0I8/xmBdco79YnM
         4S7A==
X-Gm-Message-State: APjAAAVuA6hEvh7x4EtTqghFYeZkTBbifgI2oVT0BIp6HL9xS8+3KQnJ
        KqEDLBrFqXRGAmBCFy6WHTBvEQ==
X-Google-Smtp-Source: APXvYqx1T1KiZH01KAZnyclsZ1tojxpn79SOtdOFjSYgRAOYGyJzWJ+lCez2cSKq+nON0S52mO8EiQ==
X-Received: by 2002:a5d:56d0:: with SMTP id m16mr38258591wrw.276.1561033587390;
        Thu, 20 Jun 2019 05:26:27 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g71sm6548125wmg.7.2019.06.20.05.26.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 05:26:26 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 0/5] x86/KVM/svm: get rid of hardcoded instructions lengths
In-Reply-To: <3515d812-e5dd-4436-b73f-1d64bc93b079@redhat.com>
References: <20190620110240.25799-1-vkuznets@redhat.com> <3515d812-e5dd-4436-b73f-1d64bc93b079@redhat.com>
Date:   Thu, 20 Jun 2019 14:26:25 +0200
Message-ID: <87wohgfnny.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 20/06/19 13:02, Vitaly Kuznetsov wrote:
>> 
>> P.S. If you'd like to test the series you'll have to have a CPU without
>> NRIP_SAVE feature or forcefully disable it, something like:
>> 
>> index 8d4e50428b68..93c7eaad7915 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -922,6 +922,9 @@ static void init_amd(struct cpuinfo_x86 *c)
>>         /* AMD CPUs don't reset SS attributes on SYSRET, Xen does. */
>>         if (!cpu_has(c, X86_FEATURE_XENPV))
>>                 set_cpu_bug(c, X86_BUG_SYSRET_SS_ATTRS);
>> +
>> +       /* No nrips */
>> +       clear_cpu_cap(c, X86_FEATURE_NRIPS);
>>  }
>>  
>>  #ifdef CONFIG_X86_32
>
> Let's add a module parameter instead.  Patch sent (forgot to Cc you).
>

Sure, I thought I'm the only interested person around but if there's
hope for more this definitely sounds like a good idea)

-- 
Vitaly
