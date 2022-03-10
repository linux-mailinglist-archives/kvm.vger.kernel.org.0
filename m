Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679B14D4FEA
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 18:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244244AbiCJRIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 12:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbiCJRIN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 12:08:13 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EA5155C33
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 09:07:12 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2dc348dab52so65467797b3.6
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 09:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bcEebaUL39OgBCQ1yEdv6Pu33/nVpkRgxFeI5vk+Fpg=;
        b=eWt/zXKRQRlURrm8veq/SlkRyHnxWxhEMwojwMMXNpt0ZnvEHxjwNMkAMB1nQMzKqP
         arn6y3hmVsw3jYWKG6D1uLMM/5RbIRIZwLLj3NXJYYlKSjuZfyg6tql7xwPhk9W7aGSx
         vFatBMU+/kskQoVUJZxyc4a3VFVm9pU6FnFKIQW6FGbJzIsqV4C+Lz6hxpSlZk9RZSpO
         u2qTxgtvhBIQB0Qblm737dAueZJNV1uYSfVKbokxSayTMfHin4DZC5UU/Xfg8kHECI5J
         qFyHk8/rp9gJrUKE/ONDDY6RebKsWEge1IFIL2F/8X5aJB32k4qZxQATIL5RnZR2IuFv
         /HeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bcEebaUL39OgBCQ1yEdv6Pu33/nVpkRgxFeI5vk+Fpg=;
        b=FXY1W6IcLSiCbw8cB3qjUcjKcWteAo0Et+42JGXxQAvAmVkP/ITmgfpXaqboQ4LROh
         h4EbqAoNU37DoMVj1Z2rLX/6vwDd8gPc3cv2xe/RMEDPuHHk6OUOhX4lq8lBOs1mXzCW
         /Z84cyPkquWtuVMCc1Dy2dELtn4ByD7r+lX6ISSpM+QDRLZJ6KuPrefRlkc7WK9PPIz4
         U8v6+k5yuXeszBMhIE0I79rvhCxNTNWEzmJ38d7vHLRAYtz2QfFYuo+wSJLoeQhEMwVj
         qCfxo/IxxnDcWCDSWJ7sEcCniaPAoKvMg6A4qKTfYTLHvCmYW6DFHt8araUGKuZXCbYE
         X/0w==
X-Gm-Message-State: AOAM530MiEQDkqfq1NH3XQcGFRlc4FW4RsA1d3zw1cPND4fn/0m7M5Eo
        wn8bPOn2IK5gq8OfCxikrGRjHEL81SnyJ6ucgpL84Q==
X-Google-Smtp-Source: ABdhPJz+CYUZ1IcJ3KdfYeFHYK86DgS5pAMGHdSCw/Ygtw+M3YaSnOXst0jMsKDaoq1ET7uuinPfNM9ANQZCjeSZzrU=
X-Received: by 2002:a81:5389:0:b0:2db:6d7a:93ca with SMTP id
 h131-20020a815389000000b002db6d7a93camr4932967ywb.11.1646932031522; Thu, 10
 Mar 2022 09:07:11 -0800 (PST)
MIME-Version: 1.0
References: <20220310164532.1821490-1-bgardon@google.com> <20220310164532.1821490-8-bgardon@google.com>
 <CABOYuvY8sJgzC2VA=i4gddDu=jZCffFNi5E4G2cJ2B01zg3XcA@mail.gmail.com>
In-Reply-To: <CABOYuvY8sJgzC2VA=i4gddDu=jZCffFNi5E4G2cJ2B01zg3XcA@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 10 Mar 2022 11:07:00 -0600
Message-ID: <CANgfPd_=5=Xey14N4=46_dKYHnmmMn=yJFep7M44wE9czCz5dw@mail.gmail.com>
Subject: Re: [PATCH 07/13] selftests: KVM: Add NX huge pages test
To:     David Dunn <daviddunn@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 10, 2022 at 10:59 AM David Dunn <daviddunn@google.com> wrote:
>
> Ben,
>
> Thanks for adding this test.  Nit below.
>
> Reviewed-by: David Dunn <daviddunn@google.com>
>
> On Thu, Mar 10, 2022 at 8:46 AM Ben Gardon <bgardon@google.com> wrote:
>>
>>
>> +       /* Give recovery thread time to run */
>> +       sleep(3);
>>
> Is there any way to make this sleep be based on constants which control t=
he recovery thread?  Looking at the parameters below, this seems excessive.=
  The recovery period is 2ms with a 1/1=3D100% recovery ratio.  So this is =
padded out 1000x.  Maybe it doesn't matter because normally this test runs =
in parallel with other tests, but it does seem like a pretty large hardcode=
d sleep.

Woops, I meant to make the recovery period 2 seconds, which would also
be preposterously large. We absolutely can and should tighten that up.
100ms recovery period and 150ms sleep would probably work perfectly.
I'll make that change if/when I send out a v2.

>
> Dave
