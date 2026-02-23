Return-Path: <kvm+bounces-71550-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OLfLK4HmnGlNMAQAu9opvQ
	(envelope-from <kvm+bounces-71550-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:45:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BC0F17FE37
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:45:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D99B83119CA7
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ECEB37FF6F;
	Mon, 23 Feb 2026 23:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hozANfAd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D6337FF48
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 23:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771890229; cv=none; b=a49kQY6h0B+ALiAJf6Ig3W7qrRFyJHWqn+laUz8qltHxPbZd2HARANT9r0DWI4o1gvVsObXBFjRcxvkcXAdpdGzRRi/VW/nQ+AmKRtYfejlrUVG5uJ/VTLjW/0EGEuCJHq1HFxREU/Ezd/hXD4v460fhft1pMOQ/x5+FJweXcow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771890229; c=relaxed/simple;
	bh=ixq3EXVD+9YovL/Dhlm10KQAl6fwXAJ2uZkBL4dtJrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KsJiaxvQ9J3WSeCghTygyDUTP9jIOJMkCTVvRiuNLYrEpo/87DZnVOf/1mDgxrHuP2yAxQJy/HP/DcyUiV4GvqI8C+FC0pgDyKWf92Y5GppzgZXB5njBQWnPQ7IVhRmmZJnjLqlGg2qeKl8QHBNpLiAGHE3eJ8a5MBNKhCA3wgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hozANfAd; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a964077671so33305ad.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 15:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771890228; x=1772495028; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/Nz0fZa7S09a21wJlX7cSiDYFAmJR+w6WbxCWC6v114=;
        b=hozANfAdYnmVPc1fI5jZASxX7b+DKapE86H8KRrpW2Ju4ONzd73vNfMYFbJDG9Av1U
         letP4BSm9YdKkWEyNY07Pwsisr8nDZAHhrAjcq1RL9tEBJTmkqIiyAesFG9rhjqVbKvA
         smlUArGmcJVJqCZt0n0KV0JqSgshMGSuJ8Ifb6UPsPbbjJvQEzUoYgSUMAEJjZDyJ5HH
         Q45+MTComSxVUaHPsEIkrDdQZ0mWAwqwWZjTjbZ6VxWrRZ37uR65VVURy+adXv7Ttam5
         jdhBOqzEFNcRMqQFyaPFkLo4W1o6/pQoPCdVmlzrUBAL8xPudedWJemnoeEKqm6X2w0G
         7SZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771890228; x=1772495028;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Nz0fZa7S09a21wJlX7cSiDYFAmJR+w6WbxCWC6v114=;
        b=lkUVUkJRWJ6q00mnicJMirOtVslSsAUnp/o/jGrchc+6hEiE5iqiS2JJDDbDneQlG0
         X4/A6exIy6Ht/EQ8A4Mh1BOxTyI8c8rOGPCPd85Gs/bZhMTNIV0o2rjG/BgIWqXUfOlO
         YlGSqBmZnMZElWc8GZMCBS5/C25cMbbElW6JWkd6zqR/sgtRZbzPkaSvKnIpk7gwgqfW
         eKsQkLpRa/duyehFNYsW3lWzyoXjkqcDL4/LCjit74Y01a5kMNaLXfTHJ5IU0QyNnz+n
         pKlj0ItkZzeIVo5UBWmlxO6fVU13xDOCDHIOe2U/Mc+zSYyuKpmD5cO2p8Vzm4JOBKVX
         Voww==
X-Forwarded-Encrypted: i=1; AJvYcCUUrDDey7Bwpif5iX/u335qj6EksuvMUwhX5PNG3cnFDUpM/m1hKiVZj3WTc2DMHulQyh8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPs6MUZvSGJenAGcvuC7Hz0mq47lOYQpa44IZeNKHfEkK98cO9
	ZSQfdxyU4F+GQ/RLffSc43rxaSyB2GYqK0nKvVAnyuN4WR0AKK1jYXeWgVXORARk5g==
X-Gm-Gg: ATEYQzyhm6wxY59svCKwNHG9PQCvJ1RwKR7AVxQk+bnpotrkz197Dr3Rg6wfiAtF5qw
	cop13TLRRICkrNMqB/hA0h66EcoBdCTJKgAweUJmPmqkLCr35IDXuH4b76iJzzrLE1CZCXqg2PD
	QvzaY3UEzx+DlsGKFTSz28o45FRtmASlC3JH9mWcXPHo8pYuGVSL7wadNaI/6DoJWg40xTrZJMt
	9cvVly3tDKpJ2RW3YGurEBLVGAyBktNVSbRBrIGBYcDCG3hkOhXSM5mtE70nyVTms3/7PONTP3r
	wUusv1IfgQfINQ9FXG6g3Lmdf6+AI4fz2jq2XRNS0Gq0Z605ncEYpuuZwf4osUNMcCzY/aph/IS
	r/EV3UKmzU8K/owV2wAIODaCIll+1E8yb+mUptLDWB58QG8hoIDQ9QpIb0slB6tPWnXz2U6/5Cz
	ZsQYQVp1cL9UMgjt9+zzSrnFQVoMoSjU4e22G4rSv6P+vNSKVxnO7gm88cD5RmyQ==
X-Received: by 2002:a17:903:41c3:b0:271:9873:80d9 with SMTP id d9443c01a7336-2ada3483c30mr271955ad.7.1771890226940;
        Mon, 23 Feb 2026 15:43:46 -0800 (PST)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7500e1c0sm90833575ad.45.2026.02.23.15.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 15:43:46 -0800 (PST)
Date: Mon, 23 Feb 2026 23:43:42 +0000
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
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <574e4wq43zm5tyfvvtjfvzqlhoyijcgvvk7gptghrx3ofq5ck2@l2q7xbmtibbq>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-3-dmatlack@google.com>
 <4mbhcmimhin2ulz57mbzpe5p5dkhfziiyep5k3vgls4zmom3sb@g6jlouyvmpuz>
 <CALzav=eXY=ZBshmpi9axt+_0SxaAm0Xbo7w==nCWJwKK3xcThw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=eXY=ZBshmpi9axt+_0SxaAm0Xbo7w==nCWJwKK3xcThw@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71550-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5BC0F17FE37
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 03:08:19PM -0800, David Matlack wrote:
>On Mon, Feb 23, 2026 at 2:04 PM Samiullah Khawaja <skhawaja@google.com> wrote:
>> On Thu, Jan 29, 2026 at 09:24:49PM +0000, David Matlack wrote:
>
>> >Drivers can notify the PCI subsystem whenever a device is preserved and
>> >unpreserved with the following APIs:
>> >
>> >  pci_liveupdate_outgoing_preserve(pci_dev)
>> >  pci_liveupdate_outgoing_unpreserve(pci_dev)
>>
>> nit: Preserve and Unpreserve can only be done from outgoing kernel, maybe
>> remove the "outgoing" from the function name.
>
>That's reasonable, I can make that change in v3.

I should have added it earlier, but the same applies to the
pci_liveupdate_incoming_finish() as it can only be done with incoming
kernel. Maybe we can remove incoming from it also for consistency?
>
>> >+static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
>> >+{
>> >+      struct pci_dev *dev = NULL;
>> >+      int max_nr_devices = 0;
>> >+      struct pci_ser *ser;
>> >+      unsigned long size;
>> >+
>> >+      for_each_pci_dev(dev)
>> >+              max_nr_devices++;
>>
>> This will not work for SRIOV as new devices will be registered when
>> sriov is enabled and the max will increase. As we are not handling VFs
>> with this patch series, this can be fine?
>
>That's right. Since this series does not support VFs
>(pci_liveupdate_outgoing_preserve(VF) will return -EINVAL), I dropped
>the logic from v1 that included the maximum possible number of VFs in
>max_nr_devices.
>
>Once we add support for preserving VFs, we can update this logic.
>
>Another way that pci_liveupdate_outgoing_preserve() could fail due to
>running out of room is if hot-plugged devices are preserved. But I
>don't think that's an important problem to solve right now.

