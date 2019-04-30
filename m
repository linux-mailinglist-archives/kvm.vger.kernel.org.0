Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65E83101A3
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 23:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfD3VNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 17:13:32 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40138 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfD3VNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 17:13:32 -0400
Received: by mail-pl1-f194.google.com with SMTP id b3so7309252plr.7
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 14:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=4hMEvQbmS7sq8JoiLkIUw7vTWfl+LvSIuzRy62Znp1A=;
        b=My1iXsJWdoPkLtwuk3Umw/oX5dgPOUXmtvZZeKkxH3Di+6Jx1YLwswqS8b0AUQ080H
         4NmJonXLdPBAcvySSiDxziyc1WMMiy3tKDzPgc19y2hxIWKybV/2P45dcR6MvEpxCPOq
         NxTeZGwU3rDi73bShSAoRK9LhqDOwtlBBT6wl1ZWw6AxcX0JCCnO1X6oBf5RWk+iSQMN
         3gP1aRynzANkyWV8vLvDtCdYWr9rQoOQrkRAT9XVvQ0FK51qR+2Qle/A+IItwLHzaGtm
         tuADgCy+vDsw5SAXNHYv5fRDzBkYySPi5GPw6LePxmmPYcsMJDPO07CRuqwTyXutJ6n4
         maLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=4hMEvQbmS7sq8JoiLkIUw7vTWfl+LvSIuzRy62Znp1A=;
        b=MzNWy/aHRxNvqpRefmtvURd0Xy4Yf+Ed3TOylMtvtIYaONbL9amOZkwviTS1509Slz
         CA8AJCfvgmStAEIGBX6GNjXB+lVt3q7Ur3O2c4ZdJDx+wCT4flIj38p2vt3RxSg7NVpq
         BIHG0vjTUQ7/A64Ts+jH74elK0pERstcr8gIqHZj9+YTXouI9Fl/5gS4qK2u3mvGGr/0
         nzVr7cJtRh5bg5ggkXrqQBelQE4BnVhAVqxEjUJO7CK1cUMQcwbQ7Mg/Z9Lw9KNSp0ba
         08+fLfVTsludKw1dXAD0rWXQBT9guTVhKGYIpzY7XHPjuvNSCUXzkHmdqhFXDgaFLwjI
         iZbQ==
X-Gm-Message-State: APjAAAXcu9BCCszUQbMv6i1Tx8b3QCl2lKqezhaxfRB9pdtQa3qFQLVr
        ICHEr390okzwngWYxufP3+k=
X-Google-Smtp-Source: APXvYqy2H8PufUJKyEMhVac9wQdK/Z9G07pFg6HSD4qYAr46Axd03rWp+9gqo8OHBDmZIDu7fvQOLw==
X-Received: by 2002:a17:902:a3:: with SMTP id a32mr1216495pla.111.1556658810934;
        Tue, 30 Apr 2019 14:13:30 -0700 (PDT)
Received: from [10.33.115.113] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id j22sm49214171pfn.129.2019.04.30.14.13.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 14:13:30 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [kvm-unit-tests PATCH] x86: Disable cache before relocating local
 APIC
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190430202704.GB4523@linux.intel.com>
Date:   Tue, 30 Apr 2019 14:13:28 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <918B2DD0-F728-425F-BCC0-1E8F114512C6@gmail.com>
References: <20190430122701.41069-1-nadav.amit@gmail.com>
 <20190430202704.GB4523@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Apr 30, 2019, at 1:27 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Tue, Apr 30, 2019 at 05:27:01AM -0700, nadav.amit@gmail.com wrote:
>> From: Nadav Amit <nadav.amit@gmail.com>
>>=20
>> According to the SDM, during initialization, the BSP "Switches to
>> protected mode and ensures that the APIC address space is mapped to =
the
>> strong uncacheable (UC) memory type."
>>=20
>> This requirement is not followed when the tests relocate the APIC. =
Set
>> the cache-disable flag while the APIC base is reprogrammed. According
>> to the SDM, the MTRRs should be modified as well, but it seems =
somewhat
>> complicated to do that and probably unnecessary.
>=20
> Alternatively, what about defining ALTERNATE_APIC_BASE to a sane value
> that is guaranteed to be UC (assuming BIOS isn't being mean)?  Maybe a
> use well-known address, e.g. 0xfed40000 from the TPM, so as to avoid =
any
> other unwanted side effects.

Cool. This solution is much better than mine and it works for me. I=E2=80=99=
ll send
a different patch instead.=
