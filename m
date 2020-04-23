Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979531B6037
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 18:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgDWQDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 12:03:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:53254 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729621AbgDWQDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 12:03:15 -0400
IronPort-SDR: dh7p7s7kzozyeliPqsuZ9H2tkrRyzZlXF5sHlx5aWy4lQoneAXrGMmrq7WP1Alj0ipSUC0VQTJ
 4K0c/+EGEzAw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 09:03:14 -0700
IronPort-SDR: BWfWAWVku/R6kPBuOGhh/PJ7WQmTfNHytD5ZZWwL8ycBOU2zOO7wKB4NCrEaLZ90vliB+BFpsw
 PJG5HKkmnrqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="335010776"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 23 Apr 2020 09:03:14 -0700
Date:   Thu, 23 Apr 2020 09:03:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 0/9] Introduce support for guest CET feature
Message-ID: <20200423160314.GE17824@linux.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326081847.5870-1-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 04:18:37PM +0800, Yang Weijiang wrote:
> Control-flow Enforcement Technology (CET) provides protection against
> Return/Jump-Oriented Programming (ROP/JOP) attack. It includes two
> sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
> 
> KVM needs to update to enable guest CET feature.
> This patchset implements CET related CPUID/XSAVES enumeration, MSRs
> and vmentry/vmexit configuration etc.so that guest kernel can setup CET
> runtime infrastructure based on them. Some CET MSRs and related feature
> flags used reference the definitions in kernel patchset.
> 
> CET kernel patches are here:
> https://lkml.org/lkml/2020/2/5/593
> https://lkml.org/lkml/2020/2/5/604

...

> - This patch serial is built on top of below branch and CET kernel patches
>   for seeking xsaves support:
>   https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=cpu-caps

Can you provide the full code in a branch/tag somewhere?  The CET patches
are in turn dependent on XSAVES enabling[*], and those don't apply cleanly
on the cpu-caps branch.

It might make sense to also rebase to kvm/queue?  Though that's not a
requirement by any means, e.g. don't bother if the CET patches are going to
be respun soon.

https://lkml.kernel.org/r/20200328164307.17497-1-yu-cheng.yu@intel.com
