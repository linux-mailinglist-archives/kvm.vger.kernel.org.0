Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46D2757367
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 07:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjGRFu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 01:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjGRFu0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 01:50:26 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BF5E55;
        Mon, 17 Jul 2023 22:50:24 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b89114266dso42617675ad.0;
        Mon, 17 Jul 2023 22:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689659424; x=1692251424;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gga9IzaJCX3VSwGofmNS+NNP6GAiPOUQ3G8Z12KqV+w=;
        b=S8Smn9fJOljvaaVmEISGQfSKJ4dZL5LIWPTTiZg1DuhVf+1V912GvyFw/XuUVJOc9R
         M1fSlhP/wxDBLahScFNn/b+tSq2JRuUPDRdf7Rx2mrfl+d/paNUTVKLrSav7ggXBL1Uy
         /kt0r4Q3y8BC5m82raWtOaHMootriX4N749vjwj2uQ7RKs34I/u0hq39Iiwbhrzma5NJ
         v1W3fX0svObu3oryimKWpecNu9dbwnv39aJ1aklFn6gfBo3hE9azTwx28emGPUp4hO1V
         91bc3Bo2n1xLVm9t4WhgraDxfygCKpGFYCdogoxG0EYoMfr751lgmyJk+Kaz13zk6Cbe
         1yVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689659424; x=1692251424;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gga9IzaJCX3VSwGofmNS+NNP6GAiPOUQ3G8Z12KqV+w=;
        b=Smuparp8B3pxDNW88od8xHRcvtfqgsHvXe031uEcsz8mErOCMhzRgQJGkPjx569zwJ
         Pj88Tw1xipmqqqPVBmrqJUcRVnUGHkZChNzSvkgQYhd2lKJIbWTczXUYmY+p4GnJIqGK
         733P2UlMUQWT5uiJ6dUK8t6eJSRS25gF8JheCF+ktNHPoTp0jVaiFXUchx0e+unE7opn
         sGOtac274bW/RAaUb1zHzhTH8ujnRFkC8KaoXEDgNJyKj6ogIu0H8uNY//5B/kKNLKFi
         hg+riZJL4kftQwFdaOz39D0KXRE3oA3HdksydupAcj0dI0I5oskewfJ4LVrTlzBdxB+6
         ntug==
X-Gm-Message-State: ABy/qLb6vR0N5fgZX/doL/LDW5hckhV99LmF5+/8RFO5OYuwQRQmPtyw
        qH/7Hk8nFPSauPmoKQ69kcE=
X-Google-Smtp-Source: APBJJlGDklalLU/jpOzk9HrL7DjNmsurU4Ks+fW9fRuI1cFSPNs3NyB+6/aasRpcLZCBqtae3jheHA==
X-Received: by 2002:a17:903:2581:b0:1b9:d961:69b7 with SMTP id jb1-20020a170903258100b001b9d96169b7mr13452653plb.10.1689659424421;
        Mon, 17 Jul 2023 22:50:24 -0700 (PDT)
Received: from ?IPV6:2601:1c2:980:9ec0::2764? ([2601:1c2:980:9ec0::2764])
        by smtp.gmail.com with ESMTPSA id l8-20020a170902f68800b001b80de83b10sm823737plg.301.2023.07.17.22.50.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 22:50:24 -0700 (PDT)
Message-ID: <aa7d96d5-bbd9-0a37-f43b-5c8c62d9a9dc@gmail.com>
Date:   Mon, 17 Jul 2023 22:50:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
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
From:   Randy Dunlap <rd.dunlab@gmail.com>
In-Reply-To: <20230718045550.495428-1-costa.shul@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/17/23 21:55, Costa Shulyupin wrote:
> and fix all in-tree references.
> 
> Architecture-specific documentation is being moved into Documentation/arch/
> as a way of cleaning up the top-level documentation directory and making
> the docs hierarchy more closely match the source hierarchy.
> 
> Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  Documentation/admin-guide/kernel-parameters.txt   | 4 ++--
>  Documentation/arch/index.rst                      | 2 +-
>  Documentation/{ => arch}/s390/3270.ChangeLog      | 0
>  Documentation/{ => arch}/s390/3270.rst            | 4 ++--
>  Documentation/{ => arch}/s390/cds.rst             | 2 +-
>  Documentation/{ => arch}/s390/common_io.rst       | 2 +-
>  Documentation/{ => arch}/s390/config3270.sh       | 0
>  Documentation/{ => arch}/s390/driver-model.rst    | 0
>  Documentation/{ => arch}/s390/features.rst        | 0
>  Documentation/{ => arch}/s390/index.rst           | 0
>  Documentation/{ => arch}/s390/monreader.rst       | 0
>  Documentation/{ => arch}/s390/pci.rst             | 2 +-
>  Documentation/{ => arch}/s390/qeth.rst            | 0
>  Documentation/{ => arch}/s390/s390dbf.rst         | 0
>  Documentation/{ => arch}/s390/text_files.rst      | 0
>  Documentation/{ => arch}/s390/vfio-ap-locking.rst | 0
>  Documentation/{ => arch}/s390/vfio-ap.rst         | 0
>  Documentation/{ => arch}/s390/vfio-ccw.rst        | 2 +-
>  Documentation/{ => arch}/s390/zfcpdump.rst        | 0
>  Documentation/driver-api/s390-drivers.rst         | 4 ++--
>  MAINTAINERS                                       | 8 ++++----
>  arch/s390/Kconfig                                 | 4 ++--
>  arch/s390/include/asm/debug.h                     | 4 ++--
>  drivers/s390/char/zcore.c                         | 2 +-
>  kernel/Kconfig.kexec                              | 2 +-
>  25 files changed, 21 insertions(+), 21 deletions(-)
>  rename Documentation/{ => arch}/s390/3270.ChangeLog (100%)
>  rename Documentation/{ => arch}/s390/3270.rst (99%)
>  rename Documentation/{ => arch}/s390/cds.rst (99%)
>  rename Documentation/{ => arch}/s390/common_io.rst (98%)
>  rename Documentation/{ => arch}/s390/config3270.sh (100%)
>  rename Documentation/{ => arch}/s390/driver-model.rst (100%)
>  rename Documentation/{ => arch}/s390/features.rst (100%)
>  rename Documentation/{ => arch}/s390/index.rst (100%)
>  rename Documentation/{ => arch}/s390/monreader.rst (100%)
>  rename Documentation/{ => arch}/s390/pci.rst (99%)
>  rename Documentation/{ => arch}/s390/qeth.rst (100%)
>  rename Documentation/{ => arch}/s390/s390dbf.rst (100%)
>  rename Documentation/{ => arch}/s390/text_files.rst (100%)
>  rename Documentation/{ => arch}/s390/vfio-ap-locking.rst (100%)
>  rename Documentation/{ => arch}/s390/vfio-ap.rst (100%)
>  rename Documentation/{ => arch}/s390/vfio-ccw.rst (99%)
>  rename Documentation/{ => arch}/s390/zfcpdump.rst (100%)
> 

> diff --git a/Documentation/s390/3270.ChangeLog b/Documentation/arch/s390/3270.ChangeLog
> similarity index 100%
> rename from Documentation/s390/3270.ChangeLog
> rename to Documentation/arch/s390/3270.ChangeLog
> diff --git a/Documentation/s390/3270.rst b/Documentation/arch/s390/3270.rst
> similarity index 99%
> rename from Documentation/s390/3270.rst
> rename to Documentation/arch/s390/3270.rst

> diff --git a/Documentation/s390/cds.rst b/Documentation/arch/s390/cds.rst
> similarity index 99%
> rename from Documentation/s390/cds.rst
> rename to Documentation/arch/s390/cds.rst

> diff --git a/Documentation/s390/common_io.rst b/Documentation/arch/s390/common_io.rst
> similarity index 98%
> rename from Documentation/s390/common_io.rst
> rename to Documentation/arch/s390/common_io.rst

> diff --git a/Documentation/s390/config3270.sh b/Documentation/arch/s390/config3270.sh
> similarity index 100%
> rename from Documentation/s390/config3270.sh
> rename to Documentation/arch/s390/config3270.sh
> diff --git a/Documentation/s390/driver-model.rst b/Documentation/arch/s390/driver-model.rst
> similarity index 100%
> rename from Documentation/s390/driver-model.rst
> rename to Documentation/arch/s390/driver-model.rst
> diff --git a/Documentation/s390/features.rst b/Documentation/arch/s390/features.rst
> similarity index 100%
> rename from Documentation/s390/features.rst
> rename to Documentation/arch/s390/features.rst
> diff --git a/Documentation/s390/index.rst b/Documentation/arch/s390/index.rst
> similarity index 100%
> rename from Documentation/s390/index.rst
> rename to Documentation/arch/s390/index.rst
> diff --git a/Documentation/s390/monreader.rst b/Documentation/arch/s390/monreader.rst
> similarity index 100%
> rename from Documentation/s390/monreader.rst
> rename to Documentation/arch/s390/monreader.rst
> diff --git a/Documentation/s390/pci.rst b/Documentation/arch/s390/pci.rst
> similarity index 99%
> rename from Documentation/s390/pci.rst
> rename to Documentation/arch/s390/pci.rst

> diff --git a/Documentation/s390/qeth.rst b/Documentation/arch/s390/qeth.rst
> similarity index 100%
> rename from Documentation/s390/qeth.rst
> rename to Documentation/arch/s390/qeth.rst
> diff --git a/Documentation/s390/s390dbf.rst b/Documentation/arch/s390/s390dbf.rst
> similarity index 100%
> rename from Documentation/s390/s390dbf.rst
> rename to Documentation/arch/s390/s390dbf.rst
> diff --git a/Documentation/s390/text_files.rst b/Documentation/arch/s390/text_files.rst
> similarity index 100%
> rename from Documentation/s390/text_files.rst
> rename to Documentation/arch/s390/text_files.rst
> diff --git a/Documentation/s390/vfio-ap-locking.rst b/Documentation/arch/s390/vfio-ap-locking.rst
> similarity index 100%
> rename from Documentation/s390/vfio-ap-locking.rst
> rename to Documentation/arch/s390/vfio-ap-locking.rst
> diff --git a/Documentation/s390/vfio-ap.rst b/Documentation/arch/s390/vfio-ap.rst
> similarity index 100%
> rename from Documentation/s390/vfio-ap.rst
> rename to Documentation/arch/s390/vfio-ap.rst
> diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/arch/s390/vfio-ccw.rst
> similarity index 99%
> rename from Documentation/s390/vfio-ccw.rst
> rename to Documentation/arch/s390/vfio-ccw.rst


-- 
~Randy
