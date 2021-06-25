Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC80E3B40E6
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 11:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhFYJxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 05:53:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:37060 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231417AbhFYJxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 05:53:34 -0400
IronPort-SDR: V2eKwfBIKMKGnaetBzcg9iMk2Ois7WB5kTUP5wIKqdm7R6iBMlxSC49Puzow7OF+s0skhnVCFY
 86Op8hESV9Jg==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="229236326"
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="229236326"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 02:51:13 -0700
IronPort-SDR: FR+/45s0NXxOPKeJXkvJ7pbsi3bIt+RopVJzBqpX/90W+xlF/radYKIfRX41XjYP18kShxiQWl
 qsGo5Q63ZVKw==
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="488124270"
Received: from junyuton-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.170.209])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 02:51:09 -0700
Date:   Fri, 25 Jun 2021 17:51:06 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 09/54] KVM: x86/mmu: Unconditionally zap unsync SPs when
 creating >4k SP at GFN
Message-ID: <20210625095106.mvex6n23lsnnsowe@linux.intel.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-10-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622175739.3610207-10-seanjc@google.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While reading the sync pages code, I just realized that patch
https://lkml.org/lkml/2021/2/9/212 has not be merged in upstream(
though it is irrelevant to this one). May I ask the reason? Thanks!

B.R.
Yu

