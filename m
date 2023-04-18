Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5557A6E5F0A
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 12:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjDRKkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 06:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbjDRKkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 06:40:37 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81439E49
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 03:40:33 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id l17so7692730qvq.10
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 03:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681814432; x=1684406432;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1RICzLqGpFj+6kc7Hxj72J4OAx4rtz4rv6vLbjoi2tI=;
        b=jJPlRB/Wj4evgVW0EOh7MAoCNYa6HYfquSX/tqp0drBaj5ss/3QIzEicL5xTImNmmW
         Hx60uylsvg4FG15AuQHX8ZQAAM7yZg3t884U4V3UWAG6mEVUFu2qGRQm2j4RMijfll8z
         LgXWnOqWcuIK6yqdZy8yzwNNvZKLI161X18mwnsRiz3dEE7GXESscm1W4ponU6ltUlvp
         e487QO0PMCsnR27pp4e6nDsvdJUR4vm0fqJiCpjM4V2M2KRN0+vqVPYJDl7lZbU6+d1A
         V/dkGNc7WmyeSsXxP3NRS4Nhw3qgh9Ed76IQ4K+gIDvQa5lz/a7c6IJ5/Qc3ysxfDw6n
         av0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681814432; x=1684406432;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1RICzLqGpFj+6kc7Hxj72J4OAx4rtz4rv6vLbjoi2tI=;
        b=PWdx7e/w7jyTP/zrJFK77gawR1itUqMSAKZ7MjtTWm4LIeFAlWVehfPwOpgL9vYGE0
         89YAqca4I9oCzMqnR+x2+S/Wjo3+ji+QSEqrxl0ZcbFVEflAzAGKDmXxA0qogUcTsayu
         kNsh/3WG7TC/+ckiSQ4k4dceLDsRma0e8R5oIh7fYAGM+9HNcG1tS59oGrhrXlzlV6yI
         BMbWUVoOWKmY3DCvdlNp+XNV1OS5L5e190Rkzv3i28PjM8jmdigKPw+hWnbgx14wNSmU
         tm5871zJB4x9Ov8vMfQ30EVVdMMeD1QyabRaVIYwu9eP5Bh9orzEplcY1R35ZZlDcncK
         URcQ==
X-Gm-Message-State: AAQBX9dfhnFOce/obD3aZFU6cBXbcSOgZ0BHltMhpYz7OPOUKbgINWJk
        1NWNhT2g/OBCrH6O44n1JdvBuuuDR+qAvm1WwhsQmg==
X-Google-Smtp-Source: AKy350Z73E+UVOLSdcaZlZlGNZI85j5ghx52Ap7R83DyZk/Ctn8YFeYbh2x0TjQBhuqq7VxDhN6/mcJy0H4004Y91EM=
X-Received: by 2002:ad4:5ca2:0:b0:5ef:8b6e:5841 with SMTP id
 q2-20020ad45ca2000000b005ef8b6e5841mr6481997qvh.23.1681814432641; Tue, 18 Apr
 2023 03:40:32 -0700 (PDT)
MIME-Version: 1.0
References: <calendar-8e6a5123-9421-4146-9451-985bdc6a55b9@google.com> <87r0sn8pul.fsf@secure.mitica>
In-Reply-To: <87r0sn8pul.fsf@secure.mitica>
From:   =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Date:   Tue, 18 Apr 2023 12:40:21 +0200
Message-ID: <CAPMQPELUHZOT5sAZVFcNrMaCvyQit+q1cCFpHYc33+qZWPp9TA@mail.gmail.com>
Subject: Re: QEMU developers fortnightly conference call for agenda for 2023-04-18
To:     quintela@redhat.com
Cc:     afaerber@suse.de, juan.quintela@gmail.com, ale@rev.ng, anjo@rev.ng,
        bazulay@redhat.com, bbauman@redhat.com,
        chao.p.peng@linux.intel.com, cjia@nvidia.com, cw@f00f.org,
        david.edmondson@oracle.com, Eric Northup <digitaleric@google.com>,
        dustin.kirkland@canonical.com, eblake@redhat.com,
        edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com,
        eric.auger@redhat.com, f4bug@amsat.org,
        Felipe Franciosi <felipe.franciosi@nutanix.com>,
        "iggy@theiggy.com" <iggy@kws1.com>, Warner Losh <wlosh@bsdimp.com>,
        jan.kiszka@web.de, jgg@nvidia.com, jidong.xiao@gmail.com,
        jjherne@linux.vnet.ibm.com, joao.m.martins@oracle.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org,
        mburton@qti.qualcomm.com, mdean@redhat.com,
        mimu@linux.vnet.ibm.com, peter.maydell@linaro.org,
        qemu-devel@nongnu.org, richard.henderson@linaro.org,
        shameerali.kolothum.thodi@huawei.com, stefanha@gmail.com,
        wei.w.wang@intel.com, z.huo@139.com, zwu.kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Juan,

Sorry for the late reply, I won't be able to attend this afternoon's meeting.

Regards,

Phil.

On Thu, 13 Apr 2023 at 22:55, Juan Quintela <quintela@redhat.com> wrote:
>
>
> Hi
>
> Please, send any topic that you are interested in covering.
>
> [google calendar is very, very bad to compose messages, but getting
> everybody cc'd is very complicated otherwise]
>
>
> At the end of Monday I will send an email with the agenda or the
> cancellation of the call, so hurry up.
>
> After discussions on the QEMU Summit, we are going to have always open a
> QEMU call where you can add topics.
>
>  Call details:
>
> By popular demand, a google calendar public entry with it
>
>   https://calendar.google.com/calendar/event?action=TEMPLATE&tmeid=NWR0NWppODdqNXFyYzAwbzYza3RxN2dob3VfMjAyMjEwMThUMTMwMDAwWiBlZ2VkN2NraTA1bG11MXRuZ3ZrbDN0aGlkc0Bn&tmsrc=eged7cki05lmu1tngvkl3thids%40group.calendar.google.com&scp=ALL
>
> (Let me know if you have any problems with the calendar entry.  I just
> gave up about getting right at the same time CEST, CET, EDT and DST).
>
> If you want to be added to the invite, let me know.
>
> Thanks, Juan.
>
>
