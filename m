Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4376B2A1829
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 15:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgJaObN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 10:31:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726115AbgJaObN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 31 Oct 2020 10:31:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604154672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aA9VuaMFnL18TGcqtIxugEkPyfr4Z0tbfOBEppXhOYk=;
        b=WL1ptPnlDen3s3MHbmyHRehNzu/Rft2GwLbYczXSlzZSSaLCEZOthy8LbKkvUTqUSb22kz
        JGK5/qaNw+K9k1YenTleWy4RRgjoeFqAEsc7ENYITcZMrWU5BbcrILG8UWjBMXDV81VTGl
        iXN9v5irzWQ6GWzzX8Roa2JJlIqg3lc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-I2DRj_8MPI-vIPCBt-pdkQ-1; Sat, 31 Oct 2020 10:31:10 -0400
X-MC-Unique: I2DRj_8MPI-vIPCBt-pdkQ-1
Received: by mail-wr1-f72.google.com with SMTP id 2so4088276wrd.14
        for <kvm@vger.kernel.org>; Sat, 31 Oct 2020 07:31:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aA9VuaMFnL18TGcqtIxugEkPyfr4Z0tbfOBEppXhOYk=;
        b=eEAXrD+3HQeInFHHjYedctbTDAvcIoT6DorJ+1AGgwOsZnEhcaQINwWXAzAqGcD4kI
         G6Usf+FHN3WHZXWU5xkQFyyxubwJlpXycB+jwJsn6YEhNUoRlXew93cX27UR+a1uX55X
         MmXU8UdIqTrjKyuyKDvoFjlhms3TuY47PD5fiqxoRf6f/T3weeZxbglSsgfBabbggpox
         G990nTzcEuJMIy0MRiPlsYUEPX3BQov0mcSzCCwCy8x03SIJ1bQeHnaKOOBkQynPSHP0
         Yl5tVcxllqGO35ZZmVqJdqiMBsTNP7C4vmqGKcFBUNgyQFqOmCiybmaGTnheSCZPKSIl
         Vb8Q==
X-Gm-Message-State: AOAM530F3FywQMalIP/sZ4xk249X53m75bzCBFKewIozkyeK1CIvQ9FX
        IIXzFbV6aCFghKbV5lIjbiyxF+G6W7hwYuNiF1MfbfFve54eMhvfl/k684Zw4fB7oftXKfJWn6f
        do9mkQiR3P7Ni
X-Received: by 2002:adf:dc85:: with SMTP id r5mr10252523wrj.66.1604154669191;
        Sat, 31 Oct 2020 07:31:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJxurGjdJzZd7b14XmPPfvdfV0xgWxIhvgXQsW/9czykDLoGT2D65BNVYsKDtwRzqLqs8sOg==
X-Received: by 2002:adf:dc85:: with SMTP id r5mr10252511wrj.66.1604154669051;
        Sat, 31 Oct 2020 07:31:09 -0700 (PDT)
Received: from [192.168.178.64] ([151.20.250.56])
        by smtp.gmail.com with ESMTPSA id n4sm8453526wmi.32.2020.10.31.07.31.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 07:31:08 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 1/3] lib/string: Fix getenv name matching
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com
References: <20201014191444.136782-1-drjones@redhat.com>
 <20201014191444.136782-2-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7ffb378d-74eb-c92a-d4f4-510409f2c059@redhat.com>
Date:   Sat, 31 Oct 2020 15:31:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201014191444.136782-2-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/20 21:14, Andrew Jones wrote:
> +        if (strlen(name) == len && strncmp(name, *envp, len) == 0)
>              return delim + 1;
>          ++envp;
>      }
> -- 2.26.2


Slightly more efficient:

+        if (memcmp(name, *envp, len) == 0 && !name[len])

(strncmp is not needed since we know there's no NULL between *envp and
*envp+len, and after memcmp we know the same about the first len
characters of name).

Paolo

