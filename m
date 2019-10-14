Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C91CD60E1
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 13:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731723AbfJNLEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 07:04:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52726 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731686AbfJNLEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 07:04:44 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A4C4B4E908
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 11:04:43 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id r187so6014517wme.0
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 04:04:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NBIhzwFtIahXPEyulKTMfAVXwty40qS02FIJNaibIzc=;
        b=jHT87YW8gxsbqgjv4yWRqycwvhNTddAQnrIHQIjH5Oo3Nq87Q4zXvQtUS8Bx/A0nzh
         JEOv5W+Co2MNb5SZmQclR3/UH/2ysAAOIbW9nHGZIGX46l9sBGFeN+t/PNnIJ/oVO985
         HGd9hsIzgw/fm+AxI86aO7ihdSlxnSaNpM/fqStsUAtdmti4IBwMA/0wZjlKSjmfRDIW
         8JqvA3jGTMTO/vpijmzEPBkj9atcYCqGkGqenWXDUAkAwehYA+2Lzt16Z+Q9bkgBIy/9
         sXTguxJQkw5SraabSDQ7zTRf2Wy5c3RLZy65Hl7NWS4rBTmZMWL0HPgK9gSIn92Wo9Is
         wYJA==
X-Gm-Message-State: APjAAAVpidBk6D1rKIfJoiKphWa/hEvtRTTAQaXV2PxfxsR1v7OmkyeF
        tuvSLssqNlkO+FiqY6hxlc3WdMlBU0KI2b+nAm3nUa7PFqqPd0YIGeQQXwBxk94pzYk/5+JbBRt
        uUFZXrpjVMEMl
X-Received: by 2002:a05:600c:2185:: with SMTP id e5mr1843050wme.78.1571051082253;
        Mon, 14 Oct 2019 04:04:42 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxJ+Y7r465A1g1xbi8lTQm9LjfvAs84OW30L78PfgV0kCbXozAobF2aaxhtMPIAqI8gjh/X5A==
X-Received: by 2002:a05:600c:2185:: with SMTP id e5mr1843026wme.78.1571051081963;
        Mon, 14 Oct 2019 04:04:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id r6sm19989932wmh.38.2019.10.14.04.04.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2019 04:04:41 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] lib: use an argument which doesn't require
 default argument promotion
To:     Thomas Huth <thuth@redhat.com>, Bill Wendling <morbo@google.com>
Cc:     David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?THVrw6HFoSBEb2t0b3I=?= <ldoktor@redhat.com>,
        David Gibson <dgibson@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <CAGG=3QUL_OrjaWn+gF4z-R8brR2=3661hGk0uUAK2y8Dff7Mvg@mail.gmail.com>
 <986a6fc2-ef7b-4df4-8d4e-a4ab94238b32@redhat.com>
 <30edb4bd-535d-d29c-3f4e-592adfa41163@redhat.com>
 <7f7fa66f-9e6c-2e48-03b2-64ebca36df99@redhat.com>
 <CAGG=3QUdVBg5JArMaBcRbBLrHqLLCpAcrtvgT4q1h0V7SHbbEQ@mail.gmail.com>
 <df9c5f5d-c9ec-1a7b-1fec-67d1e7a5bbad@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4d591c3f-82aa-dd9e-efce-8b7d73b2f64f@redhat.com>
Date:   Mon, 14 Oct 2019 13:04:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <df9c5f5d-c9ec-1a7b-1fec-67d1e7a5bbad@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/19 09:57, Thomas Huth wrote:
> -void report(const char *msg_fmt, bool pass, ...)
> +void report(bool pass, const char *msg_fmt, ...)
>  {
>         va_list va;
> -       va_start(va, pass);
> +       va_start(va, msg_fmt);
>         va_report(msg_fmt, pass, false, false, va);
>         va_end(va);
>  }
> 
> -void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
> +void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
>  {
>         va_list va;
> -       va_start(va, pass);
> +       va_start(va, msg_fmt);
>         va_report(msg_fmt, pass, xfail, false, va);
>         va_end(va);
>  }
> 
> ... then we can keep the "bool" - but we have to fix all calling sites, too.
> 
> Paolo, any preferences?

Actually I had already pushed Bill's patch.  I also thought about
reordering the arguments, but it's a big change.  If someone wants to
try his hands at doing it with Coccinelle, I'm happy to apply it.

Paolo

