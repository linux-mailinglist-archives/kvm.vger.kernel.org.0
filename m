Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D262F6D6E6B
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 22:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbjDDUvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 16:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236300AbjDDUvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 16:51:14 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AA34685
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 13:51:02 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id bx42so9657809oib.6
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 13:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680641462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EWld2DJgsr3xhsXTYvy21HtOymPU5OqulnM80zqfg8Y=;
        b=EkBKjiDVLODWFdpJFcFh8O0aykY31wBxbHEzGsglQCXpXUxbloMC4ZIlwS3k/vDXkV
         CH0QRAtpbyXcWKFxGvSg9BhILVEuQbdVhGuqhLYOJDcJw1tnYEknElbq2x5vMEZ3tk4J
         AOlfZTAfUt8Oryal5xVNf9jrI9Z+CLyn50e6CHQiWRvYQs9nb4EnNDx7VKM+BZTvCAai
         IlDXOHX/AyhWCwoCyubxmWfmotQbGZgCnwwsZuwWz2ByEKqx2ghK7IlZtcoEGdGh8LEM
         LA1/OtBQmGSO7eyh7IuiWfqmWR+BCsWUrne4QK/eucDpWmmWL4HHW8qKTD2q82S0k5cu
         uqzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680641462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EWld2DJgsr3xhsXTYvy21HtOymPU5OqulnM80zqfg8Y=;
        b=oJI2S5Urub+KMLmPXU2dNKSKstBBvImI5hykxGoRMyhbi/LWsHNnH6XMzV9SyYUI0r
         kCNKyokZSjSzAiGYpGDrC9qBTav3YDHidRfCENheLyzWp3qol8CEkpZZEpxgLdyrElKV
         8fZolrBn/4RUf/SK5X6FWdiz1iLDoBmUiThfGU307BqXLwxg5T4/bknm3yWd+2y8yFpm
         13H4X85QYsYztCgfb0/XgRlDaJOXfwUiPFIZ73d9C9XZQEmRWExAe/79huKtn2DKXY65
         EgRiGPY3Gu+NGvb2MoQ8RMmf33T6rTQoFAPsxiwP3KFRQBVAdbqIpkSOFCaMPbmxFNG+
         zIsw==
X-Gm-Message-State: AAQBX9csZ+R+8vxvM6xvxZBCpzCYY0Ku2oVvXISXit/pY2XlFml4ZL5k
        MzAkVRY6EEN7imMA6Rn5PxiGLmEm3zt/32GE/+7f6w==
X-Google-Smtp-Source: AKy350Yww45xogvO5C7Z+SimshwIN+RETKNV2T6Sz5QzE93xiFMN/sSAK18mghWAPp1x73tX4TLvF3PGLLGdqPlIeiM=
X-Received: by 2002:aca:171a:0:b0:389:50f2:4aa6 with SMTP id
 j26-20020aca171a000000b0038950f24aa6mr1422388oii.9.1680641461577; Tue, 04 Apr
 2023 13:51:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com> <20230206172340.2639971-4-rananta@google.com>
 <ZCTe5koj8fOgbrYO@linux.dev> <CAJHc60x-ZHN=ZQemZp0wkj5jp-Ys8024YDQmWhmKn3NgZ0HHCQ@mail.gmail.com>
 <ZCxwjYf+EjuB64iH@linux.dev>
In-Reply-To: <ZCxwjYf+EjuB64iH@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 4 Apr 2023 13:50:49 -0700
Message-ID: <CAJHc60zz1Wef+1rKFBZB2jmoHuFgs=Q9_QK7UKbc6hfff7i=iA@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] KVM: arm64: Implement __kvm_tlb_flush_range_vmid_ipa()
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 4, 2023 at 11:46=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Mon, Apr 03, 2023 at 02:08:29PM -0700, Raghavendra Rao Ananta wrote:
> > On Wed, Mar 29, 2023 at 5:59=E2=80=AFPM Oliver Upton <oliver.upton@linu=
x.dev> wrote:
> > >
> > > On Mon, Feb 06, 2023 at 05:23:36PM +0000, Raghavendra Rao Ananta wrot=
e:
> > > > Define  __kvm_tlb_flush_range_vmid_ipa() (for VHE and nVHE)
> > >
> > > bikeshed: Personally, I find that range implies it takes an address a=
s an
> > > argument already. Maybe just call it __kvm_tlb_flush_vmid_range()
> > >
> > Hmm, since TLBI instructions takes-in a variety of ranges, VA or IPA,
> > I just thought of extending the '_ipa' to make things clear. Moreover
> > it aligns with the existing __kvm_tlb_flush_vmid_ipa(). WDYT?
>
> Like I said, just a bikeshed and it seemed trivial to eliminate a token
> in the function name. FWIW, you're dealing in terms of the IPA space by
> definition, as a VMID identifies an IPA address space. Range-based
> invalidations by VA would instead take an ASID as the address space
> identifier.
>
Okay, let's rename it to  __kvm_tlb_flush_vmid_range().

Thanks,
Raghavendra
> --
> Thanks,
> Oliver
