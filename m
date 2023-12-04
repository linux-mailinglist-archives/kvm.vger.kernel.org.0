Return-Path: <kvm+bounces-3292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90AFB802C3A
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 08:41:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E6801F210DC
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 07:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4F98BE53;
	Mon,  4 Dec 2023 07:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h3dHy8zF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FF4B9
	for <kvm@vger.kernel.org>; Sun,  3 Dec 2023 23:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701675668; x=1733211668;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jMnjDLBqJ4t4/XvKEv0l+/ysieTqDpI4VbHwZZMz/Hk=;
  b=h3dHy8zFeLvTlQNp7rCYVzajohI0w5d0WK3ex4K8tybcTjYqwFS4vqTX
   31H6oLv1ybArRQt61yTMh2seMwPWL5Lt8YvEe5SJysP+RTW7IRhpMfV1J
   c+9XIhwFhNyN/M7HWrRMmFMwx1O9MMZ92r+GaWcKxA82l71VaspzK1eyf
   tOrhvFi2g5kAJFDKBJp9wB6unMYjFACV2zDfbJINMyukalUK2VuOvUCzd
   0LhDEulzTV4SCOvZBlJc0WVn15ym2j+qaaTNMw5KgsBQ46hP8EmrRQ6aJ
   NDRIBsl55gwfiRtP+gJa9AeF5q+hWmoaHV8/wXIOp81kXdlj/k+bnxogR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="12411514"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="12411514"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2023 23:41:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="763858934"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="763858934"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2023 23:41:02 -0800
Message-ID: <616b5d4e-39a1-4f61-8fa6-1938fb4df1a7@intel.com>
Date: Mon, 4 Dec 2023 15:40:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/70] physmem: replace function name with __func__ in
 ram_block_discard_range()
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-9-xiaoyao.li@intel.com>
 <24521a5c-beec-4f08-8e89-2a413788bf8b@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <24521a5c-beec-4f08-8e89-2a413788bf8b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/16/2023 2:21 AM, David Hildenbrand wrote:
> On 15.11.23 08:14, Xiaoyao Li wrote:
>> Use __func__ to avoid hard-coded function name.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
> 
> That can be queued independently.

Will you queue it for 9.0? for someone else?

Do I need to send it separately?

> Reviewed-by: David Hildenbrand <david@redhat.com>
> 


