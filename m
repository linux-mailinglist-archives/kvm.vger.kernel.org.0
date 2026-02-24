Return-Path: <kvm+bounces-71628-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yLoBAxDbnWmuSQQAu9opvQ
	(envelope-from <kvm+bounces-71628-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:08:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C44AE18A502
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:08:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3319D3012D17
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 17:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07EFA3A9D83;
	Tue, 24 Feb 2026 17:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cnrMBM1h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378523A9002
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771952899; cv=none; b=sjw5XXLV4Zb9A+iFHalHn66b78B0XlLRTewwEAf/6pp9xBF6W7ssCxMSfxxPDNQ3l+nJSOYD1f2EQuo5evcEpwMhusmAmf7zqUY8WLHxU/hG2nv8UUz0vg6GFvvwc/OGI2F0MvJJdJSTwZ2GdKQWUpqbMjzSikm+na9iiKkBItk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771952899; c=relaxed/simple;
	bh=U6OeKTFflZEsOwAbudBFuNdKmsclm262M3wZ2aA4UMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjEHbi73hXv59GKPAJRuz49SOs8cMfaMzAOlmNy4kJrYIPWvPPXDHaUCT4JgOCIwF3ovSwd4Mykde2kw23un9Admpigrkb8qfInzQEEQI7EdnfUAHA9cG90uCabgO9yZ4ofy7dhh3f99NrE65qGpo9wa+M3W1cFP5DzoD7PElLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cnrMBM1h; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ada9e4ea32so14995ad.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 09:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771952897; x=1772557697; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xJz4QDTcumvz9JVrQMb51pWWatd7LKwHk5h8C7Rf46E=;
        b=cnrMBM1hieWtTBHXZV0gag7wLK8HvLxY28h/SBDTCUIy6KPFOgIem9w8RNsm0u42jv
         NtW5HOeVPUIIi0C0GZAXq0mZc+shIo1MsC2vucGY4BEcRYIobcf6+VnGX9kWz5Sd33xM
         Qc9/scTuCIwMZboy3D0dv4n5vVIvAQrbTBPQnsghsjzUwJu4I3XVFoo1dQb0JJeAYF53
         zfZlw59RVfhClDrz2sMZKWRjsM/VqsY9uqVbbuCPQpEy22Sq/Mwb39yTmzWoXxbNFfx4
         337KTEAs+MfsoWA6UkjlZyPE03Vhr2alGa8K4p1lQYJrgLZiuDggmP/DMrMTHtJoM5Y0
         bwcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771952897; x=1772557697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xJz4QDTcumvz9JVrQMb51pWWatd7LKwHk5h8C7Rf46E=;
        b=uY64GZb+Hhj7yNXxOVGcZNi6j1QLdgYeIeaZsl3LLL0T8ZLCW6sqYM2B4soWry3iDv
         mUhfkmXFXyB8u0a8C7YMkckHeY61v7kZ6iv50Jq/XiPZXtNeEsgCuman7y42ifZCzrzI
         R6yJqjvYevAY26TmVA7bei3dUZL3A4B8FPkaYjDUBVscfieMd3Hu1+0+nDbemQZDtQkk
         RNhvts8JJcYqMdxtquwnbDP7CPQZmaKjRfhSSaQue8yLkocZqurIMTYTC9RbUxOTkrmt
         yR4mzSu2nFTExJIcPQ60IAbFJXzXU1oUV5fhUGfoNDJvR02WnnptZz4C0i2wzhHPtHuq
         jWpA==
X-Forwarded-Encrypted: i=1; AJvYcCXtnfJ6o00AWu8kEMeXzFS4jc+X8osw/kaNLuJuWvabYCMNZybxwKS8vOC9R76+TuKJJFo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9aXBx9L7r5hw2QIvBXS4GKm32kVrDfbPLtT1tVRfvCFVzFPKZ
	oOT11tv4bH7mxgz1o12PYHvHuSwi3as49kUft74fjcXzNVYSZBCDdCOKzFGuYVaLQA==
X-Gm-Gg: ATEYQzy578ZCndeACLjEYQDK4FSTk6lPM1HruyetxdDGSnd4bYQ0YQ1pzCzpqYVaPHR
	0nNL0O+XY2CY6E1d5pkfPsVcAfza7G8+80V1axnvdI6WfJmVEKIfbWt1sspexhnftMly5Tx4cmW
	jbL+DhdiXfXRbqgpH6JgBrPKG89QILlSGbtP3lt7lX7ywEUi2Rs2aKPLtPMWXjk0lKPGFivrxZG
	szwv4ADP+/eytA0pxIyzB+2l9EyqohY89FmZlCCtB69Akm3UNh8m5tDZt/BJfm8uIwgrt7SCGoM
	DHK5AhxYmTKaDYsLADXMRgBDK/IgamjJsMSWmfTxXUYtzfGffxQFTHCc8jzMUY6I1OZ0/pdlTgq
	HIRgMceuRgL/ugna8FUz55fnpIMe95CmSpFF4Bb1W2ZD6oCyImKAQBYe3uZORGahnDT/WZ9q69X
	7dhCxr88L/o3u9KemdbwxYD2iUmPHb8iuOrvh1bhtiL38LJSPEJBEwQy3eH7IBSg==
X-Received: by 2002:a17:903:b87:b0:297:f2a0:e564 with SMTP id d9443c01a7336-2ada346b6c2mr1775335ad.11.1771952896593;
        Tue, 24 Feb 2026 09:08:16 -0800 (PST)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82719e7ed8asm1521995b3a.5.2026.02.24.09.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 09:08:15 -0800 (PST)
Date: Tue, 24 Feb 2026 17:08:11 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 01/22] liveupdate: Export symbols needed by modules
Message-ID: <rlftyyae4w4frzcpvyecda32vxod6uambsb7cja274lugs4nhy@3yk3oki2kwo5>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-2-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-2-dmatlack@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71628-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	DKIM_TRACE(0.00)[google.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C44AE18A502
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 09:24:48PM +0000, David Matlack wrote:
>Export liveupdate_enabled(), liveupdate_register_file_handler(), and
>liveupdate_unregister_file_handler(). All of these will be used by
>vfio-pci in a subsequent commit, which can be built as a module.
>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> kernel/liveupdate/luo_core.c | 1 +
> kernel/liveupdate/luo_file.c | 2 ++
> 2 files changed, 3 insertions(+)
>
>diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
>index dda7bb57d421..59d7793d9444 100644
>--- a/kernel/liveupdate/luo_core.c
>+++ b/kernel/liveupdate/luo_core.c
>@@ -255,6 +255,7 @@ bool liveupdate_enabled(void)
> {
> 	return luo_global.enabled;
> }
>+EXPORT_SYMBOL_GPL(liveupdate_enabled);
>
> /**
>  * DOC: LUO ioctl Interface
>diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
>index 35d2a8b1a0df..32759e846bc9 100644
>--- a/kernel/liveupdate/luo_file.c
>+++ b/kernel/liveupdate/luo_file.c
>@@ -872,6 +872,7 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
> 	luo_session_resume();
> 	return err;
> }
>+EXPORT_SYMBOL_GPL(liveupdate_register_file_handler);
>
> /**
>  * liveupdate_unregister_file_handler - Unregister a liveupdate file handler
>@@ -917,3 +918,4 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
> 	liveupdate_test_register(fh);
> 	return err;
> }
>+EXPORT_SYMBOL_GPL(liveupdate_unregister_file_handler);
>-- 
>2.53.0.rc1.225.gd81095ad13-goog
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

