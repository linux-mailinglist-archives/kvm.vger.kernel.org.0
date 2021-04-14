Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC9A35EA27
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 03:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348932AbhDNBBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 21:01:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:62191 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348903AbhDNBBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 21:01:08 -0400
IronPort-SDR: IpWNaBaSEN/7rktX6bN7MpePhy+hBF6M+9MK482BupARKwwKJ15azGgMIKxxmKPC+D7c00hBsu
 6VCdYI8LPOVA==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="258507154"
X-IronPort-AV: E=Sophos;i="5.82,220,1613462400"; 
   d="scan'208";a="258507154"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 18:00:46 -0700
IronPort-SDR: mz+93uhYNOwn+a8RZ4tapNMO4Bmp3Cm+sWkle2xWEchoXztCane5vdKFxLURny1vcWna5SOINY
 lO15n5U3ehMA==
X-IronPort-AV: E=Sophos;i="5.82,220,1613462400"; 
   d="scan'208";a="418086521"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 18:00:42 -0700
Subject: Re: [PATCH v2 4/4] KVM: x86: Expose Architectural LBR CPUID and its
 XSAVES bit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Wei Wang <wei.w.wang@intel.com>
References: <20210203135714.318356-1-like.xu@linux.intel.com>
 <20210203135714.318356-5-like.xu@linux.intel.com>
 <8321d54b-173b-722b-ddce-df2f9bd7abc4@redhat.com>
 <219d869b-0eeb-9e52-ea99-3444c6ab16a3@intel.com>
 <b73a2945-11b9-38bf-845a-c64e7caa9d2e@intel.com>
 <7698fd6c-94da-e352-193f-e09e002a8961@redhat.com>
 <6f733543-200e-9ddd-240b-1f956a003ed6@intel.com>
 <c3b916c2-5b4e-31d1-b27b-bf71b621bd7b@redhat.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <b498b7b2-935a-a904-c513-df0b826bd0ae@intel.com>
Date:   Wed, 14 Apr 2021 09:00:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <c3b916c2-5b4e-31d1-b27b-bf71b621bd7b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Do we have a chance to make Arch LBR into the mainline in the upcoming 
merger window?
https://lore.kernel.org/kvm/20210314155225.206661-1-like.xu@linux.intel.com/

Thanks,
Like Xu

On 2021/2/8 18:31, Paolo Bonzini wrote:
> Ok, this makes sense.  I'll review the patches more carefully, looking at 
> 5.13 for the target.
>
> Paolo 

