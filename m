Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C20588C05
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 14:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237828AbiHCM0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 08:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbiHCM0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 08:26:16 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BA214D39
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 05:26:15 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id n8so28138565yba.2
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 05:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=XKfwynFR+zb0eAS1I468yeVF69HEWRUXJt9uSj4bm48=;
        b=lM3Yzng95jPAYNc13mkGKUwCVXEOcHUEScmwRfzatU0Oi5+K5RdPRJ221QrONYqnEv
         IqVQErA0MW5jaodk+wqF0m7+5FlL3UGiSteT+BKiYBU6fOcdXYbOmtUp9BgNBxdn43Wz
         cMHVDXb8WEVBN/aJa0+/+0p5Fr0hLu+jFYKc4P5cPx9XitTnfsG3PreU/rCarnRMY0Ga
         B4x0G6q+AVJBMMlaTj4bbWyBL9D/TeDNDbJIrTDa9KHJ6a1eHKq8yOqf3mpxmPQLq3mn
         toQu6wbkP7CcCV3bljB0v634Og3sIigeZQ2fE8lscKCfTJ5aX+IKzBwJ+O9EqKIpUBGW
         pjJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=XKfwynFR+zb0eAS1I468yeVF69HEWRUXJt9uSj4bm48=;
        b=2H8MoWTc+zoI6bOTOdb/llGYnjiYLtCrHrGnzirithKLlD/Xi7N/HdFTWSsCq0FpWM
         GJZwbAGb4x3RhHfkg2kd49ilyKhgFLzXyg5Axx2njC7HGVGme7SYWlI6eBtLQJSdfmkx
         wE7jRv44Tj31rT9ZSGhnA6Z2/BDYC2q8m5TAA7SMMyeJIp5tMT66s98K0Asxg1aSVqVk
         SJ0QofcLgUqnGKGD7hhojqXYAFqI4HvYIjTmDYznM2CR/Bvlzxe9+IR/5c1pO0vUa2OI
         UXotP3J4GSfV4xyuxll5xeuazhrWhsfMNpxmCDxNc2bLDR3c+1DMdnyGLl3WV4gGutv3
         mZmg==
X-Gm-Message-State: ACgBeo1o6ri0wXNAK1rKFmbFsbPX6cENf80lWKJvnqRDn6tMj4LpcbPU
        jBBKWDXvJUg/SjFK6Fo3uAeLZBxYSIyoQ3P5TInAGw==
X-Google-Smtp-Source: AA6agR5xBcKtk4NuTc4eEdJxh+lCrDSqKcpSREqeZQWl9n932njAy+MwL2lt9PFhOdvkI4IQFfs0+mLwiRrb/B1IFuM=
X-Received: by 2002:a25:cf47:0:b0:671:8224:75c6 with SMTP id
 f68-20020a25cf47000000b00671822475c6mr19218310ybg.288.1659529575043; Wed, 03
 Aug 2022 05:26:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220729130040.1428779-1-afaria@redhat.com> <20220729130040.1428779-3-afaria@redhat.com>
 <YupSAhFRK962i+nL@work-vm> <CAELaAXyh0MzuVzDCfhC8hJNAwb=niwFRsXqhc63JiWGxxitkqg@mail.gmail.com>
 <20220803111520.GO1127@redhat.com> <Yupd96RyyEcm1BCb@redhat.com>
In-Reply-To: <Yupd96RyyEcm1BCb@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Wed, 3 Aug 2022 13:25:34 +0100
Message-ID: <CAFEAcA8Eg5RqEDs3ydOZ8jRX5T6Vxjz1_QfPvYCtTneN0mBXuA@mail.gmail.com>
Subject: Re: [RFC v2 02/10] Drop unused static function return values
To:     =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc:     "Richard W.M. Jones" <rjones@redhat.com>,
        Alberto Faria <afaria@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Peter Lieven <pl@kamp.de>, kvm@vger.kernel.org,
        Xie Yongji <xieyongji@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Jeff Cody <codyprime@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
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
        John Snow <jsnow@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 3 Aug 2022 at 12:44, Daniel P. Berrang=C3=A9 <berrange@redhat.com> =
wrote:
> Inconsistent return value checking is designed-in behaviour for
> QEMU's current Error handling coding pattern with error_abort/fatal.

Yes; I habitually mark as false-positive Coverity reports about
missing error checks where it has not noticed that the error
handling is done via the errp pointer.

> If we wanted to make it consistent we would need to require that
> all methods with 'Error **errp' are tagged 'attribute(unused)'
> and then provide
>
>   # define ignore_value(x) \
>      (__extension__ ({ __typeof__ (x) __x =3D (x); (void) __x; }))
>
> Such that if you want to use  error_abort/error_fatal, you
> need to explicitly discard the return value eg
>
>    ignore_value(some_method(&error_abort));
>
> If I was starting QEMU fresh, I think like the attribute(unused)
> anntation and explicit discard, but to retrofit it now would
> require updated about 3000 current callers which pass &error_abort
> and &error_fatal.
>
> On the flipside I am willing to bet that doing this work would
> identify existing bugs where we don't pass error_abort/fatal
> and also fail to check for failure. So there would be potential
> payback for the vast churn

Yes, if somebody wanted to take on the task of making this stuff
consistent I have no objection there. (I would be inclined to
suggest that this might involve a design where we consistently
report and check for the error in exactly one way, not in two
parallel ways.)

-- PMM
