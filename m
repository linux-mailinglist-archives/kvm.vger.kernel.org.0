Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04EB139A8E
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 21:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgAMUJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 15:09:43 -0500
Received: from mga07.intel.com ([134.134.136.100]:8591 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbgAMUJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 15:09:43 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jan 2020 12:09:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,430,1571727600"; 
   d="scan'208";a="397261117"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 13 Jan 2020 12:09:42 -0800
Date:   Mon, 13 Jan 2020 12:09:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        liran.alon@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2] KVM: nVMX: vmread should not set rflags to specify
 success in case of #PF
Message-ID: <20200113200942.GC2322@linux.intel.com>
References: <1577514324-18362-1-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1577514324-18362-1-git-send-email-linmiaohe@huawei.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 28, 2019 at 02:25:24PM +0800, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> In case writing to vmread destination operand result in a #PF, vmread
> should not call nested_vmx_succeed() to set rflags to specify success.
> Similar to as done in VMPTRST (See handle_vmptrst()).
> 
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
