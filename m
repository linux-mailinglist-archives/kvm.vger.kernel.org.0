Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A31532B61
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 15:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237717AbiEXNgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 09:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbiEXNgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 09:36:23 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4593B6EC52;
        Tue, 24 May 2022 06:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653399382; x=1684935382;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=z7fDSvb7bJJotlzyGMMfrAMGEu9gb9bj8HturWMzfJQ=;
  b=d/nk5KO1psPIjHcPMIfoIC41alqaBrW3ThzeBZFuQXjUiXRr3ajVmGvF
   lRdI6BjN8tZS+1gWE+zzzd3nt8CHB8qmUfxTIXzk2zR2/nzcOWcuyUePW
   xN8kEEy8Gna6SKir6R3jrvI+2Nuf2LxTKZBY4kbRSISsNFO0XaM8XZK5j
   9dx/3qrgOgDj3rCTLKp6Ns2yUFxRTne9KwBp1IoX113VmMivXqTesR02C
   tDrbkWuD79e9PI+22kOtVXAH6umA1JEnpAj+xGmsWHsIDSxydjkJNeeEI
   daCX1fHXTLcgBblz8WDK60fkwKcB73J99IsuLBf1wWlKlRifyzGQ76xce
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="254030877"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="254030877"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:36:21 -0700
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="548476350"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.143])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:36:18 -0700
Date:   Tue, 24 May 2022 21:36:05 +0800
From:   Oliver Sang <oliver.sang@intel.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@lists.01.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: Re: [KVM] db16e9b28b: kvm-unit-tests.pmu.fail
Message-ID: <20220524133604.GA34870@xsang-OptiPlex-9020>
References: <20220515092217.GD10578@xsang-OptiPlex-9020>
 <d741a183-6180-1a49-fffb-b62d36286a04@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d741a183-6180-1a49-fffb-b62d36286a04@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like Xu,

On Sun, May 15, 2022 at 05:25:21PM +0800, Like Xu wrote:
> On 15/5/2022 5:22 pm, kernel test robot wrote:
> > patch link:https://lore.kernel.org/kvm/20220509102204.62389-2-likexu@tencent.com
> 
> Fixed by the V2 version. Please help try.

we tested the V2 version and could not reproduce pmu.fail on it:

=========================================================================================
compiler/kconfig/rootfs/tbox_group/testcase/ucode:
  gcc-11/x86_64-rhel-8.3-func/debian-10.4-x86_64-20200603.cgz/lkp-hsw-d02/kvm-unit-tests/0x28

commit:
  bec9b596f911 ("KVM: x86/pmu: Ignore pmu->global_ctrl check if vPMU doesn't support global_ctrl")
  db16e9b28b05 ("KVM: x86/pmu: Don't pre-set the pmu->global_ctrl when refreshing")
  3fa1b82c692b ("KVM: x86/pmu: Don't pre-set the pmu->global_ctrl when refreshing") v2

bec9b596f911252e db16e9b28b05f069d01b76886b6 3fa1b82c692b513878a23e07efc
---------------- --------------------------- ---------------------------
       fail:runs  %reproduction    fail:runs  %reproduction    fail:runs
           |             |             |             |             |
           :6           50%           3:3            0%            :10    kvm-unit-tests.pmu.fail


