Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379176A0083
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 02:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbjBWBQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 20:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjBWBQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 20:16:20 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CED76AD
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 17:16:19 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id j19-20020a05600c1c1300b003e9b564fae9so2436255wms.2
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 17:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACruxKNejY1sXBH2D6SAHOO/I8K6z+cEyI/uP3OdVLQ=;
        b=rXHrIyyIgAOG1TQ0RI3OmbHq/PpdTHXP+lSpuVviTpi4WBNyrTRPwN5YZ7dlCWDput
         oOgA26MutDrZw5FCC/JsXNXVxRGoaN0F/k7OLBfimzcK1b4IRakIS+BeB3rLA2GlKbcx
         QfMAJpD67t6K5yasK1mo56zU2sY7XBAWIkYjmVvlliGdsdfCqvqM317ZzU7tZld7Na03
         lSD7bfLoCFYhplpDpPQMZSTxmFhb1iQfJD/26QYiSoSlvB/dbDwKhSwQTBnr2nh5cV4i
         4+T9uCwHGJ/srZR+BW/vTaJzWzOUNFEy3kf2M1FUDeO1qg41JJjMGuntknkKf3p4HG/c
         E+OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ACruxKNejY1sXBH2D6SAHOO/I8K6z+cEyI/uP3OdVLQ=;
        b=d5eASbyBA/5CwAN9qkX+yfOY5dj33FTg+RFscSeRtMAXSh52qZbhJuJLljA72fXa/i
         vypk8Jw47Gb+pJZWVwjjwjNS7rORFwW77ugNd09PEIvk6DwxKMGoQUXI06W4b+kgm9Qc
         1AQW6fXahORdgHRawan5GU4Ivw3znrkChJqMQHivlG2nlTDjO7FLyKDaRbjkWf0jy+GL
         Fku7TFfQKLt3RGPY5LOdjrxfAks1ZQEAPX6bkxK2PYep6AOLfG2iNlOal72ZzG5hiyEm
         zRLb75ziyfWUeh0PaGnO6YAg7d7SO/FBStDO1K5bTlyzYpQHLVBOClrPAdUE9dnFdVjX
         FTDA==
X-Gm-Message-State: AO0yUKURAWz+04FXJqVtmuVquxFTpbCsoZZfJ2wMTpsAyV+ufXmMTCmr
        Sty/gjrqFi2w7g3AFXO1g5lW01df9vS0bWjJFqFtYQ==
X-Google-Smtp-Source: AK7set8lHxU0d80KxQe0PVvWY9UsJj6vGKnanrB6lTrTk+z5PUj+s5l9toLxbmscxhEUqNUdo3KSabmNbaetRlcaErs=
X-Received: by 2002:a05:600c:c16:b0:3e1:fb35:4247 with SMTP id
 fm22-20020a05600c0c1600b003e1fb354247mr1547498wmb.132.1677114977931; Wed, 22
 Feb 2023 17:16:17 -0800 (PST)
MIME-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-6-amoorthy@google.com>
 <87mt5fz5g6.wl-maz@kernel.org> <CAF7b7mr3iDBYWvX+ZPA1JeZgezX-BDo8VArwnjuzHUeWJmO32Q@mail.gmail.com>
 <Y+6iX6a22+GEuH1b@google.com> <CAF7b7mqeXcHdFHewX3enn-vxf6y7CUWjXjB3TXithZ_PnzVLQQ@mail.gmail.com>
 <Y+/kgMxQPOswAz/2@google.com>
In-Reply-To: <Y+/kgMxQPOswAz/2@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 22 Feb 2023 17:16:06 -0800
Message-ID: <CAF7b7mpMiw=6o6vTsqFR6HUUCJL+1MSTDUsMaKLnS1NqyVf-9A@mail.gmail.com>
Subject: Re: [PATCH 5/8] kvm: Add cap/kvm_run field for memory fault exits
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023 at 12:33=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote
> > > > I don't think flags are a good idea for this, as it comes with the
> > > > illusion that both events can happen on a single exit. In reality, =
these
> > > > are mutually exclusive.
>
> They aren't mutually exclusive.  Obviously KVM will only detect one other=
 the
> other, but it's entirely possible that a guest could be accessing the "wr=
ong"
> flavor of a page _and_ for that flavor to not be faulted in.  A smart use=
rspace
> should see that (a) it needs to change the memory attributes and (b) that=
 it
> needs to demand the to-be-installed page from the source.
>
> > > > A fault type/code would be better here, with the option to add flag=
s at
> > > > a later date that could be used to further describe the exit (if
> > > > needed).
> > >
> > > Agreed.
>
> Not agreed :-)
> ...
> Hard "no" on a separate exit reason unless someone comes up with a very c=
ompelling
> argument.
>
> Chao's UPM series is not yet merged, i.e. is not set in stone.  If the pr=
oposed
> functionality in Chao's series is lacking and/or will conflict with this =
UFFD,
> then we can and should address those issues _before_ it gets merged.

Ok so I have a v2 of the series basically ready to go, but I realized
that I should
probably have brought up my modified API here to make sure it was
sane: so, I'll do
that first

In v2, I've
(1)  renamed the kvm cap from KVM_CAP_MEM_FAULT_NOWAIT to
KVM_CAP_MEMORY_FAULT_EXIT due to Sean's earlier comment

> gup_fast() failing in itself isn't interesting.  The _intended_ behavior =
is that
> KVM will exit if and only if the guest accesses a valid page that hasn't =
yet been
> transfered from the source, but the _actual_ behavior is that KVM will ex=
it if
> the page isn't faulted in for _any_ reason.  Even tagging the access NOWA=
IT is
> speculative to some degree, as that suggests the access may have succeede=
d if
> KVM "waited", which may or may not be true.

(2) kept the definition of kvm_run.memory_fault as
struct {
    __u64 flags;
    __u64 gpa;
    __ u64 len;
} memory_fault;
which, apart from the name of the "len" field, is exactly what Chao
has in their series.
flags remains a bitfield describing the reason for the memory fault:
in the two places
this series generates this fault, it sets a bit in flags. Userspace is
meant to check whether
a memory_fault was generated due to KVM_CAP_MEMORY_FAULT_EXIT using the
KVM_MEMORY_FAULT_EXIT_REASON_ABSENT mask.

(3) switched over to a memslot flag: KVM_CAP_MEMORY_FAULT_EXIT simply
indicates whether this flag is supported. As such, trying to enable
the new capability
directly generates an EINVAL, which is meant to make the incorrect usage cl=
ear.

Hopefully this all appears sane?
