Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C0C8229B
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 18:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbfHEQlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 12:41:02 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40564 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfHEQlC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 12:41:02 -0400
Received: by mail-wr1-f65.google.com with SMTP id r1so85034968wrl.7;
        Mon, 05 Aug 2019 09:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:references:user-agent:to:cc:subject:message-id:in-reply-to
         :date:mime-version;
        bh=ABajkI5eExlI/xSitmeiji8gDOSYLzGBroq8lVBwkdg=;
        b=Jf1TsCUn3vg9vZIttQpRDxQyLLdSkih/m9y3kA3yWVwK1tHBcluvzb64DtQ25oH1/V
         xc+QogvPb9pckGM5vfsy43/UEaWPZWupWkE5UPXHzZT5A7/7Ma3dw/KrHAyWf+SIQ5pr
         Dcvq5iH0eSbCNiujtHHwUJZ240xv7Qi/eds7T8oztvpIBx2XrJ5va7rgiLI/SzDbk43Q
         Z9ORvjpxuJo5BgjdcSStKB849ChK0G8vPO2yzLZGaqzz0g6WR36X48+GBvCQz9Tay6xs
         czQE6+3WjSb7nz9cH1JuMb4iiT+97q5c2zuu/BUbeRroBVjCzNGInLsmtjQPkR05iWcK
         8OZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:user-agent:to:cc:subject
         :message-id:in-reply-to:date:mime-version;
        bh=ABajkI5eExlI/xSitmeiji8gDOSYLzGBroq8lVBwkdg=;
        b=ja333Nqtw20Mg9p87EzOhrEgYcG7GmjPnXLyAE4NJqb8hLRY9yagT4GFUZuohHJ2iR
         SAmnNigQGyxIXTdBfVu1ZmiFSDyC6AneB1xemr2cNDqdrSWKVN7wIHvKnAQbW87i3zL5
         2yhFktPRlmgHyb+QfCQ9uOSWZs4O/b6z1deXeokbgBny6NOEFGBO3n25sHdGA2wA1+KA
         m4GALRztMhorwE0gqrRmO3FSmuWBup1q8j2x7eyTIqjnQOSEnKNiYUL7HQBeEJEQ4IAn
         1Mr64JLB9LZNDW4q9FGYPZ3+PywIqfx2Q6j4YtdSh3rvHuSYYyy6/Fswk4l+xi6ykduS
         NKhg==
X-Gm-Message-State: APjAAAVKtD726JUIa1WAiplMkkuru1+L8SojAzp9AdVuxovPwFYEwhzT
        ndKL1hSyrCfEkuxXvSgtEVL3KSef2ck=
X-Google-Smtp-Source: APXvYqz/Y6nmSCAzfJUUyNSVsxAyHbqu5I0RQoLKZMj78OsAAfjqWRVGFPKFfORnGY8ls5vKuqHU6Q==
X-Received: by 2002:adf:f050:: with SMTP id t16mr791943wro.99.1565023259727;
        Mon, 05 Aug 2019 09:40:59 -0700 (PDT)
Received: from ptitpuce ([2a01:e35:8b6a:1220:5461:8d4f:b809:4bf8])
        by smtp.gmail.com with ESMTPSA id i12sm99839220wrx.61.2019.08.05.09.40.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 09:40:59 -0700 (PDT)
From:   Christophe de Dinechin <christophe.de.dinechin@gmail.com>
X-Google-Original-From: Christophe de Dinechin <christophe@dinechin.org>
References: <20190802145017.42543-1-steven.price@arm.com> <20190802145017.42543-2-steven.price@arm.com>
User-agent: mu4e 1.3.2; emacs 26.2
To:     Steven Price <steven.price@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] KVM: arm64: Document PV-time interface
Message-ID: <m1mugnmv0x.fsf@dinechin.org>
In-reply-to: <20190802145017.42543-2-steven.price@arm.com>
Date:   Mon, 05 Aug 2019 18:40:54 +0200
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Steven Price writes:

> Introduce a paravirtualization interface for KVM/arm64 based on the
> "Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.
>
> This only adds the details about "Stolen Time" as the details of "Live
> Physical Time" have not been fully agreed.
>
[...]

> +
> +Stolen Time
> +-----------
> +
> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
> +
> +  Field       | Byte Length | Byte Offset | Description
> +  ----------- | ----------- | ----------- | --------------------------
> +  Revision    |      4      |      0      | Must be 0 for version 0.1
> +  Attributes  |      4      |      4      | Must be 0
> +  Stolen time |      8      |      8      | Stolen time in unsigned
> +              |             |             | nanoseconds indicating how
> +              |             |             | much time this VCPU thread
> +              |             |             | was involuntarily not
> +              |             |             | running on a physical CPU.

I know very little about the topic, but I don't understand how the spec
as proposed allows an accurate reading of the relation between physical
time and stolen time simultaneously. In other words, could you draw
Figure 1 of the spec from within the guest? Or is it a non-objective?

For example, if you read the stolen time before you read CNTVCT_EL0,
isn't it possible for a lengthy event like a migration to occur between
the two reads, causing the stolen time to be obsolete and off by seconds?

--
Cheers,
Christophe de Dinechin (IRC c3d)
