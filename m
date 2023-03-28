Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC8B6CCB30
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 22:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjC1UFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 16:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjC1UFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 16:05:34 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A380D8
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 13:05:33 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id l39-20020a9d1b2a000000b006a121324abdso5461919otl.7
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 13:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680033933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G6FEViEm4gU8JFCJ2RcfK27b9/P3kvs8pk7ugYHZuE0=;
        b=CAj5fUeBt+P1MSKUzcuWRJjggwGGZ+vYKqnFK/a54Ju3lhtya1J1ugBJg02KobtzFt
         8OHDRLAGnK49Hx7QJTS0AVwRdX7Fgmdsd4TKdXNs+tRx1/ptmc6RczIfzfYG5/SQfgj8
         3yEn2AMT2wn8RXg4V5X8ikI0vD9BjMhzdr7BJJg7VppGmJsLlEeQtJNrMNW3YiQ7MhWw
         I9lc1/2rFeHVLoby+T7rDtcRu/PIILyndSj2r3Mg1YHb38qobpZ6Tb053+pUuG1NTrX1
         HLs+ndyMV9XKJWk5lFtVD7mB4GS/LBjge8IN4uOyqfEQB43z9Rh8ajNCDdxjM5Irm013
         ut7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680033933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G6FEViEm4gU8JFCJ2RcfK27b9/P3kvs8pk7ugYHZuE0=;
        b=lIzaAZ2aUKPl5zN4Lg0cVGrH+G3aoZgye8br8xKKG1iWWH6dYJLWigXPZ/DIPoLcJt
         QxUV/bILqAVJAR8mCqutocvOanXu96uec80lm3uEF4MsK31Y5Md82dJLxc9e8AH/L1Xc
         +PJFXz65scNocedsuFz5lFlXB4A8UyY5uCA5aSVa0kHOOVXAjXFgq1jPWJOs7rZHYZVu
         FqxhkzUJcLmqUGtjyWSGUsr0F250Gz601jPdIQo4WKtp6r9iAFBbq4W/8iWZzgo3O0H7
         ionjvk42Q7N+sP9PqwEhJ6bpOcrMsH1I3jf3ez7ihoj2K4k1InbK4ObKxIZlf7h7TrPx
         HG0Q==
X-Gm-Message-State: AO0yUKVUpF3QYEHkXWjt+jL26BpMyG5KlyYqxgd8cdePvlsmxjhQaeml
        6rJGsSGepN/8VgGT396ahgTaQ8hbpqw2fizhoLKZlg==
X-Google-Smtp-Source: AK7set+9cVCFolZRcf/HkeMdzjRC+qu7Oe4WvcGrY+CXjpOPVRzgrslvflHbt6aKN8UoutEzxgbN5k5tngkpn/CeRpA=
X-Received: by 2002:a9d:7998:0:b0:694:3b4e:d8d7 with SMTP id
 h24-20020a9d7998000000b006943b4ed8d7mr8972612otm.0.1680033932848; Tue, 28 Mar
 2023 13:05:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
 <20230317050637.766317-3-jingzhangos@google.com> <861qlaxzyw.wl-maz@kernel.org>
 <CAAdAUtjp1tdyadjtU0RrdsRq-D3518G8eqP_coYNJ1vFEvrz2Q@mail.gmail.com> <87y1ngr89q.wl-maz@kernel.org>
In-Reply-To: <87y1ngr89q.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 28 Mar 2023 13:05:21 -0700
Message-ID: <CAAdAUtj=D1+6bscT-CS5naKfi=Z4bKZ5F+xnmpPR5zHPhDExKg@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] KVM: arm64: Save ID registers' sanitized value per guest
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023 at 12:22=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Tue, 28 Mar 2023 18:36:58 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Hi Marc,
>
> [...]
>
> > IIUC, usually we don't need a specific locking to update idregs here.
> > All idregs are 64 bit and can be read/written atomically. The only
> > case that may need a locking is to keep the consistency for PMUVer in
> > AA64DFR0_EL1 and PerfMon in DFR0_EL1. If there is no use case for two
> > VCPU threads in a VM to update PMUVer and PerfMon concurrently, then
> > we don't need the locking as in later patch by using the kvm lock.
> > WDTY?
>
> I think we generally need locking for any writable id-reg, the goal
> being that they will ultimately *all* be writable. As you found out,
> there is this need for the PMU fields, and I'm willing to bet that
> there will be more of those.
>
> And given that the locking you have used in some of the later patches
> violates the locking order (don't worry, you're not alone!), we need
> to use something else. Which is where Oliver's series comes into play.
Got it. Thanks for the details. I'll add locking based on Oliver's series.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
Thanks,
Jing
