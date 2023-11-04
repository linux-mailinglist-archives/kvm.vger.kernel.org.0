Return-Path: <kvm+bounces-581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AFC667E0F7E
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 13:52:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F89BB20E1E
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 12:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F315E18AF6;
	Sat,  4 Nov 2023 12:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s8ktyN0Y"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930AB18620
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 12:52:39 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517B5194
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 05:52:38 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-408c6ec1fd1so21105e9.1
        for <kvm@vger.kernel.org>; Sat, 04 Nov 2023 05:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699102357; x=1699707157; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Flw7vZposfF8ezOQAkBBKQ76gaOacIHBIh3z+VoINuc=;
        b=s8ktyN0YhRSiZwbZXf2/Wl1vuGTIH0pHsr0eAcQLK/SFs/Xekvw+0M/exsR9rS9Xc/
         p+pfaLUJ0GZDEB3W8oewoCGSxfpf9pprpkZEiD1QxPhObSWzFdI5zznBnrx3pzIe5Tay
         ku/PcaKBnPJwX5h/QOZUhcSprIyH2CO1L0OHo18CHn7urNt8crAkiyubU4krUscS48Wd
         B6BGR7oTYU7rOfYgsrTs8S4AkUGOtY9jsHc63yswVL4SPM1SqVZK25iVZKMfFj1Q6dZl
         RHuJzhHDRdD+IMIfcPELOyJ6tZFI5KsLqk6TJ4DW576wThw5qoUEMtY/HGchMKubUUZ+
         Gz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699102357; x=1699707157;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Flw7vZposfF8ezOQAkBBKQ76gaOacIHBIh3z+VoINuc=;
        b=eX3C85H/qQDwhRAmpCKLSxi2VpNrDZMa6614fOXWDJg9DZIU0nckmzV0h2e2Swy4Xq
         KTp5P/YjWkekR+nle7ejofpgwQ6/jhbbVyh2znvmZ/ab9up6iIb7DRWRR5ZV6YOWELpH
         TVPmm1xKhhl3CpMwvH9r3pgZDJMD3PGpYMXXMy1XnivCduSIB42UerUmW4AD9mEs9lY6
         sN50jveiQZhDOuNcqV6Larek0Wm2Tuz1MHLXhiCXkUN3rnrBeX9ZGTNhgtG0M5QCBYdM
         GVyyfIFTR7cWe1hix8gdXKjS2ppeepSRIeFJJJs3tZ82GQFox2/HY5/C0VL0fjMmZYGr
         fGSw==
X-Gm-Message-State: AOJu0YyZ1sU/lP4EJMJ3Rbawh2gmQwNImma35RK2RhTFkDRAEec47iR3
	7wMjAUKT3nvK743wPW+9n3j2kPTdDQo9stkGPB+jsl6wiOwFBx3gl0I=
X-Google-Smtp-Source: AGHT+IEFpVoIAL3pQCTnVkmFsoixSOlqR6uSd2KntS4PaOIRWms+TNlmkBFhh5ndXwX3CoO+p9QkdEz+OYy5AcW3X+c=
X-Received: by 2002:a05:600c:929:b0:3f7:3e85:36a with SMTP id
 m41-20020a05600c092900b003f73e85036amr44095wmp.7.1699102356618; Sat, 04 Nov
 2023 05:52:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com> <20231104000239.367005-8-seanjc@google.com>
In-Reply-To: <20231104000239.367005-8-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Sat, 4 Nov 2023 05:52:24 -0700
Message-ID: <CALMp9eRZCEuCQHH7G-ZS6U_Zi768qcdZmwPtmNgxMRNjppnKbg@mail.gmail.com>
Subject: Re: [PATCH v6 07/20] KVM: selftests: Drop the "name" param from KVM_X86_PMU_FEATURE()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 3, 2023 at 5:02=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Drop the "name" parameter from KVM_X86_PMU_FEATURE(), it's unused and
> the name is redundant with the macro, i.e. it's truly useless.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

