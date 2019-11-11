Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBE7F7544
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfKKNpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:45:55 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22600 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726811AbfKKNpz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 08:45:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573479953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=lWbjR1o4iPs9dnY0AHIdujcnNAVDX3u32dRh1WZJnFY=;
        b=R+mglzbPGX2l6oFlNHUtgFxYar24BV4OYHRq8AZ13G3q3uEOlrARFgqavWa/hXqDJkXlJZ
        JbcxVB1mBBmkdbvzaxX16FsU80uyYW/AAT0rPzSostikAXKnqTQm17Gk3xEJSX01iOAJOh
        HSTf4GwPQzh6yInmqi5npQfN9QGqYzc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-mhHMYU7DNfGR4l1YD-FZFg-1; Mon, 11 Nov 2019 08:45:52 -0500
Received: by mail-wm1-f70.google.com with SMTP id x16so8377919wmk.2
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 05:45:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AMZ5Au6j1Jnx82n/wvRXqlQ2WII+db+cu7b3U/Or8ls=;
        b=E9F6TTRut/8ZRpcFoshTD5RUk6sJ93b6JPgKyTmWxQ/ZO3kLEcUMy8hPUk/jq2ZHux
         D9Di9ajfbBi08aAwCXkVJ9hte63Bj5kWH3hR63zAzfTaWGL6fI96z2NHGVqElHwdFlg6
         0J8TDNwOPN/vcujd+178zO3WlC63FNg5tKh8n72dora4J70Q7vG55OyyU1hUS1iJUCwT
         8a/0rRqnIXMxZk0XjYSVnh/5OQ8qD453/yGjUuaAY5iL+w5cQ2v+MfQTwGe1Q8YaVE3D
         8MYjZz94nkya9FUS8gZoio7HLPDNReBhU9Si0jrIX970CTr3JR0yRYMQ3lbbQ7RraGw8
         J/tA==
X-Gm-Message-State: APjAAAUVPexGSL0WgKwTP5slCdVBghX6GzWvmaoHJR+S/pyWLVSL6MBA
        aMePFzIMRt+/gWyDC5gnRFFBq/wcAOn6BZXYNzigTcm4Nkd/GZ2zDOC1rA3DXmmoAX+QF09vYcw
        QX0W9oFCxf9JJ
X-Received: by 2002:a5d:6203:: with SMTP id y3mr4496977wru.142.1573479950879;
        Mon, 11 Nov 2019 05:45:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqzKgFK9HgnPMtRCgGMYLljdTnnqZYIJzepx6HOCaRwxG0kjKA5Nmy8zlx6SiULjH6JkO+pVtg==
X-Received: by 2002:a5d:6203:: with SMTP id y3mr4496955wru.142.1573479950627;
        Mon, 11 Nov 2019 05:45:50 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id 19sm34097275wrc.47.2019.11.11.05.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 05:45:49 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: pku: fix parameter passing
To:     Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org
References: <20191025090329.11679-1-chenyi.qiang@intel.com>
 <20191025090329.11679-2-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <cc39325b-82ae-e6bd-cd20-74a7b2d30fe3@redhat.com>
Date:   Mon, 11 Nov 2019 14:45:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191025090329.11679-2-chenyi.qiang@intel.com>
Content-Language: en-US
X-MC-Unique: mhHMYU7DNfGR4l1YD-FZFg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/19 11:03, Chenyi Qiang wrote:
> Parameter error_code is passed in the function definition while
> the caller miss it. Fix it.
>=20
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>  x86/pku.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/x86/pku.c b/x86/pku.c
> index 62fb261..1ce73fa 100644
> --- a/x86/pku.c
> +++ b/x86/pku.c
> @@ -38,6 +38,7 @@ asm ("pf_tss: \n\t"
>      // no task on x86_64, save/restore caller-save regs
>      "push %rax; push %rcx; push %rdx; push %rsi; push %rdi\n"
>      "push %r8; push %r9; push %r10; push %r11\n"
> +    "mov 9*8(%rsp),%rdi\n"
>  #endif
>      "call do_pf_tss \n\t"
>  #ifdef __x86_64__
>=20

Currently harmless, but should be fixed.  I queued both patches.

Paolo

