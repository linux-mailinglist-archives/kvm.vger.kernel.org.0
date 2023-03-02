Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9476A7918
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 02:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCBBl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 20:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjCBBlz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 20:41:55 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C0C457CC
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 17:41:24 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so1182353pjg.4
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 17:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nQ/k+I6vg3DIpuQkWsbGXKaDuFnWAPV+R/MRhIWgerE=;
        b=M1faUwzF8K9LVMgFawTxpJg0odDzVyBttN0AF69uG9guWjiSvbhav1cNgD35gDMKu0
         j1niW9n0QqE3EKJ1dLgwNzvMTsr/XSuX4cXlnqhLDSoEXOlwHLpg/HIGgMwqwQFoKLTY
         /3p1wvO6ecQ1YgClypzXuo5Z+9McY/e//LJVhv3UX6Kpq0CIXJKrgmeQRoYvzMI1gJrs
         GhDh8QtNI7ubX9ks3+BO7j6DV36t9q0rMBQcG43GtBzfzhnaGmfxqQjy6q1mxlVc/mvD
         dmoYB0/AEPJc7ihdJU3WdhAsnYUJK781v7iYPrrNrt88tgTT5g7Myt5GjBx8YtQisLfu
         4ZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nQ/k+I6vg3DIpuQkWsbGXKaDuFnWAPV+R/MRhIWgerE=;
        b=6GEkDJ8KtLw1fkqfsXQsPJ/O0SUjMHtYSSyBOnN2mEgii6zkOotASNLiavB4kmjcAI
         Sa6q+8SukG5D9tYyjemfUgf5Y0z0Lth1IN2GM2ZgkTfdsd91KXLWhEH7tLTTtOMv5TsT
         s2AY3rMvxcLGpGW4tzPYvYQuLt4xvpZ2zB/kh31aJfSAeMtCBnpW3309J2lPXOIKherY
         ct8R39u4fRxYrLR6jNUZq8AJyVR2BELmDEAbOTIEFB5rGzvbBLO8GlP+J0RwZ6dB+EXk
         vSwqStWYQ8X3Lbs+3vEkFYtxrwD14ivDkh1n6z+T7vMgg3YXMyA7wdPSU59NtO3ZNL5E
         5GyQ==
X-Gm-Message-State: AO0yUKXA37H5lDc4RmWSurWEf+oPEoYY5gGwXp2uuTnGaT4ZyyZashw/
        hLw/xx+CYpxjc/mHP1nK1U+IHgmRhoCXT1VsyKWyJg==
X-Google-Smtp-Source: AK7set96nV5WxVAFJCuff1YfyXG1LVejzmkonDIYcfNUk89kau/aG+VyPFxYaHWrc+2i5u58w4j88wEOxo3FDLY30SQ=
X-Received: by 2002:a17:902:7841:b0:19d:1dfe:eac6 with SMTP id
 e1-20020a170902784100b0019d1dfeeac6mr3274257pln.1.1677721282551; Wed, 01 Mar
 2023 17:41:22 -0800 (PST)
MIME-Version: 1.0
References: <20230220183847.59159-1-michael.roth@amd.com> <20230220183847.59159-55-michael.roth@amd.com>
 <20230302020245.00006f57@gmail.com>
In-Reply-To: <20230302020245.00006f57@gmail.com>
From:   Dionna Amalie Glaze <dionnaglaze@google.com>
Date:   Wed, 1 Mar 2023 17:41:11 -0800
Message-ID: <CAAH4kHY6jm9PHjuGj18eyCC8H4oksuNkVL=igAh4P4BTsKs2xA@mail.gmail.com>
Subject: Re: [PATCH RFC v8 54/56] x86/sev: Add KVM commands for instance certs
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > @@ -2089,6 +2089,7 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >               goto e_free;
> >
> >       sev->snp_certs_data = certs_data;
> > +     sev->snp_certs_len = 0;
> >
> >       return context;
> >
>
> Better to move the fix to PATCH 45.
>

This part isn't a fix, but part of the implementation since
snp_certs_len is added in this patch here

> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 221b38d3c845..dced46559508 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -94,6 +94,7 @@ struct kvm_sev_info {
> >       u64 snp_init_flags;
> >       void *snp_context;      /* SNP guest context page */
> >       void *snp_certs_data;
> > +     unsigned int snp_certs_len; /* Size of instance override for certs */
> >       struct mutex guest_req_lock; /* Lock for guest request handling */
> >
> >       u64 sev_features;       /* Features set at VMSA creation */


-- 
-Dionna Glaze, PhD (she/her)
