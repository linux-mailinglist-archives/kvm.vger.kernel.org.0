Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B72F70CE58
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 00:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbjEVWyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 18:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbjEVWx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 18:53:59 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DE0E6
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:53:57 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-561fc920e70so100265357b3.0
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684796036; x=1687388036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WZ5WxxtzFNR4GPMEa157b3QOYmsr84J8uxIQK261qHU=;
        b=y2LILkigkDi8JwPyCLj/JVeomtgL91PKy9r4N241H3MlAe4ATNzorpJAI2F6NhjC8s
         v/jJefYS06XcNViPMgt1lxqgJ3p0Ll2UESHzQCqYyXzYyHyfbxVKuGOBI021jHBTAgS9
         dn2qyMb/N6+kuqmkJ33OyVyMcAGHnF6n1lGhe2NfW/7CjpaW/28lMcJQvclizURvZV1Y
         Ah4HB++0DsHDHYdVEMLHjOeKwlERbRJHgB3kvcLn4Vr0cTLlhdOSzoijhlp0DV58G7vl
         KRXbDhqhGHYPjXgZ+MQta/QEqegcboQ+UA5WXa/VbHk/mYEz27Kc7YG31RCodipLQjl6
         S9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684796036; x=1687388036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WZ5WxxtzFNR4GPMEa157b3QOYmsr84J8uxIQK261qHU=;
        b=g03K6CCqBEYIYcVFXUHnCn/Jca4aprJuTZYQLL6CfW+MxjRctl10vizWgrHjP8S9Ld
         /yf11SuDQCsZltim3Rfi3PrH2tSm9/ixUPGNyLP6CPKYyK3rsLvXaeRqysqECmrSazY/
         lxQR7/NJqOZBJ/7j8ST+WvZy2iFYEKAN2SMR+LVO4ocgctSLDVPfXyLvmzyzfgSJvJIN
         symvZ58+DMTZ2FHXTvo0qpZ5TXxWuNHbymILdf7FnGlyPi4U4+YbvPEADW1bMIcCcZxw
         vIyTTHeP9F3n8Av5S/AHaZsQx8/I6MJR6KviQuyaPXzaI4YDIL/7rkXVsQ6BlqpQQ01a
         cXmg==
X-Gm-Message-State: AC+VfDz4AbjMMJd5SN2aIcuO4BzndTqlQmBNizHRrQpFUmyTI7MxPQpV
        KG8H7gHv0EKOz/CELWw69OCaNQwAoEQ=
X-Google-Smtp-Source: ACHHUZ7NMf1PxkOg1/WzyYgHnNIFz9tc+bBGffNeZb3WPYwxJFRDopnW+1ai1WQZyHlrVD02A2C2Qo5QEP0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b715:0:b0:561:89f1:b9bd with SMTP id
 v21-20020a81b715000000b0056189f1b9bdmr7572237ywh.0.1684796036478; Mon, 22 May
 2023 15:53:56 -0700 (PDT)
Date:   Mon, 22 May 2023 15:53:55 -0700
In-Reply-To: <20230411125718.2297768-5-aik@amd.com>
Mime-Version: 1.0
References: <20230411125718.2297768-1-aik@amd.com> <20230411125718.2297768-5-aik@amd.com>
Message-ID: <ZGvygxYiKBD1Y8Zn@google.com>
Subject: Re: [PATCH kernel v5 4/6] KVM: SVM/SEV/SEV-ES: Rework intercepts
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 11, 2023, Alexey Kardashevskiy wrote:
> Currently SVM setup is done sequentially in
> init_vmcb() -> sev_init_vmcb() -> sev_es_init_vmcb()
> and tries keeping SVM/SEV/SEV-ES bits separated. One of the exceptions
> is DR intercepts which is for SEV-ES before sev_es_init_vmcb() runs.
> 
> Move the SEV-ES intercept setup to sev_es_init_vmcb(). From now on
> set_dr_intercepts()/clr_dr_intercepts() handle SVM/SEV only.
> 
> No functional change intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> Reviewed-by: Santosh Shukla <santosh.shukla@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
> Changes:
> v5:
> * updated the comments
> * removed sev_es_guest() checks from set_dr_intercepts()/clr_dr_intercepts()
> * removed remaining intercepts from clr_dr_intercepts()
> ---
>  arch/x86/kvm/svm/sev.c | 11 ++++++
>  arch/x86/kvm/svm/svm.c | 37 ++++++++------------
>  2 files changed, 25 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b4365622222b..f0885250252d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2946,6 +2946,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
>  
>  static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  {
> +	struct vmcb *vmcb = svm->vmcb01.ptr;
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
>  
>  	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
> @@ -2974,6 +2975,16 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  	svm_set_intercept(svm, TRAP_CR4_WRITE);
>  	svm_set_intercept(svm, TRAP_CR8_WRITE);
>  
> +	/*
> +	 * DR7 access must remain intercepted for an SEV-ES guest to disallow
> +	 * the guest kernel enable debugging as otherwise a VM writing to DR7
> +	 * from the #DB handler may trigger infinite loop of #DB's.

This is wrong.  The attack isn't writing DR7 in the #DB handler, it's setting up
a #DB on memory that's needed to vector a #DB, e.g. the stack, so that the _CPU_
itself gets stuck in an infinite #DB loop[*].  The guest software handler putting
itself into an infinite loop is a non-issue because it can be interrupted.

[*] https://bugzilla.redhat.com/show_bug.cgi?id=1278496

> +	 */
> +	vmcb->control.intercepts[INTERCEPT_DR] = 0;
> +	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
> +	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
> +	recalc_intercepts(svm);
