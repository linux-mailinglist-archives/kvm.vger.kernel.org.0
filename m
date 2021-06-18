Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F713AC910
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 12:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhFRKpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 06:45:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231767AbhFRKpL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 06:45:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624012981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=agL8vLC8hGfhuhbOOrrKP7B41xkz83OGHovo/YQfVgY=;
        b=arZADzFCVz+20ZIzZJZKzjPwl+bFuXK96xNG817Kwdha6LEM0+FMr2/KhENNn7ukVHvqSF
        5nL2RAtAJokIeUVm6kHHTn+d18BuFy/K8OnZqs/HD6jPqI1XjMDDfGxbBqw3e5WXuELryD
        iEOmeXQ0gds72Zk+JvAsWWn229KngVM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-O4qV4RtYNzKGy0nFhXahUQ-1; Fri, 18 Jun 2021 06:43:00 -0400
X-MC-Unique: O4qV4RtYNzKGy0nFhXahUQ-1
Received: by mail-ed1-f71.google.com with SMTP id q7-20020aa7cc070000b029038f59dab1c5so3311233edt.23
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 03:42:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=agL8vLC8hGfhuhbOOrrKP7B41xkz83OGHovo/YQfVgY=;
        b=rtctOIIkZ3+86ebvGuIg+Togbb8RG5ebT2KgAMUJGG20t8DfPw4Qe8hLQUdOpT1qq7
         JW+nksHLhJFEjcOpbevRRMV4THF4m5ntil7OK5bhbHPNmXKY2k5DrElRgqvzAtpZCCO8
         DE0eAC7EYf7P6Iq2ooJ93AZ7HpXVh3tFoi1sM0oSybFHpWXZ+kmT/pY7Z3ITqz5TiIsi
         qbxcrw60RzXjHLxFCyCNOtGwyp/U2jFejuojAuxN/LhCwwi4IFz+dK2Tv0Cjd8IbOITu
         aGAPVrePG9fiVq2SoAjZTPiVL5lRTXH/SPbYgo2EPkAwNGyFKHFbDPBl8xosB87IlcLC
         pL5w==
X-Gm-Message-State: AOAM530HOTjvd5eGdkbyWMDEG2PWoHiq2mqsxf7imcupQ2jjvOTUSdVt
        F9x8h9G/JnvYWEUUesDcpizU1fs60EZKScM6JfrMx775rZXcbdSGH8jWBr6+TyyWUWHFgTSgYYG
        Owjv71tzG2JSF
X-Received: by 2002:a17:907:1107:: with SMTP id qu7mr3523257ejb.40.1624012978903;
        Fri, 18 Jun 2021 03:42:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNRVuZjSUhuwUxOk0eZ+fPUnx5DQqSNfM1NnG4xCO+k9ShctLhVcqCarh3cI2276XZtFEYgg==
X-Received: by 2002:a17:907:1107:: with SMTP id qu7mr3523245ejb.40.1624012978675;
        Fri, 18 Jun 2021 03:42:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r12sm6182892edv.82.2021.06.18.03.42.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 03:42:57 -0700 (PDT)
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Remove redundant is_tdp_mmu_enabled
 check
To:     kernel test robot <lkp@intel.com>,
        David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>
References: <20210617231948.2591431-3-dmatlack@google.com>
 <202106181525.25A3muPf-lkp@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cb8882a8-4619-5993-f94a-097b1751e532@redhat.com>
Date:   Fri, 18 Jun 2021 12:42:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <202106181525.25A3muPf-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/21 09:17, kernel test robot wrote:
> Hi David,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on kvm/queue]
> [also build test ERROR on vhost/linux-next v5.13-rc6]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:https://github.com/0day-ci/linux/commits/David-Matlack/KVM-x86-mmu-Remove-redundant-is_tdp_mmu_root-check/20210618-082018
> base:https://git.kernel.org/pub/scm/virt/kvm/kvm.git  queue
> config: i386-randconfig-a016-20210618 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build):
>          #https://github.com/0day-ci/linux/commit/6ab060f3cf9061da492b1eb89808eb2da5406781
>          git remote add linux-reviewhttps://github.com/0day-ci/linux
>          git fetch --no-tags linux-review David-Matlack/KVM-x86-mmu-Remove-redundant-is_tdp_mmu_root-check/20210618-082018
>          git checkout 6ab060f3cf9061da492b1eb89808eb2da5406781
>          # save the attached .config to linux build tree
>          make W=1 ARCH=i386
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot<lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>     ld: arch/x86/kvm/mmu/mmu.o: in function `get_mmio_spte':
>>> arch/x86/kvm/mmu/mmu.c:3612: undefined reference to `kvm_tdp_mmu_get_walk'
>     ld: arch/x86/kvm/mmu/mmu.o: in function `direct_page_fault':
>>> arch/x86/kvm/mmu/mmu.c:3830: undefined reference to `kvm_tdp_mmu_map'

Turns out sometimes is_tdp_mmu_root is not inlined after this patch.
Fixed thusly:

--------- 8< -----------
Subject: [PATCH] KVM: x86: Stub out is_tdp_mmu_root on 32-bit hosts

If is_tdp_mmu_root is not inlined, the elimination of TDP MMU calls as dead
code might not work out.  To avoid this, explicitly declare the stubbed
is_tdp_mmu_root on 32-bit hosts.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index fabfea947e46..f6e0667cf4b6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -85,12 +85,6 @@ bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
  static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return kvm->arch.tdp_mmu_enabled; }
  static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
-#else
-static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
-static inline void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm) {}
-static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
-static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
-#endif
  
  static inline bool is_tdp_mmu_root(hpa_t hpa)
  {
@@ -105,5 +99,12 @@ static inline bool is_tdp_mmu_root(hpa_t hpa)
  
         return is_tdp_mmu_page(sp) && sp->root_count;
  }
+#else
+static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
+static inline void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm) {}
+static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
+static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
+static inline bool is_tdp_mmu_root(hpa_t hpa) { return false; }
+#endif
  
  #endif /* __KVM_X86_MMU_TDP_MMU_H */

