Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A90A313417C
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 13:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgAHMQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 07:16:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59723 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727212AbgAHMQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 07:16:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578485810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9W9sTpBkdGRsL3XuUTDPK6s4GdXG+QpcxPJ3i7Ao+xI=;
        b=D+0RdB6GG1//ngIcbdwFUnlZipzviZd4dICH0b9pO8K3cg7J/2qlap+iaSfSr6cFU/DDAn
        Sbkufto0ADg5RxwH0Z3L5xTg6bbI6qWCqYg4Q5xXtn1ZuuNVEDl5FMrf60ey1Gb1Z6B8Ta
        8n8WR/fb80gyxhjZ+ZsMzvYvqLwcx0Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-IgseM1UQMMuO4jXdR3pCPA-1; Wed, 08 Jan 2020 07:16:49 -0500
X-MC-Unique: IgseM1UQMMuO4jXdR3pCPA-1
Received: by mail-wm1-f71.google.com with SMTP id l11so3977294wmi.0
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 04:16:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9W9sTpBkdGRsL3XuUTDPK6s4GdXG+QpcxPJ3i7Ao+xI=;
        b=fvS+Ky01iRvS9lGMF2w24VHBHrDGKgkOnGAwUClfo+0VoI8gpxQdSztI5WkS3SYTKF
         c/aDxqhTdpfdwN+w8KLnOwDZpYNqyj87hCfv4maaXR+p++uyda+tDAzTPSfNMo1QuG9h
         7VwnnpyHRN4cffAnOCD5/+81mPbN1UlKQtUyMVR8Es2IKbtjCGbdGOwFZ6f5kD3jJZUb
         BU+bLwN6staeb5qg21AhfAHjV8kn+ntCBBXAGnjokJeDPfFOJmKWTYT3AUtv7nqH8QP5
         0rR5Kqj92p2+dsRhoQfq1r3+uvkITxeVrbeLaUc++3JLm2oFVJWsApyfCryPd3DmXtpt
         fvsQ==
X-Gm-Message-State: APjAAAW9zejUcjw+JDlwKHjmKgWsxQtKe7R4Px9tNRQ8jr8okVhHW1pw
        1WUg241xWgpF9irWobn6SDiJcJHzu+uKxniNVg+fqwZ+L/pNuM9mBHjz3O0XyTLVjWIt8Mzw7n9
        7nXyOhcQbKMIH
X-Received: by 2002:a05:600c:244:: with SMTP id 4mr3399340wmj.40.1578485808577;
        Wed, 08 Jan 2020 04:16:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqyw8wxSZKFMV6/j733IMWOpvX8FnAcYhGDTbV2NWyiuTJEUI1+29LDk7Ozv7aZC28jGe2FpAA==
X-Received: by 2002:a05:600c:244:: with SMTP id 4mr3399318wmj.40.1578485808380;
        Wed, 08 Jan 2020 04:16:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id n8sm4133584wrx.42.2020.01.08.04.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 04:16:47 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 0/4] Improvements for the x86 tests
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Drew Jones <drjones@redhat.com>
References: <20191211094221.7030-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9e750f02-a1ba-aaf3-4509-dff38babf9e0@redhat.com>
Date:   Wed, 8 Jan 2020 13:16:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191211094221.7030-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/19 10:42, Thomas Huth wrote:
> QEMU recently changed the error message that it prints out when a
> kernel could not be loaded, so we have to adjust our script in
> kvm-unit-tests accordingly.
> Once this is fixed, add two missing tests (setjmp and cmpxchg8b) to
> the unittests.cfg and CI pipelines.
> 
> Thomas Huth (4):
>   scripts: Fix premature_failure() check with newer versions of QEMU
>   x86: Fix coding style in setjmp.c
>   x86: Add the setjmp test to the CI
>   x86: Add the cmpxchg8b test to the CI
> 
>  .gitlab-ci.yml       |  4 ++--
>  .travis.yml          |  6 +++---
>  scripts/runtime.bash |  2 +-
>  x86/setjmp.c         | 22 ++++++++++------------
>  x86/unittests.cfg    |  7 +++++++
>  5 files changed, 23 insertions(+), 18 deletions(-)
> 

Applied, thanks.

Paolo

