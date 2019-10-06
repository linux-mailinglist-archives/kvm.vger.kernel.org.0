Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 029ACCD373
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2019 18:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfJFQPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Oct 2019 12:15:45 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23085 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725847AbfJFQPp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Oct 2019 12:15:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570378543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=lg/L4laSYBgn56jpgnIalr4DbesZh37mDelXP/b99M8=;
        b=hdkIWRzHyUe+hKhECd7I6uIpxrlgQYsIMPszsdobn672hNa/9WhiKRIv7CoCvCAseznylt
        Rowhrg54W+Oix3RNjoitODm+Ib2t4OcIn/7dEXVwU7JYMb8sQ19zhYEyHRmUzQWvMIqLyQ
        R7ckJnKydYyTbcScj4lg1/XnLvrLGL8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-R7cFIfhNMHyKFniNuA4psg-1; Sun, 06 Oct 2019 12:15:41 -0400
Received: by mail-wr1-f72.google.com with SMTP id i10so5776287wrb.20
        for <kvm@vger.kernel.org>; Sun, 06 Oct 2019 09:15:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dSabhuo9kaFmFYjPX/sZannVbv6ltNxrU4vHa5iavb4=;
        b=VXR45MtIJ5ZXFDxWBlqTjRCh2wgL3Z+eV+VIqsd/Uk52o47FszClLG2GIRj9kwOQDY
         19xBDo4EGjNT4JNzEOsnHAdD6+njA7G3gcCH/DouLWfPz28fAiac3THtidleSIhN13cM
         hvpFwZl2rvBYRgFJvWMTVig3OvXxMNbKCgL0sOuw5sj4piUM65shz1DJ3jdJthfFb3ma
         NUcwMe0MkXic73bvNLcREwKOg5N8qxeSOjAoby613iu9Cu85M4ne7e9VV1otGdWCZtDR
         47wiWr4PyGBtb9RSgNDeEpyJjLcJ211+gTRv4szkpQMxljYf6wJbSTSoOhSYKBsa2deD
         JczQ==
X-Gm-Message-State: APjAAAUMdzFAV7US43u51tsFs6+ZIrsVdV8EMtiupB7j5hCnvMdleH1l
        Y2NkZGHRghCJZR2B7bZi6nSlVaAznnaBhkQDBSpRXi4OGfImcsfQzuveRbmXdUh40xjBJiiAzfO
        6GRY4pnPAlB6H
X-Received: by 2002:a5d:4b0a:: with SMTP id v10mr12968306wrq.322.1570378540331;
        Sun, 06 Oct 2019 09:15:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxvzrU+IMTZGu3nozR8V5nr53z8D0g5+my60K97mvMSKYkYzbKZF246Mhkyzo6mVd/AG2JaoA==
X-Received: by 2002:a5d:4b0a:: with SMTP id v10mr12968297wrq.322.1570378540063;
        Sun, 06 Oct 2019 09:15:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e876:e214:dc8e:2846? ([2001:b07:6468:f312:e876:e214:dc8e:2846])
        by smtp.gmail.com with ESMTPSA id a10sm13273923wrm.52.2019.10.06.09.15.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Oct 2019 09:15:36 -0700 (PDT)
Subject: Re: [RFC PATCH 03/13] kvm: Add XO memslot type
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>
Cc:     "kristen@linux.intel.com" <kristen@linux.intel.com>,
        "Dock, Deneen T" <deneen.t.dock@intel.com>,
        "yu.c.zhang@linux.intel.com" <yu.c.zhang@linux.intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
 <20191003212400.31130-4-rick.p.edgecombe@intel.com>
 <5201724e-bded-1af1-7f46-0f3e1763c797@redhat.com>
 <9b885e65c3ec0ab8b4de0d38f2f20686a7afe0d0.camel@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <dc9ea270-489a-cd7c-fd68-26f22b5e49c6@redhat.com>
Date:   Sun, 6 Oct 2019 18:15:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9b885e65c3ec0ab8b4de0d38f2f20686a7afe0d0.camel@intel.com>
Content-Language: en-US
X-MC-Unique: R7cFIfhNMHyKFniNuA4psg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/19 21:06, Edgecombe, Rick P wrote:
> The reasoning was that it seems like KVM leaves it to userspace to contro=
l the
> physical address space layout since userspace decides the supported physi=
cal
> address bits and lays out memory in the physical address space. So duplic=
ation
> with XO memslots was an attempt was to keep the logic around that togethe=
r.
>=20
> I'll take another look at doing it this way though. I think userspace may=
 still
> need to adjust the MAXPHYADDR and be aware it can't layout memory in the =
XO
> range.

Right, you would have to use KVM_ENABLE_CAP passing the desired X bit
(which must be < MAXPHYADDR) as the argument.  Userspace needs to know
that it must then make MAXPHYADDR in the guest CPUID equal to the
argument.  When the MSR is written to 1, bit "MAXPHYADDR-1" in the page
table entries becomes an XO bit.

Paolo

