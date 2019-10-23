Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAD0E1F78
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 17:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406757AbfJWPie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 11:38:34 -0400
Received: from mga04.intel.com ([192.55.52.120]:9170 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406692AbfJWPie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 11:38:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 08:38:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,221,1569308400"; 
   d="scan'208";a="399432082"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 23 Oct 2019 08:38:33 -0700
Date:   Wed, 23 Oct 2019 08:38:33 -0700
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
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v8 2/5] x86/kvm: Change print code to use pr_*() format
Message-ID: <20191023153832.GM329@linux.intel.com>
References: <1571829384-5309-1-git-send-email-zhenzhong.duan@oracle.com>
 <1571829384-5309-3-git-send-email-zhenzhong.duan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571829384-5309-3-git-send-email-zhenzhong.duan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 23, 2019 at 07:16:21PM +0800, Zhenzhong Duan wrote:
> pr_*() is preferred than printk(KERN_* ...), after change all the print
> in arch/x86/kernel/kvm.c will have "kvm-guest: xxx" style.
> 
> No functional change.
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krcmar <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---

Reviewed-and-tested-by: Sean Christopherson <sean.j.christopherson@intel.com>
