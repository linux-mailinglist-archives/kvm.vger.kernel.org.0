Return-Path: <kvm+bounces-71104-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2BhDCHiikWnnkwEAu9opvQ
	(envelope-from <kvm+bounces-71104-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 11:39:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7386413E7FA
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 11:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5B8A23022977
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 10:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 371B22C21C1;
	Sun, 15 Feb 2026 10:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GKTkpIA5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IcH2trGG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDF82C15B8
	for <kvm@vger.kernel.org>; Sun, 15 Feb 2026 10:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771151947; cv=none; b=mBtY4Q0PtXLXzCRnt4PLuep0XbUTRny24qX8V97DE1Fm915Oyl5E+O4cmXd9ty9bIDhaBESyO8teZc6oUf8skkL7/cyE31oOScE6Yb4xTPi6xhGnA5WXoq1cgpZdkXeeZO5CvpH6MvQKoWq9Wt9D5bTEAQPbMB7IfZHS7r+Ftd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771151947; c=relaxed/simple;
	bh=s0Gz1lbX6oWHaXjniFNDuQXFzRewjGHyGyA3SEPcAvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hp3VTjpSRXCXRNBF+NnM7Zvo5r6onkcSAw2Ro3t9YxHb8pOgg0xl33t1IGY3ELaH3OJ1/IHqpnw7GjPqoG0NW9imZPi8/4B6OOOiEKXzXXNMPN1KcbUGODYoF+r0b2cp6dUVKeH4Vt/ljD5OlTwtVB6iDDOyYG92bI2nKnz0FVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GKTkpIA5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IcH2trGG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771151945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OaK+6zMcYsiCWtoK8iSxqAKGi6QUUb+Bn/H6Es8PiBw=;
	b=GKTkpIA5/z6xj18u6jgKBnhytK2TiBZFWh5w/qsBpcn7wqXVSoZxID5sYYn2gMwKoRNu3c
	eSKbkuq4lWLDtDgV9mUFDUoaKJAn/Q8867aA8hxIBSUJ+c6ZlGUm+bZ7IB96upMNTPDSdx
	60oV1RlI+O6Uix9XdPZlRw4CRdR5yCw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-rCZ-4DgENtCi3k8pxw_jdg-1; Sun, 15 Feb 2026 05:39:01 -0500
X-MC-Unique: rCZ-4DgENtCi3k8pxw_jdg-1
X-Mimecast-MFC-AGG-ID: rCZ-4DgENtCi3k8pxw_jdg_1771151940
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4376e25bb4dso2762313f8f.0
        for <kvm@vger.kernel.org>; Sun, 15 Feb 2026 02:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771151940; x=1771756740; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OaK+6zMcYsiCWtoK8iSxqAKGi6QUUb+Bn/H6Es8PiBw=;
        b=IcH2trGGVaOayp9/6bklHqS5tNfKvUpNMZjjbYTFwXtRaLHOeY3ouk+taFEJvV9Vie
         wauenIrpUFF4UD2eL5dmZ579ZUs/39oRhvWV2olcq6pmHV0hwGRCTAPfHE4aSsqzR2Ug
         tXFTTi3X+ri4k6dUIDGh3YU0LFFd1bsZ5PQSIIVNZMKd7W6ybjTHdNYiawZZt7slHTma
         QIZpvB5umd6qRLoJe6vyAWHg0Biaet5wNyPy9h24KsnoT/a840xvxTSeQriVOAKlFCI0
         s4DdpN70QHeE24wOzjt2LFtbZpYiU3/68JWmeCg6fVpBTgA5JeI1vMYYiwYJPYXTZbSJ
         Mbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771151940; x=1771756740;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OaK+6zMcYsiCWtoK8iSxqAKGi6QUUb+Bn/H6Es8PiBw=;
        b=rCjHrpuNTrrBIXtT6l7TSyMb2Me+DB31n1TMkMcSAlLOnZ6LKq1wlyrsYqmoJmkute
         XBuHDsCK6fBizrvAOT3hAG60YbRoXTbVju/zV6uSKINPrgt7ZhdZDUD2gJTAqUwRTl6m
         1XA1ipJgJtnHBYaXcEWJvVRNc8jwdfnwmsRHiS+P8vAJvS/5VBfwNRFAToVRcDm9vEG2
         KdJirysQomJxKr6Qoyn4rsZFFfzOHHY+GDRp8rZ4HlEvGXUkGjDsGDd411JqwN6aCtzX
         95P9+nA+3T/aFF+T1fpPw/DbG5w7ZVYzxcVJtH1vJC57LWBnwvPI6jMTKpkJ6lXkvt/e
         BWIw==
X-Forwarded-Encrypted: i=1; AJvYcCWmjBvmET1bQX+bVp3pw8+C/lyLbZ6dO33N+JpKb0M3BevWdHItTaIlM6YBr4EwJ3X4otA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyURa9nbgUQ6/fmUxm2hlPjPNAyLb+EaBTkGW8FjW131fHUPYjQ
	T7fITVC0DCktPNmcu8QUtBMX/Iy66FAbFiv0UR6ThvCsAAsE/+iaxKf29pUT09+Bfx6jvZLHgw6
	UzRMX4CKjvgMmLIRevH+W9juMY5fPXb2e1Sa0ldhbNAbKRdZUyDfaww==
X-Gm-Gg: AZuq6aI7jkTT1gduTYUF/ucaxptN5juN9wg+IDok3dz56jUc1MOTtJlvyrFDClUdPkS
	Vt2YvZmTXXicueHUEAh+rzCA99f20lfMconLQMdBhXoR3V9IP18tL5DGPRb1MNQW7UGSSphmysQ
	a8PA94A6r9PEs66Ubwqx4NYuEQqpYw5pYzjiwkJ4VbfDCEgeiKbjKVIT1qRhGJ6JyWkNWkLmqkD
	bg6MqIyjlLa09XOjFX+oe+CBpso8GD3Xbr7tpU0UukaXRkrhawsYi4KNaKUiRTOgLvPN7lI/QXI
	z5hQdhcp402oV7U/BaARtpKELz3SLvIhMbviZ8vIGxc6fsO8K80BuURpi6JR8bjKFDwSQP7EZz9
	A85cbvZUr3w1fwxIlQINSmn+dlyvlp9gaAZ6gQ846a8eKgA==
X-Received: by 2002:a05:6000:26cd:b0:435:a815:dd8d with SMTP id ffacd0b85a97d-43796b04f57mr14262762f8f.55.1771151940329;
        Sun, 15 Feb 2026 02:39:00 -0800 (PST)
X-Received: by 2002:a05:6000:26cd:b0:435:a815:dd8d with SMTP id ffacd0b85a97d-43796b04f57mr14262729f8f.55.1771151939812;
        Sun, 15 Feb 2026 02:38:59 -0800 (PST)
Received: from redhat.com (IGLD-80-230-34-155.inter.net.il. [80.230.34.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796ad112bsm19183634f8f.36.2026.02.15.02.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 02:38:59 -0800 (PST)
Date: Sun, 15 Feb 2026 05:38:55 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: Jason Wang <jasowang@redhat.com>, willemdebruijn.kernel@gmail.com,
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
	leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
	tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next v7 3/9] tun/tap: add ptr_ring consume helper
 with netdev queue wakeup
Message-ID: <20260215053411-mutt-send-email-mst@kernel.org>
References: <CACGkMEsJtE3RehWQ8BaDL2HdFPK=iW+ZaEAN1TekAMWwor5tjQ@mail.gmail.com>
 <197573a1-df52-4928-adb9-55a7a4f78839@tu-dortmund.de>
 <CACGkMEveEXky_rTrvRrfi7qix12GG91GfyqnwB6Tu-dnjqAm9A@mail.gmail.com>
 <0c776172-2f02-47fc-babf-2871adca42cb@tu-dortmund.de>
 <CACGkMEte=LwvkxPh-tesJHLVYQV1YZF4is1Yamokhkzaf5GOWw@mail.gmail.com>
 <205aa139-975d-4092-aa04-a2c570ae43a6@tu-dortmund.de>
 <CACGkMEtRikexX=cJz8zmuvW7mcO7uCFdG7AoHQLOezrsb5nbgQ@mail.gmail.com>
 <59529fd2-2a08-4a89-a853-27198b76f842@tu-dortmund.de>
 <20260214131703-mutt-send-email-mst@kernel.org>
 <1ab166aa-8e9c-4742-a80a-c2fa806218db@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ab166aa-8e9c-4742-a80a-c2fa806218db@tu-dortmund.de>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71104-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,lunn.ch,davemloft.net,google.com,kernel.org,networkplumber.org,nutanix.com,tu-dortmund.de,vger.kernel.org,lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_RCPT(0.00)[kvm,netdev];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7386413E7FA
X-Rspamd-Action: no action

On Sat, Feb 14, 2026 at 08:51:53PM +0100, Simon Schippers wrote:
> On 2/14/26 19:18, Michael S. Tsirkin wrote:
> > On Sat, Feb 14, 2026 at 06:13:14PM +0100, Simon Schippers wrote:
> > 
> > ...
> > 
> >> Patched: Waking on __ptr_ring_produce_created_space() is too early. The
> >>          stop/wake cycle occurs too frequently which slows down
> >>          performance as can be seen for TAP.
> >>
> >> Wake on empty variant: Waking on __ptr_ring_empty() is (slightly) too
> >>                        late. The consumer starves because the producer
> >>                        first has to produce packets again. This slows
> >>                        down performance aswell as can be seen for TAP
> >> 		       and TAP+vhost-net (both down ~30-40Kpps).
> >>
> >> I think something inbetween should be used.
> >> The wake should be done as late as possible to have as few
> >> NET_TX_SOFTIRQs as possible but early enough that there are still
> >> consumable packets remaining to not starve the consumer.
> >>
> >> However, I can not think of a proper way to implement this right now.
> >>
> >> Thanks!
> > 
> > What is the difficulty?
> 
> There is no way to tell how many entries are currently in the ring.
> 
> > 
> > Your patches check __ptr_ring_consume_created_space(..., 1).
> 
> Yes, and this returns if either 0 space or a batch size space was
> created.
> (In the current implementation it would be false or true, but as
> discussed earlier this can be changed.)
> 
> > 
> > How about __ptr_ring_consume_created_space(..., 8) then? 16?
> > 
> 
> This would return how much space the last 8/16 consume operations
> created. But in tap_ring_consume() we only consume a single entry.
> 
> Maybe we could avoid __ptr_ring_consume_created_space with this:
> 1. Wait for the queue to stop with netif_tx_queue_stopped()
> 2. Then count the numbers of consumes we did after the queue stopped
> 3. Wake the queue if count >= threshold with threshold >= ring->batch
> 
> I would say that such a threshold could be something like ring->size/2.


To add to what i wrote, size/2 means:
leave half a ring for consumer, half a ring for producer.

If one of the two is more bursty, we might want a different
balance. Offhand, the kernel is less bursty and userspace is
more bursty.

So it's an interesting question but size/2 is a good start.


