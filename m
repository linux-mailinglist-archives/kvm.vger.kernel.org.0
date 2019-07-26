Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B55EA773EB
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 00:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbfGZWTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 18:19:30 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35255 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbfGZWTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 18:19:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id y4so55868864wrm.2
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2019 15:19:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YCzn2d3M/bK6nxASHNYCTBtvF1uCCsPTj9a0ROwZiV8=;
        b=E0uD49W2fWyivEY2fcbLiaNoltGgi3G3l6Rer9fpMHYXVC4kLW/mf1YUEv7cm8hx5W
         4K/Wk/CiBAMMPweWfCgAllMao7ia5qessSm/qnFIjtesDSZv0X5OUV/9F7JBqR3IeIGG
         8LKmyy1ji0HajDTBG0jv3YVEPXphN9Q2ixXhfP+xSpE60UDN9/QuvI+6mZ/6ZcJOSDnW
         7tp6b7geCGrmvuTFoSHFcAZQMKnjsXTkLtP189D02ZqD7tXN+9sjcEEpoRM5C5+t79Q0
         JsFkHJiJUoqFHQ1lZB8bL1YJl0iH8HguONONWe2ghbet4SKTbgzsxdS9MA/7ch1nd95O
         3w/Q==
X-Gm-Message-State: APjAAAUQwZGAdgMdqaCvYItS1UBBstp5GMUn4TEdVvFsj8HplR/O79vc
        6F2abQ1VIIUi1oRj7skKNpblqA==
X-Google-Smtp-Source: APXvYqyRRPKjQm+AekBeMu3q9YUsqv008iQETXfKvvUxhOEE27ABBNIeCAqBKvTheZhMUo1s0PuG/g==
X-Received: by 2002:a05:6000:187:: with SMTP id p7mr96507148wrx.189.1564179568428;
        Fri, 26 Jul 2019 15:19:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9036:7130:d6ec:a346? ([2001:b07:6468:f312:9036:7130:d6ec:a346])
        by smtp.gmail.com with ESMTPSA id i18sm72932769wrp.91.2019.07.26.15.19.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 15:19:27 -0700 (PDT)
Subject: Re: [PATCH 2/3] Documentation: kvm: Convert cpuid.txt to .rst
To:     Jonathan Corbet <corbet@lwn.net>,
        Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1562448500.git.lnowakow@eng.ucsd.edu>
 <e8cd24f40cdd23ed116679f4c3cfcf8849879bb4.1562448500.git.lnowakow@eng.ucsd.edu>
 <20190708140022.5fa9d01f@lwn.net> <20190708201510.GA13296@luke-XPS-13>
 <20190708142032.4fbd175e@lwn.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5a18d0c0-8bfa-c936-11e5-8238a89b5b5f@redhat.com>
Date:   Sat, 27 Jul 2019 00:19:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190708142032.4fbd175e@lwn.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/19 22:20, Jonathan Corbet wrote:
>>>> +:Author: Glauber Costa <glommer@redhat.com>, Red Hat Inc, 2010  
>>> I rather suspect that email address doesn't work these days.
>>>   
>> No I guess it wont :). We would still keep this correct? 
> There's nothing good that will come from keeping a broken email address
> there.  You could either:
> 
>  - Just take the address out, or

I agree with this, there have been more authors since 2010.

Regarding the license, it was my understanding that if somebody wants
anything but GPL-2.0 they should put it in the file when they create it.
 That's because even if Glauber had a different idea of what license to
use, other contributors to the file couldn't know.

Paolo

>  - Track Glauber down and get a newer address; you could ask him about the
>    licensing while you're at it :)
