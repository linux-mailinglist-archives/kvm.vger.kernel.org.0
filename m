Return-Path: <kvm+bounces-70922-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6MNuEmWGjWkZ3wAAu9opvQ
	(envelope-from <kvm+bounces-70922-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 08:51:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A625C12B04C
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 08:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F08963095E48
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3148E2BE037;
	Thu, 12 Feb 2026 07:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZEt9akWM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AufQSfA9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338E542A96
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 07:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770882654; cv=pass; b=pwAwj37e6ZRWM698xu4RZJ7PjOWCNHEqKsJLFcvVv5zo/92oFya2496faNUDFVZ2jujG/V0IYQijdtJC3xpS7vWGEx0Sx37vBEVjLiBNJm9ZvFAqEh/WnSNOL5oUeLEYE4Zfy1jnuYu3OQLJitBY3r7ai7eastbzXwKFucnqCUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770882654; c=relaxed/simple;
	bh=1UeQjDPvMXEwGU5TgH9yi6lOamvhhMwVYhnuF8x8SAQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bu+KMY3QN6zo+a8ZC3tIT7hkpmiUm7W13Xcw1526g3Hw4/GxrMr7u43NVv70V3SuklJBwItSUW4MKZi7eXISvPgyBLhvuuCGYOGGTQxum5Y+1+Ww+aVb1y07MpAdSwND7aM3MEBEESLCZdE/Clk21QLQydVwYmMpPnIVT5bAxDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZEt9akWM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AufQSfA9; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770882652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qOvRFjuhnTRc3QDh3S9/EmKKtwVyoWkoQTnGpYdJhTQ=;
	b=ZEt9akWMfUNF6eNcjDImRbY+HPlMdVrSQ6Itsdqzb/FrqKD7a4Z0FNhK24SpIycc7KgPdl
	TDqQREdazZKJGaY1kjZ81NkFd5FmemI7Szl6VD9cxeQWquhZbhNtuCVlHyqrUkjYs7JU7c
	TpYLWrwGyOnSecBq66kcOf6bpO61050=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-jr_oAS7YPfee-OIF4y3JmQ-1; Thu, 12 Feb 2026 02:50:50 -0500
X-MC-Unique: jr_oAS7YPfee-OIF4y3JmQ-1
X-Mimecast-MFC-AGG-ID: jr_oAS7YPfee-OIF4y3JmQ_1770882649
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-483101623e9so24864065e9.3
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 23:50:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770882649; cv=none;
        d=google.com; s=arc-20240605;
        b=XDFDhfzZVIrRVqGwcHsLT+yn0uqL9r0/NwAyscw1vS8Lb/YZY5Kp2o6xwOu9cUejrK
         Jm1xPC26gFV3pQi7jXH7EMuHlXAuXU1xbXR3DWJWw+03S0cpCIkqYxC6CN8XwWXiPrDd
         9jawaZsb5U4ZU3pYhNnpYMkZpHJP5DjpvDIOMK+8+BXVmArMVP69hOKYNoPBJ4U2NWZv
         vSP2Y9Ex8VNjDIAquPX613h9S3+CZbScNAV8UovchSnI9dj61ziqVtQYa4xIPXRhqWPa
         LBWlXez/4TIdP8cu/z8kGcZY2IrPl2HxlsEMOP/Zz0nbpCEPbe1Mq6uad3/L7ZZs7OXo
         Ufpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=qOvRFjuhnTRc3QDh3S9/EmKKtwVyoWkoQTnGpYdJhTQ=;
        fh=z5zfDS1jKzsDI7+EPXtx7IZnnIDsBSpkfBhCPB7lO7M=;
        b=KbEUmLrxNIWhi0dhfVGCGPpWXibKVqWmJvTMiaRZ3JBEArJvA9GE2bY/XWV5A+qS5U
         3QiXCOAUnBfJZVfN4jeW3/0FSyvnmGWX6wBeTdl0ov8CmztCqSqg0mYEJSb5p5cgtBfr
         0QsBG3n3KAPFE74ndpi77Wl87e5p3M7GmVEM3zdqFQP2yT9/523UgmeyRCtk0l5MLyl6
         2E+HLmANwN2uLjFcYNNUt6f1vIRKvKhfGtjAo6pZwJejELy7Fk6U94MqzksKmLQO8pFy
         qwYtOKzAoxcKwTBHr2zl9mvVhEI7t0qql/F1BP4Y0Vxr4+eRNwYmf5gDPMc1C4OrtjXa
         oN6g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770882649; x=1771487449; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qOvRFjuhnTRc3QDh3S9/EmKKtwVyoWkoQTnGpYdJhTQ=;
        b=AufQSfA9cgVA751UlU13NakI/HQp5NzvHo2sC8Qt+d87Tofx6Z3INTLcEDnB/3lt/a
         +lJrEwKH3+nbJopZagMPCqnawxCv41aTPeLOe8o1WXC3ktS500nE3lHUhyg44ArUXiWn
         islXiyr95PbI4NHHz/iO+qUFM+G1LmOwjPwRXfjgl/0UvBx5GkBlAwyCdjmf9u2BLQ8F
         yFLouz1b1RJbNYoRX4i22BOhqcbH9a+A3lmpugE3Tn5wu9RkiMBr1qQZiX/E4qj89ZM3
         gfyYDWDYimagZIkXCbcD3Wzys+0vf3SSiuYA/urCH7Xd91HbA6pLmxSSCcbOkAtzIbiU
         MBgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770882649; x=1771487449;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qOvRFjuhnTRc3QDh3S9/EmKKtwVyoWkoQTnGpYdJhTQ=;
        b=Jvb60eD2l1kk6BdK/siGIS4zRI98ksID1ya4MqFsGzhj0EwwdkIxuHw7qT9nSj/85b
         6IwA3tB7U4A1rPyNWSmknytQ7/31+3j9kjkbjBAuheddVWlJvlpGK60ch8M0FTgv+2Qy
         dxWydP2SxbtTmnCOBLyREStNfLuTshuPUGUeZDCq+O/6DNoU/aa+npj0TulWtU4wV6e/
         k4iyL8QvNWbjtPWIB8pqJToCVulktE6NN6NnuT/wUZUPVlP33z/Qb9xUZ3sydBRMlzJB
         A6jFiDRwMBQpQBn/MCrCQlav/xy+5ANrvhywGJw+gHVoiYty94NUuNG9WsFFDBw0fuRE
         FWOw==
X-Forwarded-Encrypted: i=1; AJvYcCWazrn4gZkmV1CYPpaNmf2w9LDR8F4FIWxuAAyXm0jsz+xreRbVFn+KhT1litQdgW+CNwQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1qzIWnilsG+g2uNvHA1sewAkgWtBMikz8leS6ByW4zHdxBhQj
	7oImHP639wJsLgi1kw3BcKKhxfYCoZzJ6Zuay01OT2ORkyp/fd6+UVzxGrQG7FzKrzX1k74f49Y
	olwfc/SovbKOt5XSOpcO4mwudPhIf6K4Vd3jwfCwaa5dXw+bJuDm7yFdExSioy6Ce9F/cCGdA6U
	A6nNi/vc6uZmJjxTY286Wx0XbBpr9r
X-Gm-Gg: AZuq6aIktH1AL9ZWZu4oK5OftjYb5vqfs4fCg0MBzNzVLRPzxjSUrI2lXl99XfpNgxB
	6iM09X2Y0+HmnF6RQMZjjp5LkjGa79Sl6wPdvJEBZ59oYd42n8vgOpF1CeUhtWegNQ9pid/zKx/
	bPqQnfhJChMqR5tgUAvzzkU9z5qlTYszi2/TUVKQTZIrS10wHFtFbKOzJLr3DWTfoedmEfEVxxg
	31j3PaAY6bSezcunTTufK7c4KamFRqkNnNc8YRGatQT8opTQeiX4C6oEvaKncv+ntc=
X-Received: by 2002:a05:600c:3585:b0:480:19ed:7efa with SMTP id 5b1f17b1804b1-48367178a3dmr18824615e9.36.1770882649403;
        Wed, 11 Feb 2026 23:50:49 -0800 (PST)
X-Received: by 2002:a05:600c:3585:b0:480:19ed:7efa with SMTP id
 5b1f17b1804b1-48367178a3dmr18824355e9.36.1770882648998; Wed, 11 Feb 2026
 23:50:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260212062522.99565-1-anisinha@redhat.com> <20260212062522.99565-18-anisinha@redhat.com>
In-Reply-To: <20260212062522.99565-18-anisinha@redhat.com>
From: Prasad Pandit <ppandit@redhat.com>
Date: Thu, 12 Feb 2026 13:20:32 +0530
X-Gm-Features: AZwV_QjBRWdpW4G_f3yYhxUO7DE4LNWCUoX6PV-rLcFVJtj7YapP-US9hxJwr1U
Message-ID: <CAE8KmOwa1M_F9Qfs-XXRhaJZx7jiwQDfwDk7U2shJi8SLa+y9Q@mail.gmail.com>
Subject: Re: [PATCH v4 17/31] i386/sev: add migration blockers only once
To: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Zhao Liu <zhao1.liu@intel.com>, kraxel@redhat.com, kvm@vger.kernel.org, 
	qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,fedoraproject.org:email,mail.gmail.com:mid];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ppandit@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70922-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+]
X-Rspamd-Queue-Id: A625C12B04C
X-Rspamd-Action: no action

On Thu, 12 Feb 2026 at 11:58, Ani Sinha <anisinha@redhat.com> wrote:
> sev_launch_finish() and sev_snp_launch_finish() could be called multiple times
> when the confidential guest is being reset/rebooted. The migration
> blockers should not be added multiple times, once per invocation. This change
> makes sure that the migration blockers are added only one time by adding the
> migration blockers to the vm state change handler when the vm transitions to
> the running state. Subsequent reboots do not change the state of the vm.
>
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>  target/i386/sev.c | 20 +++++---------------
>  1 file changed, 5 insertions(+), 15 deletions(-)
>
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 66e38ca32e..260d8ef88b 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -1421,11 +1421,6 @@ sev_launch_finish(SevCommonState *sev_common)
>      }
>
>      sev_set_guest_state(sev_common, SEV_STATE_RUNNING);
> -
> -    /* add migration blocker */
> -    error_setg(&sev_mig_blocker,
> -               "SEV: Migration is not implemented");
> -    migrate_add_blocker(&sev_mig_blocker, &error_fatal);
>  }
>
>  static int snp_launch_update_data(uint64_t gpa, void *hva, size_t len,
> @@ -1608,7 +1603,6 @@ static void
>  sev_snp_launch_finish(SevCommonState *sev_common)
>  {
>      int ret, error;
> -    Error *local_err = NULL;
>      OvmfSevMetadata *metadata;
>      SevLaunchUpdateData *data;
>      SevSnpGuestState *sev_snp = SEV_SNP_GUEST(sev_common);
> @@ -1655,15 +1649,6 @@ sev_snp_launch_finish(SevCommonState *sev_common)
>
>      kvm_mark_guest_state_protected();
>      sev_set_guest_state(sev_common, SEV_STATE_RUNNING);
> -
> -    /* add migration blocker */
> -    error_setg(&sev_mig_blocker,
> -               "SEV-SNP: Migration is not implemented");
> -    ret = migrate_add_blocker(&sev_mig_blocker, &local_err);
> -    if (local_err) {
> -        error_report_err(local_err);
> -        exit(1);
> -    }
>  }
>
>
> @@ -1676,6 +1661,11 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
>      if (running) {
>          if (!sev_check_state(sev_common, SEV_STATE_RUNNING)) {
>              klass->launch_finish(sev_common);
> +
> +            /* add migration blocker */
> +            error_setg(&sev_mig_blocker,
> +                       "SEV: Migration is not implemented");
> +            migrate_add_blocker(&sev_mig_blocker, &error_fatal);
>          }
>      }
>  }
> --

* 'sev_mig_blocker' is a global static variable, so it's the same
blocker (address) added each time, maybe add_blocker() should do a
check to avoid duplicates.

* Otherwise it looks okay.
Reviewed-by: Prasad Pandit <pjp@fedoraproject.org>

Thank you.
---
  - Prasad


