Return-Path: <kvm+bounces-428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 307C37DF976
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:03:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F97FB21387
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEAB521111;
	Thu,  2 Nov 2023 18:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fhAMrvGI"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF37210FD
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:03:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBE04482
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698948063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZJ+UkH3qPYQ7lRJ5DdsZoeXn42tgB94NClzdfh7mZoQ=;
	b=fhAMrvGIrgNhgeTFIHa1B7j9K7joSluX5iTHlBv//ppfmu/fwNZInItDG8x3+UGtoAoMdy
	DBJBDpTbioOzRHSIsCkET1I1Hl+7pUiczQwyWtOHLPRDC6oWUblpN4FSBZkk6eqieEPhR4
	ST6ozRoWab6vKMrgXtHdo1SM2Bu7ttw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-o9frmOMePmOpEE9gKr4msA-1; Thu, 02 Nov 2023 14:00:58 -0400
X-MC-Unique: o9frmOMePmOpEE9gKr4msA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-32df2fc01e8so1475031f8f.0
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:00:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698948057; x=1699552857;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZJ+UkH3qPYQ7lRJ5DdsZoeXn42tgB94NClzdfh7mZoQ=;
        b=PU29zugx3WgQ7bfwv89FQAhR9+HNIilHDchMg/9zBSTyk6Tz9w4wH6zoTNBNFuAu+5
         iNz9BLeWjSW1K2HNKlkV3ex3hO/h83WE2mc0E5OVeq+AY/IE5TBh6MM0wE1mKXDmVsXf
         quI6vN9Xsgii+t7XdceGujoddv+fkw+q3p8w235USm2msJTtJdi525ObqCERyvrj0bQA
         wTj2CEoYY94SKO70xtouY+W463NwCZXm03HkVDnokCKVxO5IVYtqyY+pNgfOfNxU0fYU
         mefUw6fef8cjJ8LadmnHzIqGyR2BhHoNe++By6rbO4nq/bThu4eoBsllG8AWEiXCaKEx
         B1MA==
X-Gm-Message-State: AOJu0YxXxSQprHJ7DZaOsgtJP5/zVAvqmpUdc57oHeFffhlj791za1tb
	qJVrkUFwB5D9ElEV01vUMgofGF+NPyKfu1IyG8t/T553U5/Wh19vwpBDesOG498N69Gsf/VjoJE
	baWu22L3Q3ht+cMg6dbtS
X-Received: by 2002:a5d:584b:0:b0:314:c6b:b9a2 with SMTP id i11-20020a5d584b000000b003140c6bb9a2mr545385wrf.13.1698948056970;
        Thu, 02 Nov 2023 11:00:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1n2z71L+wqB4Mkj6U4jKyy45oITPgji4/YRzxTHFku+S26pjfXL8zLBz7RADa15XZapq+LQ==
X-Received: by 2002:a5d:584b:0:b0:314:c6b:b9a2 with SMTP id i11-20020a5d584b000000b003140c6bb9a2mr545324wrf.13.1698948056251;
        Thu, 02 Nov 2023 11:00:56 -0700 (PDT)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id u9-20020adfed49000000b0031c52e81490sm3023134wro.72.2023.11.02.11.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:00:55 -0700 (PDT)
Message-ID: <1af84c9b931f7dda277b49d1463ea8cdcda32cf0.camel@redhat.com>
Subject: Re: [PATCH 2/9] KVM: x86: SVM: Update dump_vmcb with shadow stack
 save area additions
From: Maxim Levitsky <mlevitsk@redhat.com>
To: John Allen <john.allen@amd.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 weijiang.yang@intel.com,  rick.p.edgecombe@intel.com, seanjc@google.com,
 x86@kernel.org,  thomas.lendacky@amd.com, bp@alien8.de
Date: Thu, 02 Nov 2023 20:00:54 +0200
In-Reply-To: <20231010200220.897953-3-john.allen@amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
	 <20231010200220.897953-3-john.allen@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2023-10-10 at 20:02 +0000, John Allen wrote:
> Add shadow stack VMCB save area fields to dump_vmcb. Only include S_CET,
> SSP, and ISST_ADDR. Since there currently isn't support to decrypt and
> dump the SEV-ES save area, exclude PL0_SSP, PL1_SSP, PL2_SSP, PL3_SSP, and
> U_CET which are only inlcuded in the SEV-ES save area.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6a0d225311bc..e435e4fbadda 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3416,6 +3416,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  	       "rip:", save->rip, "rflags:", save->rflags);
>  	pr_err("%-15s %016llx %-13s %016llx\n",
>  	       "rsp:", save->rsp, "rax:", save->rax);
> +	pr_err("%-15s %016llx %-13s %016llx\n",
> +	       "s_cet:", save->s_cet, "ssp:", save->ssp);
> +	pr_err("%-15s %016llx\n",
> +	       "isst_addr:", save->isst_addr);
>  	pr_err("%-15s %016llx %-13s %016llx\n",
>  	       "star:", save01->star, "lstar:", save01->lstar);
>  	pr_err("%-15s %016llx %-13s %016llx\n",

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


