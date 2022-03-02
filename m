Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33644CAC43
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243864AbiCBRkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239554AbiCBRkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:40:01 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7094BB8B
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:39:17 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id y7so2382006oih.5
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 09:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Du0HYFUv478fk4xwInf0HtuStdiJPlVkVR+fKz/M3U=;
        b=aEQzhkPMMTtl0e/KMijnmsay/iNjeOVzfTubeTWfgtHol6mSzVa60nqc+6wcvDcC+q
         EDbniNfVcLXuPrZrAf8g543RZn/2NVkzwq2xPcbWvdGXHN/aZF0xAVTfILkaZcnmiUOn
         ic8UD3rKS3PDn5RCd4/tRUogJF3y3DvkGgb4gYNxzlLORtfsuY+bht3NT4sF5W2qkzxc
         bJxv7lOvr8iRkdi6r3FMcyhIVDTdCj9q5Qc0rISg/7LJeXd/oZhadf17SWJFJyXKjIzf
         Qje04Docer37IgPHDCn1ui5tNgZRhWITcl8uKYJRWdGsTeazphGhxrQGpWXt76NdYPzh
         w+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Du0HYFUv478fk4xwInf0HtuStdiJPlVkVR+fKz/M3U=;
        b=qRmzEX5RPuH76ZghaYc0znqoFk9eEplanwAQZd9VFf2GHxVaylXExshxrs3TbaR/pm
         Kp1OTqaPGnjxcwUao/Efj+sH6ONlUYPL5zC4rospbF4WY//nAxy8pMb+2aBCKFmP41MG
         CQbr9uFIn2PRazsZtQvMVGwVe8t8Zh10wkCRjZZ4KiZulQSIxM+KYVF8ZHsX+3YCCHQG
         TP5CL+DEkpzt2cDGKWwVbp1vgl3eflHzbdNZ9It8NKmv8182IbWuMqFFVOXc6VZbOFlS
         noKzTyFdINJI/9s4p+S7HPtt/7mxtmj+jPTrgZSi79xtzSfUzuYXJZn2+zj0hrYfuj8U
         oHAA==
X-Gm-Message-State: AOAM531phgAh4wA/dsZCpGZspw/HhgvrGK0M4GMfXrqcPQBcLok2J9fc
        cI3ju24fx10d1IniG63EI6jHWLR6xN/5qTQAFDFx3A==
X-Google-Smtp-Source: ABdhPJxhmuPnCYUatcjD9AOW3Ngyej5Yn7V29aucoeD/yMPXh7Y6hy7Qx/kQ8NpubxUrX+vhi1z2VJ1Lze8mn+/hMVY=
X-Received: by 2002:a05:6808:1443:b0:2d7:306b:2943 with SMTP id
 x3-20020a056808144300b002d7306b2943mr878711oiv.66.1646242757120; Wed, 02 Mar
 2022 09:39:17 -0800 (PST)
MIME-Version: 1.0
References: <20220302112634.15024-1-likexu@tencent.com>
In-Reply-To: <20220302112634.15024-1-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 2 Mar 2022 09:39:06 -0800
Message-ID: <CALMp9eRepNj4B8s6T25+Vy3r=8cHYkeEby8zoqYNFmVp79Hj2w@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH RESEND 1/2] x86/pmu: Make "ref cycles" test
 to pass on the latest cpu
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 2, 2022 at 3:26 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> Expand the boundary for "ref cycles" event test as it has
> been observed that the results do not fit on some CPUs [1]:
>
> FAIL: full-width writes: ref cycles-N
>   100000 >= 87765 <= 30000000
>   100000 >= 87926 <= 30000000
>   100000 >= 87790 <= 30000000
>   100000 >= 87687 <= 30000000
>   100000 >= 87875 <= 30000000
>   100000 >= 88043 <= 30000000
>   100000 >= 88161 <= 30000000
>   100000 >= 88052 <= 30000000
>
> [1] Intel(R) Xeon(R) Platinum 8374C CPU @ 2.70GHz
>
> Opportunistically fix cc1 warnings for commented print statement.
>
> Signed-off-by: Like Xu <likexu@tencent.com>

This fix doesn't address the root cause of the problem, which is that
the general purpose reference cycles event is, in many cases,
decoupled from CPI. My proposed fix,
https://lore.kernel.org/kvm/20220213082714.636061-1-jmattson@google.com/,
does.
