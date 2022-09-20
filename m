Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8985F5BEC74
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 19:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiITR7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 13:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiITR73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 13:59:29 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4906747B
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:59:27 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-12803ac8113so5369524fac.8
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=tvGcJYMvm/WMuTcTgzo7jJZ5oK7Di8wXi6M7mgdP0gk=;
        b=kx+gX9UL7YkJoKVk0Wt5n22KwSrvbNIFrjDfI+BOLHO6DLNMYFCWFBrsAxQGpzFicT
         M9aaxnkBnNV6eEuE+QCbtXzcgkHNZyHbll0XlDloAJd5ex4OImiEbmA8wgocjUsvYD3f
         gOXVo5v+/Ana1VYznUOgTYjtmyaE1e/26voPFFk1d/RAbL7v2re9ZIk+RByt1JMdltTh
         UF7DzLTbcHt8eLaQYHxcN5lsF9LsYwtNCoUO59bCDiMb38a675U2WFG1ty/JqDybPOOY
         haeWtkzJLSFpTVmMFW9TFWUytL+0Cuu5Yinb6oBy4fNFxj1gUEFPAycu1fBW8GZqFMAy
         6y1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=tvGcJYMvm/WMuTcTgzo7jJZ5oK7Di8wXi6M7mgdP0gk=;
        b=nRkX0FyvhXqntMgsOjgpeiN2x+nehMyEf3wSi47rqZTmwVQDAk9NHBooVyoPvCkrPh
         qQNVu9toy2rXAiE3KP1vIvYOh6wRHq8iXQ0AHzky6D07ZaqPl0/RG51Ycctky/+wm7xg
         mG1lFefeOTx1sOG3+5Fc3u3dAP1aL7p+OsjquFXRi/g5gxQo8mgg2SIOwECNrubq7mO4
         sEgKsNhdFm+vBB60IDp7HGR5FeMO8o9zc7ePltqt0vnHACXU0rOs+zu1SglKx++lJttH
         hBILU2Tjv8pj7+e/Jqx1TXc/BrWqfP+46mVwfjJgRPmDs7IISeC0I+3N+ywPisq/idrA
         oYgA==
X-Gm-Message-State: ACrzQf14iJ+0nc1z3ANQVMYTklZRChgCkcpnKa02z88N0m1VmWupnoAL
        nhEF2c6gIaUqj7H4pwThKsdwdDAkDLE1nRg5dPmDAg==
X-Google-Smtp-Source: AMsMyM4KYzqbgH0y5+U9sArM3EGp6ug27etl1ehKINU+RYOSWSxR7zpbbzi0qDeZYdTwF20uMG6Isnqk4VfIqw8TpmU=
X-Received: by 2002:a05:6870:580c:b0:12a:f136:a8f5 with SMTP id
 r12-20020a056870580c00b0012af136a8f5mr2722554oap.269.1663696766545; Tue, 20
 Sep 2022 10:59:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220920174603.302510-1-aaronlewis@google.com> <20220920174603.302510-8-aaronlewis@google.com>
In-Reply-To: <20220920174603.302510-8-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 20 Sep 2022 10:59:14 -0700
Message-ID: <CALMp9eTh0TuSeToBOs8HF8ZifOLeSMr2Q0BsY3RMNrGY0XNsYQ@mail.gmail.com>
Subject: Re: [PATCH v5 7/7] selftests: kvm/x86: Test masked events
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

On Tue, Sep 20, 2022 at 10:46 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Add testing to show that a pmu event can be filtered with a generalized
> match on it's unit mask.
>
> These tests set up test cases to demonstrate various ways of filtering
> a pmu event that has multiple unit mask values.  It does this by
> setting up the filter in KVM with the masked events provided, then
> enabling three pmu counters in the guest.  The test then verifies that
> the pmu counters agree with which counters should be counting and which
> counters should be filtered for both a sparse filter list and a dense
> filter list.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
