Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF361123AC4
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 00:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfLQXZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 18:25:44 -0500
Received: from mga05.intel.com ([192.55.52.43]:50344 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbfLQXZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 18:25:44 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 15:25:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,327,1571727600"; 
   d="scan'208";a="209880756"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2019 15:25:43 -0800
Date:   Tue, 17 Dec 2019 15:25:43 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] KVM: vmx: delete meaningless
 nested_vmx_prepare_msr_bitmap() declaration
Message-ID: <20191217232543.GI11771@linux.intel.com>
References: <1576306125-18843-1-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576306125-18843-1-git-send-email-linmiaohe@huawei.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 14, 2019 at 02:48:45PM +0800, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> The function nested_vmx_prepare_msr_bitmap() declaration is below its
> implementation. So this is meaningless and should be removed.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
