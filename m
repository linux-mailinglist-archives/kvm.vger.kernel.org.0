Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23A571050CE
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 11:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKUKnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 05:43:24 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54149 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726833AbfKUKnY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 05:43:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574333003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SJGFd6J2iR6SZmcHzMwTOOI6ea+BczDHgJljqbvt1+k=;
        b=E4tK2VOtcNJ5hmVy5lHACRIJ5MbY+kGwbL/6oQYNTTzK4DErqZibUKMq+4kjONGh/VJjbE
        8xiUKoHNiROAjJ35QbidLvSHVsXTA/FIlnj5eH277qH9/KnCmgqJpv29cbRUQcBSmDhr/7
        3m2befz6fesvuyYFCFeVkVg3AT/rLcU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-9rqQwm4mO8mGj-e29-kQOw-1; Thu, 21 Nov 2019 05:43:19 -0500
Received: by mail-wm1-f69.google.com with SMTP id l23so518843wmh.6
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 02:43:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CAw1/LVFY4c2d2aF4u+GAoU/WDuvpiCsAx8hSiSJ7t4=;
        b=n/I2TGix2AXHl5nZK552gKzdZLaQAI5rjT4/GQilBjJWlGnxiDwBB70Rfm4To6SBGd
         SQ9zOFp1sNgM98h9hWWqNqgp71unWQGOEF3tme/2IHMnsUu6WI77xzSeT88u0IBwhwsZ
         a9KrDlA6iN6uaAhOfY97OE9evTo/SCqfjUUXDtL4oQ/ASHAuSpXLX9yC7mbSauP4RQD+
         i9CO0mpw8YA2ijrDq0eRVnD8QGFlhdD/9guFp9DEfep3on3mlUSXfYONBkETTRJkVxq1
         4RGGfSm1MnyQ+WfpfDH+EhOeVcYurxn1UgUsC298VCghouaeWa/IcvAoXxTH2s2iazc3
         P0Cg==
X-Gm-Message-State: APjAAAUvBYqEgXKutr7CdCgnBUJCzrPic+m8SoOJycE7sblJIdN6nkD0
        gQ7UK0zzrSiL4c0S/qQd5ygsnxcJeZ+kfiy0PTT656exzxUKBxCltFhmnWSYMBzGBvzEjwa1dsU
        DekBgCKt6+X0J
X-Received: by 2002:a7b:c5d2:: with SMTP id n18mr8614876wmk.37.1574332998300;
        Thu, 21 Nov 2019 02:43:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqy2qIB86M1YRPFqzRbiSYJHXSvnR5ntxhBHVG/ZPlAa+uWsmv+N3M3vBvmDnrR+iPYztXY4CA==
X-Received: by 2002:a7b:c5d2:: with SMTP id n18mr8614836wmk.37.1574332997903;
        Thu, 21 Nov 2019 02:43:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id k1sm2863881wrp.29.2019.11.21.02.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:43:17 -0800 (PST)
Subject: Re: [PATCH v7 0/9] Enable Sub-Page Write Protection Support
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com
References: <20191119084949.15471-1-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e1b64143-d372-81ae-349d-bcd72fd3b668@redhat.com>
Date:   Thu, 21 Nov 2019 11:43:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191119084949.15471-1-weijiang.yang@intel.com>
Content-Language: en-US
X-MC-Unique: 9rqQwm4mO8mGj-e29-kQOw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/19 09:49, Yang Weijiang wrote:
> EPT-Based Sub-Page write Protection(SPP) allows Virtual Machine Monitor(V=
MM)
> specify write-permission for guest physical memory at a sub-page(128 byte=
)
> granularity. When SPP works, HW enforces write-access check for sub-pages
> within a protected 4KB page.
>=20
> The feature targets to provide fine-grained memory protection for
> usages such as memory guard and VM introspection etc.
>=20
> SPP is active when the "sub-page write protection" (bit 23) is 1 in
> Secondary VM-Execution Controls. The feature is backed with a Sub-Page
> Permission Table(SPPT), and subpage permission vector is stored in the
> leaf entry of SPPT. The root page is referenced via a Sub-Page Permission
> Table Pointer (SPPTP) in VMCS.
>=20
> To enable SPP for guest memory, the guest page should be first mapped
> to a 4KB EPT entry, then set SPP bit 61 of the corresponding entry.=20
> While HW walks EPT, it traverses SPPT with the gpa to look up the sub-pag=
e
> permission vector within SPPT leaf entry. If the corresponding bit is set=
,
> write to sub-page is permitted, otherwise, SPP induced EPT violation is g=
enerated.
>=20
> This patch serial passed SPP function test and selftest on Ice-Lake platf=
orm.
>=20
> Please refer to the SPP introduction document in this patch set and
> Intel SDM for details:
>=20
> Intel SDM:
> https://software.intel.com/sites/default/files/managed/39/c5/325462-sdm-v=
ol-1-2abcd-3abcd.pdf
>=20
> SPP selftest patch:
> https://lkml.org/lkml/2019/6/18/1197

On top of the changes I sent for the individual patches, please move
vmx/spp.c to mmu/spp.c, and vmx/spp.h to spp.h (I've just sent a patch
to create the mmu/ directory).  Also, please include the selftest in
this series.

Paolo

> Patch 1: Documentation for SPP and related API.
> Patch 2: Add control flags for Sub-Page Protection(SPP).
> Patch 3: Add SPP Table setup functions.
> Patch 4: Add functions to create/destroy SPP bitmap block.
> Patch 5: Introduce user-space SPP IOCTLs.
> Patch 6: Set up SPP paging table at vmentry/vmexit.
> Patch 7: Enable Lazy mode SPP protection.
> Patch 8: Handle SPP protected pages when VM memory changes.
> Patch 9: Add SPP protection check in emulation case.
>=20
>=20
> Change logs:
> V6 -> V7:
>   1. Configured all available protected pages once SPP induced vmexit
>      happens since there's no PRESENT bit in SPPT leaf entry.
>   2. Changed SPP protection check flow in tdp_page_fault().
>   3. Code refactor and minior fixes.
>=20
> V5 -> V6:
>   1. Added SPP protection patch for emulation cases per Jim's review.
>   2. Modified documentation and added API description per Jim's review.
>   3. Other minior changes suggested by Jim.
>=20
> V4 -> V5:
>   1. Enable SPP support for Hugepage(1GB/2MB) to extend application.
>   2. Make SPP miss vm-exit handler as the unified place to set up SPPT.
>   3. If SPP protected pages are access-tracked or dirty-page-tracked,
>      store SPP flag in reserved address bit, restore it in
>      fast_page_fault() handler.
>   4. Move SPP specific functions to vmx/spp.c and vmx/spp.h
>   5. Rebased code to kernel v5.3
>   6. Other change suggested by KVM community.
>  =20
> V3 -> V4:
>   1. Modified documentation to make it consistent with patches.
>   2. Allocated SPPT root page in init_spp() instead of vmx_set_cr3() to
>      avoid SPPT miss error.
>   3. Added back co-developers and sign-offs.
>=20
> V2 -> V3:                                                               =
=20
>   1. Rebased patches to kernel 5.1 release                               =
=20
>   2. Deferred SPPT setup to EPT fault handler if the page is not
>      available while set_subpage() is being called.
>   3. Added init IOCTL to reduce extra cost if SPP is not used.
>   4. Refactored patch structure, cleaned up cross referenced functions.
>   5. Added code to deal with memory swapping/migration/shrinker cases.
>=20
> V2 -> V1:
>   1. Rebased to 4.20-rc1
>   2. Move VMCS change to a separated patch.
>   3. Code refine and Bug fix=20
>=20
>=20
> Yang Weijiang (9):
>   Documentation: Introduce EPT based Subpage Protection and related
>     ioctls
>   vmx: spp: Add control flags for Sub-Page Protection(SPP)
>   mmu: spp: Add SPP Table setup functions
>   mmu: spp: Add functions to create/destroy SPP bitmap block
>   x86: spp: Introduce user-space SPP IOCTLs
>   vmx: spp: Set up SPP paging table at vmentry/vmexit
>   mmu: spp: Enable Lazy mode SPP protection
>   mmu: spp: Handle SPP protected pages when VM memory changes
>   x86: spp: Add SPP protection check in emulation.
>=20
>  Documentation/virt/kvm/api.txt        |  46 ++
>  Documentation/virtual/kvm/spp_kvm.txt | 180 +++++++
>  arch/x86/include/asm/cpufeatures.h    |   1 +
>  arch/x86/include/asm/kvm_host.h       |  10 +-
>  arch/x86/include/asm/vmx.h            |  10 +
>  arch/x86/include/uapi/asm/vmx.h       |   2 +
>  arch/x86/kernel/cpu/intel.c           |   4 +
>  arch/x86/kvm/mmu.c                    |  78 ++-
>  arch/x86/kvm/mmu.h                    |   2 +
>  arch/x86/kvm/vmx/capabilities.h       |   5 +
>  arch/x86/kvm/vmx/spp.c                | 651 ++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/spp.h                |  28 ++
>  arch/x86/kvm/vmx/vmx.c                | 113 +++++
>  arch/x86/kvm/x86.c                    |  87 ++++
>  include/uapi/linux/kvm.h              |  17 +
>  15 files changed, 1232 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/spp_kvm.txt
>  create mode 100644 arch/x86/kvm/vmx/spp.c
>  create mode 100644 arch/x86/kvm/vmx/spp.h
>=20

