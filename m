Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C865933CD
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 19:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbiHORF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 13:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiHORF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 13:05:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6044636D;
        Mon, 15 Aug 2022 10:05:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58B24B8102C;
        Mon, 15 Aug 2022 17:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F1EC4314A;
        Mon, 15 Aug 2022 17:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660583152;
        bh=fsvEKFbRbSDv04fTMLpl6zxZMxNaTblwWd8OSQ8qC6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n2ca+2bE7miYdY9MQ/iS++z3jXsx6aNkFbyNbvxEzORjz8pdvApM5IJ2+GigFyA+n
         5dYRvy6CU9savsde+lTQSZ73SyjvX63CBWxTb/1x5fREwiQx2czuVDJdkf47kSPyn2
         JRSUuh2nbSgju64n5k8GDcnZMYCRqgn3AAbv5IMWgzL3rBrU/QeqRkR08b/De1SqyM
         Rn7hds6qQoSk4u7VV/OEJj2WTx6EVs4XTdCv/HOWAI/iiu6iXrwdkQq/5vCNUoQ06N
         n1uQ8Jz4In3HyNP9kG60RJMVM1GXWZtnin/aQeSxdeUNYVAcRX4w5YJcez23oznEoo
         4ZUYfUvKWL9nA==
Date:   Mon, 15 Aug 2022 10:05:50 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kernel test robot <lkp@intel.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [stable:linux-5.15.y 5373/9027] arch/x86/kvm/hyperv.c:2185:5:
 warning: stack frame size (1036) exceeds limit (1024) in 'kvm_hv_hypercall'
Message-ID: <Yvp87jlVWg0e376v@dev-arch.thelio-3990X>
References: <202208142025.NHKErAjq-lkp@intel.com>
 <87zgg6sza8.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgg6sza8.fsf@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 15, 2022 at 10:10:07AM +0200, Vitaly Kuznetsov wrote:
> kernel test robot <lkp@intel.com> writes:
> 
> > Hi Vitaly,
> >
> > FYI, the error/warning still remains.
> >
> 
> Yes, this is expected as the patch which is supposed to 'fix' this is
> still pendind. The latest version is here:
> 
> https://lore.kernel.org/kvm/20220803134540.399220-1-vkuznets@redhat.com/
> 
> ...
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
> > head:   7217df81279835a7aee62a07aabb7b8fb8c766f2
> > commit: cb188e07105f2216f5efbefac95df4b6ce266906 [5373/9027] KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM fast hypercall
> > config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20220814/202208142025.NHKErAjq-lkp@intel.com/config)
> > compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 52cd00cabf479aa7eb6dbb063b7ba41ea57bce9e)
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/?id=cb188e07105f2216f5efbefac95df4b6ce266906
> >         git remote add stable https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
> >         git fetch --no-tags stable linux-5.15.y
> >         git checkout cb188e07105f2216f5efbefac95df4b6ce266906
> >         # save the config file
> >         mkdir build_dir && cp config build_dir/.config
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kvm/
> >
> > If you fix the issue, kindly add following tag where applicable
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> >>> arch/x86/kvm/hyperv.c:2185:5: warning: stack frame size (1036) exceeds limit (1024) in 'kvm_hv_hypercall' [-Wframe-larger-than]
> >    int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> >        ^
> >    1 warning generated.
> >
> >
> > vim +/kvm_hv_hypercall +2185 arch/x86/kvm/hyperv.c
> >
> > 4ad81a91119df7 Vitaly Kuznetsov         2021-05-21  2184  
> > e83d58874ba1de Andrey Smetanin          2015-07-03 @2185  int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> > e83d58874ba1de Andrey Smetanin          2015-07-03  2186  {
> > 4e62aa96d6e55c Vitaly Kuznetsov         2021-07-30  2187  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> > bd38b32053eb1c Siddharth Chandrasekaran 2021-05-26  2188  	struct kvm_hv_hcall hc;
> > bd38b32053eb1c Siddharth Chandrasekaran 2021-05-26  2189  	u64 ret = HV_STATUS_SUCCESS;
> 
> ... but let me repeat myself: (see my previous reply here:
> https://lore.kernel.org/kvm/874jyw2v5n.fsf@redhat.com/)
> The source of the problem seems to be that Clang probably inlines
> kvm_hv_send_ipi() as on-stack variables in kvm_hv_hypercall() can not
> exceed 1024 bytes limit (struct kvm_hv_hcall is 144 bytes, the rest is
> negligible). The patch I mention above will likely fix the issue as it
> significantly reduces on-stack allocations in kvm_hv_send_ipi() but in
> this situation it shouldn't be inlined in the first place.

I seem to recall Nick mentioning at some point that LLVM gives a massive
inlining discount to functions that are only called once so I guess that
would explain why kvm_hv_send_ipi() gets inlined into
kvm_hv_hypercall(). I think there are some inlining cost flags we could
experiment with to see if we can avoid inlining functions with high
stack usage into other functions. Additionally, the configurations that
reported this warning are allmodconfig and allyesconfig, which enable
KASAN, which is known to use more stack usage with clang:

https://github.com/ClangBuiltLinux/linux/issues/39

I am hoping we'll get to addressing that during our meet up right before
Plumbers but we'll see.

> (I still hope that I'm wrong finger pointing at the compiler here and
> someone smart will come to correct me :-)

Other folks more familiar with the LLVM side of things might correct me
:)

Cheers,
Nathan
