Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78AA69E37A
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 16:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbjBUPdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 10:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbjBUPdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 10:33:16 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0D721A25;
        Tue, 21 Feb 2023 07:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676993592; x=1708529592;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fQUV+f/EDqJ7bb8Tm6ATv7kgDrwexd7UZ1n9UxbwncQ=;
  b=W+L1Hf+CGVabtLZwoCfNhW730pAukC4wljR92cePCHqVK2SMQrBiX9V1
   3+m39ODRWcFw+DAubCIHy5guZg6siLfhe459RL7Xh6Dklb9V8MI/QR8C8
   Vw9wRwSpiS1pBdIYWjX6R24lRR0gyxbZV0O28tlq0VO2n0q0mL3IN2C6g
   1bCE0v5sV+98kDUUhJnNw8kUJUZxm9rgEyPW4BR7xgWZZ7S2Hm7Mo8qDf
   kcF+tLzn/xfpI5Okt4Hj6xKv87dyEPDWi6aADtTFPCqK333jE9+/Y/PKr
   wmulDkwPCMRHCSUrLMCYwGMiEFYdqYUsD0eXoOUPrvHuv/T0M93qNuvvL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="313032171"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="313032171"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 07:33:11 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="740444637"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="740444637"
Received: from yichaohu-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.208.83])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 07:33:09 -0800
Date:   Tue, 21 Feb 2023 23:33:06 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] KVM: nSVM: Use KVM-governed feature framework to
 track "vVM{SAVE,LOAD} enabled"
Message-ID: <20230221153306.qubx7tfmasnvodeu@linux.intel.com>
References: <20230217231022.816138-1-seanjc@google.com>
 <20230217231022.816138-9-seanjc@google.com>
 <20230221152349.ulcjtbnvziair7ff@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221152349.ulcjtbnvziair7ff@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Sorry, why guest_cpuid_is_intel(vcpu)? Is it becasue that a AMD host with virtual
> VMSAVE/VMLOAD capability will always expose this feature for all AMD guests? 

Oh, sorry. I missed the guest_cpuid_has() in kvm_governed_feature_check_and_set().
So please just ignore my 2nd question.

As to the check of guest_cpuid_is_intel(), is it necessary?

B.R.
Yu
