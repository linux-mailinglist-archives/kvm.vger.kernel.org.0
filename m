Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F001218040F
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 17:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgCJQ4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 12:56:07 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49065 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726442AbgCJQ4G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 12:56:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583859365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j3qfwe4RA12qs3/yjv/r1NIyEKt8LSMmQD8gHLGHKf8=;
        b=c6TQTMfL6jjgAFQgwdUDAxMLv1q6YcndkROo6J/PGbRg9QO4KBlvInttEYUFGrDdgaShzY
        ohKfI28rP5vb7yXy4MKDBE9V/+Ec3QX0xNfh1qDciwPWIW/B3rD9hN/bSL+bUmuXLtxQyB
        8PHPDWdIUWoVV/AxJzkcGq1+PN+MJbY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-Bw8JF-5qPaesMExw2WwIfg-1; Tue, 10 Mar 2020 12:55:55 -0400
X-MC-Unique: Bw8JF-5qPaesMExw2WwIfg-1
Received: by mail-wm1-f72.google.com with SMTP id r19so620703wmh.1
        for <kvm@vger.kernel.org>; Tue, 10 Mar 2020 09:55:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=j3qfwe4RA12qs3/yjv/r1NIyEKt8LSMmQD8gHLGHKf8=;
        b=qZqWkTa18YopP1TAS8guKDzKUYG0kTwdXsYDTPdRRGUPv2W9LIms5DaOcOtJLpfCM8
         aboaeR3h02kR3FGo8BId8H0MGbypzUi8tlfEmiVbYz3z7i5P7MLfDgiWNVJoOB7eWR1C
         rqYwk8TRqz6jM0a/yOpVX48f3yrHQm0/j9dvpC/tmitsTVhonJ3Pmk6sqNFgSOgIRt44
         VZexC/aYv9geJ4pQgxBqzoTKzsWYjahL5UEg6zDIJNJzBWn0Z5YGXFD/lUMe4z5y3CWC
         SxGxDpEglEFWZt/0ryPJVRga+8ecivn4eooGX3AMmJ5hxiO/PeiVWJcWaVLYaOjRsHdv
         gr3w==
X-Gm-Message-State: ANhLgQ39WpGn747QqfLXG9t+aJENpadImPLi/DDIz88+vq7koyI/bAAW
        GY2RJSVVIPZyRymkwTgsR111CmxTEqNzJQETgWVvweRbSi4k40LDMrxVPbu/CTp1lQunIca6y1F
        N8xKfAdH7w++F
X-Received: by 2002:a5d:5089:: with SMTP id a9mr28974811wrt.187.1583859350877;
        Tue, 10 Mar 2020 09:55:50 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuPaKS4BThnZhT5XzCWWQoBNzywQ/daG1qZmeVnIS8G8VRLR3EYLcfUJvusx+p1DhMq1vmmzw==
X-Received: by 2002:a5d:5089:: with SMTP id a9mr28974791wrt.187.1583859350694;
        Tue, 10 Mar 2020 09:55:50 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b5sm24992416wrj.1.2020.03.10.09.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 09:55:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v4 1/5] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
In-Reply-To: <20200309182017.3559534-2-arilou@gmail.com>
References: <20200309182017.3559534-1-arilou@gmail.com> <20200309182017.3559534-2-arilou@gmail.com>
Date:   Tue, 10 Mar 2020 17:55:49 +0100
Message-ID: <87k13sb14a.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jon Doron <arilou@gmail.com> writes:

> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  include/uapi/linux/kvm.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4b95f9a31a2f..7acfd6a2569a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -189,6 +189,7 @@ struct kvm_hyperv_exit {
>  #define KVM_EXIT_HYPERV_SYNIC          1
>  #define KVM_EXIT_HYPERV_HCALL          2
>  	__u32 type;
> +	__u32 pad;
>  	union {
>  		struct {
>  			__u32 msr;

Sorry if I missed something but I think the suggestion was to pad this
'msr' too (in case we're aiming at making padding explicit for the whole
structure). Or is there any reason to not do that?

Also, I just noticed that we have a copy of this definition in
Documentation/virt/kvm/api.rst - it will need to be updated (and sorry
for not noticing it earlier).

-- 
Vitaly

