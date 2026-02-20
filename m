Return-Path: <kvm+bounces-71396-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eH9fNQ0WmGki/wIAu9opvQ
	(envelope-from <kvm+bounces-71396-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 09:06:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 46D6316583A
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 09:06:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2FFAD3071A5F
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 08:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55DF1335568;
	Fri, 20 Feb 2026 08:04:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9472DD5E2
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 08:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771574650; cv=none; b=Attq8sME+POzd2LVJYnYJWrv57aRacxCTQISL/ZfmEBZd1N7MJ3GTdz5NzghZ+p2eV2AinE9IUcpCXsBRz6GATq5N5j9rgZYShX8yGMAJ3Muv8mftGoqqFl+fe3Jq7K0OSPeUY5jBUGxWdr01bbcp1FRCoqNA2LMJoAyPMcHkMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771574650; c=relaxed/simple;
	bh=vGADSqxID99POmMSYRKWxfqsD0RW8oK82U7YrGJKqks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N/WYzDwf/Se8enMLyiACwqCmNHbl5c1JyIld0ZInZgYvdmskU7U7a2ena/BtLVyO1q401Fwy6nk5iRkcQy8vIKftih0gLV6n5Ou5cbYolOmqte/Yym/xzubvjUqlDxX6LPMZMOvx/IUsJ95DKoxRdKK39okfE7Q9cfWwOfIGnSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ooseel.net; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ooseel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-45f171cb842so1279632b6e.1
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 00:04:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771574648; x=1772179448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yxL+WdrxcUzVCuoQ2517iVUnhtiEO5j9HGMzSGdIHB4=;
        b=TgS6ilp+yt/zdi3d0Oydt+TkzMDRIJMtZZhuR7EBAAuASm98PTFGXfXLIz7sivbKmp
         zxGnUvCFbNG+agZoCEegtTCMvE8Gop+X0vkyKr1D2KSzc0NePGIRgOU0UAiVpvQnPFSX
         Zqsn/p2nKD5GidrK+SDfiJAm93fir/v5/XzP7OuV9WYq3qaC3MOQidNf8YBba+6jYaiC
         oGXi4phAOclC88W5eGL3jWNQfiE1kq+aYYsi8FhNProXAgOT77/DGslhLGdSD8zcImdn
         xseVNtqkF8K8y5hojM61ZnB6eAzmhr9xbNlFdvFf7OFBEzuAIl2H/Wo2W3GR1iZrp/oP
         hgSw==
X-Forwarded-Encrypted: i=1; AJvYcCUAG6H6H6anCK6GIBYXXmXlvnKOw8LCA7Zwu/u+iv2UK3W6W2bqX8VVu5n+8NFNnwDm//E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBd2QOGbVXc67H0a+lXScEjfO4kdMMT0czt0QaO6A7lc+6zX9+
	HKeyZd4JCqzesW+Sa4ciPbJvqPy/u5OljH/36C6VsUT3zI/3+2CpHPV55MJ78fsCOiM=
X-Gm-Gg: AZuq6aKZ0aIOfTcIsIe8IwEWSfGzhqRiak3bEW9TogZngZMtv0jgMtHdyoPT5RteEZM
	wdgPbSpdYES4SS0t4j8CjiSgaB1Nv7m4okyJ0mb8TZvR7/Z2fl7w7Cwng2YfPZmDecS4UZDjYkZ
	lXlc2q51IyhWGJgMSVVFWChc+LaKP0jKyef0BKwSe26fq5lpKIpmOO0Or1UX4D9rYJWj8gmXtvA
	CdsGdx7ax+aZNNFjBHrktuYFEgUVy2h9ENxajQ4nOA/CJGJTC4hufvzYsMIVrnZNBPN5Ft1lE1z
	3oagrNc8ZOo9Zfm/O8iCX1AS4lo5iQfEcUr9yiSEEX4k49Z8K9Ri4VZ2WzO99MmSTTz15abM0Ee
	HKjcM581X1nDZvw29u8PIFYeipiKDdkm+FdqCmxnnSmsbNSspijlqrOGqwDQcEMZ2dZIYVlVdyz
	qATmJ+7wcSGP9iWuUa2fC+Y+Ih9Oh/dtyz4mXIreXlg9ESLSRpn9JZHnU=
X-Received: by 2002:a05:6808:170f:b0:45a:6e83:fbff with SMTP id 5614622812f47-464275b2a62mr2135479b6e.20.1771574647822;
        Fri, 20 Feb 2026 00:04:07 -0800 (PST)
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com. [209.85.160.46])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaeb42708sm27155023fac.0.2026.02.20.00.04.06
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Feb 2026 00:04:06 -0800 (PST)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40fb2789476so2551246fac.1
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 00:04:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVBoITsuTULGtZwfBbUr/UjbpzclI3IWBgMP3Bgw4tBBM+KcaKxnb2nvccFDzswsMj+rdA=@vger.kernel.org
X-Received: by 2002:a05:6820:1c94:b0:66e:6a46:bfc5 with SMTP id
 006d021491bc7-679b0e0bd48mr2560855eaf.12.1771574646207; Fri, 20 Feb 2026
 00:04:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210072530.918038-1-lsahn@ooseel.net>
In-Reply-To: <20260210072530.918038-1-lsahn@ooseel.net>
From: Leesoo Ahn <lsahn@ooseel.net>
Date: Fri, 20 Feb 2026 17:03:54 +0900
X-Gmail-Original-Message-ID: <CANTT7qhsPkvwnog2V0Q+vsq4Z2axE+Q9Mce9_X-=acRONFfQuw@mail.gmail.com>
X-Gm-Features: AaiRm51bvSffxJ_AQo5ca2WaIMGMNmz_-eFEDwwLYDWNAuqU-l1pmsLEvT-z6IQ
Message-ID: <CANTT7qhsPkvwnog2V0Q+vsq4Z2axE+Q9Mce9_X-=acRONFfQuw@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: Use memdup_user instead of kernel stack to
 allocate kvm_guest_debug
To: Paolo Bonzini <pbonzini@redhat.com>, 
	"open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: lsahn@ooseel.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71396-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[ooseel.net];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lsahn@ooseel.net,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.980];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ooseel.net:email,mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 46D6316583A
X-Rspamd-Action: no action

Bump up the patch in order to remind again.

2026=EB=85=84 2=EC=9B=94 10=EC=9D=BC (=ED=99=94) PM 4:25, Leesoo Ahn <lsahn=
@ooseel.net>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Switch to using memdup_user to allocate its memory because the size of
> kvm_guest_debug is over 512 bytes on Arm64 and is burdened allocation
> from kernel stack.
>
> Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
> ---
>  virt/kvm/kvm_main.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 5b5b69c97665..bc0a53129df7 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4592,12 +4592,15 @@ static long kvm_vcpu_ioctl(struct file *filp,
>                 break;
>         }
>         case KVM_SET_GUEST_DEBUG: {
> -               struct kvm_guest_debug dbg;
> +               struct kvm_guest_debug *dbg;
>
> -               r =3D -EFAULT;
> -               if (copy_from_user(&dbg, argp, sizeof(dbg)))
> +               dbg =3D memdup_user(argp, sizeof(*dbg));
> +               if (IS_ERR(dbg)) {
> +                       r =3D PTR_ERR(dbg);
>                         goto out;
> -               r =3D kvm_arch_vcpu_ioctl_set_guest_debug(vcpu, &dbg);
> +               }
> +               r =3D kvm_arch_vcpu_ioctl_set_guest_debug(vcpu, dbg);
> +               kfree(dbg);
>                 break;
>         }
>         case KVM_SET_SIGNAL_MASK: {
> --
> 2.51.0
>

