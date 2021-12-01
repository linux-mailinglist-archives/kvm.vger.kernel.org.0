Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1A8464EBA
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 14:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245726AbhLANZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 08:25:55 -0500
Received: from mga05.intel.com ([192.55.52.43]:51079 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234027AbhLANZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 08:25:54 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="322701747"
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="322701747"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 05:22:33 -0800
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="540824436"
Received: from jelopeza-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.181])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 05:22:29 -0800
Date:   Thu, 2 Dec 2021 02:22:27 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v3 00/59] KVM: X86: TDX support
Message-Id: <20211202022227.acc0b613e6c483be4736c196@intel.com>
In-Reply-To: <YaZyyNMY80uVi5YA@google.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
        <YaZyyNMY80uVi5YA@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Nov 2021 18:51:52 +0000 Sean Christopherson wrote:
> On Wed, Nov 24, 2021, isaku.yamahata@intel.com wrote:
> > - drop load/initialization of TDX module
> 
> So what's the plan for loading and initializing TDX modules?

Hi Sean,

Although I don't quite understand what does Isaku mean here (I thought
loading/initializing TDX module was never part of TDX KVM series), for this part
we are working internally to improve the quality and finalize the code, but
currently I don't have ETA of being able to send patches out, but we are trying
to send out asap.  Sorry this is what I can say for now : (


