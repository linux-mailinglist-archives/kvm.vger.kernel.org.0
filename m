Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F11FE1F94
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 17:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403912AbfJWPkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 11:40:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:44407 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390140AbfJWPkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 11:40:07 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 08:40:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,221,1569308400"; 
   d="scan'208";a="201170699"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 23 Oct 2019 08:40:06 -0700
Date:   Wed, 23 Oct 2019 08:40:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, boris.ostrovsky@oracle.com,
        jgross@suse.com, peterz@infradead.org, will@kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v8 3/5] x86/kvm: Add "nopvspin" parameter to disable PV
 spinlocks
Message-ID: <20191023154006.GN329@linux.intel.com>
References: <1571829384-5309-1-git-send-email-zhenzhong.duan@oracle.com>
 <1571829384-5309-4-git-send-email-zhenzhong.duan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571829384-5309-4-git-send-email-zhenzhong.duan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 23, 2019 at 07:16:22PM +0800, Zhenzhong Duan wrote:
> There are cases where a guest tries to switch spinlocks to bare metal
> behavior (e.g. by setting "xen_nopvspin" on XEN platform and
> "hv_nopvspin" on HYPER_V).
> 
> That feature is missed on KVM, add a new parameter "nopvspin" to disable
> PV spinlocks for KVM guest.
> 
> The new 'nopvspin' parameter will also replace Xen and Hyper-V specific
> parameters in future patches.
> 
> Define variable nopvsin as global because it will be used in future
> patches as above.
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krcmar <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Will Deacon <will@kernel.org>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
