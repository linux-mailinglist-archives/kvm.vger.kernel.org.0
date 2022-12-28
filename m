Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B390F6585CB
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 19:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbiL1Sga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 13:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiL1Sg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 13:36:29 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7103313E0A
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 10:36:28 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id s187so15425751oie.10
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 10:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UU7nN29x0SuHfVZj+bVCd7EdpDwwVFHFOMN5Zjey0yw=;
        b=iOIDSEQFvYEAm88EgY4R48BHsmEsd+ukQw8iNkCueYM9MsbNWrEbzOGAQByJFZ7lcq
         hzJccKmAncVMzRGw2qPPtbSIPSoU7qxAx7gQki6D/Tg/l8F1cL62shWsAQZeP6O0o+0u
         X+/PhcPWjQJNlYwf0iRWS1XOjblzb9xbnKvZ9InGn4CDR5u7P59aLkWFGrXa42HpanWK
         faOgX/1+IDtmDkYWsDeAnPv3xmqsmfx3rXhz6mAUOiwnMVDLxFy7NFQvXNQbcVlspaX/
         W2cwb78LFz9237ZNzukHckECf3+nOVdcnH7ZCwGXsphdJ9+LFKmOBlCw0ILLg+T7EPI9
         3cDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UU7nN29x0SuHfVZj+bVCd7EdpDwwVFHFOMN5Zjey0yw=;
        b=MTeICvf/rS3lPQRw5pgnEsRJJCV+76pcQh8penLuCYJDq9hypNEcgzJzxDKfjoh7bg
         tZgZGIOnwnbgx1bGiEQmN5Y9D13k1Cqur8t1XiAXv0qsZQykpbcYPOfYyhk+K1u0FHls
         xWDwqVD4phlk/XAFH+2CW30OcgFao7AfOSM6ISgHT0v/aInNWqjoUtFM/V8pF2C5HY7+
         xfMtUoGgbsM7CvhyHdwL5nSZ2LwcFaqX9Ow0gcV5aLSXDvLslzqYfXx1dZOwmO84qMQj
         Y6ZzWtO4TNVIjM/oSeyILqIW8IzrKLvb7nmEFNnz/VCwq2Ft8evUFKw+sTbMpoIaWbuY
         z0tw==
X-Gm-Message-State: AFqh2kqyFUn/F55CPjVHqrEJQGdgXXPI0xnE1Te8GES+vfde2OUqIIqh
        DFLrhLp6H036ZxjVH+J/bgxPyAYZVRbq7AcGeEeqkA==
X-Google-Smtp-Source: AMrXdXs4KEo6lZsuZHNpjeNnI2FHOnZuF4EBcqP3qXR54voBm689NFyh+xa4Qg9quQaUuCPcv2Gs/MpEqAQHJCe3E9c=
X-Received: by 2002:a05:6808:1818:b0:35a:4879:a65a with SMTP id
 bh24-20020a056808181800b0035a4879a65amr1147009oib.103.1672252587387; Wed, 28
 Dec 2022 10:36:27 -0800 (PST)
MIME-Version: 1.0
References: <20221227220518.965948-1-aaronlewis@google.com>
In-Reply-To: <20221227220518.965948-1-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 28 Dec 2022 10:36:16 -0800
Message-ID: <CALMp9eQfuq2VRqA37S16Am+3bWjWgAe27zyxnmNSeqzG-Dojuw@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Assert that XSAVE supports XTILE in amx_test
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 27, 2022 at 2:05 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> The check in amx_test that ensures that XSAVE supports XTILE, doesn't
> actually check anything.  It simply returns a bool which the test does
> nothing with.
> Additionally, the check ensures that at least one of the XTILE bits are
> set, XTILECFG or XTILEDATA, when it really should be checking that both
> are set.
>
> Change both behaviors to:
>  1) Asserting if the check fails.
>  2) Fail if both XTILECFG and XTILEDATA aren't set.

For (1), why not simply undo the damage caused by commit 5dc19f1c7dd3
("KVM: selftests: Convert AMX test to use X86_PROPRETY_XXX"), and
restore the GUEST_ASSERT() at the call site?

Should this be two separate changes, since there are two separate bug fixes?
