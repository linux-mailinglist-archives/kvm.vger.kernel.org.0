Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992AD5BED7D
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 21:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiITTTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 15:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiITTTS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 15:19:18 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DCF61D68
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 12:19:17 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so3483955pjl.0
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 12:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=uLSszCT1IxpnInF2D5RqSkjjI+8VauFRIZUKTh82iEk=;
        b=Kd2KiF1uPuS50UJFnhEjakPvrHPIrmLngrROanyprldsZ1bfY+V+wuvMu4P290rQdA
         H+cVKT39j22NlNrcjaiTvfyGzjw50/x6ZJLrWnaH7BWydzqVW+to5RXaOO9pFb3zQDjB
         r0UteikTd44fqIPHiPAONL0MhuC/ZVlhAl0qGjwQw2yuRKoFSi+Wa4fHFSVatshOzsbp
         +nd9vi9yqpiyVP8HJymx1/C1/B7k0OFAOSOGtFq2uOb+gHigg2csCSeN2bcmRF3+wl98
         bpRoMWTP550QEHAC2/tZflsBx4AFTFTVdIfEnLA50fCVlXaV/SOWlBPkDXAVKAlk0Hfp
         eHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=uLSszCT1IxpnInF2D5RqSkjjI+8VauFRIZUKTh82iEk=;
        b=G6FDpBlD/pWBM2jhpc6DJ/RKiEcVUQsDPHoayYj4GWWchZdejb35s2BKL69iqfvY34
         5X0izUDGqmb0Vk/qHySfD1ifJ2mzxU9UvjwPV8wM0yeD2zpPFWW2LlpKo6Vw62LtnQQG
         DafrI8yAGKfUxWMueFh2Sk5kvChjsHgFGQgJ8bOPulrA8dgcsa3QrFQy3cu8LJrG6Qr0
         8gXlZd5o2MHNtoK8FB1+jQyDR+UF8CGVl7fn4hJn46N/xNoxwFkxoc8jazWNR086dnPv
         HgNFq+G2Qu6zgFqViBAReLNLOgrMNqH3hcPCgg0iDu/c75EN4qEgNp6fZeY01Mrjuh7E
         1/YQ==
X-Gm-Message-State: ACrzQf3qi/FVwAebRPEqR/RwI4ekjVoHTMakd9HM8UIBYEPS98G0YGJX
        wjUbj76G2SpJS3UYX3dux2o/jg==
X-Google-Smtp-Source: AMsMyM5QDSn1AqSkzDu0E5hRzTKLIWvzu5cl/aFo4299PkngStimhK8w/GVJC/d2cYeRtT2x/JbqTQ==
X-Received: by 2002:a17:90a:e60c:b0:202:6ef8:4b52 with SMTP id j12-20020a17090ae60c00b002026ef84b52mr5523330pjy.236.1663701556771;
        Tue, 20 Sep 2022 12:19:16 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o126-20020a62cd84000000b00537eacc8fa6sm286903pfg.40.2022.09.20.12.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 12:19:16 -0700 (PDT)
Date:   Tue, 20 Sep 2022 19:19:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Leonardo Bras <leobras@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 0/3] KVM: x86: Fix XSAVE related bugs
Message-ID: <YyoSMGSRRwratmrV@google.com>
References: <20220824033057.3576315-1-seanjc@google.com>
 <YwYMInTCevZ/FYNl@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwYMInTCevZ/FYNl@work-vm>
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

On Wed, Aug 24, 2022, Dr. David Alan Gilbert wrote:
> * Sean Christopherson (seanjc@google.com) wrote:
> > Patch 2 (from Dave) is the headliner and fixes a bug where KVM clear the
> > FP+SSE bits in user_xfeatures when XSAVE is hidden from the guest and thus
> > prevent userspace from saving/restoring FP+SSE state on XSAVE host.  This
> > most visibily manifests as a failed migration (KVM_GET_XSAVE succeeds on a
> > non-XSAVE host and KVM_SET_XSAVE fails on an XSAVE host), but also causes
> > KVM_GET_SAVE on XSAVE hosts to effectively corrupt guest FP+SSE state.
> > 
> > Patch 1 fixes a mostly theoretical bug, and is also a prerequisite for
> > patch 2.
> > 
> > Patch 3 fixes a bug found by inspection when staring at all of this.  KVM
> > fails to check CR4.OSXSAVE when emulating XSETBV (the interception case
> > gets away without the check because the intercept happens after hardware
> > checks CR4).
> 
> Thanks for pulling those together; the set of 3 passes my same (light) smoke test.

Paolo, do you want to grab this series for 6.0?
