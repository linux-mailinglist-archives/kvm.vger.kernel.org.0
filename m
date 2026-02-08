Return-Path: <kvm+bounces-70558-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UOnOKarIiGk4wAQAu9opvQ
	(envelope-from <kvm+bounces-70558-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 18:32:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2755D109933
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 18:32:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0A71E300957B
	for <lists+kvm@lfdr.de>; Sun,  8 Feb 2026 17:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB882DC355;
	Sun,  8 Feb 2026 17:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cmZN8SyR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="n4KRl0/y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A774125B662
	for <kvm@vger.kernel.org>; Sun,  8 Feb 2026 17:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770571938; cv=none; b=qziW4NN8gaXy+zTaTcAlwpBMASXtJKiH0XmyXCtcJwOHFOVgAQgOcLbLslQOuC+2Tv4Bo7PaavsyXKnpEZdaR5TXzUCpEHXL19RKCClNyiqJo7F+sY4yN1fFG1fCJLNGxptnEtHCqUasvfzzwnN4sBOyoeBOWg3X+EK95gcAwmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770571938; c=relaxed/simple;
	bh=AEvdSTNs1SsDl6pEhRmUA1UXlMIvLZZpo5LQw/yYq7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FS8Gz16VTekl1LdFoYa+p0Sy74B4VwX9+Rm2XislpvRDWEDs2jN2svyKxySlWDCJkCI96KLZR/1e8q+aXirByAIls2qlhRjkP0vuHklbXqqvkQqtbnWkfi8oO8wuFqGC1W6kJQKfaWxMcOs6kBHzw3HsfzbhQRrZx1X106T8sEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cmZN8SyR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=n4KRl0/y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770571937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OenOUUyuTg99CmX32A/sK68Oz1m4ee6pqVCMdR0xc20=;
	b=cmZN8SyR6gJ4Cild6/2RkJUPEQoSSISkJBGL7x8I7v1g004VB0d5kC7iHfOlMqx2nJQwLz
	nQizlQPand8vJNp0e99+IjKWxLm7+EAza85NlvXauS5DgZ04gox96I+i/p8mKGYnWd8FBr
	mH1lCGJ2GTWGHdn0g2BLgkxHFKUsd4U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-iq3K0mtoPIKSNDzCj5V0bA-1; Sun, 08 Feb 2026 12:32:16 -0500
X-MC-Unique: iq3K0mtoPIKSNDzCj5V0bA-1
X-Mimecast-MFC-AGG-ID: iq3K0mtoPIKSNDzCj5V0bA_1770571935
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4803e8b6007so34785405e9.0
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 09:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770571935; x=1771176735; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OenOUUyuTg99CmX32A/sK68Oz1m4ee6pqVCMdR0xc20=;
        b=n4KRl0/yR3vxAlGqJ/0JCPZmgQhzOq9OmXqT4ioo9Jpr3Kt/9AdiJsT9mb2nnX6WkY
         awvwc+w/mVebp/GVJWwLbhcr3x5pykjPsNrgW+ejsRggXLn7GRIB+wahVrC5upZnBNqI
         TRfEUG0mrVG+YDd6L86ux1aTpp4yKCVdCmqopn3BuXPR6WJdtSMLUmoFuN1Y6dDdvcYN
         vF0AeA3fhVHELK5sPw2FxUn4uooBBMkN00dH1y8FPMFIbLMy/qHHfOCNVWuN2Q2xaz/H
         jmptcXKk/pQsKJSyBW9bkU84ljSHjHbIGuivjft88ozwuysn3r3gwQwc/rGaT9BwAjJg
         EUwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770571935; x=1771176735;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OenOUUyuTg99CmX32A/sK68Oz1m4ee6pqVCMdR0xc20=;
        b=kAup1BGJWKjAQqMGuurpBoT6C4E6UM9o1j8ZMx0HmVrMNW8R4im4Pxxp/8dY49tNYS
         PHKYRJx6g+yW3V+FExCsE7wcVt11tvwdAWOFIhjplqXDYVwTKzDL8X7Wl8E65Rvgg4EZ
         ARPevnSf2KBIAPVmSPtJa0MPwnYswy8U4JSCVFxAb60lv/krbL6YFvLDx4IU+FA4Cpk9
         SJ88ADvp+CsLd/5NhMSZbDprSmr/z/re6aje5EIW7v2qZlbJmHEq971cNoUrApaN8/3a
         WbjoE9hlK6CXs5eZ5HajshbKTPa2zSwNZsvEa1IPqZe0nJa3V18Xy1yn6y+dd/RfGYRS
         ziGA==
X-Forwarded-Encrypted: i=1; AJvYcCVWNXmr9XJLxxrZXjKQLRuNznMBaZzTY4vRDkvGbL7MzxdUSjiO+M7MGI77A7ybiuq4WVg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFQdBfBYF4od2HcLydJPKJv4DbXTlUKMO/TVyo8ZDFq2BlTfyu
	WqcoqncEBvTqDwAD6rPbPm6x/6dCh2zTZO0ffnkgL0o/h+kPyvqncMQOyRK8dlj0xFVI+fN1NdD
	/CatryqzXKqW7vNQb5BPs2Pls9RMJpIR12gM0nNGA0dEKKEaW5e62ECYa11Ulgw==
X-Gm-Gg: AZuq6aJAKrooeMB9oxMfNPOxg+oMceOVrTF5x99DYYqYujSXrBhIuYxq4ZRJUEaKf+Z
	HsUgoxfseNEmkSGnbCvDT/evWgCE1lcqYkX/iTDlTHeUornSqBHUxEvk+Ue95FSNFBXeBcJGxju
	7aj9VGAZNfWF1LSWcepOLxex+c4TIeGYSHXkZfOnRhMpy4G2ZICv9sNat0Syg8klWmh0znqnrMq
	/q75ThhSDjW+F6F42UAIUKVXnx1tmuVhKUdGSu/hhu2oU6cBVilk6bgYPbe39UPoxIBi+BnrUmJ
	QG9OR2KbwUJVsHhmYzAOBhcjomvICp8OFQaRU4nuKSNYryEjUhAADJVoW7Ang30DItz0QEjMtbR
	jjN3GdO7v2Wo6S+sfuzHXNkKKodJt/zXUHQ==
X-Received: by 2002:a05:600c:5253:b0:480:1e9e:f9b with SMTP id 5b1f17b1804b1-483201eead3mr146871515e9.16.1770571935095;
        Sun, 08 Feb 2026 09:32:15 -0800 (PST)
X-Received: by 2002:a05:600c:5253:b0:480:1e9e:f9b with SMTP id 5b1f17b1804b1-483201eead3mr146871275e9.16.1770571934705;
        Sun, 08 Feb 2026 09:32:14 -0800 (PST)
Received: from redhat.com (IGLD-80-230-34-155.inter.net.il. [80.230.34.155])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48317d345c2sm391883135e9.6.2026.02.08.09.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 09:32:14 -0800 (PST)
Date: Sun, 8 Feb 2026 12:32:11 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cindy Lu <lulu@redhat.com>
Cc: jasowang@redhat.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/3] uapi: vhost: add vhost-net netfilter offload API
Message-ID: <20260208123029-mutt-send-email-mst@kernel.org>
References: <20260208143441.2177372-1-lulu@redhat.com>
 <20260208143441.2177372-2-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260208143441.2177372-2-lulu@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70558-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.996];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 2755D109933
X-Rspamd-Action: no action

On Sun, Feb 08, 2026 at 10:32:22PM +0800, Cindy Lu wrote:
> Add VHOST_NET_SET_FILTER ioctl and the filter socket protocol used for
> vhost-net filter offload.
> 
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  include/uapi/linux/vhost.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index c57674a6aa0d..d9a0ca7a3df0 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -131,6 +131,26 @@
>   * device.  This can be used to stop the ring (e.g. for migration). */
>  #define VHOST_NET_SET_BACKEND _IOW(VHOST_VIRTIO, 0x30, struct vhost_vring_file)
>  
> +/* VHOST_NET filter offload (kernel vhost-net dataplane through QEMU netfilter) */
> +struct vhost_net_filter {
> +	__s32 fd;
> +};
> +
> +enum {
> +	VHOST_NET_FILTER_MSG_REQUEST = 1,
> +};
> +
> +#define VHOST_NET_FILTER_DIRECTION_TX 1
> +
> +struct vhost_net_filter_msg {
> +	__u16 type;
> +	__u16 direction;
> +	__u32 len;
> +};
> +
> +
> +#define VHOST_NET_SET_FILTER _IOW(VHOST_VIRTIO, 0x31, struct vhost_net_filter)
> +
>  /* VHOST_SCSI specific defines */

can we get some info on what this is supposed to be doing, pls?
it belongs here where userspace devs can find it, not hidden
in code.


>  
>  #define VHOST_SCSI_SET_ENDPOINT _IOW(VHOST_VIRTIO, 0x40, struct vhost_scsi_target)
> -- 
> 2.52.0


