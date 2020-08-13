Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBDAE243C08
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 16:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgHMO51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 10:57:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:63083 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbgHMO51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 10:57:27 -0400
IronPort-SDR: 7WWvrclkTV4CVr52TPwTIsFUYsfokfOtzzwophr6YfGNzqPKSCqSz5zX9flxYdD/aMB5qP0m5X
 DfKEWKSkAPzw==
X-IronPort-AV: E=McAfee;i="6000,8403,9712"; a="142070131"
X-IronPort-AV: E=Sophos;i="5.76,308,1592895600"; 
   d="scan'208";a="142070131"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2020 07:57:26 -0700
IronPort-SDR: Ig6SZEbpML6NTOhKkMh3YZi+L12EGG8odysHxz3Wm6CdjlIGgiKKklKItAPYMIQhUki+AjDnwT
 Lm6J7+49jrMA==
X-IronPort-AV: E=Sophos;i="5.76,308,1592895600"; 
   d="scan'208";a="470236490"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2020 07:57:25 -0700
Date:   Thu, 13 Aug 2020 07:57:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 1/2] KVM: LAPIC: Return 0 when getting the tscdeadline
 timer if the lapic is hw disabled
Message-ID: <20200813145724.GE29439@linux.intel.com>
References: <1597213838-8847-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597213838-8847-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 12, 2020 at 02:30:37PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Return 0 when getting the tscdeadline timer if the lapic is hw disabled.

It'd be helpful to reference the SDM for the general behavior of the MSR.

  In other timer modes (LVT bit 18 = 0), the IA32_TSC_DEADLINE MSR reads
  zero and writes are ignored.

I'd also vote to squash the two patches together, they really are paired
changes to match the architectural behavior.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
