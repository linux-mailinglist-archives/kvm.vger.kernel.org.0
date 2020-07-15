Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22C0221749
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 23:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgGOVqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 17:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgGOVqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 17:46:55 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA70C061755
        for <kvm@vger.kernel.org>; Wed, 15 Jul 2020 14:46:55 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k5so2941170plk.13
        for <kvm@vger.kernel.org>; Wed, 15 Jul 2020 14:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PXD+UjMA6neqGTxFQJVOsL7bAyIy9uWpKeAjGre3Euc=;
        b=nVLsbuNUxboG//NR9omkSLNt3DTtADYGJrDWSCv3F5feYzADP2qOIPid1iqJim16Cd
         bDz9BwjHpeFILHWskWN1M9tDjwDJwY/LaQhhODoRT9ZCRpR5x15Fk2nL9Qdn/qodTWKP
         qhL9kZ2T4KzGRinw6QhZDyilc1cBHjkv6ALEoxsntxZK+JrKDcsXcAN1f/haYjxMzhA5
         GgAgzIYStbSQF8hecIHuoFHh6ZaKEmD9pz0ZTeegDH3jusIxa+OSCFWyDY7t/WIqqh0/
         NDCQGu9OqVynNdfbSOYjvNxJ0+fdtGoEDeojV6fGlFliET+EQzzbzm4QzpAJ6GZb3XlS
         l1Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PXD+UjMA6neqGTxFQJVOsL7bAyIy9uWpKeAjGre3Euc=;
        b=gf8VKDthtacEje7CdsQcyFGHRHU1ZwxqgdqLY8lXIrhHXPYJf7KJmWMwht0zIcCd83
         8BAZOqoPNhlm6Yi308yzfrvcDdXsjYmVMUQQHK7NXRasBOFn80nPvLBQbdQNUknOV5bI
         74x8wPbGBCGWDr428soOWLr//ZUUwf4WPbNVdNxIb79hhtrS+1URrzlbwHFCcXbn1sI2
         2Mr06mxt9C0kdWN39KAxvvhjnGjJXKIrjvG8FUS9B00qtFPvVxnLmPuFM2ejunMea+hP
         G8dlGDuAaVJEg/wuNHgRi/pF//RWU9rhU7ddyxME6C8tkO1HXa9RNCKdHVNQQfD87INX
         PL3Q==
X-Gm-Message-State: AOAM531lPOVu4XL+gNgbSZYOxmwTNf9SwPQ7KVrIV5gq4Ts/UkYdDe4c
        E88QQdFK0g99GH4W3t03dtU=
X-Google-Smtp-Source: ABdhPJxmwA8U1h5x6dRMxFFXeA13tlhdla8ZGBmka9/Rs/MMObCeACVbndRNYJxsYaSGbkDDQbDjxg==
X-Received: by 2002:a17:90a:780f:: with SMTP id w15mr1667205pjk.235.1594849614421;
        Wed, 15 Jul 2020 14:46:54 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:d804:e155:7b4c:bf3? ([2601:647:4700:9b2:d804:e155:7b4c:bf3])
        by smtp.gmail.com with ESMTPSA id b21sm2681568pfb.45.2020.07.15.14.46.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jul 2020 14:46:53 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [kvm-unit-tests PATCH] cstart64: do not assume CR4 should be zero
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200715205235.13113-1-sean.j.christopherson@intel.com>
Date:   Wed, 15 Jul 2020 14:46:51 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A0720822-B4F0-4AB6-98A2-2C4FD1124A95@gmail.com>
References: <20200715205235.13113-1-sean.j.christopherson@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 15, 2020, at 1:52 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> Explicitly zero cr4 in prepare_64() instead of "zeroing" it in the
> common enter_long_mode().  Clobbering cr4 in enter_long_mode() breaks
> switch_to_5level(), which sets cr4.LA57 before calling =
enter_long_mode()
> and obviously expects cr4 to be preserved.
>=20
> Fixes: d86ef58 ("cstart: do not assume CR4 starts as zero")
> Cc: Nadav Amit <namit@vmware.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>=20
> Two lines of code, two bugs.  I'm pretty sure Paolo should win some =
kind
> of award. :-D

I guess it is my fault for stressing him to push the changes so I can =
run it
on the AMD machine that was lended to me.

Reviewed-by: Nadav Amit <namit@vmware.com>

