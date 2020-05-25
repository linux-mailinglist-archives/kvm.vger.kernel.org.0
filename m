Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBFD1E11D6
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 17:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404216AbgEYPeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 11:34:10 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60248 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404066AbgEYPeI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 May 2020 11:34:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590420846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o1s5zuPCbjv4W1F4qB4hsqDOidZ/dEXbHAB3GqNTJXQ=;
        b=V25+vmvqzl8gty1xG37hc4yU8HeOdHIKwEj4+03qtW/v3Vl7S52cNqo/bLS9BUOWJLUoKM
        Sx+ssOiRCiYtSpMqgxgmMVOa1YA+mtIZgJrdm6EuRrwb98rznmDwx9VI2+xzAm8pWpVn9F
        kgAwRL+jWq4+KAsF+FBHypJEMprwKxA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-j75taoWnNwSXLGptWmdAMg-1; Mon, 25 May 2020 11:33:52 -0400
X-MC-Unique: j75taoWnNwSXLGptWmdAMg-1
Received: by mail-qt1-f197.google.com with SMTP id p20so6953224qtq.13
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:33:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o1s5zuPCbjv4W1F4qB4hsqDOidZ/dEXbHAB3GqNTJXQ=;
        b=IRGS4LXym7MzN7Ipb+LGUnYnLx9pM5PbE7M/0YQVOIfiS591x93fZFI+wLuBGzOSc8
         Zg2z3gEflq+U3SKX5zNN8WXJpd3Npk9mbGl2nVHQUus8eCk3ysOHUmc7K7x23qkkJqH6
         /SIAcahIRxpap78MUIkRYPc4rdS7LB/MoxZLrrDyQRFw4gGCQLGtqGqg46pLH92h3uIP
         egLjWBIMoPIN/cfZSXZ+ZjdTe5ihV33BcUIvt0YTAWy+87aynn2irPR9HaMxMxBGFPXP
         Q+berbgMIQ9nbiZltrE0CjlVIaxNzp9Wai2Ok3h5nUURJ+k3A1pT/VloTPZ/0zYBurgy
         x45Q==
X-Gm-Message-State: AOAM532sIFKzLtBUjr90dv9o0chm7sVXJTPywV8r7+ieWwF4rtllN9aZ
        1Lx1DOdT+AAYH6Aqup6/30xH2wAMS/oniYWzASkaeVTtEaDoWUevqYQdq5BqHNb4tn+laV6VyaQ
        7nAbZHifyd+2d
X-Received: by 2002:a37:7143:: with SMTP id m64mr26064114qkc.27.1590420831691;
        Mon, 25 May 2020 08:33:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMgbQT9zZHhsACJ6JIUxvphkrjM3Sc4JuKOREGxqwcWEftYz9SdklT7uY+WRjYzsggI7Jw5g==
X-Received: by 2002:a37:7143:: with SMTP id m64mr26064085qkc.27.1590420831299;
        Mon, 25 May 2020 08:33:51 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id p11sm3160489qtq.75.2020.05.25.08.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 08:33:50 -0700 (PDT)
Date:   Mon, 25 May 2020 11:33:47 -0400
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
Message-ID: <20200525153347.GG1058657@xz-x1>
References: <20200523225659.1027044-6-peterx@redhat.com>
 <202005252245.ZeOB8qNJ%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202005252245.ZeOB8qNJ%lkp@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 10:54:58PM +0800, kbuild test robot wrote:
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
> config: x86_64-allyesconfig (attached as .config)
> compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
> reproduce (this is a W=1 build):
>         # save the attached .config to linux build tree
>         make W=1 ARCH=x86_64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>, old ones prefixed by <<):
> 
> >> arch/x86/kvm/../../../virt/kvm/dirty_ring.c:33:6: warning: no previous prototype for 'kvm_dirty_ring_full' [-Wmissing-prototypes]
> bool kvm_dirty_ring_full(struct kvm_dirty_ring *ring)
> ^~~~~~~~~~~~~~~~~~~

I'll add a "static" to quiesce this..

> --
> arch/x86/kvm/vmx/vmx.c: In function 'init_rmode_identity_map':
> >> arch/x86/kvm/vmx/vmx.c:3472:12: warning: variable 'identity_map_pfn' set but not used [-Wunused-but-set-variable]
> kvm_pfn_t identity_map_pfn;
> ^~~~~~~~~~~~~~~~

Hmm, this seems to be true but not related to this series afaict...  but sure I
can add another patch to remove it.

> 
> vim +/kvm_dirty_ring_full +33 arch/x86/kvm/../../../virt/kvm/dirty_ring.c
> 
>     32	
>   > 33	bool kvm_dirty_ring_full(struct kvm_dirty_ring *ring)
>     34	{
>     35		return kvm_dirty_ring_used(ring) >= ring->size;
>     36	}
>     37	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org



-- 
Peter Xu

