Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1913570CF47
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbjEWAZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 20:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235634AbjEWAXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 20:23:04 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688A3212D
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 17:07:17 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-517c06c1a1bso3598802a12.3
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 17:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684800437; x=1687392437;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=00M59/ERL5rCid+0EeexM90p8FMZ55e8xTVk/5IwWAI=;
        b=eKS08NvvMxcTks/gD/Aef3buBTIRd89+5ZUYMh1veW2Bwau8N4vvj1C9yASUIO/Gl1
         oxHyQwzG9vN+C/niZsJ++pGG2eokuUJnWPCjy6ek3v5mPoLqVq8whstRJFwEID2GUHec
         Mi9oBdwFZDPfV7XB9rTviIM16S5fpiSaIMHo3VNaob6ESktjrnlVgQMzSw721XDdv87x
         1GZq2rhXbQfTFYPhNp99bfZY1T5TXRdPui6I+y0hdirdTSX84g6S5Kb1osAfq+3Sd+c/
         XgTs77NQ8/gz2esL3Leed4EPQBrJE0uEuWzjOpKjOrBYvCEl9OYgP2+Uk05chf+qs3j7
         baXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684800437; x=1687392437;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=00M59/ERL5rCid+0EeexM90p8FMZ55e8xTVk/5IwWAI=;
        b=AG5CAUo4AjG68VlpJjOe4QFXZ27a4CswZ82srqkTvlzSQgFNqW/MnP1D8XJEkP99sA
         qM3NFWCweInUpJqzKPcsQ5Xeb8jYBwVCYKFrTYGHMpEBeydKr18Of+xQfcinmeSwlalZ
         E8fvC+GNv5+VdizV8UJwI5FzgWTeY4grJ50JMAId5OBgU0JQFZA9xv8UpJecOxMeFJ0i
         lMrABpeGNO3ezqvltAmK39GdCyKyiMTdhbCW5EMy4HAKg95xhTobFG9j/cp8WB9s45sj
         OYQ5nxQE58BtJGS3SH2D4KibuKHGQgvoheHVEiKdnQ3nrSyoQgXqQ9XDcXOXQgS/hAvf
         REEA==
X-Gm-Message-State: AC+VfDxMmTrg95eUv3Zax4sKHIAooJLFED708EF7FuZ2Kkr8rE9BxeAA
        6T3zIVKVWaF+c0bhgycgnXTtkiB/jpg=
X-Google-Smtp-Source: ACHHUZ4h8CKM4xTy1lkpuF74m6v7QXKl/pIuViq4YXbsPdpBl9vkZ+vUKUQxs/EZ3XZmIxBRr/AUmQ9wf74=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:ba08:0:b0:534:9003:d58e with SMTP id
 k8-20020a63ba08000000b005349003d58emr2722120pgf.9.1684800436821; Mon, 22 May
 2023 17:07:16 -0700 (PDT)
Date:   Tue, 23 May 2023 00:07:15 +0000
In-Reply-To: <20230522072508.GA326851@chaop.bj.intel.com>
Mime-Version: 1.0
References: <20230512231026.799267-1-seanjc@google.com> <20230522072508.GA326851@chaop.bj.intel.com>
Message-ID: <ZGwDs1qHcl8PX+m2@google.com>
Subject: Re: [ANNOUNCE / RFC] Periodic Upstream Call for KVM
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sagi Shahar <sagis@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Anish Ghulati <aghulati@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Babu Moger <babu.moger@amd.com>, Chao Gao <chao.gao@intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Guang Zeng <guang.zeng@intel.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Jing Liu <jing2.liu@intel.com>,
        Junaid Shahid <junaids@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Leonardo Bras <leobras@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Li RongQing <lirongqing@baidu.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Michal Luczaj <mhal@rbox.co>,
        Mingwei Zhang <mizhang@google.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Paul Durrant <pdurrant@amazon.com>,
        Peng Hao <flyingpenghao@gmail.com>,
        Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
        Robert Hoo <robert.hu@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Qinglan Xiang <qinglan.xiang@intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Margarita Maroto <margarita.maroto@intel.com>,
        Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Nagareddy Reddy <nspreddy@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023, Chao Peng wrote:
> On Fri, May 12, 2023 at 04:10:27PM -0700, Sean Christopherson wrote:
> >   PT   (6am)
> >   MT   (7am)
> >   CT   (8am)
> >   ET   (9am)
> >   WET  (2pm)
> >   CET  (3pm)
> >   EET  (4pm)
> >   EST  (5pm)
> >   CST  (9pm)
> >   NZST (1am)
> 
> This looks good, 9pm is not too late for PRC people.
> 
> > 
> > The obvious alternative would be to invert the schedule and have the sync be in
> > the evening/night for Pacific Time, but to get 6am for ARM folks, we end up with:
> > 
> >   PT   (10pm)
> >   MT   (11pm)
> >   CT   (12pm)
> >   ET   (1am)
> >   WET  (6am)
> >   CET  (7am)
> >   EET  (8am)
> >   EST  (9am)
> >   CST  (1pm)
> >   NZST (5pm)
> > 
> > which is quite unreasonable for pretty much everyone based in the US.  Earlier
> > than 6am for WET is likewise unreasonable and will result in people not attending.
> > 9pm for China is also unreasonable, but I hope that it's not completely ridiculous
> > and is doable enough that people can at least attend on an as-needed basis.  Sorry
> > Kai, as the sole representative from New Zealand, you get hosed :-(
> > 
> > Wednesday because holidays and (short) vacations most often land at the beginning
> > and end of the week.
> > 
> > 60 minutes because I'm not waking up at dawn for anything less, and anything
> > more will likely have dimishing returns, especially for folks on the edges of
> > the time zone table.
> > 
> > Lastly, the big unknown is which video communication software to use.  My default
> > is obviously Google Meet, but I've been told that Meet is unusable in some
> > countries. :-/  My only requirements (beyond basic, obvious functionality) are
> > that (a) there's a web interface (no install required) and that (b) the calls can
> > be recorded.
> 
> Google Meet should work for me, but may not for every (PRC) people.
> Besides no installation, if no registration would be even better ;)
> Maybe we can run with Google Meet for the first session(s) if you
> havn't get one in your mind, it's not too hard to switch to alternative
> at a later time right?

Ya, switching should be no problem.  Let's try Google Meet and go from there.
Thanks much for the input!

> > To kick things off, I am leaning toward a "launch" date of May 24th (Pacific),
> > with KVM guest private mem (a.k.a. UPM) as the first topic.
> 
> Thanks for driving this, yes for UPM I would definitely join.

I'm going to push out the inagaural date one week until May 31st, partly to give
more time for this to get widely disseminated, but mostly because I need to write
down my various thoughts on where to go with UPM, and I don't think I'll get that
done before Wednesday.  That'll also give me time to setup a public calendar so
that people can get reminders and whatnot.
