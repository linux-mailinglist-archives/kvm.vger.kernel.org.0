Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833765450C3
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 17:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344482AbiFIP05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 11:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344478AbiFIP0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 11:26:48 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080F334B8A
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 08:26:47 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t2so20509238pld.4
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 08:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4yC6pfF/WN7V+oY8+r8MwzNzFD7ztYSYIkkb+eP7wsI=;
        b=p/TJGuNx5EF2KlHZGPa9pbacESJ0kmlCq42SQ6bV4PcONBrjWJQzF0r2aos67l8HEI
         3xtdBxEMpMSH5Fr14Z3vkTTDZZ1AZy9oyAaCYAzV7jjLlhYUkmbT7Dlw5B5Q6SGhWcP/
         I+AzRIQB3M5eTvTh1rUumYCdWyZJ/CwcJ2aNuOJTTpyKgsyxTvi2TbMurjH34DaTV+Hk
         5t4HX+cojWI2nzpvyXFjr03wuZb7T5wcAITM7XN+VcTsn5Gl69bHIPee6drCSNxT7sjc
         PLCdh9rX3kHUXuZziuieWznZYgC+OIWfGCnIshZjQSNZGhGWzRJnyTH+BXV5ATYNqISW
         M2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4yC6pfF/WN7V+oY8+r8MwzNzFD7ztYSYIkkb+eP7wsI=;
        b=mwrO3dk1ZSGEVt4DlvRPSLAs/j/Zkl8EO2NpkhdK54o+pcbV1YeGXF6KcfJU6/fc0T
         pN38ERcxSCBuXaMvmi0XBHJeHIkx2YvLqUE5YsFZti6fQ5fimkLk7DGJuTpPrg3IKDIz
         Zk84vmHFsh86QZhrReAHRXL8U6EEReVa3Up0DPyF4JbT1lq+eXFReYOta1SUvyNoqIK6
         UhWAiyUJKlhCOD8qDYBcpvUFOFSubVYoDjC3NjeF5a4/fzGtsBZq9nO3rVvUl4m1Imp+
         Gbewpgi4X4/o8+4vWDk2hUgJ5bd/OqW+0CcVgwoNp3Unbyf8Ekn55/cgUUpE1moT39rm
         SLlw==
X-Gm-Message-State: AOAM530udm+ZF7xovtyeiQjWYW2RPHjfE9OVFEkiEhZsoLjQBT5P1iqo
        rfqTTytJgo/6JAl6JhGrCYTFbg==
X-Google-Smtp-Source: ABdhPJznNVTHtuosLAP88M8/5gGxJJ9m6chiCuhSfrWTF+xMLbzLcGv5Z+atEe11psfn+6vT+dgWVw==
X-Received: by 2002:a17:90b:3148:b0:1e8:90ae:d1f6 with SMTP id ip8-20020a17090b314800b001e890aed1f6mr3955907pjb.84.1654788406344;
        Thu, 09 Jun 2022 08:26:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i9-20020a632209000000b003fdcf361df6sm8402348pgi.87.2022.06.09.08.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 08:26:45 -0700 (PDT)
Date:   Thu, 9 Jun 2022 15:26:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 048/144] KVM: selftests: Rename 'struct vcpu' to
 'struct kvm_vcpu'
Message-ID: <YqIRMuk5TLyaIb0G@google.com>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-49-seanjc@google.com>
 <20220608151815.7mwlj3eppwmujaow@gator>
 <YqDH4m0TxLcK5Brw@google.com>
 <20220609072746.op7ez4rmdn2wmynj@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609072746.op7ez4rmdn2wmynj@gator>
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

On Thu, Jun 09, 2022, Andrew Jones wrote:
> On Wed, Jun 08, 2022 at 04:01:38PM +0000, Sean Christopherson wrote:
> > On Wed, Jun 08, 2022, Andrew Jones wrote:
> > > If we do need prefixes for the kvm selftest framework code to avoid
> > > collisions with test code, then maybe we should invent something else, rather
> > > than use the somewhat ambiguous 'kvm', which could also collide with stuff in
> > > the kvm uapi.
> > 
> > Potential collisions with the KVM uAPI is a feature of sorts, e.g. tests shouldn't
> > be redefining kvm_* structures (I'd prefer _tests_ not use kvm_* at all, and only
> > use kvm_* in the library), and I gotta imagine KVM would break at least one real
> > world userspace if it defined "kvm_vcpu".
> > 
> > That said, I don't have a super strong preference for kvm_ versus something else,
> > though I think it will be difficult to come up with something that's unique,
> > intuitive, and doesn't look like a typo.
> >
> 
> Maybe just abbreviated "Kvm Selftests", i.e. 'ks_'? I won't harp on this
> any longer though, so if that doesn't look good, then we can proceed with
> 'kvm_'.

ks_ was the best I could come up with too.  But looking at it in code, I find it
more distracting than helpful.  It's kind of like the uncanny valley effect, where
ks_ *just* close enough to kvm_ that it makes me think something is wrong.

	struct kvm_sregs sregs;
	struct kvm_regs regs;
	struct ks_vcpu *vcpu;
	struct kvm_run *run;
