Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D1B1E1B24
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgEZGTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:19:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:20138 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbgEZGTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 02:19:36 -0400
IronPort-SDR: JfwWV1tovY89ASKwzuc6fDYYu35r+3zRgoRGPlJF5dJDbmr/vaw2dl0QYx/b05zNPGedAFtwMn
 ZMxGbXdGaXaQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2020 23:19:36 -0700
IronPort-SDR: qXOnqWJvVvKcb/iGAXTmUtWtdmcxyX4LrERJxa+q5mfb+YCjavf2Tg8NzCIQWKL4F8c3/dJuDB
 OKhp/l5FMyJw==
X-IronPort-AV: E=Sophos;i="5.73,436,1583222400"; 
   d="scan'208";a="441964147"
Received: from unknown (HELO [10.239.13.122]) ([10.239.13.122])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2020 23:19:33 -0700
Subject: Re: [PATCH v9 0/8] KVM: Add virtualization support of split lock
 detection
From:   Xiaoyao Li <xiaoyao.li@intel.com>
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
 <98c5ccc7-30bb-bed2-2065-59f7b7b09fbc@intel.com>
Message-ID: <d336bc4d-55fb-d397-0a99-33d86d704f51@intel.com>
Date:   Tue, 26 May 2020 14:19:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <98c5ccc7-30bb-bed2-2065-59f7b7b09fbc@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 5/18/2020 9:27 AM, Xiaoyao Li wrote:
> On 5/9/2020 7:05 PM, Xiaoyao Li wrote:
>> This series aims to add the virtualization of split lock detection in
>> KVM.
>>
>> Due to the fact that split lock detection is tightly coupled with CPU
>> model and CPU model is configurable by host VMM, we elect to use
>> paravirt method to expose and enumerate it for guest.
> 
> Thomas and Paolo,
> 
> Do you have time to have a look at this version?

Does this series have any chance to meet 5.8?

If not, do you plan to take a look at it after merge window?

Thanks,
-Xiaoyao
