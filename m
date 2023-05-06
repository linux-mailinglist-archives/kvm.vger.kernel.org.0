Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6106F8D6E
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 03:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbjEFBSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 21:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjEFBSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 21:18:08 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376FB5FE9
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 18:18:07 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50bc075d6b2so4688293a12.0
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 18:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683335885; x=1685927885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9xWunwBjreINeCb0tO4bVmW1S3dLtRxVeicO2rC/ju8=;
        b=6gF+SduOYgncFnt7ZoiU1yx51SAGT7MsKJ8qMRLCFbcZLolcmF75btB31W65qIZKqG
         RcwwpNxWFCNe6YCvsTUo5bO8745sK8NoXqJLZQYb1yL9bWX6xxNGHV/8cAtsND72KXUT
         +R5EXLe7k15qKVOt9ir0LkDHmRWKDxRZ4IiinvbaIAwrS3+7iZZsXhpsj41lajkfxaGx
         OmPjbVrffr7ffl54AIh2BBVarNlhvD0ZNVDStiGuh8fb8EV9+kNsdliptmErMyCjQWF0
         YI081B68yYJtReicH84crcE1AYrOaCc6CtpHxDf+oTFdQuckCpxwLrpZ73i5EeHCf77N
         tXfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683335885; x=1685927885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9xWunwBjreINeCb0tO4bVmW1S3dLtRxVeicO2rC/ju8=;
        b=j+GeKhf4RmBtYrIXiTkL/yoPA69CyoDaaI725fPnFnnHm+bJ6FFlisBmMec1VKKsbY
         spKWrVcQ26rJCKUPEI/bjWjLycSJq4XuQyIxMsJgNAR8bbzIYxS4Weg9+08HnJ795jo2
         XYYC6cIYfqm18KFmkYhviIxjeI4Kd+L2XF6cUWqcdwZwo5NgFLbumiKGHlhVICdJt1uP
         W4MyqHt79pZzqkXD90wn+NYn3M2UFXpRNECp62bl6XsezyP2jk+nZsFlUQO8P/JYLuUl
         iZsWAZ1EHM4EoPAQD7AsIalRpOcK2LyyDMEFYNF2bLzww37mWzGKj4YNUoMp/dr9WZgK
         yj3Q==
X-Gm-Message-State: AC+VfDxLO899G0BSx1hTC6/QVFnayj5TsJY4WHQIcZRddcdj6AG6Ozlk
        DLNEnhs/lE6Uj3CQ77gDj1TkRTq7EAqS8vi0fA3zhA==
X-Google-Smtp-Source: ACHHUZ7u4889MI8XKPWoYqh+hmmV7kq1hmv0/5hgbUWSzYNJEMPiTmCrxeOzedFVKJlWbn8rSBaDbniD+gAkIxH/I1E=
X-Received: by 2002:aa7:c0d7:0:b0:50b:d53d:7ceb with SMTP id
 j23-20020aa7c0d7000000b0050bd53d7cebmr2386748edp.40.1683335885503; Fri, 05
 May 2023 18:18:05 -0700 (PDT)
MIME-Version: 1.0
References: <ZEM5Zq8oo+xnApW9@google.com> <diqz8re2ftzb.fsf@ackerleytng-ctop.c.googlers.com>
 <ZFWli2/H5M8MZRiY@google.com>
In-Reply-To: <ZFWli2/H5M8MZRiY@google.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Fri, 5 May 2023 18:17:54 -0700
Message-ID: <CAGtprH9UTL5_3F4Zad38vasTWse43GEP3HHdCHtYyWkCTwu_gA@mail.gmail.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ackerley Tng <ackerleytng@google.com>, david@redhat.com,
        chao.p.peng@linux.intel.com, pbonzini@redhat.com,
        vkuznets@redhat.com, jmattson@google.com, joro@8bytes.org,
        mail@maciej.szmigiero.name, vbabka@suse.cz,
        yu.c.zhang@linux.intel.com, kirill.shutemov@linux.intel.com,
        dhildenb@redhat.com, qperret@google.com, tabba@google.com,
        michael.roth@amd.com, wei.w.wang@intel.com, rppt@kernel.org,
        liam.merwick@oracle.com, isaku.yamahata@gmail.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 5, 2023 at 5:55=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> ...
> My preference is to make it a VM-scoped ioctl(), if it ends up being a KV=
M ioctl()
> and not a common syscall.  If the file isn't tightly coupled to a single =
VM, then
> punching a hole is further complicated by needing to deal with invalidati=
ng multiple
> regions that are bound to different @kvm instances.  It's not super compl=
ex, but
> AFAICT having the ioctl() be system-scoped doesn't add value, e.g. I don'=
t think
> having one VM own the memory will complicate even if/when we get to the p=
oint where
> VMs can share "private" memory, and the gmem code would still need to dea=
l with
> grabbing a module reference.

Copyless migration would be a scenario where "private" memory may need
to be shared between source and target VMs depending on how migration
support is implemented.

Regards,
Vishal
