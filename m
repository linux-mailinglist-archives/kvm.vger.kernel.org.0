Return-Path: <kvm+bounces-72115-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IMnEEHvjoGmhnwQAu9opvQ
	(envelope-from <kvm+bounces-72115-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 01:21:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6390D1B133D
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 01:21:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E42FA301113F
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D13925B311;
	Fri, 27 Feb 2026 00:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="FUN+FU80"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE79221F03
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 00:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772151669; cv=none; b=T/Y41RWCsMUrGe9r9BKoyUmO4azYMlRLqgWpamelUoBNZXXYVwEEkP2XMXZSqA79jZ0ApFd/DSTuybUMIHeQpD01USNfLYBl5G2wCL8LFxcvtIQcdlMXZC1l4GesARIZ8+JOjtHPLfxmsbHImvOHcysR8LbZNbKiUSHLoNYauqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772151669; c=relaxed/simple;
	bh=1H1E6m/3SBzjbZermb/QgS4pChpnCVDklOtdppC5Ybw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Muq4FgDWORP6iu4mWOj/FdzIyGwSYoEqXV92gX7Xc03AFPeJ5cpjiTDZ3Nr22ohW9IgR3vPq5Jc/J+6UPZXhtkX5n1PTAbtHaqpzPboVIJZsc3spJneIerT53Z0VHTASkj3YACrF9+OE4Syio2ZL/JlIEq9gMg3oWEhJS1gvVvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=FUN+FU80; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5069ad750b7so12740621cf.2
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1772151667; x=1772756467; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LZJ67b0vcINlAFMObCVMgz4IqYLAlWLPJaI4jITHQUI=;
        b=FUN+FU809vWp8UXQ2I8P97Xo4tk/fAgg8U4AlVZVcyxr68RGMrZP3y7hHHGWZiHEGF
         WXETdexH2ZLfEDTiBjV/9/zctQ//VQqx8sZDH3VWL1YZCHZv/dXo6XBlKY55mw0ldC9R
         yTIZXa58S4q71X+uY1NgAlLo5dBhG6Riq/8nje99RdrjCPSVTCuV2D4qlZVzRTfeT116
         1Ir4u1NFIY71NrBHSEmRzpTFPdieIhZiY32Ypz5bP3o+BaI7nSyunnsiiUJL/cWjqZwX
         GLqPozy/UU3CMY3CobrsSI2KkbyL/Cs0FhR1VLBW4hwjva0isZXgmmKPRcps8TFQ+4mm
         Fenw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772151667; x=1772756467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LZJ67b0vcINlAFMObCVMgz4IqYLAlWLPJaI4jITHQUI=;
        b=Ns77M9JKFkNMSw+KXnYBqORaRSirBJNB9zdfOOfhCAQSl95KVCPOSmS0xlHYiGQy76
         keo1794TPSn6udygWcrXWg0gXod/FiN3vO5Cn2dgeF6v+lyrxQ5TI2O89vli0LnOxToG
         u7QxiYOx0YRoIGkypwLcVqA+etHcebngDac0ZeCkakoFxc5UMcE75YSP1s2GukOzSc/z
         gLZJqLNZGwzKTdCyXZPzLSQo3mE6tgWFm25/oSH1jfAZrKPEP7GhIkwt4LXotFE2fqhw
         EnOC2rnbxHa9YOBOPhZ1ynWzJ50yZPXZ0FV7CKlhSAZvxvhP4uP1sD02Gud7tO/5K3Ea
         2/+g==
X-Forwarded-Encrypted: i=1; AJvYcCWJxAU1rFAKo66o0gNtCMcjAhDRDMZdjA4EI1l/hHu/1Ucw/GvNzoLb7l3IlxM/SG20YoA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz0nGXWTZ40CT5V3eq3+UU474dkBKKLDe3wJiEyjBKXP0+k7f6
	JCgbs1BpFgGOLUYScF/s7Pga947ZPgLliGylQIxI0b9n97S9YRNAJ1fCTutWunmpPQo=
X-Gm-Gg: ATEYQzzaXMVH5i3pr/btVvVGmovCdaOhKjeyb1YaW4fUcHZsQ7E+mZu7QkQm9t+1koH
	MYRJDFeauDUw4txROQMVwKFPw2wUf5Eyr8pdi1xg8Q2Jpkk9dS3+OTeE4MAZRY/aYxExUWHQAjh
	Jre13NF+UgXWplPECFL5Uy1Zm1d53ezdldcQcDu5sr/uOrYphpDT3tlGWqKraiRsftmBDyf1E9x
	7oY5KsjICNWPtNqzfXd90ldW0G239QnDH2KNc47bNoNZ0ho7vlYKpEfXHJ5d8ULonrrcV+F4Dtc
	TB45XbD1e7SWWXw303K8xOXI5OQKwDQS6Ri+FSy3/+0t5dj2ozGJp/GXmVxBmGmqFPZkOpxJZlM
	HSAgvQVwfUq79Ou8WOec09NefOdxPjBffz+edgCDXKWmn3mTlDR7r0eX0eAsd8ofdl6nAxjGVhJ
	wBCBK8nHyvv6rG7WdIGD7R+D1qaboz17RG8h/6iNf1RxbzdXJ/EJG9vaGNo3hI+mxcf6vr63/fk
	Znk3HvH
X-Received: by 2002:a05:622a:3cb:b0:502:f07e:8569 with SMTP id d75a77b69052e-5075282779dmr12593871cf.35.1772151667151;
        Thu, 26 Feb 2026 16:21:07 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50744963095sm36791911cf.3.2026.02.26.16.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 16:21:06 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vvlbN-00000000pwc-2290;
	Thu, 26 Feb 2026 20:21:05 -0400
Date: Thu, 26 Feb 2026 20:21:05 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>,
	Alexey Kardashevskiy <aik@amd.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Steve Sistare <steven.sistare@oracle.com>,
	Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev,
	linux-coco@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	"Pratik R . Sampat" <prsampat@amd.com>,
	Fuad Tabba <tabba@google.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	michael.roth@amd.com, vannapurve@google.com
Subject: Re: [RFC PATCH kernel] iommufd: Allow mapping from KVM's guest_memfd
Message-ID: <20260227002105.GC44359@ziepe.ca>
References: <20260225075211.3353194-1-aik@amd.com>
 <aZ7-tTpobKiCFT5L@google.com>
 <CAEvNRgEiod74cRoVQVC5LUbWDZf6Wwz1ssjQN0fveN=RBAjsTw@mail.gmail.com>
 <20260226190757.GA44359@ziepe.ca>
 <aaDL8tYrVCWlQg79@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaDL8tYrVCWlQg79@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72115-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	DMARC_NA(0.00)[ziepe.ca];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,ziepe.ca:mid,ziepe.ca:dkim]
X-Rspamd-Queue-Id: 6390D1B133D
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 02:40:50PM -0800, Sean Christopherson wrote:

> > If guestmemfd is fully pinned and cannot free memory outside of
> > truncate that may be good enough (though somehow I think that is not
> > the case)
> 
> With in-place conversion, PUNCH_HOLE and private=>shared conversions are the only
> two ways to partial "remove" memory from guest_memfd, so it may really be that
> simple.

PUNCH_HOLE can be treated like truncate right?

I'm confused though - I thought in-place conversion ment that
private<->shared re-used the existing memory allocation? Why does it
"remove" memory?

Or perhaps more broadly, where is the shared memory kept/accessed in
these guest memfd systems?

Jason

