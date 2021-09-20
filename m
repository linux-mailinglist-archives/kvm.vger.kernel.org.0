Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025BD4115B2
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 15:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbhITN3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 09:29:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239611AbhITN2o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 09:28:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632144437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UlNLB2XwAsCwJ5HPC9PriUVMfGYRDh6fwBCOdRoog7o=;
        b=E44PlaRRrM80mve7ZNgLDM94btJwkTuPoJAGYVi+CJnmhfSe9hpzseGTr9Om99cXHcuv8e
        bYsRdCy23Frxx5PrLb3IDYAeNEUBKgY/0aagd7ee/Qq9W9wDgGoJVGcdxguThyrgETothE
        Il4C6AqS7XGiXl8HD9XqFu7zFs7O4qo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-nvJ7CFsaNxOnJj8R8kc7_Q-1; Mon, 20 Sep 2021 09:27:16 -0400
X-MC-Unique: nvJ7CFsaNxOnJj8R8kc7_Q-1
Received: by mail-ed1-f71.google.com with SMTP id n5-20020a05640206c500b003cf53f7cef2so12897119edy.12
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 06:27:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UlNLB2XwAsCwJ5HPC9PriUVMfGYRDh6fwBCOdRoog7o=;
        b=5ye6M0+3yT45/e27CQRa1pHxFw8Azs6bHmqr3596IG6MigP/hHfVZMjX3a20IT72oa
         JpFRfizSidB9ZeSun8AW7Lb/uCgcZWSKZ/PORM0NXKt4m/M7JyN09tX94PkopPm/5u3i
         P0kadXchX29TESTGoffAAMv7pDyMbAEJTq1LBnoQC5p568KM0R4WAr2di9UkWO2YDpnY
         Oddy8j8ZUi94X4qO8kaikK0oKN4JeLudPXd+d7lCU/XNuxm8h3w2jLMawAb0oztpxXoz
         7TUwtlgBR99fzJPhdXxF2fmQh2W/6Q2ypm787udYdIJh7lG9sFYWG5BjYdHhQvQq0LbX
         gu0g==
X-Gm-Message-State: AOAM532OagzqVHXn+Hidwgny2l/518kVGnThNaFaYAVXzMeX6riVeOaT
        3o3EexPJVvRStnREdr1cJt5K0en8tNxzY7rO1lhR/jBAWSnUKUX7gJ8FeOLFPwMrvw5KoNJvScR
        u0yz9WuR2g57/
X-Received: by 2002:a17:906:dc0d:: with SMTP id yy13mr478717ejb.88.1632144435215;
        Mon, 20 Sep 2021 06:27:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzH2E4Lg6Bz3gOLzOGbDH9QTxMBUMGC5CNDBMOtKsKlCVenqe/9YTcIWvzaWb5aQzLyO0Fsw==
X-Received: by 2002:a17:906:dc0d:: with SMTP id yy13mr478704ejb.88.1632144435035;
        Mon, 20 Sep 2021 06:27:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k4sm6896864edq.92.2021.09.20.06.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 06:27:14 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/2] Makefile: Fix cscope
To:     Andrew Jones <drjones@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1629908421-8543-1-git-send-email-pmorel@linux.ibm.com>
 <1629908421-8543-2-git-send-email-pmorel@linux.ibm.com>
 <1dd4c64e-3866-98c9-8178-dbff90dca55f@redhat.com>
 <2aaffea2-0a20-1a6d-eebb-69b6cfe6e83c@linux.ibm.com>
 <20210827102204.3y6gdpchn77cz7yo@gator.home>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <327ff7e0-82d8-a12d-7565-e476b1dbcca8@redhat.com>
Date:   Mon, 20 Sep 2021 15:27:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210827102204.3y6gdpchn77cz7yo@gator.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/21 12:22, Andrew Jones wrote:
>> 51b8f0b1 2017-11-23 Andrew Jones Makefile: fix cscope target
> No surprise there, that's when the $(PWD) use was first introduced.
> 
>> So I add Andrew as CC, I did forgot to do before.
>>
> I'll send a patch changing $(PWD) to $(shell pwd)

I could not find the patch using $(CURDIR) in my mailbox, though I found
it on spinics.net.  I fudged the following

 From 164507376abae4be15b0f65aa14d56f179198a99 Mon Sep 17 00:00:00 2001
From: Andrew Jones <drjones@redhat.com>
Date: Fri, 27 Aug 2021 12:31:15 +0200
Subject: [PATCH kvm-unit-tests] Makefile: Don't trust PWD

It's possible that PWD is already set to something which isn't
the full path of the current working directory. Let's use $(CURDIR)
instead, which is always correct.

Suggested-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/Makefile b/Makefile
index f7b9f28..6792b93 100644
--- a/Makefile
+++ b/Makefile
@@ -119,7 +119,7 @@ cscope: cscope_dirs = lib lib/libfdt lib/linux $(TEST_DIR) $(ARCH_LIBDIRS) lib/a
  cscope:
  	$(RM) ./cscope.*
  	find -L $(cscope_dirs) -maxdepth 1 \
-		-name '*.[chsS]' -exec realpath --relative-base=$(PWD) {} \; | sort -u > ./cscope.files
+		-name '*.[chsS]' -exec realpath --relative-base=$(CURDIR) {} \; | sort -u > ./cscope.files
  	cscope -bk
  
  .PHONY: tags

and queued it.

Paolo

