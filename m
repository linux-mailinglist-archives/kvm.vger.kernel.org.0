Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B620D7B7461
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 00:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbjJCW74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 18:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbjJCW7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 18:59:55 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9385EAB
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 15:59:52 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id 71dfb90a1353d-49d0f24a815so695892e0c.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 15:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696373991; x=1696978791; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VuLZmgaV89lzOHymPqsmAC6abj1UTBHkava0gPj509c=;
        b=S4XgYEYPfREDWdSu1xAwH3YZDfIAr4/rwwxpQwj9gu2o+99V6Rnhlk/BDn6wdFAiIp
         74Ec52ZMjT9hjTnnlVIYeivXafpZtp1dPnQ3G0BtA24AnbUrsWagVZkVbLFoY526rCXW
         PXYj+GSQun3RsUb0iQmm0sITEBxu0Bm+nJWQ9DNmjNTyPWzFKfRGiXbCqxUoSMpK5IWK
         VONEyG0y1u+09xjPyLmVob/9KRIaTq0Ot8Pvbowp/A6ch3frxumOecXg9v1cJbkyoXM2
         lS1xJzYuFymxqw7kP5aV51GdVmjFCp1lysogazIoRO/9Lewe0VFdDWuf6R8e873yYKUY
         i7dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696373991; x=1696978791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VuLZmgaV89lzOHymPqsmAC6abj1UTBHkava0gPj509c=;
        b=ib98Hwfoz+pgwRWPANEwoWTHHMq4cuV84Wu8G9+PZcPZX/8Ho9nppMImk6ijiDMP5t
         p3iFDSg2oMIm5AuSOmHFIPb2O82ZYreTEmLaAZdNBIf90lcnQwtnlRMQQzVrCLH/y62I
         1Xw9Fr5L3mLRghPE/7R4U2x0CSQLdSwxrSjYwS+QrVOtXMFEahXcINjyDvGyq0USIWZq
         CUuqkOK96rG+rc5C8TG16cEMtxafX7YvT9hDCwDeKEhIq/YscMFodkoDwTqE8kqGrlSA
         cgdgFDHQRcQwuvk6gxxj+LXWHAqmlk5djZPeae+VG2LMbrGYO7RP6iVMOvE3zpo9QgUv
         nOJw==
X-Gm-Message-State: AOJu0YyKkNdSxd088DJgcWQuAptdSSIGz5jdVwJpDReGdG1+WIr3rDen
        qJ2/iC+ZyEFCQtngsQtbibYyIkQPra4NU+YAjJNwZw==
X-Google-Smtp-Source: AGHT+IHt/5hi86I5tWmFhMD1MR9ouSEy0bKqsB0WSgB1we3wcIPiKRqguWhLnlbBZgNBr6PNxrWaK8kmhmE6ei5mSik=
X-Received: by 2002:a1f:4887:0:b0:493:3491:ce89 with SMTP id
 v129-20020a1f4887000000b004933491ce89mr587565vka.14.1696373991201; Tue, 03
 Oct 2023 15:59:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-8-seanjc@google.com>
 <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com> <ZQ3AmLO2SYv3DszH@google.com>
 <CAF7b7mrf-y9DNdsreOAedGJueOThnYE=ascFd4=rvW0Z4rhTQg@mail.gmail.com> <ZRtxoaJdVF1C2Mvy@google.com>
In-Reply-To: <ZRtxoaJdVF1C2Mvy@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Tue, 3 Oct 2023 15:59:15 -0700
Message-ID: <CAF7b7mqyU059YpBBVYjTMNXf9VHSc6tbKrQ8avFXYtP6LWMh8Q@mail.gmail.com>
Subject: Re: [RFC PATCH v12 07/33] KVM: Add KVM_EXIT_MEMORY_FAULT exit to
 report faults to userspace
To:     Sean Christopherson <seanjc@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 2, 2023 at 6:43=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> > - I should go drop the patches annotating kvm_vcpu_read/write_page
> > from my series
>
> Hold up on that.  I'd prefer to keep them as there's still value in givin=
g userspace
> debug information.  All I'm proposing is that we would firmly state in th=
e
> documentation that those paths must be treated as informational-only.

Userspace would then need to know whether annotations were performed
from reliable/unreliable paths though, right? That'd imply another
flag bit beyond the current R/W/E bits.

> > - The helper function [a] for filling the memory_fault field
> > (downgraded back into the current union) can drop the "has the field
> > already been filled?" check/WARN.
>
> That would need to be dropped regardless because it's user-triggered (sad=
ly).

Well the current v5 of the series uses a non-userspace visible canary-
it seems like there'd still be value in that if we were to keep the
annotations in potentially unreliable spots. Although perhaps that
test failure you noticed [1] is a good counter-argument, since it
shows a known case where a current flow does multiple writes to the
memory_fault member.

[1] https://lore.kernel.org/all/202309141107.30863e9d-oliver.sang@intel.com

> Anyways, don't do anything just yet.

:salutes:
