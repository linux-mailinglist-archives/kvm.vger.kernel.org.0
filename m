Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C966C6AD2
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 15:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjCWOXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 10:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjCWOXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 10:23:16 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51080524F;
        Thu, 23 Mar 2023 07:23:14 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-54184571389so397938497b3.4;
        Thu, 23 Mar 2023 07:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679581393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l4v4CTT2r/FIXiskPxjJpRa5eGFyYIof0wcvwjvkOs4=;
        b=AJ9mUGZB57tkkNP5vPLcFkQaGpGRpxHceoJ5mv/RHO1hdT51GHJENYRouoPUEojYNX
         AukZLeaiD9OQjVUDOomqaOFVRKUTURXwn2JymqtdG2erXoO6NgwPU8UPXGQst4jhkiYN
         pFA6KXNANHkbLw4ggmRB10ydXMQGPDorEAegEqONV5Wj4UeZOGF6XD80J1ra4ieHyV+U
         LPBk8ypQ41TpzUbLlWIFhBk1xJuYS25HE6lNBZpXZyVG/q2wIQNb32dGRNGBZk4I0kpf
         bm7KBH3lVGbuCjagkjNRkRSlacw15mJcpQZm5GID5Woc4ssUCWNn+L7T07kTKaGlNOjt
         Ni0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679581393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l4v4CTT2r/FIXiskPxjJpRa5eGFyYIof0wcvwjvkOs4=;
        b=UY7lsuEuHbFPDfNyb+lLNlNf9uxRSB8LwVYMsFEcP8P9n/5mVbZddE9UWgjwoUeMfl
         lGFhav3CIpldEGPM805NgpA2RcljsFgSEuto3lmKpyy8RJVZh+x2x50L4lGSTp6dlIsl
         MFQojMFNXqq4PRkgOlqwcowoeeRcdILZzysSTDQPYK0o3OT3D8e868gjjGp7Mm/GT3Xh
         UT9cgz7uSMyay9sxCzh9GO5HhTGcYzIYcHeG5YRnDoBuHcW+CSoKIF94LzCYXi0l93CA
         yj7xkt2CKjgro0zuoTY15WWiKh1kE0uYy1TT7fCsOqv2k4Xb9wGmarv9i6H+vvov9A+D
         f6QQ==
X-Gm-Message-State: AAQBX9ereTaHNYePz/PeMEQw4Tim1yb1koeLd0APPinPwck1XLQODUeP
        KvteEtXzazjSOdYazSr/ChetkK8fT+KZAxtTww==
X-Google-Smtp-Source: AKy350ZYdN3NgKICo87hsztPejD84SAYDNMPP4jUqK38jUAeKu59vxvoX++VzH4xCHXNMTtkOwzL+l94JdeUdmITAzs=
X-Received: by 2002:a81:ed14:0:b0:545:62d1:4a86 with SMTP id
 k20-20020a81ed14000000b0054562d14a86mr1898405ywm.1.1679581393509; Thu, 23 Mar
 2023 07:23:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230321194008.785922-1-usama.arif@bytedance.com>
 <20230321194008.785922-9-usama.arif@bytedance.com> <20230322224735.GAZBuFh9ld6FuYEyoH@fat_crate.local>
 <70628793e6777d07f27f43152df497e780925d18.camel@infradead.org>
 <20230323085138.GAZBwTGly7iOlvxrD4@fat_crate.local> <4dbdd277c4b26ae4b971a910209a3279f79f6837.camel@infradead.org>
In-Reply-To: <4dbdd277c4b26ae4b971a910209a3279f79f6837.camel@infradead.org>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Thu, 23 Mar 2023 10:23:02 -0400
Message-ID: <CAMzpN2guz4HTQ8uir9Q=xrUpCYyBfuG2zGSJsakaqY7_OvxCPQ@mail.gmail.com>
Subject: Re: [PATCH v16 8/8] x86/smpboot: Allow parallel bringup for SEV-ES
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Usama Arif <usama.arif@bytedance.com>, tglx@linutronix.de,
        kim.phillips@amd.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, arjan@linux.intel.com, mingo@redhat.com,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, Sabin Rapan <sabrapan@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023 at 5:04=E2=80=AFAM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
> On Thu, 2023-03-23 at 09:51 +0100, Borislav Petkov wrote:
> > On Thu, Mar 23, 2023 at 08:32:49AM +0000, David Woodhouse wrote:
> > > and maybe find some other stuff to cargo-cult to make it safe to run
> > > C code that early...
> >
> > I'm trying to have less shit asm, not more if possible. We've been
> > aiming to convert stuff to C for years.
>
> Absolutely, I understand. There are a few hoops we have to jump through
> to be able to run C code this early, but it's worth it.
>
> > WTF are you calling cargo-cult?
>
> Off the top of my head, I don't actually *remember* all the hoops we
> have to jump through to run C code this early.

Making sure that the stack protector is either disabled or properly
set up, and disabling any instrumentation/profiling/debug crap that
isn't initialized yet.

--
Brian Gerst
