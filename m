Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD93C50342C
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 07:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiDPDRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 23:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiDPDRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 23:17:06 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92EA6359
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 20:14:35 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so9663469pjb.1
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 20:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wFIQOSXR4x/8ZkuPhmNVYc5SLOVhYVXC0bqfpbFA+w0=;
        b=HtOXwdvTaXKVjdCmHoL0PUpMEtLUHy8RMKgTsKGurJzrQqXA2wFssOZN+0MJKLsdpJ
         upn88zC7RUGFhFD+dbnjFn/AoLDmKwmNiyBgTUuL3WUoTru2PmX5kqMAYurxTY/f/zmm
         Ul8AEXP96yYKt7+eylByN5X6Hl5fHMQgY/NdMDXS3KaMQt7OjmR2F6gLr2yHerWfZyzB
         OBa+PhGpjH8thuZAWoCTSg0BupVZ1NPVL1W4osaBjdwhESrU2f3jNu1gPtq34O9jHXua
         ZYJm84Q/RgTaYto+I4wDuS0DOap+khEtEYGoJ9rK1R3OIRR3q63TPYVMNxtzBCiHot7r
         ABgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wFIQOSXR4x/8ZkuPhmNVYc5SLOVhYVXC0bqfpbFA+w0=;
        b=LJbepz9X8q8NKRMW88aotKPfCYPYZAdmgyRTSoaDcqUxLhYnLhuUZsOc291VdEeIJs
         r6DoWnwJ+AvzWJJNejd6W0AyFP5tFgkVIpCBvjhntw0/v80FQx8ackPERmkvtwDFxMaa
         jfu1MhXTYXpGzGWu3a/5xKwPiH8kL/ID6R4KpuitzS9x0SxShVAwuqd9pojOSEtX25bl
         X8soSpwRFrp9bGk+Bjycms8UhcgHFVHiKLqmUTk7P3OVK8mbVpZdBI4QpKUPEd4daqHw
         hmzG/F9l+ZAqCC7nDjs0uOeAWkDUOn4Io/0LAhNBQhJdvEHanugkVRz2p791uQ+Cpg3E
         XRZg==
X-Gm-Message-State: AOAM533OHrmTYej9tnQWOpk3K0DqIe2hFonbctrg61qpUk1DCOg+ougd
        BfsEVSLWwSmnWH2ZSi3tDmS10CiUQOp6bw==
X-Google-Smtp-Source: ABdhPJyK6EE/XOptVzWZ4v5BCHFJiScWEY0eUyu/+NHOzGfW0T+zfj3+n45SjHpx75Z0LG3cqVa0uQ==
X-Received: by 2002:a17:90b:2385:b0:1cb:74f7:6517 with SMTP id mr5-20020a17090b238500b001cb74f76517mr2010664pjb.142.1650078875138;
        Fri, 15 Apr 2022 20:14:35 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm5662640pge.23.2022.04.15.20.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 20:14:34 -0700 (PDT)
Date:   Sat, 16 Apr 2022 03:14:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Peter Gonda <pgonda@google.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm:next 27/32] arch/arm64/kvm/psci.c:184:32: error: 'struct
 <anonymous>' has no member named 'flags'
Message-ID: <Ylo0l99k5pK2uBPo@google.com>
References: <202204160436.TdR8eFO0-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202204160436.TdR8eFO0-lkp@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 16, 2022, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git next
> head:   5d6c7de6446e9ab3fb41d6f7d82770e50998f3de
> commit: c24a950ec7d60c4da91dc3f273295c7f438b531e [27/32] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
> config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20220416/202204160436.TdR8eFO0-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=c24a950ec7d60c4da91dc3f273295c7f438b531e
>         git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>         git fetch --no-tags kvm next
>         git checkout c24a950ec7d60c4da91dc3f273295c7f438b531e
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm64 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    arch/arm64/kvm/psci.c: In function 'kvm_prepare_system_event':
> >> arch/arm64/kvm/psci.c:184:32: error: 'struct <anonymous>' has no member named 'flags'
>      184 |         vcpu->run->system_event.flags = flags;
>          |                                ^

Known issue, WIP.  https://lore.kernel.org/all/YlisiF4BU6Uxe+iU@google.com
