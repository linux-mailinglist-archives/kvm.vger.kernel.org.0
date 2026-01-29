Return-Path: <kvm+bounces-69537-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCe3FR5Be2n6CwIAu9opvQ
	(envelope-from <kvm+bounces-69537-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 12:14:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 00513AF812
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 12:14:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 75B9630677BC
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 752E5385EEE;
	Thu, 29 Jan 2026 11:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NdOFp6lE";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MrRltamC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3CD385ECC
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 11:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769685019; cv=none; b=dIPyZ2+fT7bFVWV507psT8sdt0pV6J515YtsYM3ebWuuGPWfElvHnaNXKuw8S8DRR5OIDXsgQq0AyRenmR/eg52CLIoPssoMbAWEWNwqSDrIiYT+mfphaoCbuUR+4gg35Bf1Jq5FvsSef/iXJsf9P6RUFb6Dy2xCDUC7aZhwzv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769685019; c=relaxed/simple;
	bh=Fi+iITyE5r2wTjydTGcd0cjogC3PyTbhPMlTbn1FZxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YiNWWDqbF2YJEh9UlTiycASfT+GDn+2tERfL4AAEe2SI/U226+8OHCl+bxOuvaVbS7mN3/Pda3bxTPE9kGXsIaAF1iQoVVuLSxK3BW4x6kSKIPaDvfKuJrHOOdt7ODQWz80mbsmHEo9jg14wBqnxFgPrPxCzcR0NNH1pBMn74WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NdOFp6lE; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MrRltamC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769685017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YIQVwOXDCHDhYmBr10vNY+a4rvqiuUdxtT1SruNRqfY=;
	b=NdOFp6lERUV1iYz+bepQrYDNZwfhOUVjUh7JyWtd3Q9eqfnSdqXjHt7GqpdTFbCxon9ue4
	HbYvBT2GqThNTT9amh0L9ruK/sc54gHgbwH3vSeeVKX+c42PDPYgTQYnkTuIsbYbQQRZhd
	TncrJwPK5IuVggJoocfmY+pexLBk+zs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-WJB8_n6XNXOCONWWUS4zNQ-1; Thu, 29 Jan 2026 06:10:13 -0500
X-MC-Unique: WJB8_n6XNXOCONWWUS4zNQ-1
X-Mimecast-MFC-AGG-ID: WJB8_n6XNXOCONWWUS4zNQ_1769685012
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4801c1056c7so4628025e9.2
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 03:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769685012; x=1770289812; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YIQVwOXDCHDhYmBr10vNY+a4rvqiuUdxtT1SruNRqfY=;
        b=MrRltamCeCNBmK6XPekt76KfprvE/4nJNhK9SLdc4cra/al37nfWiVY21BgwYAA08Z
         awIuiEVAdd+z7LTpM92oBAsud9bZMOjt4D/GFeR3+JPCtYI2vGcW8LM7jKMiEnQvsSO/
         tBgBme16pTFMsE3G+8Egy0ZJcgbNaL2YJ/qIXH/5Mp0/XizIzCj6qaB313bLL+6bTFCm
         DbGHwPUamaDeAoTu6KziaRYL4Ob0rsF6HXbhr++zcvPIBXveJys5rcCKMhslrMvp908p
         yA/2w/LITMLhOHvAqcypUCDxWEDH1qVA5UnCK3/pJwamXP7ossIM31bW71SFP6PfftGF
         snRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769685012; x=1770289812;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YIQVwOXDCHDhYmBr10vNY+a4rvqiuUdxtT1SruNRqfY=;
        b=ef5CbCJGobS2tFkI2Xe+4TS1Iafo8T0xX4NzaNq0iYsirTDcD27SHSzx6dFLZUSYyQ
         mSrN5gFrR5/CROlkVpKNQX1QOnjp6B+sIjV774bi1lL45gwQ5F5tqM1pCvIdDsKBystQ
         ma2G8BEl4UByGS+0AQ1gdWMlQ+Uo0pObTez3WJ3gJ/dEqeSEA8k9eAiXzNLHCg7naM5I
         d8bZZ3JpK/9N896hZygbZcQD3egXbWECcrW+79fgjJbAtzqwvvRmLN1derCj5pFzb6Oy
         9GH9EWXWrw7DTiWSOWW6yv4YHLW8sL4WfysMR5rlAC+0uI8i2CDet00N3T/hYfQdDo6e
         PwgA==
X-Forwarded-Encrypted: i=1; AJvYcCX17l+qUiOsSzRt0E+CF23pdNG0ky8bemRlgqRZqBJRt5pTK7CC5x5alrH/G4Dyqx1oIiw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmZGNRSy+hA3Jx1jpOR1ioLnATb2ZU+Y1ewKzRcCbyS+SBQUwv
	8h+FYxnfeDzNAK1eyASEGwXKpRsPU96Xbh1aK7zOJmT2Um8QNFdmUYE8pGQ5HaxGoR+F3RvRZaf
	WDzzMvOolGw/pUxgEzTGLCm+BV6uXyl+tPsGeToDdrOoDUGZ6QjPKnw==
X-Gm-Gg: AZuq6aIbfUKVf0aI38BaGyLJE9FfkYfoWdrsyMEgOMtN7UvkTqCZa6bPfGW9w20Sa7H
	PmbVpm4nYIWkg8yij+wz6KKgFalN3i/dRpEwTjTdUChi5QsRtfiRrPyBSdDzR+4ansQu5PkFhnK
	aS+C/zEqqyI5dmJeWSpcU1BfU9EPepaH68Cq4eAuktOy76VoWtDOZzBsO5ZlNfwD7lrQdwGipw9
	kyECuHw6mFPmfqb+QTHnlGwSshAbPrQ+cCryLw7ZSr6MvKF+8KYgVB56fkW1Q6BUqyMNBT3Ei/0
	zYt8Zpk+37dVzDe14jSmoq7NRCZOzHZ6bO5lrZ8SPNfk/KILdLE8h00ozYio8nBGtLE7Xsj1APQ
	ha/OfblBVA1AMJw==
X-Received: by 2002:a05:600c:e40b:b0:479:3a86:dc1c with SMTP id 5b1f17b1804b1-4806a5bef0fmr83006665e9.36.1769685012013;
        Thu, 29 Jan 2026 03:10:12 -0800 (PST)
X-Received: by 2002:a05:600c:e40b:b0:479:3a86:dc1c with SMTP id 5b1f17b1804b1-4806a5bef0fmr83006315e9.36.1769685011546;
        Thu, 29 Jan 2026 03:10:11 -0800 (PST)
Received: from leonardi-redhat ([176.206.38.57])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10e4762sm13396916f8f.6.2026.01.29.03.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 03:10:11 -0800 (PST)
Date: Thu, 29 Jan 2026 12:10:08 +0100
From: Luigi Leonardi <leonardi@redhat.com>
To: Oliver Steffen <osteffen@redhat.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Igor Mammedov <imammedo@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Ani Sinha <anisinha@redhat.com>, kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH v5 4/6] igvm: Refactor qigvm_parameter_insert
Message-ID: <aXtAAzNeJxr9usOo@leonardi-redhat>
References: <20260127100257.1074104-1-osteffen@redhat.com>
 <20260127100257.1074104-5-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260127100257.1074104-5-osteffen@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69537-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 00513AF812
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 11:02:55AM +0100, Oliver Steffen wrote:
>Use qigvm_find_param_entry() also in qigvm_parameter_insert().
>This changes behavior: Processing now stops after the first parameter
>entry found. That is OK, because we expect only one matching entry
>anyway.
>
>Signed-off-by: Oliver Steffen <osteffen@redhat.com>
>---
> backends/igvm.c | 50 ++++++++++++++++++++++++-------------------------
> 1 file changed, 25 insertions(+), 25 deletions(-)
>
>diff --git a/backends/igvm.c b/backends/igvm.c
>index 213c9d337e..0a0092fb55 100644
>--- a/backends/igvm.c
>+++ b/backends/igvm.c
>@@ -513,31 +513,31 @@ static int qigvm_directive_parameter_insert(QIgvm *ctx,
>         return 0;
>     }
>
>-    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
>-    {
>-        if (param_entry->index == param->parameter_area_index) {
>-            region = qigvm_prepare_memory(ctx, param->gpa, param_entry->size,
>-                                          ctx->current_header_index, errp);
>-            if (!region) {
>-                return -1;
>-            }
>-            memcpy(region, param_entry->data, param_entry->size);
>-            g_free(param_entry->data);
>-            param_entry->data = NULL;
>-
>-            /*
>-             * If a confidential guest support object is provided then use it to
>-             * set the guest state.
>-             */
>-            if (ctx->cgs) {
>-                result = ctx->cgsc->set_guest_state(param->gpa, region,
>-                                                    param_entry->size,
>-                                                    CGS_PAGE_TYPE_UNMEASURED, 0,
>-                                                    errp);
>-                if (result < 0) {
>-                    return -1;
>-                }
>-            }
>+    param_entry = qigvm_find_param_entry(ctx, param->parameter_area_index);
>+    if (param_entry == NULL) {
>+        return 0;
>+    }
>+
>+    region = qigvm_prepare_memory(ctx, param->gpa, param_entry->size,
>+                                    ctx->current_header_index, errp);
>+    if (!region) {
>+        return -1;
>+    }
>+    memcpy(region, param_entry->data, param_entry->size);
>+    g_free(param_entry->data);
>+    param_entry->data = NULL;
>+
>+    /*
>+     * If a confidential guest support object is provided then use it to
>+     * set the guest state.
>+     */
>+    if (ctx->cgs) {
>+        result = ctx->cgsc->set_guest_state(param->gpa, region,
>+                                            param_entry->size,
>+                                            CGS_PAGE_TYPE_UNMEASURED, 0,
>+                                            errp);
>+        if (result < 0) {
>+            return -1;
>         }
>     }
>     return 0;
>-- 
>2.52.0
>

LGTM

Reviewed-by: Luigi Leonardi <leonardi@redhat.com>


