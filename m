Return-Path: <kvm+bounces-71641-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oNGRGpvtnWncSgQAu9opvQ
	(envelope-from <kvm+bounces-71641-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:27:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F070F18B5EC
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:27:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3E89E320CB7E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1008D2C21C4;
	Tue, 24 Feb 2026 18:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NblcGDHY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0052BE642
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 18:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771957137; cv=pass; b=H85TzP8xlzzAsz1iVe+HOjMKIb+3NmGI4Ofo8lssu0IdetdwrxRSLHLT+iAWbDW4PzXsO9LFX5KJwxJ06hHdtWJ5KUiGlcS2mVnEsYp1G7dotNQ872qkGgpBEI4GskNmZzjZnE43MZR88E1FTiTn+t2UMTKxrtQnm15P+1xbnPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771957137; c=relaxed/simple;
	bh=/DInnSeaoLZAZmw5wmXhI5ZdMMTrfFLw8yTfVLpjKME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V4vLdLGYtc9ItN1Y5LGEiXiq/j4Yw14oMcEkKfV25j9sv0FMwDkY7iABVdNOjl/4f0jWYCdNCdMLH8pa5vFFlBW64MV5kRrx3xFJa3MLCK2RN9a2fFhDiAkQb9r02cyTHJlQFYz6udT0wDkC+g6e+zD1qT3hDJIj81bVF+2AUd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NblcGDHY; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-65821afe680so544a12.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 10:18:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771957134; cv=none;
        d=google.com; s=arc-20240605;
        b=EVidFOTVYDrpCFXxv3c67PP/WJ7Lelvy+lmIp54PBuwIvQMrTAeQerN6cY5a7JKUHj
         L9EFv6K6YJkVOtRBYC2GEDYX1UFIIpMeR2Srm7FPrkORAG5mVs+vnhDmsHCToxMFtnff
         UlYioiW+wDCmj9XQuw2CtRDbMBipABW3BRn/xORB8XQRU4NonWri55aVs2BBDDVmQAgA
         2et1kIAE1Jjm6ztYmArGp8p0KFgDR1/2kKNdisuDc2rBkqyhz6oZg9TlPI5GsKOTYmD/
         ranM6X3kLvkiOEIz6MCTS5QJ9WLZLf6rYvqPQQwe3bbEf+PukibwYRBipBVUWbV0Aykx
         QYhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1t5kUOC5ngZkB1png7EJ1xy3Qbr1wcwSm9sEBW7YHTM=;
        fh=+gAc6R/9NF1L2KuD63LDus3M9fBr5vWgBXK6XhSLBBo=;
        b=iG4p9jH1Oathm8bfk6gpBWJNm0iZi3jYPqB0eqBpdzDAgtsstp4ynToCb5SpxqQDBz
         PDV/eaNf44i9cuTbaSo2XzxE9XCzAuua7gmW0dyVoW4BVFy/d7lHQ/FFX0R7+AyH5nsO
         tgo5qYIEaQQM1OoknPVY4CvnMLzNaI4kHn3/CvsoS6vQOXoIMMLEgQvQaWI1naDAwa4P
         v73jzNdKkuZY+I2XAifD/7LE700C4yNEmhFHO/WflVF6yK1TXPwaKVKVbUlVHcbQ4OxF
         fQax/elS0H4X3eTdqWgW+sWGgXEc1SFvB3ovaCLjqQBI7ZE2NHgUa+tfnmp+bU7sjGsR
         8ZsQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771957134; x=1772561934; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1t5kUOC5ngZkB1png7EJ1xy3Qbr1wcwSm9sEBW7YHTM=;
        b=NblcGDHY82ivd8gADwpvAeTKgaKMe1XcuefO45YXP2bOjC5q0OtTInGo6sSa2eJ/AG
         PnWjdaRk2YSYDVxs4cYu50cxZJluZ8+KeNyNSAWCKJue3YN01Th4bHBFCf87/pKRhoLq
         MIr4cbYMfcYS7tcmW9CeMXxPkgpd1qUqxLm4XaVpZK4dZyQyk7KuTBdy9P0womToQ6KC
         /UwMSfhNUngIc17qltiMslw5NoceQRIFuKpAnKVckWAGB2TAgP81YwwcaNBe4ZVjh/Zu
         Ufb9WaVq4OQCACg9iOcYpkG5Wfp0gMafqWQNxFArGCEr7nu4JJhGwNwDXX7b3UF72zEg
         ZaDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771957134; x=1772561934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1t5kUOC5ngZkB1png7EJ1xy3Qbr1wcwSm9sEBW7YHTM=;
        b=FA3o9oDzrtQ78uTKVDVPpaLEOGkMYoqj4riGhA+pcO4bu0LkNuLehMt1FoSXVQ5lLL
         kfcJ5/EuJdBzPvMwL2e6YFxPb9Tmc4jfO7162NbuaOAyKrPygBQnDOLwj46Mel+KJkQi
         Qjh2+mW9KrZ02LJegrHGYnVDF7LMVoDR8F1m8LpAFRbcNIt5yiTfUSAfuGnVRIFucEBP
         FVeWpyT2RhLNMtM8ShjjZtbHDJmXKazNdorI/J10JEbn8K68WuB3dVUMflO+aLDkMkks
         IUvt9aq0B5EpzDqmREDs9IRkRnaavUa5+owr7T572KbihWoAuMTb+hvFxcQFPOYyHFea
         pLYw==
X-Forwarded-Encrypted: i=1; AJvYcCVu28jerSuf5Egx2+FhdJRSVBBANUWrlTsVixadpq+YmwMvKrhz25m77j09by/pHSyfh/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhhLPk692ZA6Vp9Xum0zdj9dXw65j3+4fX3ggGvQA/ySemR91w
	v5vGntS6A36RyFauljhbtFIlBNT7wxZUCziBQczbLYpYuq6eIyKn6AkuB8XiiOMirQwimftl6/v
	amY7WN/aAsXlVRK5TMIksNn/Fr28U87/MzVsmjVSz
X-Gm-Gg: ATEYQzx8lslyENF82aDMqR5Je6Z2ccYnfty6Tvv9Eu56oyZkUb37b9ImteWJ40w6TJT
	ncpo0GYboOEkqI/KQ2+axxuaDJu0q4IdGsihdK6YgAlvEi1HnQ0Hd44JjPrpzKjemLGDaBOMklU
	L5EWWNRPVxDyH41/G1/eFgKktZYGF8sN7ExDJdvmSFQkeM18eOd9ly7t+ViAYi+Ckkos0kF/wDF
	kbD7nsbvANSwnX3JGsYXLcy1e5Pr6TbZuq7d/1p2IYPFHo4DiMPsds0nYwQDjPnpVlF4xc2CsjS
	2PM2KEk=
X-Received: by 2002:a05:6402:1a53:b0:65f:8150:dd22 with SMTP id
 4fb4d7f45d1cf-65f823aa5efmr3093a12.0.1771957133943; Tue, 24 Feb 2026 10:18:53
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com> <20260224005500.1471972-6-jmattson@google.com>
 <aZ3jQ1prL4dgG0-H@google.com>
In-Reply-To: <aZ3jQ1prL4dgG0-H@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 24 Feb 2026 10:18:41 -0800
X-Gm-Features: AaiRm52c8JAGwdPAWh6exvs0BRa9dbVeXCRtPz-0PH5xfDP68TtYBoYmhdbYOcE
Message-ID: <CALMp9eSk_TdpHj5OH7W1P8hnT=y4YCS8490KX5PfpG3R4TLt0Q@mail.gmail.com>
Subject: Re: [PATCH v5 05/10] KVM: x86: nSVM: Redirect IA32_PAT accesses to
 either hPAT or gPAT
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71641-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: F070F18B5EC
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 9:43=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> Overall, this LGTM.  For this particular code, any objection to using ear=
ly
> returns to reduce indentation?  The else branch above is a bit gnarly, es=
pecially
> when legacy_gpat_semantics comes along.
> ...
> I can fixup when applying (unless you and/or Yosry object).

No objection.

