Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704585FE4EB
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 00:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJMWBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 18:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiJMWBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 18:01:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA8E189802
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 15:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665698472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iF0bAvMZpKcz6Yp8gJQHUr2yf6LEe5KLr2h0xqDTYlI=;
        b=SLPxVW47AX5kbq827Wl29NlOROwynMSc8Zr4WnYOqtDYYFSv9QK0fc0iYXdj1u2RUHZIxP
        adxTCiC1GnZPIncEHad3kqr9D/UxsKB0J4c/2OayHXLBzVELLsyIoq96/pNMQuR2snt/bC
        U669iaUHdHa/nCyy+llyftC31CqOfmM=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-317-UdazTfoaM3qr6lx4gwgRtQ-1; Thu, 13 Oct 2022 18:01:11 -0400
X-MC-Unique: UdazTfoaM3qr6lx4gwgRtQ-1
Received: by mail-ua1-f70.google.com with SMTP id 95-20020a9f23e8000000b0038caa7cd5c1so1203740uao.8
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 15:01:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iF0bAvMZpKcz6Yp8gJQHUr2yf6LEe5KLr2h0xqDTYlI=;
        b=IN8qkEaiNd/DmeNf1j0QClkwXQeiIUpaiIgliYUH/td4cviC4Uy5O4f13zyF3d9+/9
         Mvm6OohP0IJu1Gg7ZE2AW5go2YrUA37J95y39SCcnvWpez+0dkKAhDePHvHaL0fAP7o+
         keBWcpl4hPwuSbZN+FsSFYrkx6X19WAakf4E51X46GNBJhfCE5mzlraRwzEOKcA//zHm
         vVA/3ZZBFkes661chElb2+BdKeUvOy1nTMVw/oVxQ3MSiNkWlgzZTV1S7spTXwg6qQ2V
         ye4BvpZTJk/cyEQcOMAhOCghxnCuIcXh9TylihGY02DeOxJxJq0w4ZBfiPh3AZrCxupK
         UR/Q==
X-Gm-Message-State: ACrzQf0IYhZAmenjcNX1tU5oSE4KeSWbAVhWT3CjQAafbZljozOCcBLR
        bktSjxsyrBDlbR5VuxmbCowngDsa5kcwQWk/9NF5xNCCjNSPF6YDcJSJmhhCIntAU36TuxBAOR7
        Q2TRv6UCRwgYF5ihtH1Jx6hUsMFbV
X-Received: by 2002:a67:ac4c:0:b0:3a4:b881:4490 with SMTP id n12-20020a67ac4c000000b003a4b8814490mr1326712vsh.42.1665698470241;
        Thu, 13 Oct 2022 15:01:10 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5NvWSJOiEFzvCJIy4O2OoyZQ3eF7OT0hx+f2vfvWv0gFBPFYvAMXAvYdwoKZxaOmYfdpr6zdYInqmldh88+v0=
X-Received: by 2002:a67:ac4c:0:b0:3a4:b881:4490 with SMTP id
 n12-20020a67ac4c000000b003a4b8814490mr1326625vsh.42.1665698469250; Thu, 13
 Oct 2022 15:01:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220729130040.1428779-1-afaria@redhat.com>
In-Reply-To: <20220729130040.1428779-1-afaria@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 14 Oct 2022 00:00:58 +0200
Message-ID: <CABgObfZD__Z=g3rvXxYVLcYb9wtkdQ14=mgMpsKoiVRxFCicUw@mail.gmail.com>
Subject: Re: [RFC v2 00/10] Introduce an extensible static analyzer
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 29, 2022 at 3:01 PM Alberto Faria <afaria@redhat.com> wrote:
> Performance isn't great, but with some more optimization, the analyzer
> should be fast enough to be used iteratively during development, given
> that it avoids reanalyzing unmodified translation units, and that users
> can restrict the set of translation units under consideration. It should
> also be fast enough to run in CI (?).

I took a look again today, and the results are indeed very nice (I
sent a patch series with the code changes from this one).

The performance is not great as you point out. :/  I made a couple
attempts at optimizing it, for example the "actual_visitor" can be
written in a more efficient way like this, to avoid the stack:

    @CFUNCTYPE(c_int, Cursor, Cursor, py_object)
    def actual_visitor(node: Cursor, parent: Cursor, client_data:
Cursor) -> int:

        try:
            node.parent = client_data

            # several clang.cindex methods need Cursor._tu to be set
            node._tu = client_data._tu
            r = visitor(node)
            if r is VisitorResult.RECURSE:
                return 0 \
                    if conf.lib.clang_visitChildren(node,
actual_visitor, node) != 0 \
                    else 1
            else:
                return r.value

        except BaseException as e:
            # Exceptions can't cross into C. Stash it, abort the visitation, and
            # reraise it.
            if exception is None:
                exception = e

            return VisitorResult.BREAK.value

    root.parent = None
    result = conf.lib.clang_visitChildren(root, actual_visitor, root)

    if exception is not None:
        raise exception

    return result == 0

However, it seems like a lost battle. :( Some of the optimizations are
stuff that you should just not have to do, for example only invoking
"x.kind" once (because it's a property not a field). Another issue is
that the bindings are incomplete, for example if you have a ForStmt
you just get a Cursor and you are not able to access individual
expressions. As a result, this for example is wrong in the
return-value-never-used test:

                static int f(void) { return 42; }
                static void g(void) {
                    for (f(); ; ) { } /* should warn, it doesn't */
                }

and I couldn't fix it without breaking "for (; f(); )" because AFAICT
the two are indistinguishable.

On top of this, using libclang directly should make it possible to use
the Matcher API (the same one used by clang-match), instead of writing
everything by hand. It may not be that useful though in practice, but
it's a possibility.

Paolo

