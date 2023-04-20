Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884746E9F3E
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 00:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjDTWrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 18:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjDTWrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 18:47:42 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C4826B2
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 15:47:41 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f17e584462so10974225e9.2
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 15:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682030860; x=1684622860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I500wf29ShVTt/8kNXae6cb36NI8eexo7GrOocU/WMU=;
        b=IzlePHjF/qbChziTFLQN+LJ+aTmnw52wmdpyTv2kL0Q6NG/AyPO1+HnzacS7BWyViR
         pDE5N0vbgaHydiw7YYYTH4t4x15EHkEgR/eGyjZ3EJHkGn9rep5mViODsGV1QHBsDrSR
         ic+7OUcSUTfa1LkYLGX+EKMTxg51Gl0A3tltVxWIen3yafNjK6h6XR/D5kYMB66oGc+H
         e+rSrr0Tg9RP9DpJGFC3d+JukTOjaqFisiLC/x4+EXi9vIUiZ8aCq1KShJ79r/3Khsik
         5fW3/+LypYYbUUuJ1pqKWUd/CEug0j8xLPdFS+dXaTJLMjZLIMk/OwYy8/TSOEeFyZUN
         4cDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682030860; x=1684622860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I500wf29ShVTt/8kNXae6cb36NI8eexo7GrOocU/WMU=;
        b=hEvzWNdlBy0E/NCkwyFyeVAUNsMrAmQ3QWFKD7aKTO1CQ06T0evtzrXutedQW/Ltpr
         32Qo+FcsChM+dMxOAJZmETCZHoDcPf2EWBDEDU5Vg5AwOZjkqgZeYc/kbxdPaZl4A+xD
         FwsTZJ4NIVuGYdrr8HUJqDa/twCWPa/USqVSMwduaJTI6VHNnhZcDAda268KlwNOJPLf
         Fbs4usii/fWMZySOmHcNSYj3tI23DN3AWudcNiXjQZGZzOL1yvIhQVE/3WyyOKPQX4Qy
         WO8/rVffkUOXxckJyMY8QHttbRplsmTM7SmRpw1C5xD6uMS5c2HAMPGvWDnuqSDvCwUt
         m+Jg==
X-Gm-Message-State: AAQBX9fYErzdr2BIbrQPfF3YsXh0wHCuyj2XHDQJugQosVUBNtUY4xkS
        v2MTRl99XVXejIDBdUnpGam6GQwn0DsQ2Pao2MbnTQ==
X-Google-Smtp-Source: AKy350Z/7sBVzla3WvehW8q8Z1Pvmrks0DHxOdhv+P7CBhhNPJPBZ4RwV7tyeJqUXZTkzE3xfbV9xvVD5eqjL5iRCwY=
X-Received: by 2002:a1c:ed15:0:b0:3f1:6fb3:ffcc with SMTP id
 l21-20020a1ced15000000b003f16fb3ffccmr338953wmh.22.1682030860171; Thu, 20 Apr
 2023 15:47:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-23-amoorthy@google.com>
 <7db5a448-f3b2-2c43-1cf1-d7e75e8d06e1@gmail.com>
In-Reply-To: <7db5a448-f3b2-2c43-1cf1-d7e75e8d06e1@gmail.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 20 Apr 2023 15:47:03 -0700
Message-ID: <CAF7b7moF4p+f1sFVa+nYa+LqzpjpRqj7HV2eo3grE6mW0ppAug@mail.gmail.com>
Subject: Re: [PATCH v3 22/22] KVM: selftests: Handle memory fault exits in demand_paging_test
To:     Hoo Robert <robert.hoo.linux@gmail.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

On Wed, Apr 19, 2023 at 7:10=E2=80=AFAM Hoo Robert <robert.hoo.linux@gmail.=
com> wrote:
>
> I think this vcpu exec time calc should be outside while() {} block.

Ah, you're right: fixed.

> can this gettid() be substituted by tid above? or #include header file
> for its prototype, otherwise build warning/error.

Huh, not sure how I missed the warning. Thanks, and done.
