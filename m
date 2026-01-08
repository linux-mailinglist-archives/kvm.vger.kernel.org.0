Return-Path: <kvm+bounces-67349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B644FD00FA6
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 05:39:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 832B1301D9F3
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 04:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E6A2298CB7;
	Thu,  8 Jan 2026 04:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GG7/ztLi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nG2XQrLl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8226827B4E8
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 04:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767847131; cv=none; b=uXKkjBIKtVbjJvPyepU0JxhyLxEc3F9jauYwoLx5PtY5ZjGa7UjWmivLMxQMRMMy7+PjDVoWAuQjq/6fQ48U1Q9t5VpDdj1sJHGntWJY7GiNj+/B807yIqtZ3vcCH58jgxiBnBYSLR1WMDEBKg1FeFoZlPmqO9yPBvF2J/3fBow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767847131; c=relaxed/simple;
	bh=1Mw4+/RnBE3HC1Gi2CHwhB4Ll3ThRjwOgtBMJvxn2cE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CdEnQBPmcvD0Nrh+Iy+7QXVVNHuQV3Nh0d/LNSKMeRdiNnA3yj9dm6ibpEzphjNtoKVN6Aah2c3LaGOftSZZVRqngC4q+MzNRWYTqoNgBIzUYa4zsczZLAdaDMNIcooWJnQCr2YsX0n7dfWCbgr2/cu/qdO9Hv9vbdBt9MFVxkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GG7/ztLi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nG2XQrLl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767847128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ITK/RdRB2R5i8Otgr7paxSBzAk4X73xXTbyRHE7SKp4=;
	b=GG7/ztLi5ftZNh8vtEnStI3pSrtSbPJ1btNCJHg3mnVRyLzdBz5Gf6Y3wlEbOrr/JDcSga
	TGA0cYwt7odG85rldIHPtWRbbhbhtmT7N3GfErJOxyF9y9tZjaxAEy+HIynr0hrnt8GOB7
	rq4SkGG3uYqvNO1hXu1C0HVqNEmwxpg=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-xOONvviCNUaiYi7VWW7reQ-1; Wed, 07 Jan 2026 23:38:47 -0500
X-MC-Unique: xOONvviCNUaiYi7VWW7reQ-1
X-Mimecast-MFC-AGG-ID: xOONvviCNUaiYi7VWW7reQ_1767847126
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-34ab459c051so6515310a91.0
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 20:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767847126; x=1768451926; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ITK/RdRB2R5i8Otgr7paxSBzAk4X73xXTbyRHE7SKp4=;
        b=nG2XQrLlbnNvnowuc2AJ9dIbbao5IkNAebpJRgdV6bsrH3vB47LwGOpKKtW4a50cDj
         mIeXKolHhq3k5D+QZ1UwarGlQUd+Ar6pKUcbNblZFSuCHxXvpr4+jhT29rUzHvmXZwIh
         kb0gJEM6t2xlT7FpLLJhB+Y0Sq/ey1SvnyKq2fnlHwnWOhUQuU94pzsEIy70MvjPAanb
         gl0TUt/PEe4fFLfjTE4gT6N2wjBzyPykM8id/4Dw8r3bO272iktm/ZiabUVK8I8Y2q+f
         jI+lRcKA66G6SqLNMck1msqrzVA7Yb6v8/oBbGeVjYgA5Oupu9WcHRmxZMhrS1N7dqjb
         xBBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767847126; x=1768451926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ITK/RdRB2R5i8Otgr7paxSBzAk4X73xXTbyRHE7SKp4=;
        b=V1JFXoRWMGlId085ySuJIjWMTToVMXhCnWI7FU1G0WDBMv9SLrIIxv7QwQLaxUNTVr
         gP1AI9a1SlBme11TMJ4mY13LtYAqZr0tZ1zHOdbQvBXMK+Aj5Tr4oj8avziznshuPUHL
         JxGRK0oWa94dQJ76p0rnQTJ6ZtyYDNzyKeKDT5skcnrkv9eJZh9ttH9SuF3C7bQ8Uv2n
         AMfuk/syb51eqIWEMEcpDXHCv2LWNSBVeyyIEN6fFoDNI9DkTi8yioSumMG0+VlKz5oz
         tI1QBYYEFDnhlEYMixrBdElgDE5aVzK98DLACO+9w8hkSa4rNJ4jB2VsADv06IlqiotN
         lTvA==
X-Forwarded-Encrypted: i=1; AJvYcCUHC5bJgLVuNN5t7Uu9I2U1YOtvpF2soCqoFNOD/fToow+W0bF6uWf4GptnugmILRgncqM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyM7q55nBCFBAzu0LY1pZ9jOv/zp4VPsF1XiY6qBHju6AVeG3GF
	M+fbQOf/lfZ5cS8SURas9jsPSyJpfQpOybXEQ7y76cBUfdKbcJAFA7GfcnuRKSmYZkREOmIamoq
	sNXlreMzkLCz4fVRNIAny1EzxFrkpr825vfSgO1RrQW8Gb1auGUbxDDtXS/HQVb54RVUZ40lyFM
	u6dnxGFOVZkEYKtjDgcMpXVxPLegjL
X-Gm-Gg: AY/fxX6ym1H+ehiOtzJtmRzmoiG0Z2wr81lzyHQ5qmhYOKhf1A1qujl7baqMjqZ03jo
	RTgQb82zs+hfYNNbi/U/SPkM85xmOhMdD0ZJZLQxFoorPN8E8VycOoWmyXn+0INmOJjJLnJKqcK
	v73Gpt/S6g86Ej3qZhZvubaptpQ5/wWGZ5uL/3rnYxl0Jf7/uIe98mf3FsX1l0o+U=
X-Received: by 2002:a17:90b:38cd:b0:340:ad5e:cb with SMTP id 98e67ed59e1d1-34f68b8325amr4472094a91.8.1767847126199;
        Wed, 07 Jan 2026 20:38:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5VQZiGe7r1S4uFGT8iu+UqDGLcVAm47K+xxuFBZErtPwJUSS5ANbzbriNBgtK4Or956wAzsqxr3sqB3YdRdc=
X-Received: by 2002:a17:90b:38cd:b0:340:ad5e:cb with SMTP id
 98e67ed59e1d1-34f68b8325amr4472074a91.8.1767847125793; Wed, 07 Jan 2026
 20:38:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de> <20260107210448.37851-8-simon.schippers@tu-dortmund.de>
In-Reply-To: <20260107210448.37851-8-simon.schippers@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 8 Jan 2026 12:38:34 +0800
X-Gm-Features: AQt7F2ojlTg8w4ZELX6uaVy4snIzQbNmqFa41GC72EmW5kfc8xJcEouDgWh6mwE
Message-ID: <CACGkMEtndGm+GX+3Kn5AWTkEc+PK0Fo1=VSZzhgBQoYRQbicQw@mail.gmail.com>
Subject: Re: [PATCH net-next v7 7/9] vhost-net: vhost-net: replace rx_ring
 with tun/tap ring wrappers
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	mst@redhat.com, eperezma@redhat.com, leiyang@redhat.com, 
	stephen@networkplumber.org, jon@nutanix.com, tim.gebauer@tu-dortmund.de, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> Replace the direct use of ptr_ring in the vhost-net virtqueue with
> tun/tap ring wrapper helpers. Instead of storing an rx_ring pointer,
> the virtqueue now stores the interface type (IF_TUN, IF_TAP, or IF_NONE)
> and dispatches to the corresponding tun/tap helpers for ring
> produce, consume, and unconsume operations.
>
> Routing ring operations through the tun/tap helpers enables netdev
> queue wakeups, which are required for upcoming netdev queue flow
> control support shared by tun/tap and vhost-net.
>
> No functional change is intended beyond switching to the wrapper
> helpers.
>
> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Co-developed by: Jon Kohler <jon@nutanix.com>
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> ---
>  drivers/vhost/net.c | 92 +++++++++++++++++++++++++++++----------------
>  1 file changed, 60 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 7f886d3dba7d..215556f7cd40 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -90,6 +90,12 @@ enum {
>         VHOST_NET_VQ_MAX =3D 2,
>  };
>
> +enum if_type {
> +       IF_NONE =3D 0,
> +       IF_TUN =3D 1,
> +       IF_TAP =3D 2,
> +};

This looks not elegant, can we simply export objects we want to use to
vhost like get_tap_socket()?

Thanks


