Return-Path: <kvm+bounces-194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E215F7DCE9A
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 15:05:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DC801C20CA9
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 14:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A1541DDDE;
	Tue, 31 Oct 2023 14:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KTRbEKlR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF92C1DDDC
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 14:05:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5EDDE
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698761117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b3+IDD/zfis6WmMbv8JkX7GvGsvp9oF9UGR72Q5DJxI=;
	b=KTRbEKlR93ESGdIUDLmON428qOaCkAwmr03f+HJwbMTFe3ZDGJu4Xbz6AvR4cYKelJQgTI
	bY+WDqndJW9RQYM26dEK3WpurAdHoCPrPHKVHg8aK50EQqCkmL9Q4F6nnHxsjbNfG7J7AG
	jpn6kvLdNumUHfjOW2QankrJN5hIjdc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-1l1-oz77Mni4CsRz4MEVIQ-1; Tue, 31 Oct 2023 10:05:05 -0400
X-MC-Unique: 1l1-oz77Mni4CsRz4MEVIQ-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-53e2acda9d6so4302429a12.2
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:05:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698761103; x=1699365903;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b3+IDD/zfis6WmMbv8JkX7GvGsvp9oF9UGR72Q5DJxI=;
        b=jJ1W+Z2H5VSzdEt4Q7EprDkYc8/QhdJXqdcRQ57Ktj4wU0Ib/Goggo6iVUDys7w4Yg
         xHL+XZKvvhewbTLFFbY+xAAKsW7AuMx1WvK1Y341OpvqTWHK88MtOLgjI6/Hi2KN5fuu
         e744EZ77VH4mARL1PCnPADR6iz1Rs8/eWQxI+bblThalkt5EaUn1A24Mj1BJAarGZAwf
         9AErOjc6i6XOP8FZsrhFUdwG/KFiGm/C5Q6RN95crCj55ehD1MgB76SRXgc69k3aVyhB
         7g7h8p1OUo2XrGh9YMrATyKijDm1e2V0kVjlAC3bnHra5QTrKmSxE3BIl00Kv7FbuG2O
         6ERQ==
X-Gm-Message-State: AOJu0Yw7eys3Na8Z1mZMB3HkB7DYyZTmQdbyiP/CDB56UU29AYnKYoFo
	k5SvPhn/sWUtOtd+lddi2DbRT2j9lCYrl2uY8KUN9DgFPaWOM8Meu7mvLamjQcT53bZThTQWTdq
	+Ea4zL3NfybHH
X-Received: by 2002:a50:9f21:0:b0:543:5b61:6908 with SMTP id b30-20020a509f21000000b005435b616908mr2688972edf.18.1698761103186;
        Tue, 31 Oct 2023 07:05:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/3bnW3ujZbhhfg09W20sfZCeii3XoDwWmA9FyvDCB0gAGy5rkuqM3n7qS5VM/IUq0Q0gU9Q==
X-Received: by 2002:a50:9f21:0:b0:543:5b61:6908 with SMTP id b30-20020a509f21000000b005435b616908mr2688949edf.18.1698761102840;
        Tue, 31 Oct 2023 07:05:02 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id f18-20020a50a6d2000000b0053e5f67d637sm1199012edc.9.2023.10.31.07.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Oct 2023 07:05:02 -0700 (PDT)
Message-ID: <27596365-7796-4009-9bd1-b4640b03bb5b@redhat.com>
Date: Tue, 31 Oct 2023 15:04:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: Add missing fput() on error path
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Dan Carpenter <dan.carpenter@linaro.org>
Cc: Michael Roth <michael.roth@amd.com>, Ackerley Tng
 <ackerleytng@google.com>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, kvm@vger.kernel.org,
 kernel-janitors@vger.kernel.org
References: <64117a7f-ece5-42b1-a88a-3a1412f76dca@moroto.mountain>
 <ZUEJUQYiszUISROL@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZUEJUQYiszUISROL@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/23 15:04, Sean Christopherson wrote:
>>   
>>   	if (offset < 0 || !PAGE_ALIGNED(offset))
>> -		return -EINVAL;
>> +		goto err;
> Gah, I messed up when squashing a fix for v13.
> 
> Paolo, assuming you're grabbing all the fixups for v14, please apply this one too.

Yes, it was already on my list. :)

Paolo


