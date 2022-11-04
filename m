Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD9361A1DD
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 21:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiKDUGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 16:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKDUGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 16:06:41 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E401BC
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 13:06:39 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id n85so1418857yba.1
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 13:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DyHspqoSZy8qwpQeQx8PLncv/UhzgF04MTXSZVNsezE=;
        b=Kqo4Km5wAQbET6ncTjggF58yC1zjmXaWjgZm+ufPfiyjvJBmAOLevwuq2AcVKO0jdF
         i2zd9goS/L8YdNtlriUL1H3s+vhba+kd8gyHlVPzC5UqqNYncsrAxyGBCCaaCCCYbiIY
         dRRZas2Y/ie3R2RvbyUnXMRMRkebrkLhQfuEcE9jcUUo09sOKoTiLh1a6I+HHOUkI/9x
         fn34g+3KZs6UaZlLfzg9f2WGrRxB61MK1kEX0SCNgmyB9x8eQd9rtEFWnpnIjPfvY6Yb
         Aro11Ej6OzU1E+yfMT9wDyWiAyv6duRPFsjgps+ro0M4yAm0Qaehpw9qEtVt1VTOR0EX
         S87A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DyHspqoSZy8qwpQeQx8PLncv/UhzgF04MTXSZVNsezE=;
        b=T8KmyMbIgmXe/+QRE22uXGwmHE7A62qJztk4SMIgci4i9Aoby4vRf4qiIWwpAkhiJf
         NY4nOU0iPI8/XuWkg9+mMYl5uZYpXYrxn0+JLgx9HMeNm39lAR9hx6eUuZVzOfxwKNWb
         SqPrbbuCGKt77+8pfVYXvG36bCU/UtndWgakSJe3j/WbfSULuRmZxMLzxs0BINIPNOEM
         Pze9gvqxgjS756CJntpIBWDIjfc0XsxzNciYnSAzdNP3xCgFbfCp3VvKZj0eBNVvQGhh
         60W0NZwLj9e0A7GVTatoq/10fgcquwYHozxayMuNSjSjH1FMYNRRNDyqSNlkn6jNxC1Y
         kyow==
X-Gm-Message-State: ACrzQf1+olUZNdJOU3hZEALf5aC+mtoCWLGL8v2M58NGQJb+8LBXG39b
        SwA+q3JCs1nENInLI3L1/DLxw5fTagRZia/tsi4=
X-Google-Smtp-Source: AMsMyM7YXEk6MY6UlSPKf6SATf8ywjkC56533VwV1HOc3sip3QnHL8+YJ4FonRVoFW6sGpY9CbwULv3Uuo2Dr+FlPhg=
X-Received: by 2002:a05:6902:134c:b0:6bb:f88a:8744 with SMTP id
 g12-20020a056902134c00b006bbf88a8744mr35842691ybu.488.1667592398615; Fri, 04
 Nov 2022 13:06:38 -0700 (PDT)
MIME-Version: 1.0
References: <20221026194245.1769-1-ajderossi@gmail.com> <BN9PR11MB52763B921748415B14FFB57D8C369@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y2EFLVYwWumB9JbL@ziepe.ca> <CAKkLME3bR++sWFusGdxohD3ZCgBDj7rjsjMZs=RvaYYfaJskng@mail.gmail.com>
 <20221102155851.2d19978e.alex.williamson@redhat.com>
In-Reply-To: <20221102155851.2d19978e.alex.williamson@redhat.com>
From:   Anthony DeRossi <ajderossi@gmail.com>
Date:   Fri, 4 Nov 2022 20:06:27 +0000
Message-ID: <CAKkLME28+v0ZvfkP9SPwZTmqGFMmm2_Gt45zs6ja4XZAxt2biw@mail.gmail.com>
Subject: Re: [PATCH v2] vfio-pci: Accept a non-zero open_count on reset
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "abhsahu@nvidia.com" <abhsahu@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 2, 2022 at 9:59 PM Alex Williamson
<alex.williamson@redhat.com> wrote:
> I think that could work too, but of course it's PCI specific.  If we
> had a vfio core helper to get the open count for the device set, that
> would make it more universally available.

Thanks for the suggestion. I sent a new series with this change.

v4: https://lore.kernel.org/kvm/20221104195727.4629-1-ajderossi@gmail.com/

Anthony
