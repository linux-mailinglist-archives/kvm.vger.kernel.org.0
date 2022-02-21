Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5A04BEB1F
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 20:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiBUSkx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 13:40:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbiBUSkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 13:40:33 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A130249
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 10:40:09 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id x16-20020a6bfe10000000b006409f03e39eso5509594ioh.7
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 10:40:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=RPxzAA9BnC5qAmWaV/3BRmFXPmX58G4c2OEDKIVxKv8=;
        b=cgwbUNxWgflEpqX3q+3hb45I+dONWUSNQnvDqevENGEHceJKh58FjvR++NZIuovIIu
         oeUBnQnjrMdlopits5o/1rryR1Ut4jnjRPaUv+Bt7JbyFIZzz+4Vg8v0S8oNwaJefe8d
         6b2nezQ1TCXOTcTctJ7LDeDVnAIjdKFEv+AWdgvTmFfQrRI0XWNq+gAZj3kQpiZYRgKM
         07mpPRUXwJFGoztU+hR2uqhzBH/aNV1CeH6DO1upYqVwb9bJzSIzr7cej88hnoybp91l
         9QybBxLq8FfuZ3nAgm/IMOq+lYvIZ7LUX7WeYFN56vypRfpa4jwKpSYnghHibQV4aRYM
         7t0g==
X-Gm-Message-State: AOAM533Qz0laUG6vIEjIMNuFWFX2D2xZT/JiQBqVQBDE4mLvwySeKell
        LsddZ/m90j0xI/6tC1J+3+0Todpv6URYKKHOmlKWfANE/uQJ
X-Google-Smtp-Source: ABdhPJwLbZq1aO/UEzVzfLzH/O6TrJEsmlPP5tRjxaPEBMQxIGZHoAyGqkO3wxpQXTnQRAJs8+uaGTbby9XZRQfsky6WhY4Ylyrw
MIME-Version: 1.0
X-Received: by 2002:a6b:2cc5:0:b0:614:50a6:c099 with SMTP id
 s188-20020a6b2cc5000000b0061450a6c099mr16011690ios.71.1645468808827; Mon, 21
 Feb 2022 10:40:08 -0800 (PST)
Date:   Mon, 21 Feb 2022 10:40:08 -0800
In-Reply-To: <YhPZf7qHeOWHgTHe@anirudhrb.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d6dbd305d88b8fb6@google.com>
Subject: Re: [syzbot] INFO: task hung in vhost_work_dev_flush
From:   syzbot <syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com>
To:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mail@anirudhrb.com, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com

Tested on:

commit:         038101e6 Merge tag 'platform-drivers-x86-v5.17-3' of g..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=96b2c57ab158898c
dashboard link: https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15e55046700000

Note: testing is done by a robot and is best-effort only.
