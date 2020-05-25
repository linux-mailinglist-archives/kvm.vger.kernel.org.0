Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282301E11AE
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 17:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404175AbgEYP06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 11:26:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25403 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404134AbgEYP05 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 11:26:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590420415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2PI4OLD2ZI4py7bxKHPKVelhSZTDGLOrNvjwt+4tOug=;
        b=XyprC9O5gVQcz4ZCE/+f6PAlrKUfMNIWKlZhoR1am4hBOjflSfRha9KCivcbr+xXSLkMd9
        s3ZyZS412dm6ue2t/qb8EbR3xo/bxDDGuwODHgWFotCGzOdz9wSPorGJPtIy8jHyRPz8gY
        sazJXLcsvZwtWX1L/F/nNYLEFEYnz14=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-Miu-rW1DPWq1u-xRYGC9eA-1; Mon, 25 May 2020 11:26:52 -0400
X-MC-Unique: Miu-rW1DPWq1u-xRYGC9eA-1
Received: by mail-qk1-f200.google.com with SMTP id w14so2468122qkb.0
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:26:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2PI4OLD2ZI4py7bxKHPKVelhSZTDGLOrNvjwt+4tOug=;
        b=tpRQ5LnMJr+m0N4UGSEDaSVrbmBu/wAiumUCc1avX4KXORKd11wwdZ6hp3r9F/ztqf
         DGpqLQDjyPGtVWhR3KhjTEMRrf3z2e20bEQW++tXLFGR4gKHeH/318OIVNDUHwacPQp0
         +skn7lJ7fx+TXe89yEoATfyGYtZduB+sCeHiJj4uLixI9hyqIop6NXkpFWciyyU/eQH6
         3/Vuq9U7QM6NOZw7BndM8TAnRPM5OJUQpt3nRcBW6L8/wX2ZaBaOlFQ/irwJQ6PdzyXA
         5m6LB57kdRu0pZlDUBy0Md1aBdTIjSe+OU9cBvwPziz/eupjZGntQVLShyUkn2vB/cM+
         IYFg==
X-Gm-Message-State: AOAM533p+oCcREz6CIdM5AxI4jEFAGSRz4JH2J107nha8si9uDbursG5
        Ij4jV0T/K+F0YgHesWhK2AGfCEI3YXfhfXiRJ46D2nfwLoKqDMUSpzal2sj/n24zfN0c00kWR54
        INFebJX65H76o
X-Received: by 2002:ac8:4d02:: with SMTP id w2mr28319763qtv.170.1590420411955;
        Mon, 25 May 2020 08:26:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRYTEvDHkzZlN9N8OdVleY8RnsN2Eeh3cPWv0zTSlKo2jQXNjD4uFHPXMimAcfEA1Ah+yfiA==
X-Received: by 2002:ac8:4d02:: with SMTP id w2mr28319735qtv.170.1590420411698;
        Mon, 25 May 2020 08:26:51 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id s74sm15008079qka.54.2020.05.25.08.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 08:26:51 -0700 (PDT)
Date:   Mon, 25 May 2020 11:26:49 -0400
From:   Peter Xu <peterx@redhat.com>
To:     kbuild test robot <lkp@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kbuild-all@lists.01.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v9 05/14] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200525152649.GF1058657@xz-x1>
References: <20200523225659.1027044-6-peterx@redhat.com>
 <202005251058.wRNkniwm%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202005251058.wRNkniwm%lkp@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 10:48:08AM +0800, kbuild test robot wrote:
> Hi Peter,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on vhost/linux-next]
> [also build test WARNING on linus/master v5.7-rc7]
> [cannot apply to kvm/linux-next tip/auto-latest linux/master next-20200522]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Peter-Xu/KVM-Dirty-ring-interface/20200524-070926
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
> config: s390-randconfig-s002-20200524 (attached as .config)
> compiler: s390-linux-gcc (GCC) 9.3.0
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.1-240-gf0fe1cd9-dirty
>         # save the attached .config to linux build tree
>         make W=1 C=1 ARCH=s390 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>, old ones prefixed by <<):
> 
> arch/s390/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_page_in_dirty_ring':
> >> arch/s390/kvm/../../../virt/kvm/kvm_main.c:2932:16: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
> 2932 |  return (pgoff >= KVM_DIRTY_LOG_PAGE_OFFSET) &&
> |                ^~

Should be a false positive, since when KVM_DIRTY_LOG_PAGE_OFFSET==0 (true for
s390) then the code won't reach here at all due to the previous check [1].

I thought gcc should be able to directly remove the below code when it sees "if
(1) return false;", but it seems not...

I wanted to avoid using "#if" macros because I think it always makes the code
harder to read (especially when nested).  Maybe it's still ok to use one more
time here.

Thanks,

> 
> vim +2932 arch/s390/kvm/../../../virt/kvm/kvm_main.c
> 
>   2926	
>   2927	static bool kvm_page_in_dirty_ring(struct kvm *kvm, unsigned long pgoff)
>   2928	{
>   2929		if (!KVM_DIRTY_LOG_PAGE_OFFSET)
>   2930			return false;

[1]

>   2931	
> > 2932		return (pgoff >= KVM_DIRTY_LOG_PAGE_OFFSET) &&
>   2933		    (pgoff < KVM_DIRTY_LOG_PAGE_OFFSET +
>   2934		     kvm->dirty_ring_size / PAGE_SIZE);
>   2935	}
>   2936	


-- 
Peter Xu

