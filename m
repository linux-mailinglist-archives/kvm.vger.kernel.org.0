Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF75154384D
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 18:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244670AbiFHQBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 12:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244657AbiFHQBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 12:01:50 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4FCF827F
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 09:01:43 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id c18so10970303pgh.11
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 09:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LeJNBwVypsDaHqUgIqimlROAW7mu+bPC1d5HEcwRpvQ=;
        b=Teu5cyfnYPbr7uT/ShpogpHQXBLyCTusIjkw9kGxDV8yxdr/79ADs7o5HOnxe9rwEC
         ARdBMF5Q8tbWStHl3XY6se1Lf9k/R91efCPmXufsfpMedPpJLIn53yJiO4pq6zySsbLq
         vgISwYeXXgcSYh3DpN8t6tSiHGl62SlUr3RgM8PH8jPEfSv+hsqAjgZCmabB3eC8v9z+
         u+Ic1itts2HcU0halHybHiiVckFZyaMVt6uivmkzo2tkP2daB8eUY/GaW4EJs0slYhxl
         Wo+RbiJKXE7ZSPK8s6VyXFRVgBMj41Hi7glisJXN+GGEA+mbHbbyV4/QN1ISC+V2otS1
         9oKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LeJNBwVypsDaHqUgIqimlROAW7mu+bPC1d5HEcwRpvQ=;
        b=ML5Z63lLowJ6YUNftqEQp42UjeX9UYb/bWfDzm1Ku8x58fbkuWcYB+1+XUBXEO8/4J
         Gg4evF0d/tWQPORRdHUbYmKSLGGM7TJINWiu4cPP0ajhnLRxF7E54H6PGxJo5/Rhot0U
         RD2a4K73omWjo+TgCs4OKS3Jv78QZPuHx9ITG4wcic3nJv0dtvepvHvyOBOxcKNgPvoA
         eaU1OvcGiw0Ec3uJioIPcjuQERth+8gaRSQs8uYeEm0RcjXirgl9RPrt35EpoOeI7qau
         mekyNT2yFMYjNznRQcfCUJ8ayApvzJbD2YWfz/ij+K/YRsVbnXeoFCynjhig2Z0avzOe
         sROA==
X-Gm-Message-State: AOAM531X81EWlq2Hwfs263lDuYDeBu3UIa0r98NS4sHAKkggl0dUypM3
        eaE9w16twj2P5vftkKLd5H8htkYEIJwgDA==
X-Google-Smtp-Source: ABdhPJxr4aFzDSm2gR3L5oc1+Z0R77JVGx1LTOJD+08ZU36kuuWiZ6CxKRr3EAWOadaRHx0+LfJrpg==
X-Received: by 2002:a63:305:0:b0:3fc:7f18:8d7 with SMTP id 5-20020a630305000000b003fc7f1808d7mr30349801pgd.186.1654704102947;
        Wed, 08 Jun 2022 09:01:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id je21-20020a170903265500b00163b02822bdsm14834409plb.160.2022.06.08.09.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:01:42 -0700 (PDT)
Date:   Wed, 8 Jun 2022 16:01:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 048/144] KVM: selftests: Rename 'struct vcpu' to
 'struct kvm_vcpu'
Message-ID: <YqDH4m0TxLcK5Brw@google.com>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-49-seanjc@google.com>
 <20220608151815.7mwlj3eppwmujaow@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608151815.7mwlj3eppwmujaow@gator>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 08, 2022, Andrew Jones wrote:
> On Fri, Jun 03, 2022 at 12:41:55AM +0000, Sean Christopherson wrote:
> > Rename 'struct vcpu' to 'struct kvm_vcpu' to align with 'struct kvm_vm'
> > in the selftest, and to give readers a hint that the struct is specific
> > to KVM.
> 
> I'm not completely sold on this change. I don't mind that the selftest
> vcpu struct isn't named the same as the KVM vcpu struct, since they're
> different structs.

I don't care about about matching KVM's internal naming exactly, but I do care
about not having a bare "vcpu", it makes searching for usage a pain because it's
impossible to differentiate between instances of the struct and variables of the
same name without additional qualifiers.

> I also don't mind avoiding 'kvm_' prefixes in "KVM selftests" (indeed I
> wonder if we really need the kvm_ prefix for the vm struct).

Same as above, "struct vm *vm" will drive me bonkers :-)

> If we do need prefixes for the kvm selftest framework code to avoid
> collisions with test code, then maybe we should invent something else, rather
> than use the somewhat ambiguous 'kvm', which could also collide with stuff in
> the kvm uapi.

Potential collisions with the KVM uAPI is a feature of sorts, e.g. tests shouldn't
be redefining kvm_* structures (I'd prefer _tests_ not use kvm_* at all, and only
use kvm_* in the library), and I gotta imagine KVM would break at least one real
world userspace if it defined "kvm_vcpu".

That said, I don't have a super strong preference for kvm_ versus something else,
though I think it will be difficult to come up with something that's unique,
intuitive, and doesn't look like a typo.
