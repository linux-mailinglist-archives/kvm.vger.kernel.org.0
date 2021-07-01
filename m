Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EE43B9623
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 20:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhGASaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 14:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhGASaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 14:30:04 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60CEC061762
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 11:27:32 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so4465518pjo.3
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 11:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7QXXcUHR5SdmSl1rk9LFsFtBV30ZJm0VXX3f2hS40gU=;
        b=RZb62gmWRg1VP2419PrBZqRdnKcooYMY9xG/glDXUxhKiESIuvOWPpWnLhT5uuo91n
         w+n7KuMNHjxvgaiDG+oIzYVz8UL3/z9xK2O7ZQoIzajuD5JQp9ETNEw4O+6g0smEs9lk
         +QwDNMdxwmlj1eixqmHSFAZLdUsZ72LhqB5d9gs7BFQNwUU7qJTfRqJ4KIID/l24xbKg
         4FKJeKsVJy67FoXUbXUoS+6vp13yi7bHlt8/Oso6PpfEmZ/IdwYbqy4YV268zv3/5JAk
         Qgl/TnEs7wVOPEQBxB2bArKVSBBWiuPpNFp32cBSz9wdC2YBgM6BcHeLTQi/pdtLYlBF
         qFgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7QXXcUHR5SdmSl1rk9LFsFtBV30ZJm0VXX3f2hS40gU=;
        b=k6mwOGLZmVvVeY2jLxEMUIHr2CflAjPCfq4OGP2jbCBl+J0Ih+xyJnyU2PyYThe4kV
         kQzGdPS1L+Y4cZE89DL0SB1wlhosmVgRHqXVx9hfmsx8zg7LJ6bH72AJVWXh4fJhYjCF
         krzn/q8DXoEVyoSlypBwUZAdjv0ZPLc9hi6Hrci7ohvpjCRmo7oOwEjC/u/ROhHwGhXR
         LgGAzBZFlkmKiGvXwiCmcLHwilA+U98kfBPZA9KcwOr24velbGfY9rto6SgA+8Q57a7v
         41vaudfQ8iVIMdJFgNG+oyxCgXVl5nFB6xSSWedSuLyV6std/Udo+354/YfEhL/Xbl8c
         TG7Q==
X-Gm-Message-State: AOAM533uqV2GBFGzA+GN5bSRIlC3Fvf96xC08tZWuhRjNMa7yihUKCjd
        F8zB3b7vHQtm3tvcIBrdgx9bfw==
X-Google-Smtp-Source: ABdhPJzFlTAwnldUt/7pcmf343s13Yc2txaytH2juohKc0zrfIso88y16971TzNhnPpNqhDyALIN5A==
X-Received: by 2002:a17:90a:4091:: with SMTP id l17mr960875pjg.12.1625164052242;
        Thu, 01 Jul 2021 11:27:32 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id m16sm728245pfo.1.2021.07.01.11.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 11:27:31 -0700 (PDT)
Date:   Thu, 1 Jul 2021 18:27:28 +0000
From:   David Matlack <dmatlack@google.com>
To:     kernel test robot <lkp@intel.com>
Cc:     kvm@vger.kernel.org, kbuild-all@lists.01.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: fast_page_fault support for the TDP
 MMU
Message-ID: <YN4JEBLXE9vVBjC5@google.com>
References: <20210630214802.1902448-5-dmatlack@google.com>
 <202107011212.FwmbO1RX-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202107011212.FwmbO1RX-lkp@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 01, 2021 at 12:27:58PM +0800, kernel test robot wrote:
> 
> >> arch/x86/kvm/mmu/mmu.c:3119:6: error: no previous prototype for 'get_last_sptep_lockless' [-Werror=missing-prototypes]
>     3119 | u64 *get_last_sptep_lockless(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
>          |      ^~~~~~~~~~~~~~~~~~~~~~~

get_last_sptep_lockless should be static. I will include a fix in the
next version of this series.
