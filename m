Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375EF1D6FFA
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 06:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgEREwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 00:52:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:27658 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbgEREwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 00:52:34 -0400
IronPort-SDR: OC6EWW+Vk7cng3kDaga7QCfjVGLO/uiWRl8hM72U30fKw/K5OkX2q/Kgq/QBhl/Mb+NtD6WHrV
 670k7/W0TNAQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2020 21:52:33 -0700
IronPort-SDR: /1eK/3D18pvC54bUbXbIaKUoz8Bwg3J3K9WccOBj9l/69wTQmPmoDV+7VQ2DHfsLS1u+snO7kD
 ZAfMvHrvoqbA==
X-IronPort-AV: E=Sophos;i="5.73,406,1583222400"; 
   d="scan'208";a="411125766"
Received: from unknown (HELO [10.239.13.122]) ([10.239.13.122])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2020 21:52:32 -0700
Subject: Re: [PATCH] kvm: x86: Use KVM CPU capabilities to determine CR4
 reserved bits
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jmattson@google.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200506094436.3202-1-pbonzini@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <6a4daca4-6034-901a-261f-215df7d606a6@intel.com>
Date:   Mon, 18 May 2020 12:52:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200506094436.3202-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/2020 5:44 PM, Paolo Bonzini wrote:
> Using CPUID data can be useful for the processor compatibility
> check, but that's it.  Using it to compute guest-reserved bits
> can have both false positives (such as LA57 and UMIP which we
> are already handling) and false negatives: 

> in particular, with
> this patch we don't allow anymore a KVM guest to set CR4.PKE
> when CR4.PKE is clear on the host.

A common question about whether a feature can be exposed to guest:

Given a feature, there is a CPUID bit to enumerate it, and a CR4 bit to 
turn it on/off. Whether the feature can be exposed to guest only depends 
on host CR4 setting? I.e., if CPUID bit is not cleared in cpu_data in 
host but host kernel doesn't set the corresponding CR4 bit to turn it 
on, we cannot expose the feature to guest. right?


