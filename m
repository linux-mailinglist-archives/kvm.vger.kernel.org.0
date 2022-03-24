Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A924E5E86
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 07:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241671AbiCXGPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 02:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbiCXGPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 02:15:33 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A9C7B132
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 23:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648102441; x=1679638441;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UOpTd7StGhej4ruU8H47HWJvgta4QrBbISqx81PRTkk=;
  b=DbuR9Z+rruDUeig0S1ozqWGpbJcxyeJdU/26atbDflW6TLWROIb1XzX3
   qZ7qT8UQy/eIb4IGMCa+RV4J9vWr3jd2bmFc238RqP62btsf7sgwI57/T
   VpKTuTY8yAk91eXQJlILoqwaE+eL5ocEU+4BkIDQwztfibETXXIGU7M1a
   3ujOmBcQDCDHkfTKiaWiS3WcyU4Xk8NgWiJCalTay6s/iNcNlGRp2PUJJ
   A6PgltbEr6k21B/nydCnipHNMp+dmPEiJhcLn0CIT/M8oOdLZLIau5v9a
   sampehzJpilgQ9ogL8BHOgSkWl87EeA9hjq1wrhfP5O2j/hXaaPfR0DUp
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="238897384"
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="238897384"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 23:14:01 -0700
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="561229879"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.201.150]) ([10.249.201.150])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 23:13:56 -0700
Message-ID: <e7fb2eab-b2b1-dd0e-4821-4cca40751d15@intel.com>
Date:   Thu, 24 Mar 2022 14:13:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v3 17/36] pflash_cfi01/tdx: Introduce ram_mode of
 pflash for TDVF
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
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
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <YjmXFZRCbKXTkAhN@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/2022 5:29 PM, Daniel P. Berrangé wrote:
> On Tue, Mar 22, 2022 at 10:21:41AM +0100, Gerd Hoffmann wrote:
>>    Hi,
>>
>>>> If you don't need a pflash device, don't use it: simply map your nvram
>>>> region as ram in your machine. No need to clutter the pflash model like
>>>> that.
>>
>> Using the pflash device for something which isn't actually flash looks a
>> bit silly indeed.
>>
>>>
>>> I know it's dirty to hack the pflash device. The purpose is to make the user
>>> interface unchanged that people can still use
>>>
>>> 	-drive if=pflash,format=raw,unit=0,file=/path/to/OVMF_CODE.fd
>>>          -drive if=pflash,format=raw,unit=1,file=/path/to/OVMF_VARS.fd
>>>
>>> to create TD guest.
>>
>> Well, if persistent vars are not supported anyway there is little reason
>> to split the firmware into CODE and VARS files.  You can use just use
>> OVMF.fd with a single pflash device.  libvirt recently got support for
>> that.
> 
> Agreed.

The purpose of using split firmware is that people can share the same 
code.fd while using different vars.fd



