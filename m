Return-Path: <kvm+bounces-5871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 576D0827EC4
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 07:26:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9CAF1F24673
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 06:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23B368F40;
	Tue,  9 Jan 2024 06:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Aky2la1f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67E815A7
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 06:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704781604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o5muih4kLDuaOJ79kxaRis+p0HII4Xana+6AsswLR/c=;
	b=Aky2la1fe0Xh6j+lD69acniS2kC09dQdxnY6ww4z8svMco9xxlYt9F4tdyyHaKkmKxr30A
	vqorS8BzPjjJ1rKk78NyE5UDnpVfQM9zSnRSoXdfD7YjX/IvSxkYTbtSbGowIgaFr+1jms
	n/4GhFZHDcwFh6nDpBcpUvRoXYGsfUk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-uKR1OAyPNROWJhFhCxznjw-1; Tue, 09 Jan 2024 01:26:43 -0500
X-MC-Unique: uKR1OAyPNROWJhFhCxznjw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40e49906305so9023605e9.2
        for <kvm@vger.kernel.org>; Mon, 08 Jan 2024 22:26:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704781602; x=1705386402;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o5muih4kLDuaOJ79kxaRis+p0HII4Xana+6AsswLR/c=;
        b=c9zMGgWJG4tZ8n+I3XtzPf+IIKPwI7FEBl6TelkOoe3dDJ6CxkT4YSlC/7+F5pUDKj
         X/omdzyWb2ABfLZx13mV8dF3ETSymKC4U/ryI7GViK3dYkjACPKYZhVyXMnJuuQbOmKW
         w5PNq/nnLYZlyfxGAnziAECou704LDeba0MVAeCTNmoCFuf7MournT3q7tZoJEnzQXJM
         Ih++juuhtXHEPDMWKcuavNjpLSSyNgyvvl700FQXBpVOZ22cj7jkLUd4IyHqWQje9B3f
         GT4UAobfNw5tIHQ+zmEl1W6Yh2SboyFxCQ1kPbsNIZjyX3iD5HZwSTsGlLovndM4xW88
         nguQ==
X-Gm-Message-State: AOJu0Yx4UV9i86XzVLKumMp0VF1CgC+RjoTjRIP6EgWieCTmqJjJCRXQ
	Ns1/5zJ7W0PEf5ctjb/mgTREklW6i1EO8EQFUvMO2gfSKF+4auf25mo2iY9iVmVcMdaxgxaWdRw
	0s2Pzvm4gzlGwUIV3cPRU/mLtuzdhmi35/AbY
X-Received: by 2002:a7b:cd0d:0:b0:40e:4239:506d with SMTP id f13-20020a7bcd0d000000b0040e4239506dmr2027379wmj.175.1704781602229;
        Mon, 08 Jan 2024 22:26:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFVUTxD6fI8GCkCwWKDNUsc5oILgZSUFknu9p75wtGYWi8UpdMljIYYVfvPmZx7Kmqt0v8T7GDBV1OM+0Mt1QY=
X-Received: by 2002:a7b:cd0d:0:b0:40e:4239:506d with SMTP id
 f13-20020a7bcd0d000000b0040e4239506dmr2027375wmj.175.1704781601960; Mon, 08
 Jan 2024 22:26:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240103075343.549293-1-ppandit@redhat.com> <CAE8KmOwPKDM5xcd1kFhefeJsqYZndP09n9AxaRbypTsHm8mkgw@mail.gmail.com>
 <ZZwy-wCpHs-piGhJ@google.com>
In-Reply-To: <ZZwy-wCpHs-piGhJ@google.com>
From: Prasad Pandit <ppandit@redhat.com>
Date: Tue, 9 Jan 2024 11:56:25 +0530
Message-ID: <CAE8KmOxk+Vesh_y_gwM+GD8F9VwK2x_MmcQ_b6CiGKORZu52ZQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: make KVM_REQ_NMI request iff NMI pending for vcpu
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 8 Jan 2024 at 23:08, Sean Christopherson <seanjc@google.com> wrote:
> This is on my list of things to grab for 6.8, I'm just waiting for various pull
> requests to fully land in order to simplify my branch management.

* Okay, cool.

Thank you.
---
  - Prasad


