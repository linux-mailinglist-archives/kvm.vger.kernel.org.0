Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948624802D4
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 18:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhL0Rc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 12:32:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230219AbhL0Rc6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Dec 2021 12:32:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640626377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=li2xcnhgXrJYFcnjFORvUKbT7abkoirFYQl5Lh2kLk0=;
        b=VlYgSfIj7mJArYTINwqWqEPJQ5jyh8bkFuBJw1aAOk2oIV2A9YydB1Yf1tDjMGneNYVr/J
        ssfuLLDDMEm7sN+C3NNR70gRXyvK4aHjHWPNscwe+wKtrOgvd+NiSyTSF2DEMDZ/1c9UN/
        My5UPWXA0lHmpBj1gR95e+EKS7yN8kg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-4pRisZAAP_CM9DZD0j7LKw-1; Mon, 27 Dec 2021 12:32:56 -0500
X-MC-Unique: 4pRisZAAP_CM9DZD0j7LKw-1
Received: by mail-ed1-f72.google.com with SMTP id z10-20020a05640235ca00b003f8efab3342so4370357edc.2
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 09:32:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=li2xcnhgXrJYFcnjFORvUKbT7abkoirFYQl5Lh2kLk0=;
        b=3LcPeklWCM6fss0cAD/8GIUpgPt3HoYpZueWWWdKKihV2QcjBKlV+hezjgMG5qBqaM
         VwUcmfSSoBNaeRRuVXB8MzxlyhOvWSeJaDktJrK6cP5TEI6ScSzkReCahdM3TXhP6bSU
         YfNKXCvWtJw0JRvGBHNeLco/Nq1uSAzqk9ZHhITd8uiurVbGlumAHmHO/9tx9H+c1NCH
         Uyd9acdJYOYNSDvwCBK4So9nFabWMOow1ptIvnB2aYxQDDerjLalItkBMnwQyaJzv60S
         aqDXqRn2NTpbBtUuNXQlC8B+NMRQCDe+G1kPrQ4HIbs/69k9elWY3LL8lZbYIyXA4tIW
         QCgQ==
X-Gm-Message-State: AOAM530OKb7EnLgxgejGT+kf2IAWqLivIHj12+O+JezJaSgZp5m0qqRD
        sUh5valVWnPXVWy+jE3zW7+9AeXJxFT1JUETVqEDj0U+dccy1O674XZsUrrzcWrbN0EyiQZdWIb
        TN0d1EIhpsudQ
X-Received: by 2002:a17:906:d54d:: with SMTP id cr13mr15395331ejc.711.1640626375316;
        Mon, 27 Dec 2021 09:32:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwKD53g79aS4XxDZQZtqS1ZPuHcZ9lKu8ZzPc6ArOKxD31pRDGYYvk5MV6OUMwsjtGp0PPP4Q==
X-Received: by 2002:a17:906:d54d:: with SMTP id cr13mr15395325ejc.711.1640626375152;
        Mon, 27 Dec 2021 09:32:55 -0800 (PST)
Received: from localhost ([185.140.112.229])
        by smtp.gmail.com with ESMTPSA id g7sm5297224ejt.29.2021.12.27.09.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 09:32:54 -0800 (PST)
Date:   Mon, 27 Dec 2021 18:32:53 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Message-ID: <20211227183253.45a03ca2@redhat.com>
In-Reply-To: <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
        <20211122175818.608220-3-vkuznets@redhat.com>
        <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Nov 2021 13:20:28 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 11/22/21 18:58, Vitaly Kuznetsov wrote:
> > -	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
> > -	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
> > -	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
> > -	 * faults due to reusing SPs/SPTEs.  Alert userspace, but otherwise
> > -	 * sweep the problem under the rug.
> > -	 *
> > -	 * KVM's horrific CPUID ABI makes the problem all but impossible to
> > -	 * solve, as correctly handling multiple vCPU models (with respect to
> > -	 * paging and physical address properties) in a single VM would require
> > -	 * tracking all relevant CPUID information in kvm_mmu_page_role.  That
> > -	 * is very undesirable as it would double the memory requirements for
> > -	 * gfn_track (see struct kvm_mmu_page_role comments), and in practice
> > -	 * no sane VMM mucks with the core vCPU model on the fly.
> > +	 * Changing guest CPUID after KVM_RUN is forbidden, see the comment in
> > +	 * kvm_arch_vcpu_ioctl().
> >   	 */  
> 
> The second part of the comment still applies to kvm_mmu_after_set_cpuid 
> more than to kvm_arch_vcpu_ioctl().
> 
> >  		r = -EFAULT;
> > [...]
> > +		if (vcpu->arch.last_vmentry_cpu != -1)
> > +			goto out;
> > +
> >  		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
> >  			goto out;
> >  		r = kvm_vcpu_ioctl_set_cpuid(vcpu, &cpuid, cpuid_arg->entries);  
> 
> This should be an EINVAL.
> 
> Tweaked and queued nevertheless, thanks.

it seems this patch breaks VCPU hotplug, in scenario:

  1. hotunplug existing VCPU (QEMU stores VCPU file descriptor in parked cpus list)
  2. hotplug it again (unsuspecting QEMU reuses stored file descriptor when recreating VCPU)

RHBZ: https://bugzilla.redhat.com/show_bug.cgi?id=2028337#c11

> 
> Paolo
> 

