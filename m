Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A831A3521
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 15:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgDINtg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 09:49:36 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34101 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726641AbgDINtf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Apr 2020 09:49:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586440174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CDKoKGqtj/GJWfQ/EvttCrfHTdSN6Oe2CdcIahqhpRs=;
        b=HgFX0gq6UlmsYMkYWb1tIS/auu9phT9GlF2ZOTe0cbzNOgOvhV/AKJyM3O7pOoYp4qWJs0
        P0SEr27hDt4FPq55p5z13rJQ7CdNjhAByjcMSy9iTBK9raqFwNztwlQKDGYwc/AUJVCDkZ
        Z2ppyjqnl56BKOdg4rYgOIy+8rsk3Eo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-XxZ9I1AGMu2ur7P2ypysag-1; Thu, 09 Apr 2020 09:49:32 -0400
X-MC-Unique: XxZ9I1AGMu2ur7P2ypysag-1
Received: by mail-wm1-f72.google.com with SMTP id 72so2019490wmb.1
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 06:49:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CDKoKGqtj/GJWfQ/EvttCrfHTdSN6Oe2CdcIahqhpRs=;
        b=HQdHknZj1g768RHA7Hc4S3XH6pkF0QbV/hkaHUY9hTLnkmFxqgWgDGeM1nmQsBC73d
         YOetIwXA7CnHDCK3Hf1UWboWHUWM+w8W4/ERsLto2Do2emt0Mj4k94uScm6xqnFCxYr5
         GIEjv+04O43BEhBe4FliTCB6N6nZZ4CsXBferlK0QPbZ9gwCx+unmB5xtrbA9rsQrjJ0
         RHDk86+B3SvxnqQyOwlUFTNJEc00eS8GR6EIICflgGso8uwNkdgyevawYzz4B4iPiDH8
         GP4fZV9xMsCJlcSZdK04xNpP7x8AkoyQvhPhLWRSpQgO/oLop+N1xei6Wnh9GxkiPGyC
         8Gcg==
X-Gm-Message-State: AGi0PuZ+0mweB6yxdE3Z2kRQhATai1heqJs5zsLzBPGDWti6EVj9WB84
        eDzS45YiigtuHn6IkODL9tmf21I1N5v7GRVBCOVSxjX4SH6bG/50wEpAD4SKEFiB6pfu0N0itqr
        Ba7PO/8KbopZj
X-Received: by 2002:a1c:1bcb:: with SMTP id b194mr30259wmb.4.1586440171094;
        Thu, 09 Apr 2020 06:49:31 -0700 (PDT)
X-Google-Smtp-Source: APiQypI5EoaxnA5Xi/N+v0a+YCFP7Zq1V6hMieVImatAChiIFdmoCLeWMhkhOrhDfnM86eMUh9YUNQ==
X-Received: by 2002:a1c:1bcb:: with SMTP id b194mr30251wmb.4.1586440170920;
        Thu, 09 Apr 2020 06:49:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e8a3:73c:c711:b995? ([2001:b07:6468:f312:e8a3:73c:c711:b995])
        by smtp.gmail.com with ESMTPSA id b82sm4076909wmh.1.2020.04.09.06.49.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 06:49:30 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 1/2] svm: Add test cases around NMI
 injection
To:     Cathy Avery <cavery@redhat.com>, kvm@vger.kernel.org
References: <20200409133247.16653-1-cavery@redhat.com>
 <20200409133247.16653-2-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <16401e25-f484-a96e-2f49-53b5a7470754@redhat.com>
Date:   Thu, 9 Apr 2020 15:49:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200409133247.16653-2-cavery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/20 15:32, Cathy Avery wrote:
> +static volatile bool nmi_fired;
> +
> +#define NMI_VECTOR    2
> +

This one is already defined, so it is not necessary to include the
#define here.

Paolo

