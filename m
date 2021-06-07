Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576E439D90C
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 11:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhFGJuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 05:50:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230200AbhFGJuY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 05:50:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623059313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SkAIYLfm4/1iLuq6lTkLfCsF4nUOdcGlXrVl9zo8ayI=;
        b=cwgkYt0Sd7sPMTNTf8UMfIycuhqjUhQ4dCi3ez9wm6lkwwrlIEPKBk5E6zwa8t77gkgYs4
        +SH2cmXK159JsbIyHD+Zru/xA/ztrbY9BsAbfKkL0PKAGLy+DZ6sAb7eCS8KQpYTY7rY3E
        Mv8lEluVxaqUtK6HnW0LeYB2FDP92r8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-4E8ctzaXMqiXUOOeXtXmWw-1; Mon, 07 Jun 2021 05:48:31 -0400
X-MC-Unique: 4E8ctzaXMqiXUOOeXtXmWw-1
Received: by mail-wr1-f72.google.com with SMTP id x9-20020adfffc90000b02901178add5f60so7627936wrs.5
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 02:48:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SkAIYLfm4/1iLuq6lTkLfCsF4nUOdcGlXrVl9zo8ayI=;
        b=Ucz5Aa+ir2rHRCxw8mOl3ea/h+Et8wI5EdPsR6GcPFZC8DZKf5uKxHqiVVF0Z/P94P
         HjlkI2gU9e7rKZms4PhrFrlTI25Xnog8eNyz47RUbMkjMWvGPWldNegDgzRg2Hf0MTqz
         OvOsYFxB6vq7bQUa7K/+a+l5vnVHw1P4sl4qLNIY/SURc2ZySGJp+Y5VoTvzjSMy1jVy
         Rk1zfJ8sxgUIsb5c7stsN9epkmj+rVhF1zL1J6olOTcUYFPr6s7tMWpKXBufFPgnNYY3
         ysxqlr/l4ETQW1dXLAOH+dmzey1WaKJxe0vAkh7QV7H9mPwTNWNaZqglFJvHW4ei5ZWL
         x0eg==
X-Gm-Message-State: AOAM532LOpSKUnRCVmolEaT6yml0scrjow6FwrdaNHhnAfuzJkSTWUkw
        ICwjNhYHzG5DGVbcS4YUNVdDSw6lTtcmtfsFvAzmA/xyY4OoqpOUncbATP1EBieeWP9CZLePU3+
        ic9xDTJUIaLq6
X-Received: by 2002:a5d:474f:: with SMTP id o15mr16478000wrs.298.1623059310833;
        Mon, 07 Jun 2021 02:48:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySqGNpsM+Vgsi/Zd16E4qqjWCZsY1aXdUsaG1NGq4ZDuq3vXlNUvzQ/Wb2nF2N9KrcHJy6eQ==
X-Received: by 2002:a5d:474f:: with SMTP id o15mr16477987wrs.298.1623059310657;
        Mon, 07 Jun 2021 02:48:30 -0700 (PDT)
Received: from thuth.remote.csb (pd957536e.dip0.t-ipconnect.de. [217.87.83.110])
        by smtp.gmail.com with ESMTPSA id n42sm2022446wms.29.2021.06.07.02.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 02:48:30 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 2/3] configure: s390x: Check if the host
 key document exists
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20210318125015.45502-1-frankja@linux.ibm.com>
 <20210318125015.45502-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <6273f4da-9ce8-965a-dd57-bed917513674@redhat.com>
Date:   Mon, 7 Jun 2021 11:48:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210318125015.45502-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/2021 13.50, Janosch Frank wrote:
> I'd rather have a readable error message than make failing the build
> with cryptic errors.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   configure | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/configure b/configure
> index cdcd34e9..4d4bb646 100755
> --- a/configure
> +++ b/configure
> @@ -121,6 +121,11 @@ while [[ "$1" = -* ]]; do
>       esac
>   done
>   
> +if [ "$host_key_document" ] && [ ! -f "$host_key_document" ]; then

Use [ -n "$host_key_document" ] instead of just
  [ "$host_key_document" ] ?

With that fixed:

Reviewed-by: Thomas Huth <thuth@redhat.com>


> +    echo "Host key document doesn't exist at the specified location."
> +    exit 1
> +fi
> +
>   if [ "$erratatxt" ] && [ ! -f "$erratatxt" ]; then
>       echo "erratatxt: $erratatxt does not exist or is not a regular file"
>       exit 1
> 

