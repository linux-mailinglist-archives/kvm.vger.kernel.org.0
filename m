Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E190723A908
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 17:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgHCPAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 11:00:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:24353 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726799AbgHCPAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 11:00:01 -0400
IronPort-SDR: zJIUeWrLYzFQz2PAlP86v4psZsRGczRPiCVs9cDlsw84igvOh99O3QNUdWnuP5OccdSb2HKESD
 wDUfRoVt/ccQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="132172253"
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="132172253"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 08:00:00 -0700
IronPort-SDR: 8brbl9eKV+8r54JGxJ1DaX3KNuoEq+Ue77rBltIYg0jXHiSQAFQyaVL6uJTuNTHfHZF4cpUlz7
 3YSc1g6zifpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="305854684"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga002.jf.intel.com with ESMTP; 03 Aug 2020 08:00:00 -0700
Date:   Mon, 3 Aug 2020 08:00:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Eric van Tassell <evantass@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH 0/8] KVM: x86/mmu: Introduce pinned SPTEs framework
Message-ID: <20200803150000.GA3151@linux.intel.com>
References: <20200731212323.21746-1-sean.j.christopherson@intel.com>
 <b5cc5643-4790-3c88-e767-1a7506afb2ae@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5cc5643-4790-3c88-e767-1a7506afb2ae@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 02, 2020 at 10:00:13PM -0500, Eric van Tassell wrote:
> Sean,
> 	What commit did you base your series  on?

Gah, sorry.

kvm/queue, commit 9c2475f3e46a1 ("KVM: Using macros instead of magic values").
