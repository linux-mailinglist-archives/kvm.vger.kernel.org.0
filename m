Return-Path: <kvm+bounces-431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2F877DF995
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:09:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D488281CF8
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6922D21117;
	Thu,  2 Nov 2023 18:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C4Q6wwRd"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD1A21108
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:09:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E41B170D
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698948368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nD8lh0J8JiWJ+kvt0KJ7RLOjVJvmjV+qsIu+YAgB6DM=;
	b=C4Q6wwRdVvQVsCDTNr8d7jUHMJcwB9gd2vzNpzhyLl+mMFYfajFov+MTRFBpug6TN7QL0Q
	pHp3eAH8tfJbB+Cr4cWLZojZMQB2RcXOio21brsyG8ab1IL1GxnN3iNDrXfa221j/Xaywh
	iIkdG5cb+lMn5SjyGQcfrZ1G0MKDtho=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-e-exaLF-Maa5cf4Mi8v1NA-1; Thu, 02 Nov 2023 14:06:06 -0400
X-MC-Unique: e-exaLF-Maa5cf4Mi8v1NA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4094e5664a3so8066245e9.0
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:06:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698948365; x=1699553165;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nD8lh0J8JiWJ+kvt0KJ7RLOjVJvmjV+qsIu+YAgB6DM=;
        b=wMm41m9iw5bAqEBKdsEeNwDIj3JBeAX9DgRzzVYjGJTnXIYFdJgS2ztWJVT98kHnnO
         Nbj2FJ3fggGpkFgLqpHdeySMOozsx09n1hdp3skpFyW6IvoY3YEiZtLgvh/AGtJtjmQY
         ++0tp5eBsTJVYw8MnkN5zGDlHAl7y85upK8dVVBAGvi3ZqXgo6XKMPrpZrnNCLDaFnpF
         RfLPbGtx6oIVcfW4SUZBTyco+Zu2BtbcT+AwFofcGwNu4kqkDeXapUozVcKQjDcmBXn5
         V14csoGn01zfxCbeOMmZve27npP47gpxkURlOqBqEounXyWh+3bP4z9amxpNZu5M2eUT
         QylA==
X-Gm-Message-State: AOJu0Yzpgqf2TOekrEmAV6Szmk6ixBHF8CJrl2GK39cLgZiMiaGtnGhy
	ytHjKE+A8T/2IN3r1VxkzTuPmUJqzj5fyzK1wWF/oq5UVsBEE45GI1yhGZU6emTxT8SVTu5jwGp
	UL32MTvqYOdU9OmsEpHo9
X-Received: by 2002:a05:600c:acc:b0:401:bdd7:49ae with SMTP id c12-20020a05600c0acc00b00401bdd749aemr17206728wmr.18.1698948365132;
        Thu, 02 Nov 2023 11:06:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUfpY3pn466g3IG4+RPvgHe7nNa/Hy9VJNg9r7eUGZ4RAmCjMw5LPHpYlEp269Vaogh4yBnA==
X-Received: by 2002:a05:600c:acc:b0:401:bdd7:49ae with SMTP id c12-20020a05600c0acc00b00401bdd749aemr17206702wmr.18.1698948364781;
        Thu, 02 Nov 2023 11:06:04 -0700 (PDT)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id bh27-20020a05600c3d1b00b004063d8b43e7sm3649100wmb.48.2023.11.02.11.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:06:04 -0700 (PDT)
Message-ID: <e87c077a463f13b3c71bfc4e09493e4751aaa563.camel@redhat.com>
Subject: Re: [PATCH 4/9] KVM: SVM: Rename vmplX_ssp -> plX_ssp
From: Maxim Levitsky <mlevitsk@redhat.com>
To: John Allen <john.allen@amd.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 weijiang.yang@intel.com,  rick.p.edgecombe@intel.com, seanjc@google.com,
 x86@kernel.org,  thomas.lendacky@amd.com, bp@alien8.de
Date: Thu, 02 Nov 2023 20:06:02 +0200
In-Reply-To: <20231010200220.897953-5-john.allen@amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
	 <20231010200220.897953-5-john.allen@amd.com>
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
> Rename SEV-ES save area SSP fields to be consistent with the APM.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/include/asm/svm.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 19bf955b67e0..568d97084e44 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -361,10 +361,10 @@ struct sev_es_save_area {
>  	struct vmcb_seg ldtr;
>  	struct vmcb_seg idtr;
>  	struct vmcb_seg tr;
> -	u64 vmpl0_ssp;
> -	u64 vmpl1_ssp;
> -	u64 vmpl2_ssp;
> -	u64 vmpl3_ssp;
> +	u64 pl0_ssp;
> +	u64 pl1_ssp;
> +	u64 pl2_ssp;
> +	u64 pl3_ssp;
>  	u64 u_cet;
>  	u8 reserved_0xc8[2];
>  	u8 vmpl;

Matches the APM.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


