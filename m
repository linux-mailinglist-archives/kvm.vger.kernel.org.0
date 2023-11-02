Return-Path: <kvm+bounces-438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 419A67DF9B7
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:14:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71EE21C20FDB
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E715521340;
	Thu,  2 Nov 2023 18:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Md8XJtKr"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3AE2110F
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:14:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDDA271F
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698948850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NW+YV2uLwTdlD8Qd7addq0svLC3cgDkrnxIxuA+hovU=;
	b=Md8XJtKr08+Zt3kCJMzbg+PvxZn4DXsB/BLidGdF47E/HJUZ8z9LZ6FQ8xmLMqkfrZqixZ
	ovX+MOM8060RbGrKRyUy3lbTtijiMREdJyLRD18pccvOYL1+aPvuAwr044ItXPQ473Sdlc
	l0mq9IuH4vDqlNOx4S7gCfabjkKtBaE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-T5UK--6QPtiWN4m91YLNxg-1; Thu, 02 Nov 2023 14:14:09 -0400
X-MC-Unique: T5UK--6QPtiWN4m91YLNxg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-32f8c4e9b88so845349f8f.0
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698948848; x=1699553648;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NW+YV2uLwTdlD8Qd7addq0svLC3cgDkrnxIxuA+hovU=;
        b=Tf72bc/H7Mn5SzScgcNcDWmLC8d4JmvpDOpTV4/vhG86GeGW7aMluL3L6e0hr8xU6u
         l5GPELoIN9JCxZNb6AuJzY/f2weNF7k4lPp7Myta9L5wsi6zIeuivF0D0DjCFBCP3ppL
         eiw+td+sWpTB0BSgCEwPFlwn2HYJnvgka3yBGylHh1WVyq6ZXXxxdpF9a7tTOTRlhdRm
         B+BmBSir0ItoUH840oE2uRJReBw2GjuwxvNTg3zg9v0PrkQk3+gtykfwCrTXhQcubuFk
         w0jpYsVKvPKwKsmtOTz0qUiQdkx27iHu4b2DAni3kJm93TvNSAq6jAqupmtNEMHtYE97
         4BUA==
X-Gm-Message-State: AOJu0Yy2m/VqVv6w19C10kA/abJXk+9Em4PGJ6oDdl3WyNo2GCPSkvFR
	EEzJ0+KnfbcclNLjQDuveEQXTG/E7KRcRNk6mW5Cfoto5ZknipbhK8gfq3hljx709lJbhY6LVIB
	DFeuE3Jl450AGFlSmUCfr
X-Received: by 2002:a5d:6da7:0:b0:32f:75d2:bdba with SMTP id u7-20020a5d6da7000000b0032f75d2bdbamr368694wrs.6.1698948848131;
        Thu, 02 Nov 2023 11:14:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+ExAndHJW2+ysfQ5FsuJ1jlBFBD9QgwVTOw01ckExwh5O38L4OPFzkA+0+pe3DfMzRCU58w==
X-Received: by 2002:a5d:6da7:0:b0:32f:75d2:bdba with SMTP id u7-20020a5d6da7000000b0032f75d2bdbamr368673wrs.6.1698948847836;
        Thu, 02 Nov 2023 11:14:07 -0700 (PDT)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id u9-20020adfed49000000b00326b8a0e817sm3047099wro.84.2023.11.02.11.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:14:07 -0700 (PDT)
Message-ID: <015ee02a072460b9e844278f5cc4c3b3618f5e9e.camel@redhat.com>
Subject: Re: [PATCH 7/9] x86/sev-es: Include XSS value in GHCB CPUID request
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Borislav Petkov <bp@alien8.de>, John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	weijiang.yang@intel.com, rick.p.edgecombe@intel.com, seanjc@google.com, 
	x86@kernel.org, thomas.lendacky@amd.com
Date: Thu, 02 Nov 2023 20:14:05 +0200
In-Reply-To: <20231017184932.GBZS7XPESSMgPoCysY@fat_crate.local>
References: <20231010200220.897953-1-john.allen@amd.com>
	 <20231010200220.897953-8-john.allen@amd.com>
	 <20231012125924.GFZSftrGx43ALVCtfS@fat_crate.local>
	 <ZS7OjlhJKI2xlbY/@johallen-workstation>
	 <20231017184932.GBZS7XPESSMgPoCysY@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2023-10-17 at 20:49 +0200, Borislav Petkov wrote:
> On Tue, Oct 17, 2023 at 01:12:30PM -0500, John Allen wrote:
> > I looked into using __rdmsr in an earlier revision of the patch, but
> > found that it causes a build warning:
> > 
> > ld: warning: orphan section `__ex_table' from `arch/x86/boot/compressed/sev.o' being placed in section `__ex_table'
> > 
> > This is due to the __ex_table section not being used during
> > decompression boot. Do you know of a way around this?
> 
> Yeah, arch/x86/boot/msr.h.
> 
> We did those a while ago. I guess they could be moved to
> asm/shared/msr.h and renamed to something that is not a
> "boot_" prefix.
> 
> Something like
> 
> rdmsr_without_any_exception_handling_and_other_gunk_don_t_you_even_think_of_adding()
> 
> ...
> 
> But srsly:
> 
> raw_rdmsr()
> raw_wrmsr()
> 
> should be good, as tglx suggests offlist.
> 
> You can do that in one patch and prepend your set with it.
> 
> Thx.
> 


Assuming that we will actually allow the guest to read the IA32_XSS, then it is correct,
but otherwise we will need to return some cached value of IA32_XSS,
the same as the guest wrote last time.

Or another option: KVM can cache the last value that the guest wrote to IA32_XSS (I assume that
the guest can write msrs by sharing the address and value via GHCB), and then use it
when it constructs the CPUID.

Best regards,
	Maxim Levitsky




