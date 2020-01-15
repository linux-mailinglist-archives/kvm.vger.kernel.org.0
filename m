Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65CA013D0A9
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 00:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730978AbgAOX1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 18:27:40 -0500
Received: from mga07.intel.com ([134.134.136.100]:6617 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbgAOX1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 18:27:39 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jan 2020 15:27:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,323,1574150400"; 
   d="scan'208";a="225762705"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 15 Jan 2020 15:27:39 -0800
Date:   Wed, 15 Jan 2020 15:27:38 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization
 out of nested_enable_evmcs()
Message-ID: <20200115232738.GB18268@linux.intel.com>
References: <20200115171014.56405-1-vkuznets@redhat.com>
 <20200115171014.56405-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115171014.56405-3-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 15, 2020 at 06:10:13PM +0100, Vitaly Kuznetsov wrote:
> With fine grained VMX feature enablement QEMU>=4.2 tries to do KVM_SET_MSRS
> with default (matching CPU model) values and in case eVMCS is also enabled,
> fails.

As in, Qemu is blindly throwing values at KVM and complains on failure?
That seems like a Qemu bug, especially since Qemu needs to explicitly do
KVM_CAP_HYPERV_ENLIGHTENED_VMCS to enable eVMCS.
