Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9ED5D3A7
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 17:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfGBPyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 11:54:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40951 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbfGBPyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 11:54:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id p11so18446979wre.7
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 08:54:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tdSbWMjZkQV9mZNgzhzlHm5c3QDM4cMy2MD63efrffE=;
        b=X2HTTjMXbvFqxM5S8pIGGoFmflufUN9gcgPzBg/Sm3zSnbC/iuHIzNZatSwhZfMUP1
         ASX6AC+eCpIVDYzsFVVE6jpnbnQfKvrWIedvFnpOIl10OVPsaJ+xRkoYbzsw/+6cevyD
         nFhyzeRxuSa++TKIG2AAl9U7jUgza48D1F/4bMzvlGjoW9TT5kP39PylCYfTXTKltlrM
         s/OZEP7RGwLIDTtKb5C74Lmjz3vTv5PS+5I7gytXfcEERTtTNM2N80arlV+IjGhAqXA8
         gNrh5NfXqDg5NcoBoJqrlwLyIH/ewcbwh3Cnnu9V1QVz3y2nqEuKKwhkMl9ZjPnKXJq6
         fv1w==
X-Gm-Message-State: APjAAAUxfBGGrp2utBe7FWU+RyCFT/EA+PRzvnwV8J9SYpgk1FoAKZfa
        gzkybsD1Z3eyHFroZcbGm4KLXw42On4=
X-Google-Smtp-Source: APXvYqzyNqyQBIK7+iKP5PjQceNvuELQHQ6+VDC4FWfQS0IiwPA0E8lwGAqyBHejsB7T/Xq9RrokaQ==
X-Received: by 2002:adf:bc4a:: with SMTP id a10mr18541987wrh.230.1562082857673;
        Tue, 02 Jul 2019 08:54:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id o24sm3017166wmh.2.2019.07.02.08.54.15
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:54:15 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Remove assumptions on CR4.MCE
To:     Nadav Amit <nadav.amit@gmail.com>, Marc Orr <marcorr@google.com>
Cc:     kvm@vger.kernel.org
References: <20190625120322.8483-1-nadav.amit@gmail.com>
 <CAA03e5EZTQbX_-_=KKcOaVgMUDS2=MO6CgdnOO8yHt+9v5zK6w@mail.gmail.com>
 <88414639-D2BA-47EF-BF3B-A7B69FEA92E6@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <507f9b61-d5f3-35f6-8cfd-0632048dab9d@redhat.com>
Date:   Tue, 2 Jul 2019 17:54:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <88414639-D2BA-47EF-BF3B-A7B69FEA92E6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/06/19 20:03, Nadav Amit wrote:
>> "set ..." doesn't make sense, right? Maybe just delete "We choose to
>> ... during this test.".
> Will do on v2. Thanks.
> 

Or "We use CR4.MCE...".  I can do this when applying (which is now).

Paolo
