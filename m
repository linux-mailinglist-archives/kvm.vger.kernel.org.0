Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6B977E2C0
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 15:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245594AbjHPNj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 09:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245668AbjHPNjY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 09:39:24 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E9626AA
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 06:39:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d6861869bcdso5235693276.3
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 06:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692193162; x=1692797962;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qjBB+Xzq/GvNmpPnRskR0EICzJkdM/dxZettTvi4CjI=;
        b=KPi+rGDgk7mm/LRgr7mpbcZNwO0VRb7nYCLi6YAi1zdHi4Pw0oJ/Yj9cNQQ07vCa7+
         JNoovGqbU/K55F4LpOZfbQxjr1dCh3er3Bg0crdnLJf98/ObYmXVCbrb+f2xaArtk7cv
         dZtfKJecmqXFAQuDFesYQ1RnJmvQJJIr08sHL159ypOBtRD+hz/CGp2wS2P6GhvcY8EQ
         B3rcTPGVO7sgKEt3W1busYHPSMT8/UCYjziVJnCNe4enF9y8lO7guNtHNhUETXzDjH+1
         4PsLf0kU27CEzxQpioUGimNwK5Y8oeHU3eE9fexD8UP1i1Oj4fSdDwn4VVhK20FBrNLd
         xHHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692193162; x=1692797962;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qjBB+Xzq/GvNmpPnRskR0EICzJkdM/dxZettTvi4CjI=;
        b=V2O43+ovGIQzdSC+Fp/SgZop6Ek8WChTDQQ/V/+e9ekYc8BwTwgvskEe32XHF1Akwx
         igMNxlJJ0cfqOxVrWW8cVfiYxi/W0og+vKGIR5Uug0AY/LCOVpvJ4D65ftu7dvqyNW6g
         qdxZYpjHDefrmJ5KfYiz9ItEvaLqYMFNNTatDTaLdeDGNrMpbCw/0oULgPbS0TDytkNB
         Gtmp8T4JvNfHQ8SC8SGGU87Z+tUVbt64ee1vBc1M1J9W40tzofK70O1EdnlocBAq2tk+
         kTr3MvZBaUGZuaGPiCiApK7wBwNuOIcEtMGiIIzXf96494OL4cIOXcid30VMrJP6lidV
         qBpg==
X-Gm-Message-State: AOJu0YzkCad5fKC7DHUCdQDoq0oIp3bGAQuGhtv0fZ/MUHLI8KG3SDdo
        Mr9JnJVUU+fKV6AOLAi6AL7j3vnT1+I=
X-Google-Smtp-Source: AGHT+IFWP0NUlvjkvht2jsW+fNJwVcLRVJBmUBKb7IbXE8/dRg9cj8UwboYpVeRqZUfyteoqaz0cmifLHbw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e6d2:0:b0:d72:8661:ee25 with SMTP id
 d201-20020a25e6d2000000b00d728661ee25mr8108ybh.2.1692193162535; Wed, 16 Aug
 2023 06:39:22 -0700 (PDT)
Date:   Wed, 16 Aug 2023 06:39:20 -0700
In-Reply-To: <624efb22-8723-d813-0943-edab2870b51d@loongson.cn>
Mime-Version: 1.0
References: <ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com> <ZNpZDH9//vk8Rqvo@google.com>
 <ZNra3eDNTaKVc7MT@yzhao56-desk.sh.intel.com> <ZNuQ0grC44Dbh5hS@google.com>
 <107cdaaf-237f-16b9-ebe2-7eefd2b21f8f@loongson.cn> <c8ccc8f1-300a-09be-db6b-df2a1dedd4cf@loongson.cn>
 <ZNxbLPG8qbs1FjhM@yzhao56-desk.sh.intel.com> <42ff33c7-ec50-1310-3e57-37e8283b9b16@loongson.cn>
 <ZNx4OoRQvyh3A0BL@yzhao56-desk.sh.intel.com> <624efb22-8723-d813-0943-edab2870b51d@loongson.cn>
Message-ID: <ZNzRiL9e2wzmB7KI@google.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
From:   Sean Christopherson <seanjc@google.com>
To:     bibo mao <maobibo@loongson.cn>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mike.kravetz@oracle.com, apopple@nvidia.com,
        jgg@nvidia.com, rppt@kernel.org, akpm@linux-foundation.org,
        kevin.tian@intel.com, david@redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 16, 2023, bibo mao wrote:
>=20
>=20
> =E5=9C=A8 2023/8/16 15:18, Yan Zhao =E5=86=99=E9=81=93:
> > On Wed, Aug 16, 2023 at 03:29:22PM +0800, bibo mao wrote:
> >>> Flush must be done before kvm->mmu_lock is unlocked, otherwise,
> >>> confusion will be caused when multiple threads trying to update the
> >>> secondary MMU.
> >> Since tlb flush is delayed after all pte entries are cleared, and curr=
ently
> >> there is no tlb flush range supported for secondary mmu. I do know why=
 there
> >> is confusion before or after kvm->mmu_lock.
> >=20
> > Oh, do you mean only do kvm_unmap_gfn_range() in .invalidate_range_end(=
)?
> yes, it is just sketchy thought for numa balance scenery,=20
> do kvm_unmap_gfn_range() in invalidate_range_end rather than
> invalidate_range_start.

That is not an option, it's a direction violation of the mmu_notifier contr=
act.
Secondary MMUs must drop all references before returning from invalidate_ra=
nge_start().
