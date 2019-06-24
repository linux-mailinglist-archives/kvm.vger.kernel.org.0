Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E06F350A59
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 14:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbfFXMGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 08:06:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:53063 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbfFXMGh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 08:06:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jun 2019 05:06:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,412,1557212400"; 
   d="scan'208";a="166312876"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.238.129.47]) ([10.238.129.47])
  by orsmga006.jf.intel.com with ESMTP; 24 Jun 2019 05:06:34 -0700
Subject: Re: [PATCH RFC] kvm: x86: Expose AVX512_BF16 feature to guest
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jing2.liu@intel.com
References: <1561029712-11848-1-git-send-email-jing2.liu@linux.intel.com>
 <1561029712-11848-2-git-send-email-jing2.liu@linux.intel.com>
 <fd861e94-3ea5-3976-9855-05375f869f00@redhat.com>
 <384bc07d-6105-d380-cd44-4518870c15f1@linux.intel.com>
 <fb749626-1d9e-138f-c673-14b52fe7170c@linux.intel.com>
 <7d304ae7-73c0-d2a9-cd3e-975941a91266@redhat.com>
From:   Jing Liu <jing2.liu@linux.intel.com>
Message-ID: <2a2b395b-0bad-5022-9698-9beb87f55ec6@linux.intel.com>
Date:   Mon, 24 Jun 2019 20:06:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <7d304ae7-73c0-d2a9-cd3e-975941a91266@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 6/24/2019 4:33 PM, Paolo Bonzini wrote:
> On 24/06/19 05:10, Jing Liu wrote:
>>> What do you think about @index in current function? Does it mean, we
>>> need put cpuid from index to max subleaf to @entry[i]? If so, the logic
>>> seems as follows,
>>>
>>> if (index == 0) {
>>>       // Put subleaf 0 into @entry
>>>       // Put subleaf 1 into @entry[1]
>>> } else if (index < entry->eax) {
>>>       // Put subleaf 1 into @entry
>>> } else {
>>>       // Put all zero into @entry
>>> }
>>>
>>> But this seems not identical with other cases, for current caller
>>> function. Or we can simply ignore @index in 0x07 and just put all
>>> possible subleaf info back?
> 
> There are indeed quite some cleanups to be made there.  Let me post a
> series as soon as possible, and you can base your work on it.
> 

Thanks. I just had another mail (replying you in this serial) appending
some codes to deal with case 7. If you prefer to firstly cleanup, I can
wait for the patch then. :)

Thanks,
Jing

> Paolo
> 
