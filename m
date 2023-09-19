Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D271A7A6683
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 16:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbjISOW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 10:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbjISOW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 10:22:58 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0570AD;
        Tue, 19 Sep 2023 07:22:52 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-313e742a787so3775866f8f.1;
        Tue, 19 Sep 2023 07:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695133371; x=1695738171; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i3FMlhPXh7cv8FtN2gEXUrO+RhACXKU/mUpIqycicmg=;
        b=d7DbMlQaFxJDPS/mvu7B3WIpbtY+PFpML668CNc1z4aQAFXqCkxJVdQhA2W9cZL0zL
         sHS2/9uQ9NbuEbglxYJ40abbfABksf5k71AlHFcgbIhGY4d3oFNud15/ddmrfUxVXTH5
         j9p+1IQfOS3odyyUTjbZM3DFyFbfr8H2HUWhM90/7Um6DcdpS6RfBB/7bk73cvNCeehD
         HanMezozhCLT4b0YXE/jgIdCFgeiA6iOef3dZ5PNtK4PzHGeOMaOtru4CMcTXJPBkWBp
         A6zlRNGCNBcqc/Wpt581eSv1WSovX3gG0RAvUjsCAqNd11PQ95Bk+5xUK/Yj9WvFkRRF
         +WQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695133371; x=1695738171;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i3FMlhPXh7cv8FtN2gEXUrO+RhACXKU/mUpIqycicmg=;
        b=Ny+GOYvs57UKxTz5Bg8uIOuJcYS6/NEB7oNj+R7elajaS7ES9Qg+IpwbkAw4pk/Sqx
         5/9knPV/JR74GoLIM13N/4Pgq5VcSr2Cb5C3UiZS3sJfLvY6j3BLz/QCrBAA3nSxbLWA
         oor6l0U/+tvyoJZfT732rPm6o4HmhUgJqFf4K2L/7RDdqTlGo11nMNAKaYn5HJFPA5jG
         2jsyk0ztvJDjp01FAfLDAlIHg51gtR1G1Q0cW6hO6mFgORVGMZQHQQDHpUQSyDmX1TQU
         uxHOH1FdorwN4isGlxmJWWp3QCB3EWxn/dl6crO+UciBEEjOp3IeLUfBH9vDCCcNdoVW
         DnPA==
X-Gm-Message-State: AOJu0YwL/GJb4cdtVglKiSJovKJvhq2dgtaBvclp1BAFXYQBdtKxv7Jy
        nEgkIGmRKAyaeLm0Heo9j+Xql1omGFT+BA==
X-Google-Smtp-Source: AGHT+IEG4fvlRxvzAjfzXxcDfGFG/mxWWxraaUg4bVCChSoIJJR55fMqk2Gzk41SVSqOGCTZt3EGHQ==
X-Received: by 2002:a5d:64a9:0:b0:31f:ffe3:b957 with SMTP id m9-20020a5d64a9000000b0031fffe3b957mr2478459wrp.31.1695133370817;
        Tue, 19 Sep 2023 07:22:50 -0700 (PDT)
Received: from [192.168.4.177] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id v15-20020adff68f000000b0031433443265sm15740484wrp.53.2023.09.19.07.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Sep 2023 07:22:50 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <7fd349af-6a98-08cf-864f-7116d32c0400@xen.org>
Date:   Tue, 19 Sep 2023 15:22:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Reply-To: paul@xen.org
Subject: Re: [PATCH v4 05/13] KVM: pfncache: allow a cache to be activated
 with a fixed (userspace) HVA
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230919134149.6091-1-paul@xen.org>
 <20230919134149.6091-6-paul@xen.org>
 <fbe316fa112c5aafaee249d20503209feadbf2fa.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <fbe316fa112c5aafaee249d20503209feadbf2fa.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/09/2023 15:20, David Woodhouse wrote:
> On Tue, 2023-09-19 at 13:41 +0000, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> Some cached pages may actually be overlays on guest memory that have a
>> fixed HVA within the VMM. It's pointless to invalidate such cached
>> mappings if the overlay is moved so allow a cache to be activated directly
>> with the HVA to cater for such cases. A subsequent patch will make use
>> of this facility.
>>
>> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> 
> I think I gave you one of these in a previous round, but
> 
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> 

Yes. Apologies. You gave it on v2; I definitely have it now.

   Paul

