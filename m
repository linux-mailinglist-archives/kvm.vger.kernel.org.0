Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 274A1139A95
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 21:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgAMULF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 15:11:05 -0500
Received: from mga14.intel.com ([192.55.52.115]:21225 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgAMULF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 15:11:05 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jan 2020 12:11:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,430,1571727600"; 
   d="scan'208";a="218762103"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jan 2020 12:11:04 -0800
Date:   Mon, 13 Jan 2020 12:11:04 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        liran.alon@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2] KVM: nVMX: vmread should not set rflags to specify
 success in case of #PF
Message-ID: <20200113201103.GD2322@linux.intel.com>
References: <1577514324-18362-1-git-send-email-linmiaohe@huawei.com>
 <20200113200942.GC2322@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113200942.GC2322@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 13, 2020 at 12:09:42PM -0800, Sean Christopherson wrote:
> On Sat, Dec 28, 2019 at 02:25:24PM +0800, linmiaohe wrote:
> > From: Miaohe Lin <linmiaohe@huawei.com>
> > 
> > In case writing to vmread destination operand result in a #PF, vmread
> > should not call nested_vmx_succeed() to set rflags to specify success.
> > Similar to as done in VMPTRST (See handle_vmptrst()).
> > 
> > Reviewed-by: Liran Alon <liran.alon@oracle.com>
> > Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> 
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

Gah, got trigger happy.  This could also have "Cc: stable@vger.kernel.org".
With that, my Reviewed-by stands :-).
