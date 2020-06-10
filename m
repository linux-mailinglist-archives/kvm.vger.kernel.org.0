Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A966E1F5985
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 18:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgFJQ4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 12:56:37 -0400
Received: from mga03.intel.com ([134.134.136.65]:46920 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbgFJQ4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 12:56:36 -0400
IronPort-SDR: hjQWYtaK5OFKhg0sg8vcXUCzzxQTtnaM91n4VUev8qBxo2j8wGKQV+myNTctKrPv77u9mwkJKP
 7P9AZ5LkYuUA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2020 09:56:36 -0700
IronPort-SDR: vHN1fkctrzd3E9h6K8v2Zr1SvipXikofTBDthZx/YXQZ1SgFvJE+y9aPZwRkiaCnG4wHhnhArQ
 tPpvogBhvd6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,496,1583222400"; 
   d="scan'208";a="260208102"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga007.jf.intel.com with ESMTP; 10 Jun 2020 09:56:36 -0700
Date:   Wed, 10 Jun 2020 09:56:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v12 00/10] Introduce support for guest CET feature
Message-ID: <20200610165635.GB18790@linux.intel.com>
References: <20200506082110.25441-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506082110.25441-1-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 04:20:59PM +0800, Yang Weijiang wrote:
> Several parts in KVM have been updated to provide VM CET support, including:
> CPUID/XSAVES config, MSR pass-through, user space MSR access interface, 
> vmentry/vmexit config, nested VM etc. These patches have dependency on CET
> kernel patches for xsaves support and CET definitions, e.g., MSR and related
> feature flags.

Other than the MSR and cpufeatures flags definitions, is there any direct
dependency on kernel CET support?  I.e. if/when XSAVES support is merged,
is there anything beyond the architectural definitions that are required to
merge KVM CET virtualization?
