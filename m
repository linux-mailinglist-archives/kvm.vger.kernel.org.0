Return-Path: <kvm+bounces-4777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 82693818353
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 09:28:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A63E2B23632
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 08:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B116514A87;
	Tue, 19 Dec 2023 08:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ap+3Zdu0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE2713FFD
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 08:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702974484; x=1734510484;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SF1xtC9s/BdwmVxQ+MVzSKvMYcd3/QhbK4vXAjIWhyo=;
  b=ap+3Zdu0pDtWyNlLtmArNSCCv7N9JWMAqiqawEYn7C2DYG3oWAdQbWqT
   OcK2qmOwxv7gfpS5vsPkQXy0bGsIiBRbG2XtUDxCrUhg2XVmGfGiVOpaK
   wWiGEAruPR9rKX+3UE9uU+KqRDwe2WfcrmFryU47VPAhS6sL/2rb4sAD+
   ljyZlwFv5oN5bjPBXa/dIPRwLoXT+Cy41FIZ7KP2kugUtWJH1sTqd6nDo
   /IvBJT8QdStR0+/62NdgrwpD3mtFO1sweHVq/D0d/BAMmFvM5wxk8IpDW
   2KioK4Xf8y2QSYxjGLMIAaTSSffvnFLnu8QadTVSw6sP23ybrL1h38CfQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="395354916"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="395354916"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 00:28:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="725657611"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="725657611"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.8.39]) ([10.93.8.39])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 00:27:56 -0800
Message-ID: <8532ca57-629e-41e2-93ef-4b1e25587d0c@intel.com>
Date: Tue, 19 Dec 2023 16:27:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 31/70] i386/tdx: Allows
 mrconfigid/mrowner/mrownerconfig for TDX_INIT_VM
Content-Language: en-US
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2EBerrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-32-xiaoyao.li@intel.com>
 <87o7faw5k1.fsf@pond.sub.org>
 <31d6dbc1-f453-4cef-ab08-4813f4e0ff92@intel.com>
 <87edfjsjvx.fsf@pond.sub.org>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87edfjsjvx.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/18/2023 9:46 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> On 12/1/2023 7:00 PM, Markus Armbruster wrote:
>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>
>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>
>>>> Three sha384 hash values, mrconfigid, mrowner and mrownerconfig, of a TD
>>>> can be provided for TDX attestation.
>>>>
>>>> So far they were hard coded as 0. Now allow user to specify those values
>>>> via property mrconfigid, mrowner and mrownerconfig. They are all in
>>>> base64 format.
>>>>
>>>> example
>>>> -object tdx-guest, \
>>>>     mrconfigid=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
>>>>     mrowner=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
>>>>     mrownerconfig=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v
>>>>
>>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> ---
>>>> Changes in v3:
>>>>    - use base64 encoding instread of hex-string;
>>>> ---
>>>>    qapi/qom.json         | 11 +++++-
>>>>    target/i386/kvm/tdx.c | 85 +++++++++++++++++++++++++++++++++++++++++++
>>>>    target/i386/kvm/tdx.h |  3 ++
>>>>    3 files changed, 98 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/qapi/qom.json b/qapi/qom.json
>>>> index 3a29659e0155..fd99aa1ff8cc 100644
>>>> --- a/qapi/qom.json
>>>> +++ b/qapi/qom.json
>>>> @@ -888,10 +888,19 @@
>>>>   #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>>>>   #     be set, otherwise they refuse to boot.
>>>>   #
>>>> +# @mrconfigid: base64 encoded MRCONFIGID SHA384 digest
>>>> +#
>>>> +# @mrowner: base64 encoded MROWNER SHA384 digest
>>>> +#
>>>> +# @mrownerconfig: base64 MROWNERCONFIG SHA384 digest
>>>
>>> Can we come up with a description that tells the user a bit more clearly
>>> what we're talking about?  Perhaps starting with this question could
>>> lead us there: what's an MRCONFIGID, and why should I care?
>>
>> Below are the definition from TDX spec:
>>
>> MRCONFIGID: Software-defined ID for non-owner-defined configuration of the guest TD – e.g., run-time or OS configuration.
>>
>> MROWNER: Software-defined ID for the guest TD’s owner
>>
>> MROWNERCONFIG: Software-defined ID for owner-defined configuration of the guest TD – e.g., specific to the workload rather than the run-time or OS
> 
> Have you considered using this for the doc comments?  I'd omit
> "software-defined" in this context.

sure. I will use them in the next version.

>> They are all attestation related, and input by users who launches the TD . Software inside TD can retrieve them with TDREPORT and verify if it is the expected value.
>>
>> MROWNER is to identify the owner of the TD, MROWNERCONFIG is to pass OWNER's configuration. And MRCONFIGID contains configuration specific to OS level instead of OWNER.
>>
>> Below is the explanation from Intel inside, hope it can get you more clear:
>>
>> "These are primarily intended for general purpose, configurable software in a minimal TD. So, not a legacy VM image cloud customer wanting to move their VM out into the cloud. Also it’s not necessarily the case that any workload will use them all.
>>
>> MROWNER is for declaring the owner of the TD. An example use case would be an vHSM TD. HSMs need to know who their administrative contact is. You could customize the HSM image and measurements, but then people can’t recognize that this is the vHSM product from XYZ. So you put the unmodified vHSM stack in the TD, which will include MRTD/RTMRs that reflect the vHSM, and the owner’s public key in MROWNER. Now, when the vHSM starts up, to determine who is authorized to send commands, it does a TDREPORT, and looks at MROWNER.
>>
>> Extending this model, there could be important configuration information from the owner. In that case, MROWNERCONFIG is set to the hash of the config file that the vHSM should accept.
>>
>> This results in an attestable environment that explicitly indicates that it’s a well recognized vHSM TD, being administered by MROWNER and loading the configuration information that matches MROWNERCONFIG.
>>
>> Extending this idea of configuration of generally recognized software, it could be that there is a shim OS under the vHSM that itself is configurable. So MRCONFIGID, which isn’t a great name, can include configuration information intended for the OS level. The ID is confusing, but MRCONFIGID was the name we used for this register for SGX, so we kept the name."
> 
> Include a reference to this document?

That was the email reply from internal attestation folks.

but I can add the link to this mail in the version.

>>>> +#
>>>>   # Since: 8.2
>>>>   ##
>>>>   { 'struct': 'TdxGuestProperties',
>>>> -  'data': { '*sept-ve-disable': 'bool' } }
>>>> +  'data': { '*sept-ve-disable': 'bool',
>>>> +            '*mrconfigid': 'str',
>>>> +            '*mrowner': 'str',
>>>> +            '*mrownerconfig': 'str' } }
>>>>    ##
>>>>    # @ThreadContextProperties:
>>> [...]
>>>
> 


