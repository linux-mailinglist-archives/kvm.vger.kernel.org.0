Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6D546F37D
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhLIS7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhLIS7b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:59:31 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2286EC061746;
        Thu,  9 Dec 2021 10:55:57 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id g14so21908908edb.8;
        Thu, 09 Dec 2021 10:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pWwoYV6f5eE3TAEXwDK4FFkFf2kDxMmFmHp/m8WrKqU=;
        b=BgFP9f2AS8qbKScGYulFkIKBIZF7JhPtQutQZsMXRAyJ3VsVqzndrMn244/YxeSa51
         1JUMrJPUwH6WLWl6wKGB+t4kB+BfxBS/3tylxelJEEsxjfutVgkY0NGGWdXlHSxUH9/s
         IG5V5H9F2fbokZUBDHFl4GJeYwFtPdJjNvWKwn/iXALcP0VtLbtjDrHf8WZWTCwB3Xhm
         geXXoQOtv6TQOuhRK4Dwojif5cLxpkeylANQuiS2B3K1Yq5gB28MA62ZLyfdvPigvuID
         /R8nJ2bNX2pioETM5nl38v0+1+ad+KAxF1M3iKasVf2dXhApLQn8URlgJhmcpu2xwC3Q
         0KEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pWwoYV6f5eE3TAEXwDK4FFkFf2kDxMmFmHp/m8WrKqU=;
        b=qIboc9/9UP4TxPYqOmyZR8XBk1AqD0zrK37CVpsi4O40mvT4PDKTK7wBfHUXpiDbCG
         MC5lJaMb7T8ye5fw3VOt/R0SeQML41LcknML8ky/sy8J10mfFfFU0TCxCKcjUFnZ3dNJ
         pNBdAZH5vQ4mWZrEjM1ytUniaMFdhWg702w+C6cF4twyV29gGZGenrhCaPL2F8FxUM03
         jv1GsKDN165IeGLKh6jyjugpjpaeOHGiOR7vfqqNqYqJiBswQdLTe6AoQKSrqGCo/cw7
         gAaxwknXt+UAqM/NfeGd1/2pJ6ILLZpMkufwT9phnA+cHeAB32kQIRwzLzgWKf+d/8u0
         hHpg==
X-Gm-Message-State: AOAM530c8PHSwZc6YVVItM41APEl3u1Ci5kKrFhTsM6+vP/xGkNOFi8z
        21tIFMc0Sjif9fp3F2BEM1I=
X-Google-Smtp-Source: ABdhPJwFiK8t4T2rMj2CnTJwfI5KDFX/WPkj8rfHAoRspVvoAsdM3AeM8i4uwXNbLWDTdu8wAOHXxw==
X-Received: by 2002:a05:6402:40d2:: with SMTP id z18mr31216197edb.395.1639076154663;
        Thu, 09 Dec 2021 10:55:54 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h7sm279134edb.89.2021.12.09.10.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 10:55:54 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <68d867c7-1031-00be-e28d-bd435d9c4170@redhat.com>
Date:   Thu, 9 Dec 2021 19:55:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 00/12] KVM: x86/xen: Add in-kernel Xen event channel
 delivery
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anup Patel <anup.patel@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
References: <20211121125451.9489-1-dwmw2@infradead.org>
 <2617aea0-af09-5c0d-1fd7-65e2a814b516@redhat.com>
 <5706a7fec0ffdb18097792374dad90c0400b17cd.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <5706a7fec0ffdb18097792374dad90c0400b17cd.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 19:47, David Woodhouse wrote:
>>> As in the previous two rounds, the last patch (this time patch 12) is
>>> included as illustration of how we*might*  use this for fixing the UAF
>>> bugs in nesting, but isn't intended to be applied as-is. Patches 1-11 are.
>> Queued 1-7, will be on kvm/next tomorrow though.
>
> Thanks. I assume you made the changes you wanted to the makefiles then,
> and will work on the gfn_to_pfn_cache changes you suggested.

Yes, thanks.

Paolo
