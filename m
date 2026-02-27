Return-Path: <kvm+bounces-72152-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YBTgLaqZoWl8ugQAu9opvQ
	(envelope-from <kvm+bounces-72152-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 14:18:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C15261B787E
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 14:18:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E10BA3045A20
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 13:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4014D226D00;
	Fri, 27 Feb 2026 13:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="TMAwo9wv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA0D21CA02
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 13:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772198299; cv=none; b=XqTbUNGtjqsL0EG9TlPQp85120XvPNSypbsp6RByMLbWwA1h8CouVHB55wy7vmWwfKf/BScwmO6iX18GWpVoS64so0lG/97ygTuj0OkoNAiOB2L9Ado12AFkklGr49sSqYdEJbATsL+kfeilHvPVsrw4NY8+rHwIl3R+vgU9rjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772198299; c=relaxed/simple;
	bh=L/z+htTQOMeMfJb12gYYUmgCXubeh01T5SyfZ35RqHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2RjAA5w5a3yiVmJp/ZwKsh2zLtk99zjwJycOTuFit7kaq+e5I2RUNIjjGwxNYqWmLgAyA8gjKhwHlFjdlKyUYeNdpEwjSNlH6R1AeL4k9G3zDRwSQWheSi6maVNSuqAW5Mbj5AzhtJ/WKzvi7XIJc9sY86c1GJ501P3YrH88p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=TMAwo9wv; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8cbad8e6610so228704385a.0
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 05:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1772198297; x=1772803097; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L/z+htTQOMeMfJb12gYYUmgCXubeh01T5SyfZ35RqHM=;
        b=TMAwo9wv+dExDGFp4UwRCJP+rpamtM+oNeploNYGVTHlsakzqWbW7BGsNwH+l+Qjax
         aT/Ed9EQKKpaPmEt/wOFsEQCXo6sXxPjRmcHduTB+lX9RgoCmaSmsNu3aoG1jDvnTUw7
         zoZFK2tl563vYEY+hag0b4PT4MDomONLI9PJUTec86gg35zvXzL/zVP+Budinlt6XYKg
         SpqaQ3b++uIV8Lxxr8nsHM7WAP3HW8oLGBble3AbwEO2LPDP12pQq01b/0oM5pylQUHi
         oxVxwRn6HvyboTX1KeZNLYEypahL4anBxmuZ2eOfaX60jhAw6hYeSbsAifiMc6H85d7Q
         8J7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772198297; x=1772803097;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L/z+htTQOMeMfJb12gYYUmgCXubeh01T5SyfZ35RqHM=;
        b=qezakzXfQBQme8pdydQ29nlo4Hp69/E7ALL0aRbtAySo1lUOk2m3bZ3yKtBKWK5Hkq
         sOBzaVFgY0aalaJpT77jXSd055d+VkYMAZ9gDiM6VXTEXryG3NWgkNNOSLGHfNPnJcvf
         7Vrud/E/6qmaN+napwkWt++aKmnqbhTp+9lF61UUU91sm1Ur4RPSJYyJj3A7YX3D3LEy
         7o+7EJrIPVuiC+MC42iR7RRlgV2JRC0SeMXJQbrFHJJe3JhwJPBp5HZx0xj9B6UYYdRC
         ipdhxUnNd4sJga/rl2TUKHgNwylKH5elc/6IjrAkrCcrq5DXgBH60BGAmU6aFKKLOTnz
         v/oA==
X-Forwarded-Encrypted: i=1; AJvYcCWqASYHYV9l9F1xSW1mWFMKCvfDvDWQlbE1pTt3RNL0nbrN2KmHYZdfi2gZuPnwQ1S9Yc4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxskSGl+zt2oDZQsilH+uhgnhnT3XPp0WN3WE54tRxDiCEUHraJ
	+V7fyXQcGsL4LPkohsVrnKa+GRZWafhG1cyAYiSV4n35dAP4g86nVFCw/BLUj+G9hIg=
X-Gm-Gg: ATEYQzy8ZPMX2C60nRNgatktiTlJvcy9m82yireJ7a+DQLm0WAdzuoEUTxbhr3VfdQn
	30CMBAbB9Gl27c356fiB4r70ATd0Dh0fzzj9hIvJw9Odm9CRnbgcVMJTg7Pg+Z8qadJe9tRg3X2
	xRNUHPpb0j8Qcc/PPdjn0q+LtxiicyDgIW9ug/ZGfqQ5CanM+UVjfuaDfmPrv5oIEAvXDsFaZ7k
	tAWSrwhYf/ze7dledTMpntJW6gV7eW9ebipUUZACisMao/sWHUjtC8bbA5rvtGHVVDNn2kVSCPL
	Jpunl7vyonH0qM65K2gGF9NdQEtcwXxzM6wAmGl8+KGQ7kDQciIlIyp9qjCXDN54STmj+EkoF17
	piBCyMR4ae20wAjrEaMdKInoQGponnO+1CAaJKL6SXo9Rv//mx9egCwmPrkg5RE3L7tyYZAzk3A
	4cN3nOQrddD+rKpmjoWTcM1lUG+leYey2dCZHZW1TeVT8W9/TYF3k5c8UMly/ELXuFWYUE/uUMf
	6I4FPmq+6vYWk8cQ/k=
X-Received: by 2002:a05:620a:4891:b0:8ca:2a04:3ff3 with SMTP id af79cd13be357-8cbc8e8096amr324078985a.30.1772198296803;
        Fri, 27 Feb 2026 05:18:16 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c7193227sm41395436d6.21.2026.02.27.05.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 05:18:15 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vvxjT-00000000uvx-0Dij;
	Fri, 27 Feb 2026 09:18:15 -0400
Date: Fri, 27 Feb 2026 09:18:15 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
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
	Fuad Tabba <tabba@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	michael.roth@amd.com, vannapurve@google.com
Subject: Re: [RFC PATCH kernel] iommufd: Allow mapping from KVM's guest_memfd
Message-ID: <20260227131815.GG44359@ziepe.ca>
References: <20260225075211.3353194-1-aik@amd.com>
 <aZ7-tTpobKiCFT5L@google.com>
 <CAEvNRgEiod74cRoVQVC5LUbWDZf6Wwz1ssjQN0fveN=RBAjsTw@mail.gmail.com>
 <20260226190757.GA44359@ziepe.ca>
 <aaDL8tYrVCWlQg79@google.com>
 <20260227002105.GC44359@ziepe.ca>
 <aaDlRdnhIqRXEbPZ@google.com>
 <20260227010902.GE44359@ziepe.ca>
 <aaFzgGTpZI0eZWdD@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaFzgGTpZI0eZWdD@yilunxu-OptiPlex-7050>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72152-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[ziepe.ca:mid,ziepe.ca:dkim]
X-Rspamd-Queue-Id: C15261B787E
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 06:35:44PM +0800, Xu Yilun wrote:

> Will cause host machine check and host restart, same as host CPU
> accessing encrypted memory. Intel TDX has no lower level privilege
> protection table so the wrong accessing will actually impact the
> memory encryption engine.

Blah, of course it does.

So Intel needs a two step synchronization to wipe the IOPTEs before
any shared private conversions and restore the right ones after.

AMD needs a nasty HW synchronization with RMP changes, but otherwise
wants to map the entire physical space.

ARM doesn't care much, I think it could safely do either approach?

These are very different behaviors so I would expect that userspace
needs to signal which of the two it wants.

It feels like we need a fairly complex dedicated synchronization logic
in iommufd coupled to the shared/private machinery in guestmemfd

Not really sure how to implement the Intel version right now, it is
sort of like a nasty version of SVA..

Jason

