Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4262D1FBD
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 02:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgLHBK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 20:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgLHBK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 20:10:56 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D40C061749
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 17:10:16 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id q22so12196710pfk.12
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 17:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=bx+Vl9JgF8W82HQw1BgvFlKwvrUO3IJ4Z04ne+ReaG4=;
        b=qrXFRqBLDPe3SQUDL3CpcpyB8yQ6rHGKTyWs37WyGOgtMZl8UJqrcXFZ4ub+YWypmr
         unqXAFz9d20X8wzNgj8bXq+B2z7MprIIxTsppzuf6Yj/A+pcVKUg4tY6LsY6JJmWXm8K
         FEeoKmezQd4vxJqO+dm84hibvlQUIHx3PUUA7jY2V0fwVx6yeLGbPD/okfgmtjamO9xp
         qg+hvdVgkJlfPuEcAnHp/LzF2sRL+Z8uXrugr3QmbOYBfd0B+ykoQoy/Wf1HGzw5QyV8
         6vRW8Wu7Ku6b0Qt6CSkbDiMF5sC/T+daih3YvP0JNL9lauVxzrALP2AopoosvbLAQ+bK
         9jeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=bx+Vl9JgF8W82HQw1BgvFlKwvrUO3IJ4Z04ne+ReaG4=;
        b=QLpyNfHv122nEWTEeczwVNihJjkibR25PG8xixDr8VQBUAfFwZCNeiJTNelCBGHm0X
         ePRCnDoVHgQVsWJculF8bjjqJCduYh6nwcEZ0RU41uU8p5fC23BpsNlM80z5OGPa9cH3
         KMcZv3y5+4KSx62nUnsGlL1sg0wzDjU0Jg1iBEhDo+IlZEnpS6b7k4S8SFCSfp0aU89j
         aX5KdYOe/BG6XY5LEaFZss7zYuN5eLygVgRsq9Reb98xyzk4uWMqg8DwgguBW8SOdkfh
         cooCdSP7yxaz4f7Pbpn2Zd6iH1FajsTb3kjTv/lh98si4/Mi6j7dm1Ozoz0E+E208yJa
         akYA==
X-Gm-Message-State: AOAM530f2wji7cHpKEFTo+uDXxooigzBvVUz80LFzB0Z1Tsr3afuxcM3
        pS4xYQ9dqE+7H/zNHIeBUBbgkI3VVW8PrQ==
X-Google-Smtp-Source: ABdhPJwLnrbSkaa4eig0JC6Eonm8lMdBywQWTmDBY1otaJoYE1K4enYCTD0xAUmv4T74hZRNd+YmNg==
X-Received: by 2002:aa7:8014:0:b029:197:cd5c:3e6b with SMTP id j20-20020aa780140000b0290197cd5c3e6bmr18171607pfi.21.1607389815579;
        Mon, 07 Dec 2020 17:10:15 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:5c98:e5b3:1ddc:54ce? ([2601:647:4700:9b2:5c98:e5b3:1ddc:54ce])
        by smtp.gmail.com with ESMTPSA id x22sm12491563pfc.19.2020.12.07.17.10.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Dec 2020 17:10:14 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib/alloc_page: complete rewrite of
 the page allocator
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com>
Date:   Mon, 7 Dec 2020 17:10:13 -0800
Cc:     KVM <kvm@vger.kernel.org>, pbonzini@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <11863F45-D4E5-4192-9541-EC4D26AC3634@gmail.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <20201002154420.292134-5-imbrenda@linux.ibm.com>
 <C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Dec 7, 2020, at 4:41 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>> On Oct 2, 2020, at 8:44 AM, Claudio Imbrenda <imbrenda@linux.ibm.com> =
wrote:
>>=20
>> This is a complete rewrite of the page allocator.
>=20
> This patch causes me crashes:
>=20
>  lib/alloc_page.c:433: assert failed: !(areas_mask & BIT(n))
>=20
> It appears that two areas are registered on AREA_LOW_NUMBER, as =
setup_vm()
> can call (and calls on my system) page_alloc_init_area() twice.
>=20
> setup_vm() uses AREA_ANY_NUMBER as the area number argument but =
eventually
> this means, according to the code, that __page_alloc_init_area() would =
use
> AREA_LOW_NUMBER.
>=20
> I do not understand the rationale behind these areas well enough to =
fix it.

One more thing: I changed the previous allocator to zero any allocated =
page.
Without it, I get strange failures when I do not run the tests on KVM, =
which
are presumably caused by some intentional or unintentional hidden =
assumption
of kvm-unit-tests that the memory is zeroed.

Can you restore this behavior? I can also send this one-line fix, but I =
do
not want to overstep on your (hopeful) fix for the previous problem that =
I
mentioned (AREA_ANY_NUMBER).

Thanks,
Nadav=
