Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EBE463CB5
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 18:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244801AbhK3R3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 12:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244782AbhK3R3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 12:29:43 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8A6C061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 09:26:24 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id g14so89930218edb.8
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 09:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ws2wwfY93J2bOXqXoDeJxD6F7LWPRGa05fdFMK/4e6o=;
        b=hMN2nXBsFpaCe4woOtaPyL7U3T9xNyENm6yY+3cpTPgHtPm4ckxGsID3bUbJhI0ZGU
         EnhetT0mmR5JzBJmlHpSnIE6hG9MblYlhkV1+4hlYZxqH2rbOW1TDnb/FuC7llMGZw2f
         AJGDb5G5V6D9GwjdlFxuCU5JrSRvMdYHpVMaf0bWOfOubB9zao6uMIdCjVjBMkGn/9SL
         viMiln9AE8ogjPcLFSwK8UtfwAQmpVvsKWuiL0FE6AdjE2MzQP8AdmSInj/rH3rq1h3/
         /6xx7jiHP7rn6I5trPfqu4JOZyTNpL13ND3sElMArSHMazhrp3IetBonP016ztxyxSpm
         OCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ws2wwfY93J2bOXqXoDeJxD6F7LWPRGa05fdFMK/4e6o=;
        b=SdmdDJyC5Him/Hks8ZHFGknUqoPbD/Ii8iUWedl3c/GBVnwkY9F59Ei4oZ/4ZwTJ+u
         I43FPu7ufvYdIrPZYLFdRutHoUjRK03SnjY97+KQyFrM4nlTV0V5vki42OVxxhJAK5YQ
         KZADQqHB9V9Lnd9kXuUFwump4FK6AiNOg56KPtzCiNIBXqK4vDcohfjbKcMiQMh7Fe23
         2TUaJQu4ISbFODdty4TBArhLi8g7M42NW4l8ra7kFRCdaEBXTwnV3TEB2skfhCOeEih6
         +kM/lWDH8Na/1p9kxW2wxJyPLqCyg5P99Ejx3R4qAobylaw9WkW7Uoe/NVn/7M2y4D7h
         DbXw==
X-Gm-Message-State: AOAM533YBXlXxX/sUaR0mAVTYKkgmgDCbXygxlffe95/8ExlbpJaPGxj
        ljnUn65I3XLjAbLLsd4fFcs=
X-Google-Smtp-Source: ABdhPJz0/sIzsTMgsTzta1w0Grt/kIPuFcemoyI70iO+qsa7abR2yJ6ZaCW7Fy8kcpQr3risydXGmA==
X-Received: by 2002:a17:906:1913:: with SMTP id a19mr510320eje.484.1638293182686;
        Tue, 30 Nov 2021 09:26:22 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id t3sm11680966edr.63.2021.11.30.09.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 09:26:22 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <6cb98e78-4e30-85c2-e280-9e89709b3497@redhat.com>
Date:   Tue, 30 Nov 2021 18:26:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH kvm-unit-tests 1/9] x86: cleanup handling of 16-byte GDT
 descriptors
Content-Language: en-US
To:     Marc Orr <marcorr@google.com>
Cc:     kvm@vger.kernel.org, aaronlewis@google.com, jmattson@google.com,
        zxwang42@gmail.com, seanjc@google.com, jroedel@suse.de,
        varad.gautam@suse.com
References: <20211021114910.1347278-1-pbonzini@redhat.com>
 <20211021114910.1347278-2-pbonzini@redhat.com>
 <CAA03e5FX+C9BaN9VeJAVjLSN0_DknTv5PB0+Q_cmpk1t3a0uJg@mail.gmail.com>
 <7a6d3027-4ce6-87eb-b490-0f2f0d79655b@redhat.com>
 <CAA03e5Hs18UmjkvSrojJkYvBNDGZhEWN7NT-nybTA1OUbFmkJQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAA03e5Hs18UmjkvSrojJkYvBNDGZhEWN7NT-nybTA1OUbFmkJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/21 18:22, Marc Orr wrote:
>> Mostly the fact that "./run_tests.sh" does not work out of the box.
> Ack. The recent patch set posted by Zixuan [1] makes "./run_tests.sh"
> work out of the box.
> 
> [1]https://lore.kernel.org/all/20211116204053.220523-1-zxwang42@gmail.com/
> 

Yep, I'll take a look.  I also want to merge it. :)

Paolo
