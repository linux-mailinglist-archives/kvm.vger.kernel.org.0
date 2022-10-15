Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690015FFA4C
	for <lists+kvm@lfdr.de>; Sat, 15 Oct 2022 15:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJONfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Oct 2022 09:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJONfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Oct 2022 09:35:45 -0400
X-Greylist: delayed 1272 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 15 Oct 2022 06:35:43 PDT
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA9F4D162
        for <kvm@vger.kernel.org>; Sat, 15 Oct 2022 06:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=1xgL3nGmvsWM+eEOqBnpQ1xASQnjO01Ot02KqniN8vM=; b=Zx4UzJcow0ashPdOdi8f+pS9eG
        qsgoKZAQcc+D7sdLgmFBo5xEARyUMJsBv6HiMEMlQ76VeBQ179vdsk4JacN11Y/Rbep45xjXd5qnI
        KX37Mc2m22PUWKvGm3bKcMJvT5rHPo9ZYBw72EZOBBz0zkK8wiA67M4h0XZrCOycMz9FX3jQvJ6ZE
        ch4fZ2Ym+8zSLRa3mzdefRGxh+uDczZHVdoWZX0M5tz3EO3/e0FA41U78TrQilfMU69UpV8UameAy
        oc8ptxr0f1gPOkM1fyVnNxkUxAOZl7yQWoWoRRvfuSN/rkfMu72QY1ivIJazAz5Rxt+/LKGW4J3RE
        dcSbXGMMTxSNXLUIhcE5az+bBPmpH8sXIy9Lk8uRFe9LTVHAOc0IHjxv6XAJ4UNd4gzvyoH8+yZQQ
        DCOX8xz/YbD5INB8IIV4KAffRsif2m4Kw7IjTNT9FkWF+Ca2Nvj6/q2zCjlBLA4EHOG2Dn05RBYfc
        pePgwhzPZmJqmEG9JHwzPPsxoCSR2Loz1a6yT185sbdqH5FvCNfnkYLd7bJsnsgV/R5OPo4T9wysO
        6+MIxcV+y+CYdtxZAboVQhg6P2XyhIT57sV3PZ0Tn6+8b/38GKc4LRFV1DH0vNZOLM3oztpwRR9vJ
        b8DlROi0AYXbgpm8IAwLTsyhaDNoGdMd6codbqs/A=;
From:   Christian Schoenebeck <qemu_oss@crudebyte.com>
To:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alberto Faria <afaria@redhat.com>,
        =?ISO-8859-1?Q?Marc=2DAndr=E9?= Lureau 
        <marcandre.lureau@redhat.com>,
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
        Daniel =?ISO-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Philippe =?ISO-8859-1?Q?Mathieu=2DDaud=E9?= <f4bug@amsat.org>,
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
        Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        "Richard W.M. Jones" <rjones@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
Subject: Re: [RFC v2 00/10] Introduce an extensible static analyzer
Date:   Sat, 15 Oct 2022 15:14:20 +0200
Message-ID: <3662732.oTPJGMJ31K@silver>
In-Reply-To: <CABgObfZD__Z=g3rvXxYVLcYb9wtkdQ14=mgMpsKoiVRxFCicUw@mail.gmail.com>
References: <20220729130040.1428779-1-afaria@redhat.com>
 <CABgObfZD__Z=g3rvXxYVLcYb9wtkdQ14=mgMpsKoiVRxFCicUw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Freitag, 14. Oktober 2022 00:00:58 CEST Paolo Bonzini wrote:
[...]
> However, it seems like a lost battle. :( Some of the optimizations are
> stuff that you should just not have to do, for example only invoking
> "x.kind" once (because it's a property not a field). Another issue is
> that the bindings are incomplete, for example if you have a ForStmt
> you just get a Cursor and you are not able to access individual
> expressions. As a result, this for example is wrong in the
> return-value-never-used test:
> 
>                 static int f(void) { return 42; }
>                 static void g(void) {
>                     for (f(); ; ) { } /* should warn, it doesn't */
>                 }
> 
> and I couldn't fix it without breaking "for (; f(); )" because AFAICT
> the two are indistinguishable.

You mean accessing the `for` loop's init expression, condition expression,
increment statement? AFAICS those are accessible already by calling
get_children() on the `for` statement cursor:
https://github.com/llvm/llvm-project/blob/main/clang/bindings/python/clang/cindex.py#L1833

I just made a quick test with a short .c file and their demo script:
https://github.com/llvm/llvm-project/blob/main/clang/bindings/python/examples/cindex/cindex-dump.py

And I got all those components of the `for` loop as children of the `for`
cursor.

Best regards,
Christian Schoenebeck


