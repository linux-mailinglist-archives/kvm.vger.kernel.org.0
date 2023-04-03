Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1556D5512
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 01:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbjDCXD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 19:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbjDCXD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 19:03:26 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6050819AC
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 16:03:24 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id n125so36687014ybg.7
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 16:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680563003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/UqlrjHaq21iiGBIQ42uRCqTTkgo3ssXPeC+pvC2mpk=;
        b=YXF6ct2am7WoKSfbts4DI3hdBCAldklbdhzonbI2heK3aoEG7hZhdcI/bAD4GMwf/l
         2vGdgZlpR3lkJjX6ulynKiH4aUoUyKl3MUNn9IYYdlO05Ad2q4S4IL4ihCUlS6XxpP/A
         tMTFJC67oxjeOxfQJ5bZSC4kGZvRJ2tRIPeKUBXHz0VoZVVvjENsfUE93yNQWhXTzZRp
         XAkf0u+p4+4me7LrRLHTrUOqzlscXY8yBbBKcA5PnfJM+lih6UkmNUXQfDWyf4Nu9VMd
         1G6gE+qVJ7GioYqH1Wf9ardZ/QvbVpN03mcWYRfgPpaMFWG39USSqctJ/E1YhMwUjERs
         bPCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680563003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/UqlrjHaq21iiGBIQ42uRCqTTkgo3ssXPeC+pvC2mpk=;
        b=hNXwD0nQYW0kfQwv+F4z2pNa5ux1hW3VFnD5zEzeszsfN+EHZR9+PSlmOnR1Rmb5gz
         ZyDbRU1R5pNJfaTNjz+v9Wq5iIpUar0oJyAoS9gibZe7R6D393f1Gh2mgoQeLwlu0cGF
         XoT8Z71wQTMnOodN25T+hfUuMbDselg1O/+E522DB/FLb0G8JX7TEjTZnu4kCqDBpO0A
         y18vzsbY71bQnoMQg1p/emQnd3dttEtxQ+6LzjEIr+GJjiZQ6+wNpxnx64ffRX+UvFNv
         2sJhdFY2HLQtZv0ZU1RY1IQC6sciqoLo8gDuewRqJhP63QYkU2GerpvgUIUBL1r5tYlV
         Czcw==
X-Gm-Message-State: AAQBX9c++Wev6F6Re9vphE8OXi5NdKjNsbDc8Xuyy8wR5kQGNNs/fUEx
        CCr/D5zV4jNAxB8KdU0dx7VsKlNAWgw1akftdFyGeg==
X-Google-Smtp-Source: AKy350a7+WUqYPzL1iHQeB+Smx71zLrW8+QcNi7UEx8a0U3oM1Svz9j/afNcWg6iaFDuEy2ZVeRiNGzDM5hig/fQlvo=
X-Received: by 2002:a25:e00a:0:b0:b6c:48c3:3c1c with SMTP id
 x10-20020a25e00a000000b00b6c48c33c1cmr561444ybg.13.1680563003401; Mon, 03 Apr
 2023 16:03:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-9-vipinsh@google.com>
 <ecd28c71-6f3d-d5bb-cd39-ab80edc549ab@intel.com>
In-Reply-To: <ecd28c71-6f3d-d5bb-cd39-ab80edc549ab@intel.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Mon, 3 Apr 2023 16:02:47 -0700
Message-ID: <CAHVum0cOG62gstGK_W9r1vgjJ5P7_Eswek9SCmEA=E_hexaysw@mail.gmail.com>
Subject: Re: [Patch v4 08/18] KVM: x86/mmu: Track unused mmu_shadowed_info_cache
 pages count via global counter
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
Cc:     jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com,
        pbonzini@redhat.com, bgardon@google.com, dmatlack@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023 at 9:53=E2=80=AFPM Yang, Weijiang <weijiang.yang@intel=
.com> wrote:
>
>
> On 3/7/2023 6:41 AM, Vipin Sharma wrote:
> > Add unused pages in mmu_shadowed_info_cache to global MMU unused page
> > cache counter i.e. kvm_total_unused_cached_pages. These pages will be
> > freed by MMU shrinker in future commit.
>
> This patch mainly renames some functions,  but the commit log doesn't
> reflect what
>
> this patch does. Please change the commit log or squash the patch.
>
>

This is not just function renaming, it is using a function which does
page accounting. I will expand the commit log to capture more details
instead of squashing.

Thanks
