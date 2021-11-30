Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967AD463CAB
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 18:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbhK3RZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 12:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbhK3RZk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 12:25:40 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD35C061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 09:22:21 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so31182001otj.7
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 09:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IBelZDFQmpXLYLVZg/fvEG9q4sQls5EMs7G1JYqfnrI=;
        b=jaUb7GuzZKYFBlUWG+yjB7RX+dS/0DwLnfaOqQJ6Vv21vSRZt3oRofA6wWx24IhEjH
         TSBB+m4tSRYZe11c4rblcwMuj+n4/vR9Mafo0EO6Gzz4GwLKgX5YBIu2MlbSWUo9wjDq
         vCONRfxcptS8B1HM0ypsbkvTlj9ALWgeFJpwjF3tNl3k5OrRNSJbg0HahMgo2WOw6ZMU
         7yKiLN3gbp2OmxC0QY9JHKMAFiUw8qEOdKyxKO4ExIdf/i8nEtPTVYoiCN9XyTKxK9H6
         pky3X1GfgOWlqD3wQNg/XQxLGvqPR6zwSJWygHPMAMUIN+DWhqp/BmBLhHnpBF4fIjuD
         EcsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IBelZDFQmpXLYLVZg/fvEG9q4sQls5EMs7G1JYqfnrI=;
        b=cv9+7DbsuF8CO+9Zce6R4Cln+TthmlbDa9Zbah06OChvXsdATTbQ8icM3IPPYTd7oB
         qFNgaF+NHhCWMsmWKisYxZHOIN8iqSuqRtg+uLSH5kQ7HuVn8v/Yb9lIb27Lpk32nSJj
         18I5mqekodcTnFdfEW85PXsROkg8SjeHM7dauf+iU7e5mVRG/TAXt7+Ec2UCBQQNpOxG
         aL+FyGvN7QNLD5BdgWLmi7Umpxs+a5N34cligttSHKpc/TH3PyEIAVh45iaJoR+8vxkV
         iplh9xFD0cE3b9vNS0Vr0ZZMsQdYrrjHC0370QcufVFVdsKPpv8JRAQa5qR+J7AnH0SU
         xo2Q==
X-Gm-Message-State: AOAM532Z3ExaLoloMji9xzzuPi6alt3VHtGO3S6NsWM9H0wPfVzSYHym
        RGAbY4ZtlwSFUd7Y3BXYOIcdrSqD3GRcXzr/Ez64sw==
X-Google-Smtp-Source: ABdhPJwQOm/FPm8yQjAg6N+aIfojNgsWG9vHuLIk2bSejiFdKmmR+5IoCUD4KTVKVcTCq8bq/pdR+suc9q76doUnV1U=
X-Received: by 2002:a9d:ed6:: with SMTP id 80mr535957otj.35.1638292940486;
 Tue, 30 Nov 2021 09:22:20 -0800 (PST)
MIME-Version: 1.0
References: <20211021114910.1347278-1-pbonzini@redhat.com> <20211021114910.1347278-2-pbonzini@redhat.com>
 <CAA03e5FX+C9BaN9VeJAVjLSN0_DknTv5PB0+Q_cmpk1t3a0uJg@mail.gmail.com> <7a6d3027-4ce6-87eb-b490-0f2f0d79655b@redhat.com>
In-Reply-To: <7a6d3027-4ce6-87eb-b490-0f2f0d79655b@redhat.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 30 Nov 2021 09:22:09 -0800
Message-ID: <CAA03e5Hs18UmjkvSrojJkYvBNDGZhEWN7NT-nybTA1OUbFmkJQ@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests 1/9] x86: cleanup handling of 16-byte GDT descriptors
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, aaronlewis@google.com, jmattson@google.com,
        zxwang42@gmail.com, seanjc@google.com, jroedel@suse.de,
        varad.gautam@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 2:55 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/29/21 22:46, Marc Orr wrote:
> > I think this patch series was what was blocking the `uefi` branch from
> > being merged into the `master` branch. I was just trying to apply it
> > locally, so I could review it, and now see that it's been merged
> > already.
>
> Yes, Aaron used it in some patches of his so I took that as a review.

Makes sense.

> > Any reason not to go ahead and merge the `uefi` branch into
> > the mainline branch?
>
> Mostly the fact that "./run_tests.sh" does not work out of the box.

Ack. The recent patch set posted by Zixuan [1] makes "./run_tests.sh"
work out of the box.

[1] https://lore.kernel.org/all/20211116204053.220523-1-zxwang42@gmail.com/
