Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21952606D0
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 15:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfGENrf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 09:47:35 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33566 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfGENre (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 09:47:34 -0400
Received: by mail-pf1-f193.google.com with SMTP id x15so4380658pfq.0;
        Fri, 05 Jul 2019 06:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=FZ0X0bC9AHQc2jRDWtnIb2cairGd0Neb1HrNsRi3tYg=;
        b=r7qFxfkxFdNokvFU3DH0kcaoAI8CEDkyN5mTkNW3Xcmmn8ku+0M+/bO+orFjh7vrcK
         6wTCojB86FuYCgVpw81BkbPXVr53PZOtRqQ+uaAeb2ghbhjDibpNt4oyvFfZTwnTOZhS
         SaFf6ukc3GWANf/x4rHz4nLvBxNvXJF1yM4vsOBDcejbBEZEssmlulJXTuivl0DsyD+P
         PSLZ+gPLela4Vys3rSftmzHTKBkdAkUYyl1ALWiRYNgvOYbOynV5PXCjsPFQYDBI/eJ4
         tXsK/6dF6uM/2GhxA1LOIXc2ULCQJHNGTCUoZDAqoZK8wYovlTiSczZ5sHX/DCqfc7LR
         yABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=FZ0X0bC9AHQc2jRDWtnIb2cairGd0Neb1HrNsRi3tYg=;
        b=BxCZQ3ZlKPSN2Q0Lm0y6frBA5kXVQXj8dTcnjWgEU3Ed6baT0MNK8jAWciYrgsu8Mc
         kYpm/PCzczmh8J+GsWHMtTQzsq6SaAD15FoGA5/bIiaKduLjHDmPMOO54vY/I7JSahTq
         RBOQB6YhkrUhai05RgqHihGlqatpRQqM0IkjR4glvV9cjAIMlFM+PrQ/rVCocdlcIGkk
         C5oLDntE9Zg2YeV9xnO5o7MLzw7Ncwga6nAwfud/VHu+jDP981lH2VmEfbKK57mlFj9l
         6O4ELcOj2qxxYRsS8Eq2wlUeAlYKGjGBATWNEsiPK3vQDl+Ea76/4EhrxnBxNYd04i5W
         yVbw==
X-Gm-Message-State: APjAAAUHTskHUB/Nepy5BX+M+NvLHI+xRfKwjRixe2BT4Dm87Jzwc3UC
        hYvKnYaGS4lw3XSLadt8qcU=
X-Google-Smtp-Source: APXvYqy/FcOiFGN0BOR4dgOfUuVm7cQx8W+3tAtA9NkICU9/oMvNJsb/CwlkA/TzbTh8d1RicYsVtA==
X-Received: by 2002:a63:e506:: with SMTP id r6mr5750049pgh.324.1562334453840;
        Fri, 05 Jul 2019 06:47:33 -0700 (PDT)
Received: from ?IPv6:2601:647:4580:b719:ac8c:5fbe:1262:33d4? ([2601:647:4580:b719:ac8c:5fbe:1262:33d4])
        by smtp.gmail.com with ESMTPSA id m100sm18878643pje.12.2019.07.05.06.47.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 06:47:33 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] KVM: LAPIC: ARBPRI is a reserved register for x2APIC
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <7335396e-d82f-456f-b086-3e8d613186b6@redhat.com>
Date:   Fri, 5 Jul 2019 06:47:31 -0700
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <E4B6D7F9-8F3C-48D1-B414-0E62A95CEDD5@gmail.com>
References: <1562328872-27659-1-git-send-email-pbonzini@redhat.com>
 <2624F5BF-1601-4A7B-8CA2-7D3328184E46@gmail.com>
 <7335396e-d82f-456f-b086-3e8d613186b6@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 5, 2019, at 6:43 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> On 05/07/19 15:37, Nadav Amit wrote:
>>> On Jul 5, 2019, at 5:14 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>> 
>>> kvm-unit-tests were adjusted to match bare metal behavior, but KVM
>>> itself was not doing what bare metal does; fix that.
>>> 
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> 
>> Reported-by ?
> 
> I found it myself while running the tests, was there a report too?

Perhaps it is in my mind. I thought that fixing a test is equivalent to a
bug report.

