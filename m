Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448265E6BEB
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 21:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbiIVTlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 15:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiIVTlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 15:41:47 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5684610AB22
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:41:47 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id v4so10141336pgi.10
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=RCQxJld93bYDKeJgtBTmKFJY/XaunNlU2lDm3t6TXk0=;
        b=jP7HNnvKpk5+mf4xXV1t+Hq6KRksvPaPM9pzmzd0L9fcydmqJL/SYHDatRA0oVhz5i
         XhFmv+2SepA//a+2Akt5yuLjSk8FYTTxopchL5Y79j//Fklu2iMwNV0EuJbFuut/KF8Q
         WSEWxVpEf+0PAFb/S7pR1Qu5UZjFFQH1v+RLzASOsfyYrmWv5JWnG4rDNiL3pWl/SG3P
         kd9m7bdmZQIqGj2irkwIKSXK7k9UrYullGtNf1S86/cHT2BOQX/G/qmnvo4YWJHz/VVJ
         cEghQ14vOluXpIFFdSTHHPzD+KTZT4A4JA0szLU3SBZejMR/+QDNqzj7guH/NvM5JnZ6
         dULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=RCQxJld93bYDKeJgtBTmKFJY/XaunNlU2lDm3t6TXk0=;
        b=pxpryNPeTV+r4kUgcvaNCo7u013bjhFsSWe06OuflxjxEkjhEENWuaWJHiEcX4SIBx
         H8Vn3DmI9BQpqeoXKZfj1vKnCHoQbP1c9xsxF+umsjPomXE6I0i4T1cJqyyybzm01Xh4
         5qmS5hfFXQAsreKpjucrLFJKDpfVQGA9BSL07cKnex4sf1BgfXfj6KMHZz9Vhx0WYH7g
         cLIk4hEqSBkEoKo1xbPABWWQSgmOmbGofl5yOR+xBYZwbM4o0xRbbCbh8ustn8KO4Nbr
         a3ufZLpUv5pJTwv54y//2d+OM8OfKp6HUyEXB6fYg8MNJqP+TzFYZaIberwABX+k+9t4
         HyXw==
X-Gm-Message-State: ACrzQf17E5GyXfWABiCNsNz8N/Fc1mnAgCd2vzRT5MEuZqJLIDmtI/rQ
        mshLq/v43S6UlIbaS9FV+Uieww==
X-Google-Smtp-Source: AMsMyM6mK3yqgGWWjVSW9drey59giIXhzur9YywXloQYbFhFrr1pcVx7BP4g0KY5uq2qv57b4W7tzw==
X-Received: by 2002:a63:2c4c:0:b0:434:e001:89fd with SMTP id s73-20020a632c4c000000b00434e00189fdmr4348468pgs.444.1663875706700;
        Thu, 22 Sep 2022 12:41:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id fu1-20020a17090ad18100b001fd6066284dsm190812pjb.6.2022.09.22.12.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 12:41:46 -0700 (PDT)
Date:   Thu, 22 Sep 2022 19:41:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM: x86: First batch of updates for 6.1, i.e.
 kvm/queue
Message-ID: <Yyy6dv+07D3OR1K+@google.com>
References: <YypJ62Q9bHXv07qg@google.com>
 <Yysjz3e8y4ij0l0a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yysjz3e8y4ij0l0a@google.com>
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

On Wed, Sep 21, 2022, Sean Christopherson wrote:
> On Tue, Sep 20, 2022, Sean Christopherson wrote:
> > First batch of x86 updates for 6.1, i.e. for kvm/queue.  I was planning to get
> > this out (much) earlier and in a smaller batch, but KVM Forum and the INIT bug
> > I initially missed in the nested events series threw a wrench in those plans.
> 
> ...
> 
> >  - Precisely track NX huge page accounting.
> 
> Abort!  Abort!  Abort!
> 
> Please don't pull, the NX series is embarrasingly broken[*].  It could probably
> be fixed up, but I'd much rather redo the series for 6.2.
> 
> [*] https://lore.kernel.org/all/87tu50oohn.fsf@redhat.com

...

> Jinpeng Cui (1):
>       KVM: x86/mmu: remove superfluous local variable "r"

> ye xingchen (1):
>       KVM: x86: Remove the unneeded "ret" in kvm_vm_ioctl_set_tss_addr()


I'm also going to drop two these cleanups, Shuah pointed out[1] that patches from
this common gmail account shouldn't be accepted in their current form[2].

[1] https://lore.kernel.org/all/b9044b55-1498-3309-4db5-70ca2c20b3f7@linuxfoundation.org
[2] https://lore.kernel.org/all/Yylv5hbSBejJ58nt@kroah.com
