Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68870610D2B
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 11:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJ1J2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 05:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJ1J2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 05:28:23 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAAE541B4
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 02:28:21 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id n12so11526302eja.11
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 02:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o1dEA6QDjwPI5Lqqp4PnQXLAiiJ6pk7DSaf8g2e6LNg=;
        b=rpEWC7xCFV/pUAbhRF1OBflH1ReSXldbCEKcEiVXMZLJXp8WrR3mYW7CBPs9qGTxSM
         UGFff4Lu0d14TN77FyLd0S9EnSY0LwHdWlyjmpIw5Uh3bqrlOxRssh9m5P40Wz4xRloS
         OLJbpdgCIaF2TJ1p94MYswxOseYLaRD3oo1680naj5NFO8VNcKuVHpXns4R/T0kzSnSl
         6sG2RtN/JJuOujfjwbAwgoeAyXZeOCk7QVT+a7GTgDbEMqsXhoFR3DCAWpYLwzhnx/3T
         862fYsgfYJ1UwFXWPaEkP6iNe3jaIGVJaxoW84T8ZgKGeEwDHbbx+wTlIeFXqFzuv6Nl
         iVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o1dEA6QDjwPI5Lqqp4PnQXLAiiJ6pk7DSaf8g2e6LNg=;
        b=HV6zHPSygZAm/mAm18R9urjNyAwNm/xPOaSd7ZK08ZdB0mGOlzEUYbCkP9Sv/hgtg+
         gX9+qoYA7fOUo56127GZwrSMJo0zPmRGv7IgbyzIRSmdfcMf2QwnDND/++jSbAZe3dgB
         qmVLBGQpzDROYTmz3/2eF2Dl6wd1JPH8c4No/SmzXfz4jI3s/ISQb6ZoJLaZbDDI39ca
         tZ4qHqJlt7Xpw0i1bXJJt0FeOo3ykbKxf5MnpV19YhVo3ObSmoPsDrmgukZOExf+oXIZ
         j2PohbT/0WlqF7yj25ZTXvlif1KK8aFmUSJWQXm0XkRKBsVUgS9xdVq2i881pl+f3rFt
         b1fA==
X-Gm-Message-State: ACrzQf04RooJ+74QXDPSd9NnoRKSYC8ojo6gLTGZqYbVUqMrOdpcKR3b
        dkS1RWilkfKRoZvf7svUo4YPyg==
X-Google-Smtp-Source: AMsMyM7L7iJ/b3nYLQTZha1zpDQVJblHC8G85NArgRqyqWymZq33WRAiEkkyQmt3H6qTWyPBQb1TDQ==
X-Received: by 2002:a17:907:980e:b0:78d:b6ea:25b3 with SMTP id ji14-20020a170907980e00b0078db6ea25b3mr45999011ejc.98.1666949299844;
        Fri, 28 Oct 2022 02:28:19 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id 24-20020a170906311800b007933047f930sm1909751ejx.157.2022.10.28.02.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 02:28:19 -0700 (PDT)
Date:   Fri, 28 Oct 2022 09:28:15 +0000
From:   Quentin Perret <qperret@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>, Marc Zyngier <maz@kernel.org>,
        kernel-team@android.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 02/25] KVM: arm64: Allow attaching of non-coalescable
 pages to a hyp pool
Message-ID: <Y1ugr1WKKbNIRKAh@google.com>
References: <20221020133827.5541-1-will@kernel.org>
 <20221020133827.5541-3-will@kernel.org>
 <Y1sfpM3IjNvr8ckf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1sfpM3IjNvr8ckf@google.com>
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

Hey Oliver,

On Friday 28 Oct 2022 at 00:17:40 (+0000), Oliver Upton wrote:
> On Thu, Oct 20, 2022 at 02:38:04PM +0100, Will Deacon wrote:
> > From: Quentin Perret <qperret@google.com>
> > 
> > All the contiguous pages used to initialize a 'struct hyp_pool' are
> > considered coalescable, which means that the hyp page allocator will
> > actively try to merge them with their buddies on the hyp_put_page() path.
> > However, using hyp_put_page() on a page that is not part of the inital
> > memory range given to a hyp_pool() is currently unsupported.
> > 
> > In order to allow dynamically extending hyp pools at run-time, add a
> > check to __hyp_attach_page() to allow inserting 'external' pages into
> > the free-list of order 0. This will be necessary to allow lazy donation
> > of pages from the host to the hypervisor when allocating guest stage-2
> > page-table pages at EL2.
> 
> Is it ever going to be the case that we wind up mixing static and
> dynamic memory within the same buddy allocator? Reading ahead a bit it
> would seem pKVM uses separate allocators (i.e. pkvm_hyp_vm::pool for
> donated memory) but just wanted to make sure.

So, in the code we have that builds on top of this, yes, but to be
frank it's a bit of a corner case. The per-guest pool is initially
populated with a physically contiguous memory range that covers the
need to allocate the guest's stage-2 PGD, which may be up to 16
contiguous pages IIRC. But aside from that, all subsequent allocations
will be at order 0 granularity, and those pages are added to the pool
dynamically.

> I suppose what I'm getting at is the fact that the pool range makes
> little sense in this case. Adding a field to hyp_pool describing the
> type of pool that it is would make this more readable, such that we know
> a pool contains only donated memory, and thus zero order pages should
> never be coalesced.

Right. In fact I think it would be fair to say that the buddy allocator
is overkill for what we need so far. The only high-order allocations we
do are for concatenated stage-2 PGDs (host and guest), but these could
be easily special-cased, and we'd be left with only page-size allocs for
which a simple free list would do just fine. I've considered removing
the buddy allocator TBH, but it doesn't really hurt to have it, and it
might turn out to be useful in the future (e.g. SMMU support might
require high-order allocs IIUC, and the ability to coalesce would come
handy then).
