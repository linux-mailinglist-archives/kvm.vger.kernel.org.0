Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F8E462608
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbhK2WqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbhK2Wpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:45:38 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C90C20146A
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 11:15:09 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x6so76009378edr.5
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 11:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=34kTiDZ4RjGEi4sG0MFR2e5l+WgUm717YmCjkndh+wY=;
        b=VcdTvdC5xUpXrzNOzNvUm3x96UYyR9ZkVjTYnOpIwX3R3blY/3lXnA1nwxokez2oEf
         jvWw7R1jFsXXZXSjRrqdIZJFGCg6BITa/u4zt0swuK6SGHHNlYh1P91ywUR3TNmYotde
         fVtZqKnO3+Q66oaJHCSok6p9lQEGWiwUSMdaI38wR5YxVgxVRWb4xSe7Y5cFDa7q7qVB
         1gl4oTAoj40hPC5buj2fr6YzHBMv+Tsx1hN2FIfoAJswbgfbyduAugMet4B4VwpEg3iu
         vfcv4EW66TYxd8lb7ZqRl7zbUYXXxYlKYzDolZVSSiZZPyaDXQMeN1ZIRzSV+1fqmCsS
         afpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=34kTiDZ4RjGEi4sG0MFR2e5l+WgUm717YmCjkndh+wY=;
        b=M3cxEdSivXzMQ+jgrlDbi2J8JRIfJpFySoouEo5W/QBxMHCxh6AWPhBpbTtpH9mYNJ
         C23UUZANryohBZBrWxHVEC9jioxo5rEi2QsTKuuXsNUUvVhonxPMZ7Y1l9autBOdlobs
         Y3F/uOqEz8sz0GxaLa2fyhMtl5fx7zTfOzR4qIIOzKNG7nL5l3I10vVk8iLEYHFLwwBB
         w99IG1lYTKb1C3bXqXb0v0O1cF5AekXBu//m3HSHTsmSKf6q4s6ThXpqcFNzaUP4bZiA
         rLdznKt4l+70AeRRguZ6wkygtTfv9oSHD1r+YPCAM3o8bW9kgRbsn2agfRQElagLMn4B
         1EIA==
X-Gm-Message-State: AOAM530/wZhNx3r2j42tW+1pJQZO+M1Na/y971igyiRTPIiazoCJXrXG
        5Dfz/CvK3hudkecv0K+qUe6mqjpE288=
X-Google-Smtp-Source: ABdhPJz0Lpj0Y2aD23cN4rA91hwwdQeGvk29FJGvvYHQ86xejgbvaBsgIdWc0LvBBXfXRVp3aQFFLg==
X-Received: by 2002:a17:906:d54d:: with SMTP id cr13mr17814752ejc.72.1638213308404;
        Mon, 29 Nov 2021 11:15:08 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id y19sm10835949edc.17.2021.11.29.11.15.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 11:15:07 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <e155b5aa-500c-0a76-8db9-fbd157b82196@redhat.com>
Date:   Mon, 29 Nov 2021 20:15:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 00/39] x86/access: nVMX: Big overhaul
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20211125012857.508243-1-seanjc@google.com>
 <34ff357d-c073-4a68-117d-63ccff1085cb@redhat.com>
 <YaUkMQQQ4KdlmDq5@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YaUkMQQQ4KdlmDq5@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/29/21 20:04, Sean Christopherson wrote:
>> Queued, thanks.  The new tests are pretty slow on debug kernels (about 3
>> minutes each).  I'll check next week if there's any low hanging fruit---or
>> anything broken.
> Hrm, by "debug kernels", do you mean with KASAN, UBSAN, etc...?  I don't think I
> tested those.  And with or without EPT enabled?

It's a normal Fedora rawhide kernel config.  It doesn't have 
KASAN/UBSAN/KCSAN but it has lockdep (including CONFIG_PROVE_RCU), 
CONFIG_DEBUG_VM, CONFIG_DEBUG_LIST, etc.  I will gather a profile just 
in case it's something egregious.

Paolo

> The tests are definitely much slower than the base access test and its nVMX variant
> as they trigger exits on every INVLPG, but three minutes is a bit extreme.
> 

