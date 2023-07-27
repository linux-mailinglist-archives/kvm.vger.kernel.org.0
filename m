Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6EF76583A
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 18:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjG0QFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 12:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjG0QFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 12:05:49 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931C3BC
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 09:05:47 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-307d58b3efbso1146650f8f.0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 09:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690473946; x=1691078746;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4s3yjcZ2vRVHgzK6hn2+1/dhgBJOv42KtkzRrKRA6Jc=;
        b=g+qwjQkrRd6H8GH/yQtkVAeVg9zSeDcs1KDcsDXx1k+M9SsY6eoHLRfUeNfnNqqH6Y
         +LRGL9pQpZHkWagkFe6umI8b877GJKXD7Enf0zK+Poe51XHBuaL+sFsQDXTOvvVSBJNP
         4CQtVN7jO8huxd0k8NTXaC9X04HJk0NKMOC3So+kekUX/p3s7C6j02S4k9/J5F18pDl+
         vIjvPd15mYD6BTDNV9YfUVbCUL4sYjNA8gwMw/IE7c/ebyuXtyD3JU7B1e9wmoMJZ+Jq
         s5fsBRasNPgBLCJTJBXP1ZFWmfbTvOi2sBBhFsHbqOA3MAusmroyhrh2SBEw+2BVpqw+
         pSzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690473946; x=1691078746;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4s3yjcZ2vRVHgzK6hn2+1/dhgBJOv42KtkzRrKRA6Jc=;
        b=IWrDIDCMZscG2HIxbJ4sZbj+Ibnk462cIXDRp+UCqm00j6aWCpjwAjqNfTxS6CFr7H
         /4fFPJm5SiepnDlmvMFr3UwpzyHKIjM0xy7CsZ6OKGPKMC/hxIv6oKrQ6hwjADdwM/SA
         eAHvEmHirFP9O8luIMj4e28BWcrdvfJq7IeFq1G7xqQbfbg6T5O47nrTbQ1jm0lCvx5q
         M4kQZcdeNTUZahJBWmNZ25ZmySY1Li2iWMYS7tQJ3f+UEb33F14qFeVQTDFHZf5lkHfD
         i2EDILwUHRwdyB6ANxt8kGq05l9uEfZFkwuj15YPzf/uiUQjakquj8Ly2jAQSfPvKlFp
         2GBA==
X-Gm-Message-State: ABy/qLaTcPlJ1B4ZpB3sqcNxmz/tQUooq03gdw+eU+Blr+voir2JcWQA
        UZzQCul1s2NXT8tG3iL0rMWMDsv29oQKJm8iyK+jqQ==
X-Google-Smtp-Source: APBJJlE9709XXSBw95bTFBAVUOJ8kzsLC6rlWxTrwbQNtOZ3x+aoM8aDqNhz5jf9yiSeaNc4m56RaLULYqhnZid9tZI=
X-Received: by 2002:a5d:420b:0:b0:314:3ad6:2327 with SMTP id
 n11-20020a5d420b000000b003143ad62327mr2259572wrq.12.1690473946033; Thu, 27
 Jul 2023 09:05:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230725150002.621-1-shameerali.kolothum.thodi@huawei.com> <CAFEAcA_3+=m8nt6_eJMiEpxyGcSAXJRC5LWMVvU3f9CHAxKzCw@mail.gmail.com>
In-Reply-To: <CAFEAcA_3+=m8nt6_eJMiEpxyGcSAXJRC5LWMVvU3f9CHAxKzCw@mail.gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 27 Jul 2023 17:05:34 +0100
Message-ID: <CAFEAcA8euHStuwCHVwWC=4=gE91gFrcz4o4sYQDy1X_RW5yv9g@mail.gmail.com>
Subject: Re: [RFC PATCH] arm/kvm: Enable support for KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, ricarkol@google.com,
        kvm@vger.kernel.org, jonathan.cameron@huawei.com,
        linuxarm@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Jul 2023 at 16:43, Peter Maydell <peter.maydell@linaro.org> wrote:
>
> On Tue, 25 Jul 2023 at 16:01, Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com> wrote:
> > +static bool kvm_arm_eager_split_size_valid(uint64_t req_size, uint32_t sizes)
> > +{
> > +    int i;
> > +
> > +    for (i = 0; i < sizeof(uint32_t) * BITS_PER_BYTE; i++) {
> > +        if (!(sizes & (1 << i))) {
> > +            continue;
> > +        }
> > +
> > +        if (req_size == (1 << i)) {
> > +            return true;
> > +        }
> > +    }
>
> We know req_size is a power of 2 here, so if you also explicitly
> rule out 0 then you can do
>      return sizes & (1 << ctz64(req_size));

Er, that's also over-complicated. Just
   return sizes & req_size;

should do (and catches the 0 case correctly again).

-- PMM
