Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADB211DB3B
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 01:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731689AbfLMAna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 19:43:30 -0500
Received: from mga06.intel.com ([134.134.136.31]:19840 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731593AbfLMAn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 19:43:29 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Dec 2019 16:43:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,307,1571727600"; 
   d="scan'208";a="216472424"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 12 Dec 2019 16:43:26 -0800
Date:   Fri, 13 Dec 2019 08:44:45 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com, yu-cheng.yu@intel.com
Subject: Re: [PATCH v8 0/7] Introduce support for guest CET feature
Message-ID: <20191213004445.GA2822@local-michael-cet-test>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
 <20191212160345.GA13420@char.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212160345.GA13420@char.us.oracle.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 12, 2019 at 11:03:45AM -0500, Konrad Rzeszutek Wilk wrote:
> On Fri, Nov 01, 2019 at 04:52:15PM +0800, Yang Weijiang wrote:
> > Control-flow Enforcement Technology (CET) provides protection against
> > Return/Jump-Oriented Programming (ROP/JOP) attack. It includes two
> > sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
> > 
> > KVM change is required to support guest CET feature.
> > This patch serial implemented CET related CPUID/XSAVES enumeration, MSRs
> > and vmentry/vmexit configuration etc.so that guest kernel can setup CET
> > runtime infrastructure based on them. Some CET MSRs and related feature
> > flags used reference the definitions in kernel patchset.
> > 
> > CET kernel patches is here:
> > https://lkml.org/lkml/2019/8/13/1110
> > https://lkml.org/lkml/2019/8/13/1109
> 
> Is there a git tree with all of them against v5.5-rc1 (so all three series)?
> I tried your github tree: https://github.com/yyu168/linux_cet.git #cet
> but sadly that does not apply against 5.5-rc1 :-(
> 
> Thanks!
Hi, 
The CET patch includes two parts: one from kernel side the other from KVM,
the kernel patch in github is maintained by my peer, he'll rebase
it to the latest kernel tree shortly after resolve some issues.
Thank you for having interest!

