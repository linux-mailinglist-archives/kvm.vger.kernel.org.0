Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE991E85F5
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 19:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgE2R4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 13:56:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:50691 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgE2R4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 13:56:37 -0400
IronPort-SDR: 4rzs4QqlomS8Jtvf5KJaLp7MMXUJXAjEaAesxsFxWplSorfPo75nynlPBH7Y/9/B4gD6QI1tex
 sqBE5WiFqL4g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 10:56:37 -0700
IronPort-SDR: a1f7kC44aruh5/IdMMc0OnAqFcZpzDIywHQihgjM1ZFtlmI4PkQgL/v5EkFz1LVcdkj+6Knuuu
 JdTsRb52KGVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,449,1583222400"; 
   d="scan'208";a="285604168"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 29 May 2020 10:56:37 -0700
Date:   Fri, 29 May 2020 10:56:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 06/30] KVM: SVM: always update CR3 in VMCB
Message-ID: <20200529175636.GB1074@linux.intel.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-7-pbonzini@redhat.com>
 <07139fc2-39bd-5bc5-ef23-a98681013665@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07139fc2-39bd-5bc5-ef23-a98681013665@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 29, 2020 at 10:41:58AM -0700, Krish Sadhukhan wrote:
> 
> On 5/29/20 8:39 AM, Paolo Bonzini wrote:
> >svm_load_mmu_pgd is delaying the write of GUEST_CR3 to prepare_vmcs02
> 
> Did you mean to say enter_svm_guest_mode here ?

Heh, looks like Vitaly passed the s/vmcs/vmcb bug on to Paolo, too. :-D
