Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BB545B90C
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 12:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241182AbhKXL2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 06:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240520AbhKXL2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 06:28:45 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0493CC061574;
        Wed, 24 Nov 2021 03:25:36 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id w1so8833551edc.6;
        Wed, 24 Nov 2021 03:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=b1buRXU5rD4SSQpdIa6kX0zDvHTz7Su/CMQ01HSJ/QQ=;
        b=WspF/9buN8DfGHB/qbiMSS4Z9GgtaM7WBmUkdksRp9IAY+2payLQOiKFag4xc0BBml
         +eBLZ9vXT1iCkMukr9pgWiXRpNUewu+cAjnNJijIFLthEaK9E6COigvIpmnBXYOLrBUT
         jj2VpSGQkSIoM0+5SO0aTNZzd4flX5BJltBiJzkMsz8ozv4OmjvP/EBpRW/NgKfHmvRL
         KwV4hqhu+mPujPYse5+EdzwXoPLWN2Jby9xX8ege8E5dn9fzpwYPJuBxz1QYTN7L4UFN
         rElXBxtisvzzKQQKunNCpE71vdXJ8suio6v6XHi9kHWC5RLxiHk+wcKMBUHPpcUxFQjM
         ZjXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=b1buRXU5rD4SSQpdIa6kX0zDvHTz7Su/CMQ01HSJ/QQ=;
        b=ykubxQSKrvZ0DdU62oO0hgqV8DffxtK+D32MJSFxkhVtWTWeGdGVmCf9zVAEIlie4M
         f8aqwBMiKlO08LqKipfd+uYfa+dzSR81sb7jokwTlJSV6MkyxcyMqIP0OyBXyXGe0Lnn
         uMR4HisVjUBPBN0RXjcoZmCBLGTc3Mre1+LUQ2j4TnKwoViTOinVPqqAYCjI/VzOYHCJ
         FLLEQIyPV+NyU3UqMPb9Sbi5DvBlJiPUAz8nM1Hk4C/ftI47fRc6ZiWU6BuWkpleFrds
         5R0FXgkMqshy0wXl7GxsNYCto7kYYykXtu3pUF2dE2YmSivrjKNbJQI8L++IRItXj/Rw
         DDcw==
X-Gm-Message-State: AOAM530jCQRlC6Ufa9tuG4QD0Pjs6w6Z5ELjgawAbJRuwItL6mV5JHlh
        uU4mGossjt2r36NENJ67Bps=
X-Google-Smtp-Source: ABdhPJyMVsqNRPRfoXuQen30v4VRDKIKDTG18STn9WOHrkikIkfB5sjbz+N24ZEO7tdKl3LD9rOGqA==
X-Received: by 2002:a05:6402:147:: with SMTP id s7mr23607229edu.8.1637753134519;
        Wed, 24 Nov 2021 03:25:34 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id cw5sm7020871ejc.74.2021.11.24.03.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 03:25:34 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <1b1729ec-f94e-98ac-e76c-bad1c76467c7@redhat.com>
Date:   Wed, 24 Nov 2021 12:25:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] kernel BUG in kvm_read_guest_offset_cached
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot <syzbot+7b7db8bb4db6fd5e157b@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com,
        Sean Christopherson <seanjc@google.com>
References: <000000000000f854ec05d167f227@google.com>
 <871r35n6nh.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <871r35n6nh.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/24/21 12:18, Vitaly Kuznetsov wrote:
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    4c388a8e740d Merge tag 'zstd-for-linus-5.16-rc1' of git://..
>> git tree:       upstream
>> console output:https://syzkaller.appspot.com/x/log.txt?x=171ff6eeb00000
>> kernel config:https://syzkaller.appspot.com/x/.config?x=6d3b8fd1977c1e73
>> dashboard link:https://syzkaller.appspot.com/bug?extid=7b7db8bb4db6fd5e157b
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
> No worries, I think I do.
> 

FWIW I have already posted a patch.  Thanks for the reproducer though!

Paolo
