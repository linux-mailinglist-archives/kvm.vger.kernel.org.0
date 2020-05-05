Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FE01C5A57
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 17:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbgEEPBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 11:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729754AbgEEPB0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 11:01:26 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774DBC061A0F
        for <kvm@vger.kernel.org>; Tue,  5 May 2020 08:01:26 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id k133so2026184oih.12
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 08:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UaSaKrG1GYt5NqPeMxhEv2V8xLVBrsC2/RKAOBrJGC4=;
        b=QbR4WxF0hKDLAEH3Oz//DX0SVDNL6E6UirVQsQHs5pb3Ccr6GhcAc3G72Di+OLpGLT
         G8100kTvuXNr4qlHsIS/U9T0XgE726P/QzNpPyNcENKiylEgrFW7yGgdLJ4qXKlJwzgr
         K53LF5n+TGjhQNfgA4MyBMT6gtMru8TVf8B1wSuTwYYN0jmTh8Os/QqhRHH44QE1hfaH
         viUxMGg4nl9vhhoHev3K9+Og/yLrV6Lg7YvunCNvMecTYVAresU2NBHV8L+yMnRRgvp8
         DaO1aRmJfXXRDUhoNRSwQSw3oN4y6deUEtqDajN7iHPIXPaa6Jiy0ywZvGtIh647kIlx
         qiJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UaSaKrG1GYt5NqPeMxhEv2V8xLVBrsC2/RKAOBrJGC4=;
        b=c8v/cVWHIE4FsWpO06UW6RJQTiL7/PG0IdlD6DMvUoOHDFYij+i5/CrvoGqR0JvJOb
         fW5OS7kHWXnXLbz3pgJ4uBuz2MMBcyb8tDy/TsNIKYy/urTHmLh0l2oEhFS15lVO3JLD
         BccOmtdwUrLbyP9QmNh9d9TD4SnXMgRS+v5p41zkZewfzqoXSv4DUQcBZY7QnOeGuFEa
         gp3JNu6AzUYZ0BL1/n4Gy16VWoXPu/FdWHVoMUbL23Xh240W3toVUBztolnckMyjrbHI
         m69EQ/QJmoD9JGmlfgnIuYtIpotyC1lu/wcmQ4ckWgt26FsEa0cmJqfGr5opMX3dWIlK
         jWvQ==
X-Gm-Message-State: AGi0PuYu4zLAa65KVu52kX6GsQ+r0YqXakREbuiynrGMHtnMZG/7W61C
        QI7ylvSp82AGhlFc+REg25UOFr89ln+dBlWcZ5g=
X-Google-Smtp-Source: APiQypKTZBidHyFrlE/DfGbNYi/VGF2aLfmMQ/CYgNNxn3ltu79j+ylPtcqeVEWjuAka5gylS5YMqoxARQY445dv41Q=
X-Received: by 2002:aca:1709:: with SMTP id j9mr2700109oii.59.1588690885621;
 Tue, 05 May 2020 08:01:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAP4+ddND+RrQG7gGoKQ+ydnwXpr0HLrxUyi-pshc-jsigCwjBg@mail.gmail.com>
 <20200501150547.GA221440@stefanha-x1.localdomain> <20200504075845.GA2102825@angien.pipo.sk>
In-Reply-To: <20200504075845.GA2102825@angien.pipo.sk>
From:   =?UTF-8?Q?Anders_=C3=96stling?= <anders.ostling@gmail.com>
Date:   Tue, 5 May 2020 17:01:14 +0200
Message-ID: <CAP4+ddMZp29kWYG5NsB92caY0HYMrbjxV77Sb-MvdS7Tjh2pRA@mail.gmail.com>
Subject: Re: Backup of vm disk images
To:     Peter Krempa <pkrempa@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        kvm@vger.kernel.org, qemu-block@nongnu.org, libvir-list@redhat.com,
        John Snow <jsnow@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Peter and Stefan for enlightening me!

On Mon, May 4, 2020 at 9:58 AM Peter Krempa <pkrempa@redhat.com> wrote:
>
>  One thing to note though is that the backup integration is not entirely
>  finished in libvirt and thus in a 'tech-preview' state. Some
>  interactions corrupt the state for incremental backups.
>
>  If you are interested, I can give you specific info how to enable
>  support for backups as well as the specifics of the current state of
>  implementation.
>

I would very much appreciate if you can tell me more on this! It's for
a client, and I want to be as sure as possible that the solution is
robust.

Also, the wiki page referred by Kashyap is also something that I will
experiment with!

Thanks again folks!

Anders

--=20
---------------------------------------------------------------------------=
--------------------------------------------
This signature contains 100% recyclable electrons as prescribed by Mother N=
ature

Anders =C3=96stling
+46 768 716 165 (Mobil)
+46 431 45 56 01  (Hem)
