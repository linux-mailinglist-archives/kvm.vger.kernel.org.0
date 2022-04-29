Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7250A5152E9
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 19:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379795AbiD2Rvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 13:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343957AbiD2Rvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 13:51:36 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179CFA6E33
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 10:48:18 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so11151269pju.2
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 10:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=37m6AzyYfkWStvf9aJw8Jy6UEa2JtWYvi+mVWOmJgUs=;
        b=CY7TQ3+aM1g21qm98sbu+VQVCl+OjwURQv8jUnuInDt0Z9NAiPnAI0hrukouhWApU0
         MbPZidJeo8qd5VXc6GFDYxYegOTPyhMCEPL+rH0Ft9Pesb4Vz46Sv1LogiN+wfuj+IUN
         w/5cjOPiPfoOk2GL+4YQvbBvvwtU+C52KJh/NdofO1bTC/H+F+Pomhfs8Nwv0nwGTPAs
         n0UWga4gSGPBbV0N+zG7g4gY1mdqJgYxyy2MCI+IlYCpASJFGE9/tWhhiu27VInerF5Y
         xYpzxCnZgsxP8PXGiozY6STFSZjXbdszLDjlHHSV2r47RTXjtZA19PHwTJ6i3pyTWmwi
         Hu9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=37m6AzyYfkWStvf9aJw8Jy6UEa2JtWYvi+mVWOmJgUs=;
        b=D7SHJhOzG8xrTHq+dETkiO9QPYsgCsyPwODQ3x2juc3BO655DoqaAH7IazF5lECw4O
         dQxpo/sr4nFXwZRUfPeUzq2MKsV44rgodgbKSPgx4wsk7dTlyJpmZh1KgEEuBmQpzyaS
         CZllKMnfD4Tj1+6Ga8STDkaP4yfREZr/uFEKiucCtgeiFjD9Zs2AZ0VCZ358mhnHRUo/
         HXiH1oR2Uie0j3jyT/S3AAuYxOLLkqWGetxZaksXLuxEsvcQy9t6URSGghZGebUxNmnJ
         85zioU5jH8eczkmvOovqMLKRQTZgRAxVkZPdAHwpF6yQaC/m/yCiu06ip08C4gJVSxF2
         j2uA==
X-Gm-Message-State: AOAM532HfFZLUqaY36EuaoWYm2j6xz7pfdCufnPk8rub1KIM4bcUNsG/
        I6HafZnsFxkFrre6AVuX4BT13v3ZMcfjbYI7Hrdkmw==
X-Google-Smtp-Source: ABdhPJzTBafb0KnPGjixKxzRN6So46mwnVHpVEuktSyjE2C0ju5wNupcx+O2sCAkCUTE8W8bCvfXLn4L1THnTHmDKi0=
X-Received: by 2002:a17:90b:1e0f:b0:1d9:dba5:482c with SMTP id
 pg15-20020a17090b1e0f00b001d9dba5482cmr286745pjb.220.1651254497576; Fri, 29
 Apr 2022 10:48:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649219184.git.kai.huang@intel.com> <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
 <CAPcyv4g5E_TOow=3pFJXyFr=KLV9pTSnDthgz6TuXvru4xDzaQ@mail.gmail.com>
 <de9b8f4cef5da03226158492988956099199aa60.camel@intel.com>
 <CAPcyv4iGsXkHAVgf+JZ4Pah_fkCZ=VvUmj7s3C6Rkejtdw_sgQ@mail.gmail.com>
 <92af7b22-fa8a-5d42-ae15-8526abfd2622@intel.com> <CAPcyv4iG977DErCfYTqhVzuZqjtqFHK3smnaOpO3p+EbxfvXcQ@mail.gmail.com>
 <4a5143cc-3102-5e30-08b4-c07e44f1a2fc@intel.com>
In-Reply-To: <4a5143cc-3102-5e30-08b4-c07e44f1a2fc@intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 29 Apr 2022 10:48:06 -0700
Message-ID: <CAPcyv4i6X6ODNbOnT7+NEzpicLS4m9bNDybZLvN3gqXFTTf=mg@mail.gmail.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>,
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
        Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 10:18 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 4/29/22 08:18, Dan Williams wrote:
> > Yes, I want to challenge the idea that all core-mm memory must be TDX
> > capable. Instead, this feels more like something that wants a
> > hugetlbfs / dax-device like capability to ask the kernel to gather /
> > set-aside the enumerated TDX memory out of all the general purpose
> > memory it knows about and then VMs use that ABI to get access to
> > convertible memory. Trying to ensure that all page allocator memory is
> > TDX capable feels too restrictive with all the different ways pfns can
> > get into the allocator.
>
> The KVM users are the problem here.  They use a variety of ABIs to get
> memory and then hand it to KVM.  KVM basically just consumes the
> physical addresses from the page tables.
>
> Also, there's no _practical_ problem here today.  I can't actually think
> of a case where any memory that ends up in the allocator on today's TDX
> systems is not TDX capable.
>
> Tomorrow's systems are going to be the problem.  They'll (presumably)
> have a mix of CXL devices that will have varying capabilities.  Some
> will surely lack the metadata storage for checksums and TD-owner bits.
> TDX use will be *safe* on those systems: if you take this code and run
> it on one tomorrow's systems, it will notice the TDX-incompatible memory
> and will disable TDX.
>
> The only way around this that I can see is to introduce ABI today that
> anticipates the needs of the future systems.  We could require that all
> the KVM memory be "validated" before handing it to TDX.  Maybe a new
> syscall that says: "make sure this mapping works for TDX".  It could be
> new sysfs ABI which specifies which NUMA nodes contain TDX-capable memory.

Yes, node-id seems the only reasonable handle that can be used, and it
does not seem too onerous for a KVM user to have to set a node policy
preferring all the TDX / confidential-computing capable nodes.

> But, neither of those really help with, say, a device-DAX mapping of
> TDX-*IN*capable memory handed to KVM.  The "new syscall" would just
> throw up its hands and leave users with the same result: TDX can't be
> used.  The new sysfs ABI for NUMA nodes wouldn't clearly apply to
> device-DAX because they don't respect the NUMA policy ABI.

They do have "target_node" attributes to associate node specific
metadata, and could certainly express target_node capabilities in its
own ABI. Then it's just a matter of making pfn_to_nid() do the right
thing so KVM kernel side can validate the capabilities of all inbound
pfns.

> I'm open to ideas here.  If there's a viable ABI we can introduce to
> train TDX users today that will work tomorrow too, I'm all for it.

In general, expressing NUMA node perf and node capabilities is
something Linux needs to get better at. HMAT data for example still
exists as sideband information ignored by numactl, but it feels
inevitable that perf and capability details become more of a first
class citizen for applications that have these mem-allocation-policy
constraints in the presence of disparate memory types.
