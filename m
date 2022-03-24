Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E604E6565
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 15:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350950AbiCXOia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 10:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245080AbiCXOi3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 10:38:29 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB2C1106
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 07:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648132617; x=1679668617;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kuUZZE3Y+2nYQ+xUdxnV5mXzvQrIWXlqswvHHABl52o=;
  b=dmrCSSHtsE0HizA3v/2v99/liCB3Nsvy/B7XnMFdlcaR613/JdtA6Ynv
   uux7V+fI3DGiEszK0ME4x2Z2Wzkhp5Du9uQkvWOsG9m3Esl0xYS9MPITW
   TxKFu2JV4o2HNE711n4ZIcnEjOA5C4mUCjHW3cSRMSgSZm4cSmW/g2Q2m
   TZiTxWOK7r5E1u5B7NVCLEI5QVWM9+e9M2zIBqGtIhpRbGCDDjqqVuhA5
   vUJv/UHRk21Jz/Ls15dq2Olu1s1m9w5by8nWcVSSXwBmfiThh6cHcQvX3
   1hO3/SDbl71Rd0IQGp7PeZtcCkhbmwAOKOyPL08tNDfwTLXVlGErH6y6Q
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="245868978"
X-IronPort-AV: E=Sophos;i="5.90,207,1643702400"; 
   d="scan'208";a="245868978"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 07:36:57 -0700
X-IronPort-AV: E=Sophos;i="5.90,207,1643702400"; 
   d="scan'208";a="561397107"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.29.242]) ([10.255.29.242])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 07:36:53 -0700
Message-ID: <b8ea630c-cbd8-80f4-1acc-396f1665dfba@intel.com>
Date:   Thu, 24 Mar 2022 22:36:51 +0800
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
 <b452d357-8fc2-c49c-8c19-a57b1ff287e8@intel.com>
 <20220324075703.7ha44rd463uwnl55@sirius.home.kraxel.org>
 <4fc788e8-1805-c7cd-243d-ccd2a6314a68@intel.com>
 <20220324093725.hs3kpcehsbklacnj@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220324093725.hs3kpcehsbklacnj@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/24/2022 5:37 PM, Gerd Hoffmann wrote:
>    Hi,
> 
>> #VE can be triggered in various situations. e.g., CPUID on some leaves, and
>> RD/WRMSR on some MSRs. #VE on pending page is just one of the sources, Linux
>> just wants to disable this kind of #VE since it wants to prevent unexpected
>> #VE during SYSCALL gap.
> 
> Linux guests can't disable those on their own?  Requiring this being
> configured on the host looks rather fragile to me ...

Yes, current TDX architecture doesn't allow TD guest to do so. Maybe in 
the future, it can be allowed, maybe.

> take care,
>    Gerd
> 

