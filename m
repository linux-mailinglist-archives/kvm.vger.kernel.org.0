Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED36B6D8B48
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbjDEX7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbjDEX7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:59:30 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F3459E2
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 16:59:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 186-20020a2510c3000000b00b880000325bso10521924ybq.3
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 16:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680739166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gyCr9OUcPLoeGPEHX6a4SD6RRnehB93fDgoV/FBdOb0=;
        b=jSASHtikqaA+W7+SCU+z5kmfTP7TKJjZibXBeQPXnNJ+JZ/x8lZxPIGQzQHRQ+Q6iR
         8FSoSIywsARlIIBDUoXneqQ+VHub9WFiz+ggHKC/DD+0nwQHrURFKn9/YNL/uqTs+aHK
         34kv1vJ5sEfUpFI4kMljruRW4fUtmDtZ7VizjUpkqB4Shk8yb1Sv8otcWtZD5MBxIcaQ
         47Jp4me3B4MvHAIo56Mo0Jnn+wJR87GdGQEY7CpHLz5NslLPCHJWCjIxoJ0xaYjqBjMr
         THR6U6l5CA6EBPezdjoYzMUJq631c6osEwZCovKin+o78FpBayNY2gqFeeo3D/iMsT4l
         Mm7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680739166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gyCr9OUcPLoeGPEHX6a4SD6RRnehB93fDgoV/FBdOb0=;
        b=6I3hH1rX8q2LNZP5j6DfNq9lPS2k29DKD8dl3pXPunQTyNxUkGIFMMVauQN83Mr4sO
         OmdBXDFmWhAzxXcQB2J2HcU24mvfzrNPhGmI40oDGYBfS1x2HWhxSkvO35WNMG30yrCL
         Rpn/b9vdHjySspgVfiLwtOPTit5GJtfyCWD9NGg3b7x2ekGmUimyDAYF0ZC7QfmPWOtU
         N8eC5h+nb+UxG0NDW5xxy9EYAuUyzDBjG1FS1k+RGkx8gfOWVyxwhTgZp8WKHh1Tf+wV
         VOoi5zmlsWUeuWIVMOxbY4XN1lhF7YtBvqy0zmeSiv+qKvOpuF1zlDRH2TmoTFzfJG+t
         InAA==
X-Gm-Message-State: AAQBX9ebSGqzn6cXSEgFfCLPpGpvCBKUj/pwCo1OZNiz6Lm1uuBP6eo3
        7lt9vKX+ZHBUprCN1nrwZijDDYtGS4M=
X-Google-Smtp-Source: AKy350bUPui1x5zNkOqG8Xc/ByIYKS1l7yISdqFbXRK2eFwGdGqyYGogu0fUP9ktJ+wOOyjTPO8JFL7Zi5Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:441e:0:b0:540:62be:42b with SMTP id
 r30-20020a81441e000000b0054062be042bmr4798963ywa.6.1680739166441; Wed, 05 Apr
 2023 16:59:26 -0700 (PDT)
Date:   Wed,  5 Apr 2023 16:59:13 -0700
In-Reply-To: <20230404010141.1913667-1-trix@redhat.com>
Mime-Version: 1.0
References: <20230404010141.1913667-1-trix@redhat.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <168073838093.697026.15762641048801886450.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: set varaiable mitigate_smt_rsb
 storage-class-specifier to static
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        Tom Rix <trix@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"varaiable" in the shortlog is mispelled, I just dropped it and wrapped the
variable name itself in quotes.

On Mon, 03 Apr 2023 21:01:41 -0400, Tom Rix wrote:
> smatch reports
> arch/x86/kvm/x86.c:199:20: warning: symbol
>   'mitigate_smt_rsb' was not declared. Should it be static?
> 
> This variable is only used in one file so it should be static.
> 
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: set "mitigate_smt_rsb" storage-class-specifier to static
      https://github.com/kvm-x86/linux/commit/944a8dad8b4e

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
