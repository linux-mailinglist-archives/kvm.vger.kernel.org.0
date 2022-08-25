Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43AB5A0504
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 02:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiHYAPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 20:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiHYAPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 20:15:10 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592A7606A7
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 17:15:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v23so11811414plo.9
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 17:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=n+ySj59iuhXBdH7RwhR2A/p3y2hpdOt74I5f5GJbaSQ=;
        b=QF/70eGuJb/+uVaUM/C1aTb4BKXUu8qGyIWbycD3aNYqZVoYgui+EaP1SK14zpiLmM
         MVlYHYvRaEf69gvlUZ+Nm96rL5vChHjU7ul3wBflss7VGE58g0hsTnzdpxrF6rmDk+PW
         zrzxEvVVHUX8AJpyWF1WQA+4FIHevPQecQNYjRxbdT0u3ClM/IpXsDHTcSae4mdTBCnX
         4TMhqgI6wzURR46zugKlk4K3hpu6AWPtclYZnnme7yilUEPb5xSIg5Jo+AI+WyH41VyO
         z0t4HY94631pjfPV16IioFxfecbZwDDvhU6TiYgYrLSzZlXm703V53r9TN4fB2SExUnd
         X9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=n+ySj59iuhXBdH7RwhR2A/p3y2hpdOt74I5f5GJbaSQ=;
        b=DOlCHCQiJiAOCYUpj3OgTvuy4q/pasVoPTApLtQFKjMkZX+FxSpw21sqxHKllZvUF4
         LPEDN/8Somz5VoTO1Wf7QgJpQRTwQvtVRUfSPocfmCPZR4oc8vbZgzsOEeCgYaM2lr1B
         q4H+GrBRW9xZPuKVm8kRPYzOGvjAlhNdo66X53zU6rLAYRzTKyQgWEy4kT4+cOoB6qVe
         4Jt1eHMTRusTib8vOSm2UXxY0/rEa76yFvcq5qjeQxaIyQXpte0Pu0W6OW4icfNCYUGw
         7ugXU9daeCK9vP3mVDGR4AOoauLHFIHxq/qkU7W+UpquAIubw0KuXfkKzOJeFuqAaQF8
         365g==
X-Gm-Message-State: ACgBeo25pVZvgOFZTE4bG4gyR44QXmS9hpnHvwu5oXL6BYP3sxKVhCqZ
        C7/em0Wq4dGt7ti5QbRHV9YjQw==
X-Google-Smtp-Source: AA6agR4J8b4pMIkDlsiPr/WCKybp/istJCAy5D2HjF5oCz7I/g5txBHuvEBaB1b4xOcgMRPirjrw+g==
X-Received: by 2002:a17:90b:918:b0:1fa:ad32:57f3 with SMTP id bo24-20020a17090b091800b001faad3257f3mr1719911pjb.28.1661386505798;
        Wed, 24 Aug 2022 17:15:05 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w185-20020a6230c2000000b0052ac12e7596sm13540564pfw.114.2022.08.24.17.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 17:15:05 -0700 (PDT)
Date:   Thu, 25 Aug 2022 00:15:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 3/5] selftests: KVM: Introduce vcpu_run_interruptable()
Message-ID: <Ywa/BaYIdBi7N0iR@google.com>
References: <20220802230718.1891356-1-mizhang@google.com>
 <20220802230718.1891356-4-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802230718.1891356-4-mizhang@google.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022, Mingwei Zhang wrote:
> Introduce vcpu_run_interruptable() to allow selftests execute their own
> code when a vcpu is kicked out of KVM_RUN on receiving a POSIX signal.

But that's what __vcpu_run() is for.  Clearing "immediate_exit" after KVM_RUN does
not scream "interruptible" to me.

There's only one user after this series, just clear vcpu->run->immediate_exit
manually in that test (a comment on _why_ it's cleared would be helpful).

> +int vcpu_run_interruptable(struct kvm_vcpu *vcpu)
> +{
> +	int rc;
> +
> +	rc = __vcpu_run(vcpu);
> +
> +	vcpu->run->immediate_exit = 0;
> +
> +	return rc;
> +}
> +
>  int _vcpu_run(struct kvm_vcpu *vcpu)
>  {
>  	int rc;
> -- 
> 2.37.1.455.g008518b4e5-goog
> 
