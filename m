Return-Path: <kvm+bounces-159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 122387DC81B
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:23:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF7262817BB
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 08:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F6811C92;
	Tue, 31 Oct 2023 08:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bqo2Crsq"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7FD1FDA
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 08:23:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B497DB
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 01:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698740589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lkPsJmsvqXKseM89Bl+2H72cqwC7IoO2lINO3/fCkdY=;
	b=bqo2CrsqFnHUxot5eRIhWPPZxLGYFIgQSHlhzux29Ujq5JuYFoA5yS1reE2II+0wSJinT0
	t9s3SZEXdShfUNFdV794pA5MjzPzANQ8G85gbUWloS9DpwU5vi+hVlv+e9pD730PjBQiPb
	WPvD9dIsZRuHPunIfeWNjvbMkqcTLiI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-eRG7ZgQqN9iCn2bpc5Y34g-1; Tue, 31 Oct 2023 04:23:08 -0400
X-MC-Unique: eRG7ZgQqN9iCn2bpc5Y34g-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-32f5b22e806so2691490f8f.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 01:23:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698740587; x=1699345387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkPsJmsvqXKseM89Bl+2H72cqwC7IoO2lINO3/fCkdY=;
        b=N9M+scEygoE4PLqgCb23fD7JFG8bKUuxcxjgMTNbfzg4p9jMavMRjGfGi6ajSXJ+H8
         XPOHsBXmDIVriu3ihITIjXK1D0CNdkziDKiUEhnJ0zs+Ou7v+hcPPcvexpFE8/wfjkEM
         22IOgjy4quzA8RicvVny7RpddZyKoMyWu7pAnjD0wlK7LqNlDruMMup1U63F3XqxoF82
         SUwuo25Ns2PNCNm8swG9LvIeFfEix+sF3lTfVYm5+WwsK5z5tfEs3JRLSfQsjs5eLAMe
         Q6dESJMbn/yjKW8xYRyJLkbrJo8z37B6SVDZ+uTTKwO6M3/iAt3KaxgaQiGzBd/0rH/w
         fKXA==
X-Gm-Message-State: AOJu0YzbrATBkhoRUZbScYpP6vKAux5BqoMGwPXLT93uaNs3gz3HaOQ6
	Xu+Its4gLwKFPykAWQDzCW1rwTkMMb6GTAnIYFnc6niqD32MkdZo0jka+EvOxlWYG6xQEtP1NDg
	yn/Z39bbg8aIg
X-Received: by 2002:a5d:6daa:0:b0:32f:914e:427f with SMTP id u10-20020a5d6daa000000b0032f914e427fmr1815531wrs.16.1698740586941;
        Tue, 31 Oct 2023 01:23:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFc9PcfR+ryqLtXXr3yzpBv1Zn+JInlQMRQv8GNG2r0TcqZoR483Dbi/gFCaOouLVRP4wmRPw==
X-Received: by 2002:a5d:6daa:0:b0:32f:914e:427f with SMTP id u10-20020a5d6daa000000b0032f914e427fmr1815518wrs.16.1698740586591;
        Tue, 31 Oct 2023 01:23:06 -0700 (PDT)
Received: from redhat.com ([2.52.26.150])
        by smtp.gmail.com with ESMTPSA id c8-20020adfef48000000b0032f7c563ffasm906445wrp.36.2023.10.31.01.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 01:23:05 -0700 (PDT)
Date: Tue, 31 Oct 2023 04:23:02 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
	jasowang@redhat.com, jgg@nvidia.com, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, parav@nvidia.com,
	feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
	joao.m.martins@oracle.com, si-wei.liu@oracle.com, leonro@nvidia.com,
	maorg@nvidia.com
Subject: Re: [PATCH V2 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231031042235-mutt-send-email-mst@kernel.org>
References: <20231029155952.67686-1-yishaih@nvidia.com>
 <20231029155952.67686-10-yishaih@nvidia.com>
 <4a5ab8d6-1138-4f4f-bb61-9ec0309d46e6@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a5ab8d6-1138-4f4f-bb61-9ec0309d46e6@intel.com>

On Tue, Oct 31, 2023 at 04:17:45PM +0800, Yi Liu wrote:
> a dumb question. Is it common between all virtio devices that the legay
> interface is in BAR0?

It has to be, that is where the legacy driver is looking for it.


