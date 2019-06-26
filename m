Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2AF5687B
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 14:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfFZMTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 08:19:34 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:35612 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfFZMTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 08:19:34 -0400
Received: by mail-wr1-f41.google.com with SMTP id f15so2513906wrp.2
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 05:19:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z65EMMRLMdv1kWvP14/NVwJOwEpNkbLuO3J31367Rxs=;
        b=FnsgZzFX1zdGr4VWtuga8Bk7nzn6MhXOKctoRLKgEOtJONlOQ7ZEKWTEXX0NEb+hv3
         tO/ZcXWekiR6WkPqit+JtKEADyAvxtfHZanO2q3jpiVX2T7AQsoiMUXRgYPp0OgpD/bY
         33J337HAl2ULe1rLfFYgx+jSeERnnVfEqarSmsoG9B7ppKKSZfkxabR/ovtohKpOxUBv
         Vw5+yyD6HAe2DGf4KfQk6F5yb/VoYqPvNeBjxk2UasDG6+E9MDfKRXjttz2XzNgk34v2
         28nhhVZ4KBV+R1rdrCacYXcDkzCoQiBZJKQXXFjUjzhqWZWSg2cryvOFe+p4iW0GOtRG
         aGKQ==
X-Gm-Message-State: APjAAAWt8tdWj09ozzjyPxA7z+HX5gB5Gc0EWeyM4Qf+mgVEhmwpZwbU
        cZmCrg2PT56DM3s1mzLjsRfIqQ==
X-Google-Smtp-Source: APXvYqxjVWpVZIPguHFdWiP8rPq1t14VjoshpsvwLkCTn21s39Idea2oHCjm9hOtTdcLHbRSD5BINA==
X-Received: by 2002:a5d:4b12:: with SMTP id v18mr3611195wrq.123.1561551572292;
        Wed, 26 Jun 2019 05:19:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e88d:856c:e081:f67d? ([2001:b07:6468:f312:e88d:856c:e081:f67d])
        by smtp.gmail.com with ESMTPSA id j189sm2373028wmb.48.2019.06.26.05.19.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 05:19:31 -0700 (PDT)
Subject: Re: WARNING in kvm_set_tsc_khz
To:     Alexander Potapenko <glider@google.com>,
        syzbot+c03f30b4f4c46bdf8575@syzkaller.appspotmail.com,
        haozhong.zhang@intel.com
Cc:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, rkrcmar@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
References: <CAG_fn=VyAYUYJuCqR1rL_KjGm5i1mBzffA=uuCnTa0QOBRsvaA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <abc5e09d-aaf5-3e12-6f2d-d97138951abe@redhat.com>
Date:   Wed, 26 Jun 2019 14:19:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAG_fn=VyAYUYJuCqR1rL_KjGm5i1mBzffA=uuCnTa0QOBRsvaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/06/19 14:09, Alexander Potapenko wrote:
> Hi Haozhong, Paolo,
> 
> KMSAN bot is hitting this warning every now and then.
> Is it possible to replace it with a pr_warn()?

Sent a patch now---actually 2 because I forgot a --dry-run. :)

Paolo

