Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68DC9606C6
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 15:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbfGENnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 09:43:12 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:47022 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbfGENnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 09:43:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so5370805wru.13
        for <kvm@vger.kernel.org>; Fri, 05 Jul 2019 06:43:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z4BuVK5MHJZKRznczRER/njh+cqjMTnj6tQCtgEvnIM=;
        b=IpjbcS+9e+A+Nu+ZWxPNpRIrqWyh55FdJZdj/8NtVkPaYrKip6YvihcpH/sN4bDjtf
         oHBAoHeBmbuof7K7O2mS5LByaIkKEt1VPbjLz6I1NoFYAVy3H4AT+6LXpwVM/cOxuRi1
         3AH02Y6Qs23/VbRdmhzgkC7jOTf0Pm4Cpi9FlNGAKY/hlrKmyvo5ccKrW4GZc5TEcB71
         jAXAmziwevc5780kaqOb9Pk9Ns6pQ3NgGihbU0O0jiGQOGFcNzDFGM3D7E5aWmSa9MfF
         rwn+9hCy/QB4FFD4Fk0G8W1EOwW+t12oygS8fkS4rIUTFmqm3dNhQMzuZMV6DbtkTx3K
         a1mw==
X-Gm-Message-State: APjAAAUzxUtU7a+KOk+pb49oFt1JrZBLyYmH4HcNtjCKlj9tN6g/P7eO
        G/zPSh0aoCtCEfoemzLwfWrF28MijLs=
X-Google-Smtp-Source: APXvYqySB4V1DmbZ4ga2+U+9TKqDiRiwvoE7ChTFqhHXu+z7B/U2VlmAyeKhxAoUqMj8/okKLw99Jw==
X-Received: by 2002:adf:979a:: with SMTP id s26mr4242906wrb.13.1562334190153;
        Fri, 05 Jul 2019 06:43:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e943:5a4e:e068:244a? ([2001:b07:6468:f312:e943:5a4e:e068:244a])
        by smtp.gmail.com with ESMTPSA id c65sm8593960wma.44.2019.07.05.06.43.09
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 06:43:09 -0700 (PDT)
Subject: Re: [PATCH] KVM: LAPIC: ARBPRI is a reserved register for x2APIC
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
References: <1562328872-27659-1-git-send-email-pbonzini@redhat.com>
 <2624F5BF-1601-4A7B-8CA2-7D3328184E46@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7335396e-d82f-456f-b086-3e8d613186b6@redhat.com>
Date:   Fri, 5 Jul 2019 15:43:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <2624F5BF-1601-4A7B-8CA2-7D3328184E46@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/19 15:37, Nadav Amit wrote:
>> On Jul 5, 2019, at 5:14 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> kvm-unit-tests were adjusted to match bare metal behavior, but KVM
>> itself was not doing what bare metal does; fix that.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Reported-by ?

I found it myself while running the tests, was there a report too?

Paolo
