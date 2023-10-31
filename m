Return-Path: <kvm+bounces-212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77B0D7DD269
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:43:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A07B281854
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 16:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B9E1E506;
	Tue, 31 Oct 2023 16:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xq/K6WUJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BBE1D6BD
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:43:42 +0000 (UTC)
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C715E1BF
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:43:40 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-5ab53b230f1so4126898a12.3
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698770620; x=1699375420; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KUWzNpZFu6ZH+LPCMipXBlnOZ2iMu0xo6DdlSVTTSCM=;
        b=xq/K6WUJT8CqcSv142B1xusTthevqQt6VrjvnoB/CJrAeL2QYkp8xFzyY1QhKEn9o0
         jB3q0hvnxRPMa+81oNjJCGfntadyK2H4PI+20Z771RVjlZek59qEx55TFuo8S92jI8J0
         niwZwMOcRuVyHckT0B/XE0BqEiG+FWYXQN1MCYjyAfxwXktdeg2mDnBGmmq5EV62Fxfn
         /+y+SwE6dFPmC101DRBtthXKgkcejhuLrjUdnYNYJ9lwkSBq+WZyv95SWWu5SNrNxsGj
         kMDia302Dw1tdeq17HmMWj51BKtyGrY5Ek3gshWqT4HRovXRrC7UZaEdiCPodhEMOo1w
         hfBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698770620; x=1699375420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KUWzNpZFu6ZH+LPCMipXBlnOZ2iMu0xo6DdlSVTTSCM=;
        b=YugBkWdOQZyZnMjivsA6tjllCWP9rLm9/8YudHO8G+9uKGq/DML2Px4tjYRYfogm4V
         nMSRg0Yq7MSNShpbAGLJuTmC7mww5oxrY4pWmNQhm2z0GdGb+UZt5J+FdswHVqycFR60
         7h/dmw0WUxZ6ftA4aXp+Vx3Xoy/0sFEORVlfLEtYyuvbSZZIyP+db6cqJfdL9zeKZ3M8
         aftBu6IJjsvujahnleJHvrOSx+jTnI2E4VxmsTdf+mg5oKbga38QA+TW3dCUZH8CtP9o
         HOmO2MYs+bcgdmlTbTXDcpRlGJ7pEoU0TkROEWUB85ISqX3PFcl8jivYf/Mu38nsxZfE
         AotA==
X-Gm-Message-State: AOJu0YxJaWNPhXEqddObfrFnWnDa17HGwM9yp2KfmInkzuYHnVIdTY0V
	Z2U498xVL0ddZpgLnzTQ0plb5w==
X-Google-Smtp-Source: AGHT+IEij7+ydhlYjhr1xlKLUtNUJw25BFH2l+RQ8zeBA7dBnKRXxZXchV1bLlBIgwVsc3GuzIJ3dQ==
X-Received: by 2002:a05:6a20:a10b:b0:15d:7e2a:cc77 with SMTP id q11-20020a056a20a10b00b0015d7e2acc77mr12395968pzk.48.1698770620059;
        Tue, 31 Oct 2023 09:43:40 -0700 (PDT)
Received: from google.com (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with ESMTPSA id fb17-20020a056a002d9100b006b1e8f17b85sm1451493pfb.201.2023.10.31.09.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 09:43:39 -0700 (PDT)
Date: Tue, 31 Oct 2023 09:43:32 -0700
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>,
	Anish Moorthy <amoorthy@google.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Vlastimil Babka <vbabka@suse.cz>,
	Vishal Annapurve <vannapurve@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Maciej Szmigiero <mail@maciej.szmigiero.name>,
	David Hildenbrand <david@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>,
	Liam Merwick <liam.merwick@oracle.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v13 13/35] KVM: Introduce per-page memory attributes
Message-ID: <ZUEutAmPcVLHXlQc@google.com>
References: <20231027182217.3615211-1-seanjc@google.com>
 <20231027182217.3615211-14-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231027182217.3615211-14-seanjc@google.com>

On 2023-10-27 11:21 AM, Sean Christopherson wrote:
> From: Chao Peng <chao.p.peng@linux.intel.com>
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 89c1a991a3b8..df573229651b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -808,6 +809,9 @@ struct kvm {
>  
>  #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
>  	struct notifier_block pm_notifier;
> +#endif
> +#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +	struct xarray mem_attr_array;

Please document how access to mem_attr_array is synchronized. If I'm
reading the code correctly I think it's...

  /* Protected by slots_locks (for writes) and RCU (for reads) */

