Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1AEA51C177
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 15:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380201AbiEEN4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 09:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380336AbiEENze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 09:55:34 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E21D58E7F
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 06:51:31 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 204so907200pfx.3
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 06:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oIH9/l+jKgs9B5DRYw7FbS58vVe4zVtylGwe2TjrN9M=;
        b=iWb/KiI5Nh4F/zht1nOaD5nXxGZBVUw70MvhbB/MJ6c+5LPqpREBzsf6zsAQsrRDm8
         rx/RYqOl+t8yV2aaX7MVFWaZvRX9f5nKsomJH2A+eg3KYprH4WqxwzJSyMckr3iJaKXk
         JiCQBoCdirntvgQwkNUj81coh+byvO158gtCySbTKTu7QRCz3MZhlApdPH//ifXBchv0
         UvitkHWl28bD8tdx70HEP8vaf9H3st3Uu54CmlDnMyBi7D2FUbHJQVrUAG71YMXAoyw8
         GcDd05HWhgN9qLBr6esb2aJMpkMvKgXc/DFPVtmeJ6Fnr1DS5S6T0cBS3lXFfjEVmAnn
         Zh/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oIH9/l+jKgs9B5DRYw7FbS58vVe4zVtylGwe2TjrN9M=;
        b=PHjY1/MNtiJ6Vj+k+UvgCTLZPTevyhL+0elUx6scHJ3K/adU6ocSzXE/ZLaJZ/N8vT
         0EFNph1IZZCvQirvP0nS0vuqfUTy/U7t781Kd11u8mrUCgOGfliv+LF1u13Y7yZdJwY7
         pF5AdfMI2CuigOo1m2KkzLY0lGTv+W2yu/pUSiYyeE6zSQfWYsnMnz+QgrpPsaO48zrm
         33jWarXm8vDDaJo7QZ25W27y3cs7njKMKkLPX7X1VFadVWRaV4hclLPNqio4MEuogasG
         tcm2jOc/SUD6j1aYHUZIQdKyqjEjxOao+JLFsqNvfhkgdpQLHUG3bRgwcm/ceqtgN75h
         DzTQ==
X-Gm-Message-State: AOAM531/JwVrYNcalx1C4hCbS9aQS8Bxo+4eE4dPQFtMs16mQsLSGEWu
        RivG7e6tgMxHcKcTLZzIH9YCjjn9gzq0cDXNEmU6Zg==
X-Google-Smtp-Source: ABdhPJxpS0BcW8ju409ItQiIAiHo+aqD0i1wKv4dQJui6EWLaCpdb50z1BFUKtJYPkQggkeD3Blgh/QiSI1KJedl4Ug=
X-Received: by 2002:a05:6a02:283:b0:342:703e:1434 with SMTP id
 bk3-20020a056a02028300b00342703e1434mr21850337pgb.74.1651758691003; Thu, 05
 May 2022 06:51:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649219184.git.kai.huang@intel.com> <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
 <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
 <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com> <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
 <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com> <c90a10763969077826f42be6f492e3a3e062326b.camel@intel.com>
 <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com>
 <664f8adeb56ba61774f3c845041f016c54e0f96e.camel@intel.com>
 <1b681365-ef98-ec78-96dc-04e28316cf0e@intel.com> <8bf596b45f68363134f431bcc550e16a9a231b80.camel@intel.com>
 <6bb89ca6e7346f4334f06ea293f29fd12df70fe4.camel@intel.com>
In-Reply-To: <6bb89ca6e7346f4334f06ea293f29fd12df70fe4.camel@intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 5 May 2022 06:51:20 -0700
Message-ID: <CAPcyv4iP3hcNNDxNdPT+iB0E4aUazfqFWwaa_dtHpVf+qKPNcQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Mike Rapoport <rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[ add Mike ]


On Thu, May 5, 2022 at 2:54 AM Kai Huang <kai.huang@intel.com> wrote:
[..]
>
> Hi Dave,
>
> Sorry to ping (trying to close this).
>
> Given we don't need to consider kmem-hot-add legacy PMEM after TDX module
> initialization, I think for now it's totally fine to exclude legacy PMEMs from
> TDMRs.  The worst case is when someone tries to use them as TD guest backend
> directly, the TD will fail to create.  IMO it's acceptable, as it is supposedly
> that no one should just use some random backend to run TD.

The platform will already do this, right? I don't understand why this
is trying to take proactive action versus documenting the error
conditions and steps someone needs to take to avoid unconvertible
memory. There is already the CONFIG_HMEM_REPORTING that describes
relative performance properties between initiators and targets, it
seems fitting to also add security properties between initiators and
targets so someone can enumerate the numa-mempolicy that avoids
unconvertible memory.

No, special casing in hotplug code paths needed.

>
> I think w/o needing to include legacy PMEM, it's better to get all TDX memory
> blocks based on memblock, but not e820.  The pages managed by page allocator are
> from memblock anyway (w/o those from memory hotplug).
>
> And I also think it makes more sense to introduce 'tdx_memblock' and
> 'tdx_memory' data structures to gather all TDX memory blocks during boot when
> memblock is still alive.  When TDX module is initialized during runtime, TDMRs
> can be created based on the 'struct tdx_memory' which contains all TDX memory
> blocks we gathered based on memblock during boot.  This is also more flexible to
> support other TDX memory from other sources such as CLX memory in the future.
>
> Please let me know if you have any objection?  Thanks!

It's already the case that x86 maintains sideband structures to
preserve memory after exiting the early memblock code. Mike, correct
me if I am wrong, but adding more is less desirable than just keeping
the memblock around?
