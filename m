Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B00AED7D
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 16:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393498AbfIJOnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 10:43:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393490AbfIJOnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 10:43:01 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 13288C087353
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 14:43:01 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id b15so9092415wrp.21
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 07:43:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g5eX5iweKwpOy+eqaEJiHTiSPYwyjs0qXEWixSsDraA=;
        b=W3jvsvnd4XHmtqDqx1Anf9CRubFBk1PJfvVAL02K2Tkk5joCPNdow1PUFkXVY/QDG8
         QdrINNMsuQONl3OFnHkWgnQkOaEyBFE/HCvRLVXN1c0gxH8w83903p1BhbMqL0vMNd0w
         zZhFi+F5XDWXU8PwmCzc2rgTyrccMUYXlHIPZBLxYdlpSQE9AZojnHLF0/l9jkz3uqc7
         dvYUgsIzyJ1FnT7D3EnewsIuqKYJF8PWqYgzPWCvnsOq9GIgF+/jdmwqD554PjuL/Zwz
         QICn1GNjB7RT6JLn1sgyxBxglwb5OpSmBsZwaE7G6Wm46hrz1snlFfmyqAQ8xq32aUP6
         YHdg==
X-Gm-Message-State: APjAAAVqSchZ8q8LWYYVwCz66UhXKricDYceXKk7uNsMEG7NWLJTZuUW
        sisgzIIzU3OI3Laa0ZiARBwLhmXJVkeFdw4ukoUrG1PZ1mzrbvly9P9cYqYq9FsnOggnmrL8IxH
        i5CHcxTMG7YB0
X-Received: by 2002:adf:ee4a:: with SMTP id w10mr26511470wro.138.1568126579742;
        Tue, 10 Sep 2019 07:42:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzsECAYjVh0ThWzJsHPAzjtOv5V4wtRrLNgqPWTpp1Frhut3SvXecGYRunp/wYsYpbLV62Czg==
X-Received: by 2002:adf:ee4a:: with SMTP id w10mr26511445wro.138.1568126579485;
        Tue, 10 Sep 2019 07:42:59 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a6sm9434153wrr.85.2019.09.10.07.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2019 07:42:59 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] Makefile: do not pass non-c++ warning
 options to g++
To:     Haozhong Zhang <hzzhan9@gmail.com>, rkrcmar@redhat.com
Cc:     kvm@vger.kernel.org, Haozhong Zhang <hzhongzhang@tencent.com>
References: <20190909232823.24513-1-hzzhan9@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <34910bc4-c713-07bd-79b4-48a5f23639ba@redhat.com>
Date:   Tue, 10 Sep 2019 16:42:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190909232823.24513-1-hzzhan9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/09/19 01:28, Haozhong Zhang wrote:
> From: Haozhong Zhang <hzhongzhang@tencent.com>
> 
> -Wmissing-prototypes and -Wstrict-prototypes are C and Obj-C only
> warning options. If passing them to g++ (e.g., when compiling api/),
> following warning messages will be produced:
>   cc1plus: warning: command line option ‘-Wmissing-prototypes’ is valid for C/ObjC but not for C++[enabled by default]
>   cc1plus: warning: command line option ‘-Wstrict-prototypes’ is valid for C/ObjC but not for C++ [enabled by default]
> 
> Move those options from COMMON_CFLAGS to CFLAGS so as to mute above
> warning messages.
> 
> Signed-off-by: Haozhong Zhang <hzhongzhang@tencent.com>
> ---
>  Makefile | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 643af05..32414dc 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,4 +1,3 @@
> -
>  SHELL := /usr/bin/env bash
>  
>  ifeq ($(wildcard config.mak),)
> @@ -53,7 +52,6 @@ cc-option = $(shell if $(CC) $(1) -S -o /dev/null -xc /dev/null \
>  COMMON_CFLAGS += -g $(autodepend-flags)
>  COMMON_CFLAGS += -Wall -Wwrite-strings -Wclobbered -Wempty-body -Wuninitialized
>  COMMON_CFLAGS += -Wignored-qualifiers -Wunused-but-set-parameter
> -COMMON_CFLAGS += -Wmissing-prototypes -Wstrict-prototypes
>  COMMON_CFLAGS += -Werror
>  frame-pointer-flag=-f$(if $(KEEP_FRAME_POINTER),no-,)omit-frame-pointer
>  fomit_frame_pointer := $(call cc-option, $(frame-pointer-flag), "")
> @@ -71,6 +69,7 @@ COMMON_CFLAGS += $(fno_pic) $(no_pie)
>  
>  CFLAGS += $(COMMON_CFLAGS)
>  CFLAGS += -Wmissing-parameter-type -Wold-style-declaration -Woverride-init
> +CFLAGS += -Wmissing-prototypes -Wstrict-prototypes
>  
>  CXXFLAGS += $(COMMON_CFLAGS)
>  
> 

Queued, thanks.

Paolo
