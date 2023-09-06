Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976727941AB
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 18:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239760AbjIFQqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 12:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238771AbjIFQqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 12:46:46 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A546D19A8
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 09:46:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d7ba519f46bso3312936276.3
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 09:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694018797; x=1694623597; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kEa2f2r5+8Ye+Y3Rea4IpiSzc5RRjFLgk939Csd8Y4M=;
        b=Yg24c9SNOTTkFvibF8PFkt7lW4a8rdTwsJwHSCCSBU0Uk/wah0KNuFyiURaL0BZncs
         r9Umtta4njNB5/A/CUTZitx7/s3hScOxiTavoSJgvifhsQd2X8766hmPidYmqcZ24Uei
         ahS7a4CFvwyTix78Vr8SYPVjy3jmlKRJPoNCerMP0rhepbWtT4hyN29tbHN6hSOAMfs3
         PvZvMH/409+1SXWrjMWYDK3rkj6UpT3v/qINVB9Mpe55I9uPXTJnxxyeGgjC9ZBKwl0i
         KSq3CYSEOW9SQFQ6u9M3PvbzwN032MR8YR8lxBKq92m4I8IUqU00ev6clfeSAgl5bCxo
         SlHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694018797; x=1694623597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kEa2f2r5+8Ye+Y3Rea4IpiSzc5RRjFLgk939Csd8Y4M=;
        b=YqUnMlU5gbFckbSr2KnxMqH0FVKkCLYZSBYE2hz043/dv5sFS0rROU11d5MlkmoYUo
         j8H/+8A5mWdSp7h7yboUjWOIQzbjYueWXPNQEXgd8FuuJzlmR6SjgfzdOkAwU3hrdTv+
         rMVB5w15Rm8BFpUiE0I4Xq6vRvHY6yLaZzqrbg+PagdG/d7Mr94LOATYjia2OnwsuWX3
         cbNKfLNa4Cv5VjFRh5aFuYLPBkhNgDRVvtTpOHX5CFTk0dDHcxR02A2v5RSPnZKDq4/u
         3qiLXFZ7b10WdDtJnzb7GwwMh6kabVy48bHVfnLojvFensTIiX7LNoaBKCepKwyJpmvP
         UOuQ==
X-Gm-Message-State: AOJu0YwYn1EQ9X7Fk38NqH/sgiVrmhSVX/Xfcu5cClV0NpR/sYj4c6+d
        7n0Wybh4vqvTejlp8IaQfeW2WNRA+rE=
X-Google-Smtp-Source: AGHT+IEZlBFSJ9GJjDT/u5X8GlcTwrb4NN4jBAxF5f8C8zTwvYzgAueDPpLQsRb43imu0XVwrhKVQbKCp+k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1804:b0:d7a:c85c:725b with SMTP id
 cf4-20020a056902180400b00d7ac85c725bmr375293ybb.7.1694018796920; Wed, 06 Sep
 2023 09:46:36 -0700 (PDT)
Date:   Wed, 6 Sep 2023 09:46:35 -0700
In-Reply-To: <5d81a9cd-f96d-bcdb-7878-74c2ead26cfb@arm.com>
Mime-Version: 1.0
References: <20230808085056.14644-1-yan.y.zhao@intel.com> <ZN0S28lkbo6+D7aF@google.com>
 <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com> <ZN5elYQ5szQndN8n@google.com>
 <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com> <ZPWBM5DDC6MKINUe@yzhao56-desk.sh.intel.com>
 <ZPd6Y9KJ0FfbCa0Q@google.com> <5ff1591c-d41c-331f-84a6-ac690c48ff5d@arm.com>
 <ZPiQQ0OANuaOYdIS@google.com> <5d81a9cd-f96d-bcdb-7878-74c2ead26cfb@arm.com>
Message-ID: <ZPis61o4lkjr0mMU@google.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023, Robin Murphy wrote:
> On 2023-09-06 15:44, Sean Christopherson wrote:
> > On Wed, Sep 06, 2023, Robin Murphy wrote:
> > > Even non-virtualised, SWIOTLB is pretty horrible for I/O performance by its
> > > very nature - avoiding it if at all possible should always be preferred.
> > 
> > Yeah.  The main reason I didn't just sweep this under the rug is the confidential
> > VM use case, where SWIOTLB is used to bounce data from guest private memory into
> > shread buffers.  There's also a good argument that anyone that cares about I/O
> > performance in confidential VMs should put in the effort to enlighten their device
> > drivers to use shared memory directly, but practically speaking that's easier said
> > than done.
> 
> Indeed a bunch of work has gone into SWIOTLB recently trying to make it a
> bit more efficient for such cases where it can't be avoided, so it is
> definitely still interesting to learn about impacts at other levels like
> this. Maybe there's a bit of a get-out for confidential VMs though, since
> presumably there's not much point COW-ing encrypted private memory, so
> perhaps KVM might end up wanting to optimise that out and thus happen to end
> up less sensitive to unavoidable SWIOTLB behaviour anyway?

CoW should be a non-issue for confidential VMs, at least on x86.  SEV and SEV-ES
are effectively forced to pin memory as writable before it can be mapped into the
guest.  TDX and SNP and will have a different implementation, but similar behavior.

Confidential VMs would benefit purely by either eliminating or reducing the cost
of "initializing" memory, i.e. by eliminating the memcpy() or replacing it with a
memset().  I most definitely don't care enough about confidential VM I/O performance
to try and micro-optimize that behavior, their existence was simply what made me
look more closely instead of just telling Yan to stop using IDE :-)
