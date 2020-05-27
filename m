Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4DF1E467F
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 16:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389378AbgE0OzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 10:55:15 -0400
Received: from mga05.intel.com ([192.55.52.43]:38884 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388738AbgE0OzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 10:55:15 -0400
IronPort-SDR: cmI7gxDIg/EtDwY1Qyz6EArB8tUP18ZTaLniDgboty0DgPl5S2A+IqcEFRl7tUWJJ+RKmsSUVY
 1A3ZWA/ydsuA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 07:55:15 -0700
IronPort-SDR: ZPYfkxIfq26DM++JyCItHYsHYJJbOXbnuPeNo4K82uRWjeNJZE8ugjLsA42OioaxmWTpQaAANV
 iSm70DdkW+0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,441,1583222400"; 
   d="scan'208";a="255807471"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga007.jf.intel.com with ESMTP; 27 May 2020 07:55:14 -0700
Date:   Wed, 27 May 2020 07:55:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: Preserve registers modifications done before
 nested_svm_vmexit()
Message-ID: <20200527145514.GA24461@linux.intel.com>
References: <20200527082921.218601-1-vkuznets@redhat.com>
 <20200527084835.GO31696@linux.intel.com>
 <878shd69g9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878shd69g9.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 27, 2020 at 10:58:14AM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Shortlog says nVMX, code says nSVM :-)
> >
> 
> My brain is tainted, you know :-) Also, saying *VMX* always helps to get
> your review so I may use the trick again :-)

Beetlejuice...Beetlejuice...Beetlejuice!
