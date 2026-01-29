Return-Path: <kvm+bounces-69533-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IMICNEA8e2kRCwIAu9opvQ
	(envelope-from <kvm+bounces-69533-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:53:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 11CE1AF317
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:53:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 27DC8300D0EB
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 10:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C3AA385510;
	Thu, 29 Jan 2026 10:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EDwGckfQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="S4Y8Rlnm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2D6385502
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 10:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769683875; cv=none; b=FOyoUyV5NCPziHy9QI7jpOxb64iD9ug1HwGBMRf3HXzwpTlsMiC4gGYO4EPZwV9Vk8Iut24802oQOlnuOl5wsdjZ5BRWXQKtCh6Z4HcUy0TAUvDRjwNtsNo9muxjs6LY7dJ5AEcLRtP6DsxpRWbXh/h1OMMB8cC9bjwL70+xDGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769683875; c=relaxed/simple;
	bh=7IhIJccrZmKOnCGC4kLZ+66KthHO2A7SceAXWZiXeO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eG2xbezVdCceb4zCbpaXKkBaERUmKI4txc/6Mwu8Wemfy+iSQQeHMKu5+w3Q+zgEXyDNykAggNBONGK9u1ySJLrXqx9KZJskDMp+KXdGnINm6EZZ5YFMZ6gOUwVsNDP2d12DD1l6TShhsFmldzwJfj2fEuIrgCTt5ny52T8FUD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EDwGckfQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=S4Y8Rlnm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769683868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hkN3odwc4xjpc2DM0clenXqHqr+SgiBsauZIR+93fN0=;
	b=EDwGckfQsKmrFjo9LNdcyfDbyPK+X/eeeOAA9eAZI9zGi+XTrIYCYbZQsDcXBOS4ibjxTQ
	H+2yo4zRo5FuDZZQpn/vZ8HQmA5mNeizc5/Ivgh+9zL63NNU+JyHMa55qxYSW8k6XQME/U
	S6gF1vT3sAjuCoyzdQaFCTUemA8st4c=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-KEktwEKfN1arVMdcOEVHkA-1; Thu, 29 Jan 2026 05:51:06 -0500
X-MC-Unique: KEktwEKfN1arVMdcOEVHkA-1
X-Mimecast-MFC-AGG-ID: KEktwEKfN1arVMdcOEVHkA_1769683866
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47ee3dd7fc8so7841875e9.3
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 02:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769683866; x=1770288666; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hkN3odwc4xjpc2DM0clenXqHqr+SgiBsauZIR+93fN0=;
        b=S4Y8Rlnm4n1wAciR+A1Mnprbsc1eNivBP++YEaSHK3WVadJ11iviisIJSZy9C6Um9e
         YXdMvoatBfrlDghyioHZscDdGvFzVdciaLmj2jPbJ1Ho6PJ04FEPkV/m820JDA17IXLO
         bAsRcJ9iN4zzMWU3//a+ME0XcDwn0UVANaAyns68KGWhZ2/o7XOVmJFMZ6s9fHFR3xVG
         mw9xvdC5PJQ/FZ6dJaAI/2bwq9KghPwMmzg5I76LDQgSVOLRO5qqD390OxHFPlSb8Ib7
         2GORnB/wI69smV/0iL6bZS/A76t3bIu6gLn1Mw3t7QPJWHX+VEAQ7Y4b6hEyxscXbTtR
         gJHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769683866; x=1770288666;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hkN3odwc4xjpc2DM0clenXqHqr+SgiBsauZIR+93fN0=;
        b=TzcPPcxY7lGbU8EufowHcPWK9syZMY6n05VW64gk1GuurlUrQfTfz/M/AdXj9IiNWe
         5Bq2RCMYqxzyjlAJ0/eEFtnZAb5er1Zp8jemW99VKmcu9RA1cQ30Fx0TAhE79ywuntF+
         N8PwR3Rju4od3FInwngDmZ0UCcwfhKdwpD1Bbk2L89nDUa7T74BXQ56FFd7viJOw/7PD
         JFSbCfb+ttpugmXnl8TNyecvvDpwIQZGrfuVZuEek1IRnsqwnuIhxEkTsDlLEmtMA/md
         HMQ6aMLOKOw8LH/40h25RmmpUdDjf4+y794VSgTwty+gPQ+Gp335aRudQk9sJPaK7FLo
         AInQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5CjJblKz7GIQSrMGZgcLLBYrhXnvig261P48Pz4uODi/bnXLGBSkH1UL/q7Y0AqTtvc0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4YeZFKYGdmY0BIWETkz/oEPlWSkcOLftM1UEnew6N8HEFsZL0
	TxGAzQK+++5jzWyfyhrzAMOy9pvfHwvTwBSBNMCYIKizWEv3VqWl7d9s72NLiu/X3O7Sf5HriWN
	GY0QLH1F9v2c52C4jjsG1jYdvJtXUbPRAOHBUevng6WqWV/IhjkS/gg==
X-Gm-Gg: AZuq6aKci8SJNbY2RwQu4I0RgHlM7/msqRimvLZrMb+mX10fhR3ilcUrWaOKl/A9SJr
	G8NpilQj2x4IAxXCJZZe0MkD3iDAEBBuIQdsC5TAh9FGuC714+abuPuFs44C7vgVWj5PBD8SHun
	aBr/Vu13uFTisWJXPXWyYcLINdO/arQNLNdmFQI6rq7ut2htAeE95XaYprK0VotosVDtrRBe49S
	T1K1wMNxYEmV1C4/E8LW82G2BRxKQbMrsy/lWokl+bmN2m1+Dyl9lrynlE1wYIMPXprrRjEte2+
	FSK6jqF2bi7qC81M8jSRRSuIIxMpVWKT6BprPSr6CYn642+zGFcKHGo3/cGRm8jeUf+FpCk9Dzt
	ewtNUhuHPWFjpnA==
X-Received: by 2002:a05:600c:3586:b0:477:561f:6fc8 with SMTP id 5b1f17b1804b1-48069c2abccmr124001005e9.5.1769683865730;
        Thu, 29 Jan 2026 02:51:05 -0800 (PST)
X-Received: by 2002:a05:600c:3586:b0:477:561f:6fc8 with SMTP id 5b1f17b1804b1-48069c2abccmr124000625e9.5.1769683865324;
        Thu, 29 Jan 2026 02:51:05 -0800 (PST)
Received: from leonardi-redhat ([176.206.38.57])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e131ce64sm14124650f8f.26.2026.01.29.02.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 02:51:04 -0800 (PST)
Date: Thu, 29 Jan 2026 11:51:01 +0100
From: Luigi Leonardi <leonardi@redhat.com>
To: Oliver Steffen <osteffen@redhat.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Igor Mammedov <imammedo@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Ani Sinha <anisinha@redhat.com>, kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH v5 1/6] hw/acpi: Make BIOS linker optional
Message-ID: <aXszoXaOgNGaHnTM@leonardi-redhat>
References: <20260127100257.1074104-1-osteffen@redhat.com>
 <20260127100257.1074104-2-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260127100257.1074104-2-osteffen@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69533-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[nongnu.org,redhat.com,habkost.net,intel.com,gmail.com,linaro.org,vger.kernel.org,amd.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leonardi@redhat.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 11CE1AF317
X-Rspamd-Action: no action

Hi Oliver,

On Tue, Jan 27, 2026 at 11:02:52AM +0100, Oliver Steffen wrote:
>Make the BIOS linker optional in acpi_table_end() and calculate the ACPI
>table checksum directly if no linker is provided.
>
>This makes it possible to call for example
>acpi_build_madt() from outside the ACPI table builder context.
>
>Signed-off-by: Oliver Steffen <osteffen@redhat.com>
>---
> hw/acpi/aml-build.c | 29 +++++++++++++++++++++++++++--
> 1 file changed, 27 insertions(+), 2 deletions(-)
>
>diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
>index dad4cfcc7d..6a3650076f 100644
>--- a/hw/acpi/aml-build.c
>+++ b/hw/acpi/aml-build.c
>@@ -1730,6 +1730,25 @@ void acpi_table_begin(AcpiTable *desc, GArray *array)
>     build_append_int_noprefix(array, 1, 4); /* Creator Revision */
> }
>
>+static uint8_t calculate_acpi_checksum(const gchar *data, size_t len)
>+{
>+    size_t i;
>+    uint8_t sum = 0;
>+
>+    for (i = 0; i < len; ++i) {
>+        sum += (uint8_t)data[i];
>+    }
>+
>+    return sum;
>+}
>+

In `hw/acpi/core.c` there is a `acpi_checksum` function that does 
exactly this. Can we reuse this to reduce code duplication? Currently 
that function is marked as static.

Thanks for all the work so far.

Luigi


