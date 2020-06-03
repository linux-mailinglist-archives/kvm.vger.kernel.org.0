Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455C61EC66F
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 03:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgFCBLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 21:11:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:56913 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFCBLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 21:11:03 -0400
IronPort-SDR: tN39wWCFx+LpszOWJ+ipem7WIQlYiyLQdAB3X+qc0sRsp52cKEeNo494p76WJLAyHMnsxYrbp1
 DR3LJ4XD8GIQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 18:11:02 -0700
IronPort-SDR: 1A5GzQdoUcCXCdwGiIkBOBkikTrv6NL0nVW4C178usULtgGkjC1QVLXCKIyIJjpPmX+UsH2K/U
 KgHmd3h3Hb/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,466,1583222400"; 
   d="scan'208";a="258477860"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 02 Jun 2020 18:10:59 -0700
Date:   Tue, 2 Jun 2020 18:10:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] KVM: X86: Split kvm_update_cpuid()
Message-ID: <20200603011059.GB24169@linux.intel.com>
References: <20200529085545.29242-1-xiaoyao.li@intel.com>
 <20200529085545.29242-5-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529085545.29242-5-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 29, 2020 at 04:55:43PM +0800, Xiaoyao Li wrote:
> Split the part of updating KVM states from kvm_update_cpuid(), and put
> it into a new kvm_update_state_based_on_cpuid(). So it's clear that
> kvm_update_cpuid() is to update guest CPUID settings, while
> kvm_update_state_based_on_cpuid() is to update KVM states based on the
> updated CPUID settings.

What about kvm_update_vcpu_model()?  "state" isn't necessarily correct
either.
