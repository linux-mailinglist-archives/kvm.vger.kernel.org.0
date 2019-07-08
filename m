Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9445B62138
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 17:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732176AbfGHPLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 11:11:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:58570 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732162AbfGHPLm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 11:11:42 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 08:11:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="165482391"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.137])
  by fmsmga008.fm.intel.com with ESMTP; 08 Jul 2019 08:11:40 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 3F381301BB6; Mon,  8 Jul 2019 08:11:41 -0700 (PDT)
Date:   Mon, 8 Jul 2019 08:11:41 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Wei Wang <wei.w.wang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, kan.liang@intel.com,
        mingo@redhat.com, rkrcmar@redhat.com, like.xu@intel.com,
        jannh@google.com, arei.gonglei@huawei.com, jmattson@google.com
Subject: Re: [PATCH v7 10/12] KVM/x86/lbr: lazy save the guest lbr stack
Message-ID: <20190708151141.GL31027@tassilo.jf.intel.com>
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com>
 <1562548999-37095-11-git-send-email-wei.w.wang@intel.com>
 <20190708145326.GO3402@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708145326.GO3402@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> I don't understand a word of that.
> 
> Who cares if the LBR MSRs are touched; the guest expects up-to-date
> values when it does reads them.

This is for only when the LBRs are disabled in the guest.

It doesn't make sense to constantly save/restore disabled LBRs, which
would be a large overhead for guests that don't use LBRs. 

When the LBRs are enabled they always need to be saved/restored as you
say.

-Andi
