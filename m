Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3442CA217
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 13:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgLAMGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 07:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbgLAMGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 07:06:17 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E712C0613D2
        for <kvm@vger.kernel.org>; Tue,  1 Dec 2020 04:05:36 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id k4so2893389edl.0
        for <kvm@vger.kernel.org>; Tue, 01 Dec 2020 04:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dZ8sExb6D1TJHHkVCOV6EAQsOL0RaMz69T7dbpfX3OM=;
        b=fXpGGIQs8SwHbjw4dhjwoo46nGqeg5DOxkqINklQ3TOUNuWu24XzRsMf7/mxf1cFzH
         MdYneBqpbJd6vRlM8hOsOSKsfCPvd9hGZxuL6lyYRThwg4+M48piLPWXlBCpsMOhfA47
         GnAJzJe+ryvwhQxytAzEE9SfI67xFI3CpWEVPUT0JClN1i+RU5DFsGaZ6yQYFssrJOXM
         IdlCN1H8b0R244egwcy9hESOG/aKZ10slkeF0HS/rMCzppf8QN5Jwla/kAEmSDEv0g1Q
         DU7y3cwW/ija3T7u/pAAjC+ukJW9xXUB1olMn4Jor9na4Xxrai+oxVjmpOir8TUnrABC
         nJ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dZ8sExb6D1TJHHkVCOV6EAQsOL0RaMz69T7dbpfX3OM=;
        b=rgNEx47N7CzyUkD/da48BBvaSrg1fvRKTl/G5ZlIZONl2Wz/zA1UhuY5qtPEqyflCM
         jBdjsunYiJXJ6iILsBxh5yu72GNdjaJxLwTDF2Dis5MfDfSQOADfHmnbOtPU9Aqy/TyW
         MTjUvKUFpqiigg2cJoLYHk7R9eXeWHU6FQTCJpZeHOu/xm38N86tU9M9pjoi9ezrK+01
         nvHduB5Rwz/apopYoFcNCCXqKUnZM/CHi2cTIZv2OxxxAHQgIYLjpyhO6qfHYeAOW7Jv
         ify+zl90lsP1JOj6tDH+csRK3RXf4dHuuvB70raraHEetygd9byQNL+cUoGb1HDX4o4w
         QK8Q==
X-Gm-Message-State: AOAM533IsGv4v5amOSN6Ut7zgM3wEYFO2M/x4ITVycC70HR7bW9MxgJJ
        vwY+ef+fmFf60jp47eyHOV2qAuIDvbnm8B3z87BQRA==
X-Google-Smtp-Source: ABdhPJyxpyeR1SDmXMFDnfu57acDSqOxPq2jB/wG3BKpbmbCQHhdjv1kxmHcygeEpB/gLMfQv/lQ4OZ8z85El5AEld4=
X-Received: by 2002:a05:6402:3089:: with SMTP id de9mr2689855edb.100.1606824335347;
 Tue, 01 Dec 2020 04:05:35 -0800 (PST)
MIME-Version: 1.0
References: <cover.1605316268.git.ashish.kalra@amd.com> <aa90b9f98f7314ae8c197a16e2acedbd29e16200.1605316268.git.ashish.kalra@amd.com>
In-Reply-To: <aa90b9f98f7314ae8c197a16e2acedbd29e16200.1605316268.git.ashish.kalra@amd.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 1 Dec 2020 12:05:24 +0000
Message-ID: <CAFEAcA8n353Zs_my_XsLv9+MS7UVo7Kx2Mm84cYrBQzAa_GHVA@mail.gmail.com>
Subject: Re: [PATCH 06/11] monitor/i386: use debug APIs when accessing guest memory
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, ssg.sos.patches@amd.com,
        Markus Armbruster <armbru@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Nov 2020 at 19:29, Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> Update the HMP commands to use the debug version of APIs when accessing
> guest memory.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  monitor/misc.c        |  4 ++--
>  softmmu/cpus.c        |  2 +-
>  target/i386/monitor.c | 54 ++++++++++++++++++++++++-------------------
>  3 files changed, 33 insertions(+), 27 deletions(-)
>
> diff --git a/monitor/misc.c b/monitor/misc.c
> index 32e6a8c13d..7eba3a6fce 100644
> --- a/monitor/misc.c
> +++ b/monitor/misc.c
> @@ -824,8 +824,8 @@ static void hmp_sum(Monitor *mon, const QDict *qdict)
>
>      sum = 0;
>      for(addr = start; addr < (start + size); addr++) {
> -        uint8_t val = address_space_ldub(&address_space_memory, addr,
> -                                         MEMTXATTRS_UNSPECIFIED, NULL);
> +        uint8_t val;
> +        cpu_physical_memory_read_debug(addr, &val, 1);
>          /* BSD sum algorithm ('sum' Unix command) */
>          sum = (sum >> 1) | (sum << 15);
>          sum += val;

Side note -- are byte-by-byte accesses to the encrypted guest
memory noticeably higher overhead than if we asked for a
larger buffer to be decrypted at once? If so and if anybody
cares about hmp_sum performance we might consider having it
work on a larger buffer at a time rather than byte-by-byte...

thanks
-- PMM
