Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16C3FE007
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 15:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfKOO04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 09:26:56 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49845 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727411AbfKOO04 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 09:26:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573828015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=YAABbHe3sNY+Egrkqr4me6x1W0FPkMdgZ+GIVxxRgO4=;
        b=KTXaCBBNQo0zC50dM60ag3g7zeyvBMH2F/FWLhu/v9gPhxWY4tOYAoW4X+J7sgmzuZ85la
        1d8kTaYciIQsB1fvM3TYlmjDIlujFU5DCqSmCw2EE7F+dDpCnpEqALh0YIZUbGYEbqYEJr
        COrzCg10W8NqIhVVAj3QCWV4Hbp8nAo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-1wRRZ56WOVmo7JyOoHkOdw-1; Fri, 15 Nov 2019 09:26:51 -0500
Received: by mail-wr1-f70.google.com with SMTP id q12so7780399wrr.3
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 06:26:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B6aD7MeLkiqpuKWWnu1AaCWgAg1Wn1iy4yCeUluVRb0=;
        b=oetNr6V+LDEFDYjSXyH7/i9sn3lce1AvuBxnFx5kiCS4V1wKFH6bD2DRCUGNYc2K6k
         Zn1LdgkiSAF6Ay1bFzjBkoXmsclZCsUGEfxJDmvkkuq7DIxWdanmKmjXDqc9Fu2yXqMf
         ovQsV6qgDwXeSE2gWLd/bM3AdTtN/9pDSS3CgLLLR1sHQxApBtSB9dHYmjAMlGZ6vvba
         IMihYWz8hXoLEM8m5rFe0/EY8aRJXEBe7aN9ZJhxJGGr0douwNlNDOSNELQvfVi6Z769
         cSRf8GANXTotoMU1CFOeQwRH6MIIc4evq1rFUSujlQ8z9kAlg7K16GQTu4l7kVQnSkGw
         9RUg==
X-Gm-Message-State: APjAAAX2R0RypdEvfx74ue/yyXsEoZr5fyQoitpAv4v5COc9/j9cEwKR
        1aeAF2G4H6Y6ZNqNzQaHRD8VppJgl5unwOqpILNLvOBEZbIWV21psesGx7WrDpeXQwVB6DqYf35
        6tT8kd/uyfs8k
X-Received: by 2002:a1c:4456:: with SMTP id r83mr14194173wma.2.1573828010439;
        Fri, 15 Nov 2019 06:26:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqy0HVdAECPM563WhDKZT2ASqBtrO4RHcyxdiJtbCydoHrnVyPFZcoZ7liXHHMWmmEvibZ1KlA==
X-Received: by 2002:a1c:4456:: with SMTP id r83mr14194143wma.2.1573828010122;
        Fri, 15 Nov 2019 06:26:50 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:857e:73f6:39a8:6f94? ([2001:b07:6468:f312:857e:73f6:39a8:6f94])
        by smtp.gmail.com with ESMTPSA id f140sm10806039wme.21.2019.11.15.06.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 06:26:49 -0800 (PST)
Subject: Re: [PATCH v4 0/4] Add support for capturing the highest observable
 L2 TSC
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20191108051439.185635-1-aaronlewis@google.com>
 <52b9e145-9cc6-a1b5-fee6-c3afe79e9480@redhat.com>
 <CAAAPnDHQSCGjLX252Zj7UDWjQQ9uKYC9UTmCWx2HJ4Q+u-aObw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <fe087e58-252a-f489-abbb-37cd68e2e437@redhat.com>
Date:   Fri, 15 Nov 2019 15:26:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAAPnDHQSCGjLX252Zj7UDWjQQ9uKYC9UTmCWx2HJ4Q+u-aObw@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: 1wRRZ56WOVmo7JyOoHkOdw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/11/19 15:25, Aaron Lewis wrote:
> Agreed.  I have some test cases in kvm-unit-tests for this code that
> I've been using to test these changes locally, however, they would
> fail upstream without "[kvm-unit-tests PATCH] x86: Fix the register
> order to match struct regs" being taken first.  I'll ping that patch
> again.
>=20

You've just done that... :)

Paolo

