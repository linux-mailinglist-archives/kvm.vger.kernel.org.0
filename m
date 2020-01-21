Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDBF0143CB5
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 13:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgAUMYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 07:24:36 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30149 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726968AbgAUMYg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 07:24:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579609474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2JRami1vqERtvVOhWdic7ftSfhU5/AM2PS8umediSqQ=;
        b=CDoZ+FRbuTegZPROtVuTwBn3WOTMF/8tx6/d8t8sp6oDOSyV7cO3bzGDojU50zIAiI88Tm
        I/ZQrMQSwtIEpJvqGykHWn0igFNbkQZkFuV9ZuwK8CS3QHvz4QdIg50i/ftw9F7SEtNMHR
        bjYcJb4AqCadv7OpoNRmtK2LQk6WyYc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-T6aMLAOCOhK5L0_M5Y_6Vg-1; Tue, 21 Jan 2020 07:24:33 -0500
X-MC-Unique: T6aMLAOCOhK5L0_M5Y_6Vg-1
Received: by mail-wm1-f69.google.com with SMTP id h130so550555wme.7
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 04:24:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2JRami1vqERtvVOhWdic7ftSfhU5/AM2PS8umediSqQ=;
        b=q2TBGVXvP5ChWzhFEgVG8I+9e6FeTwMgiuwVDrOw329oHC33eA+tS2FZjjA9M/SZU3
         zTJksyHolGpyCfx4vqu+5Pgwn4jXmgnmzDJlfGNlHMygMrMgzCmVDqsm65vmXJO00ZH5
         PTkx+gGchEU2dN9oPPxpbhvx1nOSvANN4yH890WokzRyZiy7Gm9eHmU3DWZ8Bml8pxkH
         tXAot2H+aR1E0LLXnzqlRznW/soWsLuDrtI4OmIN/I2EVBUsBD2fU5BaFSUsMldroCln
         qZq78QfGhVD9v7iDSN+4v2MmFeB2inszBIpCeVOaO+qV2LGEzk/YQcwfEEvwUaugqCEM
         ec3A==
X-Gm-Message-State: APjAAAWQFpGzVwNN7M6eQeiF14kzgzUXwdFtmG41re/kjy41+I0D34iZ
        N0+8p7Z5rlFRuvyUD51JJaqttpinSzq7mJyWBvaSuJNnwjppGagSDIbIgz0N+imevRegWmaWYAH
        gDGTZVXLemmq2
X-Received: by 2002:adf:e6c6:: with SMTP id y6mr4914504wrm.284.1579609472349;
        Tue, 21 Jan 2020 04:24:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqwNvH/P6poOhLh9BEBTM0W39aC5Gdgb79gu8uifJcP0NDeYfjycB4x/ep68tvfF9lucHS4Q4Q==
X-Received: by 2002:adf:e6c6:: with SMTP id y6mr4914477wrm.284.1579609472031;
        Tue, 21 Jan 2020 04:24:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id f12sm3844116wmf.28.2020.01.21.04.24.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 04:24:31 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests 0/3] arm/arm64: selftest for pabt
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com
References: <20200113130043.30851-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bbd1f024-2f6c-d963-57f9-e6d7f2939fda@redhat.com>
Date:   Tue, 21 Jan 2020 13:24:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200113130043.30851-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/01/20 14:00, Andrew Jones wrote:
> Patch 3/3 is a rework of Alexandru's pabt test on top of a couple of
> framework changes allowing it to be more simply and robustly implemented.
> 
> Andrew Jones (3):
>   arm/arm64: Improve memory region management
>   arm/arm64: selftest: Allow test_exception clobber list to be extended
>   arm/arm64: selftest: Add prefetch abort test
> 
>  arm/selftest.c      | 199 ++++++++++++++++++++++++++++++++------------
>  lib/arm/asm/setup.h |   8 +-
>  lib/arm/mmu.c       |  24 ++----
>  lib/arm/setup.c     |  56 +++++++++----
>  lib/arm64/asm/esr.h |   3 +
>  5 files changed, 203 insertions(+), 87 deletions(-)
> 

Looks good, are you going to send a pull request for this?

Paolo

