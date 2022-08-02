Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA9E587B1F
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 12:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235903AbiHBKz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 06:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiHBKz5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 06:55:57 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8495EB12
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 03:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659437756; x=1690973756;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vZz9mzuhpu3zRjEhVt6UxN62+bj06C97CVbwXNC20bk=;
  b=cUyLjnsFeLnXUFzox5LYMuZL72U8+AEI923dOQhyL/4xQjIXv/6TilgL
   36/UpF7VITLkGXcWpJXYEam1558Z5x/iFzCVvE8lMSzwSBthlcgDfgQqE
   19tF4c3V9fPLHE8HmAf95MVak/EtxBd+lJY9bDMZarMnlQbo2MP4Dcnes
   SzdreQWblnP5ZncpYmSsNOq1iXN0ToPSZKyfuzx5mUojrTNdgvixvtF+G
   u9vO7e+zVCkVUti3HrQVMdwOIIuJklNHq052Ge95J9nWOkl2BN3EAJ3t1
   mOeLojvRWT3QLQCghg7iPDDeY3aprLFoOvRXx6cLBLDsvHK6VabXtGP46
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="290154896"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="290154896"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 03:55:56 -0700
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="578175803"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.175.192]) ([10.249.175.192])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 03:55:51 -0700
Message-ID: <db14e4f1-6090-7f97-f690-176ba828500c@intel.com>
Date:   Tue, 2 Aug 2022 18:55:48 +0800
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
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <YujzOUjMbBZRi/e6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/2/2022 5:49 PM, Daniel P. Berrangé wrote:
> On Tue, Aug 02, 2022 at 03:47:10PM +0800, Xiaoyao Li wrote:

>> - CPU model
>>
>>    We cannot create a TD with arbitrary CPU model like what for non-TDX VMs,
>>    because only a subset of features can be configured for TD.
>>    
>>    - It's recommended to use '-cpu host' to create TD;
>>    - '+feature/-feature' might not work as expected;
>>
>>    future work: To introduce specific CPU model for TDs and enhance +/-features
>>                 for TDs.
> 
> Which features are incompatible with TDX ?

TDX enforces some features fixed to 1 (e.g., CPUID_EXT_X2APIC, 
CPUID_EXT_HYPERVISOR)and some fixed to 0 (e.g., CPUID_EXT_VMX ).

Details can be found in patch 8 and TDX spec chapter "CPUID virtualization"

> Presumably you have such a list, so that KVM can block them when
> using '-cpu host' ? 

No, KVM doesn't do this. The result is no error reported from KVM but 
what TD OS sees from CPUID might be different what user specifies in QEMU.

> If so, we should be able to sanity check the
> use of these features in QEMU for the named CPU models / feature
> selection too.

This series enhances get_supported_cpuid() for TDX. If named CPU models 
are used to boot a TDX guest, it likely gets warning of "xxx feature is 
not available"

We have another series to enhance the "-feature" for TDX, to warn out if 
some fixed1 is specified to be removed. Besides, we will introduce 
specific named CPU model for TDX. e.g., TDX-SapphireRapids which 
contains the maximum feature set a TDX guest can have on SPR host.

> 
> With regards,
> Daniel

