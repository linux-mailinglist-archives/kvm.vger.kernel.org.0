Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0024EDC19
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 16:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbiCaOw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 10:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237842AbiCaOwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 10:52:55 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0798756407
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 07:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648738267; x=1680274267;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IdPVgYv7jMZxTmW8cgKoipO58BY+gpsYPjK9ZurKhEw=;
  b=XMWLrNN+m9BuhpU3KgmuRqQIttKKwZlS0rFGRSqrL7stkvf0i/82w7WQ
   /5DHw/WjhlEkUnf3a9kO53QA1Lt1vZY5/g73aM0sTXnoD6/fmn8DhBSZj
   Q9MWhMZsG3GHhODSfdUJXej0Pq3wHxqU/wYmWs+jLHeCA9cr0pvqqmzAQ
   XfQNRIgtEOBqMSq0Wx/6exi1xapg37H9lqrzMEPsvlmDE9cFm3Bowm/gI
   VDf7oNIRlBq55IF5eCzkWxZDdgIj420P1TCjO5OhcOaKfrHwYH8WBf4ZJ
   c6L3fUHkxe6F34fu8woHM0aJuv8NQkLEjoI+K1p35xOfS/g3f/N82U3FR
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="323032784"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="323032784"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 07:51:06 -0700
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="547364693"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.193.1]) ([10.249.193.1])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 07:51:02 -0700
Message-ID: <714b7d35-911c-ba68-22a9-86b9edb6fe47@intel.com>
Date:   Thu, 31 Mar 2022 22:50:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v3 17/36] pflash_cfi01/tdx: Introduce ram_mode of
 pflash for TDVF
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
        <philippe.mathieu.daude@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        erdemaktas@google.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        seanjc@google.com
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-18-xiaoyao.li@intel.com>
 <f418548e-c24c-1bc3-4e16-d7a775298a18@gmail.com>
 <7a8233e4-0cae-b05a-7931-695a7ee87fc9@intel.com>
 <YjmWhMVx80/BFY8z@redhat.com>
 <1d5b0192-75ef-49ad-dc47-cfc0c3c63455@intel.com>
 <YkVtuRNherKV1kJC@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <YkVtuRNherKV1kJC@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/31/2022 5:00 PM, Daniel P. Berrangé wrote:
> On Thu, Mar 31, 2022 at 04:51:27PM +0800, Xiaoyao Li wrote:
>> On 3/22/2022 5:27 PM, Daniel P. Berrangé wrote:
>> ...
>>> IMHO the AmdSev build for OVMF gets this right by entirely disabling
>>> the split OVMF_CODE.fd vs OVMF_VARS.fd, and just having a single
>>> OVMF.fd file that is exposed read-only to the guest.
>>>
>>> This is further represented in $QEMU.git/docs/interop/firmware.json
>>> by marking the firmware as 'stateless', which apps like libvirt will
>>> use to figure out what QEMU command line to pick.
>>
>> Hi Daniel,
>>
>> I don't play with AMD SEV and I'm not sure if AMD SEV requires only single
>> OVMF.fd. But IIUC, from edk2
>>
>> commit 437eb3f7a8db ("OvmfPkg/QemuFlashFvbServicesRuntimeDxe: Bypass flash
>> detection with SEV-ES")
>>
>> , AMD SEV(-ES) does support NVRAM via proactive VMGEXIT MMIO
>> QemuFlashWrite(). If so, AMD SEV seems to be able to support split OVMF,
>> right?
> 
> Note that while the traditional OvmfPkg build can be used with
> SEV/SEV-ES, this is not viable for measured boot, as it uses
> the NVRAM whose content is not measured.
> 
> I was specifically referring to the OvmfPkg/AmdSev build which
> doesn't use seprate NVRAM, and has no variables persistence.

Thanks for the info. It seems I need to learn more about those. It would 
be very appreciated if you can provide me some links.

> With regards,
> Daniel

