Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF1F276E78
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 12:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgIXKSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 06:18:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53171 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727393AbgIXKSM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 06:18:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600942690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1o//4K9KXtlvHkxAD66+1dAPFkneQrYFyZeqBXbHdy0=;
        b=cUgXkjrDugcV/E3di1XPss1wOuw+Mr6LCqM1OJRbZtwMDytefoQGhHYvROkI/Tv5R4wimb
        uRV1AVS51POQnoyk25SmuBJ+cXt4ENgHP8Bfh0deOHRlS7Jow4bVj3D/7elO5q2hTgRPp2
        48oSgzOw4bgXFy3Z7Vdo9s+yfNDCMBY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-NhOheTiRMhWAETtOpolEww-1; Thu, 24 Sep 2020 06:18:07 -0400
X-MC-Unique: NhOheTiRMhWAETtOpolEww-1
Received: by mail-wr1-f70.google.com with SMTP id v12so1049729wrm.9
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 03:18:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1o//4K9KXtlvHkxAD66+1dAPFkneQrYFyZeqBXbHdy0=;
        b=qhk3p0k4hOj04WT3kGi8jYaiqnWNjQxJ31fOf/emoZoCPznHcAQGSmybwZgHX5m4wU
         Th4em+s2J49cQlkOJo1cZ2M/PZCqKgFh172XVwMz/Or+/FhdtUJ7M/NnwxTn/mkA9Q/w
         K4yTIfLlXyxGHr6y1+oiaNuz8BxM6o2cIScQIDAEZb568b86pRFU6Q99jJmhgnAtthiz
         kNwqWOECUpY1Oks2tFnO7uHmfCQO4kXbkp6hsCIoa2Uk6TBPGDiMCaKeMhlBgl6a2kAp
         cAScrwJ7lQI6frGRsrIhtmmn0SvVGveCTvyWvLKtM820TdgZDINQH52QkA9mGAH7k2Mv
         AArQ==
X-Gm-Message-State: AOAM530sHD+fAPMNLXQiLLlh8wnI5y9+xyGdVZo9cpH0674AyR0EwhwK
        V44OHcMjQEgoydpUjbLq5PNPoRgFypVS0pH/2osgG9YCCv9xBW6wz5dvF5z0ZXSMmiYYe7CZJj5
        FRvn9p074LTCz
X-Received: by 2002:a05:6000:12c3:: with SMTP id l3mr4590722wrx.164.1600942686059;
        Thu, 24 Sep 2020 03:18:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwI6aD3xiDyYmQMmhbcN0WKnzbT9TMZbW8C1QeAuf5ewRGSPjo2NqDURzQO1j9h6FLG4BuodQ==
X-Received: by 2002:a05:6000:12c3:: with SMTP id l3mr4590697wrx.164.1600942685834;
        Thu, 24 Sep 2020 03:18:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d80e:a78:c27b:93ed? ([2001:b07:6468:f312:d80e:a78:c27b:93ed])
        by smtp.gmail.com with ESMTPSA id f23sm13883377wmc.3.2020.09.24.03.18.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 03:18:05 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] README: Reflect missing --getopt in
 configure
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>
References: <20200924100613.71136-1-r.bolshakov@yadro.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <43d1571b-8cf6-3304-b4df-650a65528843@redhat.com>
Date:   Thu, 24 Sep 2020 12:18:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200924100613.71136-1-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/20 12:06, Roman Bolshakov wrote:
> 83760814f637 ("configure: Check for new-enough getopt") has replaced
> proposed patch and doesn't introduce --getopt option in configure.
> Instead, `configure` and `run_tests.sh` expect proper getopt to be
> available in PATH.

Is this because getopt is "keg only"?  I thought you could just add
`brew --prefix`/bin to the path.  You can also do "brew link" if there
are no backwards-compatibility issues.

Paolo

> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  README.macOS.md | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/README.macOS.md b/README.macOS.md
> index 4ca5a57..62b00be 100644
> --- a/README.macOS.md
> +++ b/README.macOS.md
> @@ -22,10 +22,14 @@ $ brew install i686-elf-gcc
>  $ brew install x86_64-elf-gcc
>  ```
>  
> -32-bit x86 tests can be built like that:
> +Make enhanced getopt available in the current shell session:
> +```
> +export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
> +```
> +
> +Then, 32-bit x86 tests can be built like that:
>  ```
>  $ ./configure \
> -  --getopt=/usr/local/opt/gnu-getopt/bin/getopt \
>    --arch=i386 \
>    --cross-prefix=i686-elf-
>  $ make -j $(nproc)
> @@ -34,7 +38,6 @@ $ make -j $(nproc)
>  64-bit x86 tests can be built likewise:
>  ```
>  $ ./configure \
> -  --getopt=/usr/local/opt/gnu-getopt/bin/getopt \
>    --arch=x86_64 \
>    --cross-prefix=x86_64-elf-
>  $ make -j $(nproc)
> @@ -71,7 +74,6 @@ $ ct-ng -C $X_BUILD_DIR build CT_PREFIX=$X_INSTALL_DIR
>  Once compiled, the cross-compiler can be used to build the tests:
>  ```
>  $ ./configure \
> -  --getopt=/usr/local/opt/gnu-getopt/bin/getopt \
>    --arch=x86_64 \
>    --cross-prefix=$X_INSTALL_DIR/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-
>  $ make -j $(nproc)
> 

