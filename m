Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E35338E68F
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbhEXM3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:29:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26158 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232692AbhEXM31 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:29:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621859278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ikStd8qunKQm65lWUW587QvKLPZMZNFV5KeKWHkbI+s=;
        b=dUNT6gdc3O9dXlvfH4WPw78ghCxLgtN+k30q2l5QDixRhAX5/HPHzHCqHQtA0dMkjQcVR7
        3amLodyugzlaAz7rfLMvsudLsLVD51jofovF40Ffl3g8xecaNpSqno0QgEiZOEKHcvQlNZ
        lWk9Z18K2Q+AAaK4Vw8Vc/VX65VQ690=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-P2qa4PMFMm2HanlKfO-z3g-1; Mon, 24 May 2021 08:27:57 -0400
X-MC-Unique: P2qa4PMFMm2HanlKfO-z3g-1
Received: by mail-ej1-f72.google.com with SMTP id i23-20020a17090685d7b02903d089ab83fcso7482231ejy.19
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 05:27:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ikStd8qunKQm65lWUW587QvKLPZMZNFV5KeKWHkbI+s=;
        b=S7NhQvVOK4Y9YTP8qAejmcoGIzAoJn3o3YKchgp10Vpkd8Nws0XMwcjnR8vzc+IVN2
         mm+tP9ecFr79YZ0MwklecR+Yu4PwsxBGhgSR+4XXyxA19rusQNHirbNOnNtulVfV4q5a
         2M6Q3YCxqr6PFoiZ52xswNHLvIp+f2GfUTzXsF4iTS3pxeZYs0qkkM/a9Nrypkh0ENrh
         FjapTbgNwxzvV9DnyUY0f46dj8Dox0a77+U8kJKLlOivF1AOAdNLASLhpwccpLMqbJMF
         2/OTA/ULr7zSU3M1B93PSiwgKjBy9OZPWu8SiKESGBz8avvjyXYcHMHzSrROyKVzDHMA
         rHHg==
X-Gm-Message-State: AOAM531rBl59y1p16lp32Ijzfq1MIswJkQD5AH0oo/8jH01NND7Vdmv7
        yv3+OLrNTcqmYIjhbA3c90vmK8tyxn7VhqQqv2zwyMchV8uUXvNFsNsBxEP/2W530yijQd260xg
        gAVB7wqWjFv7s
X-Received: by 2002:a17:906:7f8a:: with SMTP id f10mr22329231ejr.12.1621859275920;
        Mon, 24 May 2021 05:27:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLbUgLHbLVYN+b0wOSTuWgYGRBcmqoKumnwIIXZlIViNzT8Yi97liN6/CRamtdksEb13OjLA==
X-Received: by 2002:a17:906:7f8a:: with SMTP id f10mr22329215ejr.12.1621859275726;
        Mon, 24 May 2021 05:27:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a5sm9215530eds.73.2021.05.24.05.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 05:27:55 -0700 (PDT)
Subject: Re: [PATCH] selftests: kvm: Fix a potential elf loading issue
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
        shuah@kernel.org
References: <20210512043107.30076-1-zhenzhong.duan@intel.com>
 <20210512043107.30076-2-zhenzhong.duan@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2b16869a-7518-529b-9cbe-fb2e5f61a6e9@redhat.com>
Date:   Mon, 24 May 2021 14:27:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210512043107.30076-2-zhenzhong.duan@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/05/21 06:31, Zhenzhong Duan wrote:
> vm_vaddr_alloc() setup GVA to GPA mapping page by page, then GPA may not be
> continuous if same memslot is used for data and page table allocation.
> 
> kvm_vm_elf_load() expects a continuous memory of GPA or else it need to
> read file data page by page. Fix it by adding a check in vm_vaddr_alloc()
> to ensure memory is allocated in a whole if same memslot is used for data
> and page table.
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> ---
Why not do

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 7426163d448a..f362a066f37a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1170,6 +1170,9 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
  	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
  
  	virt_pgd_alloc(vm, pgd_memslot);
+	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
+					      KVM_UTIL_MIN_PFN * vm->page_size,
+					      data_memslot);
  
  	/*
  	 * Find an unused range of virtual page addresses of at least
@@ -1179,11 +1182,7 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
  
  	/* Map the virtual pages. */
  	for (vm_vaddr_t vaddr = vaddr_start; pages > 0;
-		pages--, vaddr += vm->page_size) {
-		vm_paddr_t paddr;
-
-		paddr = vm_phy_page_alloc(vm,
-				KVM_UTIL_MIN_PFN * vm->page_size, data_memslot);
+		pages--, vaddr += vm->page_size, paddr += vm->page_size) {
  
  		virt_pg_map(vm, vaddr, paddr, pgd_memslot);
  

instead?

Paolo

