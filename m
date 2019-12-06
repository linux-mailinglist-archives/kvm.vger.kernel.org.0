Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF6FD1158AD
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 22:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfLFViM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 16:38:12 -0500
Received: from mga17.intel.com ([192.55.52.151]:42161 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfLFViM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 16:38:12 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 13:38:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="294976823"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 06 Dec 2019 13:38:11 -0800
Date:   Fri, 6 Dec 2019 13:38:11 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: get rid of var page in kvm_set_pfn_dirty()
Message-ID: <20191206213811.GF5433@linux.intel.com>
References: <1575515105-19426-1-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1575515105-19426-1-git-send-email-linmiaohe@huawei.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 05, 2019 at 11:05:05AM +0800, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> We can get rid of unnecessary var page in
> kvm_set_pfn_dirty() , thus make code style
> similar with kvm_set_pfn_accessed().

For future reference, there's no need to wrap so aggressively, preferred
kernel style is to wrap at 75 columns (though for some reason I am in the
habit of wrapping changelogs at 73 columns), e.g.:

We can get rid of unnecessary var page in kvm_set_pfn_dirty(), thus make
code style similar with kvm_set_pfn_accessed().
