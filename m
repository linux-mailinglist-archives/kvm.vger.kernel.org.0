Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C51415BC28
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 10:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgBMJyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 04:54:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55432 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726232AbgBMJyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 04:54:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581587680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ez44N34m1PHTjtAxByIbkjxOsH6Q8Xfjl62Un4eIlPE=;
        b=F/yI7C7tvqcgFaKUgCxXJiANg4t7Rqv+0gaOYVxAfAT4QbDODkihLUW5jT9rNfUBAzjpJy
        bGxlk+tlTBXHvPIrNm5ZCrabjjpajgN/U6llplXtWjOdYZMxp7YMkSObZWhyH/RRXdS3M8
        1mjwnz16uF3482iZ/7OilxDn/1FSAXE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-DFwOYNHOPZSv_j0w1mMtkA-1; Thu, 13 Feb 2020 04:54:39 -0500
X-MC-Unique: DFwOYNHOPZSv_j0w1mMtkA-1
Received: by mail-wr1-f72.google.com with SMTP id 50so2129012wrc.2
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 01:54:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ez44N34m1PHTjtAxByIbkjxOsH6Q8Xfjl62Un4eIlPE=;
        b=qGMZoLWawFUqcG4NQNryTAZs50ORrT6QaEgkZ39khTCnSYEaqq35vClbVgRUD2Loe9
         1XslwZTuy+RJQtq1QflVduF45NuZcXcTeR7iMCfyM4ghIRoDcDqWMqQS9VigPUx71fza
         zIzlXpQIDzDIpYajrMcm1BFl1iHN7UKN2ThapIGsBrHtJ9u3gaUV1pm7TclsNaOZyBxA
         bg230QSyI+JUwZxOvAdExeSAOpgnni3smWqmVglk/7dw2w+K64jKQEpCrb9os4tz/Nl7
         Zshw329UeOpOJRxKP+KlPATzoQPwVFAq/2xbL3/9P8cf/r+xP30FueoS9Wyo17MO2gYG
         pfwQ==
X-Gm-Message-State: APjAAAWJcMms8BGGXtF9eu37ZQH+MgcATWKHGPu1nAB7GhgWzYzPKTUq
        MZEs1rkEW4jcXnohJiTGRPaxdVCDuCJ0O+cWdVtFmPCuCKD0uYU2Mhwx4txZIIkGAdNia2oUkZC
        ZRzPGJLiyJnqt
X-Received: by 2002:a7b:c318:: with SMTP id k24mr5213063wmj.54.1581587678273;
        Thu, 13 Feb 2020 01:54:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqz4Fq3M8a40Fwp+Pl2CcItRt8aHeoE6SL80Nlz6KbnNbOf6qcxWgFwi+XXod3UC9586V1UZ+Q==
X-Received: by 2002:a7b:c318:: with SMTP id k24mr5213036wmj.54.1581587678038;
        Thu, 13 Feb 2020 01:54:38 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id k16sm2259120wru.0.2020.02.13.01.54.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 01:54:37 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: enable -Werror
To:     Joe Perches <joe@perches.com>, linmiaohe <linmiaohe@huawei.com>,
        Linus Walleij <linux.walleij@sterricsson.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <12259a951c5e47359c46f7875e758d41@huawei.com>
 <71b3bf53c0fc3c68b10368092022e3bf2cffc506.camel@perches.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <249ec0c0-10fb-52df-0c81-2ec28ecae32b@redhat.com>
Date:   Thu, 13 Feb 2020 10:54:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <71b3bf53c0fc3c68b10368092022e3bf2cffc506.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/02/20 04:31, Joe Perches wrote:
> On Thu, 2020-02-13 at 01:40 +0000, linmiaohe wrote:
>> Paolo Bonzini <pbonzini@redhat.com> wrote:
>>> Avoid more embarrassing mistakes.  At least those that the compiler can catch.
>>>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
> 
> I think adding -Werror is a bad idea as new versions of compilers can
> create additional compilation warnings and break builds in the
> future.
Seems like cargo culting (in the reverse) to me.  We can cross the
bridge when we get there.

Paolo

