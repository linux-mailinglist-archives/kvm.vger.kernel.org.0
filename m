Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBE244E737
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 14:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhKLN0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 08:26:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231855AbhKLN0I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 08:26:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636723397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dyKHXIHlcMfQZRfkXKprwqg9ZzcuoNJyRdE1idLkbvo=;
        b=M4UgpKsV5dyjnupGMRZDbIUYxq5DJ6v33yjXjiMBVRgb8LRXRGxYz4kG8kEwvi/N8u31Lk
        FWgIudgr5FEjuRZDBCbNP9LBmT1Txe7m+k5dPiot6mAuh26MXt4RMmt4J2OJl70M3UICdo
        pddNA+Sz66F/+JGhw8haIb3yzFyp8E8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-l7B_jm3pN5W6WFWUewRi5w-1; Fri, 12 Nov 2021 08:23:16 -0500
X-MC-Unique: l7B_jm3pN5W6WFWUewRi5w-1
Received: by mail-ed1-f69.google.com with SMTP id w18-20020a056402071200b003e61cbafdb4so11006edx.4
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 05:23:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dyKHXIHlcMfQZRfkXKprwqg9ZzcuoNJyRdE1idLkbvo=;
        b=mU1n4LWZvpIYe01iYNi40Vc1iXyhVHZsaDk4NSrLnkS7GMQ11i6q8o+fuE8XnTcESw
         blAhOtdRJCxMMyPaI8A/65JL93HHdlyGe3bdzhp2oFgvVDNu2QD0UHf9KNaj+MW5TkY0
         z2lWzumPtuH2ADJK1pfpN3WjLkKBqfcAR5lSLOIVz9C/voH4HwQACfUie+pTSv7ZGe3Y
         E93H/iZw6kpFeKkjY5jEDSrUDMfkNEqQgVT5tXEeu0m7ifeLTAOh4XR6N5FzEmPtFgg0
         KaOy5zQe0CT4HNx8F6qd9gkQJv70w8HCnznHm9uR1amWONH6cxjoK9Lz5ZtcrowDffFk
         1gdw==
X-Gm-Message-State: AOAM532F8HUjfHKgOXCA4fA4FmaZNq/AZS7VIjaPTj7ZK++wGTs8HiBq
        TVrQ8n0blYTr15XT0ySV0RT8ZdgccIrs0pyeEI058AVtVrbhwLR6hl6pb/mOrfjQnyUef9drXeG
        qeelPBXuVmSDB
X-Received: by 2002:a17:906:3a48:: with SMTP id a8mr19304751ejf.458.1636723395069;
        Fri, 12 Nov 2021 05:23:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyY8HEfWPjz11A3Q4pU+tqaY6+zBIvvUXtomRkRBGvaA5KiR1eDXqnPaKamaP+yGLtQsTNnLg==
X-Received: by 2002:a17:906:3a48:: with SMTP id a8mr19304728ejf.458.1636723394897;
        Fri, 12 Nov 2021 05:23:14 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id n16sm3041819edv.79.2021.11.12.05.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 05:23:14 -0800 (PST)
Date:   Fri, 12 Nov 2021 14:23:12 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
        qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Message-ID: <20211112132312.qrgmby55mlenj72p@gator.home>
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211112114734.3058678-1-alex.bennee@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021 at 11:47:31AM +0000, Alex Bennée wrote:
> Hi,
> 
> Sorry this has been sitting in my tree so long. The changes are fairly
> minor from v2. I no longer split the tests up into TCG and KVM
> versions and instead just ensure that ERRATA_FORCE is always set when
> run under TCG.
> 
> Alex Bennée (3):
>   arm64: remove invalid check from its-trigger test
>   arm64: enable its-migration tests for TCG
>   arch-run: do not process ERRATA when running under TCG
> 
>  scripts/arch-run.bash |  4 +++-
>  arm/gic.c             | 16 ++++++----------
>  arm/unittests.cfg     |  3 ---
>  3 files changed, 9 insertions(+), 14 deletions(-)
> 
> -- 
> 2.30.2
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Hi Alex,

Thanks for this. I've applied to arm/queue, but I see that

FAIL: gicv3: its-trigger: inv/invall: dev2/eventid=20 pending LPI is received

consistently fails for me. Is that expected? Does it work for you?

Thanks,
drew

