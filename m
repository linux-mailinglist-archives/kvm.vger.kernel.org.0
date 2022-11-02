Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BB6616DE8
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 20:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiKBTjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 15:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiKBTjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 15:39:46 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDF610D9
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 12:39:45 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p15-20020a17090a348f00b002141615576dso3067059pjb.4
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 12:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Oy/+InM7thBp0kwixsoFXfh5sgFzh+UFZjFGkPyLYAQ=;
        b=AlcBvu+Y8a9n0rxdCd7zQ9e17/IgiXWiW1brOwB5ZbqKr0SLoquafVF2YULPC3vlet
         uSvOds2cnLBsHxmhHE7ndhPTYL5pauSfC7xzaQss2UczgTV3VYIG6/OP33iqNuAJKL+d
         LvWvNA2iJGJPbsOQpB/Dji8i51YZCf6Q/ISjFxFbxFbku9lnCGmjRd0Dgdx9WZGItFV/
         2AiTf+3QkbGxpIrmP/8lnU62kw9iNvAiIoGPBkKzwLwHrqSFwtZxTIHgIhpOED9s7cKB
         3c4cmTHomEsxZCom4U2kcddeyipmi4giT/3jA5bvxdMV/McfpAXZhOh+lEB408GUCwPX
         AW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oy/+InM7thBp0kwixsoFXfh5sgFzh+UFZjFGkPyLYAQ=;
        b=2/9xzOabIKeNuqkVUlCUEdCakfn19TYZBwxMWC00Cy7qpx+4osKNs4MI8lJ89kkIHm
         Y5SDz8qmOTtf7+/cPKf3muNqEpc/OPR93zPQduc7ZCevlc9KrE4m3nUXrA5vap56eo4W
         VTkHcPXG3lfhjEfkUj88w1IDRVeOhBZsCYu2SkyhEGWZN0lQvxWI8GWMHwzkzljRtTsb
         A8ZLiP6hzIefRpkLrd7+XYAswZyOYumsdLpQwUZ+kgUR4xu+Nev5n+v6I40eYrtu5dHX
         XZwSsOuItH20h6dPD6IHB94f8JkJL1jDeYE/EFyr4W4eGQ9MJes4SFkjBpYTSYXEqSS/
         OT3Q==
X-Gm-Message-State: ACrzQf21YYleNjsjFjvyCSWt4f5HTgra3UtLAAFLhp/GSNWoP9Y0qDs5
        1VYQvZ8Np2l1Ii9NM0axBLRFxQ==
X-Google-Smtp-Source: AMsMyM4nTTPc3fRpd+P93lNOuXEOQVEyD2E+BsPyWFnexxUNkM1wQSGyy2pTEo93wVPY4+XonbOyww==
X-Received: by 2002:a17:90b:3144:b0:215:db2e:bc6e with SMTP id ip4-20020a17090b314400b00215db2ebc6emr1492273pjb.12.1667417984739;
        Wed, 02 Nov 2022 12:39:44 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w2-20020aa79542000000b0054ee4b632dasm8813384pfq.169.2022.11.02.12.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 12:39:44 -0700 (PDT)
Date:   Wed, 2 Nov 2022 19:39:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Bo Liu <liubo03@inspur.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: replace DEFINE_SIMPLE_ATTRIBUTE with
 DEFINE_DEBUGFS_ATTRIBUTE
Message-ID: <Y2LHfJYjd1PxPVQq@google.com>
References: <20221101072506.7307-1-liubo03@inspur.com>
 <c0b98151-16b6-6d8f-1765-0f7d46682d60@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0b98151-16b6-6d8f-1765-0f7d46682d60@redhat.com>
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

On Wed, Nov 02, 2022, Paolo Bonzini wrote:
> On 11/1/22 08:25, Bo Liu wrote:
> > Fix the following coccicheck warning:
> >    virt/kvm/kvm_main.c:3847:0-23: WARNING
> >      vcpu_get_pid_fops should be defined with DEFINE_DEBUGFS_ATTRIBUTE
> > 
> > Signed-off-by: Bo Liu <liubo03@inspur.com>
> > ---
> >   virt/kvm/kvm_main.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index f1df24c2bc84..3f383f27d3d7 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3844,7 +3844,7 @@ static int vcpu_get_pid(void *data, u64 *val)
> >   	return 0;
> >   }
> > -DEFINE_SIMPLE_ATTRIBUTE(vcpu_get_pid_fops, vcpu_get_pid, NULL, "%llu\n");
> > +DEFINE_DEBUGFS_ATTRIBUTE(vcpu_get_pid_fops, vcpu_get_pid, NULL, "%llu\n");
> >   static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
> >   {
> 
> If you really wanted to do this, you would also have to replace
> debugfs_create_file with debugfs_create_file_unsafe.
> 
> However, this is not a good idea.  The rationale in the .cocci file is that
> "DEFINE_SIMPLE_ATTRIBUTE + debugfs_create_file() imposes some significant
> overhead", but this should not really be relevant for a debugfs file.
> 
> Such a patch would only make sense if there was a version of
> debugfs_create_file_unsafe() with a less-terrible name (e.g.
> debugfs_create_simple_attr?), which could _only_ be used with fops created
> by DEFINE_DEBUGFS_ATTRIBUTE.  Without such a type-safe trick, the .cocci
> file is only adding confusion to perfectly fine code.

Heh, some serious deja vu here[1].  This is the second case of identical, flawed
patches being sent in response to misguided coccinelle warnings in a rather short
amount of time, the "return min(r, 0)" horror being the other case[2][3].

The min() thing is supposed to be fixed by commit aeb300c1dbfc ("coccinelle: misc:
minmax: suppress patch generation for err returns").  Is that patch broken, or are
folks just running old scripts?

As for the DEFINE_DEBUGFS_ATTRIBUTE check, can that warning be downgraded (is that
even a thing?) or even deleted?  As much as I enjoyed the opportunity to learn more
about debugfs, the unnecessary confusion and wasted time was/is annoying.

[1] https://lore.kernel.org/all/Yxoo1A2fmlAWruyV@google.com
[2] https://lore.kernel.org/all/8881d7b4-0c31-cafd-1158-0d42c1c7f43a@redhat.com
[3] https://lore.kernel.org/all/d8a518c4a4014307b30020b38022d633@AcuMS.aculab.com
