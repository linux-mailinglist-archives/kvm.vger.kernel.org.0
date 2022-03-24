Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E11A4E603B
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 09:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348880AbiCXIUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 04:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348872AbiCXIUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 04:20:01 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2899284B
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 01:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648109909; x=1679645909;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SFCP+FN92bSkd2t6kU2XW/ohSbmfvTSxmWku8wbVy/k=;
  b=L3hHegexgvHBID95JA8UHC7JlvkI0eKFTOQjtzM7BeUFrBAcGLFYx2X7
   PpJKQsdGxs8jV2Mt83wky3ciJEfaranBNgSJouIFjQShWYYtou0Ts9B+T
   zJ7YbpqrPABhgYGbH1aQQMSFariIZxPvyKG/SUiyjZEyn+9mjPH+sSJrG
   gp3uMsJMFcD452x4e5I1DoQmXxdsl7lsj+qfzaUC3Swi8iHUqtjCrh3o6
   1S2nHU5Ad72LefkAsSg5sJwGhkAmODjbQCeuYDvcmmNxsb2LYi8sqJqXg
   WZ9DJKcwEtEbszYN5M4ER7z1f7jwdvlPbk/dxEwcR1lA+86v/aWDWzTZE
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="258503882"
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="258503882"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 01:18:29 -0700
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="561274077"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.201.150]) ([10.249.201.150])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 01:18:24 -0700
Message-ID: <8537b667-67c0-7880-f9fd-ed7b7154c190@intel.com>
Date:   Thu, 24 Mar 2022 16:18:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v3 17/36] pflash_cfi01/tdx: Introduce ram_mode of
 pflash for TDVF
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
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
 <e7fb2eab-b2b1-dd0e-4821-4cca40751d15@intel.com>
 <20220324075841.6ywj6eboeyep2sz2@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220324075841.6ywj6eboeyep2sz2@sirius.home.kraxel.org>
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

On 3/24/2022 3:58 PM, Gerd Hoffmann wrote:
>    Hi,
> 
>>>> Well, if persistent vars are not supported anyway there is little reason
>>>> to split the firmware into CODE and VARS files.  You can use just use
>>>> OVMF.fd with a single pflash device.  libvirt recently got support for
>>>> that.
>>>
>>> Agreed.
>>
>> The purpose of using split firmware is that people can share the same
>> code.fd while using different vars.fd
> 
> Using different vars.fd files is pointless though when changes are never
> written back ...

Yes, I agree on this.

Off the topic. If we really want to NVRAM capability to TDX guest, 1) we 
can use the PV interface issue MMIO write in OVMF, like what SEV does in 
OVMF. 2) map OVMF as shared, thus existing pflash works well.

However, both options will expose the content to VMM, which loses 
confidentiality.

> take care,
>    Gerd
> 

