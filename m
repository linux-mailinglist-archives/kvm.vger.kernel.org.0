Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D842798C3B
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 20:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240909AbjIHSGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 14:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbjIHSGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 14:06:10 -0400
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1191FE9
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 11:05:34 -0700 (PDT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-68bff8f3351so3284662b3a.3
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 11:05:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694196270; x=1694801070;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0lAvPiHpQzYJH2/Evbqeae0jEIobBXd5mkIT/JR5mjU=;
        b=YdhKf4HrtWvknvwM5jh9Ptfq3jKn4W0fODycUoanB/KZjcsua4nbx3yntbCBrsxPoo
         moUU2qHgocADyM66L7tg1YsZHIC13HVm+6OIKyVTNjsr4RVUR0PnVnEINGUYy+ouMavx
         Ylc0N44sA3uTYhEs+vUHndp/jswp7i5FeMooWGwYrk3u9nkaV3EG0A+70kElKFnRO7Jz
         TWwVmbT5Ria1S3HlbtAouhmGAC0Y+JrA90hJQNwredb3wmU5476eA/hYYf+LpQxZGBJx
         vbPqQwlnYdIGLLZ9FI3t/RvWWLCEoXwVcj61+juTKGeOnplKYgQeynPN7GHaGJTdhz0c
         uKog==
X-Gm-Message-State: AOJu0YwlRd3f90G5awlcccrK06H2UCPMlECKctIDn7CDm8LYCjSutBWp
        CmSBDkYGcXNNb5Y320YfvLlT3OzkQhoB73KKNAsValf5pQYK
X-Google-Smtp-Source: AGHT+IFG6oZqBOayFovKE0NVKEQ0Xnwtd+Nskzg2qKPXIoko6vfMv+elInHkBKWJh6QlQckbllDdPD2ESA+Mlnx+N1cgB86kBYBd
MIME-Version: 1.0
X-Received: by 2002:a05:6a00:80c:b0:68a:3c7a:128c with SMTP id
 m12-20020a056a00080c00b0068a3c7a128cmr1357477pfk.2.1694196270440; Fri, 08 Sep
 2023 11:04:30 -0700 (PDT)
Date:   Fri, 08 Sep 2023 11:04:30 -0700
In-Reply-To: <000000000000f392a60604a65085@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e127ec0604dcce27@google.com>
Subject: Re: [syzbot] [mm?] kernel BUG in vma_replace_policy
From:   syzbot <syzbot+b591856e0f0139f83023@syzkaller.appspotmail.com>
To:     42.hyeyoo@gmail.com, Liam.Howlett@Oracle.com,
        agordeev@linux.ibm.com, akpm@linux-foundation.org,
        alexghiti@rivosinc.com, aou@eecs.berkeley.edu,
        borntraeger@linux.ibm.com, cgroups@vger.kernel.org,
        christophe.leroy@csgroup.eu, damon@lists.linux.dev,
        david@redhat.com, eadavis@sina.com, frankja@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
        hannes@cmpxchg.org, hca@linux.ibm.com, imbrenda@linux.ibm.com,
        jeeheng.sia@starfivetech.com, jglisse@redhat.com,
        kvm@vger.kernel.org, leyfoon.tan@starfivetech.com,
        linmiaohe@huawei.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mason.huo@starfivetech.com,
        mhocko@kernel.org, mpe@ellerman.id.au, muchun.song@linux.dev,
        naoya.horiguchi@nec.com, npiggin@gmail.com, palmer@dabbelt.com,
        paul.walmsley@sifive.com, roman.gushchin@linux.dev,
        sebastian.reichel@collabora.com, shakeelb@google.com,
        sj@kernel.org, surenb@google.com, svens@linux.ibm.com,
        syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this issue to:

commit 49b0638502da097c15d46cd4e871dbaa022caf7c
Author: Suren Baghdasaryan <surenb@google.com>
Date:   Fri Aug 4 15:27:19 2023 +0000

    mm: enable page walking API to lock vmas during the walk

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11fd2348680000
start commit:   7733171926cc Merge tag 'mailbox-v6.6' of git://git.linaro...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13fd2348680000
console output: https://syzkaller.appspot.com/x/log.txt?x=15fd2348680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b273cdfbc13e9a4b
dashboard link: https://syzkaller.appspot.com/bug?extid=b591856e0f0139f83023
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d4ecd0680000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1055c284680000

Reported-by: syzbot+b591856e0f0139f83023@syzkaller.appspotmail.com
Fixes: 49b0638502da ("mm: enable page walking API to lock vmas during the walk")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
