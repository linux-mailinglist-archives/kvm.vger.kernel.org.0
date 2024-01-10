Return-Path: <kvm+bounces-5984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A49F82962E
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 10:21:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C37541F243FF
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 09:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13D73EA7F;
	Wed, 10 Jan 2024 09:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="iFS0yr26"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384B43EA73
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 09:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-555aa7fd668so4504381a12.0
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 01:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1704878489; x=1705483289; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7KdvnDVT3RerDcuyovlFeMJkh/Y6h3/FfvY1wG84drU=;
        b=iFS0yr26NgnX5IVcTm9L6y6cDIJeOKcTHdGiMdlwKe7IFaWDfUW/qxAWONWQAjVikH
         Kx9E0DVzOgd29HAyW8o61+r1bd/BBqBP2yBdnVYLkWmunh/Zam7Tleahm8rFOS4oJ+sR
         SZYQyrqeqPALGqI6jt+kEUu6SLPQD56tWvSvTFmAa9K+3elZDOKN8t6euNM+//G16qMI
         9JO66TB5GpL/m56CZW9ymiqr9sRBnl0ogpDCIlnvUJ23l0OonLNkoreKe1l+z8GuawWK
         Mg4jXZtcjpJhQ5aZxHB+Qdktan49Z6q8Z+cxK7Mre+R1KgKpEMCTZRH4t6QLaZ0soxcI
         eqFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704878489; x=1705483289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KdvnDVT3RerDcuyovlFeMJkh/Y6h3/FfvY1wG84drU=;
        b=rGUzaX5fSy0W9ZEx9LV1NNCrnUId2qY9S6eSlMh8FU4uZ4N16Bh1PYkkFftLsss+Zb
         2h29CodSvYst+51cq9Y0MnycTdk4n1WIVvtkDCAm1qvv7CWP9ZwZmZCfreewnZ+Kc4Te
         H5HNq2WI1gGFTWbwMSw6U/DpwbRa5am2L1S7FlwPB5jwvWhZ/vYFOxDzO/jE5WvHdGc7
         5rnUb3QJlIoRMPE02EWCQRe3EXNNtawghiYLlfpcLt2syImP7ImP5EjvJ4A01jCiSpYU
         DL3n+b/ATER98wcaSjTpHgDwjqa8UHgN7vugF82Mb6K3jUaM/eHl/QYjOhLfpX2haFEI
         z9tA==
X-Gm-Message-State: AOJu0YyOadiha3umYf4sO8VZ4ly5ElHRYv5HPiTb78Uv4iIpEt/aL0Nb
	GKLtgRFrt5t+tt2kHN8tu5Ni+TMB9w4QLA==
X-Google-Smtp-Source: AGHT+IGEyTr+ypAUAY7JbOPesSBCqHWJ7TGBGWoPJ0liiEUzCKwbvNO3k3m5p0ACna7QK0erWKDXCQ==
X-Received: by 2002:a05:6402:617:b0:557:3c8a:20a8 with SMTP id n23-20020a056402061700b005573c8a20a8mr217861edv.66.1704878489390;
        Wed, 10 Jan 2024 01:21:29 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id l8-20020a056402344800b00554b1d1a934sm1801943edc.27.2024.01.10.01.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 01:21:29 -0800 (PST)
Date: Wed, 10 Jan 2024 10:21:27 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Like Xu <likexu@tencent.com>
Subject: Re: [PATCH v10 15/29] KVM: selftests: Add pmu.h and lib/pmu.c for
 common PMU assets
Message-ID: <20240110-a69620ca0ebce509dc54f025@orel>
References: <20240109230250.424295-1-seanjc@google.com>
 <20240109230250.424295-16-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240109230250.424295-16-seanjc@google.com>

On Tue, Jan 09, 2024 at 03:02:35PM -0800, Sean Christopherson wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> Add a PMU library for x86 selftests to help eliminate open-coded event
> encodings, and to reduce the amount of copy+paste between PMU selftests.
> 
> Use the new common macro definitions in the existing PMU event filter test.
> 
> Cc: Aaron Lewis <aaronlewis@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  tools/testing/selftests/kvm/include/pmu.h     |  97 ++++++++++++
>  tools/testing/selftests/kvm/lib/pmu.c         |  31 ++++

Shouldn't these new files be

tools/testing/selftests/kvm/include/x86_64/pmu.h
tools/testing/selftests/kvm/lib/x86_64/pmu.c

Thanks,
drew

