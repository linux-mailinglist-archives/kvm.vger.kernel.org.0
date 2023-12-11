Return-Path: <kvm+bounces-4051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 021D080CE82
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 15:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 766861F212C6
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 14:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D07B748CFE;
	Mon, 11 Dec 2023 14:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wNDq9+Wr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850A59F
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 06:36:45 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-54f4b31494fso6414899a12.1
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 06:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702305404; x=1702910204; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hnlDRuUqfo4QrqddI/qWEwk9SWh3sjr/XXfcP2vUeRg=;
        b=wNDq9+Wr1V/HEJknxRt5wJ39c6fqZQJoapUFfPupvT/mBI5VPM9lQbMQ5PghILgRGm
         3i7HefGl7RhoQaIMDcP/kbMTFtQy10WM09EHg86s89q2oQpgPMOsBSNEpCl9mzrxsdZU
         971L7IGAu+hrbLr056jftKzDW/yadD/PgA6SIpMQ1vYV2whrePMzYHdTMacWAmiDDBoP
         NYdoK+pPYT/lKbaU2Mnh4k5ekUoT8QieZ5s/k4NumzSpdKAYAj+81LEPlw+kc9GWsz8w
         tKQ2H6vDJq5Fu9YWVj/CMdw2igQZVzbwv6cLL3sYUqC8c+Jzr/b+JFvXFjyQOCCR2ZY4
         JRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702305404; x=1702910204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hnlDRuUqfo4QrqddI/qWEwk9SWh3sjr/XXfcP2vUeRg=;
        b=mfYgVeDJ/Oe6266+NnDsv+DJGGj8byLyCeGG6DXIjAf0OxsDLz60LKWt/MNoFymljs
         A9UYRD2xkwldYzYJRoe4lMq8K46fwvD7SfSiZnQD12PkejvIOQzR9shZztVCKJnt/dLO
         oR62/6fXVFrHLR58+o/7fbZGi4AlTZQywogLvtgvy/p63UYaL3DgdyD0da9GdrJbcEe9
         Akd9BYEnAXMaMlUChOf0OZelZrqzUDlJDTPmITnrVeuvbmIKw8uF7kZSULhogKAJcw4Y
         Y2Gi0HHcsnOIarL0rXwpYIHD0RoXoC4ibXu266JfAK6HYtsfUu5D0KtMmfbMo3s1rGyC
         Ogww==
X-Gm-Message-State: AOJu0YxgPIkGLIt+j9HK1SExeb/nxVt3eJKjA9Lxo4otieQQu+g+LXkT
	g7utG9//ofojqmz0XNbG5jU2J3WjF2vI87SzcsEiVQ==
X-Google-Smtp-Source: AGHT+IHPVGkHY5T66mLFfrATbBqb9h4CV21aGKeNWVd4/WzZsB76YC8N8NW8EyeJHL66q2Xoxoz1hmp/Ltsje7hwOjo=
X-Received: by 2002:a50:ef17:0:b0:54b:38f:7263 with SMTP id
 m23-20020a50ef17000000b0054b038f7263mr5484022eds.8.1702305403990; Mon, 11 Dec
 2023 06:36:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231123183518.64569-1-philmd@linaro.org>
In-Reply-To: <20231123183518.64569-1-philmd@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 11 Dec 2023 14:36:33 +0000
Message-ID: <CAFEAcA8S7Ug8uFpvDO9FarLpLhTr_236H8gOK=dEOWQZe-3zgg@mail.gmail.com>
Subject: Re: [PATCH-for-9.0 00/16] target/arm/kvm: Unify kvm_arm_FOO() API
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Nov 2023 at 18:35, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> Half of the API takes CPUState, the other ARMCPU...
>
> $ git grep -F 'CPUState *' target/arm/kvm_arm.h | wc -l
>       16
> $ git grep -F 'ARMCPU *' target/arm/kvm_arm.h | wc -l
>       14
>
> Since this is ARM specific, have it always take ARMCPU, and
> call the generic KVM API casting with the CPU() macro.



Applied to target-arm.next for 9.0, thanks.

-- PMM

