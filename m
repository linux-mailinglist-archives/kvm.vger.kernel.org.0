Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A03C587AD2
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 12:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236102AbiHBKip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 06:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235957AbiHBKin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 06:38:43 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412E3192B3
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 03:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659436723; x=1690972723;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yRO/Qak8meRaRYV429cR8sxpDUpVbz1fGwGn6gbLGuA=;
  b=YEjliLWNry0q6fx3tyfcEljBUFwxsfEXrEG7avy7DEH9Ygfh0eVXpOzA
   YQnpsNM6RyspphFxr42bXu5RcvxH0YYAVLmhkUo5fOj98POQMvfN3IZLc
   KTrXJKsTYxkGaw5rPtDSzMEC44WnvOFfwgQEGd5FncTmHsVR+zC5z05qY
   TE7LB9r62GDphsfe02yGtV9fGiFV+6YX4psbcPR8VScFRN3BxccuYkhSl
   2Cq/1CyD7jXBhLfExAdXZIro3pKjtuW1ogPM2gocMTwAQJfWCWOeGM/XP
   78FrDzIRQ/s1xN+5n9UMb4BYaH/X3w0LKoxlhFXpI+xOsqKHHQ6Mdf/m9
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="290152245"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="290152245"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 03:38:30 -0700
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="578172223"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.175.192]) ([10.249.175.192])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 03:38:26 -0700
Message-ID: <8442ad7a-7c91-e5ba-3f12-c2e053290857@intel.com>
Date:   Tue, 2 Aug 2022 18:38:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v1 01/40] *** HACK *** linux-headers: Update headers to
 pull in TDX API changes
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
 <20220802074750.2581308-2-xiaoyao.li@intel.com> <YujyyAeHMJaWOtR2@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <YujyyAeHMJaWOtR2@redhat.com>
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

On 8/2/2022 5:47 PM, Daniel P. Berrangé wrote:
> On Tue, Aug 02, 2022 at 03:47:11PM +0800, Xiaoyao Li wrote:
>> Pull in recent TDX updates, which are not backwards compatible.
>>
>> It's just to make this series runnable. It will be updated by script
>>
>> 	scripts/update-linux-headers.sh
>>
>> once TDX support is upstreamed in linux kernel.
> 
> I saw a bunch of TDX support merged in 5.19:
> 
> commit 3a755ebcc2557e22b895b8976257f682c653db1d
> Merge: 5b828263b180 c796f02162e4
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon May 23 17:51:12 2022 -0700
> 
>      Merge tag 'x86_tdx_for_v5.19_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>      
>      Pull Intel TDX support from Borislav Petkov:
>       "Intel Trust Domain Extensions (TDX) support.
>      
>        This is the Intel version of a confidential computing solution called
>        Trust Domain Extensions (TDX). This series adds support to run the
>        kernel as part of a TDX guest. It provides similar guest protections
>        to AMD's SEV-SNP like guest memory and register state encryption,
>        memory integrity protection and a lot more.
>      
>        Design-wise, it differs from AMD's solution considerably: it uses a
>        software module which runs in a special CPU mode called (Secure
>        Arbitration Mode) SEAM. As the name suggests, this module serves as
>        sort of an arbiter which the confidential guest calls for services it
>        needs during its lifetime.
>      
>        Just like AMD's SNP set, this series reworks and streamlines certain
>        parts of x86 arch code so that this feature can be properly
>        accomodated"
> 
> 
> Is that sufficient for this patch, or is there more pending out of
> tree that QEMU still depends on ?

That's TDX guest support, i.e., running Liunx as TDX guest OS.

What QEMU needs is TDX KVM support and that hasn't been merged yet.

> With regards,
> Daniel

