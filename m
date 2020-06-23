Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64757204AFF
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 09:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731211AbgFWH1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 03:27:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48156 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731054AbgFWH1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 03:27:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592897256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qLYOujDDx1aBVpzEpAYgWCS7UouFMa1b4GD1woVG6zc=;
        b=ZGctLeWYMMRpUyeEpJdl7KOqD9YRBSkffPIxIEn70t0IfdPnNRF6dOf6ygnJXLzHFmjef2
        7HDWvZsgUTIl5E1yuh6RDMReL+wGuX7t2myucLyLkNeWzOmjJEhHxJk1AFRYe1dGoAD5lG
        Aw5eE/k0NN8jwz8AtS65OotZkFxm3q4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-yhUBIU64NfSb1UaRYiITbA-1; Tue, 23 Jun 2020 03:27:35 -0400
X-MC-Unique: yhUBIU64NfSb1UaRYiITbA-1
Received: by mail-wm1-f71.google.com with SMTP id t18so3115515wmj.5
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 00:27:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qLYOujDDx1aBVpzEpAYgWCS7UouFMa1b4GD1woVG6zc=;
        b=WmSrSf8N25dsM+Nx3ooQ6Pp9QFvjx9HYPMqWAm/UHq+ZoiCPbCYSedPr+dcCMwo3/5
         egjRvVva5Uw9LD0IggSIHHFG11RcXtdyGKxI4bVzB4Q2yoM8wLT2klQqtBi4E5oQOhSP
         Xq381q2gtluEIMMY8G5eLHfvv4rBpGWeiDpK2TMvA/U9WtrztMKUhkyD/KdFReN7gX1x
         mmi54mB3PBhwg2mDT27sweYEaam2IYHGhp9UpjTOmiQJv6zqCHmBukAaIuffagdKXsZp
         CZ7M5MNJ4P8sPQIDDIfDvhrstsQU1hLTUh48t7CjN0cLC97lD+kgwdXYrcOyTPSfib+p
         EsBg==
X-Gm-Message-State: AOAM533Z3AIbM29nY5cpJP1a4H8sLhUTbGH8QlogSMXRWjpP8prGJG/K
        uHUaiCUhuYvYjwwzuukRMOST0dFdOVtoeCk2V37qbJ9r5rFR0zU3wYKyvmA0YR7m7Hdm3R0+6XZ
        qbQ7gXimVOXQY
X-Received: by 2002:a5d:54c9:: with SMTP id x9mr24766743wrv.247.1592897253836;
        Tue, 23 Jun 2020 00:27:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQYkWVH3VEDx+syDsPmDus0VeHj8xuspDjggksaf4Dx9vOkybGi/V7R2c3xM0jNuWLcp4VKQ==
X-Received: by 2002:a5d:54c9:: with SMTP id x9mr24766724wrv.247.1592897253623;
        Tue, 23 Jun 2020 00:27:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24f5:23b:4085:b879? ([2001:b07:6468:f312:24f5:23b:4085:b879])
        by smtp.gmail.com with ESMTPSA id a12sm11131695wrv.41.2020.06.23.00.27.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 00:27:33 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v1 4/8] lib/alloc.c: add overflow check for
 calloc
To:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com
References: <20200622162141.279716-1-imbrenda@linux.ibm.com>
 <20200622162141.279716-5-imbrenda@linux.ibm.com>
 <efb517a5-f5d7-e870-2bb6-654690121c20@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ddb0a038-ff81-afe3-94da-ee53387a4994@redhat.com>
Date:   Tue, 23 Jun 2020 09:27:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <efb517a5-f5d7-e870-2bb6-654690121c20@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/20 07:57, Thomas Huth wrote:
> cc1: all warnings being treated as errors
> 
> Claudio, any ideas how to fix that?

I guess it's just

diff --git a/lib/alloc.c b/lib/alloc.c
index f4aa87a..6c89f98 100644
--- a/lib/alloc.c
+++ b/lib/alloc.c
@@ -1,5 +1,6 @@
 #include "alloc.h"
 #include "asm/page.h"
+#include "bitops.h"

 void *malloc(size_t size)
 {

> Paolo, could you maybe push your staging branches to Githab or Gitlab
> first, to see whether there are any regressions in Travis or Gitlab-CI
> before you push the branch to the main repo? ... almost all of the
> recent updates broke something, and analyzing the problems afterwards is
> a little bit cumbersome...

Ok, I'll catch you on IRC to discuss this.

Paolo

