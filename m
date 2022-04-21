Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4363D50AB0C
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 23:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442257AbiDUV7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 17:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442249AbiDUV7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 17:59:45 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3886B4E382
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 14:56:52 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id v15so8170907edb.12
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 14:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q2XnpBOwTDdjnVA+25Nh56cl0azTcJsJDuS10iR7LTc=;
        b=C4S3R9quYIAIUDMHwwKrVcSNKDQy/sv5rRXpMlQl5RbY0E6QCEpJJslLkmjuhZaAhy
         MSMKHKSuf9ocQqSSQIHa2TXWFKOr3GZsp0jsMvlUHKBNUoENlr+MfnW9fWQJjtpaQswu
         BvBzah3BjlbBsTa9DlggZC/CzseNvWqWXRWXPItaAi67V6OqN9DuiCVfzGm63cR6f3Uo
         DKZnpaVsA6/FbxqZsYxc0qZDUxvK66K37vUU0Oul6qCZKrEqwR78CHZWvJjpLhLmmBMY
         6rkaE84XTfRzu+0ONujt4PsR5Es3nLyMPVkCCPRiCy+dDRwAcQYp6lkalo/DThefYCqE
         Ry1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q2XnpBOwTDdjnVA+25Nh56cl0azTcJsJDuS10iR7LTc=;
        b=I7+XxI7Zz9lJJ04ux9Ok8x/oBxC3D6/8M1snNzIw4OeYDVZwdQR9ZUOJk7eD99HkPb
         8+UIFuBUzdqEr3+bhpssrFrkwEEvXyQxQfIXTnMWrFkPmdwPWAEQJqGKnqzJjxVJjENm
         3eUfeEHLvrzS1TJ7FdVP+5By5DnG75GPa9jHABbhec+JZoT7286JXQBMwgWSjkWexTf5
         Yy8gXbIp8HKC8KVG/8zRikAZ6zB5CZf7XYNAvSXTTaYUegCRMqzWTjscFoS9kvDnNjcI
         NcO/FSEX0FbcgFIDCaxWT7/qmpChlG7DH3aWsi4E0aA6CrNQnuzUEDCGBpf4twh5MZHJ
         HqLw==
X-Gm-Message-State: AOAM5328CEcp/8zSK/UKzxWrrQdzmMkno6ONl2qXX5HXptP4NBY4YdCm
        bw94umFfkHp7xWpmGK3a2P4BY+WbWYgmmt1mPhXU6Q==
X-Google-Smtp-Source: ABdhPJyVlCrDZZJwxaQZkTgcqpx6uvDXQzPAyz56fmdnocfKZWMqx+j2dPO18ZFNTaOiEQNbpcGIzLIYnQKG5YtYBJE=
X-Received: by 2002:a05:6402:11cd:b0:424:ba:877f with SMTP id
 j13-20020a05640211cd00b0042400ba877fmr1700976edw.292.1650578210823; Thu, 21
 Apr 2022 14:56:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220422075024.161914a8@canb.auug.org.au>
In-Reply-To: <20220422075024.161914a8@canb.auug.org.au>
From:   Atish Kumar Patra <atishp@rivosinc.com>
Date:   Thu, 21 Apr 2022 14:56:40 -0700
Message-ID: <CAHBxVyEM4gO2KMP-+cGHLSvriYDuF+TO2JoETh-x1X+bRwuOfA@mail.gmail.com>
Subject: Re: linux-next: Fixes tags need some work in the kvm-fixes tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 21, 2022 at 2:50 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> In commit
>
>   38d9a4ac65f2 ("RISC-V: KVM: Restrict the extensions that can be disabled")
>
> Fixes tag
>
>   Fixes: 92ad82002c39 ("RISC-V: KVM: Implement
>
> has these problem(s):
>
>   - Subject has leading but no trailing parentheses
>   - Subject has leading but no trailing quotes
>
> In commit
>
>   3ab75a793e49 ("RISC-V: KVM: Remove 's' & 'u' as valid ISA extension")
>
> Fixes tag
>
>   Fixes: a33c72faf2d7 ("RISC-V: KVM: Implement VCPU create, init and
>
> has these problem(s):
>
>   - Subject has leading but no trailing parentheses
>   - Subject has leading but no trailing quotes
>
> Please do not split Fixes tags over more than one line.
>
Sorry for that.
This probably happened while copying the fixes tag from mail to the
actual patch.
Let me know if I should resend the patches with correctly formatted fixes tag.


> --
> Cheers,
> Stephen Rothwell
