Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095A14ED44B
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 08:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbiCaG7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 02:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiCaG7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 02:59:42 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8BF1575B4
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 23:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648709875; x=1680245875;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O/bKGbwTuz4odrbizTQy29vauof302HjcqPe5nVHZvI=;
  b=g7VWPqa0dB7YfESUx7iU7P2Nm3n8bkohCBXH7YRYcvulo/UUPWPfF+yI
   eRsqSc9xhqXhlelAjgvNBxyRwZLJFjjeWGyygJoDc5TAJ4mapeJXtF9g3
   6lZJppA6oMc25Cw6snZKq7Ef9JAzMJ0GEWcoaMCM4LSQn5eDHy18XjE+0
   gcPdIksnvcKZJMWk+g0F8cjg00FQzXil1gzHBbsmVYU4WA18gQ5AQMqfY
   MpvsY17iJLeCPEsRvsT5SiE9ofXq9XsuxuZ7Zh3CQXlayd5mWZTsXsxvB
   Pc0csBEZIUNe30JNxNpVDTBwUiXeM8CLm6T/XblNKLpx5I0+GG67jJS5z
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="259449743"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="259449743"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 23:57:54 -0700
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="547188445"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.193.1]) ([10.249.193.1])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 23:57:50 -0700
Message-ID: <9d6299ef-ed28-7192-7f8e-5c1a4daf6a62@intel.com>
Date:   Thu, 31 Mar 2022 14:57:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v3 17/36] pflash_cfi01/tdx: Introduce ram_mode of
 pflash for TDVF
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
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
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        erdemaktas@google.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        seanjc@google.com
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-18-xiaoyao.li@intel.com>
 <f418548e-c24c-1bc3-4e16-d7a775298a18@gmail.com>
 <7a8233e4-0cae-b05a-7931-695a7ee87fc9@intel.com>
 <20220322092141.qsgv3pqlvlemgrgw@sirius.home.kraxel.org>
 <YjmXFZRCbKXTkAhN@redhat.com>
 <20220322103518.ljbi4pvghbgjxm7k@sirius.home.kraxel.org>
 <YjmqOolbafWkMEHN@redhat.com>
 <20220322122024.blyut6mnszhyw6hz@sirius.home.kraxel.org>
 <20220324083528.deoh77e77swf67gb@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220324083528.deoh77e77swf67gb@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/24/2022 4:35 PM, Gerd Hoffmann wrote:
> On Tue, Mar 22, 2022 at 01:20:24PM +0100, Gerd Hoffmann wrote:
>>    Hi,
>>
>>> At the time I did try a gross hack that (IIRC) disabled the
>>> rom_reset logic, and munged x86_bios_rom_init so that it would
>>> force load it straight at the RAM location.
>>
>> Sounds reasonable.  The whole rom logic exists to handle resets,
>> but with confidential guests we don't need that, we can't change
>> guest state to perform a reset anyway ...
> 
> Completed, cleaned up a bit, but untested:
>    https://git.kraxel.org/cgit/qemu/log/?h=sirius/cc
> 
> Any chance you can give this a try?

Hi Gred,

I refactor the TDX series to load TDVF via "-bios" option upon it.

No issue hit.

Thanks,
-Xiaoyao

> thanks,
>    Gerd
> 

