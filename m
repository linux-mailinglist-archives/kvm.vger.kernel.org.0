Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A312B0C5C
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 19:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgKLSKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 13:10:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21763 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726545AbgKLSKa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 13:10:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605204629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SGPuf82/3MbNe/jFjp2MD534KwJP61B4CnlXSFqR/Hc=;
        b=FRCI3FTJGDfKaG+Auj4WzxzYXmvCZzoYeB1w1wYpo8iKNpMpW1ZfG5eiUbBO802XG7drGu
        2t7hKrtoqJwGvG/YuYnSm8oYlqmeEzzik5E3LjF7/ZfDqU52CKKk2Jz1pEEIJzWOs0iPy1
        Q0jr1aNyWkt3HxogQc1k9aBifvnJ5xA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-3ocueoUpNXePm9gH2a7TqA-1; Thu, 12 Nov 2020 13:10:28 -0500
X-MC-Unique: 3ocueoUpNXePm9gH2a7TqA-1
Received: by mail-qk1-f199.google.com with SMTP id x22so4818838qkb.16
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 10:10:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SGPuf82/3MbNe/jFjp2MD534KwJP61B4CnlXSFqR/Hc=;
        b=tCTbnrGC+1fRKmtDlELCKf7jJJuVrHqj4NyW6HhysYf1yzcRoKoEA5KfoV092jvCrI
         LeU5nOy8/PkJDZR/4mVEzPXmqi4jx214yJFpWbroKoLtr19oai3W1EVITFm1ro2RoK1c
         JtJwjN/i4M26XEgCS+XaRhEm0onbG694RJrpcaMiRPaN8zCqCj6t+aThDI188U6vrwGE
         dEbIGVFVUam2kMdK/CWal32K+5o/NsdS2juC8Np/bX1oZIODDdX7HAzvkr3K3EMZhx5b
         7k3vjoi1k0tpplBLIITFsuOLZFoD/2oCMgfx1UPpTNPcl/3JqmlzYo29ZJ50+ukB+0vN
         uwMQ==
X-Gm-Message-State: AOAM531sNxl9U4oYXwax3wmQ13oC8DvLOTPFdRE3BSG6DTJ0BFjgEBtn
        oih7B0K4l7i556uwsbad2OFCDmCKDhDj9OQ/Xn2MIylkoSkW/ufAnVGjusoPBSVF4T3AacTXcqF
        9dZAUqVgnb/BW
X-Received: by 2002:ac8:5319:: with SMTP id t25mr339962qtn.351.1605204627719;
        Thu, 12 Nov 2020 10:10:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzbjoNS1H0JubzyRuzDNSbhtaAVQmiy4BQsW1AJM10tcQ5JivbXkWvUMgaC8PFU/Kf+R+2dWg==
X-Received: by 2002:ac8:5319:: with SMTP id t25mr339938qtn.351.1605204627407;
        Thu, 12 Nov 2020 10:10:27 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id m5sm4960393qtp.51.2020.11.12.10.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 10:10:26 -0800 (PST)
Date:   Thu, 12 Nov 2020 13:10:24 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, bgardon@google.com
Subject: Re: [PATCH v2 10/11] KVM: selftests: x86: Set supported CPUIDs on
 default VM
Message-ID: <20201112181024.GQ26342@xz-x1>
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-11-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201111122636.73346-11-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 01:26:35PM +0100, Andrew Jones wrote:
> +void disable_vmx(struct kvm_vm *vm)
> +{
> +	struct kvm_cpuid2 *cpuid = kvm_get_supported_cpuid();
> +	int i;
> +
> +	for (i = 0; i < cpuid->nent; ++i)
> +		if (cpuid->entries[i].function == 1 &&
> +		    cpuid->entries[i].index == 0)
> +			break;
> +	TEST_ASSERT(i != cpuid->nent, "CPUID function 1 not found");
> +
> +	cpuid->entries[i].ecx &= ~CPUID_VMX;
> +
> +	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	struct kvm_vm *vm;
> @@ -264,6 +280,11 @@ int main(int argc, char *argv[])
>  
>  	vm = vm_create_default(VCPU_ID, 0, 0);
>  
> +	/*
> +	 * First run tests with VMX disabled to check error handling.
> +	 */
> +	disable_vmx(vm);
> +

My gut feeling is that we may even drop these complexity, but simply remove the
vcpu_set_cpuid() in test_vmx_nested_state().  Since I see that most (or all?)
the tests before vcpu_set_cpuid() were a bunch of ioctl testings against
KVM_SET_NESTED_STATE - seems not really related to the applied cpuid at all...

-- 
Peter Xu

