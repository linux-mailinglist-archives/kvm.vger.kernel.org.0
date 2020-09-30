Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229BC27DDF2
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 03:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbgI3BnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 21:43:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:11590 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729322AbgI3BnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 21:43:21 -0400
IronPort-SDR: mN4bP4kjQ3MTuerJFbSxEoc0M1X0DjpBty7Dfg3DZkgZEWa992MbkKY9O7q+nOu24ZQDBnTRwO
 iLGYYDGEIZPA==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="150112521"
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="150112521"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 18:43:19 -0700
IronPort-SDR: Nwz9+y/4PYCkTgaUzcURpAUM+jat2Qm//hC951+Pwxtj52BcXWjmKnhizTlGUjrROKOOOCA3kL
 Sy6QDkgC/3ZA==
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="457481056"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 18:43:18 -0700
Date:   Tue, 29 Sep 2020 18:43:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] KVM: x86: Add kvm_x86_ops hook to short circuit emulation
Message-ID: <20200930014317.GG32531@linux.intel.com>
References: <20200915232702.15945-1-sean.j.christopherson@intel.com>
 <CANRm+Cx85NBnL76VoFV+DNrShp_2o+c4dgQCwNARzrAcmX1KAw@mail.gmail.com>
 <20200916173416.GF10227@sjchrist-ice>
 <2cacbe0d-703b-cb06-ac5b-96841f145b95@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cacbe0d-703b-cb06-ac5b-96841f145b95@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 22, 2020 at 03:32:58PM +0200, Paolo Bonzini wrote:
> On 16/09/20 19:34, Sean Christopherson wrote:
> > 
> > The intent of posting the patch standalone is so that SGX, SEV-ES, and/or TDX
> > have "ready to go" support in upstream, i.e. can change only the VMX/SVM
> > implementation of is_emulated().  I'm a-ok dropping the handle_ud() change,
> > or even the whole patch, until one of the above three is actually ready for
> > inclusion.
> 
> I think it's fine with the "can" in the name.  Hopefully one of the
> three will go in soon...

FWIW, the changelog still references is_emulated().  Probably not worth
rewriting history though.
