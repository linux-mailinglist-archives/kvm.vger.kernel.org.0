Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDDF648999
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 21:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiLIUim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 15:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiLIUik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 15:38:40 -0500
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39136A4314
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 12:38:40 -0800 (PST)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-144bd860fdbso1184719fac.0
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 12:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pF3iFHXuAqyC453vtW8AYvAdGU6FL+taF+rjrB5LCwA=;
        b=IdEF5BHXPCcxvnE9oRGbFY6KCdIwvzPIqaIyOp86NpM20cYShoAXq0wS9+u00v4T/H
         fmF0oT5ICG8lhgZAF7qcBTPykboBDWO1gt3+eOvUSa8eq3v9RWCPdoU7U8WnRVZu5jwy
         4XnJMrIJd4eDYLE7t8RItutnogkuK5bEIC0FB3OFv95lnMbbfsmb/tY4tEWYR8jhXDCD
         OAaufnd/yJ5jmPWjf5jTc5cc7VNFY9GvB7YQoB+jNXSlMHF/ueQsf1YM1oLrzSPHwwfm
         aIBPzGfdxsu76bhtRr3uG3dd0DQvYfICjjFbunJFU36GUgpI871Q1zNnPh4843si5bbQ
         bU7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pF3iFHXuAqyC453vtW8AYvAdGU6FL+taF+rjrB5LCwA=;
        b=aiZTbmnqpT0l7/VBWLSVAIDS4NdsKHlhBe3m0J28QqwjTd/vF3Ya9ePUUfcuCEl053
         i1ay0DDgq7QbH1sGVFh8vMnsKmMrOpXg0s3LKnLoWPaRE3Mv1BJKRn42opMJYeP3babk
         fMWSVZEezImOgWmdJf0a4bW3LBOnwh0B93Vqk8ov03BaCIzcA2dRbNVvqf66bTiM0vr7
         Zv6fQIlgivJyI02vweWdlmcz05M/YuYfnp/ZKmDvazyS8R6ucYmtkkIRhU/pdLZlu0wB
         szsxKtYAyY1ZXk2/4MFZMIEx9qnxcmzkk+kvuOigXi6dobj05ccZazJe8NW0RX8z4HJl
         Wa8A==
X-Gm-Message-State: ANoB5pmAqP1Y7s99cR2pMQFgQlXyvrzCdRlFjevLhj7WBDwGEq4Ebous
        +qttGDQZEFeEB41CwbWG/wRAZ/Q/11B7zSZ6n8U+XA==
X-Google-Smtp-Source: AA0mqf5sbMDdkvFzp48wWJol2tQ7zfOj3tTNmCdpJTuraUQY9KdYqZ7m4rfpUYzRhhZAheiku7GPdwDXr7Nns4CcYdc=
X-Received: by 2002:a05:6870:9d0e:b0:144:8e4b:f75 with SMTP id
 pp14-20020a0568709d0e00b001448e4b0f75mr354495oab.112.1670618319267; Fri, 09
 Dec 2022 12:38:39 -0800 (PST)
MIME-Version: 1.0
References: <20221209201326.2781950-1-aaronlewis@google.com>
In-Reply-To: <20221209201326.2781950-1-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 9 Dec 2022 12:38:28 -0800
Message-ID: <CALMp9eTsBPd-f2tCTtvjrX+Vgr1T_J2JY6Sm5r=ckMuNG2FpPA@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Fix a typo in the vcpu_msrs_set assert
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

On Fri, Dec 9, 2022 at 12:13 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> The assert incorrectly identifies the ioctl being called.  Switch it
> from KVM_GET_MSRS to KVM_SET_MSRS.
>
> Fixes: 6ebfef83f03f ("KVM: selftest: Add proper helpers for x86-specific save/restore ioctls")
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
