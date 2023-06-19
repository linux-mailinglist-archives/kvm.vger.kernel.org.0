Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1860D7358C2
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 15:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbjFSNko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 09:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjFSNkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 09:40:42 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6882A118;
        Mon, 19 Jun 2023 06:40:40 -0700 (PDT)
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DB3D31EC0102;
        Mon, 19 Jun 2023 15:40:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1687182038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=NQcQ+a91rnEmxFtS6KIZWR6r/nd+aTVNBSnx9bM3XZo=;
        b=MjZrI2Pb1EA97CsnjLQkLLYXnftqpz1BMSytwT2Fkcm79yTr7JlS3vbPHybZQGk2gNvBdV
        7pJxq+Ljl/BYq/YNswcZLYfOeYT3BcOtdCS2ltKIotcJp6HYvURYcrmTpDMEIyanHuqgDd
        H+X68i3UAmnnIDktOVRK7Y5dvsc0MIs=
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xyc2kN7e7SI6; Mon, 19 Jun 2023 13:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1687182035; bh=NQcQ+a91rnEmxFtS6KIZWR6r/nd+aTVNBSnx9bM3XZo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hhjq4sAwqpuXAjDZr0482mo+tJJ0h0offjDvdI0pCCoCQw2bDUcP8d1vbDkapw272
         xVM5yjFjjoNovnJZSBbFHf8J20dy0BvYq3Lf5/6HRBdwil9v1Aobm+f2g/gfW4DXnM
         b4YK0b1ne/U38dROisrBRRDzRlbXtYjRrFji1OTpCkEAnk7c+RPW9lAtONuYgZRerJ
         I6+INtMP4DnSAZnjWraSMdu0T5EW08EU7cAYkC/Hha/niDr/F5MewITS/JqCLcCk2w
         M4fJW5oXMRz9hZQzxEsZOb+8GOiaXrEPRugbBe8sJyskrr6Nh7FJhJjuPcsFYYypTU
         hca7QInRQqaye2PTigrrCnFcm0WMOQp1goK0OxCGZ9Ing4TiGzBJOuvh74BZVr/Qmi
         DdSTA2frFGKVeHBbStTjaynkbdb1FjWeT4A2xGYIok+FY/MvJPPnX/bv72T9u8DOue
         fdyb1/BCxS9myr7OYuFisiuGoDRpYKpLCPZZzwC8xjY8OXaZXwAYoWmCwqI56wH0Js
         TfJMAZ4TNRorAeiEzc0gIHq0u0T5lPm4dt0t754mvHOYYJYEaoCsQqHeC4Dy2RGzS1
         aqKVArwd+i9hfQZM7ZM3g53aGg9SoCzbpCl/YgirQxJXdSuW99oJN7wrICWB1/lnJP
         63A8a5ZQ59tJNZlWhFgkbgVs=
Received: from zn.tnic (p200300ea971dC5b2329c23fFFEA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971d:c5b2:329c:23ff:fea6:a903])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 793DE40E0034;
        Mon, 19 Jun 2023 13:39:55 +0000 (UTC)
Date:   Mon, 19 Jun 2023 15:39:50 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com
Subject: Re: [PATCH RFC v9 02/51] KVM: x86: Add gmem hook for invalidating
 private memory
Message-ID: <20230619133950.GBZJBapnJ3vD74ASAu@fat_crate.local>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-3-michael.roth@amd.com>
 <20230612104905.GOZIb4ISN9gj9lWYNv@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230612104905.GOZIb4ISN9gj9lWYNv@fat_crate.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023 at 12:49:05PM +0200, Borislav Petkov wrote:
> ld: arch/x86/kvm/../../../virt/kvm/eventfd.o: in function `kvm_arch_gmem_invalidate':
> /home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: multiple definition of `kvm_arch_gmem_invalidate'; arch/x86/kvm/../../../virt/kvm/kvm_main.o:/home/boris/kernel/2nd/linux/./include/linux/kvm_host.h:2356: first defined here
> ld: arch/x86/kvm/../../../virt/kvm/binary_stats.o: in function `kvm_arch_gmem_invalidate':

Fix is trivial:

---
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7de06add2235..67fdfb683cb9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2353,7 +2353,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	return -EIO;
 }
 
-void kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end) { }
+static inline void kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end) { }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
 #endif

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
