Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD58B3A5F90
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 11:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbhFNJ7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 05:59:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20444 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232730AbhFNJ7R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 05:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623664634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ljCWDPI+DdOXsJXVk0IodoSksgjdTbxJDmUUvdhHn1k=;
        b=HY8MxaV1OniVpZKWGxvnGyN6aaPG7HKFZIfGHbrWBiOKBbQFtRNCHrb/CnxlLlczwFkslZ
        UdHnJ7dED2UHDCzWcvg/anUNBxFuRsFOrbicu18yIAIRHiiH43xoQ2dChfdTk1rWVJpNcA
        5seJyjza79JAN4yRYvTbvzFtYVB1M60=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-PR26syplPMWAfb2C04KEJQ-1; Mon, 14 Jun 2021 05:57:13 -0400
X-MC-Unique: PR26syplPMWAfb2C04KEJQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 703D4192376B
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 09:57:12 +0000 (UTC)
Received: from localhost (ovpn-113-175.ams2.redhat.com [10.36.113.175])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CA2D660938;
        Mon, 14 Jun 2021 09:57:08 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, lvivier@redhat.com,
        david@redhat.com
Subject: Re: [PATCH kvm-unit-tests] generators: unify header guards
In-Reply-To: <20210614090723.30208-1-drjones@redhat.com>
Organization: Red Hat GmbH
References: <20210614090723.30208-1-drjones@redhat.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Mon, 14 Jun 2021 11:57:06 +0200
Message-ID: <87y2bcydjh.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14 2021, Andrew Jones <drjones@redhat.com> wrote:

> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  configure               | 4 ++--
>  scripts/asm-offsets.mak | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/configure b/configure
> index 4ad5a4bcd782..b8442d61fb60 100755
> --- a/configure
> +++ b/configure
> @@ -332,8 +332,8 @@ if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>  fi
>  
>  cat <<EOF > lib/config.h
> -#ifndef CONFIG_H
> -#define CONFIG_H 1
> +#ifndef _CONFIG_H_
> +#define _CONFIG_H_
>  /*
>   * Generated file. DO NOT MODIFY.
>   *

Already changed in "header guards: clean up some stragglers", seems that
patch has not been applied yet.

> diff --git a/scripts/asm-offsets.mak b/scripts/asm-offsets.mak
> index 7b64162dd2e1..2b9be2b439f4 100644
> --- a/scripts/asm-offsets.mak
> +++ b/scripts/asm-offsets.mak
> @@ -17,8 +17,8 @@ endef
>  
>  define make_asm_offsets
>  	(set -e; \
> -	 echo "#ifndef __ASM_OFFSETS_H__"; \
> -	 echo "#define __ASM_OFFSETS_H__"; \
> +	 echo "#ifndef _ASM_OFFSETS_H_"; \
> +	 echo "#define _ASM_OFFSETS_H_"; \
>  	 echo "/*"; \
>  	 echo " * Generated file. DO NOT MODIFY."; \
>  	 echo " *"; \

For the second hunk:

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

