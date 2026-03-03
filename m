Return-Path: <kvm+bounces-72601-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ADXgMKpKp2n2gQAAu9opvQ
	(envelope-from <kvm+bounces-72601-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 21:55:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ED0B1F7029
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 21:55:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 71F7431542D8
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 20:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF01388386;
	Tue,  3 Mar 2026 20:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GYXRbiox";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jUFl4vdF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BE0379ED4
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 20:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772571190; cv=none; b=OR1ismwNgWYkj7UiUpZyOPE1P6nGciiKuCckZcBUAhPY6UT79At0e2B9+3HTOeIH56cf3+fPvg+7ntGgNO4QGv1DJzQetw1mYDFil0tmwpiX99CWltKCWGBzypJnjUAsDqzQxyv2t//799p4N8TnV8GqDa93WR9I2NdkSm2LQVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772571190; c=relaxed/simple;
	bh=I5gpiqsO+dAgH/nEJUqEofkhf7ZFzhfOnIeWvdgbAYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IezKi/mrgr/PuhzJcv5zdLuosureFZxKrIFIagpEhunl6DDdLbxsTUYg//Mm9Jgp8iMd5Fkp7l5+hi/Cw3INXRws5W7l1mVihmreN/1VjvskfE6L8FMiazfwQfHmnNNQqTBtPBSGfCe22KIyH5lVNKQ7sycoTEgdkreiUhADoys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GYXRbiox; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jUFl4vdF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772571187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VoJ2INzWG7kGdihTQvUQGIPL9oTDsZ5C8rJbFDor7iI=;
	b=GYXRbiox6gfAFSVV46CVVYZAKr9n/6VU7hqRYfO76d8Ef/mJ/O63jv7KeR5sv/xx6HpDs6
	oq9oddfBNW0YBLzoHnPDbuCfitzVCtkpKKQZEdqSmpEGOqvC+WN5Sq4EXdAGorSFS3E+2M
	fZ3rLFf9vfdITsibwqczgtCxghpoOn0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-gIU9pr9XNh6cVfOtPyHDQg-1; Tue, 03 Mar 2026 15:53:04 -0500
X-MC-Unique: gIU9pr9XNh6cVfOtPyHDQg-1
X-Mimecast-MFC-AGG-ID: gIU9pr9XNh6cVfOtPyHDQg_1772571183
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4837b7903f3so74353675e9.2
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 12:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772571183; x=1773175983; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VoJ2INzWG7kGdihTQvUQGIPL9oTDsZ5C8rJbFDor7iI=;
        b=jUFl4vdFmPneL1yOF7SRlvDZdmbwOGMPVmTFs5ij1O9kUrRqClHSsdno8CcnP2yVT7
         zxhibugFFpIATrwZ7K1eIDOiPmGaP1+kyKErixiqeGNVhf+Ast1PBhIvQ4RGNek1rsmp
         k3dfj6BZUVvJqmyUlo9Xx2PvU5v4m9azr5xSD81t+QzNPnULrikA1I+wj6qKaXbUR6v4
         NJqD/gG8ZIvSZObs05cdd9L5f3IBrOoGbFwcCUzYfuAthYEtK53lNTV7Siwnq3AkWqQp
         cn7LbWXBzun5VxzI0ATMX4XIVOQ+d1XI6JEYurTGVL0TlVkTDtjtPINVMmF4ztJ9DagX
         A+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772571183; x=1773175983;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VoJ2INzWG7kGdihTQvUQGIPL9oTDsZ5C8rJbFDor7iI=;
        b=ZE6xIG4N8/dn8vHjq11fDXCfZkq6oZCWnTcyQ2VNMG35HxJDOvTtc/Qe7KI82mgfYC
         gL3JWXzUGOpZE2C4iR/S3PWaBJ+JNORarMnB3EPjITy//4AtlWI540ZpEPF/HGlTvFK1
         oEbqYsZ7LbxX+I7Y1MLkSTcvjstijOHZiwmjvI7K7ECf9nLPARBgFvBofzlUQCY2OU64
         6zRQIQJTGap91v8gfEwU1rVWZ6VM3BMKiqlZOcpbWs6PTy07k2CnFg5UshvnZpXOjq2A
         zs4QxfKoZx/jmIKyEP8KfEMeQO4F8fQzf/5H4YVcO0378jF4Bn89y6vBcQ10DAtS0RYm
         2BhA==
X-Forwarded-Encrypted: i=1; AJvYcCXKXmAqsvL3xNtgyEZSUs2rX4hZyStdIIgNl+ZFNnKUlj+6s/LOpwht/HpH89KqEOW2dfg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGMgOKFQ+6A21bhxEUEn1kNwUeFaNSMExPM3vWOM9GtecOBsr9
	NwST+UnaJndUv6c6qQn+sFvx4A+ATO2UfWubGHLOTBsfp0vSyhuTR7r3ZzG4JdGro77/A/V0kH4
	NiqeFa6BWtI3jV3wHngkN0lkgkzSlw1jS7Da/lqczoaozrCepB6QWrQ==
X-Gm-Gg: ATEYQzxFFJJ8a7hCK4dt3+dSS7I+7/8Zf0j31oYqaiIcyLdwgOu8+k2sPPJ5ol8Wh7R
	W3Wg7blrV6oNZD8n4n7NFFOPRiEcLKj1ngxDzEkdpB3KTuW+cQSoDpb1lj7w50em7UMb1wCzADi
	iYTlnRefLO0LeyMcKU7q+duq6sKPiDiyK86i8XKO+SexctfIiB+vHPqRcWmhvREYSpReq5AaDVo
	d1me3FIdIlv1KKQXcMZYBDg2df4ib1wpgPFKbnj7lhBjHQLoFB2NDqwl7ny5BCBZhw3C3H8gJW0
	ysEFlbWq2dhrieerEmfGhcZKvSR1BDoUO28lNJ3ZbJwLLBEA1Gl6cNFnP3duh77tmEnsdqIEGmY
	MV5us11IuQREljXLZjRNRe1PX1kaAGPKWcYYFHlWH/D1SKg==
X-Received: by 2002:a05:600c:4f8b:b0:483:498f:7953 with SMTP id 5b1f17b1804b1-483c9c21525mr326042815e9.28.1772571182892;
        Tue, 03 Mar 2026 12:53:02 -0800 (PST)
X-Received: by 2002:a05:600c:4f8b:b0:483:498f:7953 with SMTP id 5b1f17b1804b1-483c9c21525mr326042375e9.28.1772571182293;
        Tue, 03 Mar 2026 12:53:02 -0800 (PST)
Received: from redhat.com (IGLD-80-230-79-166.inter.net.il. [80.230.79.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485188a20c4sm2138835e9.15.2026.03.03.12.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 12:53:01 -0800 (PST)
Date: Tue, 3 Mar 2026 15:52:58 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alexander Graf <graf@amazon.com>
Cc: Bryan Tan <bryan-bt.tan@broadcom.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, kvm@vger.kernel.org, eperezma@redhat.com,
	Jason Wang <jasowang@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, nh-open-source@amazon.com
Subject: Re: [PATCH] vsock: Enable H2G override
Message-ID: <20260303155040-mutt-send-email-mst@kernel.org>
References: <20260302104138.77555-1-graf@amazon.com>
 <aaVrsXMmULivV4Se@sgarzare-redhat>
 <aaV80wWlpjEtYCQJ@sgarzare-redhat>
 <17d63837-6028-475a-90df-6966329a0fc2@amazon.com>
 <aaW2FgoaXIJEymyR@sgarzare-redhat>
 <27dcad4e-d658-4b6b-93b2-44c64fcbeb11@amazon.com>
 <aaaqLbRNmoRHNTkh@sgarzare-redhat>
 <CAOuBmuaQwxKDJoirwtRwEP=690JcRX3Efk6z=udiOHsGr8u6ag@mail.gmail.com>
 <cc4093e8-31c8-4a14-80f9-034852cf54f7@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc4093e8-31c8-4a14-80f9-034852cf54f7@amazon.com>
X-Rspamd-Queue-Id: 2ED0B1F7029
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72601-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 09:47:26PM +0100, Alexander Graf wrote:
> 
> On 03.03.26 15:17, Bryan Tan wrote:
> > On Tue, Mar 3, 2026 at 9:49 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > > On Mon, Mar 02, 2026 at 08:04:22PM +0100, Alexander Graf wrote:
> > > > On 02.03.26 17:25, Stefano Garzarella wrote:
> > > > > On Mon, Mar 02, 2026 at 04:48:33PM +0100, Alexander Graf wrote:
> > > > > > On 02.03.26 13:06, Stefano Garzarella wrote:
> > > > > > > CCing Bryan, Vishnu, and Broadcom list.
> > > > > > > 
> > > > > > > On Mon, Mar 02, 2026 at 12:47:05PM +0100, Stefano Garzarella wrote:
> > > > > > > > Please target net-next tree for this new feature.
> > > > > > > > 
> > > > > > > > On Mon, Mar 02, 2026 at 10:41:38AM +0000, Alexander Graf wrote:
> > > > > > > > > Vsock maintains a single CID number space which can be used to
> > > > > > > > > communicate to the host (G2H) or to a child-VM (H2G). The
> > > > > > > > > current logic
> > > > > > > > > trivially assumes that G2H is only relevant for CID <= 2
> > > > > > > > > because these
> > > > > > > > > target the hypervisor.  However, in environments like Nitro
> > > > > > > > > Enclaves, an
> > > > > > > > > instance that hosts vhost_vsock powered VMs may still want
> > > > > > > > > to communicate
> > > > > > > > > to Enclaves that are reachable at higher CIDs through
> > > > > > > > > virtio-vsock-pci.
> > > > > > > > > 
> > > > > > > > > That means that for CID > 2, we really want an overlay. By
> > > > > > > > > default, all
> > > > > > > > > CIDs are owned by the hypervisor. But if vhost registers a
> > > > > > > > > CID, it takes
> > > > > > > > > precedence.  Implement that logic. Vhost already knows which CIDs it
> > > > > > > > > supports anyway.
> > > > > > > > > 
> > > > > > > > > With this logic, I can run a Nitro Enclave as well as a
> > > > > > > > > nested VM with
> > > > > > > > > vhost-vsock support in parallel, with the parent instance able to
> > > > > > > > > communicate to both simultaneously.
> > > > > > > > I honestly don't understand why VMADDR_FLAG_TO_HOST (added
> > > > > > > > specifically for Nitro IIRC) isn't enough for this scenario
> > > > > > > > and we have to add this change.  Can you elaborate a bit more
> > > > > > > > about the relationship between this change and
> > > > > > > > VMADDR_FLAG_TO_HOST we added?
> > > > > > 
> > > > > > The main problem I have with VMADDR_FLAG_TO_HOST for connect() is
> > > > > > that it punts the complexity to the user. Instead of a single CID
> > > > > > address space, you now effectively create 2 spaces: One for
> > > > > > TO_HOST (needs a flag) and one for TO_GUEST (no flag). But every
> > > > > > user space tool needs to learn about this flag. That may work for
> > > > > > super special-case applications. But propagating that all the way
> > > > > > into socat, iperf, etc etc? It's just creating friction.
> > > > > Okay, I would like to have this (or part of it) in the commit
> > > > > message to better explain why we want this change.
> > > > > 
> > > > > > IMHO the most natural experience is to have a single CID space,
> > > > > > potentially manually segmented by launching VMs of one kind within
> > > > > > a certain range.
> > > > > I see, but at this point, should the kernel set VMADDR_FLAG_TO_HOST
> > > > > in the remote address if that path is taken "automagically" ?
> > > > > 
> > > > > So in that way the user space can have a way to understand if it's
> > > > > talking with a nested guest or a sibling guest.
> > > > > 
> > > > > 
> > > > > That said, I'm concerned about the scenario where an application
> > > > > does not even consider communicating with a sibling VM.
> > > > 
> > > > If that's really a realistic concern, then we should add a
> > > > VMADDR_FLAG_TO_GUEST that the application can set. Default behavior of
> > > > an application that provides no flags is "route to whatever you can
> > > > find": If vhost is loaded, it routes to vhost. If a vsock backend
> > > mmm, we have always documented this simple behavior:
> > > - CID = 2 talks to the host
> > > - CID >= 3 talks to the guest
> > > 
> > > Now we are changing this by adding fallback. I don't think we should
> > > change the default behavior, but rather provide new ways to enable this
> > > new behavior.
> > > 
> > > I find it strange that an application running on Linux 7.0 has a default
> > > behavior where using CID=42 always talks to a nested VM, but starting
> > > with Linux 7.1, it also starts talking to a sibling VM.
> > > 
> > > > driver is loaded, it routes there. But the application has no say in
> > > > where it goes: It's purely a system configuration thing.
> > > This is true for complex things like IP, but for VSOCK we have always
> > > wanted to keep the default behavior very simple (as written above).
> > > Everything else must be explicitly enabled IMHO.
> > > 
> > > > 
> > > > > Until now, it knew that by not setting that flag, it could only talk
> > > > > to nested VMs, so if there was no VM with that CID, the connection
> > > > > simply failed. Whereas from this patch onwards, if the device in the
> > > > > host supports sibling VMs and there is a VM with that CID, the
> > > > > application finds itself talking to a sibling VM instead of a nested
> > > > > one, without having any idea.
> > > > 
> > > > I'd say an application that attempts to talk to a CID that it does now
> > > > know whether it's vhost routed or not is running into "undefined"
> > > > territory. If you rmmod the vhost driver, it would also talk to the
> > > > hypervisor provided vsock.
> > > Oh, I missed that. And I also fixed that behaviour with commit
> > > 65b422d9b61b ("vsock: forward all packets to the host when no H2G is
> > > registered") after I implemented the multi-transport support.
> > > 
> > > mmm, this could change my position ;-) (although, to be honest, I don't
> > > understand why it was like that in the first place, but that's how it is
> > > now).
> > > 
> > > Please document also this in the new commit message, is a good point.
> > > Although when H2G is loaded, we behave differently. However, it is true
> > > that sysctl helps us standardize this behavior.
> > > 
> > > I don't know whether to see it as a regression or not.
> > > 
> > > > 
> > > > > Should we make this feature opt-in in some way, such as sockopt or
> > > > > sysctl? (I understand that there is the previous problem, but
> > > > > honestly, it seems like a significant change to the behavior of
> > > > > AF_VSOCK).
> > > > 
> > > > We can create a sysctl to enable behavior with default=on. But I'm
> > > > against making the cumbersome does-not-work-out-of-the-box experience
> > > > the default. Will include it in v2.
> > > The opposite point of view is that we would not want to have different
> > > default behavior between 7.0 and 7.1 when H2G is loaded.
> >  From a VMCI perspective, we only allow communication from guest to
> > host CIDs 0 and 2. With has_remote_cid implemented for VMCI, we end
> > up attempting guest to guest communication. As mentioned this does
> > already happen if there isn't an H2G transport registered, so we
> > should be handling this anyways. But I'm not too fond of the change
> > in behaviour for when H2G is present, so in the very least I'd
> > prefer if has_remote_cid is not implemented for VMCI. Or perhaps
> > if there was a way for G2H transport to explicitly note that it
> > supports CIDs that are greater than 2?  With this, it would be
> > easier to see this patch as preserving the default behaviour for
> > some transports and fixing a bug for others.
> 
> 
> I understand what you want, but beware that it's actually a change in
> behavior. Today, whether Linux will send vsock connects to VMCI depends on
> whether the vhost kernel module is loaded: If it's loaded, you don't see the
> connect attempt. If it's not loaded, the connect will come through to VMCI.
> 
> I agree that it makes sense to limit VMCI to only ever see connects to <= 2
> consistently. But as I said above, it's actually a change in behavior.
> 
> 
> Alex
> 

I think it was unintentional, but if you really think people want a
special module that changes kernel's behaviour on load, we can certainly
do that. But any hack like this will not be namespace safe.


> 
> 
> Amazon Web Services Development Center Germany GmbH
> Tamara-Danz-Str. 13
> 10243 Berlin
> Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
> Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> Sitz: Berlin
> Ust-ID: DE 365 538 597


