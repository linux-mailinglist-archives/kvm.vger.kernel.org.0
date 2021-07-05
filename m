Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112C13BBC47
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 13:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhGELji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 07:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbhGELjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 07:39:37 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929E2C061574;
        Mon,  5 Jul 2021 04:36:59 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id h6so24242310ljl.8;
        Mon, 05 Jul 2021 04:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6n9dVwepW2FjWn98aPrmogm8bsjFfoTV2UF3IavtpKU=;
        b=iijNDKQo8tLbJVp8lE1S5t6KOQ4t8YKsqj3h0olTZYFsz/rhkZlCyoypWY9WCnTq6p
         B7pM6erBpyM10FzGUrRA4MJFbUcNv5DR6y/yuIulBQbGNZvoRu75wiBa/fEYGP2ptlfa
         AWdUD+nh41rjI+d3LQ/L4TedJ+N69FAlp+HaurS0Ejy+CQJo7Qluu/N3GOEbR2sw4Xwa
         0+v22SIaw3GI7Evx26aZ0GOIZthHx9I95MctYbu22u0i4KpW8n2V8N5ScMiJJ4j4osF1
         yrumzlgk2q64NDZJsLF+v8Y4uRcg+utl3dQgmJ942bgUIF3j/7ZIkNMpqi/Cq7W51wzX
         9TQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6n9dVwepW2FjWn98aPrmogm8bsjFfoTV2UF3IavtpKU=;
        b=FR/bFDz9VEBT55tjEDlX8Hsi4Dd1epl5P6f7pDztzbQDs/RE5+FrX8DQ3rsWN1U3OC
         QbvjzxF6It9nfBVesV9cllk+83nrxUASHKY3J+b2L6uI1iKpiOu8V/Ec21azITNPs1Lk
         hsE5oIPlpCAHQpcwGA93Ldngh9ehM7dhDOrk4A9N51mr5S6F4ofymOSHFF8s1n7mpsV0
         Ub6zUfakkm77++auEX+4S5pKxUVU1qsgNKIAa2cXqNmN+zQ3edzr3F7Kff6aZxwhGOuq
         OOKkKtPO+Q6/jjFlKyuewUahJJ7B2KrW+TRpJt7qDRIi5l+QRqZBc+dUILpv5YoYfuSb
         1gNg==
X-Gm-Message-State: AOAM530SvrJb7QhaTs7JGTK2WqRuo1WCGCT2xQhGbBueTjnVpzsvRswA
        IRxh4opdPxgrMBwJBqzusao=
X-Google-Smtp-Source: ABdhPJzxNt/Bm1WIK489uKepp7pjOtTNS79kV94AAaObK8C4HOITdKddAFadyFTthO2rprZQNHKTaA==
X-Received: by 2002:a2e:7310:: with SMTP id o16mr10733602ljc.383.1625485017609;
        Mon, 05 Jul 2021 04:36:57 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id l6sm161923lfk.256.2021.07.05.04.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 04:36:57 -0700 (PDT)
Date:   Mon, 5 Jul 2021 14:36:52 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] memory leak in kvm_dev_ioctl
Message-ID: <20210705143652.56b3d68b@gmail.com>
In-Reply-To: <CACT4Y+Yk5v3=2V_t77RSqACNYQb6PmDM0Mst6N1QEgz9CdYrqw@mail.gmail.com>
References: <000000000000bfb6cf05c631db0b@google.com>
        <20210703101243.45cbf143@gmail.com>
        <CACT4Y+Yk5v3=2V_t77RSqACNYQb6PmDM0Mst6N1QEgz9CdYrqw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Jul 2021 07:54:59 +0200
Dmitry Vyukov <dvyukov@google.com> wrote:

> On Sat, Jul 3, 2021 at 9:12 AM Pavel Skripkin <paskripkin@gmail.com>
> wrote:
> >
> > On Fri, 02 Jul 2021 23:05:26 -0700
> > syzbot <syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com>
> > wrote:
> >
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    e058a84b Merge tag 'drm-next-2021-07-01' of
> > > git://anongit... git tree:       upstream
> > > console output:
> > > https://syzkaller.appspot.com/x/log.txt?x=171fbbdc300000 kernel
> > > config:
> > > https://syzkaller.appspot.com/x/.config?x=8c46abb9076f44dc
> > > dashboard link:
> > > https://syzkaller.appspot.com/bug?extid=c87d2efb740931ec76c7 syz
> > > repro: https://syzkaller.appspot.com/x/repro.syz?x=119d1efc300000
> > > C reproducer:
> > > https://syzkaller.appspot.com/x/repro.c?x=16c58c28300000
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to
> > > the commit: Reported-by:
> > > syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com
> > >
> >
> > Corresponding fix was sent about 2 days ago
> > https://patchwork.kernel.org/project/kvm/patch/20210701195500.27097-1-paskripkin@gmail.com/
> 
> Hi Pavel,
> 
> Thanks for checking. Let's tell syzbot about the fix:
> 
> #syz fix: kvm: debugfs: fix memory leak in kvm_create_vm_debugfs


Hi, Dmitry!

Sorry for stupid question :)

I don't see, that my patch was applied, so syzbot will save the patch
name and will test it after it will be applied? I thought about
sending `syz fix` command, but I was sure that syzbot takes only
accepted patches.



With regards,
Pavel Skripkin
