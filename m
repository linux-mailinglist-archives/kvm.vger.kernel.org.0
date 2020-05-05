Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7420E1C5D3B
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 18:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbgEEQQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 12:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728807AbgEEQQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 12:16:41 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A081AC061A0F
        for <kvm@vger.kernel.org>; Tue,  5 May 2020 09:16:41 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d184so1105768pfd.4
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 09:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=AFoa2jSQmwFH1H/9Mpl8zrOPJkiCHAvTakQpWbZywyQ=;
        b=i9LXZQysTN42mcC7IKzqFKaDOnxiGNF3pFM2cvPEgrWh4o3CEO2ez0AQAh6tLkEuXM
         X8+L4D6g9sMZ1zTLsOOM0F9GpRJo/XNUUFmXLKrcH2raHc8wFAFK2FdJHgvg9F/Kjei+
         cl2NI2oesApPTD0Bb9JjUbsDAS+ql6kKvsV07htpQXqiomfO/HdLqaO9rJDg+SNM4cuP
         FVqcpJ9cCrS2JqeU4m2EUYsA2YN/JKZg0g6Ya4qhy4X0/em2oYOHvCEJqhxcAyz3p34b
         XWBv6/z5e17CII3pPKNG/VPoR+IPYL5Pf8uPuK9jhJBFFB7S9sTRQpMry+EeQdhiCwtd
         c0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=AFoa2jSQmwFH1H/9Mpl8zrOPJkiCHAvTakQpWbZywyQ=;
        b=EAnkrqEJe+YdmA7Dw9NNY56JgdCZZ6uZuf/txRAjKGbfu9EeWy8DcRz308vcrVvP52
         REFEaXXFZ3lcWB4XWacDiet6JP1ZYDpihErn9pj3VEB0sEVU7S8mjFUEjd7uz7ExfvqX
         RKDnLi4+suHpE8aHlIvZRQx6NJEY+9WT3AL14JOal7rqbC1e6WTy2wmNheJ/HfRqVYvo
         YxoCRDzP+99pM3aqyVzN0QP/W4wXLh29IorSBdW+KvyrBo7ezZWILA8mBPIgEIK5wpIa
         d00OZVx9icsZPwyjKe1MOpJzGREV0O0npm8MEnrUJUD0xQ4is6yeHssKjNgCOq1VWGYj
         xqlQ==
X-Gm-Message-State: AGi0Pub6yd0aHZqoIAdlxz07IG9WkxonMLu3oRytf5s+2QJy9wXs/PVP
        ITIAcs7kREYMK8BAzcvollKjszXyujI=
X-Google-Smtp-Source: APiQypIkLNut/hHZQL0WVs1vsAL1HnELxYNm1HxPQ7w4fDPCFva8H04/AGbMn2NnhRN1m46TYaJnaw==
X-Received: by 2002:a63:f610:: with SMTP id m16mr3468117pgh.174.1588695399946;
        Tue, 05 May 2020 09:16:39 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:1cf4:7516:9122:5276? ([2601:647:4700:9b2:1cf4:7516:9122:5276])
        by smtp.gmail.com with ESMTPSA id 184sm2430866pfy.144.2020.05.05.09.16.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 09:16:38 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH kvm-unit-tests] KVM: VMX: add test for NMI delivery during
 HLT
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200505160512.22845-1-pbonzini@redhat.com>
Date:   Tue, 5 May 2020 09:16:37 -0700
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EE739374-65DD-4DA0-85F4-DC060E8C22E4@gmail.com>
References: <20200505160512.22845-1-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 5, 2020, at 9:05 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> From: Cathy Avery <cavery@redhat.com>

Paolo,

Not related directly to this patch: can you please push from time to =
time
the kvm-unit-tests? You tend to forget=E2=80=A6

Thanks,
Nadav

