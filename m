Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD83584A4A
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 05:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbiG2Dui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 23:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiG2Dug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 23:50:36 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626012AC69
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 20:50:33 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o14-20020a17090a4b4e00b001f2f2b61be5so4066586pjl.4
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 20:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YQpurthpd79ltKeNcne3CW9AN47hruLnqp7ECw/DFPY=;
        b=KV0WesXazPGGQgHCyrTIeS5eGadDx3WUDze+7p6emj8xgNmrF03XqWzy6atLQWqJUM
         gkavXGZbmuXlIsi+R8Qo3yJcvcVv8Qizp5s4iYqWwoCWoYEsJNlKWZp42IfS/7tCGPZQ
         H3PMI4M5lTgUDuJxhHvVAzWLuHvXhiz7prMZrO33MJbHcIDuPCv/FS/18u5LvLhL21HN
         Zn/zlbWxorQm7MD+OL6oYg8ImylwTu1a9I6yLm7NcWtsdG4I7ZN5aXY9ifMX9eI9RpSY
         Ko5PMu01R7wMn5lD0Uie57TWzbmVHYENko0oTdH80PYKCAaUnYFeZ/YLTzpcn5qzkvH3
         GQrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YQpurthpd79ltKeNcne3CW9AN47hruLnqp7ECw/DFPY=;
        b=UtwZ2mlnsbjSvgVq5LpI/AauUDzde8xz1ZgpwVdUAeVW6gdu/TmMx1DG/JY22tSUxf
         jMvegv3Jk7d8jzG3L1wJKKzWCqCRtBOIuYroTcRec5ym5Y14cC+IKnHrBaXLC1ofNYdt
         dUWUEfwUNyaYaz08xMIlHMeKlXJJxPi1SvUO4TFpk2grp2oh1mgoY76eCjx25hnztvi+
         jeN+y263KDHZKKMK3tiwdKVFNPWcMT9h3rbW373XNfbt4Iu9At0p5+KaQXPMz0viXC14
         EsdwkUY8z3M4ZyNJDopGtfrriPTF9XtSULalDpN6zPGuKHO0aEkzywGjEKQuU0HZlKB0
         S42g==
X-Gm-Message-State: ACgBeo2zU8+8ajKmxLREb9lDqx979r4D+2fURG3JysKcjsJLZtX9qSrK
        92CYS2rrCceXjhLpDaFCY8o5gg==
X-Google-Smtp-Source: AA6agR60ruOjF9mnAPPgGOUWvaJkztxX2/z8cghwrKPSMu8fHHJNxJpysVKsIwQoLxDKbSeGgSDTAA==
X-Received: by 2002:a17:90b:3e89:b0:1f0:4233:b20e with SMTP id rj9-20020a17090b3e8900b001f04233b20emr2012452pjb.0.1659066632918;
        Thu, 28 Jul 2022 20:50:32 -0700 (PDT)
Received: from [192.168.10.153] (203-7-124-83.dyn.iinet.net.au. [203.7.124.83])
        by smtp.gmail.com with ESMTPSA id o124-20020a625a82000000b005289fbef7c4sm1638163pfb.140.2022.07.28.20.50.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 20:50:32 -0700 (PDT)
Message-ID: <78db23aa-ff77-478e-efaa-058fe08765d9@ozlabs.ru>
Date:   Fri, 29 Jul 2022 13:50:24 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101
 Thunderbird/103.0
Subject: Re: [PATCH kernel] powerpc/iommu: Add iommu_ops to report
 capabilities and allow blocking domains
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Oliver O'Halloran <oohall@gmail.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rodel, Jorg" <jroedel@suse.de>, Joel Stanley <joel@jms.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
References: <20220707135552.3688927-1-aik@ozlabs.ru>
 <20220707151002.GB1705032@nvidia.com>
 <bb8f4c93-6cbc-0106-d4c1-1f3c0751fbba@ozlabs.ru>
 <bbe29694-66a3-275b-5a79-71237ad7388f@ozlabs.ru>
 <BN9PR11MB527690152FE449D26576D2FE8C829@BN9PR11MB5276.namprd11.prod.outlook.com>
 <300aa0fe-31c5-4ed2-d0a2-597c2c305f91@ozlabs.ru>
 <CAOSf1CHxkSxGXopT=9i3N9xUmj0=13J1V_M=or23ZamucXyu7w@mail.gmail.com>
 <BN9PR11MB527626B389A0F7A4AB19B6728C999@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <BN9PR11MB527626B389A0F7A4AB19B6728C999@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 29/07/2022 13:10, Tian, Kevin wrote:
>> From: Oliver O'Halloran <oohall@gmail.com>
>> Sent: Friday, July 29, 2022 10:53 AM
>>
>> On Fri, Jul 29, 2022 at 12:21 PM Alexey Kardashevskiy <aik@ozlabs.ru> wrote:
>>>
>>> *snip*
>>>
>>> About this. If a platform has a concept of explicit DMA windows (2 or
>>> more), is it one domain with 2 windows or 2 domains with one window
>> each?
>>>
>>> If it is 2 windows, iommu_domain_ops misses windows manipulation
>>> callbacks (I vaguely remember it being there for embedded PPC64 but
>>> cannot find it quickly).
>>>
>>> If it is 1 window per a domain, then can a device be attached to 2
>>> domains at least in theory (I suspect not)?
>>>
>>> On server POWER CPUs, each DMA window is backed by an independent
>> IOMMU
>>> page table. (reminder) A window is a bus address range where devices are
>>> allowed to DMA to/from ;)
>>
>> I've always thought of windows as being entries to a top-level "iommu
>> page table" for the device / domain. The fact each window is backed by
>> a separate IOMMU page table shouldn't really be relevant outside the
>> arch/platform.
> 
> Yes. This is what was agreed when discussing how to integrate iommufd
> with POWER [1].
> 
> One domain represents one address space.
> 
> Windows are just constraints on the address space for what ranges can
> be mapped.
> 
> having two page tables underlying is just kind of POWER specific format.


It is a POWER specific thing with one not-so-obvious consequence of each 
window having an independent page size (fixed at the moment or creation) 
and (most likely) different page size, like, 4K vs. 2M.


> 
> Thanks
> Kevin
> 
> [1] https://lore.kernel.org/all/Yns+TCSa6hWbU7wZ@yekko/

-- 
Alexey
