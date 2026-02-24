Return-Path: <kvm+bounces-71631-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8GcgD/vhnWnpSQQAu9opvQ
	(envelope-from <kvm+bounces-71631-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:38:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A975E18A9D7
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:38:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4086430A3191
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 17:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B01C53A9D91;
	Tue, 24 Feb 2026 17:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O+yyE1qx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73793803D1
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771954649; cv=pass; b=Y4zIMXfN3aOIjgQYW7HrW5lqfBD+Q0B3oBanP7YiGmPWyKe+XkZ5BZTkDf5GDM12a3tDygL7+LSzsmDM15xU9G7gHm0aaDYXdWP4Su0OcEz5S9KE/5Whqc7H2wpr2VUPuE6OrX+U6tXQwcVG36EnJ9PjV4miaG39Hbn6da4RoxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771954649; c=relaxed/simple;
	bh=NzE6Dg5T/WZzjhrxSxryu35IDaiffOedvMQkCnbUBbs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ll6AuRxAOyFH4tZEj4LDltYyARGbUYNMweHVeV060pyjknHdHaMCZrXu4HSXErPTgBxPZU/LtQawnwA4P30aBoOqR0c/ppoIV1vi4TFnqBCjPc6aqsmo3G+RNaRs/9yAz50BTNBD/gy+G0CjpMzeHD7SdCnh/YYRxcz0m9B7avw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O+yyE1qx; arc=pass smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-56641200d6eso6478190e0c.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 09:37:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771954647; cv=none;
        d=google.com; s=arc-20240605;
        b=PY4Ohys/6IN5ilQkd6iFpuaUYqQ/lf0c8FzlXqjhbUjQnk0olUWojdg/hqwuBzNnrg
         SCxnF9siuuSCPa+RTBX90jfp2NJRig+hWMPIq4bloNXWOpoWFa9GHnR2c4YuCNQRtXAb
         TPo2Nb+5xpT3hJtRVkLCAw+VYYyw7gaq0E7OMmjii45EuKcASuzp1rxZl6nbzjzbmuC8
         EDan/UoKP0lvKybUfI2eyjeDn8TecZb1pvZKUhU0umK5jsjw/D2IDKcpaQgr9h0JGd0T
         ATzIHnMu5fl44gLOWF8LmZs/MadlLNI6P0NeUMuqIZO7IxEDzfSYAi2vXlQHq2Pq/qu2
         4Llg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WVyG+GjslObEPoiorlcEtEb0lbImQuwl2+xBSlYjPvU=;
        fh=B9hcVx/XeyNB7wnvFQl5s8IWC4Rhl0EJh/GiBumJZkQ=;
        b=LiYa82d0K9jB5WlVNIUh+egUymFgbWA6wxQ8ze0WYDQm9b1NvWRmGazFXb43gC9Tku
         4oJ/CZi7Es7FoK1rla4KrJzcBpiTemJ9HN7Xn/9Zearf8o0T5pqwWWxuGUYiXfKwpqtA
         jY4AASSB9dm+Z2/OSpHl6ai0r553mnK9I5v8iArdgOtdKB2EXHR2IUjfB54nBx6nKa89
         9gvzNTAbIe+wn979qs5XKB8DbpGXaciYmVTTZdY2ULVkNoyNWIp09PB3IeL2GJ4o0ZLi
         j23qmg9ZMccVVfgYTcDq72399tw231BgtKsppvpII9bwewwxm4/C0JEN/8lAJOuIkSqD
         MuAQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771954647; x=1772559447; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WVyG+GjslObEPoiorlcEtEb0lbImQuwl2+xBSlYjPvU=;
        b=O+yyE1qxUOAg6dKVlAaP7DqeAKGiTg2vj+80mJTczPFmVifUrvXeiRAUTHwcY494hs
         nYb1zcEenz5Pr9R+S5wX2fzs6WzUVhJq3NHDLMU1dUIaQLuUMHJZppn+L6jA2ywQRraX
         e0mJSaajncxDDeSLw5ZGMRSxhBxvuucjh4gIMTqlxMEn9XOaUjH+JZpANuq66YMr/C77
         cVNZr4KOfDMzrm6CHNWYiua1MCYdmhCYINFR4ZAoUJe0W+1ywY/RGZKP0jA5xVOuFSPN
         CedJgKBY/KmNHzfLvo3a+Lt7jvxYnRPAZFJmKLozY4jiCcQo3hZpYtW8JIF7cczZ3JQp
         WWQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771954647; x=1772559447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WVyG+GjslObEPoiorlcEtEb0lbImQuwl2+xBSlYjPvU=;
        b=PIiDnUEu4WWGZtvnkzB+6Y3Atn7NMmvbqymG72YNdTolBnhkzUBhKLTDe3Da/wxiAR
         YoYEjRRXqgjpNYaWaIJiAOammlvx7FXVJLul1E3s7PDKdbT9uaLgWsWQJkKOPZB4g+Zf
         4U8CQccWWLcRoREHe+v4kfItj0FB7M7AU2VNvvkfQOpN/Cxdk1//1OxWHy1RCzZjOBHI
         EW5OO512CxksQvDztpJ54K18hA99Dze8vR2omqmlo/vWYwJ60CLCXJIDuiAnrRWhu5A1
         e0JIUa88bRRYXIDGSodwvACMzyeyNloeKo4fxc4dD3BKP+wESdv4WVpeN/zqBMUnhjUX
         HZfg==
X-Forwarded-Encrypted: i=1; AJvYcCU4FdQLYhT3wGglQp0gGUoO/w4vjueqzIw7rnTNK4XM/boeDtPG8XPEacievYLneaozaVU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo0T+bn0P3eIWhhVjITChG2HeRTqxGFD9qsWesoa9kJ6KHIwQH
	UOHzfcl7uf+Kyv2UT5U4nDMwlvTFMVv3XobTZreaxp8qxQ2l/SkThrU91KeiDru/Rt6/whj9Nx6
	Vn/Bi5qr7Kb6Kcm4ZYSe7MKCK2eN7p7qImOP/4gwB
X-Gm-Gg: ATEYQzyME551nVG2glZdQGl7ywiBS+4zrld+MkqUxcRmd+OcW30V+0JP68XvyehZquq
	+WzAQKIgL2dQPxNfR64ALOcwGQjf7sL8EdFr+V9Un4A8kfhPu793k/dJDIbrg2UX89CXwkhLnC/
	kjtg3BmhYbXN0gQftlzitcM6PdPi8OW9K+4+/qRDUk16A3w/YBr1u9ldVkLfZ+c8snXUHt37jjP
	rwaxRh6Afbv1t17q5Y3uakKX/xW7TdLe/8OIn5fmCTXFFPMEGU4UbBC6wU95GbMJKWG6+h8aRBT
	kTWcmnQ=
X-Received: by 2002:a05:6102:e11:b0:5f5:3835:4796 with SMTP id
 ada2fe7eead31-5feb2eebe4fmr7234443137.15.1771954646379; Tue, 24 Feb 2026
 09:37:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-4-dmatlack@google.com>
 <aZ1xAyN0vgLWIi5y@google.com>
In-Reply-To: <aZ1xAyN0vgLWIi5y@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 24 Feb 2026 09:36:50 -0800
X-Gm-Features: AaiRm51zYRUGqNlquBQBjZ_Ao68Y3fgUdHKViouV8m9qg-AcIptaKIFOE6taQzc
Message-ID: <CALzav=cMsDyUrOPgkr5ouROPmsEAN2icsL266M4FxY3P6BNd1w@mail.gmail.com>
Subject: Re: [PATCH v2 03/22] PCI: Inherit bus numbers from previous kernel
 during Live Update
To: Pranjal Shrivastava <praan@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71631-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: A975E18A9D7
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 1:36=E2=80=AFAM Pranjal Shrivastava <praan@google.c=
om> wrote:
> On Thu, Jan 29, 2026 at 09:24:50PM +0000, David Matlack wrote:

> > +     if (pci_liveupdate_incoming_nr_devices())
> > +             return false;
>
> Following the comment on Patch 2 regarding propagating errors, the check
> if (pci_liveupdate_incoming_nr_devices()) should be made explicit to
> distinguish between "Preservation Active" and "Retrieval Failed".

As mentioned in the previous patch, the errors mean "no incoming
devices" rather than "retrieval failed".

> >                               while (parent->parent) {
> > -                                     if ((!pcibios_assign_all_busses()=
) &&
> > +                                     if (!assign_all_busses &&
> >                                           (parent->busn_res.end > max) =
&&
> >                                           (parent->busn_res.end <=3D ma=
x+i)) {
> >                                               j =3D 1;
>
> Looks like we over-ride the pci=3Dassign-busses boot param here.
> We should document how this change affects the pci=3Dassign-busses kernel
> command line. If both are present, the inheritance required by LUO would
> likely take precedence to prevent DMA corruption, but a doc update & a
> warning to the user would be nice.

Good call, I'll add a log message and update kernel-parameters.txt in v3.

