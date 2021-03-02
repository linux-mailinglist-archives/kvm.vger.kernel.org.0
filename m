Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBED32B579
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376483AbhCCHR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:17:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:38217 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352197AbhCBS3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 13:29:44 -0500
IronPort-SDR: F5FmO9NGRuYS2Slg0aWdS2U5cYn55fgCmy/63KVrZ0Rbiv2AqydA01cXMU/+d7S3/Ib2GgkfPk
 T8FDABU0sSuA==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="187046949"
X-IronPort-AV: E=Sophos;i="5.81,217,1610438400"; 
   d="scan'208";a="187046949"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 10:27:49 -0800
IronPort-SDR: ESLLalIr0n5PtBs/dBpI5d96eVnKnzplKfnKNA7chNSWjgi7V6ZIMxSJPx9joDorGiO4grUraM
 XO5tho5vTqEA==
X-IronPort-AV: E=Sophos;i="5.81,217,1610438400"; 
   d="scan'208";a="367290439"
Received: from ttschlue-desk2.amr.corp.intel.com ([10.251.17.34])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 10:27:44 -0800
Message-ID: <4f31636e6155428ab69153fec8dd7ac31f888ffe.camel@intel.com>
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
From:   Kai Huang <kai.huang@intel.com>
To:     Boris Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Date:   Wed, 03 Mar 2021 07:27:42 +1300
In-Reply-To: <9971018C-8250-4E51-9EF9-72ED6CBD2E47@alien8.de>
References: <cover.1614590788.git.kai.huang@intel.com>
         <bbfc8c833a62e4b55220834320829df1e17aff41.1614590788.git.kai.huang@intel.com>
         <20210301100037.GA6699@zn.tnic>
         <3fce1dd2abd42597bde7ae9496bde7b9596b2797.camel@intel.com>
         <20210301103043.GB6699@zn.tnic>
         <7603ef673997b6674f785d333a4f263c749d2cf3.camel@intel.com>
         <20210301105346.GC6699@zn.tnic>
         <e509c6c1e3644861edafb18e4045b813f9f344b3.camel@intel.com>
         <20210301113257.GD6699@zn.tnic>
         <0adc41774945bf9d6e6a72a93b83c80aa8c59544.camel@intel.com>
         <YD5hhah9Sgj1YGqw@google.com>
         <9971018C-8250-4E51-9EF9-72ED6CBD2E47@alien8.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Tue, 2021-03-02 at 18:53 +0100, Boris Petkov wrote:
> On March 2, 2021 5:02:13 PM GMT+01:00, Sean Christopherson <seanjc@google.com> wrote:
> > The KVM use case is to query /proc/cpuinfo to see if sgx2 can be
> > enabled in a
> > guest.
> 
> You mean before the guest ia created? I sure hope there's a better way to query HV-supported features than grepping /proc/cpuinfo...
> 
> > The counter-argument to that is we might want sgx2 in /proc/cpuinfo to
> > mean sgx2
> > is enabled in hardware _and_ supported by the kernel.  Userspace can
> > grep for
> > sgx in /proc/cpuinfo, and use cpuid to discover sgx2, so it's not a
> > blocker.
> 
> Question is, what exactly that flag should denote: that EDMM is supported in the HV and guests can do the dynamic thing of adding/rwmoving EPC pages? Is that the only feature behind SGX2?

Yes SGX2 == EDMM. Other sub-features, such as VMM oversubscription, have other CPUID
bits.

> 
> > That being said, adding some form of capability/versioning to SGX seems
> > inevitable, not sure it's worth witholding sgx2 from /proc/cpuinfo.
> 
> See what I typed earlier - no objections from me if a proper use case is identified and written down.
> 
> Thx.


