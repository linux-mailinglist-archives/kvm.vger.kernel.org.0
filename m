Return-Path: <kvm+bounces-4425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CF6268125C0
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 04:07:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3509AB20ACF
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 03:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66E7715D1;
	Thu, 14 Dec 2023 03:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HNbUTl7d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB18E0
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 19:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702523256; x=1734059256;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=o+Xh5+ubvPl+H4+Pxt2mVXHzTgpGDMgBg6p1Y6WJUnI=;
  b=HNbUTl7d432CuTzyiAN1EKdlrFS4QsfpLY4SQgj9Hy8JXQ2P5s6imJGV
   sviPt7e6/ZbXXWmSrRYKHDC/w2nxx9ATnYxXpsOmOEvewf/M5dQgNIxFc
   gdBtrKu9erUYBELEhfA09ZqulMr8UBLY82/CrRRwN3EeNp+BJzsmKfboE
   tsOqgk39fnuxI7JYysOOda03Gs2y8/7RmrWjKQkNeNtBJUrOZ4Md21ROh
   vH60dEToiXzKPrUNyNg4WY6SNsUXjM+t0XhS4zlR7bKUmyNzpRRkLx817
   7oEjEkQUmP2zdmuuXVboRuZTOuhWqWX5lrl104dWswA7nmVa69k5CYWar
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="8421972"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="8421972"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 19:07:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="917899219"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="917899219"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 19:07:24 -0800
Message-ID: <31d6dbc1-f453-4cef-ab08-4813f4e0ff92@intel.com>
Date: Thu, 14 Dec 2023 11:07:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 31/70] i386/tdx: Allows
 mrconfigid/mrowner/mrownerconfig for TDX_INIT_VM
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
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87o7faw5k1.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/1/2023 7:00 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Three sha384 hash values, mrconfigid, mrowner and mrownerconfig, of a TD
>> can be provided for TDX attestation.
>>
>> So far they were hard coded as 0. Now allow user to specify those values
>> via property mrconfigid, mrowner and mrownerconfig. They are all in
>> base64 format.
>>
>> example
>> -object tdx-guest, \
>>    mrconfigid=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
>>    mrowner=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
>>    mrownerconfig=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> Changes in v3:
>>   - use base64 encoding instread of hex-string;
>> ---
>>   qapi/qom.json         | 11 +++++-
>>   target/i386/kvm/tdx.c | 85 +++++++++++++++++++++++++++++++++++++++++++
>>   target/i386/kvm/tdx.h |  3 ++
>>   3 files changed, 98 insertions(+), 1 deletion(-)
>>
>> diff --git a/qapi/qom.json b/qapi/qom.json
>> index 3a29659e0155..fd99aa1ff8cc 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -888,10 +888,19 @@
>>   #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>>   #     be set, otherwise they refuse to boot.
>>   #
>> +# @mrconfigid: base64 encoded MRCONFIGID SHA384 digest
>> +#
>> +# @mrowner: base64 encoded MROWNER SHA384 digest
>> +#
>> +# @mrownerconfig: base64 MROWNERCONFIG SHA384 digest
> 
> Can we come up with a description that tells the user a bit more clearly
> what we're talking about?  Perhaps starting with this question could
> lead us there: what's an MRCONFIGID, and why should I care?

Below are the definition from TDX spec:

MRCONFIGID: Software-defined ID for non-owner-defined configuration of 
the guest TD – e.g., run-time or OS configuration.

MROWNER: Software-defined ID for the guest TD’s owner

MROWNERCONFIG: Software-defined ID for owner-defined configuration of 
the guest TD – e.g., specific to the workload rather than the run-time or OS


They are all attestation related, and input by users who launches the TD 
. Software inside TD can retrieve them with TDREPORT and verify if it is 
the expected value.

MROWNER is to identify the owner of the TD, MROWNERCONFIG is to pass 
OWNER's configuration. And MRCONFIGID contains configuration specific to 
OS level instead of OWNER.

Below is the explanation from Intel inside, hope it can get you more clear:

"These are primarily intended for general purpose, configurable software 
in a minimal TD. So, not a legacy VM image cloud customer wanting to 
move their VM out into the cloud. Also it’s not necessarily the case 
that any workload will use them all.

MROWNER is for declaring the owner of the TD. An example use case would 
be an vHSM TD. HSMs need to know who their administrative contact is. 
You could customize the HSM image and measurements, but then people 
can’t recognize that this is the vHSM product from XYZ. So you put the 
unmodified vHSM stack in the TD, which will include MRTD/RTMRs that 
reflect the vHSM, and the owner’s public key in MROWNER. Now, when the 
vHSM starts up, to determine who is authorized to send commands, it does 
a TDREPORT, and looks at MROWNER.

Extending this model, there could be important configuration information 
from the owner. In that case, MROWNERCONFIG is set to the hash of the 
config file that the vHSM should accept.

This results in an attestable environment that explicitly indicates that 
it’s a well recognized vHSM TD, being administered by MROWNER and 
loading the configuration information that matches MROWNERCONFIG.

Extending this idea of configuration of generally recognized software, 
it could be that there is a shim OS under the vHSM that itself is 
configurable. So MRCONFIGID, which isn’t a great name, can include 
configuration information intended for the OS level. The ID is 
confusing, but MRCONFIGID was the name we used for this register for 
SGX, so we kept the name."

>> +#
>>   # Since: 8.2
>>   ##
>>   { 'struct': 'TdxGuestProperties',
>> -  'data': { '*sept-ve-disable': 'bool' } }
>> +  'data': { '*sept-ve-disable': 'bool',
>> +            '*mrconfigid': 'str',
>> +            '*mrowner': 'str',
>> +            '*mrownerconfig': 'str' } }
>>   
>>   ##
>>   # @ThreadContextProperties:
> 
> [...]
> 


