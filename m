Return-Path: <kvm+bounces-3000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE3657FF936
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:19:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63CBF2818C7
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 649705A0E5;
	Thu, 30 Nov 2023 18:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cv8ax+Xh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3899310C2
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701368375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QaDt2NWj0VcEPGAu3rPNwrwu8X8kzCzHOAGmxbpNQlU=;
	b=Cv8ax+Xh+YriKsrBhdCGDCqoIAkCH1a62r1DAYM0AnmSWe5z+OvQS6kuGcsOcz4qDYkgct
	hdC4bfw/VphSaFx94jNcDZpenSYyL+NcNA7LwdKJO2gpOJPtXglrHa0wMdmxUmnMU2wzav
	+VreDNdrK0OCANXz5YA40Q6xyLqPW9s=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-4olR4nkIMTSCgwy2gB7zfg-1; Thu, 30 Nov 2023 13:19:34 -0500
X-MC-Unique: 4olR4nkIMTSCgwy2gB7zfg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-548cf45e962so980687a12.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:19:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701368373; x=1701973173;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QaDt2NWj0VcEPGAu3rPNwrwu8X8kzCzHOAGmxbpNQlU=;
        b=jyd+JApnQxNB6CiAlaSvFxsFX8LLKtsbAdUgaY6kqQzaB56HzshDSbaqkw3Sh1TCY8
         yTqWkJ7r7kCXuGq8cq1FduOtEwmjPlkT7A88QeR1U2Qf8vaKmTNrFDDCElVbSUsVo9Ml
         lN8TKtqjDHMPBu5P+Raa7h6LuVnnfall8oHAtycw8CRGaMUqgMV8EF4z4Sal8Uw1/oFV
         ASkP0FeC6U3t0EHIYGKENiHLZQw6fjpoKDhJt9JV3t+7Sg79C6m6azzK2B1xmb0lGi5Q
         YDTZNImfAQ9hkdV2ETR4UTbYl04U/aYcwfHJtmPVM8vpjHrvHCqaU7QV/vtWEHi54TdB
         SU+Q==
X-Gm-Message-State: AOJu0YxtO86P4j4Nd9f24dKpoeFMjpleMfCn6or4niU0kfuXGlFtcBi2
	C5Wup6A6q8OLrh+vXK9flROVc1P8Ic8uvC5Cc5qII+bGYQ4ie4CIDDqKM4ktbhuQrcabDnwdN36
	6kupXKSzD6XUgW0GtlKL1
X-Received: by 2002:a05:600c:3104:b0:40b:5e22:959 with SMTP id g4-20020a05600c310400b0040b5e220959mr10675wmo.72.1701367618316;
        Thu, 30 Nov 2023 10:06:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFdphK/loP/z/u3KEHI9MgK1+EX6Se565Rx1rK2c2OAM42riyCiA6+jugSv7PqbgFcgNUVf3w==
X-Received: by 2002:a2e:a445:0:b0:2b9:412a:111d with SMTP id v5-20020a2ea445000000b002b9412a111dmr21246ljn.42.1701365088186;
        Thu, 30 Nov 2023 09:24:48 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id e20-20020a2e8ed4000000b002c9c5dd4921sm189164ljl.67.2023.11.30.09.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:24:47 -0800 (PST)
Message-ID: <9a8e3cb95f3e1a69092746668f9643a25723c522.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: Allow XSAVES on CPUs where host doesn't use
 it due to an errata
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, "Maciej S. Szmigiero"
	 <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Thu, 30 Nov 2023 19:24:45 +0200
In-Reply-To: <ZWTQuRpwPkutHY-D@google.com>
References:
	  <c858817d3e3be246a1a2278e3b42d06284e615e5.1700766316.git.maciej.szmigiero@oracle.com>
	 <ZWTQuRpwPkutHY-D@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2023-11-27 at 09:24 -0800, Sean Christopherson wrote:
> On Thu, Nov 23, 2023, Maciej S. Szmigiero wrote:
> > From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> > 
> > Since commit b0563468eeac ("x86/CPU/AMD: Disable XSAVES on AMD family 0x17")
> > kernel unconditionally clears the XSAVES CPU feature bit on Zen1/2 CPUs.
> > 
> > Since KVM CPU caps are initialized from the kernel boot CPU features this
> > makes the XSAVES feature also unavailable for KVM guests in this case, even
> > though they might want to decide on their own whether they are affected by
> > this errata.
> > 
> > Allow KVM guests to make such decision by setting the XSAVES KVM CPU
> > capability bit based on the actual CPU capability
> 
> This is not generally safe, as the guest can make such a decision if and only if
> the Family/Model/Stepping information is reasonably accurate.

Another thing that really worries me is that the XSAVES errata is really nasty one - 
AFAIK it silently corrupts some registers.

Is it better to let a broken CPU boot a broken OS (OS which demands XSAVES blindly),
and let a silent data corruption happen than refuse to boot it completely?

I mean I understand that it is technically OS fault in this case (assuming that we
do provide it the correct CPU family info), but still this seems like the wrong thing to do.

I guess this is one of those few cases when it makes sense for the userspace to
override KVM's CPUID caps and force a feature - in this case at least that
won't be KVM's fault.


Best regards,
	Maxim Levitsky

> 
> > This fixes booting Hyper-V enabled Windows Server 2016 VMs with more than
> > one vCPU on Zen1/2 CPUs.
> 
> How/why does lack of XSAVES break a multi-vCPU setup?  Is Windows blindly doing
> XSAVES based on FMS?
> 



