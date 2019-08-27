Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 808249F343
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 21:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbfH0TYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 15:24:18 -0400
Received: from mga05.intel.com ([192.55.52.43]:38393 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728834AbfH0TYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 15:24:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 12:24:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="192344648"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga002.jf.intel.com with ESMTP; 27 Aug 2019 12:24:16 -0700
Date:   Tue, 27 Aug 2019 12:24:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: x86: Only print persistent reasons for kvm disabled
 once
Message-ID: <20190827192416.GG27459@linux.intel.com>
References: <20190826182320.9089-1-tony.luck@intel.com>
 <87imqjm8b4.fsf@vitty.brq.redhat.com>
 <20190827190810.GA21275@flask>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190827190810.GA21275@flask>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 27, 2019 at 09:08:10PM +0200, Radim Krčmář wrote:
> I am also not inclined to apply the patch as we will likely merge the
> kvm and kvm_{svm,intel} modules in the future to take full advantage of
> link time optimizations and this patch would stop working after that.

Any chance you can provide additional details on the plan for merging
modules?  E.g. I assume there would still be kvm_intel and kvm_svm, just
no vanilla kvm?
