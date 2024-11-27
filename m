Return-Path: <kvm+bounces-32559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A2569DA31E
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 08:32:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBC3816783E
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 07:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC481547C0;
	Wed, 27 Nov 2024 07:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="bMOvlLf8"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6988BBE46;
	Wed, 27 Nov 2024 07:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732692765; cv=none; b=ZVX3LNM5kKS6XHKFCsiG01fPL6osgSzaVbSWBLeK89Qtv2qdZ1LmSJbGn3W51nnUUeJ6EF9cfWZ8Ji6MrK/Z4m4goyrVR9bw72qKQBL84K0qVxUKVQzDW6GJmGWz80Wqzkl6bkb4m/vYGP9QC2vuLfnXjLZ3MNZRUT9Pl/COYes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732692765; c=relaxed/simple;
	bh=y5PKOe3A/ElM8wkWM4XMgKNtPnBBd+d6Q8Bsjsnjh14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C6RgjlwgSsp7iklyKH/f12UJeuo5z+YtCVBcXCFnnqcxu11bGzyomamHgNmWOH87fxTtJbIardeVudC/8xZR+S1bXHzQe5y3LRj+ZwyKLW2mZG5g/q+47TKYXNupmUvITb1tuLt8p3UwQk+bJj3tZFvKtId8Y9ptz9JQ9PXGSs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=bMOvlLf8; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.205] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 4AR7WE5O1827260
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 26 Nov 2024 23:32:14 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 4AR7WE5O1827260
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024111601; t=1732692735;
	bh=Q+69jm4dZPx/77M/o6zw1lNWCYUcUCa6Gnxp/BFqGUo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bMOvlLf8TZEck31MTyVHXl+AkIYh0ku74K/YZ0Myta9xF9uEn/Yd+hhOXBFbKqyiy
	 1E3jrJZBS9Q1HGcXiJt6faZoqovW/TP9DginaUVsG0AJxLD+56nGhDTkTa4SGuFuCT
	 jTyu84+Iq9s7xcDLqkJ9e9Se6kwhMr6Y1np1L6p6/uDRPZjIMmAb7i+LK3rPuLfz0D
	 ybe25B0eozQqjKhavasjcNePh6YxGfNHDjc77O6YuzY42cinM8p8OPgGtSzlKoSP0o
	 eLoDMIneEolnJVh2M2vnblkARceLdWGINc/sxXuFUFyIBAwxN3hrx4CzUx8XtjKFhr
	 jw76Pgawb9ReA==
Message-ID: <43e47da0-1257-4e68-9669-8e3d4915fa57@zytor.com>
Date: Tue, 26 Nov 2024 23:32:13 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/27] KVM: VMX: Do not use
 MAX_POSSIBLE_PASSTHROUGH_MSRS in array definition
To: Borislav Petkov <bp@alien8.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-10-xin@zytor.com>
 <20241126180253.GAZ0YNTdXH1UGeqsu6@fat_crate.local>
 <e7f6e7c2-272a-4527-ba50-08167564e787@zytor.com>
 <20241126200624.GDZ0YqQF96hKZ99x_b@fat_crate.local>
 <f2fa87d7-ade8-42e2-8b2b-dba6f050d8c2@zytor.com>
 <20241127065510.GBZ0bCTl8hptbdph2p@fat_crate.local>
 <a76d9b6c-5578-4384-970d-2642bff3a268@zytor.com>
 <20241127071008.GCZ0bF0EGespFhxwlP@fat_crate.local>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20241127071008.GCZ0bF0EGespFhxwlP@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/2024 11:10 PM, Borislav Petkov wrote:
> On Tue, Nov 26, 2024 at 11:02:31PM -0800, Xin Li wrote:
>> This is a patch that cleanup the existing code for better accommodate
>> new VMX pass-through MSRs.  And it can be a standalone one.
> 
> Well, your very *next* patch is adding more MSRs to that array. So it needs to
> be part of this series.
> 

It's self-contained.  Another approach is to send cleanup patches in a 
separate preparation patch set.

Thanks!
     Xin

