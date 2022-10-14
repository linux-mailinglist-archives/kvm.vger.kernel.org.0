Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C156A5FEFE0
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 16:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiJNOKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 10:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiJNOKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 10:10:08 -0400
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C977F09E;
        Fri, 14 Oct 2022 07:10:07 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id x188so5150777oig.5;
        Fri, 14 Oct 2022 07:10:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KCRXtXm+S+Vgn1M1AL9cmatt1G/L/k3UGFpcLB8yDLw=;
        b=WvYIpFsu/g25Xp8u9dp6m2uH5tfidKFtl44gcAFVLmhu6UXsegtUjoe4woDlCOiLZL
         CF6VNT6s0W4OuJE7WdKUrezv7D7MNFEP4HnJ/ummPKim/6kIvf7EP2nF/pJ9WYxz8+mo
         yWZnhtRY1BmJAWPfSB8bHvMbTYi3xrZpmT0h2i5KMWnDJn0EDO03ZvPj6lXH9XwyWDjU
         5oq62y5Rsv0VmvkAsrrggMvts0Oy85yfY9x1x2Z+0mwYfOlylzOYQgAk+FeYjdTZZC4Z
         GdCkUEGG+r7wE+7ci8X8SaiTyh8KNKbQXn0C6j77HrIlVW4IrxyIuFLoBQLoAMXvtGAC
         VGSg==
X-Gm-Message-State: ACrzQf2cwO61iGjO0Azqm/YsDPCplbq4xupJJwyz9ccyJkKce4qazpbX
        BFmY5aYRv+8lMpmjQBlSFA==
X-Google-Smtp-Source: AMsMyM7j/oE8z7AS4zYm6NVvXj+ZM059l7CzZGm9ZwPzyh/uENyWJRMMKioNS3tpi0/g1yBaD5z7QQ==
X-Received: by 2002:aca:4303:0:b0:354:cbc8:d269 with SMTP id q3-20020aca4303000000b00354cbc8d269mr2470024oia.115.1665756606573;
        Fri, 14 Oct 2022 07:10:06 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id ep10-20020a056870a98a00b00136f3e4bc29sm1338643oab.9.2022.10.14.07.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 07:10:05 -0700 (PDT)
Received: (nullmailer pid 1893044 invoked by uid 1000);
        Fri, 14 Oct 2022 14:10:05 -0000
Date:   Fri, 14 Oct 2022 09:10:05 -0500
From:   Rob Herring <robh@kernel.org>
To:     Nipun Gupta <nipun.gupta@amd.com>
Cc:     krzysztof.kozlowski+dt@linaro.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, eric.auger@redhat.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        puneet.gupta@amd.com, song.bao.hua@hisilicon.com,
        mchehab+huawei@kernel.org, maz@kernel.org, f.fainelli@gmail.com,
        jeffrey.l.hugo@gmail.com, saravanak@google.com,
        Michael.Srba@seznam.cz, mani@kernel.org, yishaih@nvidia.com,
        jgg@ziepe.ca, jgg@nvidia.com, robin.murphy@arm.com,
        will@kernel.org, joro@8bytes.org, masahiroy@kernel.org,
        ndesaulniers@google.com, linux-arm-kernel@lists.infradead.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kvm@vger.kernel.org, okaya@kernel.org,
        harpreet.anand@amd.com, nikhil.agarwal@amd.com,
        michal.simek@amd.com, aleksandar.radovanovic@amd.com, git@amd.com
Subject: Re: [RFC PATCH v4 0/8] add support for CDX bus
Message-ID: <20221014141005.GA1862711-robh@kernel.org>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014044049.2557085-1-nipun.gupta@amd.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 10:10:41AM +0530, Nipun Gupta wrote:
> This patch series introduces AMD CDX bus, which provides a
> mechanism to discover/rescan FPGA devices on run-time. These
> devices are memory mapped on system bus for embedded CPUs, and 
> added as CDX devices in Linux framework.

Please don't send a new version of a series as a reply to older 
versions. Just provide a lore link to older versions.

Rob
