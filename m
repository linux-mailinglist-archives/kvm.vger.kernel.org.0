Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4805117EB4A
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 22:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgCIVgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 17:36:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31166 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726168AbgCIVgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 17:36:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583789761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WFaOjYkjQp10BON4OY2n2qebvVotlGef2Ci4vePe9f4=;
        b=a9spCSDDWckYHlvqAPVhxQkauRrmtrK8zZ4t1ci8oJLchQSN6EMgX0sgruUO3siWPmKAWS
        oxZ29L9WnfPgvYl/1XihBXlqPhhdemTe194rVqNjCD2vbDbMJ1XyPDGlUmsd9bcO0i0tW1
        0OPcNCVKqgdXYpBmyFNlEhjvKtGe7no=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-m1VaKUgvNra4FMWwgaPEbQ-1; Mon, 09 Mar 2020 17:35:57 -0400
X-MC-Unique: m1VaKUgvNra4FMWwgaPEbQ-1
Received: by mail-qt1-f199.google.com with SMTP id f25so7715262qtp.12
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 14:35:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WFaOjYkjQp10BON4OY2n2qebvVotlGef2Ci4vePe9f4=;
        b=G95CrQSp+O6Heu8NBfzwE1rfHZjksuXjgsgIzYI5S1x0K6fIGqGkWURR7U5sQ1ILf/
         blDNLEvGwKfLpv1yED8h7ULWtjhFkaFxifcLUW9AVwCqNZrP7f4H1mQEFRJpHP8HjOVK
         gipqhjYV/q4IVw6qVGlN7D3mOfUOiTdza+bEXZQbd/igCUaGMamJ+ejlitcZuWKO4g5x
         OCTkvvnNl0uO1uBVF3XUlYajL+9M0JhuV/9w21AUqze1fUTCcVL7is1t7uRZvUUkAZrT
         ADpIeiHKSpdresEHUgQV11r/vG5608gKFWO0KZUj3tpC2CasumDnDyCNZ7GMHlAKeH2x
         +utw==
X-Gm-Message-State: ANhLgQ0hNTm/CRM7nZXTu0eEZEgFbQLXA7kFith8LBdZ3buqknVsjPjY
        BvXtMTpYRuC32Q3mKkwMwk4QX9wX70TJ2mHr4OF+VDO+JjWS+D6g1r7eXkPB20RCruw5H7Zi0GE
        LxVUBNPg1EYwx
X-Received: by 2002:a37:c0d:: with SMTP id 13mr16494678qkm.417.1583789757352;
        Mon, 09 Mar 2020 14:35:57 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vt2s8s1SwnonzNqXw6lvns7taZsI3hjZ0REGgGXiGjlFYAQRwpCOm/iuvRE0WA6v1Btrj8wLg==
X-Received: by 2002:a37:c0d:: with SMTP id 13mr16494649qkm.417.1583789757022;
        Mon, 09 Mar 2020 14:35:57 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id 68sm5985561qkh.75.2020.03.09.14.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 14:35:56 -0700 (PDT)
Date:   Mon, 9 Mar 2020 17:35:54 -0400
From:   Peter Xu <peterx@redhat.com>
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v5 05/14] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200309213554.GF4206@xz-x1>
References: <20200304174947.69595-6-peterx@redhat.com>
 <202003061911.MfG74mgX%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202003061911.MfG74mgX%lkp@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 06, 2020 at 07:32:20PM +0800, kbuild test robot wrote:
> Hi Peter,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on tip/auto-latest]
> [also build test ERROR on linus/master v5.6-rc4]
> [cannot apply to kvm/linux-next linux/master vhost/linux-next next-20200305]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Peter-Xu/KVM-Dirty-ring-interface/20200305-053531
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git 6f2bc932d8ff72b1a0a5c66f3dad04ccba576a8b
> config: s390-alldefconfig (attached as .config)
> compiler: s390-linux-gcc (GCC) 7.5.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.5.0 make.cross ARCH=s390 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    arch/s390/../../virt/kvm/kvm_main.o: In function `kvm_reset_dirty_gfn':
> >> kvm_main.c:(.text+0x6a60): undefined reference to `kvm_arch_mmu_enable_log_dirty_pt_masked'

It turns out that when I wanted to fix the build error previously, I
did the compilation test (using a ppc64 host) without using the
correct config file, so KVM is not enabled at all...

I'll fix it (again) this time by moving kvm_reset_dirty_gfn() into
kvm_dirty_ring.c (and some other macro touch-ups).  I'll probably also
move KVM_DIRTY_LOG_PAGE_OFFSET==0 definition to uapi/linux/kvm.h.

Thanks,

-- 
Peter Xu

