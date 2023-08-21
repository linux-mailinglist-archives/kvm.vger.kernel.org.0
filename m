Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38A3782609
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 11:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbjHUJIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 05:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbjHUJIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 05:08:00 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B1FC1;
        Mon, 21 Aug 2023 02:07:59 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id 2adb3069b0e04-4ff09632194so4149366e87.2;
        Mon, 21 Aug 2023 02:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692608877; x=1693213677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JKWRJTfGQowIKvL3XjiDWE9FYLrusIoybiwsp0Evuyk=;
        b=i74RrRT/nZrpfBRl2fhQa9dTPKM7u23SB+mv35LcAjV0iW0uW4MTr18kiBqE7k5aqx
         aCT3Z+ejZmORg8iaYsiMmuRcRjj/RDzCVwAyZjkVY9tzG2J3Q0fLI37k5RI2BxB3NGaD
         5DUsAOByVq5e5epmlSCDyT6lkkxwOq5XxXDL+8Rn4+w+bIApLATl6jz0n+fDRkTJ5EmA
         HwW6Yjs826uPaDIjWXGNAhW7OcyMxTQrj8NKSmbYuu0HwHywkz5B6WkeDlf/+pokItQW
         U8w21AQbmfLOwmI4hkPUknEPlgCnHbQd22h9iKijRahoqG8UbDSn4/pFWoTfNAfM3KVu
         aAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692608877; x=1693213677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JKWRJTfGQowIKvL3XjiDWE9FYLrusIoybiwsp0Evuyk=;
        b=IWqMYS/bqI4//jC+H84KAMF7yLm16UiKGJCYow6H4D9oYB5Ltv1q6/hrZX441uHk/+
         4tnmPYvkqjjK51R1Q9yIDe6rpgohU4EVdfcJoVQBqzmpwrG0XPUnsvQyGmSgCVUxN2nh
         hThJqK+Awdze1bqE2McxKFIDLFWffqmuSUpB7N9YVkGs68bzEJFk6d+7kEDX5zZUjpNd
         NqOrt1oSvLOJUH+daRc/XkCZQ+rLLCN0alh8j7V+KWEVnyYo6mfBuGGZ2ktuvFmX5N3E
         ALLYHBqF0C78EXOS8MEzEQfod/a92ELQ6NBavSGOiLPbWWwDpwGBLDTtQuV//rULom77
         JOAw==
X-Gm-Message-State: AOJu0Yz+qJIQb/ZBA8MHgR5kyPgnrQaRJrsP2l3u2abxGFiBpURfneG1
        obkgioG4/OjYa7KpQwfyPRrwRwXP4rBublfxN50=
X-Google-Smtp-Source: AGHT+IGcyGcLR9ieZcYZFcxkxoF+t0ejjZ6vHbUf6OXAnQs7ZPV/jSisWOFHbcHRF2Inn7DmUzEGs8tATvEeswPHF9A=
X-Received: by 2002:a05:6512:e84:b0:4fe:61f:3025 with SMTP id
 bi4-20020a0565120e8400b004fe061f3025mr5145487lfb.61.1692608876970; Mon, 21
 Aug 2023 02:07:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230814115108.45741-1-cloudliang@tencent.com>
 <20230814115108.45741-3-cloudliang@tencent.com> <56873cf7-ddaf-3e8d-3589-78700934c999@gmail.com>
In-Reply-To: <56873cf7-ddaf-3e8d-3589-78700934c999@gmail.com>
From:   Jinrong Liang <ljr.kernel@gmail.com>
Date:   Mon, 21 Aug 2023 17:07:45 +0800
Message-ID: <CAFg_LQXmcPZnCUP1eWt-cH2=rHtDRWVWDyg7RXK6_QW=eYnp9g@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] KVM: selftests: Add pmu.h for PMU events and
 common masks
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Like Xu <like.xu.linux@gmail.com> =E4=BA=8E2023=E5=B9=B48=E6=9C=8821=E6=97=
=A5=E5=91=A8=E4=B8=80 16:56=E5=86=99=E9=81=93=EF=BC=9A
>
> On 14/8/2023 7:50 pm, Jinrong Liang wrote:
> > +#define ARCH_PERFMON_EVENTSEL_EDGE           BIT_ULL(18)
> > +#define ARCH_PERFMON_EVENTSEL_PIN_CONTROL    BIT_ULL(19)
> > +#define ARCH_PERFMON_EVENTSEL_INT            BIT_ULL(20)
> > +#define ARCH_PERFMON_EVENTSEL_ANY            BIT_ULL(21)
> > +#define ARCH_PERFMON_EVENTSEL_ENABLE         BIT_ULL(22)
> > +#define ARCH_PERFMON_EVENTSEL_INV            BIT_ULL(23)
> > +#define ARCH_PERFMON_EVENTSEL_CMASK          GENMASK_ULL(31, 24)
>
> Could you write more test cases to cover all EVENTSEL bits including ENAB=
LE bit ?

I am more than willing to write additional test cases to cover all
EVENTSEL bits, including the ENABLE bit.

If you have any specific suggestions or scenarios you'd like me to
cover in the new test cases, please feel free to share them. I am open
to any ideas that can further improve the coverage and quality of our
selftests.

Thanks
