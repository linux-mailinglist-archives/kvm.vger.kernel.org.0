Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2F21E7DFD
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 15:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgE2NGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 09:06:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:57402 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbgE2NGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 09:06:39 -0400
IronPort-SDR: JrVVBUTDZzed092BUBpEuS7sqW4McpFdYNYFnvmZG4Trxq9F35nQiO4wNPeZByy4+nEuT9fmpM
 fsK4Wl0IetAg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 06:06:37 -0700
IronPort-SDR: WhIp9ln5iB4rCyOa50k0wXmSo+WPdlOehbSGKs1w7Bs9LNB67LzmFaDnw6aaAOjrU3heswaWvL
 db6ZwZNzkEew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,448,1583222400"; 
   d="scan'208";a="414966428"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 29 May 2020 06:06:36 -0700
Date:   Fri, 29 May 2020 06:06:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+904752567107eefb728c@syzkaller.appspotmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: Initialize tdp_level during vCPU creation
Message-ID: <20200529130636.GA520@linux.intel.com>
References: <20200527085400.23759-1-sean.j.christopherson@intel.com>
 <40800163-2b28-9879-f21b-687f89070c91@redhat.com>
 <20200527162933.GE24461@linux.intel.com>
 <20200528194604.GE30353@linux.intel.com>
 <871rn3ji9m.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rn3ji9m.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 29, 2020 at 09:46:13AM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > I'll looking into writing a script to run all selftests with a single
> > command, unless someone already has one laying around? 
> 
> Is 'make run_tests' in tools/testing/selftests/kvm/ what you're looking
> for?

*sigh*  Yes.  Thanks!
