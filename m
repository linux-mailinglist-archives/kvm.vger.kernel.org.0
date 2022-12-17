Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E450F64F932
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 15:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiLQORt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 09:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiLQORr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 09:17:47 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F2A6438
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 06:17:43 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id g1so3549922pfk.2
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 06:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xNfEddRIOphyC/U4i6KaIOkajJ1qtFPwVhN65+71iv4=;
        b=HTaeci6QMzAYrKlkHCibDPNesH6NQaFsq3gt8qsDvuoU81500fdPGn4uv1HcSnY3X5
         CARiaImyTb5o8SkSU+BQl+NzF0t+Yf5o5BHTKAm+WvI7SSD7dotyo4YyIuXvxquAOj4J
         Y20FmGSTG6duP2gemACPkmKXhHtGeVQtXwZ5cmnSnGLRh0UXR6oh/IB1faWQWGLWoSFP
         e9DGkYZOgDvWwgAY0UMXi0XTY9AcpmZZ7xyVezzEFSQNXjx0vFTJbz1C81kB/QNzTYNa
         4xCisy5PiI6ZCMqLfnA8IsVA+12hZj3RqdK6yVrDXzHa7KSd0qTH17/bHLIrOnHcLQ62
         nwew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xNfEddRIOphyC/U4i6KaIOkajJ1qtFPwVhN65+71iv4=;
        b=WWlIK8WqhvS3ULPMsxHN9tpEVpS0G9nC0uLBFdBeBzfPXwH2PGVHQHNgWRNLbGW54V
         4pG0vACD9bsuZAt4vbDqWwpsS6Gh0ZEBaGw6Iv8enDZaCEePETarmX0Iy2EbXR/OarpI
         sysVhjxzw8dFmGo3UMXDzmvKYmt3n+pb3okJ73zoEzyCR8Y3FEiScI7MLeDXC8RCMAGC
         wd92RYnVhIVbKI2MCWqQZGjPnFF6Jy7YS06kiVYgXXFvVJhqbLCeMVB6zRcQtJz/I4Im
         P9u9Mk1QV2Pc3z/jbcp1ZeRqrvuhQLKg2CJarHwHmqOl66xHcEiEvU72EOifzjAYEIvR
         0eQQ==
X-Gm-Message-State: ANoB5pkMieCrzZtxmumwF8Hv0IIWJuBLXpbZIAxLwh8X3nSMOHNpUuoj
        Dkna0wfq/vj37Dot3ajQnoCRLK/5+rUHZXgOTN5N/w==
X-Google-Smtp-Source: AA0mqf4sJTQzxVAyuyfPndN+cFfXCetE5MzcyHYxSEjRglGqnXHR5+VpVD1/DTblX0u9sfsC1TWJzqUEUB+Gxw/fd3Q=
X-Received: by 2002:a62:b501:0:b0:573:1959:c356 with SMTP id
 y1-20020a62b501000000b005731959c356mr80489363pfe.51.1671286663082; Sat, 17
 Dec 2022 06:17:43 -0800 (PST)
MIME-Version: 1.0
References: <20221216220951.7597-1-philmd@linaro.org>
In-Reply-To: <20221216220951.7597-1-philmd@linaro.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Sat, 17 Dec 2022 14:17:31 +0000
Message-ID: <CAFEAcA_Foy+k80r=vjXx2JO1T=2qFT-_7uvPhAuoSz-=XDanBQ@mail.gmail.com>
Subject: Re: [PATCH] exec: Rename NEED_CPU_H -> CONFIG_TARGET
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org, David Hildenbrand <david@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        xen-devel@lists.xenproject.org,
        Anthony Perard <anthony.perard@citrix.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        haxm-team@intel.com,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org,
        Wenchao Wang <wenchao.wang@intel.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, qemu-arm@nongnu.org,
        Cameron Esfahani <dirty@apple.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Paul Durrant <paul@xen.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Peter Xu <peterx@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 16 Dec 2022 at 22:09, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> 'NEED_CPU_H' guard target-specific code; it is defined by meson
> altogether with the 'CONFIG_TARGET' definition. Since the latter
> name is more meaningful, directly use it.
>
> Inspired-by: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

This feels to me like it's overloading the meaning of CONFIG_TARGET,
which at the moment is "the string which names the header file
with target-specific config definitions". I think I'd rather
we just renamed NEED_CPU_H to something a bit clearer, like
perhaps COMPILING_PER_TARGET (better suggestions welcome).

thanks
-- PMM
