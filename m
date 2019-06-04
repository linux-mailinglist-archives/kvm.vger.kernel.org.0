Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9708434DF4
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 18:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfFDQsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 12:48:17 -0400
Received: from mga12.intel.com ([192.55.52.136]:52246 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727470AbfFDQsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 12:48:17 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 09:48:16 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga006.jf.intel.com with ESMTP; 04 Jun 2019 09:48:15 -0700
Date:   Tue, 4 Jun 2019 09:48:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Ahmed <karahmed@amazon.de>
Subject: Re: [PATCH] KVM/nSVM: properly map nested VMCB
Message-ID: <20190604164815.GC32350@linux.intel.com>
References: <20190604160939.17031-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604160939.17031-1-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 04, 2019 at 06:09:39PM +0200, Vitaly Kuznetsov wrote:
> Commit 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping guest
> memory") broke nested SVM completely: kvm_vcpu_map()'s second parameter is
> GFN so vmcb_gpa needs to be converted with gpa_to_gfn(), not the other way
> around.
> 
> Fixes: 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping guest memory")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
