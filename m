Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FBB2D1F2D
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgLHAmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbgLHAmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:42:01 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBF6C061794
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:41:21 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id q22so12125405pfk.12
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8kGr/d02PkmC1obWtw7/7DzMYLhgfhYUhVl//Foo/Kg=;
        b=aF+FGr8Y+UH3OyIPKLNp+dik3pxFlL3lzU9m1V+oh1XUNMjamYT1cxB+ZH608TCY06
         92iYhIHPLlGxDkV9QhG39wAhZ/dMwyjX1+LYA/D/NU90ZrnYePUq7JH6SzLjflG9AQxE
         MzyiOUPcYWi8gyRDhabv/Z8LUATsWeGOhSz/GAB4VeO0B7rZoaBJkP1Y6vtf+FOv8Yyf
         mcCSv+WM+ePtgU+4zaENa6YD2lqvTLARx2dgGyTUIdQ2/rCRF3wZjrUNvsYB1JnFy1Zk
         /X5+E6Ww/YzfzKeBKy1MpO3lEtn9sPZ3ndGTRbJfnaU5ysQt2/TyphSEeYjAgg5PFoPJ
         qJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8kGr/d02PkmC1obWtw7/7DzMYLhgfhYUhVl//Foo/Kg=;
        b=kmonACB/Ku0Q85arq/HOzxoQR3ZqmPDE/gJkzIZ6mthJc7p9SaYYeZNirxNLyHynlO
         mcYREpfqeVM+K3LgX4nsZ2Z0i+3pqxUdhnAPVv/OPmdrMF47pDIVq6pd2oZ1qgEGZq/E
         TnKlF5m/ihmeNGMDHM6Os/Ae9eLW0CKdUvysgF68LMY/Q2JSUMD3QNr/iUbhvCBjgYQB
         E7LbKDsywvcFwYPNfJ/IfIomSja0ydXsZrZJzPs6eCVYwUI+lsWuW4CKrubzlm5wUUd9
         DLq8YuDsenuy10Epp/f+gLWewgd3UKwiZb3mP+nu+EK8KWjRFGrxduIxWo1ARpMd5BWh
         DV0A==
X-Gm-Message-State: AOAM531ng5fAJWh9BkiaMp5VI6Byz5a4sGv8Xi+dKtwgogkczGs75yn2
        uMBrd/+fNPVgwL4KqaqkMec=
X-Google-Smtp-Source: ABdhPJzmYYnq+KisHK8ynAyOKfKMyaZqpdzEq4ezBo+7BCnSmUuy63tOMzKxowqjl97rs7EFlZ6LhA==
X-Received: by 2002:a62:cd0d:0:b029:18b:a1cc:a5be with SMTP id o13-20020a62cd0d0000b029018ba1cca5bemr17926025pfg.67.1607388080945;
        Mon, 07 Dec 2020 16:41:20 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:5c98:e5b3:1ddc:54ce? ([2601:647:4700:9b2:5c98:e5b3:1ddc:54ce])
        by smtp.gmail.com with ESMTPSA id gz2sm567120pjb.2.2020.12.07.16.41.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Dec 2020 16:41:20 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib/alloc_page: complete rewrite of
 the page allocator
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20201002154420.292134-5-imbrenda@linux.ibm.com>
Date:   Mon, 7 Dec 2020 16:41:18 -0800
Cc:     KVM <kvm@vger.kernel.org>, pbonzini@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <20201002154420.292134-5-imbrenda@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 2, 2020, at 8:44 AM, Claudio Imbrenda <imbrenda@linux.ibm.com> =
wrote:
>=20
> This is a complete rewrite of the page allocator.

This patch causes me crashes:

  lib/alloc_page.c:433: assert failed: !(areas_mask & BIT(n))

It appears that two areas are registered on AREA_LOW_NUMBER, as =
setup_vm()
can call (and calls on my system) page_alloc_init_area() twice.

setup_vm() uses AREA_ANY_NUMBER as the area number argument but =
eventually
this means, according to the code, that __page_alloc_init_area() would =
use
AREA_LOW_NUMBER.

I do not understand the rationale behind these areas well enough to fix =
it.

Thanks,
Nadav=
