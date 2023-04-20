Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67276E962B
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 15:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbjDTNqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 09:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDTNq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 09:46:29 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41CF5B88
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 06:46:28 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id he13so1266404wmb.2
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 06:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681998387; x=1684590387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=axU7XEy16fAD4uBkqSOy63MFeDTbMdldzOob35I518o=;
        b=PkH9/RtUE1SjHdbDNR1abE13D1pvIPBtI8KhiWVOTK/UWQtSsCmXrNzzh1/UJe0EIK
         0yZbvk7+QWE9Be6tEPJeOyoOSuSb5PWh9S2EYxtlqrJDIdkyGXgOZ+rCrfZuocjBUfBq
         DgK583YBnw3/4ZQBDU+vm4ZtytVG9gVzFIZNc7ulC9ZIvdibqEY9wN9SFwrbZup+fa+R
         PvCC5PbFCJHjVnSQz+Jb9JZTzhRiH/akCThmvrhrm7zdAfi7SY06KlkDN9JEgW9EpB2i
         wR6w/iqlrulWqafrObJh7NmjcJWxTojhSc0wVFhELZlA1lvD5j8nTJWkCHQWMbUy/cxb
         4XZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681998387; x=1684590387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=axU7XEy16fAD4uBkqSOy63MFeDTbMdldzOob35I518o=;
        b=ItXnv1EK0bTA+nKIkJlLfxBr/s6QmKTl8b5i/iX6fqW95Ig2JzCcy/YQO7RjrpqsO5
         n+OFZ4PhDHLgW3XpEm7Lu5Ae9lKN29KwTZrF1fGOmZjn2eaz/QKMmHCYF58koAk20glI
         cWqv2lzWs1dFMUfB2PMvv9eWmq8AKBvspFD8/EmeO0RWo/SuuTEqhXlzfTIBmjtUa1E/
         VjjClxtcD/clVvgMeVj4c9Y8qJeSgGdEmS42M1Fj33Teny/SYp9MRkWZqK/RAPAR4jco
         qIEUB8syIjSCNCed/EJVPUtbFXsKFGFOenhEJPFh4/6uFDczslaIelBsl5JVP+4serA8
         hy9g==
X-Gm-Message-State: AAQBX9e9H2meN//y/RNa+mLcKAWtI1LpqlhFEQaGblFzfZToAYnzbP+W
        2v4icHYYIK9hTkHIiGYDxSzYk8oT18T3FzYijGg=
X-Google-Smtp-Source: AKy350ZzmILp/toFxvcIobZBmfaN/xZOuepKu6OHoira4TNtJ+IgUmKqodo325GElpmAhajkkNgnhA==
X-Received: by 2002:a7b:cd87:0:b0:3f1:6f4a:a3ad with SMTP id y7-20020a7bcd87000000b003f16f4aa3admr1409758wmj.2.1681998387151;
        Thu, 20 Apr 2023 06:46:27 -0700 (PDT)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id v9-20020a05600c444900b003f173be2ccfsm7549581wmn.2.2023.04.20.06.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 06:46:26 -0700 (PDT)
Date:   Thu, 20 Apr 2023 14:46:27 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool v2 2/2] virtio/rng: return at least one byte of
 entropy
Message-ID: <20230420134627.GA282884@myrica>
References: <20230419170136.1883584-2-andre.przywara@arm.com>
 <20230419170526.1883812-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419170526.1883812-1-andre.przywara@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 19, 2023 at 06:05:26PM +0100, Andre Przywara wrote:
> In contrast to the original v0.9 virtio spec (which was rather vague),
> the virtio 1.0+ spec demands that a RNG request returns at least one
> byte:
> "The device MUST place one or more random bytes into the buffer, but it
> MAY use less than the entire buffer length."
> 
> Our current implementation does not prevent returning zero bytes, which
> upsets an assert in EDK II. /dev/urandom should always return at least
> 256 bytes of entropy, unless interrupted by a signal.
> 
> Repeat the read if that happens, and give up if that fails as well.
> This makes sure we return some entropy and become spec compliant.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Reported-by: Sami Mujawar <sami.mujawar@arm.com>
> ---
>  virtio/rng.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/virtio/rng.c b/virtio/rng.c
> index e6e70ced3..d5959d358 100644
> --- a/virtio/rng.c
> +++ b/virtio/rng.c
> @@ -66,8 +66,18 @@ static bool virtio_rng_do_io_request(struct kvm *kvm, struct rng_dev *rdev, stru
>  
>  	head	= virt_queue__get_iov(queue, iov, &out, &in, kvm);
>  	len	= readv(rdev->fd, iov, in);
> -	if (len < 0 && errno == EAGAIN)
> -		len = 0;
> +	if (len < 0 && (errno == EAGAIN || errno == EINTR)) {
> +		/*
> +		 * The virtio 1.0 spec demands at least one byte of entropy,
> +		 * so we cannot just return with 0 if something goes wrong.
> +		 * The urandom(4) manpage mentions that a read from /dev/urandom
> +		 * should always return at least 256 bytes of randomness, so

I guess that's implied, but strictly speaking the manpage only states that
reads of <=256 bytes succeed. Larger reads may return an error again or
(if you read the man naively) zero bytes. We could increase the chance of
this succeeding by setting in = 1 and iov_len = min(iov_len, 256)

Thanks,
Jean

> +		 * just retry here in case we were interrupted by a signal.
> +		 */

> +		len = readv(rdev->fd, iov, in);
> +		if (len < 1)
> +			return false;
> +	}
>  
>  	virt_queue__set_used_elem(queue, head, len);
>  
> -- 
> 2.25.1
> 
