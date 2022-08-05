Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDFC58A419
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 02:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbiHEAQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 20:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiHEAQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 20:16:26 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2E417AA3
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 17:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659658583; x=1691194583;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K1SdlcQDUknfyWqpf0El5/S3OXBEmuog0Lsy9lG1L3g=;
  b=LOxQNX2y3mj5eah+Iz5p4Y5vFSaDMojzuvrjZoTskfbqMBlLACHeyQgk
   K15vNLq5/KizswNnsuDibLLhqgWEzY/UvKmMHM534O/FMZEbrnPjos94L
   /23zGEXkVbk3j8fQgwM9t2F1JfFmB/oNnlq6eSxzVNyoD6aOol5so/P6o
   stn9L6NPWXHEhldyH5WmPZFPetc0oza7GwBe7qB/Ego4N3Yn6T+FpNYqx
   qOjJmLROKLVAd2JWhppBrM6QIymvTzDM2ddf8vv5DXtMiQKndODXTuNpQ
   TwhuTaXTFzQ4+9WYsDkGqUMBo2n6gfUlpw6r2DuI0SH0qCNGvw5pGVOeJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10429"; a="288844446"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="288844446"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 17:16:22 -0700
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="579293992"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.170.34]) ([10.249.170.34])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 17:16:18 -0700
Message-ID: <c76a9b00-7972-dcf1-28b4-6befe621e094@intel.com>
Date:   Fri, 5 Aug 2022 08:16:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v1 00/40] TDX QEMU support
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <YujzOUjMbBZRi/e6@redhat.com>
 <db14e4f1-6090-7f97-f690-176ba828500c@intel.com>
 <Yuqz6nPIIqzrlxP1@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Yuqz6nPIIqzrlxP1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/2022 1:44 AM, Daniel P. Berrangé wrote:
> On Tue, Aug 02, 2022 at 06:55:48PM +0800, Xiaoyao Li wrote:
>> On 8/2/2022 5:49 PM, Daniel P. Berrangé wrote:
>>> On Tue, Aug 02, 2022 at 03:47:10PM +0800, Xiaoyao Li wrote:
>>
>>>> - CPU model
>>>>
>>>>     We cannot create a TD with arbitrary CPU model like what for non-TDX VMs,
>>>>     because only a subset of features can be configured for TD.
>>>>     - It's recommended to use '-cpu host' to create TD;
>>>>     - '+feature/-feature' might not work as expected;
>>>>
>>>>     future work: To introduce specific CPU model for TDs and enhance +/-features
>>>>                  for TDs.
>>>
>>> Which features are incompatible with TDX ?
>>
>> TDX enforces some features fixed to 1 (e.g., CPUID_EXT_X2APIC,
>> CPUID_EXT_HYPERVISOR)and some fixed to 0 (e.g., CPUID_EXT_VMX ).
>>
>> Details can be found in patch 8 and TDX spec chapter "CPUID virtualization"
>>
>>> Presumably you have such a list, so that KVM can block them when
>>> using '-cpu host' ?
>>
>> No, KVM doesn't do this. The result is no error reported from KVM but what
>> TD OS sees from CPUID might be different what user specifies in QEMU.
>>
>>> If so, we should be able to sanity check the
>>> use of these features in QEMU for the named CPU models / feature
>>> selection too.
>>
>> This series enhances get_supported_cpuid() for TDX. If named CPU models are
>> used to boot a TDX guest, it likely gets warning of "xxx feature is not
>> available"
> 
> If the  ',check=on' arg is given to -cpu, does it ensure that the
> guest fails to startup with an incompatible feature set ? That's
> really the key thing to protect the user from mistakes.

"check=on" won't stop startup with an incompatible feature set but 
"enforce=on". Yes, this series can ensure it with "enforce=on"

> 
>> We have another series to enhance the "-feature" for TDX, to warn out if
>> some fixed1 is specified to be removed. Besides, we will introduce specific
>> named CPU model for TDX. e.g., TDX-SapphireRapids which contains the maximum
>> feature set a TDX guest can have on SPR host.
> 
> I don't know if this is the right approach or not, but we should at least
> consider making use of CPU versioning here.  ie have a single "SapphireRapids"
> alias, which resolves to a suitable specific CPU version depending on whether
> TDX is used or not.

New version of a CPU model inherits from the last version. This fits 
well with CPU model fixup when features need to be removed/added to 
existing CPU model to make it work well with the latest kernel, and a 
new version is created.

However, I think it less proper to define a TDX variant with versioned- 
cpu model. For example, we have a SPR-V(x), then we need to define 
SPR-V(x+1) and alias it as SPR-TDX. For SPR-V(x+1), we need to add and 
remove several features. In the future, we may need a SPR-V(x+2) to fix 
up the normal SPR cpu model SPR-V(x). All the changes in V(x+1)/SPR-TDX 
  has to be reverted at first.

Anyway, we can discuss it in the future when we post the series of TDX 
CPU model. We plan to do that after this basic series gets merged. :)

> With regards,
> Daniel

