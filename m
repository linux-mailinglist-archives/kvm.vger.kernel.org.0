Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D40A3B4410
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 15:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhFYNKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 09:10:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:41218 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231405AbhFYNKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 09:10:49 -0400
IronPort-SDR: qRkwrRss2th95lxgt9XcPMw1Z2ly7BriQYfCpa9LX1jZcC1EmrbOggQ/nQKPAEP8ZvTUtvvF6X
 caG0DEAkWo0g==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="194959000"
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="194959000"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 06:08:27 -0700
IronPort-SDR: s6RkTRgaDA+cJvb6/2gklVNWp93vUMlbVjufSQGHUDSChyDrbbRi/SHht3j7xptkEZg4Fhgj7x
 AihtYKa5qM1g==
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="453809539"
Received: from junyuton-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.170.209])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 06:08:24 -0700
Date:   Fri, 25 Jun 2021 21:08:21 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 09/54] KVM: x86/mmu: Unconditionally zap unsync SPs when
 creating >4k SP at GFN
Message-ID: <20210625130821.eo7q25kish4fhg24@linux.intel.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-10-seanjc@google.com>
 <20210625095106.mvex6n23lsnnsowe@linux.intel.com>
 <bb6885fa-4ad3-8da4-8d8e-ebfee30ad159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb6885fa-4ad3-8da4-8d8e-ebfee30ad159@redhat.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25, 2021 at 12:26:10PM +0200, Paolo Bonzini wrote:
> On 25/06/21 11:51, Yu Zhang wrote:
> > While reading the sync pages code, I just realized that patch
> > https://lkml.org/lkml/2021/2/9/212 has not be merged in upstream(
> > though it is irrelevant to this one). May I ask the reason? Thanks!
> 
> I hadn't noticed it, thanks for reminding me.

It's just a cleanup patch. And I forgot it too.:) Thanks!

B.R.
Yu
