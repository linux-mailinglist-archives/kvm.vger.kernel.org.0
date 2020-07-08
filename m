Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C70A218C21
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 17:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbgGHPpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 11:45:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:42581 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730238AbgGHPpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 11:45:22 -0400
IronPort-SDR: WCZWhubuDuW7BI2dw21HWvLUkP7qBSvDm2vUvvcuFonKlhivTzqHlwuOgKo878p5O2Mz79ReUt
 EUAh5uSJUl6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="149337381"
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="149337381"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 08:45:21 -0700
IronPort-SDR: vVJ+YMfwq3ur0VH8KzSE1sOfEtddPujVDIpc+ye2YEpKOlrzq7OuFIlkc/HJicq4D1FZ9JK1eZ
 NgdERwSKHSwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="388853900"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 08 Jul 2020 08:45:20 -0700
Date:   Wed, 8 Jul 2020 08:45:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM/x86: pmu: Fix #GP condition check for RDPMC emulation
Message-ID: <20200708154520.GB22737@linux.intel.com>
References: <20200708074409.39028-1-like.xu@linux.intel.com>
 <20200708151824.GA22737@linux.intel.com>
 <e285ccb3-29bd-dcb8-73d1-eeee11d72198@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e285ccb3-29bd-dcb8-73d1-eeee11d72198@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 08, 2020 at 05:31:14PM +0200, Paolo Bonzini wrote:
> The order follows the SDM.  I'm tempted to remove the CR0 check
> altogether, since non-protected-mode always runs at CPL0 AFAIK, but let's
> keep it close to what the manual says.

Heh, it wouldn't surprise me in the least if there's a way to get the SS
arbyte to hold a non-zero DPL in real mode :-).
