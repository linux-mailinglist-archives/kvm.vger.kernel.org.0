Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54EB27DD52
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 02:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbgI3ARy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 20:17:54 -0400
Received: from mga12.intel.com ([192.55.52.136]:32018 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728684AbgI3ARw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 20:17:52 -0400
IronPort-SDR: kDqAwDrfM81u1CmJ3qIc9LD1N0rpdVEPEHMoPai4s5MQyaRYxfrSClHC1s5GG5PLa/48y+6dRH
 kCwM8eXPM4Gg==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="141728216"
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="141728216"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 17:17:51 -0700
IronPort-SDR: 1TxDgN72vnVlAkifBSOTGKhB5mvOfygN5RfbPa5AseKnsAL7R1RPZqTEelaeiZ3SthVemGlq2V
 rLBGceo6FJGA==
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="494346963"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 17:17:50 -0700
Date:   Tue, 29 Sep 2020 17:17:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH kvm] KVM: VMX: vmx_uret_msrs_list[] can be static
Message-ID: <20200930001749.GF32531@linux.intel.com>
References: <202009282300.GKb6ot6E%lkp@intel.com>
 <20200928153714.GA6285@a3a878002045>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928153714.GA6285@a3a878002045>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 28, 2020 at 11:37:14PM +0800, kernel test robot wrote:
> 
> Fixes: 14a61b642de9 ("KVM: VMX: Rename "vmx_msr_index" to "vmx_uret_msrs_list"")
> Signed-off-by: kernel test robot <lkp@intel.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
