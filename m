Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3BFD15A35C
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 09:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbgBLIba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 03:31:30 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59263 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728426AbgBLIba (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 03:31:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581496289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oZOfuc0f9zTXdDLlba5WZgUvut3L8/MVnfbdrFnGVlk=;
        b=RhO3jD+7xFfhwSK3oe0WoZR9cH5/gA73KTDOP/hncOy6DgP2U7ro2OdygIgK8vhGUEmnlk
        yIUYr/Lk+RF9hM12o4eiunjJOKDnjP5SfgkHNKv2XWMT4CjMT/YMVcYQVLArWBHIsz/0vB
        1VBQoZJaVW030Ir6XN+sXrdReavfOOE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-3yPipWyrMqyzly1DuD_t5Q-1; Wed, 12 Feb 2020 03:31:28 -0500
X-MC-Unique: 3yPipWyrMqyzly1DuD_t5Q-1
Received: by mail-wm1-f70.google.com with SMTP id b8so251150wmj.0
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 00:31:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oZOfuc0f9zTXdDLlba5WZgUvut3L8/MVnfbdrFnGVlk=;
        b=iv4EX7987qodVluBKCSCiSnUaj3D66nj4WMo1wj0IKsyRaXqTVPArNP8qA+Dh3gmed
         KQKOGodTf4KejBQF55tEh5kiAuZaEQJt/LZfZPYL4ccnfulrEBk6EsiRCmxdgy56GRGK
         HFPrZxxFCXdc1eqrIJ2jWgOst0S/PbaEJw27tqu4QzsXK8Dbh5L2GgYnxc3ezJzwPT+Q
         k088ptvrqP5uw6KuI/yJbO5BLaFCYjrP0AkxwlTWYfl8/iCAxT+S1fs6M8GlT+AS1pt2
         ga4VbnRpAmHUsyfbbMr6XdyFqmPBTf/usPa2QWTjiLKppapmC4+f76sSw6H+ZhiuaeTV
         eksA==
X-Gm-Message-State: APjAAAXBrh/KGCw+s0navpFEFiZ7Kv4jYY3zxuIc/LxMk+ygB279bsok
        Ak8izCR/7kQNf4kdjeMfXhEeO8urMLpr7EUvPxFl7sI7JGAGPBP+qU8shT0uC/jrvvANapiNlxP
        g/uMLcaEfPIb1
X-Received: by 2002:a5d:534b:: with SMTP id t11mr13741806wrv.120.1581496286527;
        Wed, 12 Feb 2020 00:31:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqza9H25/6DFSL8gggVhZrtaOfNP+AdiOecReyyBui2YL/vcqKEAGwyfksGHrCPVHXAXdbPgkg==
X-Received: by 2002:a5d:534b:: with SMTP id t11mr13741777wrv.120.1581496286194;
        Wed, 12 Feb 2020 00:31:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id g128sm7071124wme.47.2020.02.12.00.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 00:31:25 -0800 (PST)
Subject: Re: [RFC] eventfd: add EFD_AUTORESET flag
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        linux-fsdevel@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kivity <avi@scylladb.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <20200129172010.162215-1-stefanha@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <66566792-58a4-bf65-6723-7d2887c84160@redhat.com>
Date:   Wed, 12 Feb 2020 09:31:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200129172010.162215-1-stefanha@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/01/20 18:20, Stefan Hajnoczi wrote:
> +	/* Semaphore semantics don't make sense when autoreset is enabled */
> +	if ((flags & EFD_SEMAPHORE) && (flags & EFD_AUTORESET))
> +		return -EINVAL;
> +

I think they do, you just want to subtract 1 instead of setting the
count to 0.  This way, writing 1 would be the post operation on the
semaphore, while poll() would be the wait operation.

Paolo

