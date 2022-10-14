Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4055FF536
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 23:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiJNVWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 17:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiJNVWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 17:22:05 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4FAF1DD884
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:21:56 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id i21so4651145ljh.12
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tKq14h3L8DuFvFIc1/toFN9il0HrAJZRTsymLOESL+4=;
        b=mySxM6vSz9WNpDWgs9WvCAaiMLUE7dK/EUmo+cDPFzHdu82YZFloiRCAnmWbkQiCOo
         r4pclB/Xuz16mfrbhGtTe8xXyiRB3H7SXGYljmk32wxqSPi6j1alBSM3xpICqiTxlsz3
         AV2TCkvdvDG2AwoLFus2/mVUhCWLm6IRNd2dAv3mHMDrtzfY2AmTQ9+I7nyv1YjpafdF
         pzoZrtB6fkoef41u6egJXsmJYyD/xkmSX/6UGxBvq2TN/5KWz3I0olnQdxeytoYgdcgg
         q/27Cx8HWO7SshXib5JwcYgCbnpMGBkmO8FLc16qtJNPtTXMO6SR/kDpdFWR8ALX8gt4
         eDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tKq14h3L8DuFvFIc1/toFN9il0HrAJZRTsymLOESL+4=;
        b=O/MdY+aO9zS8z3bAzCLraqcv5euB25T1qgahXADtcHEd+tEU2ycbEy+D0Utj8d7HqV
         x4qAT8JRSYJ+arBfE65kMim2zHcySiXGNNvrEKeq6gyKBW4uII0dYnZJVvWMqwzpGoQZ
         DFrpmizXnU2RgEL6LKq8iEa454qiGDvmAKdpkZEF4p3e6zLJed/Yn4QGMopiCFwF5YlE
         +icEjKgzxurPSmxlGn2F13VMKJ3JM6GyeH/gcc+9RD8AuzSCNS2ko0Umj1uL/+zjcm3i
         pTQXkKu+Wr23aawsllj9VtE5/MaFWYWOJGCBOnMCvWTA8IRMf18Ciwd0BuJksYbCKdF+
         H1WQ==
X-Gm-Message-State: ACrzQf2UoabNhrIOezr/TNSOVHDgDByT3pgQa+Y7whMSTrUw+RIT6WLc
        wI+TZHYgFpROC2XD0yQdBcp1ZJzyd0YFZvAz26n2rg==
X-Google-Smtp-Source: AMsMyM7RfQSCNFkfdmCX8rMwbPUObMSkQkobBqn2l/baX55oiYmBev50wCALmO5IDM+jTnQDPQTPyhZGVM7jZxIPl3w=
X-Received: by 2002:a2e:9547:0:b0:26b:fb41:f60a with SMTP id
 t7-20020a2e9547000000b0026bfb41f60amr2609653ljh.295.1665782514418; Fri, 14
 Oct 2022 14:21:54 -0700 (PDT)
MIME-Version: 1.0
References: <20221010220538.1154054-1-vipinsh@google.com> <DS0PR11MB63735576A8FBF80738FF9B76DC249@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y0mPqNRSgpArgyS8@google.com> <CALzav=dU2-3avKGT2-AxO8d_uVH9bmYaO=ym8pPFM8esuSWP=A@mail.gmail.com>
 <CAHVum0d2Jfr=WVxKxvnmwGKzPfV3vN5dbz11=rdcW6qoSoobew@mail.gmail.com> <Y0myXiIjlT8pYyr8@google.com>
In-Reply-To: <Y0myXiIjlT8pYyr8@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 14 Oct 2022 14:21:17 -0700
Message-ID: <CAHVum0cKG_LHN3PhskxLAOK18YCin2ee_keoGQsR4tUtwxLz=A@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] dirty_log_perf_test vCPU pinning
To:     Sean Christopherson <seanjc@google.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     David Matlack <dmatlack@google.com>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 12:03 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Oct 14, 2022, Vipin Sharma wrote:
> > On Fri, Oct 14, 2022 at 9:55 AM David Matlack <dmatlack@google.com> wrote:
> > >
> > > On Fri, Oct 14, 2022 at 9:34 AM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Fri, Oct 14, 2022, Wang, Wei W wrote:
> > > > > Just curious why not re-using the existing tools (e.g. taskset) to do the pinning?
> > > >
> > > > IIUC, you're suggesting the test give tasks meaningful names so that the user can
> > > > do taskset on the appropriate tasks?  The goal is to ensure vCPUs are pinned before
> > > > they do any meaningful work.  I don't see how that can be accomplished with taskset
> > > > without some form of hook in the test to effectively pause the test until the user
> > > > (or some run script) is ready to continue.
> > >
> > > A taskset approach would also be more difficult to incorporate into
> > > automated runs of dirty_log_perf_test.
> > >
> > > >
> > > > Pinning aside, naming the threads is a great idea!  That would definitely help
> > > > debug, e.g. if one vCPU gets stuck or is lagging behind.
> > >
> > > +1
> >
> > I also like the idea.
> >
> > Sean:
> > Do you want a v6 with the naming patch or you will be fine taking v5,
> > if there are no changes needed in v5, and I can send a separate patch
> > for naming?
>
> Definitely separate, this is an orthogonal change and I don't think there will be
> any conflict.  If there is a conflict, it will be trivial to resolve.  But since
> Wei provided a more or less complete patch, let's let Wei post a formal patch
> (unless he doesn't want to).

Sounds good!
