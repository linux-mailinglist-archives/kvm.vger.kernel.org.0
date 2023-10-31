Return-Path: <kvm+bounces-167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 439E47DC8D8
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 10:00:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 929B9B20D23
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93B78125CF;
	Tue, 31 Oct 2023 09:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aEdh52PL"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EC3EEA3
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:00:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E9BF9
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 02:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698742812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JJaPhbcmh8rSiQ4KL2QqVbu7Ce8KpG8/Bm1tkvMPCfo=;
	b=aEdh52PLgbu13210qsLG1jIRZPzKh1gE8r8cTbxWVJeUPn2V7kqxmoHZWA3+kwI/TVIgQd
	KbtiUEZkkdfWOOXXq7O4lpDEDjHZe4jMS4cCZkJGYbEheiSXWLDFZAwU8WYwsgqZPL6DGU
	Q9VICgj2SQeEvoHzxFS33d3wYzFzhNc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-8yHOmrYONn6Xj59P5LZmRw-1; Tue, 31 Oct 2023 05:00:11 -0400
X-MC-Unique: 8yHOmrYONn6Xj59P5LZmRw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-507b8ac8007so6322568e87.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 02:00:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698742809; x=1699347609;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJaPhbcmh8rSiQ4KL2QqVbu7Ce8KpG8/Bm1tkvMPCfo=;
        b=Yy7n8ZJiTlMa2lzPdXamJMLWQh+085d5UsLSpPh/O+TzQ7gRkH4x4gsMFXin6Ik9Pn
         VpOPjSLc5FW23XlPst2ulZxTjtH8mP0LGqzv9BRLSm2KNLYJGqAJXay02ncjYBIE9RyN
         BkLQlecgjOZjhYSTRAXJdv79MJ+/C2Z7wWQWdsv7j+LtyLLMKqExX1qCZYIX5nibTEZ6
         jc8cIvxT3RGlXTr7inne5Yhd8IA7RAQydJM1cLteF1QpIlb05m42SQSAIkKaGDKYaEpP
         EJNEewLtu7b/6/J/Xy1oDwRkT7Bi1CZLk+XwW+oxuSu25VS/iiTDpmWlTbOu1NkDTaxi
         gp4A==
X-Gm-Message-State: AOJu0YxxMXxkYg9ZuyTfKRFW6LzPuWUiEATH6p52b6PlFECJN5WJo70d
	qomRfrthKaJw6JKJJZ1FLOp1yyKW+FTzO5qlsP4U61C0LpBQ0gkXqrJtNpMYvOE2tKa1Ojd751D
	o5LzE+0vfazdb
X-Received: by 2002:ac2:42c3:0:b0:509:2b82:4ce8 with SMTP id n3-20020ac242c3000000b005092b824ce8mr1849299lfl.42.1698742809669;
        Tue, 31 Oct 2023 02:00:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3S35L/UQTy/U7yQi8+SVu+0V8xB9AoTI/4Vdd4oeEJ0oJwQJPeCjGFyCZnVrk7tqVWNUWCQ==
X-Received: by 2002:ac2:42c3:0:b0:509:2b82:4ce8 with SMTP id n3-20020ac242c3000000b005092b824ce8mr1849274lfl.42.1698742809259;
        Tue, 31 Oct 2023 02:00:09 -0700 (PDT)
Received: from redhat.com ([2.52.26.150])
        by smtp.gmail.com with ESMTPSA id e13-20020a056000194d00b003142e438e8csm998743wry.26.2023.10.31.02.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 02:00:08 -0700 (PDT)
Date: Tue, 31 Oct 2023 05:00:04 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
	kevin.tian@intel.com, joao.m.martins@oracle.com,
	si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 vfio 6/9] virtio-pci: Introduce APIs to execute legacy
 IO admin commands
Message-ID: <20231031045933-mutt-send-email-mst@kernel.org>
References: <20231029155952.67686-1-yishaih@nvidia.com>
 <20231029155952.67686-7-yishaih@nvidia.com>
 <20231031040403-mutt-send-email-mst@kernel.org>
 <3a7c776d-1e5a-4c8d-b91e-9da5fe91db32@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a7c776d-1e5a-4c8d-b91e-9da5fe91db32@nvidia.com>

On Tue, Oct 31, 2023 at 10:30:41AM +0200, Yishai Hadas wrote:
> > And further, is caller expected not to invoke several of these
> > in parallel on the same device? If yes this needs to be
> > documented. I don't see where does vfio enforce this if yes.
> Please have a look at virtiovf_issue_legacy_rw_cmd() from patch #9.
> 
> It has a lock on its VF device to serialize access to the bar, it includes
> calling this API.
> 
> Yishai

OK so if caller must serialize accesses then please document this assumption.


