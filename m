Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDEB268EF6
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 17:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgINPFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 11:05:25 -0400
Received: from mga07.intel.com ([134.134.136.100]:17317 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgINPFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 11:05:15 -0400
IronPort-SDR: aP+NgzUOPEwRKyP3EymL5+ssfJDTsPu1M0BRJoP5y+Bes0JRCGLfvvq3TZuYOkGdYVWMwv2aJG
 zfPbEXArM1zg==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="223274251"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="223274251"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 08:05:13 -0700
IronPort-SDR: 9/Tz4M7Upcqu8ByHhz7kUJ0mGZVjKuASTy1pTNN8gijwhk5Zuwm6jycigxxPkxAgEuajwZsoOM
 vVrteybeijxg==
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="482371642"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 08:05:11 -0700
Date:   Mon, 14 Sep 2020 08:05:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Babu Moger <babu.moger@amd.com>, vkuznets@redhat.com,
        jmattson@google.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
Message-ID: <20200914150510.GA6855@sjchrist-ice>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <83a96ca9-0810-6c07-2e45-5aa2da9b1ab0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83a96ca9-0810-6c07-2e45-5aa2da9b1ab0@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 12, 2020 at 07:08:05PM +0200, Paolo Bonzini wrote:
> Queued except for patch 9 with only some changes to the names (mostly
> replacing "vector" with "word").  It should get to kvm.git on Monday or
> Tuesday, please give it a shot.

Belated vote for s/vector/word, I found EXCEPTION_VECTOR quite confusing.
