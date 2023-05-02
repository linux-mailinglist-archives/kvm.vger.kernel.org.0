Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80996F3C4A
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 05:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbjEBDRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 23:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjEBDR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 23:17:28 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A085D2D63
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 20:17:26 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e9e14a558f8ab-32f4e0f42a7so21025ab.1
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 20:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682997446; x=1685589446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=54kBrp3Vxziw3p22iYsy8m0DYqII8po7wwHRfta3sxE=;
        b=Ppe5qQF6TRHU2nIyCgijoWIjJAkINKF58656oeV43ZXxy/2y492/bXFqsVmRD9Ocgt
         SvDIgac6/4m29/0MqoKdi4KksFGmvFRfTnFV8aKmZF/6yxV/AK4x1BWvVvzNE3ZTmbe3
         APdo8CPTYzumFC7Vb5EpHZEA6t7sX6TFQimkHuXHVAyaevvthy2xOgMt0LLnXFnzUSYQ
         HqtW0urQdFgjGVF0YM4xiSsDaekU/ZUin3PxewojFCAZSQTakBzZp7dipNR8vQORR/SD
         rceJfi4wZq9WC/myoYretpLZ7B+cC3b3+XP9TssdmNAJAJ1uQtPBNZSZ3uX25Njcnu+B
         b2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682997446; x=1685589446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=54kBrp3Vxziw3p22iYsy8m0DYqII8po7wwHRfta3sxE=;
        b=i3XA4N1s3Gfv7bVbXBeUSGh6N05TV0XNFN5N0nrhWlRIryym16CK7AbR78Pp0covJL
         A6yvR1sRyAd53klnhdk5KoZRiaKawEmYlx/S4w8LlZRRbeIgPyGtAEAH/lsHMGWPREO0
         R1eW/stgwkqO2kMxtASzmk5vZk5kQVpfPZxaymQfd2JG0Mnabz0KxSH3UC05HgYC/YUU
         eRhDshyXNl9S7xTaQHHGO+aVmlS5atDAHZxtADMyBwDuobFUaEtmkqZej7aO+4gbpHFL
         WwHeNpz0jklnvhJsAXvr3sDOpXnE1P5G1oppv3j9d9u2RJx2QmhjGEeGNCVsWZkRGFfO
         Aw6w==
X-Gm-Message-State: AC+VfDwRMH6Jd3kWAxe/aeSsyIYEubyv9g7Edk5EB11WxSNQrkdku6AF
        e0MRGmmF+FwS6T9dpOrLf3NtgZFHcIc5epgFEZ7soA==
X-Google-Smtp-Source: ACHHUZ6LIFxz5dLsSmtSCOZpHIw3rdAcVgD/Xg/g2WfJtJVSA+Yz00s61GgACaOSmXpGh8dKOPaH3VD35YwY8u6rL/c=
X-Received: by 2002:a92:c24c:0:b0:32a:db6c:d51d with SMTP id
 k12-20020a92c24c000000b0032adb6cd51dmr153225ilo.12.1682997445842; Mon, 01 May
 2023 20:17:25 -0700 (PDT)
MIME-Version: 1.0
References: <CANZk6aSv5ta3emitOfWKxaB-JvURBVu-sXqFnCz9PKXhqjbV9w@mail.gmail.com>
 <a9f97d08-8a2f-668b-201a-87c152b3d6e0@gmail.com> <ZE/R1/hvbuWmD8mw@google.com>
 <665d7fc9-5245-b63c-af6a-aae6ba9aabce@gmail.com>
In-Reply-To: <665d7fc9-5245-b63c-af6a-aae6ba9aabce@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 1 May 2023 20:17:14 -0700
Message-ID: <CALMp9eQRd+22_Pkv2FkPPdmKuH5TxJcG_q5eaTA_rQgeQn2Xyg@mail.gmail.com>
Subject: Re: Latency issues inside KVM.
To:     Robert Hoo <robert.hoo.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        zhuangel570 <zhuangel570@gmail.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 1, 2023 at 6:16=E2=80=AFPM Robert Hoo <robert.hoo.linux@gmail.c=
om> wrote:
>
> On 5/1/2023 10:51 PM, Sean Christopherson wrote:
> >
> > For the NX hugepage mitation, I think it makes sense to restart the dis=
cussion
> > in the context of this thread: https://lore.kernel.org/all/ZBxf+ewCimtH=
Y2XO@google.com
> >
> OK, wasn't aware of that thread. Thanks for pointing out.
> Just took a glance at it, I'll comment there.
>
>
> > TL;DR: I am open to providng an option to hard disable the mitigation,
>
> Why hard disable? Isn't already "nx_huge_pages" parameter sufficient for =
this?
> My aforementioned not-sent-out patch is to consider nx_huge_pages for
> creating the kthread or not, i.e. if nx_huge is enabled, start the kthrea=
d,
> if not, terminate the kthread; once re-enabled, spawn the kthread again..=
.
>
> > but there
> > needs to be sufficient justification, e.g. that the above 100ms latency=
 is a
> > problem for real world deployments.
> >
> Ah, I was objected by similar reason: the kthread does nothing if
> nx_huge_pages =3D false, it does no harm. Therefore I put the patch aside=
.
>
> For the justification from real world, I guess Zhuangel570 can say more.
>
> >> As more and more old CPUs retires, I think NX-HugePage code will becom=
e more
> >> and more minority code path/situation, and be refactored out eventuall=
y one
> >> day.
> >
> > Heh, yeah, one day.  But "one day" is likely 10+ years away.  Intel dis=
continuing
> > a CPU has practically zero relevance to KVM removing support a CPU, e.g=
. KVM still
> > supports the original Core CPUs from ~2006, which were launched in 2006=
 and
> > discontinued in 2008.
>
> OK, got it.
> Why does KVM still FULLY support so old CPUs? Any real world users? What'=
s
> the rational/necessity? even if it's already EOL by manufacture.
> My thought was that each new generation of CPU will linger in CSP's data
> center for 3~4 yrs.

Hobbyists drive the rationale for what kvm supports, not CSPs.
