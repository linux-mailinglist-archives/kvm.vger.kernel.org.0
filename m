Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9BA79153B
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352712AbjIDJz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235214AbjIDJzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:55:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3DCCC7
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 02:54:18 -0700 (PDT)
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-qRomlt3BP9a06-KTMDWZeQ-1; Mon, 04 Sep 2023 05:54:16 -0400
X-MC-Unique: qRomlt3BP9a06-KTMDWZeQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-401db0c9d3eso8600405e9.3
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 02:54:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693821255; x=1694426055;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uTvB95KyzDb1YHMdthNLhzgghnoayFFEqz5D/WvthFE=;
        b=DxqZX9Whu595oytmPjj1paNHOnvCRXmgDh+j8PasXt9StNR6A74PkEnTergeYAylnk
         Liilpte9RfbZz/CmC+PKmza4EJcXM8seVGulmEk4TPI+QgZeLjNqpS8RpHwXnEii0/Ek
         29xikVtpvVZh4raRGclTQx+9wnm1pi2FejYAhn/66fMvAqIokUnyxoD2kmpKjXe9HwCV
         DzoMNqaMhkgFMnCxXcrEBgzLinVFX0phDzPZBeHU3sXH5E9KKz/P35ADEVNX03PhP0PL
         4iW87z0brtQUSp+qg0lHjgl6+WIQTpZnSZ+OGTRTXN3CEKzvIB6XlN2D/MO3MMheiHrD
         pOQw==
X-Gm-Message-State: AOJu0YySyiYKkPNAqa4WfncOq0NrqJrw/zcOHLXc46UC+zdbZF43ZmBB
        GkCy2RKk5KyjXtkx6y7L6KqHHJs9aj7xn1f7Gs+KZH31B/H6t/XVoELnfuRpnxfp/Cs2FIgTNf0
        VdN35/DBviSmJ
X-Received: by 2002:a05:600c:446:b0:401:c52c:5ed9 with SMTP id s6-20020a05600c044600b00401c52c5ed9mr7189480wmb.32.1693821255443;
        Mon, 04 Sep 2023 02:54:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFI10YPPteFQXl1Pb89NCBFyOvAvoSR+teTCFaysuJFUUiOp7xeh0z9/8Eei9B2E8yp9v3jyQ==
X-Received: by 2002:a05:600c:446:b0:401:c52c:5ed9 with SMTP id s6-20020a05600c044600b00401c52c5ed9mr7189466wmb.32.1693821255096;
        Mon, 04 Sep 2023 02:54:15 -0700 (PDT)
Received: from [10.33.192.199] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id m18-20020a7bce12000000b00401dc20a070sm16566936wmc.43.2023.09.04.02.54.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Sep 2023 02:54:14 -0700 (PDT)
Message-ID: <74a7684b-0c11-37b3-4313-9241a3f975cc@redhat.com>
Date:   Mon, 4 Sep 2023 11:54:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [kvm-unit-tests PATCH v6 2/8] s390x: add function to set DAT mode
 for all interrupts
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230904082318.1465055-1-nrb@linux.ibm.com>
 <20230904082318.1465055-3-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230904082318.1465055-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/09/2023 10.22, Nico Boehr wrote:
> When toggling DAT or switch address space modes, it is likely that
> interrupts should be handled in the same DAT or address space mode.
> 
> Add a function which toggles DAT and address space mode for all
> interruptions, except restart interrupts.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h  | 10 ++++++----
>   lib/s390x/asm/interrupt.h |  2 ++
>   lib/s390x/interrupt.c     | 35 +++++++++++++++++++++++++++++++++++
>   lib/s390x/mmu.c           |  5 +++--
>   4 files changed, 46 insertions(+), 6 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

