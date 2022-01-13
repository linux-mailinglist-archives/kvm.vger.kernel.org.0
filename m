Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3756A48DC36
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 17:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236887AbiAMQvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 11:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiAMQvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 11:51:02 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474C2C061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 08:51:01 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id v6so11205119wra.8
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 08:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2T+3ozcz/6lmcdRtW1zitHpD4aLtV8zz4quQhpBq1uE=;
        b=PTqd9k25FaL1Wkxnau+N/FEhL1i1pMUk0g0/I+pvvL4J5/bEJyBh8KeBiiZ7Aiea2M
         HqSXk3xocvjkB/M8G6Jq+t5EDbWxDsPeKcSVSY5q23vjGlMZKTCfv4WLVM1Byd4P1Psb
         +UP8g2l3hKnteD6oX5ANUvDyfce5lWXHlWoYgmuq0mt07iQzuOkE17uOTC+6Yi2/gpQL
         hgnsJrr0SDtcF1nPIZX7Ya4D+0+FGD6T5HeENagBD25HTTWfQ5aGN+3LJYxEVr8RbkO/
         Uq41EUJA6RKRYGwa13UVFuq9YynMoaXxvmhoI6Qs3XCMohBjiyE+0hBce4GxxkI6iCqo
         abjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2T+3ozcz/6lmcdRtW1zitHpD4aLtV8zz4quQhpBq1uE=;
        b=gwknvEXWdgbBT+A946C+CEKG0SdnCPSxHW0qjOm+0CXl7kDKi95RtqnrCfIWj17Hs5
         Xkz5TyOlC1xIlqjvGtAtxFg7ln34VSXCEruu0G6bZ71Tjl4xGVrrmd9lBzX7x6z7jpfC
         pHDiaZxesxVPrQM8oAWR5gB7ZSbg1YaxLV6Grqc05oI/wz1YFT6GbRPsHUd2fCkuWby4
         NsDTeVnPylW2LmL4jvNBJn4whqA1bzfMSS4LfM+lErmQUfDQ2elCM4wAvM5S/dX6/HY8
         ja0sqVQ5BkXT6ypS8sguuNIOlmlikaR7LPH8VcYdFQGRicV8WQqNWeI7cDM8Y04MxR7t
         jeUg==
X-Gm-Message-State: AOAM533BMvNPonEROYs/xxxS6HeuOetZqtV+kFBezK7DwoEVZOFcnoTR
        fsE10ymFK6NeLvL0PDiZYoEIvhZY2pMQnA3W/3DyADqsYmzwfQ==
X-Google-Smtp-Source: ABdhPJznf9Vvd5Cx8ZZU5FhIMh6cIzqx17un9KHPptYzlvEhzhXgCfaB2WqluU/ojfT3u3wMi93nsc3bjlxIRb8mWnc=
X-Received: by 2002:a05:6000:1886:: with SMTP id a6mr4912494wri.703.1642092659768;
 Thu, 13 Jan 2022 08:50:59 -0800 (PST)
MIME-Version: 1.0
References: <20220113011453.3892612-1-jmattson@google.com> <20220113011453.3892612-4-jmattson@google.com>
In-Reply-To: <20220113011453.3892612-4-jmattson@google.com>
From:   David Dunn <daviddunn@google.com>
Date:   Thu, 13 Jan 2022 08:50:48 -0800
Message-ID: <CABOYuvbc=ik3OVSz4f2BaWvM57_k-KESk_fBdtzKwOh46YMBMA@mail.gmail.com>
Subject: Re: [PATCH 3/6] selftests: kvm/x86: Introduce is_amd_cpu()
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim,

On Wed, Jan 12, 2022 at 5:15 PM Jim Mattson <jmattson@google.com> wrote:

> +bool is_amd_cpu(void)
> +{
> +       return cpu_vendor_string_is("AuthenticAMD") ||
> +               cpu_vendor_string_is("AMDisbetter!");
> +}
> +

The original code only checked for AuthenticAMD.  I don't think it is
necessary or wise to add the check for early K5 samples.  Do we know
whether they even need this KVM logic?

Dave Dunn
