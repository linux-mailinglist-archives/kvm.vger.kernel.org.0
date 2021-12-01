Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8824656F4
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 21:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352938AbhLAUUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 15:20:30 -0500
Received: from mga18.intel.com ([134.134.136.126]:12583 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239976AbhLAUTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 15:19:31 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="223422781"
X-IronPort-AV: E=Sophos;i="5.87,279,1631602800"; 
   d="scan'208";a="223422781"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 12:16:08 -0800
X-IronPort-AV: E=Sophos;i="5.87,279,1631602800"; 
   d="scan'208";a="609694761"
Received: from pkumar17-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.62.247])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 12:16:05 -0800
Date:   Thu, 2 Dec 2021 09:16:03 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v3 00/59] KVM: X86: TDX support
Message-Id: <20211202091603.4886b0270f41971b806c2c94@intel.com>
In-Reply-To: <bb6dd4eb-c713-f0e5-71fa-b0a514c4da6c@redhat.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
        <YaZyyNMY80uVi5YA@google.com>
        <bb6dd4eb-c713-f0e5-71fa-b0a514c4da6c@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 1 Dec 2021 16:05:32 +0100 Paolo Bonzini wrote:
> On 11/30/21 19:51, Sean Christopherson wrote:
> > On Wed, Nov 24, 2021,isaku.yamahata@intel.com  wrote:
> >> - drop load/initialization of TDX module
> > So what's the plan for loading and initializing TDX modules?
> > 
> 
> The latest news I got are that Intel has an EFI application that loads 
> it, so loading it from Linux and updating it at runtime can be punted to 
> later.
> 

Yes we are heading this approach.
