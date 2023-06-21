Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D797390FD
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 22:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjFUUqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 16:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjFUUqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 16:46:47 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E218019A8
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 13:46:46 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id 6a1803df08f44-62fe192f7d3so58488976d6.3
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 13:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687380406; x=1689972406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X3Qi4zy5Gr75S42BE9xiiVJqsuIBs35w8Y4EM5LQQNY=;
        b=KlTPYcQJVDU0wrNlvuOhxxoVr9cZ2HoxP47XbMf7/fWWISuGM6n62tPPGxrLdAKOYo
         +GteKiCQO74tyats+2/dW3h58DD82+GpVOWudzMbITeqUJev4mbtn2hFfbjk5bQYqurU
         CKlZLiu9Xl2RB5zQR4B5B1KBf0OlygsLL8vVRkZ+xi0bBXTvBvPyKTDa+YD9NDGuDE3v
         TfH5toEDnV5W1xwxF0HpXWoydJoTs/FUQBfF54AAZ1msPo+mcw6uNs7mCro2z6jMffHg
         vQmIvUjmNGNBylz7I4OlkmeO8slu+mIUdcIFIsNxcRYcQOXNcyO65WQEWfO+3mF65TY8
         DdBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687380406; x=1689972406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X3Qi4zy5Gr75S42BE9xiiVJqsuIBs35w8Y4EM5LQQNY=;
        b=F2SB/9Ql1+3e1eHMYAobGGQ4lVZnA0iBDpRmhq7WpZdf/gXVA2LcEdbFb0EINyTFOx
         aUfUnf9HcHf2ZWloiqk6w8IQQO3xJwVPJIj4tspW6LOp99GDt6ofZMVFQ2RC3Nuj1XmS
         7SGzV7EgBVLfAfblamd/hvxZ+UeR4pzjoiA1WsQSARMGd+a7SuUjaUInL3+bbmTo8OB3
         hr2W9kOWaHbrJUFKm1pq15Gwwl9ds6yonQK5IT+v8NcRYH6+jJKUYebGnrM2FCqgFXF5
         EZA1ws/20LTPaWi+txiIp3GSe4ztxtGFc5K6buOkGxET2acSAsNlP7ZfFzY9NaLTJOOL
         1wuQ==
X-Gm-Message-State: AC+VfDyB8DAICLq9XfU8vPa2Q2r/eijsTRcuRRFBQEtMG/6dTcLBMnKN
        bWLu96V1z0dBCrJIIcZ1AwygZymRJo4gWLxTrAVnMA==
X-Google-Smtp-Source: ACHHUZ5g2jX+76imzzqsdw+sRPFF3XcgchHI37CBupvSyiBqg1npw9B3sqUYnYCSxsI2p7ycLlPKdJJbzCnY4MDTO4w=
X-Received: by 2002:a05:6214:f23:b0:631:e696:7b6 with SMTP id
 iw3-20020a0562140f2300b00631e69607b6mr11969303qvb.53.1687380405803; Wed, 21
 Jun 2023 13:46:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686858861.git.isaku.yamahata@intel.com>
 <CAGtprH8O6dsjjNrMzLPmRio0ZDLe6M3U06HD0oNX3NN9FeWQfg@mail.gmail.com>
 <20230619231142.0000134a.zhi.wang.linux@gmail.com> <CAGtprH8jreK52wTcNhoAcBoHKZfkQ_1AYArgb2v6M_YVRYAw+w@mail.gmail.com>
 <BL0PR11MB3042820B6CD6E4926E7BA50E8A5DA@BL0PR11MB3042.namprd11.prod.outlook.com>
In-Reply-To: <BL0PR11MB3042820B6CD6E4926E7BA50E8A5DA@BL0PR11MB3042.namprd11.prod.outlook.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Wed, 21 Jun 2023 13:46:34 -0700
Message-ID: <CAGtprH8JqCMmcNnWEhKFQd3Mm4WqT6buJJndtzG8rgxjU=bLnw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] KVM: guest memory: Misc enhacnement
To:     "Dong, Eddie" <eddie.dong@intel.com>
Cc:     Zhi Wang <zhi.wang.linux@gmail.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Chen, Bo2" <chen.bo@intel.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 21, 2023 at 11:20=E2=80=AFAM Dong, Eddie <eddie.dong@intel.com>=
 wrote:
>
>
>
> > -----Original Message-----
> > From: Vishal Annapurve <vannapurve@google.com>
> > Sent: Monday, June 19, 2023 2:55 PM
> > To: Zhi Wang <zhi.wang.linux@gmail.com>
> > Cc: Yamahata, Isaku <isaku.yamahata@intel.com>; kvm@vger.kernel.org;
> > linux-kernel@vger.kernel.org; isaku.yamahata@gmail.com; Paolo Bonzini
> > <pbonzini@redhat.com>; Aktas, Erdem <erdemaktas@google.com>;
> > Christopherson,, Sean <seanjc@google.com>; Shahar, Sagi
> > <sagis@google.com>; David Matlack <dmatlack@google.com>; Huang, Kai
> > <kai.huang@intel.com>; Chen, Bo2 <chen.bo@intel.com>; linux-
> > coco@lists.linux.dev; Chao Peng <chao.p.peng@linux.intel.com>; Ackerley
> > Tng <ackerleytng@google.com>; Michael Roth <michael.roth@amd.com>
> > Subject: Re: [RFC PATCH 0/6] KVM: guest memory: Misc enhacnement
> >
> > On Mon, Jun 19, 2023 at 1:11=E2=80=AFPM Zhi Wang <zhi.wang.linux@gmail.=
com>
> > wrote:
> > >
> > > On Mon, 19 Jun 2023 12:11:50 -0700
> ...
> >
> > Protected VM effort is about being able to have guest memory ranges not
> > mapped into Userspace VMM and so are unreachable for most of the cases
> > from KVM as well. Non-CC VMs can use this support to mitigate any
> > unintended accesses from userspace VMM/KVM possibly using enlightened
> > kernels.
>
> "PROTECTED" seems to be not very close to what you mean here. "PROTECTED_=
MEM" ?
> What case of non-CC VMs may use this feature in reality?  Or do you have =
any expected cases?
>

Similar to pKvm efforts [1], PROTECTED_VM functionality may be used to
unmap guest memory ranges from the host and userspace VMM on x86
platforms. If the KVM/host kernel and the guest VMs are enlightened
for this usecase, then it should be possible to deploy this feature
for normal VMs irrespective of the platforms they are running on.

Primary usecase here would be to prevent unintended accesses from
KVM/userspace VMM which would normally go undetected at runtime or are
hard to trace back to the original culprit.

[1] https://source.android.com/docs/core/virtualization/architecture#hyperv=
isor
