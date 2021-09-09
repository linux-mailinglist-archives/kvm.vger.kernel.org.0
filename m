Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A390405B08
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238268AbhIIQkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:40:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:47508 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237884AbhIIQkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 12:40:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10102"; a="220872511"
X-IronPort-AV: E=Sophos;i="5.85,280,1624345200"; 
   d="scan'208";a="220872511"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 09:39:10 -0700
X-IronPort-AV: E=Sophos;i="5.85,280,1624345200"; 
   d="scan'208";a="539718091"
Received: from gchen28-mobl2.ccr.corp.intel.com (HELO localhost) ([10.255.31.74])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 09:39:04 -0700
Date:   Fri, 10 Sep 2021 00:39:01 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Hou Wenlong <houwenlong93@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Avi Kivity <avi@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] kvm: x86: Introduce hypercall x86 ops for
 handling hypercall not in cpl0
Message-ID: <20210909163901.2vvozmkuxjcgabs5@linux.intel.com>
References: <cover.1631188011.git.houwenlong93@linux.alibaba.com>
 <04a337801ad5aaa54144dc57df8ee2fc32bc9c4e.1631188011.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04a337801ad5aaa54144dc57df8ee2fc32bc9c4e.1631188011.git.houwenlong93@linux.alibaba.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 07:55:23PM +0800, Hou Wenlong wrote:
> Per Intel's SDM, use vmcall instruction in non VMX operation for cpl3
> it should trigger a #UD. And in VMX root operation, it should

Are you sure? IIRC, vmcall will always cause VM exit as long as CPU
is in non-root mode(regardless the CPL).

Also, could you please explain why skipping the vmcall would cause
exception in the host? Thanks!

B.R.
Yu

