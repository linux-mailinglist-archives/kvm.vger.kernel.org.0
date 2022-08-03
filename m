Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F670588C22
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 14:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbiHCMbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 08:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238107AbiHCMaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 08:30:55 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5BE13D5B
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 05:30:54 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-31f41584236so169669247b3.5
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 05:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=EnEMZUisXgxKUeKdBWNakeH0nco9cqyUMj7sIOSeHts=;
        b=wBjZ4EWoT3IXM2rvQgo/t7iMO7Z6AqfGm1GIQmNIFjGGTHlyeJG7j1I2OSrRNvcZI4
         24k2WM2IKnHBV+ZCeUtBpy9JaD4ym2P6O+Sx6iXEqf2s+MM7dXPgBrJhpqxTlshnWOMT
         /XRRnl44vtKcEGy1+RuPHeeVZJb9bUtlui8lVbF4jDWRWBfRpg9A9wh22QqGgYpyZro9
         6mPOg56X+aQwz5+G9KEi4Ju7IBHwv2yJCyMFsdag7FlqLd4YMjaQmfBhB889xA+9o19G
         YBs3fUN7HMTCdp4gc1AwBypOKpTd50FqXhhWGSbE7h8UTKaX2R5dZPh3u2SRGxGR64Xy
         7m6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=EnEMZUisXgxKUeKdBWNakeH0nco9cqyUMj7sIOSeHts=;
        b=siGDbKV6Xc0cJ+RAZanv+g8nhyQtpDvyAPFDu5uX4yhSaMT7huPSK6zKodtQIwFLk2
         0k8qqWWUx3oU4SznNTSLxv+MO56XY9Ks7Byrhsv3mYXk3RHihAQctE3zXbmWkj7337rX
         +zpjPfX36AMPw4YHFmDmzVEABkIIUoKqHDD++DpXJZWpV5dEMexF9xchUosomOcQ+5h1
         s4432Kh2VZ44oTI6oFaPDkbeKp8lcX2vhxKnoF7kAMz6gpmaJ86snwlN8CgPV0iCoycX
         mjE7mGMkNd4dBaYCDNsYVfbaD9EoHt7IuRHnVAICoXkd85bMo/IWAIoGYHF0FBzYnwm3
         77DQ==
X-Gm-Message-State: ACgBeo2DsyB00imXh0iO9Ug0332xN/Z/YP68poL/Gfk4YyuQ42JqbC3E
        TXB6ewNOdP1Aki6C7Ws1gRzaxDa/JeK4+WfxBxLswhkG4gA=
X-Google-Smtp-Source: AA6agR6Acf24aJyXoKtZHIzM4mHsOgSx8fBe4RDwSTNj0C85t8ZJsrkChHB/cJrEukq03vD9OsUKczAH0kPtBUTlaZM=
X-Received: by 2002:a0d:d2c3:0:b0:31e:62ea:3303 with SMTP id
 u186-20020a0dd2c3000000b0031e62ea3303mr23699810ywd.64.1659529853465; Wed, 03
 Aug 2022 05:30:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220729130040.1428779-1-afaria@redhat.com> <20220729130040.1428779-3-afaria@redhat.com>
In-Reply-To: <20220729130040.1428779-3-afaria@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Wed, 3 Aug 2022 13:30:13 +0100
Message-ID: <CAFEAcA83Eaw59H7ha0hScvX1yF8LrJatWqD-hnX0eVy+Ne4EUQ@mail.gmail.com>
Subject: Re: [RFC v2 02/10] Drop unused static function return values
To:     Alberto Faria <afaria@redhat.com>
Cc:     qemu-devel@nongnu.org,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Peter Lieven <pl@kamp.de>, kvm@vger.kernel.org,
        Xie Yongji <xieyongji@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Jeff Cody <codyprime@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        Stefan Weil <sw@weilnetz.de>, Klaus Jensen <its@irrelevant.dk>,
        Laurent Vivier <lvivier@redhat.com>,
        Alberto Garcia <berto@igalia.com>,
        Michael Roth <michael.roth@amd.com>,
        Juan Quintela <quintela@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-block@nongnu.org,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        "Richard W.M. Jones" <rjones@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jul 2022 at 14:09, Alberto Faria <afaria@redhat.com> wrote:
>
> Make non-void static functions whose return values are ignored by
> all callers return void instead.
>
> These functions were found by static-analyzer.py.
>
> Not all occurrences of this problem were fixed.
>
> Signed-off-by: Alberto Faria <afaria@redhat.com>

>  65 files changed, 248 insertions(+), 403 deletions(-)

The problem with a patch like this is that it rolls up into a
single patch changes to the API of many functions in multiple
subsystems across the whole codebase. Some of those changes
might be right; some might be wrong. No single person is going
to be in a position to review the whole lot, and a +248-403
patch email makes it very unwieldy to try to discuss.

If you want to propose some of these I think you need to:
 * split it out so that you're only suggesting changes in
   one subsystem at a time
 * look at the places you are suggesting changes, to see if
   the correct answer is actually "add the missing error
   check in the caller(s)"
 * not change places that are following standard API patterns
   like "return bool and have an Error** argument"

thanks
-- PMM
