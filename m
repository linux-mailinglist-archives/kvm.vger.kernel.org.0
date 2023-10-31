Return-Path: <kvm+bounces-205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 325FB7DCF39
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 15:31:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF67C2817C6
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 14:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E4331DFD8;
	Tue, 31 Oct 2023 14:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AEHgBXcK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF39A1DFC8
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 14:30:58 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81386F9
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:30:57 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9cb79eb417so4382107276.2
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698762657; x=1699367457; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G+5mFSmwzy02eXplSCzUEvQ6qF9l0j94is7Nf9C9jYY=;
        b=AEHgBXcK60CLou9N22CWwHcBvAaaRBMjJFOosK/TBu+g/89Ojh0+58uOE2dEQqMSuN
         CsOocHoyo82FoCCM+7XTX7fZODOUu1vEVFggc4vyRNd2cSCnF5jtNOoO+5ODkzCOb7/N
         SEfm6WHV7OncdyYqEPfGg4mkiQDZUHZ+Jz/A+K5AS20lJFw5MLylLyS1FlBLzLZXqGKE
         Fn31vhuDMO5hFBeGCz1cYL7MOH89ov3gc6AZjfGUAtZVxaRxkS7WMYm4sifoNd1ykND4
         +kUCH91uwUerzdI4teq59LuSAKcdS6HMlijX0hZydze9OazSzLU326niQYpFtHx+Axsc
         tjDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698762657; x=1699367457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G+5mFSmwzy02eXplSCzUEvQ6qF9l0j94is7Nf9C9jYY=;
        b=xKE3GoN5PkSB6lT9toRL9w/n6dzoqmNuJbkbu4jLjS3iqHYSE7vDv0o+prQx7rqU/B
         9WYNDrsKleFCtnS/CeRO23Jf3A6W5/EfC5Eu2kUUZmz6LK5mUL/n2FULOsythUDGx4g6
         zfBsFqpnStwumGdZ0C0Tm/ePcvr5yP+J/l7t8HwsoItsQofH2FX0qcCkz/S+JwGVtVmT
         lVvp/yRjxtiiTZrpFf5paaQpsDQ58DObwzBuJ8ZA7x0+ta2W1wBgGTvox6vroU5Rpm3p
         K/RvDeTr+UXNfhCUr0PRx2YBh7o3Q9KrUnkIcxtUqf7cq4wnRmj5PPDkegjfPHroh1mH
         N0tA==
X-Gm-Message-State: AOJu0Yy5O4xkkohzXTA5mIdcedKu5xxyrEdNZMzT0/TPth798XcqyDI2
	oyS13DfBFySCFhZ1Qe317akStfgVkgc=
X-Google-Smtp-Source: AGHT+IEZqhN+IYUKaMtos7FbgKMZPVomc9IftVr5HCPDZa4DCVZQBFFRA7mieVnbr/UJ/ajvGhyuR5QPPKc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1788:b0:da0:c9a5:b529 with SMTP id
 ca8-20020a056902178800b00da0c9a5b529mr222465ybb.12.1698762656758; Tue, 31 Oct
 2023 07:30:56 -0700 (PDT)
Date: Tue, 31 Oct 2023 07:30:55 -0700
In-Reply-To: <CAD=HUj5733eL9momi=V53njm85BQv_QkVrX92xReiq0_9JhqxQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <CAD=HUj5733eL9momi=V53njm85BQv_QkVrX92xReiq0_9JhqxQ@mail.gmail.com>
Message-ID: <ZUEPn_nIoE-gLspp@google.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, David Stevens wrote:
> Sean, have you been waiting for a new patch series with responses to
> Maxim's comments? I'm not really familiar with kernel contribution
> etiquette, but I was hoping to get your feedback before spending the
> time to put together another patch series.

No, I'm working my way back toward it.  The guest_memfd series took precedence
over everything that I wasn't confident would land in 6.7, i.e. larger series
effectively got put on the back burner.  Sorry :-(

