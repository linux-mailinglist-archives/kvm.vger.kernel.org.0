Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7319E39D90A
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 11:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhFGJtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 05:49:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230200AbhFGJtO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 05:49:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623059243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eDC5Gg9PMJ8D90yo3uH4QtVW+Fhvs8D9cIZIY9SdUQE=;
        b=MdKC/I3x9WND65QKs67Gud1AfA8XzcvX/y4K6SrxjU6IKFrXfZRQlrNdaAx3sKnSaT4oN/
        +Vjhhowsrs6M0QQfr36YGEipfag64dsrmY+5WTVOeCo+L4+B44lj/oT8xedgVRK2v21IPw
        ebDJkLQc56TKdDnjbmo6xS+WnykPtq4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-vfKfQaKPOEWkAXcx4L9WGQ-1; Mon, 07 Jun 2021 05:46:52 -0400
X-MC-Unique: vfKfQaKPOEWkAXcx4L9WGQ-1
Received: by mail-wm1-f69.google.com with SMTP id a25-20020a7bc1d90000b029019dd2ac7025so3898877wmj.1
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 02:46:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eDC5Gg9PMJ8D90yo3uH4QtVW+Fhvs8D9cIZIY9SdUQE=;
        b=uJWY5Dsc4LEfSd0mOfStEA3Tkivm+bhl8GvDpw7hpq1Gzsxf4CJdnRb6Lbdc0jROWZ
         uUBCB3+rajaI/xz1CO8kgF8csiKmbNPgd+ujwCEJ+DBtM8x/Ixh4Onc5/ex17PjgvztT
         aW93FCXyd8ScPF0BmoJ4D/86kwHqk/VvLg1WH+BvxLglXbcl57izx6h4c2PFjRgYVzVz
         EL5V7yR5xBW59INQ7J/7uZsfIG7tJiEXPBiRsKjyZZQEKZZCb27FsGHeZ8yrYeovIBPY
         JKJYCFqMx7kejYOl6/yylW6Y7n7oiH1aDZ/awomy3eyA05hC3N5aIn2tSOn46w+5ATNd
         FnDg==
X-Gm-Message-State: AOAM533gYOJaIFcpgWPsKt43d04//TCODEEBho5wrOl8NWTWgickFchj
        3LJ+xmsho3FxzpwE8tKIsTIMc0BxMI6NEeJhZce7TU9OauvciSjoX4w6NS+cZzmuLpscnAeg7kj
        nCRh3e86xXKAf
X-Received: by 2002:a5d:630f:: with SMTP id i15mr16045774wru.155.1623059210866;
        Mon, 07 Jun 2021 02:46:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7yUn1EBw8AQzKvxX7emcvlSe6/C0uAbBIg0m2i6ZiXMXtkO1i9hCVQynyYvhXd1llqIfeHg==
X-Received: by 2002:a5d:630f:: with SMTP id i15mr16045761wru.155.1623059210694;
        Mon, 07 Jun 2021 02:46:50 -0700 (PDT)
Received: from thuth.remote.csb (pd957536e.dip0.t-ipconnect.de. [217.87.83.110])
        by smtp.gmail.com with ESMTPSA id 32sm16773659wrs.5.2021.06.07.02.46.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 02:46:50 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Don't run PV testcases under
 tcg
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20210318125015.45502-1-frankja@linux.ibm.com>
 <20210318125015.45502-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <65c4318b-5319-48e2-5e81-b20a3de66e53@redhat.com>
Date:   Mon, 7 Jun 2021 11:46:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210318125015.45502-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/2021 13.50, Janosch Frank wrote:
> The UV call facility is only available on hardware.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   scripts/s390x/func.bash | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
> index b3912081..bf799a56 100644
> --- a/scripts/s390x/func.bash
> +++ b/scripts/s390x/func.bash
> @@ -21,6 +21,9 @@ function arch_cmd_s390x()
>   	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>   
>   	# run PV test case
> +	if [ "$ACCEL" = 'tcg' ]; then
> +		return
> +	fi
>   	kernel=${kernel%.elf}.pv.bin
>   	testname=${testname}_PV
>   	if [ ! -f "${kernel}" ]; then
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

