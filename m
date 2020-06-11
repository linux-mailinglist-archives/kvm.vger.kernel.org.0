Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9411F5F78
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 03:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgFKB2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 21:28:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:15014 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgFKB2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 21:28:38 -0400
IronPort-SDR: EQPNe0vNgmOeu+IVk0MQgstMGO2IlRLUWgUm3mbrvPmy+oCzFbdzT6l9rFuvVF+hGaFf/Tqfja
 QgiHS7YHaOeA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2020 18:28:38 -0700
IronPort-SDR: TDwZrLfXKyCPyLkRMz+erSgA3fgoVSeC0VxAIc+HU7rjn60eWjqAMO9lF9+BapzJ7p9RTyr8x5
 07RBzg00SO+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,498,1583222400"; 
   d="scan'208";a="259471853"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jun 2020 18:28:36 -0700
Date:   Thu, 11 Jun 2020 09:29:13 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v12 00/10] Introduce support for guest CET feature
Message-ID: <20200611012913.GA15497@local-michael-cet-test>
References: <20200506082110.25441-1-weijiang.yang@intel.com>
 <20200610165635.GB18790@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610165635.GB18790@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 09:56:36AM -0700, Sean Christopherson wrote:
> On Wed, May 06, 2020 at 04:20:59PM +0800, Yang Weijiang wrote:
> > Several parts in KVM have been updated to provide VM CET support, including:
> > CPUID/XSAVES config, MSR pass-through, user space MSR access interface, 
> > vmentry/vmexit config, nested VM etc. These patches have dependency on CET
> > kernel patches for xsaves support and CET definitions, e.g., MSR and related
> > feature flags.
> 
> Other than the MSR and cpufeatures flags definitions, is there any direct
> dependency on kernel CET support?  I.e. if/when XSAVES support is merged,
> is there anything beyond the architectural definitions that are required to
> merge KVM CET virtualization?
No, KVM CET patches only depend on kernel CET related definitions and XSAVES 
support now. But to make guest CET work, we need CET patches for QEMU. 
