Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE034E5EF7
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 07:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344977AbiCXGyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 02:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiCXGyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 02:54:02 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C83695494
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 23:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648104751; x=1679640751;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q3/NuftGfLPPjfiFFvPfNgBlxWkXnmen2C4wwhW3JZw=;
  b=GEjaQnw9sxtKN1gQsEwdAwV3R4JPRRrxwkTl3Tolt9d46rsnsfe/Dith
   yIUn5Lv9nXHsn78DAVF57Sbf49M7uOEuaWroa4eiNKwfr4gdf5MRGVMYB
   NZ/JCS3dCTsETY/NEo0zQ7YsnsrxONoP8avVf0WTgA2S/EbWFan7bPWuq
   iYcrbons0ShnJ0KZOMF3kD3Ugct5xgQAkCL05zaBHLzINv9BBuDLPk1sp
   xk/sUUIw/9yjjp1/xmryse+FAhvWhRJKLsqfYcQJrmBTOQT1n2IeAPzQG
   5LStfJxS/t0cbtltUIVVj8MC03vPnSZg+zDCoMf5eHKjedFr5Km9OHp1x
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="255867093"
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="255867093"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 23:52:17 -0700
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="561239669"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.201.150]) ([10.249.201.150])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 23:52:12 -0700
Message-ID: <b452d357-8fc2-c49c-8c19-a57b1ff287e8@intel.com>
Date:   Thu, 24 Mar 2022 14:52:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v3 12/36] i386/tdx: Add property sept-ve-disable for
 tdx-guest object
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        erdemaktas@google.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        seanjc@google.com
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-13-xiaoyao.li@intel.com>
 <20220322090238.6job2whybu6ntor7@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220322090238.6job2whybu6ntor7@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/2022 5:02 PM, Gerd Hoffmann wrote:
> On Thu, Mar 17, 2022 at 09:58:49PM +0800, Xiaoyao Li wrote:
>> Add sept-ve-disable property for tdx-guest object. It's used to
>> configure bit 28 of TD attributes.
> 
> What is this?

It seems this bit doesn't show up in the public spec yet.

Bit 28 (SEPT_VE_DISABLE): Disable EPT violation conversion to #VE ON 
guest TD ACCESS of PENDING pages.

The TDX architecture requires a private page to be accepted before 
using. If guest accesses a not-accepted (pending) page it will get #VE.

For some OS, e.g., Linux TD guest, it doesn't want the #VE on pending 
page so it will set this bit.

>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -792,10 +792,13 @@
>>   #
>>   # @attributes: TDX guest's attributes (default: 0)
>>   #
>> +# @sept-ve-disable: attributes.sept-ve-disable[bit 28] (default: 0)
> 
> I'd suggest to document this here.
> 
> thanks,
>    Gerd
> 

