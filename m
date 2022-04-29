Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2463651521F
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 19:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379741AbiD2Rcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 13:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379644AbiD2RcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 13:32:20 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5764EDB0C7
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 10:28:06 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id t25so15239391lfg.7
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 10:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k5wgbbVMzxT1FGv3ToNsrykCep98GtsONmeu7ExUc9Q=;
        b=Ooof03YYaerjHpgKdNiPWsEY0/0Dof5Tz3f/l3NM3t82c5E1iKlZq6AVPXH7KVYIH6
         X0iW4bDtykLWpRUA0aFTl1zoZb6D1zksUCsNeGK4PbYeN/hSAip981Pdq3GvY9cWpIGa
         S7jr4Ia7I0MCL9snxMeGlLXf1oWzHPFugitt9t0znydt9cx3QNGRLv9Qta8Qx0RsBORv
         O31pV3mithTb0WNiKc5dnD+lkhpglvtgjGLf6WzYWqepdwo3zG87nGVUMSbep/g7KU43
         ltQNnCH9OiGTffgBabg9qYb+C2TTPZbJLX0uq5IGHF+ZO1sRlGKjXmOr/QZUOY59VTjp
         A3hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k5wgbbVMzxT1FGv3ToNsrykCep98GtsONmeu7ExUc9Q=;
        b=ZfcAik2ZNy2frtniD46WG8wkwYw4l3oScdd6b6dt0e/6FGOhPX3OwBT2JV85NqysW0
         +B1Ksf/KTzBNSFHdjK7oViWB0iY1hetecjkQju8eO4AZ5TObqV2SuR4OkCS9cS8z1PzP
         WMZhf+mriEFclpN6NWtlSvu4mBIHVAX/hpnrCE1oE2ffzr9aWfdJRDX0EGcAh0xxyvZL
         BpL/1DqiASAL0/Cv4pPB+H9F0Tlt2mLPC782ofq3yvbNr/Hqgct1R0vkBx2n0jDC4o+Q
         kYAf6pFvw7+aXHE1SIBHvklMUqHgin3/S9e/q8J1UunW6Po+EwiU4W/BwRvNNAoqUUe2
         uSeA==
X-Gm-Message-State: AOAM531U+IQE8f14+R+aTyrGqXV7APdHGyHvL0Xd6ftkpQuPWQvsHHDs
        L74sC3Jp9CbRWCIu+HOuoxK3gsM6Z2L3kQBAUun0uA==
X-Google-Smtp-Source: ABdhPJwg3BtzWCk4ed0t1y77RW806RTg1nSgy4v/2th+J0/fN7ePNIb4Qp0MNC4cFS2diG3oqDYHS6+0sdvk4Sihi0E=
X-Received: by 2002:a05:6512:2627:b0:44a:f55c:ded9 with SMTP id
 bt39-20020a056512262700b0044af55cded9mr184036lfb.373.1651253283698; Fri, 29
 Apr 2022 10:28:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220407195908.633003-1-pgonda@google.com> <CAFNjLiXC0AdOw5f8Ovu47D==ex7F0=WN_Ocirymz4xL=mWvC5A@mail.gmail.com>
 <CAMkAt6r-Mc_YN-gVHuCpTj4E1EmcvyYpP9jhtHo5HRHnoNJAdA@mail.gmail.com>
 <CAMkAt6r+OMPWCbV_svUyGWa0qMzjj2UEG29G6P7jb6uH6yko2w@mail.gmail.com>
 <62e9ece1-5d71-f803-3f65-2755160cf1d1@redhat.com> <CAMkAt6q6YLBfo2RceduSXTafckEehawhD4K4hUEuB4ZNqe2kKg@mail.gmail.com>
 <4c0edc90-36a1-4f4c-1923-4b20e7bdbb4c@redhat.com> <CAMkAt6oL5qi7z-eh4z7z8WBhpc=Ow6WtcJA5bDi6-aGMnz135A@mail.gmail.com>
 <CAMkAt6rmDrZfN5DbNOTsKFV57PwEnK2zxgBTCbEPeE206+5v5w@mail.gmail.com>
 <0d282be4-d612-374d-84ba-067994321bab@redhat.com> <CAMkAt6ragq4OmnX+n628Yd5pn51qFv4qV20upGR6tTvyYw3U5A@mail.gmail.com>
 <8a2c5f8c-503c-b4f0-75e7-039533c9852d@redhat.com> <CAMkAt6qAW5zFyTAqX_Az2DT2J3KROPo4u-Ak1sC0J+UTUeFfXA@mail.gmail.com>
 <4afce434-ab25-66d6-76f4-3a987f64e88e@redhat.com> <CAMkAt6o8u9=H_kjr_xyRO05J=RDFUZRiTc_Bw-FFDKEUaiyp2Q@mail.gmail.com>
 <CABgObfa0ubOwNv2Vi9ziEjHXQMR_Sa6P-fwuXfPq76qy0N61kA@mail.gmail.com>
In-Reply-To: <CABgObfa0ubOwNv2Vi9ziEjHXQMR_Sa6P-fwuXfPq76qy0N61kA@mail.gmail.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 29 Apr 2022 11:27:51 -0600
Message-ID: <CAMkAt6pcg_Eg49nN5hS=wbeVWtPV1N_12G9Lvfgoq_bS_tUYog@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: SEV: Mark nested locking of vcpu->lock
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     John Sperbeck <jsperbeck@google.com>,
        kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 11:21 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On Fri, Apr 29, 2022 at 7:12 PM Peter Gonda <pgonda@google.com> wrote:
> > Sounds good. Instead of doing this prev_vcpu solution we could just
> > keep the 1st vcpu for source and target. I think this could work since
> > all the vcpu->mutex.dep_maps do not point to the same string.
> >
> > Lock:
> >          bool acquired = false;
> >          kvm_for_each_vcpu(...) {
> >                  if (mutex_lock_killable_nested(&vcpu->mutex, role)
> >                      goto out_unlock;
> >                 acquired = true;
> >                  if (acquired)
> >                       mutex_release(&vcpu->mutex, role)
> >          }
>
> Almost:
>
>           bool first = true;
>           kvm_for_each_vcpu(...) {
>                   if (mutex_lock_killable_nested(&vcpu->mutex, role)
>                       goto out_unlock;
>                   if (first)
>                       ++role, first = false;
>                  else
>                       mutex_release(&vcpu->mutex, role);
>          }
>
> and to unlock:
>
>           bool first = true;
>           kvm_for_each_vcpu(...) {
>                 if (first)
>                       first = false;
>                 else
>                       mutex_acquire(&vcpu->mutex, role);
>                 mutex_unlock(&vcpu->mutex);
>                 acquired = false;
>           }
>
> because you cannot use the first vCPU's role again when locking.

Ah yes I missed that. I would suggest `role = SEV_NR_MIGRATION_ROLES`
or something else instead of role++ to avoid leaking this
implementation detail outside of the function signature / enum.


>
> Paolo
>
