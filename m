Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664A41D6E9C
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 03:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgERB1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 21:27:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:62464 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726665AbgERB1w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 21:27:52 -0400
IronPort-SDR: hwgmVVkDU0tRVcvt/W/J/KtXIpO1WQzWgJX/Gutv4C3D5pdEO1HtZB1CoX/q0LQBEtFR0zEI8h
 081IinlLnH/w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2020 18:27:51 -0700
IronPort-SDR: Aqzlh6aBiYoLzYWHgtR5GMwBAXEoKyK6vuDwqa+I0cEiOgiNDo1kJ7SZkYG4F6L3iYfDrNi8wd
 sGGrl12QpPxw==
X-IronPort-AV: E=Sophos;i="5.73,405,1583222400"; 
   d="scan'208";a="411090277"
Received: from unknown (HELO [10.239.13.122]) ([10.239.13.122])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2020 18:27:48 -0700
Subject: Re: [PATCH v9 0/8] KVM: Add virtualization support of split lock
 detection
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>, peterz@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
References: <20200509110542.8159-1-xiaoyao.li@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <98c5ccc7-30bb-bed2-2065-59f7b7b09fbc@intel.com>
Date:   Mon, 18 May 2020 09:27:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200509110542.8159-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/9/2020 7:05 PM, Xiaoyao Li wrote:
> This series aims to add the virtualization of split lock detection in
> KVM.
> 
> Due to the fact that split lock detection is tightly coupled with CPU
> model and CPU model is configurable by host VMM, we elect to use
> paravirt method to expose and enumerate it for guest.

Thomas and Paolo,

Do you have time to have a look at this version?
