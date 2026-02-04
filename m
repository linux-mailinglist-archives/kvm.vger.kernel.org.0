Return-Path: <kvm+bounces-70273-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iL0xAXjTg2niugMAu9opvQ
	(envelope-from <kvm+bounces-70273-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 00:17:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id ABD49ED322
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 00:17:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A8B67301474F
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 23:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B8619D092;
	Wed,  4 Feb 2026 23:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LIPg7nUw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31FB2D061B
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 23:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770247028; cv=pass; b=eMLO0cUgRpGD05Xx5mpinnWCWuFcI2IHW9wnSlSBaSmYRRt3Gjfger0sgdDgR/KD6H/E3Fdbv12Zt5BhNeiePxIJQCzJE31RvwEHrdWOLwuWHGELlPQR1u6Iwc4IpvbCC6Cezj2wor48zpeumF7f59VqcvQfGSpSxlt3j27CLko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770247028; c=relaxed/simple;
	bh=tC5YsWveEZUGpFI79SVCPakI/W0g8gI/xm+FXH2KznQ=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WZxfzNOGeFhWDr0NgOh4vc24lK3VYVhJ/Izez8Zrym+/7MVdf07ORh5AjLPyLsPrro2dazh9LdAc4kldNH02Rmimt9gFe6VNIC8rOZsSRm3bFX0rz4VNmZEcQk/Im8i6lZR8fbJPh6jKV06GDF++LoRsP8Dcf7t2fD2u7fqs9uA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LIPg7nUw; arc=pass smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-948a378b9deso83648241.2
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 15:17:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770247026; cv=none;
        d=google.com; s=arc-20240605;
        b=lCN9VIxyD1+I5vkpzR6VupcXEFLjvctR+q78oJRVnPDY6tQphvej+sQii1YFHZHoom
         Gs1Rjrcjd6VFQbg135qocKfFkhzbPzQ0BwmXKNORTwOWM0aCetT+WtJGNx6fh7gG6x4Y
         ckdIDReO9rdzDkxPnKBzmVGpDNbj2XIcHUCEcU4tB07EHr5HmBh2qOZa4ExMtZ6x8MFk
         QVSVOPhtP6j5LUTSZ980yNxZuwc9SpNCVhGMAWzFgADmKgiu3tTrm2jiHKSq6pWAwVON
         UyowGnANaSpo6pBhkZ9jKeXYRKHevY3Bzd/ZTLXlXH17h62fXsNQc651GCEVAHmRFhcc
         96Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=1/UEh/WvDHNId/qcPGt/D6GIajP9ilohqKmlVhSScLU=;
        fh=PTfheikpfDrLcmFICuXlVvOIHgLexNzlSRt45VPFDUs=;
        b=COoHHQj+CQ4bdxKCDIatUWjBI/yQBumAfvXBhHZRLdT4xMGX+1dmDtyaq/h0z2dtsS
         Ie1GgQxs8kX0MA8Gq9ghJwCNfll/n2clASfdVKEME1A/0CmscSiTcgML3jJDyeaE/WD6
         vY+y3ly2FeXYLZFe3l59+oVVVpNcsyMCGwrDXj4PDyr5RjrJ6pdoNVZzXehjFZGKxxj5
         6ZkbE35SzOgdHzVcwWRZ4lyaCPO5TrOLPNGtozNV3nsRfrmmjg3Je3g5J/JpVgZ8Yzpq
         naai0ob7u6qdbCyKJUKdpAS3LPuoKuTd3OqZbGT4sWF+cEh85D3kM2URMyDAOaS6a6SX
         YFyw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770247026; x=1770851826; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=1/UEh/WvDHNId/qcPGt/D6GIajP9ilohqKmlVhSScLU=;
        b=LIPg7nUwTZjW+dK147DAR21yDuVlnzBLEPWqcAaiQsCafH2ViEpOxUOFLLGzJxiZbR
         W/uUTfpayiVsph9sOIqaUEL8cZ8DrC5OPU50rnmNEkgY3YNj9VjEORg7aLKWZBz92L/Z
         a57t3c4GD6T+uZrnNc0GIXnVetVSp6kCLM7AHxNWiKBNDh7OKWqiqBDzonQOiXEgJTWi
         QqDlITg3uoo/ATenhvYVvM5Hmpx6ht+/+ku+pt2CttonsZuBMgLEZqTRekpzdt2AWrQ6
         F6gXnkS1NSM8orgS3/PEXKAVm49uqNUeXkEcGKx7dtgSqm4KQJwbYi3FWDZKs5khM9V/
         J2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770247026; x=1770851826;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1/UEh/WvDHNId/qcPGt/D6GIajP9ilohqKmlVhSScLU=;
        b=MLEGu/4N3hDLniKGgFQ2n1ZXuRGsl763aXuFaLsZLpDs5tFMjYLGGeBMegqzSAsquV
         LqvMmyC8+k9czP+CRcf+U3bXt4eiX8/F4FuT4fu3kMhWWdS7cbPA0gYkpp31N69pBpAO
         anTe64zhNrYDjedynCA56nP22mUNtigA1ftfcXRD8weKLm05D6Wzc9cPdJFoeBeF7a8c
         dBJ+xGOer1rrRnbCkWyfFQasWEDS5+Y2Au5eb6B2ntolfFaMaVpyqicc57B42AmZb0iU
         wpubRMwFm8NIqnnX7h8VZAqNeDG93wGE1gnszQa++B2cJBJSpb3RMGtKJBnRP47YAh1r
         /hVw==
X-Forwarded-Encrypted: i=1; AJvYcCUpiylE3CYssRNTIeJy/MEY0f3PivPWSIs2kd2L7lNn/TRDrIPBPDOpMWCQAWrIAosPN5w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcmYJWLoPp3IYmR3ddeQcFltX4GzdYJua2Z+YUskv6+Y8mic3j
	jqgsA/WgzI4N4VgUDFRcRHPwEu9DNzUWGfbR6UF+Sqiah1bMsBMyG7N9IoZIBr1kQmuX9SIbWU5
	aTx4L1ls6/G47wMyLD225rL1VxeE/DngIfpMu+5To
X-Gm-Gg: AZuq6aIHSI7BNTAnHYKhzpT6k3JbAHWq8bNPYXqAdJ2wHYOit4lLl/+9P6PLYIJvT+N
	bcOcr9OLLDFFPBRM5hOAb6qzLOK82a06spHatdu90moy08YHKVqnAJLGHvQNSothOg3hjOyLzzy
	cFLP6ceasSjS6o4tBRVOHBptJZBpKj8ouZPq/QqXUhn5Tc91+M00mtsih54fIcATk1QW+I7v015
	k21ORYRTUPXrqMtEziMwiSFE86txpKguqeHJ6IxxNl+v5d8RJIJ7Pkc84Q6+Wjn8SlOreFJgMWX
	NcAYlhXLsCSfNBNX324QGvj8F4Joy3a1DQ8r
X-Received: by 2002:a05:6102:3713:b0:5ee:a3d3:39ec with SMTP id
 ada2fe7eead31-5f93959fa06mr1375473137.22.1770247026345; Wed, 04 Feb 2026
 15:17:06 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Feb 2026 15:17:05 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Feb 2026 15:17:05 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <16e5a36e-fff0-4a54-9c5c-a8e411659108@kernel.org>
References: <697d115a.050a0220.1d61ec.0004.GAE@google.com> <20260204170144.2904483-1-ackerleytng@google.com>
 <CAEvNRgF75EsHL8idLzFzbk0K9uhE70AMj5Vitp4cKNg_5WqQKw@mail.gmail.com>
 <aYO8DLCWw8FEQUAU@google.com> <16e5a36e-fff0-4a54-9c5c-a8e411659108@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 4 Feb 2026 15:17:05 -0800
X-Gm-Features: AZwV_QijtBnzo_YMcGc93Uq6IbdFZDqkBZJNU9n4PO7tFP2VYWDXRH4wDjLjgyQ
Message-ID: <CAEvNRgHX7MPSBX7pMeSWEtzc0-bJhAZ=pv+WF0VtOv9Tx0Jpxw@mail.gmail.com>
Subject: Re: [PATCH] KVM: guest_memfd: Disable VMA merging with VM_DONTEXPAND
To: "David Hildenbrand (arm)" <david@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com, michael.roth@amd.com, vannapurve@google.com, 
	kartikey406@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[syzkaller.appspotmail.com,vger.kernel.org,redhat.com,googlegroups.com,amd.com,google.com,gmail.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70273-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm,33a04338019ac7e43a44];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: ABD49ED322
X-Rspamd-Action: no action

"David Hildenbrand (arm)" <david@kernel.org> writes:

> On 2/4/26 22:37, Sean Christopherson wrote:
>> On Wed, Feb 04, 2026, Ackerley Tng wrote:
>>> Ackerley Tng <ackerleytng@google.com> writes:
>>>
>>>> #syz test: git://git.kernel.org/pub/scm/virt/kvm/kvm.git next
>>>>
>>>> guest_memfd VMAs don't need to be merged,
>>
>> Why not?  There are benefits to merging VMAs that have nothing to do with folios.
>> E.g. map 1GiB of guest_memfd with 512*512 4KiB VMAs, and then it becomes quite
>> desirable to merge all of those VMAs into one.
>>

I didn't realise VM_DONTEXPAND's no expansion policy extends to the case
where adjacent VMAs with the same flags, etc automatically merge. Since
VM_DONTEXPAND blocks this kind of expansion, I agree VM_DONTEXPAND is
not great.

>> Creating _hugepages_ doesn't add value, but that's not the same things as merging
>> VMAs.
>>
>>>> especially now, since guest_memfd only supports PAGE_SIZE folios.
>>>>
>>>> Set VM_DONTEXPAND on guest_memfd VMAs.
>>>
>>> Local tests and syzbot agree that this fixes the issue identified. :)
>>>
>>> I would like to look into madvise(MADV_COLLAPSE) and uprobes triggering
>>> mapping/folio collapsing before submitting a full patch series.
>>>
>>> David, Michael, Vishal, what do you think of the choice of setting
>>> VM_DONTEXPAND to disable khugepaged?
>>
>> I'm not one of the above, but for me it feels very much like treating a symptom

Was going to find some solution before getting to you to save you some
time :)

>> and not fixing the underlying cause.
>
> And you are spot-on :)
>
>>
>> It seems like what KVM should do is not block one path that triggers hugepage
>> processing, but instead flat out disallow creating hugepages.  Unfortunately,

__filemap_get_folio_mpol(), which we use in kvm_gmem_get_folio(), looks
up mapping_min_folio_order() to determine what order to allocate. I
think we could lock that down to always use order 0. I tried that here
[1] but in this case khugepaged allocates new folios for guest_memfd
(and others) directly in collapse_file(), explicitly specifying
PMD_ORDER.

I took a look and wasn't able to find a central callback/ops to catch
all fs allocations.

[1] https://lore.kernel.org/all/6982553e.a00a0220.34fa92.0009.GAE@google.com/

>> AFAICT, there's no existing way to prevent madvise() from clearing VM_NOHUGEPAGE,
>> so we can't simply force that flag.
>>
>> I'd prefer not to special case guest_memfd, a la devdax, but I also want to address
>> this head-on, not by removing a tangentially related trigger.
>
> VM_NOHUGEPAGE also smells like the wrong thing. This is a file limitation.
>
> !thp_vma_allowable_order() must take care of that somehow down in
> __thp_vma_allowable_orders(), by checking the file).
>
> Likely the file_thp_enabled() check is the culprit with
> CONFIG_READ_ONLY_THP_FOR_FS?
>
> Maybe we need a flag to say "even not CONFIG_READ_ONLY_THP_FOR_FS".
>
> I wonder how we handle that for secretmem. Too late for me, going to bed :)
>

Let me look deeper into this. Thanks!

> --
> Cheers,
>
> David

