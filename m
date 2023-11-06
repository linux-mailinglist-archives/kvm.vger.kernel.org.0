Return-Path: <kvm+bounces-787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1567E2968
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:06:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32541B20FB9
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F00CF2940D;
	Mon,  6 Nov 2023 16:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hx3B3qTX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E552D28E3A
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 16:06:11 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24561134
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 08:06:08 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-4084de32db5so40797665e9.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 08:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699286766; x=1699891566; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MeZXKteg9ly/LgC189oPLkONMw9yBgVhmCgiKF0kD7Q=;
        b=hx3B3qTXqSMsrjMNF1271E6YE4IjeMbr3aid75PiK6pgW4TVjA5RDCxGwbnbH+XK+i
         9U1vBNRs1HdTGGNMToBaB8yfoA3A9Z9DJNg05jW9Egr+in7uA99K4WNKIKT0ypjXgp3p
         Fd4iY2JM5fqjNBpkINZeURufxBIesgTyPpEM3jOW7Bz+hccHzLYSwaxOEFXAmw8Bu27o
         amyxdHR6Y27Ns09GpHo1ENAIxxc9ZPaU0XM/95MRJtJ0dTxuiKuirAujdlkT+7DnSed0
         LdmIrJGLNF+mzp0+0Owx3W5O1QjUf2D/zEOcmmbIPSd95XIDuQYBtoIV6tBMgqOVFj3F
         33Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699286766; x=1699891566;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MeZXKteg9ly/LgC189oPLkONMw9yBgVhmCgiKF0kD7Q=;
        b=lFhv9U4yrtTkiZqqcAzwTcIqkGjgS7hHSMaebjOrfEi6b8uBg1/2UhcRE2MiMIAe8A
         HXW+gmsMMV1nCsZceLAdWfu8aedDGMrU2ZawqZinpqjoh82vtHcth4sxhDQ5w9QsLciT
         G2FzW/LBslm/5aY6qeuEcgDkZGbqCd1JFANycrOLeiflqhmquQh6p31IEpfrOEjUeP+F
         /JM7x2rqLbJ7py8FW7gjGG/+fdrWjyXrtNCwVOt6ly0HA5jmUTK0/FSYzbhTum0ggGTj
         ire0+1BT2iehxkQSRcZVPv0VDedAIp3DlH6xxqWUsqkDXE/Z3PFVTraI51/QMlx4vI7a
         Havw==
X-Gm-Message-State: AOJu0YzypostiwJwRSZunQVEPsRYKHoW53YtiJWKiCZilF0vcTcbJvEL
	99xcHL6cF0ECwRY9sd55k7c=
X-Google-Smtp-Source: AGHT+IHSWnf3wN6plpUIgGebG8qT3uQ6MHwdZ3cvFdZB/eJDKIi8+G3R12MVZ1RUvoie9Yarv/csaQ==
X-Received: by 2002:a05:600c:1d19:b0:409:5a92:470e with SMTP id l25-20020a05600c1d1900b004095a92470emr102303wms.28.1699286766483;
        Mon, 06 Nov 2023 08:06:06 -0800 (PST)
Received: from [10.95.110.31] (54-240-197-231.amazon.com. [54.240.197.231])
        by smtp.gmail.com with ESMTPSA id h15-20020a05600c314f00b004094d4292aesm12576758wmo.18.2023.11.06.08.06.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 08:06:05 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <8531c820-549a-4979-9575-e659ab1b6659@xen.org>
Date: Mon, 6 Nov 2023 16:06:01 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v4 16/17] doc/sphinx/hxtool.py: add optional label
 argument to SRST directive
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony Perard <anthony.perard@citrix.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S. Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Jason Wang <jasowang@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 qemu-block@nongnu.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org
References: <20231106143507.1060610-1-dwmw2@infradead.org>
 <20231106143507.1060610-17-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231106143507.1060610-17-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/11/2023 14:35, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> We can't just embed labels directly into files like qemu-options.hx which
> are included from multiple top-level RST files, because Sphinx sees the
> labels as duplicate: https://github.com/sphinx-doc/sphinx/issues/9707
> 
> So add an 'emitrefs' option to the Sphinx hxtool-doc directive, which is
> set only in invocation.rst and not from the HTML rendition of the man
> page. Along with an argument to the SRST directive which causes a label
> of the form '.. _LABEL-reference-label:' to be emitted when the emitrefs
> option is set.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   docs/sphinx/hxtool.py      | 18 +++++++++++++++++-
>   docs/system/invocation.rst |  1 +
>   2 files changed, 18 insertions(+), 1 deletion(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


