Return-Path: <kvm+bounces-445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44F127DF9DE
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:26:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 669341C20F9A
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 032EA21355;
	Thu,  2 Nov 2023 18:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JmKlPZ42"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3455821344
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:26:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C83138
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698949570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o7VlI3P4zkoGBoInIQmHlfw4FeMBcLOAHJ8eeKcs2mc=;
	b=JmKlPZ42Mxkh+yFQVUJy8rBI8ZjlCYrvsbH2X95ueHarnsZhdLgZFOZLe4YEEzvOLUSXJH
	hoQd34BVzSMb1ZTxDnHd5JbVk1NoUbuhq+05AGB4A3zKveYZz50wCP8XbOUYj+Jo2ITLAV
	JiEO86znkd39+xxBQ6XZ6WqSHIxj/hs=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-9TIHnKYnPk-6AHERjAmJqw-1; Thu, 02 Nov 2023 14:26:09 -0400
X-MC-Unique: 9TIHnKYnPk-6AHERjAmJqw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-507d4583c4cso1356943e87.1
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:26:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698949567; x=1699554367;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o7VlI3P4zkoGBoInIQmHlfw4FeMBcLOAHJ8eeKcs2mc=;
        b=VWaKWEl+6EKgCgLTuys/OHGT+Je47wWDKQcx9IgBQMn8mueriMR+SHfOgp11nBNDib
         2FbIh02vJAogeOwXiTqPjPNcaXpaPMcmIJ+aqZBqUZ1xjL5y6Lahs9wgcR4Q80DbV3BB
         19QnP2g+tXsYYa9rB49sxvCqdacnksF13SSm9nP1lxmCXr5q6x+lIIxVVV9q4xFHWPGk
         YjYht45OvNMJUb+OPA/3SkgzHWdj4MKu3J/2b2wLwPzQkBMoRltrpj3sN+i7YOQrHRRB
         /ZTqoE+V2NMCLThiWXb3ObA6c6UwqqEUiCH4jSO+k3AsfI4N66DYxoSO5C4gJ88UkSJ1
         dQfg==
X-Gm-Message-State: AOJu0Yxb4UHH2GhqCJvSygbCIb9KHAPaSjv/H+BQ5YHEYMiwkurgVUCj
	vyDlh/W1pEjsxXxI35EuLLTvCHqmjhB6JNHz2ZdWJBmD0dNcHDsjzvfENAwyW6l+TPz+QH9QEjb
	CSsmWwkvJie5b
X-Received: by 2002:ac2:44c4:0:b0:509:dd0:9414 with SMTP id d4-20020ac244c4000000b005090dd09414mr10956135lfm.24.1698949567671;
        Thu, 02 Nov 2023 11:26:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwdj92bVhqKRjZlj65hl0Att8XKDMIM0oIyfctzH6r2VQilezMgCK2YEafflmanu3ckbNE7A==
X-Received: by 2002:ac2:44c4:0:b0:509:dd0:9414 with SMTP id d4-20020ac244c4000000b005090dd09414mr10956121lfm.24.1698949567349;
        Thu, 02 Nov 2023 11:26:07 -0700 (PDT)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id j17-20020a05600c1c1100b0040775501256sm298171wms.16.2023.11.02.11.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:26:07 -0700 (PDT)
Message-ID: <1e9921f687abe09d8797e6fb83760acf970f344e.camel@redhat.com>
Subject: Re: [PATCH v6 10/25] KVM: x86: Add kvm_msr_{read,write}() helpers
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, dave.hansen@intel.com, 
	peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 02 Nov 2023 20:26:05 +0200
In-Reply-To: <ZUKnyfbRqTFhMABI@google.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-11-weijiang.yang@intel.com>
	 <92faa0085d1450537a111ed7d90faa8074201bed.camel@redhat.com>
	 <ZUKnyfbRqTFhMABI@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-11-01 at 12:32 -0700, Sean Christopherson wrote:
> On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> > On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > > Wrap __kvm_{get,set}_msr() into two new helpers for KVM usage and use the
> > > helpers to replace existing usage of the raw functions.
> > > kvm_msr_{read,write}() are KVM-internal helpers, i.e. used when KVM needs
> > > to get/set a MSR value for emulating CPU behavior.
> > 
> > I am not sure if I like this patch or not. On one hand the code is cleaner
> > this way, but on the other hand now it is easier to call kvm_msr_write() on
> > behalf of the guest.
> > 
> > For example we also have the 'kvm_set_msr()' which does actually set the msr
> > on behalf of the guest.
> > 
> > How about we call the new function kvm_msr_set_host() and rename
> > kvm_set_msr() to kvm_msr_set_guest(), together with good comments explaning
> > what they do?
> 
> LOL, just call me Nostradamus[*] ;-)
> 
>  : > SSP save/load should go to enter_smm_save_state_64() and rsm_load_state_64(),
>  : > where other fields of SMRAM are handled.
>  : 
>  : +1.  The right way to get/set MSRs like this is to use __kvm_get_msr() and pass
>  : %true for @host_initiated.  Though I would add a prep patch to provide wrappers
>  : for __kvm_get_msr() and __kvm_set_msr().  Naming will be hard, but I think we
>                                              ^^^^^^^^^^^^^^^^^^^
>  : can use kvm_{read,write}_msr() to go along with the KVM-initiated register
>  : accessors/mutators, e.g. kvm_register_read(), kvm_pdptr_write(), etc.
> 
> [*] https://lore.kernel.org/all/ZM0YZgFsYWuBFOze@google.com
> 
> > Also functions like kvm_set_msr_ignored_check(), kvm_set_msr_with_filter() and such,
> > IMHO have names that are not very user friendly.
> 
> I don't like the host/guest split because KVM always operates on guest values,
> e.g. kvm_msr_set_host() in particular could get confusing.
That makes sense.

> 
> IMO kvm_get_msr() and kvm_set_msr(), and to some extent the helpers you note below,
> are the real problem.
> 
> What if we rename kvm_{g,s}et_msr() to kvm_emulate_msr_{read,write}() to make it
> more obvious that those are the "guest" helpers?  And do that as a prep patch in
> this series (there aren't _that_ many users).
Makes sense.

> 
> I'm also in favor of renaming the "inner" helpers, but I think we should tackle
> those separately.separately

OK.

> 

Best regards,
	Maxim Levitsky


