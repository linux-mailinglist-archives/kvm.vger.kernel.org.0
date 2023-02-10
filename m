Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A966920DC
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 15:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjBJOdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 09:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbjBJOdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 09:33:17 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754AE5B764
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 06:33:14 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id s8so3799716pgg.11
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 06:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EoyqZuT2eCQbPBzisd4AEJrjYx9W/vK3n0wiOZhNzwM=;
        b=J6OyvW6DQadZOtUPSG+XjxWB9VyVd+gqG78TiO9GUcBNUb7yEloVmE6YTkseT4/UJT
         mW4fMVkIeT3P6ISy1YuX6HpqyqvtMcoBxzANucFTLomhFhGO4m0y1gVAy6ZfA75t4soV
         cP/cmBD5rm3W8VINPO0VoyUAXLoberlBTck6EG+9dlPyy53AX9kw5hPTjrGAGcZO8fF0
         wHFZ1319fthomq7D4esrcg+JafzRlySnfKCclXwFlr6hT+Ed+SJnqqnPv5PvA81bF2WG
         A0Qlvd6nwqa3Mue8dAgkVU3wkK0Y2P418xY/GAIFmkrYmJczzFiFV+3Wy9X8uHzgC8uL
         5TeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EoyqZuT2eCQbPBzisd4AEJrjYx9W/vK3n0wiOZhNzwM=;
        b=myB/A/Is5/Ac8qjTN4C98ZrrkVd8BOe1aQb6sD20WoqjtTCQ6tWoiO0ttvS7Unl3hx
         jObNRfMZLhYzB3wymBwrFJionmaPJvlvILEbLgmTCMZk4GgNWExrYCYZ+2NkAcgsG+Rs
         jc/zYJEMA0qNP0KZqcWmeRqQFw8J8CFRd/+WbalIXbmJVVzZG3qCZ47p1QiBRqd1dxJr
         IMRQgNGM3+e/feOLb4qU2STwAjCCI3DtlB7vzLsySl5YnbdkvWw24+3BZSoTISOnm+Vr
         pXYe8aNOLzqZopuRV5b+5Y5K6p4pc+OV5lP+UV44EoHLfLLK6r29PBBlqKAXe0wXBiLy
         0haw==
X-Gm-Message-State: AO0yUKXNj2wOTYzq8JrtK8yz9Wam/OzcE6GlDKWuz0zf1WZXvpoHGEZU
        v1t/ahVmk8PRcIl89kgwzBGEFmbuoTcjB0mGGS+HVQ==
X-Google-Smtp-Source: AK7set/FMf5yUm3tbCiiAP0QwzvkRjvitzWezf0+tWQKOdceyVyld22nLwm8RRo8cU9hraWQ+y0cWAcVHw11vKovaNc=
X-Received: by 2002:a62:53c6:0:b0:58d:a84a:190b with SMTP id
 h189-20020a6253c6000000b0058da84a190bmr3361718pfb.48.1676039593895; Fri, 10
 Feb 2023 06:33:13 -0800 (PST)
MIME-Version: 1.0
References: <20230209233426.37811-1-quintela@redhat.com> <CAFEAcA-qSWck=ga4XBGvGXJohtGrSPO6t6+U4KqRvJdN8hrAug@mail.gmail.com>
 <87r0uxy528.fsf@secure.mitica>
In-Reply-To: <87r0uxy528.fsf@secure.mitica>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 10 Feb 2023 14:33:02 +0000
Message-ID: <CAFEAcA-SOpRiX+s14OxCJ+Lwx6kzUdroM9ufugzTVLM9Tq2gHA@mail.gmail.com>
Subject: Re: [PULL 00/17] Migration 20230209 patches
To:     quintela@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Feb 2023 at 14:21, Juan Quintela <quintela@redhat.com> wrote:
>
> Peter Maydell <peter.maydell@linaro.org> wrote:
> > Fails to build the user-mode emulators:
>
> This is weird.

> > https://gitlab.com/qemu-project/qemu/-/jobs/3749435025
> >
> > In file included from ../authz/base.c:24:
> > ../authz/trace.h:1:10: fatal error: trace/trace-authz.h: No such file
> > or directory
> > 1 | #include "trace/trace-authz.h"
>
> This series only have one change for traces:
>
> diff --git a/util/trace-events b/util/trace-events
> index c8f53d7d9f..16f78d8fe5 100644
> --- a/util/trace-events
> +++ b/util/trace-events
> @@ -93,6 +93,7 @@ qemu_vfio_region_info(const char *desc, uint64_t region_ofs, uint64_t region_siz
>  qemu_vfio_pci_map_bar(int index, uint64_t region_ofs, uint64_t region_size, int ofs, void *host) "map region bar#%d addr 0x%"PRIx64" size 0x%"PRIx64" ofs 0x%x host %p"
>
>  #userfaultfd.c
> +uffd_detect_open_mode(int mode) "%d"
>  uffd_query_features_nosys(int err) "errno: %i"
>  uffd_query_features_api_failed(int err) "errno: %i"
>  uffd_create_fd_nosys(int err) "errno: %i"
>
> Rest of trace mentions are for the removal of migration.multifd.c.orig
>
> And I don't play with authentication at all.
>
> This is Fedora 37.
>
> > https://gitlab.com/qemu-project/qemu/-/jobs/3749435094
> > In file included from ../authz/simple.c:23:
> > ../authz/trace.h:1:10: fatal error: trace/trace-authz.h: No such file
> > or directory
>
> Problem is that this trace file is not generated, but I can think how
> any change that I did can influence this.
>
> > 1 | #include "trace/trace-authz.h"
> >
> >
> > https://gitlab.com/qemu-project/qemu/-/jobs/3749434963
> > In file included from ../authz/listfile.c:23:
> > ../authz/trace.h:1:10: fatal error: trace/trace-authz.h: No such file
> > or directory
> > 1 | #include "trace/trace-authz.h"
>
> Looking at the ouptut of these, they are not informatives at all.
>
> I am going to try to compile linux-user without system, and see if that
> brings a clue.

Yes, I suspect this is a "user-mode only build" specific failure
(you may need --disable-system --disable-tools to see it).

meson.build only puts authz into trace_events_subdirs "if have_block"
(which is to say "if have_system or have_tools"). However the
bit of meson.build that says "subdir('authz') does not have
the same condition on it -- it's just been put in the list without
any condition on it. So I think that in a build-only-user-emulators
config meson will not generate trace events for the subdirectory
but will try to build it, which falls over.

Contrast 'block', 'nbd', 'scsi', which are all guarded by
'if have_block' for their subdir() lines, to match the guard on
the trace_events_subdirs. OTOH 'io' is also mismatched-guards...

Why this only shows up with your pullreq I have no idea.

thanks
-- PMM
