Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477944D5281
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 20:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238989AbiCJTpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 14:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiCJTpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 14:45:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8020198EE1
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 11:44:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50E06B825DB
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C84C340E8;
        Thu, 10 Mar 2022 19:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646941455;
        bh=1I6monj8Z80bkIg29uwQzm498syCFKo8PKbjOheNRj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e2sipm9ZeVufcrhX8Hgh2DfYiJ1srdCUKpFl7TTrvGTi6cT4TkBK2iVqo3TxooJIA
         3jqIBPpGu0CmrOT32DeWYFiTm2YXnp44uVt6WfuKxuQCptiEjlAyH20vDDwDFD+wgw
         foleS6LWcJYPV7dS54byuUxK73qyBIqOxpXo2G2tvRtSmOzSaeYvX/HUB6IiJludIO
         qaWlywJuVQIrxE0rVgcMiifzP5K42bnF6M73sodkfY8gEK5anXZq3bF7kf7GjGMb30
         8i9Xc8l3U8GyuqQUo+WJL8ryLL9d7orqL87sO5+pAbTUVatFD+uB6sQoaFpnPXYdy6
         5NXMysl6sGDmg==
Date:   Thu, 10 Mar 2022 12:44:07 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Li RongQing <lirongqing@baidu.com>, llvm@lists.linux.dev,
        kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm:queue 182/205] <inline asm>:40:208: error: expected
 relocatable expression
Message-ID: <YipVB6MiWdjY3HI3@dev-arch.thelio-3990X>
References: <202203100905.1o88Cp2l-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202203100905.1o88Cp2l-lkp@intel.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 10, 2022 at 09:28:32AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> head:   8c1db5a775bc8314d78e99263e0d063a01b692c2
> commit: 4ab22f38c2046f2c949cb43fc0f7515666a2a2fb [182/205] KVM: x86: Support the vCPU preemption check with nopvspin and realtime hint
> config: x86_64-randconfig-a012 (https://download.01.org/0day-ci/archive/20220310/202203100905.1o88Cp2l-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 276ca87382b8f16a65bddac700202924228982f6)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=4ab22f38c2046f2c949cb43fc0f7515666a2a2fb
>         git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>         git fetch --no-tags kvm queue
>         git checkout 4ab22f38c2046f2c949cb43fc0f7515666a2a2fb
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
> >> <inline asm>:40:208: error: expected relocatable expression
>    .pushsection .text;.global __raw_callee_save___kvm_vcpu_is_preempted;.type __raw_callee_save___kvm_vcpu_is_preempted, @function;__raw_callee_save___kvm_vcpu_is_preempted:movq  __per_cpu_offset(,%rdi,8), %rax;cmpb    $0, KVM_STEAL_TIME_preempted+steal_time(%rax);setne     %al;ret;.size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;.popsection
>                                                                                                                                                                                                                    ^
>    1 error generated.

It looks like there is a new revision of the patch that should resolve
this.

https://lore.kernel.org/r/1646891689-53368-1-git-send-email-lirongqing@baidu.com/

It happens with GCC / GNU as too.

/tmp/cc6grhKv.s: Assembler messages:
/tmp/cc6grhKv.s:52: Error: invalid operands (*UND* and .data sections) for `+'

Cheers,
Nathan
