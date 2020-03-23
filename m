Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3502D18EDEF
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 03:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgCWCSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 22:18:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:60526 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbgCWCSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 22:18:37 -0400
IronPort-SDR: C6CNLa+r1wv8sT1PxWiEjA+bFtSMYALqdO8pb4r1HlFG7QL8ewlGPloe9re9RK2gis7gM/MWBw
 nTlGyrfTi7aA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 19:18:36 -0700
IronPort-SDR: f8Vufh5T1Fhfwhdqge8EpGTKWnVNuVrld+s++r0Z1cgXugz6igzZzSyPDOJfuxHCLKRdOh5JNg
 xrG3qIaJkTvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,294,1580803200"; 
   d="scan'208";a="392761916"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.169.56]) ([10.249.169.56])
  by orsmga004.jf.intel.com with ESMTP; 22 Mar 2020 19:18:30 -0700
Subject: Re: [PATCH v5 0/9] x86/split_lock: Add feature split lock detection
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <8e00dd68-c7d9-f61e-3102-72bd0260f05b@intel.com>
Date:   Mon, 23 Mar 2020 10:18:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200315050517.127446-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas and Paolo,

On 3/15/2020 1:05 PM, Xiaoyao Li wrote:
> This series aims to add the virtualization of split lock detection for
> guest, while containing some fixes of native kernel split lock handling.
> 
> Note, this series is based on the kernel patch[1].

Do you have any comment on this series?

If no, may I ask can we make it for 5.7?

Thanks,
-Xiaoyao

