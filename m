Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03953608577
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 09:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiJVHdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 03:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiJVHdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 03:33:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC3757E3C
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 00:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666423983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UD1oLm9Hn5bxNzWtEkUvZu/ox9ybbs3hLmz1f3bzisg=;
        b=cppRghMl3bOcK2nQm/xjJ34S2oe58OWr7B6P7/nyUykeZA+rhgkr/crHJ1s80u4BjN6Okg
        DFilhSItTPxdbLzgFdl9zP/FOgT7CvnlyPnAR/cmCs9RTI8+6UxFUGt8GZiyGpuCURJvi7
        xM4cJuRMome/Lj/ngHpsbef+KXLZ7cU=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-260-RzMfYeyQOti59eS2TSlUuA-1; Sat, 22 Oct 2022 03:33:02 -0400
X-MC-Unique: RzMfYeyQOti59eS2TSlUuA-1
Received: by mail-ua1-f72.google.com with SMTP id g13-20020ab05fcd000000b004031088f012so1357420uaj.23
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 00:33:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UD1oLm9Hn5bxNzWtEkUvZu/ox9ybbs3hLmz1f3bzisg=;
        b=zrVR/l417UHS+Qn9ydoeMvnML+Y+RSLwqaxSW0EqdKuOsl/ELgVacQ2iJmp6d4OyQk
         /n+93EtwgrjpE+JD+o1RPFoUXkNhBSTJnlEi15mYda9krjxGcDlBehyhhQL/ue2Jnepg
         UF+A35diPfNgZ9tVrS2JPMKCWNVA3iSOAd0jgLJMiVDrprH0ji6bXktAVH/VkkVuFQwd
         Q2oj1LniWx5yUDwdiFq4Xc+sGCFhdQOKKHfd0/uZ8R7p3/MyeMYA6klVSxLjpUo4EDIR
         D660q683AIpeByt//NyuZL9QMzqj57kiJSmgnz5G79ndRWzAKymEV2YN8YVtj4dDGP0H
         awnw==
X-Gm-Message-State: ACrzQf3h4CBWyUDSUhAHLgTZ4lVBH6pG2T0YWU9Onb2T+ju8/kEtySc2
        0mIqXW1PU8eTt5fPiYVnNf3ddxiZKldmX35U7NX+UzwR3eJrysBS6/K/5LcRb5ArUipiL4HO7Aj
        clqmsQ8l4gWDwmxJz6vD6Wjzf9IQx
X-Received: by 2002:a05:6102:290f:b0:3a9:58e4:21e4 with SMTP id cz15-20020a056102290f00b003a958e421e4mr15185757vsb.16.1666423982080;
        Sat, 22 Oct 2022 00:33:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7n2r61OPuivZoFkcwGIIhNnUj6Oumoro17gWYamx6wmsyOrWyfDfcB7j2agdpVk+jXKxHd35lMn+Edv5flcH8=
X-Received: by 2002:a05:6102:290f:b0:3a9:58e4:21e4 with SMTP id
 cz15-20020a056102290f00b003a958e421e4mr15185746vsb.16.1666423981772; Sat, 22
 Oct 2022 00:33:01 -0700 (PDT)
MIME-Version: 1.0
References: <20221013132830.1304947-1-maz@kernel.org>
In-Reply-To: <20221013132830.1304947-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sat, 22 Oct 2022 09:32:50 +0200
Message-ID: <CABgObfaPLnwLVL3_QYwPw2ToaBJ331ihuSHqo2bqzr-mEauw5Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.1, take #1
To:     Marc Zyngier <maz@kernel.org>
Cc:     Gavin Shan <gshan@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 13, 2022 at 3:28 PM Marc Zyngier <maz@kernel.org> wrote:
> Paolo,
>
> Here's the first set of fixes for 6.1. The most interesting bit is
> Oliver's fix limiting the S2 invalidation batch size the the largest
> block mapping, solving (at least for now) the RCU stall problems we
> have been seeing for a while. We may have to find another solution
> when (and if) we decide to allow 4TB mapping at S2...
>
> The rest is a set of minor selftest fixes as well as enabling stack
> protection and profiling in the VHE code.
>
> Please pull,

Done, thanks.

Paolo

