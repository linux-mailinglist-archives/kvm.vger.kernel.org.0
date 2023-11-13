Return-Path: <kvm+bounces-1590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1F07E99D0
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 11:07:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E1BB1F20EE0
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 10:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 068711C6B1;
	Mon, 13 Nov 2023 10:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hkn6qlcj"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922E21C28C
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 10:07:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A723F10C8
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699870025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NGtWFn3WY/6+Bm2hlCR5qe61nX9MiQpZ4JPVOs9ZJMI=;
	b=hkn6qlcjhqNsyBQfTLCAcTVFW1X8CsX7WnkK/mQSU9vA0fGOlXeeea9NAtT5y0xw3n4wXK
	y2QnjvgAXw1/Vb1SCEY2ZdrZL9K91HqwyxIWn1vB06ckHN2S8RI7Q2BhczRZ72Qvqf9zyf
	OmJ+FlXoTaGHQP2JATknw4NLXdpgIXk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-waI6fjOLN1KLmQwaPaaWgw-1; Mon, 13 Nov 2023 05:07:04 -0500
X-MC-Unique: waI6fjOLN1KLmQwaPaaWgw-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2c53ea92642so39485891fa.2
        for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:07:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699870023; x=1700474823;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NGtWFn3WY/6+Bm2hlCR5qe61nX9MiQpZ4JPVOs9ZJMI=;
        b=h6T6vc9FpI3imYXggKAxE2z+T1j3+WT1eK07lgP77CdXjs9G5NNkVGyuwyHEJvYnq0
         WPBLZ3N6N74iAVE3PeTLljEuKMOjnuHM+8jmMVLiqpAkoBLyqch1ffgfLCf3FztJGL6f
         izS7XOqtA57q90wTSHM+dPYSI4RU52AgxPBXFInrDYM0veGgMmWbkMQnJeAa2kMqT5NR
         zzr617q1MBMrC2o1PchHP02uWEVq0exT+WhHuVaG4uHE6hY4D9sKZkeI+mYM6D4d3j+O
         /YkXkCRrASXCVu8cmtyJnOagD+M6Z+Rs1DWqvrSpDfCrL4DUCKKLKnbTyfNNoIg5Xagf
         P1+A==
X-Gm-Message-State: AOJu0YzKYYEWpiMmQXaLQWOJODn8ZeCjdpJsJtjV/3b6q+SwE9VJkG5r
	rt5+jLrW8hVpeTM5cQ1JHBZa6Dgk/AlJTcAj9R1GUMOjCwo1KvfVhzVcOXjSQ5zbei/JfuxqQW9
	q/w5K0DvtrqY4
X-Received: by 2002:a05:6512:12cf:b0:509:4424:2e0e with SMTP id p15-20020a05651212cf00b0050944242e0emr5426792lfg.0.1699870022994;
        Mon, 13 Nov 2023 02:07:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGVQkyfRsuGOMOyI1XpBYg2WZPpBqGjPENYvJNvhkOYdvA7Ab2jsQgIQuAdrm/NfZ1lUinGMg==
X-Received: by 2002:a05:6512:12cf:b0:509:4424:2e0e with SMTP id p15-20020a05651212cf00b0050944242e0emr5426766lfg.0.1699870022651;
        Mon, 13 Nov 2023 02:07:02 -0800 (PST)
Received: from redhat.com ([2a06:c701:73f2:e100:f288:9238:4f0d:83ab])
        by smtp.gmail.com with ESMTPSA id h9-20020a05600c350900b004094d4292aesm7517024wmq.18.2023.11.13.02.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 02:07:01 -0800 (PST)
Date: Mon, 13 Nov 2023 05:06:58 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
	kevin.tian@intel.com, joao.m.martins@oracle.com,
	si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V3 vfio 0/9] Introduce a vfio driver over virtio devices
Message-ID: <20231113050633-mutt-send-email-mst@kernel.org>
References: <20231113080222.91795-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113080222.91795-1-yishaih@nvidia.com>

On Mon, Nov 13, 2023 at 10:02:13AM +0200, Yishai Hadas wrote:
> This series introduce a vfio driver over virtio devices to support the
> legacy interface functionality for VFs.

Because of LPC, pls allow a bit more time for review. Thanks!


