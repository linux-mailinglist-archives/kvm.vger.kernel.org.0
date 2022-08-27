Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741515A38E4
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 18:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbiH0Qvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Aug 2022 12:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiH0Qvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Aug 2022 12:51:46 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D297952E7A
        for <kvm@vger.kernel.org>; Sat, 27 Aug 2022 09:51:45 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id w197so5719883oie.5
        for <kvm@vger.kernel.org>; Sat, 27 Aug 2022 09:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=/lrfQkeIPfO5w9k9o4PLMAGId4b1pB9gsrcimppmEYo=;
        b=g9saBexIndAIbnxEUk1qrTSlnK5R23IlurBPpHCY+LPYmfuAsKKVYroKozDBrbjOMn
         LPI3wHHxP5UwoPLEXLRWHlbqrW0rGJOizqLMngWE+rf4l+rZXm80GqpOlXnNFZkXRJH4
         2yw4VNIdO17zS78fBPW0G4y03jm2S8nsFOXYayz/ijokOlE836z49xQVoA3g7nvdGWCv
         KDLXkuxjKBdsTdi4NcgfpGLT385jAkPoh/5EQ1Jq88TN/YrwqM9H+FLUsyfJrQ+H91FP
         UB9uH3QbNt/ndkSatnch2DcyZ83x0cQbQUx2zoXIlV71gV6JI42VE3Re9fBgybZVXqQJ
         pcjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=/lrfQkeIPfO5w9k9o4PLMAGId4b1pB9gsrcimppmEYo=;
        b=gpHEG+4s8xp8f2l+ZlQBFY3Us0i83rw7WcowFUhB0TFYRK3WA8xmMkSBk5EWZ9I7lQ
         A1RZMv8uW3W8FjN3WhCqyQ5+r+DJdsguHKfbH0leDXzA3IjllNXknMa+xD2GduKhkXl+
         eOjJyCD/X5NeFJ+bWA4vlmQGPQzocyGCCzvahwGZMRMcG2TvooNVmzE6ziOfqkm+1Ldx
         TypZVFPt9TTrTOOKkkce7yuGwWeRbJp4Of07SM6WvR8izzX0Hq/nx0IlI2YP18hbrvQ4
         r1Pi8FKg4CIqKt0vovZRhPFwcUgcUv+cw1maWHEEklCnlSVrOnH9Ysm6us/m77bnWsMF
         1kJA==
X-Gm-Message-State: ACgBeo3IpyKN4IlymriyUFyvzcDQxtz1AU2dVxNpMy+cB/rjDGPqR9bt
        zYrWyB5qNdwR1kY5KnzdNAWuZptXB4Aet5WyQxIbS53IbdM=
X-Google-Smtp-Source: AA6agR7dtAwP9Xs4of5FmvIjoeDnttAvBxuM8BVrXF2nX0YjF0CW4wULo6ddr8sXbcFnT7tJ/vfWXZrzKjP6pCfdpyI=
X-Received: by 2002:a05:6808:150f:b0:343:3202:91cf with SMTP id
 u15-20020a056808150f00b00343320291cfmr3932609oiw.112.1661619104959; Sat, 27
 Aug 2022 09:51:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220826210019.1211302-1-jmattson@google.com> <20220826210019.1211302-2-jmattson@google.com>
 <YwldHBEo+7rg0sF3@google.com>
In-Reply-To: <YwldHBEo+7rg0sF3@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 27 Aug 2022 09:51:33 -0700
Message-ID: <CALMp9eSZY3=pH3DegqBY-YYbM=vziPQDpQ1ngaiizT+391ry5A@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86: Report CPUID.7.1 support on CPUs with
 CPUID.7 indices > 1
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Aug 26, 2022 at 4:54 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Aug 26, 2022, Jim Mattson wrote:
> > Previously, KVM reported support for CPUID.(EAX=7,ECX=1) only if the
> > maximum leaf 7 index on the host was exactly 1. A recent microcode
> > patch for Ice Lake raised the maximum leaf 7 index from 0 to 2,
> > skipping right over 1. Though that patch left CPUID.(EAX=7,ECX=1)
> > filled with zeros on Ice Lake, it nonetheless exposed this bug.
> >
> > Report CPUID.(EAX=7,ECX=1) support if the maximum leaf 7 index on the
> > host is at least 1.
> >
> > Cc: Sean Christopherson <seanjc@google.com>
> > Fixes: bcf600ca8d21 ("KVM: x86: Remove the unnecessary loop on CPUID 0x7 sub-leafs")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 07be45c5bb93..64cdabb3cb2c 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -886,7 +886,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >               cpuid_entry_override(entry, CPUID_7_EDX);
> >
> >               /* KVM only supports 0x7.0 and 0x7.1, capped above via min(). */
> > -             if (entry->eax == 1) {
> > +             if (entry->eax >= 1) {
>
> But as the comment says, above this is:
>
>                 entry->eax = min(entry->eax, 1u);
>
>                 ...
>
>                 /* KVM only supports 0x7.0 and 0x7.1, capped above via min(). */
>                 if (entry->eax == 1) {
>
> What am I missing?

It's not you; it's me. There's no bug here.
