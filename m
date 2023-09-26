Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811BF7AEB09
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 13:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbjIZLGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 07:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbjIZLGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 07:06:03 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4696095
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 04:05:57 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-533d9925094so6356508a12.2
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 04:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695726356; x=1696331156; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+IqYctc6vXyAnk7lJI6tiNVIFCNG6WNOLwv/uH2q+Q=;
        b=owE6hh3BGDL/7+TZMkLNTneYIM9pUIQeBgKVsVhorBL2SNYgxnhJgUhiqPOoP9FvYa
         mQITr9QQgLv3VhI7qfBSZT1No9kIqUrSqBahY5IqDTvJ/Lr4Jl0/OGtzt6ZzKrCLa5B7
         21MePxP3apKy5W5Sb//yQ7oAxbkYt5clkHFx/hbSBX6qrxiR9+y9k8EF9l2SNP/2daA9
         nxpiL+RnqksL3QlIxiagl0yKk6MCwxiaartBLgdXLz8HpYQLT35oRaGBgtdmk4g6EJ1r
         wFG5Q2wFfS8vyAsrjN+zSgC4JjYzvuaTl9iGerWHkDVyyOYNsL+3AD43CvYdOpqT/HyB
         CGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695726356; x=1696331156;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q+IqYctc6vXyAnk7lJI6tiNVIFCNG6WNOLwv/uH2q+Q=;
        b=lPWtvgpsq09m5dNkES6qijwtNhwyJD71VL8WxWk05aPPzUqD2Ty0qcWr70ETB3eGa1
         FF8Ku0P87D3u7GEQ2eGCqOEgRGWikVHT0OktfS/kRjBunVcAbKlxYLNCCCCpoPTKBiJ/
         CcKVvpvsHhzwg+5lnLQkJi2vMQ3EmQvq96ekSj8W9ydhfCS5QHEXu+572Vj2V1JTm5ZI
         5e9ctl6gv7CCme6HiHee01EMbsIwOzrxDOw+ajVxHysnCWoUAcsSpHXmDU2E1oQwz5vJ
         ARz9ov6qayVlelQYfIMBkcMH8R0L/RFplCW6q3eiLVD/iq8cK3Jqj66OUJDUquf4fBW7
         wgOA==
X-Gm-Message-State: AOJu0Yxa52q6b8VeB3iJ6tcqgyG0pZvIrZbc0WyExMOTazpmIrZeFce0
        wUXLBTDXLVrDMS67dBVDBEjqa6ylH+KhI+cA7kUMjQkODKuCUnRu
X-Google-Smtp-Source: AGHT+IFrcUGzXoEW7lAWqLF3YlU1u850HoxQCg1+KuWwTybo8rnfEk+TUuRgFiCKeROTpLuc4V4LmKqdEbZsb83dZkY=
X-Received: by 2002:aa7:c30e:0:b0:530:d53c:b4d with SMTP id
 l14-20020aa7c30e000000b00530d53c0b4dmr7915849edq.35.1695726355741; Tue, 26
 Sep 2023 04:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230925194040.68592-1-vsementsov@yandex-team.ru> <20230925194040.68592-10-vsementsov@yandex-team.ru>
In-Reply-To: <20230925194040.68592-10-vsementsov@yandex-team.ru>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 26 Sep 2023 12:05:37 +0100
Message-ID: <CAFEAcA8CXa1fyyGtZRwbyPch9wwmgMrg8wbWEPZ3pL3GW6n1dg@mail.gmail.com>
Subject: Re: [PATCH 09/12] kvm-all: introduce limits for name_size and num_desc
To:     Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Sept 2023 at 20:43, Vladimir Sementsov-Ogievskiy
<vsementsov@yandex-team.ru> wrote:
>
> Coverity doesn't like when the value with unchecked bounds that comes
> from fd is used as length for IO or allocation. And really, that's not
> a good practice. Let's introduce at least an empirical limits for these
> values.
>
> Signed-off-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
> ---
>  accel/kvm/kvm-all.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index ff1578bb32..6d0ba7d900 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -3988,6 +3988,9 @@ typedef struct StatsDescriptors {
>  static QTAILQ_HEAD(, StatsDescriptors) stats_descriptors =
>      QTAILQ_HEAD_INITIALIZER(stats_descriptors);
>
> +
> +#define KVM_STATS_QEMU_MAX_NAME_SIZE (1024 * 1024)
> +#define KVM_STATS_QEMU_MAX_NUM_DESC (1024)

These seem arbitrary. Why these values in particular?
Does the kernel have any limitation on the values it passes us?
Do we have any particular limit on what we can handle?

thanks
-- PMM
