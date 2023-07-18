Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FA8757453
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 08:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjGRGhf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 02:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjGRGhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 02:37:34 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2162B13E
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 23:37:32 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-31590e4e27aso4787929f8f.1
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 23:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689662250; x=1692254250;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hIEy3rLqSCnnyzfWlfxqBHFoBDkclU5Mx6T9CUvcNwc=;
        b=s/o60ezihcuQS79qv7ICzuxOeNZHsBk1ocPusTvEmQhDfwlQYAlH6lPh29nT35oMc9
         kWXWdWzdLiBagWVLDkOEOAr70zBEOAjUXv21u0EyGSESqdi3AiRh++3nIfineVQLCNEY
         E/bkEgGZGvOk46nVkgRmbSaX0PyFWlG/CZ9VGRY5mwiuEauNXaWTEi06Lc78qV9zvDzZ
         BYl53vXNPjD8kI92rfQ3lPkVPqDZgRor8F4AQ4uCwNIQW0JaNk54qdUzR5tLtpChFZ+P
         HfkkOePjfuCFcKMACymgW2LAHCj8BLDOOXNNsV6CJQEaye0So+InIFaZMqABzrsjM3Kw
         /jUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689662250; x=1692254250;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hIEy3rLqSCnnyzfWlfxqBHFoBDkclU5Mx6T9CUvcNwc=;
        b=b6cXufD0cgJ3qSa3OdpbsLeKVgMtxkouib/17pMzv+94HnG93d1WjY2xxpx8LUOn4C
         NfOUu3+ZEO70R/9FYAon3zHUGWjIO953ScFAvINg5f73VrjIpO7FRd5O6nmqCUwsE2aT
         Ggeo/p/2hB1xbKr/wCAnOFa5U94tbeTwko1bRmECxDn8uPb4dQwyDBZqebqJVXhyoGO6
         i2x04FNFmkzdG8x9K7jKPNtVT9UgBeMyuujX1jDW71epJpJJ/Qrm28GXTPFaNmhm+G6x
         edHptOVRK7gsVC+wEFfT/lwKuYCYwtSKNKOTTrCgc2ZFlO4Xpp6OE9WoJb1+bR8EWqtv
         lSgw==
X-Gm-Message-State: ABy/qLb21/ybw88xB/P80zD9yEyEAtghC6NxIJRsS/SWJMiFfci/701v
        0yaoVzqM5JEoZlGTPnNd1PRPGg==
X-Google-Smtp-Source: APBJJlGdBiXVAKrEH3ChYvLgoNBQHQNzqNno1TY0mbR3+XKzm7LHTa/6LiEmaWdNIuj/vHzsGZ6jSQ==
X-Received: by 2002:adf:cd11:0:b0:316:e422:38e8 with SMTP id w17-20020adfcd11000000b00316e42238e8mr967530wrm.66.1689662250546;
        Mon, 17 Jul 2023 23:37:30 -0700 (PDT)
Received: from [192.168.69.115] ([176.187.222.251])
        by smtp.gmail.com with ESMTPSA id q7-20020adfea07000000b003140fff4f75sm1408059wrm.17.2023.07.17.23.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 23:37:30 -0700 (PDT)
Message-ID: <ed53e088-f538-3c5e-e870-e07998a09bb0@linaro.org>
Date:   Tue, 18 Jul 2023 08:37:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH] docs: move s390 under arch
Content-Language: en-US
To:     Costa Shulyupin <costa.shul@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vineet Gupta <vgupta@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Eric DeVolder <eric.devolder@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:S390 ARCHITECTURE" <linux-s390@vger.kernel.org>,
        "open list:S390 VFIO-CCW DRIVER" <kvm@vger.kernel.org>
References: <20230718045550.495428-1-costa.shul@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230718045550.495428-1-costa.shul@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/7/23 06:55, Costa Shulyupin wrote:
> and fix all in-tree references.
> 
> Architecture-specific documentation is being moved into Documentation/arch/
> as a way of cleaning up the top-level documentation directory and making
> the docs hierarchy more closely match the source hierarchy.
> 
> Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>
> ---
>   Documentation/admin-guide/kernel-parameters.txt   | 4 ++--
>   Documentation/arch/index.rst                      | 2 +-
>   Documentation/{ => arch}/s390/3270.ChangeLog      | 0
>   Documentation/{ => arch}/s390/3270.rst            | 4 ++--
>   Documentation/{ => arch}/s390/cds.rst             | 2 +-
>   Documentation/{ => arch}/s390/common_io.rst       | 2 +-
>   Documentation/{ => arch}/s390/config3270.sh       | 0
>   Documentation/{ => arch}/s390/driver-model.rst    | 0
>   Documentation/{ => arch}/s390/features.rst        | 0
>   Documentation/{ => arch}/s390/index.rst           | 0
>   Documentation/{ => arch}/s390/monreader.rst       | 0
>   Documentation/{ => arch}/s390/pci.rst             | 2 +-
>   Documentation/{ => arch}/s390/qeth.rst            | 0
>   Documentation/{ => arch}/s390/s390dbf.rst         | 0
>   Documentation/{ => arch}/s390/text_files.rst      | 0
>   Documentation/{ => arch}/s390/vfio-ap-locking.rst | 0
>   Documentation/{ => arch}/s390/vfio-ap.rst         | 0
>   Documentation/{ => arch}/s390/vfio-ccw.rst        | 2 +-
>   Documentation/{ => arch}/s390/zfcpdump.rst        | 0
>   Documentation/driver-api/s390-drivers.rst         | 4 ++--
>   MAINTAINERS                                       | 8 ++++----
>   arch/s390/Kconfig                                 | 4 ++--
>   arch/s390/include/asm/debug.h                     | 4 ++--
>   drivers/s390/char/zcore.c                         | 2 +-
>   kernel/Kconfig.kexec                              | 2 +-
>   25 files changed, 21 insertions(+), 21 deletions(-)
>   rename Documentation/{ => arch}/s390/3270.ChangeLog (100%)
>   rename Documentation/{ => arch}/s390/3270.rst (99%)
>   rename Documentation/{ => arch}/s390/cds.rst (99%)
>   rename Documentation/{ => arch}/s390/common_io.rst (98%)
>   rename Documentation/{ => arch}/s390/config3270.sh (100%)
>   rename Documentation/{ => arch}/s390/driver-model.rst (100%)
>   rename Documentation/{ => arch}/s390/features.rst (100%)
>   rename Documentation/{ => arch}/s390/index.rst (100%)
>   rename Documentation/{ => arch}/s390/monreader.rst (100%)
>   rename Documentation/{ => arch}/s390/pci.rst (99%)
>   rename Documentation/{ => arch}/s390/qeth.rst (100%)
>   rename Documentation/{ => arch}/s390/s390dbf.rst (100%)
>   rename Documentation/{ => arch}/s390/text_files.rst (100%)
>   rename Documentation/{ => arch}/s390/vfio-ap-locking.rst (100%)
>   rename Documentation/{ => arch}/s390/vfio-ap.rst (100%)
>   rename Documentation/{ => arch}/s390/vfio-ccw.rst (99%)
>   rename Documentation/{ => arch}/s390/zfcpdump.rst (100%)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

