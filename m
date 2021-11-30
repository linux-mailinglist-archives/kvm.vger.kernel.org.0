Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB674631DD
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 12:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237292AbhK3LOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 06:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbhK3LOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 06:14:51 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47445C061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 03:11:32 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id w1so85343603edc.6
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 03:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/H+LuZX1fGHm+fCq0wcDJ9/wPnRpWO7dTxByyfOKwzU=;
        b=VfsaplV463eXjZF6zSATmw/mIHOJ73Y1elA6nPCx2myvHSvr4qrQQ2XwTEYfmIt0rZ
         o19u3zHa5zL0KlZUnH53jmrynuk/N8TZAMbuAjQNUAzwevVGdx47m52DZ2kZT+JMO/0t
         rlC4E+D9oPO1+yYScWUma4YYoiAKfiuH5a6j7GC5rnLUD+YB0JNqwS+/Te3NpDNE4Iv6
         BXPxC/AafhlxZKwK1FWm1+eGhj1QZe8YtnjMLdlZC0sq5D1isVGXke3Ree+FKeQZtyjg
         eQDRY1pz+evWipEtS6Y0wPYy6RZegvDz1KXrATdNN3N+UkweD2Kbj8//cDeEOMuahdth
         2AjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/H+LuZX1fGHm+fCq0wcDJ9/wPnRpWO7dTxByyfOKwzU=;
        b=pmOwiAV9GQMXM6ZcZmfq6lUrtXo5MsneELxYSpRHDh8SDeeGc19WoM1yAGzuYkEi13
         s379EXqndiQd6rok2iPzd/Km4KniTPh5yfbhXcoUSLvBT+7wLql9yKKsYDHLH/MNcsIj
         ho81V/vcz1g/vsrrCzWDB2IypsaGA/I+jYqlob5ylzxRcaGIjo3tDtI3HYYz8gyaUtma
         KetAwyY69kYKCmSzJzvA4T7d9A8ZQbc0ovNApCRG6PujHCfNh6t2mpzrPMd99ocLyQ+I
         Wy/iWc2L/rRQuwF2XE7LN8LzWCn/8neYbVWcJTsdJWLBPaQeV4nQDtSSfEM3flYpJfBd
         JKLg==
X-Gm-Message-State: AOAM533guhQuFU9DHWXXY7KXqDwXwhKlrvP0t2IKVetR1HMINUgnT3GO
        D67dwJbTRUdkS0jBFSDk0T4=
X-Google-Smtp-Source: ABdhPJyLZzac+dmwZQjHjDY/jCtn62rNj9rDZEYlcvWig4UFwc06i7GCZ8vAnbSSjx+rI5QhyMsP3w==
X-Received: by 2002:a05:6402:4248:: with SMTP id g8mr82955342edb.182.1638270690922;
        Tue, 30 Nov 2021 03:11:30 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id mp9sm9205581ejc.106.2021.11.30.03.11.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 03:11:30 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <041803a2-e7cc-4c0a-c04a-af30d6502b45@redhat.com>
Date:   Tue, 30 Nov 2021 12:11:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Potential bug in TDP MMU
Content-Language: en-US
To:     Ignat Korchagin <ignat@cloudflare.com>, kvm@vger.kernel.org
Cc:     stevensd@chromium.org, kernel-team <kernel-team@cloudflare.com>
References: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
 <d49e157a-5915-fbdc-8103-d7ba2621aea9@redhat.com>
 <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/21 11:58, Ignat Korchagin wrote:
> I have managed to reliably reproduce the issue on a QEMU VM (on a host
> with nested virtualisation enabled). Here are the steps:
> 
> 1. Install gvisor as per
> https://gvisor.dev/docs/user_guide/install/#install-latest
> 2. Run
> $ for i in $(seq 1 100); do sudo runsc --platform=kvm --network=none
> do echo ok; done
> 
> I've tried to recompile the kernel with the above patch, but
> unfortunately it does fix the issue. I'm happy to try other
> patches/fixes queued for 5.16-rc4

You can find them already in the "for-linus" tag of kvm.git as well as 
in the master branch, but there isn't much else.

Paolo
