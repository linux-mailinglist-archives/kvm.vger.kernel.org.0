Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC7170D946
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 11:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236241AbjEWJix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 05:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbjEWJiw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 05:38:52 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248E694
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 02:38:51 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id 006d021491bc7-5557e8f00ccso112113eaf.0
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 02:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684834730; x=1687426730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6z3lMGxH6Mz7+Fn/T4LYytMshUBzmp0MZ7SoDpV31I=;
        b=AMeKxWPLAfExFxJB/0pFuUFEiXN+50+SPDOH4XHy6mpSblEnrvX5T4wWHVkOgl2LP5
         wKCrtEhSYOeRjQVsEEAMbGheO6riK1oW2/ZbezvQrNFINT7x4ETrELaqjV6VRddeLoES
         7NKC8FBFPgJ5OTX8YbW5GFwVWTl0Uq7HiaIwakPUp1YU2svnE+zLhg/XSveCCReEKAVC
         hxo8s1qdeX09joUdCGs8jWtIrYgj5ppyUVS5wlS4gl2Iqda5R6VlUW7iSV/gIDGqVQZU
         2oJtnoMoEVZBeVDe9sF5nzsToRIjCrsINtx7ylnAYEmtAQf4jn+yxY9A6Jg66DOGtrHf
         8Y5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684834730; x=1687426730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N6z3lMGxH6Mz7+Fn/T4LYytMshUBzmp0MZ7SoDpV31I=;
        b=LJqzm42RjwMxjvai8XgvqdIDPf8zI+p7UdA+MFQxb4IUGcULb9tWJuYYfUG8Jzph1C
         Z3d3rIn0AsLeKQftm6N/XD1XeqkjL97LIvIO+6yl1CoaB8WpAL/5ueuG4EKdUoCAyzTW
         9Jwc92axS/kaswgFKmeG6MavAJ1qwhrZv3ApX2YhmhnfzeKFsJEtEiYzsBoS9n0pRS9x
         lrE0FpMPWo3YIBq9W4DaqFa/jnXCvxSrCjSd/Je4xzkLmygGM+zW37XbwoSzt3vO630u
         VS1kE5FqloPmpAbmWE8ImYuNl8xdGMIcbiDZw5vGjj6110o7Gfnt5AMyIIHCfXkFG3pI
         oFjA==
X-Gm-Message-State: AC+VfDxUfg9EQRxu61J9CEEYQpj+ZCn9pYkq6giS9l8M386FNfb36yma
        m2YNf/SjQMxBpu03RGrMD48td359kCxf78GeG2TR/Q==
X-Google-Smtp-Source: ACHHUZ590ivdXOBK8DVn/lntOQYNQicJN9rrix/NpCdyreZpkdnN9TcSNijcVkPKccvqAJg6nDXarvxDZKkcTuOZh9I=
X-Received: by 2002:a4a:92dd:0:b0:555:39b5:c7fc with SMTP id
 j29-20020a4a92dd000000b0055539b5c7fcmr3187082ooh.6.1684834730118; Tue, 23 May
 2023 02:38:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230505113946.23433-1-yongxuan.wang@sifive.com>
 <20230505113946.23433-2-yongxuan.wang@sifive.com> <20230505101707.495251a2.alex.williamson@redhat.com>
 <878rdze0fx.fsf@redhat.com>
In-Reply-To: <878rdze0fx.fsf@redhat.com>
From:   Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date:   Tue, 23 May 2023 17:38:40 +0800
Message-ID: <CAMWQL2gDRcawsLLVUpL5dV1nXGKBqWiE_6SSgOw8+ZgLjgO8rw@mail.gmail.com>
Subject: Re: [PTACH v2 1/6] update-linux-headers: sync-up header with Linux
 for KVM AIA support
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        qemu-devel@nongnu.org, qemu-riscv@nongnu.org, rkanwal@rivosinc.com,
        anup@brainfault.org, dbarboza@ventanamicro.com,
        atishp@atishpatra.org, vincent.chen@sifive.com,
        greentime.hu@sifive.com, frank.chang@sifive.com,
        jim.shu@sifive.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 8, 2023 at 3:39=E2=80=AFPM Cornelia Huck <cohuck@redhat.com> wr=
ote:
>
> On Fri, May 05 2023, Alex Williamson <alex.williamson@redhat.com> wrote:
>
> > On Fri,  5 May 2023 11:39:36 +0000
> > Yong-Xuan Wang <yongxuan.wang@sifive.com> wrote:
> >
> >> Update the linux headers to get the latest KVM RISC-V headers with AIA=
 support
> >> by the scripts/update-linux-headers.sh.
> >> The linux headers is comes from the riscv_aia_v1 branch available at
> >> https://github.com/avpatel/linux.git. It hasn't merged into the mainli=
ne kernel.
> >
> > Updating linux-headers outside of code accepted to mainline gets a down
> > vote from me.  This sets a poor precedent and can potentially lead to
> > complicated compatibility issues.  Thanks,
> >
> > Alex
>
> Indeed, this needs to be clearly marked as a placeholder patch, and
> replaced with a proper header sync after the changes hit the mainline
> kernel.
>

Hi Alex and Cornelia,

We found that the changes are from 2 different patchsets.

[1] https://lore.kernel.org/lkml/20230404153452.2405681-1-apatel@ventanamic=
ro.com/
[2] https://www.spinics.net/lists/kernel/msg4791872.html

Patchset 1 is already merged into mainline kernel in v6.4-rc1 and
patchset 2 is not.
Maybe we can split them into two placeholder patches?

Regards,
Yong-Xuan
