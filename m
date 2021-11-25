Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03A845D31C
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237286AbhKYCX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:23:27 -0500
Received: from mga12.intel.com ([192.55.52.136]:57404 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229700AbhKYCV1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:21:27 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="215447716"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="215447716"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 18:13:04 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="510105492"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.31.184]) ([10.255.31.184])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 18:12:58 -0800
Message-ID: <46eb9fbd-f21f-920d-907f-0fcf327b129a@intel.com>
Date:   Thu, 25 Nov 2021 10:12:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.2
Subject: Re: [RFC PATCH v3 00/59] KVM: X86: TDX support
Content-Language: en-US
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com
References: <cover.1637799475.git.isaku.yamahata@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/25/2021 8:19 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Changes from v2:
> - update based on patch review
> - support TDP MMU
> - drop non-essential fetures (ftrace etc.) to reduce patch size
> 
> TODO:
> - integrate vm type patch

Hi, everyone plans to review this series,

Please skip patch 14-22, which aer old and a separate series can be 
found at 
https://lore.kernel.org/all/20211112153733.2767561-1-xiaoyao.li@intel.com/

I will post v2 with all the comments from Sean addressed.

thanks,
-Xiaoyao

> - integrate unmapping user space mapping


