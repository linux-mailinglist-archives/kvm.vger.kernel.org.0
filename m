Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8991D1B76FB
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 15:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgDXN3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 09:29:40 -0400
Received: from mga03.intel.com ([134.134.136.65]:63524 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbgDXN3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 09:29:40 -0400
IronPort-SDR: YvDEbMMZKNjzMaIb4B2VP26HGUzN6D31nQhnATEklIX+KfJRpRDQL92VGH1DNG/KxHuGPEbpg2
 S2pBErK/UNzQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 06:29:39 -0700
IronPort-SDR: 64R9MDsW0CF8L3MESn1yqC+i4CXvebiAVZdK7XPQreI4c2nvb1ZER3fsqrSwoIzQSQwr1PyuIa
 Ea68KJxcmmVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="292632097"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga008.jf.intel.com with ESMTP; 24 Apr 2020 06:29:37 -0700
Date:   Fri, 24 Apr 2020 21:31:39 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 0/9] Introduce support for guest CET feature
Message-ID: <20200424133139.GA24039@local-michael-cet-test>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200423155109.GD17824@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423155109.GD17824@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 08:51:09AM -0700, Sean Christopherson wrote:
> On Thu, Mar 26, 2020 at 04:18:37PM +0800, Yang Weijiang wrote:
> > Control-flow Enforcement Technology (CET) provides protection against
> > Return/Jump-Oriented Programming (ROP/JOP) attack. It includes two
> > sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
> > 
> > KVM needs to update to enable guest CET feature.
> > This patchset implements CET related CPUID/XSAVES enumeration, MSRs
> > and vmentry/vmexit configuration etc.so that guest kernel can setup CET
> > runtime infrastructure based on them. Some CET MSRs and related feature
> > flags used reference the definitions in kernel patchset.
> > 
> > CET kernel patches are here:
> > https://lkml.org/lkml/2020/2/5/593
> > https://lkml.org/lkml/2020/2/5/604
> 
> lkml.org is pretty worthless for this sort of thing, and lkml.kernel.org
> is the preferred link method in general.  The syntax is
> 
>   https://lkml.kernel.org/r/<Message-ID>
> 
> e.g.
> 
>   https://lkml.kernel.org/r/20200205181935.3712-1-yu-cheng.yu@intel.com
> 
> Note, that will redirect to lore.kernel.org, but the above format is
> preferred because it isn't dependent on binning the thread to a specific
> mailing list.
> 
> Anyways, kernel.org provides a link to download the entire thread in mbox
> format, which allows reviewers to get the prerequisite series without much
> fuss.
> 
>   https://lore.kernel.org/linux-api/20200205181935.3712-1-yu-cheng.yu@intel.com/t.mbox.gz
Thanks Sean for the detailed review!

I completely omitted such kind of consideration, will change it from
next version.

