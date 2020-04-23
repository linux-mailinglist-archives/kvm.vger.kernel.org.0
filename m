Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4718B1B5FE5
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729319AbgDWPvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:51:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:47577 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729212AbgDWPvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 11:51:11 -0400
IronPort-SDR: QJsMvB0BMJQIHoPzevHn7Irh3dNDocrfhUlkDi5K5xRMwTAyF0c8E0EPhOHjYlrKQz3b7zWJks
 M4CDhaz1EzAQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 08:51:10 -0700
IronPort-SDR: B+irv8OhOSdHt7XQDod4Mdv7W3npq8mQj6RTSAXE5lQXWciQE/vNqNB+YyyQq6GKZi3vzC5O/4
 7j6vMjK4igXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="402957569"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 23 Apr 2020 08:51:10 -0700
Date:   Thu, 23 Apr 2020 08:51:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 0/9] Introduce support for guest CET feature
Message-ID: <20200423155109.GD17824@linux.intel.com>
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

lkml.org is pretty worthless for this sort of thing, and lkml.kernel.org
is the preferred link method in general.  The syntax is

  https://lkml.kernel.org/r/<Message-ID>

e.g.

  https://lkml.kernel.org/r/20200205181935.3712-1-yu-cheng.yu@intel.com

Note, that will redirect to lore.kernel.org, but the above format is
preferred because it isn't dependent on binning the thread to a specific
mailing list.

Anyways, kernel.org provides a link to download the entire thread in mbox
format, which allows reviewers to get the prerequisite series without much
fuss.

  https://lore.kernel.org/linux-api/20200205181935.3712-1-yu-cheng.yu@intel.com/t.mbox.gz
