Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4656EAA5F
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 14:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbjDUM2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 08:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDUM2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 08:28:38 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7832A5EA
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 05:28:37 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id af79cd13be357-74db3642400so208347985a.2
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 05:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682080117; x=1684672117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LaA2IxjFzdB4pL6Hvh4e5PWI3DFz5C3NfZLvof2RS6A=;
        b=CfrWzaBJwLGlpq2Gqmthv22Pig8tuTHuNDHAwh+Zwb35qvZ9Tw/barFCYvaCT/GTNO
         yD96aXapUnJ3gsbmNB0YC2mWV/gcrBeIW3Ed/6K8PeT+fekkOG9TLF/FhOCHgeMtVU65
         nRlMSgUZkio33xAqsOGrBe/v6Lc9GIIoCKctOgoYKS5g9Voz02LdJ5BLxOPWUY7oMNMZ
         IpppfvrtCiW651UQ7JA7LsJUpgixgczrcnBYq+0FgJDBrvkgq+tYA/R52+k3FQGMIpwM
         ticuqGxj+QynHWT1IB3fIYdj+EHQ+wkU2xws491CPNeb+DfJVLZWflTpMv+UhKKYS9B4
         //8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682080117; x=1684672117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LaA2IxjFzdB4pL6Hvh4e5PWI3DFz5C3NfZLvof2RS6A=;
        b=ater8kMsMc5teWIHmLrcuyX2tS7Tfg54OuXQAB6dCdx4MGcveyycM9KMSmsvRq5z4+
         lgRujstk25Ce9wlZ6WEb5oUZHHJg6v4tuQ60CaSJxJb+tQzazm6sbJVqOFq9Vbvw5EKZ
         XAscXkksGXpE6iNGMPfS+O6HIACZXRlW8W6dFogVza5OJE0ke8H9N4QktgliKV8sTS+0
         gfeZ57cfqoG0vpFL5YqFQrG3D37X0hQVDYVdY1VnwGkMg6FdLEvhaI9LKFQTSaEK9U6w
         bv67b+Vmw3H8sEOiCtbGffJSyluU+Q67OzDn80xsgaUcLMVieR6uBls0+m8dqUmTQHJd
         yD9w==
X-Gm-Message-State: AAQBX9d6xWJBzuT1J8Ziu0pSin2Uhm9RlAaJ0YVVNG7aYqtBulNj4kEq
        XFn2QIQETjuF/V6oAautzOuNRLoWpT92cTqsCzI=
X-Google-Smtp-Source: AKy350Ytf21NwN1nkXRDtNVotBxyI5dApyXftcbFhG6ouEugUyR9diFOOTcR/HxPw0BIZw53qTagDEJw9DpAtQZP5b8=
X-Received: by 2002:ad4:5f0f:0:b0:5e9:9eb:e026 with SMTP id
 fo15-20020ad45f0f000000b005e909ebe026mr8473624qvb.29.1682080116952; Fri, 21
 Apr 2023 05:28:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-6-amoorthy@google.com>
 <a518e669-c758-57c8-3ba9-b4844e2cb79d@gmail.com> <CAF7b7mopmS5dQEQSC4g5NVmDpfV7UJv2UursruROrr3kb=BQHQ@mail.gmail.com>
In-Reply-To: <CAF7b7mopmS5dQEQSC4g5NVmDpfV7UJv2UursruROrr3kb=BQHQ@mail.gmail.com>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
Date:   Fri, 21 Apr 2023 20:28:26 +0800
Message-ID: <CA+wubQAvt4UxvJV17hx-V-93cH7Wz0cgGyEDbu90gD0sOsCHMA@mail.gmail.com>
Subject: Re: [PATCH v3 05/22] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anish Moorthy <amoorthy@google.com> =E4=BA=8E2023=E5=B9=B44=E6=9C=8821=E6=
=97=A5=E5=91=A8=E4=BA=94 02:10=E5=86=99=E9=81=93=EF=BC=9A
> > struct exit_reason[] string for KVM_EXIT_MEMORY_FAULT can be added as
> > well.
>
> Done, assuming you mean the exit_reasons_known definition in kvm_util.c

Yes.
