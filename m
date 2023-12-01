Return-Path: <kvm+bounces-3074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C5FA8005FB
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 09:40:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A82C21F20ED2
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 08:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4C3C1C29A;
	Fri,  1 Dec 2023 08:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d/JMISoE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317221718
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 00:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701420040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LGk4QvSN2JqDycRctvYjdFxpYw1DpmiQEHZnHJsO+SM=;
	b=d/JMISoEYckzlpsmxLC7ihHWBjbT+V7IUImYCNDH3WrSFagfefIK+TO7HPlhv4tcTDmncX
	tw/hNb6ZmcIxLIrVTYSTi7t+wYuo2ANGsuHTM7bbf8ySrkN5IYgRMXz6PA6miX2j9qMXVj
	q0f5sPTay9BynHbjvYOV6Rgaj2iIn9c=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-rb5-KHCSMfmClUFmT9eCNA-1; Fri, 01 Dec 2023 03:40:39 -0500
X-MC-Unique: rb5-KHCSMfmClUFmT9eCNA-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6ce03f65b97so82019b3a.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 00:40:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701420038; x=1702024838;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LGk4QvSN2JqDycRctvYjdFxpYw1DpmiQEHZnHJsO+SM=;
        b=FczsK+qzEhJlmv/19Htoo50WRjhPdZOn64pypR8ihAXLpH1ftEJ8A6gn+rUlKKz1Jj
         M8qfmco0I133ZsIkyMJVOkrE3Bda3svCIXsd5CAZI+1mNKI7pO5YH9wwgYPUkqwhEPly
         Ammsl3W01Yvk3dJhcwpefXLoJ6WayjGqE3YGv/UwbMFTSWQXNrSrmoltqwJxhTn8gKgP
         x3ERL0rlGKAyYTqJ0C9OG4YXA3AMpGRJyDGy+gMP241PammV08rjqZI5RvWgECzHSynY
         n7N8tO8OboRW/7rxYGPitS5Do7UxCwqN8H/skdi5zTAL5Nh4Tm9PNmSBBbk8/pv1RAI4
         xQjw==
X-Gm-Message-State: AOJu0YzNLsLduTPmbQir7jNXOjBEOvzk8BF/dw6lthQYbklIY44QIIz4
	M2PYTC8QXxB62ih/2Ndb5c+Kw32BecmmcAxGcbmk5o2R0Yt2dYIMbdARrNqS8VIM/tFaNH8fLoP
	o8LKLiE1TCSIt
X-Received: by 2002:a05:6a20:42aa:b0:187:4a56:9a06 with SMTP id o42-20020a056a2042aa00b001874a569a06mr29345862pzj.5.1701420037888;
        Fri, 01 Dec 2023 00:40:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFz3MKfwYqiw8IkFt7xxoAsTvTdxN5g5PACruI74hM2WEQIwJm8mzlNOuUNMVTm6CRhjqiO9g==
X-Received: by 2002:a05:6a20:42aa:b0:187:4a56:9a06 with SMTP id o42-20020a056a2042aa00b001874a569a06mr29345847pzj.5.1701420037504;
        Fri, 01 Dec 2023 00:40:37 -0800 (PST)
Received: from [10.72.112.54] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b10-20020a170902b60a00b001c613091aeasm2750920pls.297.2023.12.01.00.40.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Dec 2023 00:40:37 -0800 (PST)
Message-ID: <bb0d7490-ca51-e98b-e5af-0f65bc044529@redhat.com>
Date: Fri, 1 Dec 2023 16:40:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v1 00/18] arm/arm64: Rework cache
 maintenance at boot
Content-Language: en-US
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
 David Woodhouse <dwmw@amazon.co.uk>, Eric Auger <eric.auger@redhat.com>,
 kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, Nadav Amit <namit@vmware.com>,
 Nico Boehr <nrb@linux.ibm.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Thomas Huth <thuth@redhat.com>
References: <20231130090722.2897974-1-shahuang@redhat.com>
 <ZWhlf7ZLTZIZ3qcQ@raptor>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <ZWhlf7ZLTZIZ3qcQ@raptor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Alexandru,

Just take your time. I also appreciate your work. :)

Thanks,
Shaoqin

On 11/30/23 18:35, Alexandru Elisei wrote:
> Hi,
> 
> Thank you so much for reviving this, much appreciated.
> 
> I wanted to let you know that I definitely plan to review the series as
> soon as possible, unfortunately I don't believe I won't be able to do that
> for at least 2 weeks.
> 
> Thanks,
> Alex
> 
> On Thu, Nov 30, 2023 at 04:07:02AM -0500, Shaoqin Huang wrote:
>> Hi,
>>
>> I'm posting Alexandru's patch set[1] rebased on the latest branch with the
>> conflicts being resolved. No big changes compare to its original code.
>>
>> As this version 1 of this series was posted one years ago, I would first let you
>> recall it, what's the intention of this series and what this series do. You can
>> view it by click the link[2] and view the cover-letter.
>>
>> Since when writing the series[1], the efi support for arm64[3] hasn't been
>> merged into the kvm-unit-tests, but now the efi support for arm64 has been
>> merged. Directly rebase the series[1] onto the latest branch will break the efi
>> tests. This is mainly because the Patch #15 ("arm/arm64: Enable the MMU early")
>> moves the mmu_enable() out of the setup_mmu(), which causes the efi test will
>> not enable the mmu. So I do a small change in the efi_mem_init() which makes the
>> efi test also enable the MMU early, and make it works.
>>
>> And another change should be noticed is in the Patch #17 ("arm/arm64: Perform
>> dcache maintenance"). In the efi_mem_init(), it will disable the mmu, and build
>> a new pagetable and re-enable the mmu, if the asm_mmu_disable clean and
>> invalidate the data caches for entire memory, we don't need to care the dcache
>> and after mmu disabled, we use the mmu_setup_early() to re-enable the mmu, which
>> takes care all the cache maintenance. But the situation changes since the Patch
>> #18 ("arm/arm64: Rework the cache maintenance in asm_mmu_disable") only clean
>> and invalidate the data caches for the stack memory area. So we need to clean
>> and invalidate the data caches manually before disable the mmu, I'm not
>> confident about current cache maintenance at the efi setup patch, so I ask for
>> your help to review it if it's right or not.
>>
>> And I also drop one patch ("s390: Do not use the physical allocator") from[1]
>> since this cause s390 test to fail.
>>
>> This series may include bug, so I really appreciate your review to improve this
>> series together.
>>
>> You can get the code from:
>>
>> $ git clone https://gitlab.com/shahuang/kvm-unit-tests.git \
>> 	-b arm-arm64-rework-cache-maintenance-at-boot-v1
>>
>> [1] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/arm-arm64-rework-cache-maintenance-at-boot-v2-wip2
>> [2] https://lore.kernel.org/all/20220809091558.14379-1-alexandru.elisei@arm.com/
>> [3] https://patchwork.kernel.org/project/kvm/cover/20230530160924.82158-1-nikos.nikoleris@arm.com/
>>
>> Changelog:
>> ----------
>> RFC->v1:
>>    - Gathered Reviewed-by tags.
>>    - Various changes to commit messages and comments to hopefully make the code
>>      easier to understand.
>>    - Patches #8 ("lib/alloc_phys: Expand documentation with usage and limitations")
>>      are new.
>>    - Folded patch "arm: page.h: Add missing libcflat.h include" into #17
>>      ("arm/arm64: Perform dcache maintenance at boot").
>>    - Reordered the series to group patches that touch aproximately the same code
>>      together - the patches that change the physical allocator are now first,
>>      followed come the patches that change how the secondaries are brought online.
>>    - Fixed several nasty bugs where the r4 register was being clobbered in the arm
>>      assembly.
>>    - Unmap the early UART address if the DTB address does not match the early
>>      address.
>>    - Added dcache maintenance when a page table is modified with the MMU disabled.
>>    - Moved the cache maintenance when disabling the MMU to be executed before the
>>      MMU is disabled.
>>    - Rebase it on lasted branch which efi support has been merged.
>>    - Make the efi test also enable MMU early.
>>    - Add cache maintenance on efi setup path especially before mmu_disable.
>>
>> RFC: https://lore.kernel.org/all/20220809091558.14379-1-alexandru.elisei@arm.com/
>>
>> Alexandru Elisei (18):
>>    Makefile: Define __ASSEMBLY__ for assembly files
>>    powerpc: Replace the physical allocator with the page allocator
>>    lib/alloc_phys: Initialize align_min
>>    lib/alloc_phys: Consolidate allocate functions into memalign_early()
>>    lib/alloc_phys: Remove locking
>>    lib/alloc_phys: Remove allocation accounting
>>    lib/alloc_phys: Add callback to perform cache maintenance
>>    lib/alloc_phys: Expand documentation with usage and limitations
>>    arm/arm64: Zero secondary CPUs' stack
>>    arm/arm64: Allocate secondaries' stack using the page allocator
>>    arm/arm64: assembler.h: Replace size with end address for
>>      dcache_by_line_op
>>    arm/arm64: Add C functions for doing cache maintenance
>>    arm/arm64: Configure secondaries' stack before enabling the MMU
>>    arm/arm64: Use pgd_alloc() to allocate mmu_idmap
>>    arm/arm64: Enable the MMU early
>>    arm/arm64: Map the UART when creating the translation tables
>>    arm/arm64: Perform dcache maintenance at boot
>>    arm/arm64: Rework the cache maintenance in asm_mmu_disable
>>
>>   Makefile                   |   5 +-
>>   arm/Makefile.arm           |   4 +-
>>   arm/Makefile.arm64         |   4 +-
>>   arm/Makefile.common        |   6 +-
>>   arm/cstart.S               |  71 +++++++++++++++------
>>   arm/cstart64.S             |  76 +++++++++++++++++------
>>   lib/alloc_phys.c           | 122 ++++++++++++-------------------------
>>   lib/alloc_phys.h           |  28 ++++++---
>>   lib/arm/asm/assembler.h    |  15 ++---
>>   lib/arm/asm/cacheflush.h   |   1 +
>>   lib/arm/asm/mmu-api.h      |   1 +
>>   lib/arm/asm/mmu.h          |   6 --
>>   lib/arm/asm/page.h         |   2 +
>>   lib/arm/asm/pgtable.h      |  39 ++++++++++--
>>   lib/arm/asm/thread_info.h  |   3 +-
>>   lib/arm/cache.S            |  89 +++++++++++++++++++++++++++
>>   lib/arm/io.c               |  31 ++++++++++
>>   lib/arm/io.h               |   3 +
>>   lib/arm/mmu.c              |  37 ++++++++---
>>   lib/arm/processor.c        |   1 -
>>   lib/arm/setup.c            |  82 +++++++++++++++++++++----
>>   lib/arm/smp.c              |   5 ++
>>   lib/arm64/asm/assembler.h  |  11 ++--
>>   lib/arm64/asm/cacheflush.h |  37 +++++++++++
>>   lib/arm64/asm/mmu.h        |   5 --
>>   lib/arm64/asm/pgtable.h    |  50 +++++++++++++--
>>   lib/arm64/cache.S          |  85 ++++++++++++++++++++++++++
>>   lib/arm64/processor.c      |   1 -
>>   lib/devicetree.c           |   2 +-
>>   lib/powerpc/setup.c        |   9 ++-
>>   powerpc/Makefile.common    |   1 +
>>   powerpc/cstart64.S         |   1 -
>>   powerpc/spapr_hcall.c      |   5 +-
>>   33 files changed, 642 insertions(+), 196 deletions(-)
>>   create mode 100644 lib/arm/asm/cacheflush.h
>>   create mode 100644 lib/arm/cache.S
>>   create mode 100644 lib/arm64/asm/cacheflush.h
>>   create mode 100644 lib/arm64/cache.S
>>
>> -- 
>> 2.40.1
>>
> 

-- 
Shaoqin


