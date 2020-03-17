Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2C6188221
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 12:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgCQLYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 07:24:17 -0400
Received: from mga04.intel.com ([192.55.52.120]:60184 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbgCQLYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 07:24:17 -0400
IronPort-SDR: igUf7PrRvcVZYtrBcC7AldeQFQT/WF7NOy1PKKXTvLrTL5V6owCXz9ZdgRu3Zy5tjQc6gur0nm
 MAYFTrEkiuYg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2020 04:24:17 -0700
IronPort-SDR: ym6w+YD+WLAOsiXsFcvr5v46k0vFcKq96Aou1QarGV9ROUv4IsFiEbJRpjHzHKHaKO5BzHhBCO
 Z1NOXwKA/GeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,564,1574150400"; 
   d="scan'208";a="244448946"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.31.237]) ([10.255.31.237])
  by orsmga003.jf.intel.com with ESMTP; 17 Mar 2020 04:24:13 -0700
Subject: Re: [PATCH] KVM: X86: correct meaningless kvm_apicv_activated() check
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linmiaohe@huawei.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <1584185480-3556-1-git-send-email-pbonzini@redhat.com>
 <878sk0n1g1.fsf@vitty.brq.redhat.com>
 <20200316152650.GD24267@linux.intel.com>
 <87zhcgl2xc.fsf@vitty.brq.redhat.com>
 <20200316155911.GE24267@linux.intel.com>
 <eb1037c8-fdb5-4f4c-4641-915c0e3d01bc@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <b2d0a1ec-d305-f03e-3063-d324bf8b1d19@intel.com>
Date:   Tue, 17 Mar 2020 19:24:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <eb1037c8-fdb5-4f4c-4641-915c0e3d01bc@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/17/2020 12:39 AM, Paolo Bonzini wrote:
> On 16/03/20 16:59, Sean Christopherson wrote:
>>>>
>>> 	if (!!old == !!new)
>>> 		return;
>>>
>>> to make it clear we're converting them to 1/0 :-)
>>
>> All I can think of now is the Onion article regarding razor blades...
>>
>> 	if (!!!!old == !!!!new)
>> 		return;
>>
> 
> That would be !!!!!, but seriously I'll go with two.
> 
> (Thanks for giving me a chuckle, it's sorely needed these days).

Take care, Paolo.

I have been staying at home for two months in Wuhan, China, and things 
are going better now. I believe all the world can defeat Coronavirus 
eventually.

> Paolo
> 

