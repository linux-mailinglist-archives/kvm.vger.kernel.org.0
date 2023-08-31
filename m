Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F90E78F28C
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 20:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347007AbjHaS1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 14:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjHaS1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 14:27:06 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040A0E64
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 11:27:03 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-56f924de34fso1166183a12.2
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 11:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693506423; x=1694111223; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9BL29J1RzTtLIRB8EYDyGe+vo37rP6HDohP3M6dAx+U=;
        b=B/yNBGZdEvJwbmlj8/1+4UyO5O/ON0FW5I2gLe3wDh4122D7oTI9DEvcv4xd+8usvw
         dDu4J7kD/lBmKCcK5DtPJ68276AknazyaquPGN7ZAP8YRL+fSyVocQArGv8/HSA4daKo
         e5T+MxHnWPDkjtaq0KtHSDLzWzYowUKGEUX2WbS60LAuyzzKgF8n5MaaOIHvIXHGvwh0
         B9JkliSm8LCroeYduq+LWqQugsKV75TLsLENFIt7pXEyS4Ms+vwxNkpXWruxghcFLbQx
         k0UqNYmFCbW1sl9YSUIVdebkV0YIqMk9Ir0WJqiYBweOfRjk1cdMUMKbdgx9NkC0bUkU
         w4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693506423; x=1694111223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9BL29J1RzTtLIRB8EYDyGe+vo37rP6HDohP3M6dAx+U=;
        b=aRmHWxGBGUX1GC6qCTH/7mdaEfdr1AFkwcNOOCcxa37aid+vKesVDwsuvcsC+c4Dug
         UjELKSroRLMGEven7pmXyhVR6uwh2txELRLYl/f79B44JWX0+/bEfq4pUzFx8t33Ub2Q
         zQTJc4wheEZ2GGobXTCIO59dd0/qwsGxJXY5KAdrcwx2ERj8XrMfPFWJbwTfXtjUYAlb
         GC8dBwcK5TCDO27lig/nCA6P4Z6e73gev8ys0urrWMow25WXRAOsbw8/Gy4RQO6tMufu
         7SuYTbHeDxO7i12dyBdTc9gDVqs8BHRqQs0h71tDpcMsrRR28dJi7CiNz57Dkciy0BNK
         JiAw==
X-Gm-Message-State: AOJu0YzuLycxRI0p1lq9bHGsNaVOyT5Ely6rbIEUk51AuaDJEP7ndFyW
        3NlWo8grTWTY8qBZwtqi9H4jEHJgzyI=
X-Google-Smtp-Source: AGHT+IGy8aNlBIT34IBTO5UeG7P11LE8KsEbP0ykxoFscuLHnZ697p9o+nlvmi+P3IJduZDTQXpkgbeEDsg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2309:b0:1c0:ac09:4032 with SMTP id
 d9-20020a170903230900b001c0ac094032mr122962plh.9.1693506423541; Thu, 31 Aug
 2023 11:27:03 -0700 (PDT)
Date:   Thu, 31 Aug 2023 11:27:01 -0700
In-Reply-To: <CABgObfay4FKV=foWLZzAWaC2kVHRnF1ib+6NC058QVZVFhGeyA@mail.gmail.com>
Mime-Version: 1.0
References: <20230830000633.3158416-1-seanjc@google.com> <20230830000633.3158416-3-seanjc@google.com>
 <CABgObfay4FKV=foWLZzAWaC2kVHRnF1ib+6NC058QVZVFhGeyA@mail.gmail.com>
Message-ID: <ZPDbdTIUXAnvL7SM@google.com>
Subject: Re: [GIT PULL] KVM: x86: Misc changes for 6.6
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 31, 2023, Paolo Bonzini wrote:
> This is definitely stuff that I wish I took a look for earlier (and
> this is also why I prefer small bits over the development period, as
> it keeps me honest),

I'll work on making this happen.  I think the biggest thing on my end is to make
it easier to track/merge arbitrary topic branches, e.g. so that I can put big
series into their own branches with minimal risk of forgetting to merge them into
kvm-x86/next.

> I'll take a look but I've pulled it anyway.

FWIW, I despise the "goverened features" name, though I like the guest_can_use()
name.

> BTW, not using filemap turned out to be much bigger, and to some
> extent uglier, than I expected. I'll send a message to the private mem
> thread, but I think we should not pursue that for now and do it in a
> separate patch series (if at all) so that it's clearer what filemap_*
> code is being replaced by custom code.

Bummer, I was hoping we could avoid having to touch mm/ code.
