Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769E5339BB6
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 05:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhCMEah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 23:30:37 -0500
Received: from mga03.intel.com ([134.134.136.65]:38799 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231597AbhCMEa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 23:30:28 -0500
IronPort-SDR: AJFAvR7GP5rM82kqJxFtfZ6niSIRVmsLL4sd91pXRb/bVXg69/eDM5IMBo/9w5dtM2pl6t1jh7
 U5sG4sRMaT9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="188962572"
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="188962572"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 20:30:27 -0800
IronPort-SDR: w1dgyukI4YaleZ7Xy+Fft36hB6Wetu4Mkj54VtLghA+tAD+Bv7g9pJVaEjJaQvzw7Qf+uaptwV
 qDt2tbtcPAmA==
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="387549457"
Received: from standon-mobl1.amr.corp.intel.com ([10.255.230.31])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 20:30:22 -0800
Message-ID: <6eec5091aeac32ebd5e95ca7f4696c9775857bc7.camel@intel.com>
Subject: Re: [PATCH v2 00/25] KVM SGX virtualization support
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, jethro@fortanix.com, b.thiel@posteo.de,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, corbet@lwn.net
Date:   Sat, 13 Mar 2021 17:30:19 +1300
In-Reply-To: <YEvlUIOWGstrgh7H@google.com>
References: <cover.1615250634.git.kai.huang@intel.com>
         <20210309093037.GA699@zn.tnic>
         <51ebf191-e83a-657a-1030-4ccdc32f0f33@redhat.com>
         <YEvlUIOWGstrgh7H@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-03-12 at 14:04 -0800, Sean Christopherson wrote:
> On Tue, Mar 09, 2021, Paolo Bonzini wrote:
> > On 09/03/21 10:30, Borislav Petkov wrote:
> > > On Tue, Mar 09, 2021 at 02:38:49PM +1300, Kai Huang wrote:
> > > > This series adds KVM SGX virtualization support. The first 14 patches starting
> > > > with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX core/driver to
> > > > support KVM SGX virtualization, while the rest are patches to KVM subsystem.
> > > 
> > > Ok, I guess I'll queue 1-14 once Sean doesn't find anything
> > > objectionable then give Paolo an immutable commit to base the KVM stuff
> > > ontop.
> > 
> > Sounds great.
> 
> Patches 1-14 look good, just a few minor nits, nothing functional.  I'll look at
> the KVM patches next week.
> 
> Thanks for picking this up Kai!

Thank you Sean! I'll address your comments in next version.


