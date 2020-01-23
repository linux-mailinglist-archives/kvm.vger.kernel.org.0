Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3AE146BC0
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 15:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgAWOuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 09:50:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31119 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728057AbgAWOuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 09:50:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579791015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NBh4tFI6gPfbLyITAYbksh9Ljg6ViqUdmi8pBvTpn9E=;
        b=OtgNkvrMNodjZNexcpRthMuy5cXwgi4mMe7hBoUJuz1yNLdzFVrydxIxKBBRH7HCuTXJ8x
        +LOQTRCaHui2B8g48QiUjNif2oBiHz9Ao+pjUW71PdBZW9MPh4PYWUGloqyQCMWZF9AyN5
        S5fNRUg1K5d1HZTi6pbPpjzE2pI+LiY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-ki_f6cpPMvC7u7yOo3CvQQ-1; Thu, 23 Jan 2020 09:50:13 -0500
X-MC-Unique: ki_f6cpPMvC7u7yOo3CvQQ-1
Received: by mail-wm1-f69.google.com with SMTP id g26so718443wmk.6
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 06:50:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NBh4tFI6gPfbLyITAYbksh9Ljg6ViqUdmi8pBvTpn9E=;
        b=VSzkmDDXWLUJoxT1yEylyW/wy3MetRDW0u24ZTDAtnmP5XlKkQuSTcBg+YZUzrE+us
         vH86RDEEb2EJa/8Z3dk+xkmoZTq0xIYTDFuGhjT6iFEewz4jqjyQnQR3L0OR4o9I+MnC
         DSEPOxCuxF8h9XiDkMm1odFfwUr4gOjIXINtiUzylJH7jnZld/rUKel/IFue31NMPbSQ
         evHUTI5+37l+T6z/ffdGIrQj3Fwy8yIugOtOteM0VwSlfO64CgmeGzsSFG0mijGlrdk6
         GolpZmJLV4/O/BIe4DWLjq1u7tXaqfgm4VwGB2dkqXbUy4c5Yp73hXc3KZWm1MKmb5bV
         PAPA==
X-Gm-Message-State: APjAAAWgzYDV0MzLaxkTvguMdPq5yW41xEnX+rRyWwdMEfaNihDtShZp
        b2izTOK80PE+ylv48imRXFX9CkltpYpVqgLNePaqVDXKqU4u0A570MYlpl19dh5HtzfOt2wnXSX
        r5KQJ6yB7fbpj
X-Received: by 2002:a1c:62c1:: with SMTP id w184mr4641881wmb.150.1579791012617;
        Thu, 23 Jan 2020 06:50:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqyykVwQqjSnKlXsVDjKRpV7/uyZp8hQyj4SK7i/LXXKmogx7O6CSZiQeIzl3gC8Vp4TFhCWVg==
X-Received: by 2002:a1c:62c1:: with SMTP id w184mr4641836wmb.150.1579791012049;
        Thu, 23 Jan 2020 06:50:12 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id u188sm3070973wme.10.2020.01.23.06.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 06:50:11 -0800 (PST)
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     Alexander Graf <graf@amazon.de>, milanpa@amazon.com,
        Milan Pandurov <milanpa@amazon.de>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, borntraeger@de.ibm.com
References: <20200115134303.30668-1-milanpa@amazon.de>
 <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
 <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
 <ab84ee05-7e2b-e0cc-6994-fc485012a51a@amazon.de>
 <668ea6d3-06ae-4586-9818-cdea094419fe@redhat.com>
 <e77a2477-6010-ae1d-0afd-0c5498ba2117@amazon.de>
 <30358a22-084c-6b0b-ae67-acfb7e69ba8e@amazon.com>
 <7f206904-be2b-7901-1a88-37ed033b4de3@amazon.de>
 <7e6093f1-1d80-8278-c843-b4425ce098bf@redhat.com>
 <6f13c197-b242-90a5-3f53-b75aa8a0e5aa@amazon.de>
 <b69546be-a25c-bbea-7e37-c07f019dcf85@redhat.com>
 <c3b61fff-b40e-07f8-03c4-b177fbaab1a3@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3d3d9374-a92b-0be0-1d6c-82b39fe7ef16@redhat.com>
Date:   Thu, 23 Jan 2020 15:50:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <c3b61fff-b40e-07f8-03c4-b177fbaab1a3@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/01/20 15:45, Alexander Graf wrote:
> I think we're in agreement then, just leaning onto the other side of the
> same fence. My take is that if I don't know whether a string is
> necessary, I'd rather not have a string :).

And for me it's if I don't know whether a #define is necessary, I'd
rather not have a #define.  So yeah we agree on everything except the
userspace API (which is no small thing, but it's a start).

> I guess as long as we do get stat information out per-vm as well as
> per-vcpu through vmfd and vcpufd, I'm happy overall.
> 
> So how strongly do you feel about the string based approach?

I like it, of course.

> PS: You could btw easily add a "give me the string for a ONE_REG id"
> interface in KVM to translate from 0x10042 to "insn_emulation_fail" :).

That could actually be somewhat useful for VCPU registers as well (give
me the string and type, and a list of valid ONE_REG ids).  If that was
the case, of course it would be fine for me to use ONE_REG on a VM.  The
part which I don't like is having to make all ONE_REG part of the
userspace ABI/API.

Paolo

