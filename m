Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C2E74B614
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 20:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjGGSGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 14:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjGGSGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 14:06:14 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA882110
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 11:06:13 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id 71dfb90a1353d-47e3c76fe7fso832444e0c.0
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 11:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688753173; x=1691345173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TqypugKQXZjj/NYiOBpd9Ow35utqsr2sWxi8Xw/IL/w=;
        b=f8AWRl/xIOmT1/naGq0CvDemv3Fh/xm/gc/2dITYuFqKGtBKaH66YsIkJzg5wqTiyN
         Qs5oONLBe2h9wO8xvluWJ/l5uGd68P2ipVEXZmJAAlYBeY2GWA4ZvOIJHUKCiMWZ/Yhg
         NX1JzexTWa0cWQwluGEXIXIg9Si8cfyRsCZJB1h72/qxdl80gVlvAautmX0cM+kY/vAO
         XpKmYBmnHZHdHpFAgp/OHapIOHoXRhIcZRR8yYH9DsfBnxV0fk5pnOaFoMdxvv8/MlVP
         RKxa852US+oL0f5OgN5fyhz/Xw1NYAFSK7Ug+JPE5OKq0KB51H/8YJvbSjwksGFmmxt+
         ntJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688753173; x=1691345173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TqypugKQXZjj/NYiOBpd9Ow35utqsr2sWxi8Xw/IL/w=;
        b=DcGWM7yahFdqU/nhUMDRngT6QUKrbfYq6gWlfo/Y8pTcLOdDzabs9dsWJ3L8XnEXwj
         /GJCd4wQeIK0ftzhI78Dem6+I4lkAuAcmXEHf+jRIA1Mu4q4U5q/AiTv9sQmSzuQ4teb
         Yt3l06zM1YBjGYo+qw8tDamvgRG2TGdSOCQzg9gL8xpb/NpJmMTXQGTjXTB/h7z5vsdX
         t6NS4JJLNtS22YNZgo35f1V3kgcKISHMw3Ur7fPtfuGvNUz4xloD0YnMKvYzO5MRiTxC
         Z0ZB0mC8Tb+i3VnqKbx4M0M1EYO02dERq8xEPbc1K13n8+QJVAljCW/Q+73m0BDppaVO
         ZkYg==
X-Gm-Message-State: ABy/qLY6Evrw826jlRADMS+9fp2MDCSiLhY4FvcvmkQiQiVk55M3Zb+R
        q9TNfVjJl7IC4L7VhWaRiUQNfj1hr3qV7rB1KiabpA==
X-Google-Smtp-Source: APBJJlGi7OAkQcSYaK+NBRpEFW1iek9g+QZQvOeV63zyIQ3Jo0THiIx/dzD0Ma2Z0+/rSIsa8joQgLBMdgXTia2BfUM=
X-Received: by 2002:a1f:db81:0:b0:471:2b9d:1e85 with SMTP id
 s123-20020a1fdb81000000b004712b9d1e85mr3250468vkg.14.1688753172966; Fri, 07
 Jul 2023 11:06:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-9-amoorthy@google.com>
 <ZIodEnUmwIv+Iuqd@google.com>
In-Reply-To: <ZIodEnUmwIv+Iuqd@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Fri, 7 Jul 2023 11:05:37 -0700
Message-ID: <CAF7b7mr=v4oOMOaSWd2hYGCNc0JrUoiWki0WP52xZ1CJhU_=Zw@mail.gmail.com>
Subject: Re: [PATCH v4 08/16] KVM: x86: Annotate -EFAULTs from kvm_handle_error_pfn()
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023 at 1:03=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> We have a helper for this too, gfn_round_for_level().  Ooh, but this isn'=
t storing
> a gfn, it's storing a gpa.  Naughty, naughty.

Caught in mischief I didn't even realize I was committing :O Anyways,
I've taken all the feedback you provided here. Although,

> All that said, consuming fault->goal_level is unnecessary, and not be coi=
ncidence.
> The *only* time KVM should bail to userspace is if KVM failed to faultin =
a 4KiB
> page.  Providing a hugepage is done opportunistically, it's never a hard =
requirement.
> So throw away all of the above and see below.

I wonder if my arm64 patch commits the same error. I'll send an email
over there asking Oliver about it.
