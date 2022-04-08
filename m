Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C8A4F9B3F
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 19:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237485AbiDHRDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 13:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiDHRDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 13:03:30 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C6D1A6E61
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 10:01:26 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id s8so8839019pfk.12
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 10:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eWqSaaArcKpWGewd/PpIagLrNxnVfrX7eeJw2V+0bsU=;
        b=e/45W54vRn2wXoqJKapVjNEBlsEKPzVALK2ZnAsyFTU2/VLcvfFN2z/PxuDrnf5yYr
         wzIZFXscKl8tHOtv/5026QUqf5dZEVpW5xXL+BJhaMbKHsMcXaLbg3UDu/MPSYtSCJpD
         NStDS1RhCtWJEloYe2nnA9d03udZ98pC6ACDsUDlQiTQARKIv5X7uaNW5SFBVwO/MRUA
         le3GLs6AS9o+aCulMgFQ/uPSlx88/hkf0J7s+PGqEP08qCYcHxEd+xmJzW+0539J/wiV
         XZmLF7RhSiYxp0yJxVQXu2Fh70FpHZTcMsLNb16H5o5qr/tR61TwEg60MtEePoW/jwCf
         t7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eWqSaaArcKpWGewd/PpIagLrNxnVfrX7eeJw2V+0bsU=;
        b=WXsk1LXk16/B5RVPwZGblungbqqsLJUDbyh4p3fUxSr63wpWrgVU867AGMGY7+c2kT
         aWrriQfouvukskhM+67tRxnqiIpDmD/JoziXxe9Vgiajfk5o8C42DYLtdVPmF3xbRvFa
         FEjy5a8yDkeBStDnMgjGFIPlnxnh6YqPoFunS+zA4nDAki735daqol1QAdVjFb/ZD5Ox
         8oxxYqg/knl4PMl7yhumKlEO26MUuGJE4TydWU1Fua+9EuK476ICSqaNwVcTKy/8Ecui
         iLuemkjkwdznLQdJseDaXO4FxUzeb7NqgC6UVT9iN/zYzrUrS2oPnQewqwm2ogaag+d2
         0UFg==
X-Gm-Message-State: AOAM530kcHeMcnSc49DAk200PS3oT03/I2nzRW9/+BeEgr43LVdAWU9g
        s3R/IvgDvOf+jBUiIVkfOkyHBA==
X-Google-Smtp-Source: ABdhPJx61Cp20UincZxmgyHkjllgAkxu7q8n+OznXbv79pEtVaCAbT28ENVjE8GnNMEUjlgOP6uBfg==
X-Received: by 2002:a05:6a00:1312:b0:4e1:58c4:ddfd with SMTP id j18-20020a056a00131200b004e158c4ddfdmr20443717pfu.65.1649437285741;
        Fri, 08 Apr 2022 10:01:25 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e19-20020a637453000000b003821bdb8103sm22268448pgn.83.2022.04.08.10.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 10:01:25 -0700 (PDT)
Date:   Fri, 8 Apr 2022 17:01:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4.1] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Message-ID: <YlBqYcXFiwur3zmo@google.com>
References: <20220407210233.782250-1-pgonda@google.com>
 <Yk+kNqJjzoJ9TWVH@google.com>
 <CAMkAt6oc=SOYryXu+_w+WZR+VkMZfLR3_nd=hDvMU_cmOjJ0Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6oc=SOYryXu+_w+WZR+VkMZfLR3_nd=hDvMU_cmOjJ0Xg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Anup and Will

On Fri, Apr 08, 2022, Peter Gonda wrote:
> On Thu, Apr 7, 2022 at 8:55 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Apr 07, 2022, Peter Gonda wrote:
> > > If an SEV-ES guest requests termination, exit to userspace with
> > > KVM_EXIT_SYSTEM_EVENT and a dedicated SEV_TERM type instead of -EINVAL
> > > so that userspace can take appropriate action.
> > >
> > > See AMD's GHCB spec section '4.1.13 Termination Request' for more details.
> >
> > Maybe it'll be obvious by the lack of compilation errors, but the changelog should
> > call out the flags => ndata+data shenanigans, otherwise this looks like ABI breakage.
> 
> Hmm I am not sure we can do this change anymore given that we have two
> call sites using 'flags'
> 
> arch/arm64/kvm/psci.c:184
> arch/riscv/kvm/vcpu_sbi.c:97
> 
> I am not at all familiar with ARM and RISC-V but some quick reading
> tells me these archs also require 64-bit alignment on their 64-bit
> accesses. If thats correct, should I fix this call sites up by
> proceeding with this ndata + data[] change and move whatever they are
> assigning to flags into data[0] like I am doing here? It looks like
> both of these changes are not in a kernel release so IIUC we can still
> fix the ABI here?

Yeah, both came in for v5.18.  Given that there will be multiple paths that need
to set data, it's worth adding a common helper to the dirty work.

Anup and Will,

system_event.flags is broken (at least on x86) due to the prior 'type' field not
being propery padded, e.g. userspace will read/write garbage if the userspace
and kernel compilers pad structs differently.

		struct {
			__u32 type;
			__u64 flags;
		} system_event;

Our plan to unhose this is to change the struct as follows and use bit 31 in the
'type' to indicate that ndata+data are valid.

		struct {
                        __u32 type;
			__u32 ndata;
			__u64 data[16];
                } system_event;

Any objection to updating your architectures to use a helper to set the bit and
populate ndata+data accordingly?  It'll require a userspace update, but v5.18
hasn't officially released yet so it's not kinda sort not ABI breakage.
