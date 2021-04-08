Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6234B357BF6
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 07:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhDHFpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 01:45:45 -0400
Received: from mga07.intel.com ([134.134.136.100]:34674 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229832AbhDHFpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 01:45:44 -0400
IronPort-SDR: wul/fQ8pFKBjBGEvzUbFx09nxr5EKMKvvF+UJ0HqixLXBA/qwv3Gq1HMPHlR+nHXswoK2bFEM6
 TWvPALHOx/ow==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="257449899"
X-IronPort-AV: E=Sophos;i="5.82,205,1613462400"; 
   d="scan'208";a="257449899"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 22:45:33 -0700
IronPort-SDR: zDLAZa4ZTeU4noyzOeujmfFmElelEGHNVhNvhd8QtcP+MmShxsnupOzFElXvjLBb8u4mawKSO0
 /khRKmJC3pwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,205,1613462400"; 
   d="scan'208";a="415599545"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga008.fm.intel.com with ESMTP; 07 Apr 2021 22:45:30 -0700
Message-ID: <543aeb306475eb1daa7a90482fd16920cf5c8c08.camel@linux.intel.com>
Subject: Re: [RFC PATCH 08/12] kvm/vmx: Refactor
 vmx_compute_tertiary_exec_control()
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chang.seok.bae@intel.com,
        kvm@vger.kernel.org, robert.hu@intel.com
Date:   Thu, 08 Apr 2021 13:45:29 +0800
In-Reply-To: <YGsw5UPoA/OpOIok@google.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
         <1611565580-47718-9-git-send-email-robert.hu@linux.intel.com>
         <YGsw5UPoA/OpOIok@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-04-05 at 15:46 +0000, Sean Christopherson wrote:
> On Mon, Jan 25, 2021, Robert Hoo wrote:
> > Like vmx_compute_tertiary_exec_control(), before L1 set VMCS,
> > compute its
> > nested VMX feature control MSR's value according to guest CPUID
> > setting.
> 
> I haven't looked through this series in depth, but why is it
> refactoring code
> that it introduces in the same series?  In other words, why not add
> the code
> that's needed right away?

Yes, this will be corrected in next version.

