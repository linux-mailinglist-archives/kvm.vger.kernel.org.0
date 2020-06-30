Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA1820F9E7
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 18:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389893AbgF3QyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 12:54:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55175 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731280AbgF3QyM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 12:54:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593536050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pXmamib9WjdIQWclbtNv+Mtf3LRDcnCnedPdsW7rtqo=;
        b=afgm2PYkw8Lg8J6Yyjlw49/3V/kniMrnPBwnMyYyQKyKdL4DTWe9mcpGIuAtnS380gHGRV
        L4UKijDTAflYU3jp1jnrLtyUsVe5yaif+RHdz4Hoa1yuIbGDuzm296HO329pzXx6DW1MgY
        4fjwN3oXmY6cCQ5WbB5/uMSq5+WR1gU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-JBsnC_h9Nme6fk2yw_RyPA-1; Tue, 30 Jun 2020 12:54:07 -0400
X-MC-Unique: JBsnC_h9Nme6fk2yw_RyPA-1
Received: by mail-wr1-f71.google.com with SMTP id j16so13719209wrw.3
        for <kvm@vger.kernel.org>; Tue, 30 Jun 2020 09:54:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pXmamib9WjdIQWclbtNv+Mtf3LRDcnCnedPdsW7rtqo=;
        b=o68cPjEDLOjvNnp69q2Wkdyn2L2q+VTTE6Dd4YT9+He/jDdUx6rahsvVGSClv5MaYw
         eWLGohu7rdrLDoJ9sIVBFiP8PXVOaSj4Q58+f1jQtmNTi6q22T4BTHOaBvZ8j/fmQRSW
         9M8qWRL4/p5FITdWl54lUYmh2gpwi6YgurhKNYDJhRifvkxZpPziqmhk3qV+lqvO2g6u
         PnkrDsusKmLdtUYq1NrcW1YwXS67EAu0KdzHdp+E9dSDJ2wEzudiQQpqdJtLmw4hyr6m
         bWGetYGUFiF5ZuJ65b77Tz6XKdKDPytPtfPkM7XZ1fa+/PG/S841znIr8sLd6nf8Yc8O
         Ibrw==
X-Gm-Message-State: AOAM5323WRDsPlmO48DX8VfBZgTXy2MvCpqG9AOCdYinnBPaVJWx98NA
        Y2V6aeMLAY7kv17Hmn9PK39DgztUhP7nTQ8RZNwHnk73cSKJgYXwQIUh+V0YiUOxSdGpb18HjK5
        f167qHCo3fs41
X-Received: by 2002:adf:eec8:: with SMTP id a8mr22963149wrp.421.1593536046020;
        Tue, 30 Jun 2020 09:54:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbzDEkQoe89/m3RRoO03z6agDDw19BZf29Q3NgMiaPn74wnB91OVrEdiyS+amyb3Y2sYal/Q==
X-Received: by 2002:adf:eec8:: with SMTP id a8mr22963136wrp.421.1593536045825;
        Tue, 30 Jun 2020 09:54:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:acad:d1d4:42b8:23e4? ([2001:b07:6468:f312:acad:d1d4:42b8:23e4])
        by smtp.gmail.com with ESMTPSA id 65sm4318938wre.6.2020.06.30.09.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 09:54:05 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 4/5] x86: svm: wrong reserved bit in
 npt_rsvd_pfwalk_prepare
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org
References: <20200630094516.22983-1-namit@vmware.com>
 <20200630094516.22983-5-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <306265c5-0593-397b-3b8f-eb237d1425cc@redhat.com>
Date:   Tue, 30 Jun 2020 18:54:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200630094516.22983-5-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/20 11:45, Nadav Amit wrote:
> According to AMD manual bit 8 in PDPE is not reserved, but bit 7.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  x86/svm_tests.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 92cefaf..323031f 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -825,13 +825,13 @@ static void npt_rsvd_pfwalk_prepare(struct svm_test *test)
>      vmcb_ident(vmcb);
>  
>      pdpe = npt_get_pdpe();
> -    pdpe[0] |= (1ULL << 8);
> +    pdpe[0] |= (1ULL << 7);
>  }
>  
>  static bool npt_rsvd_pfwalk_check(struct svm_test *test)
>  {
>      u64 *pdpe = npt_get_pdpe();
> -    pdpe[0] &= ~(1ULL << 8);
> +    pdpe[0] &= ~(1ULL << 7);
>  
>      return (vmcb->control.exit_code == SVM_EXIT_NPF)
>              && (vmcb->control.exit_info_1 == 0x20000000eULL);
> 

Wait, bit 7 is not reserved, it's the PS bit.  We need to use the PML4E instead (and
then using bit 7 or bit 8 is irrelevant):

diff --git a/x86/svm.c b/x86/svm.c
index 0fcad8d..62907fd 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -49,6 +49,11 @@ u64 *npt_get_pdpe(void)
 	return pdpe;
 }
 
+u64 *npt_get_pml4e(void)
+{
+	return pml4e;
+}
+
 bool smp_supported(void)
 {
 	return cpu_count() > 1;
diff --git a/x86/svm.h b/x86/svm.h
index 645deb7..8d688b6 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -365,6 +365,7 @@ typedef void (*test_guest_func)(struct svm_test *);
 u64 *npt_get_pte(u64 address);
 u64 *npt_get_pde(u64 address);
 u64 *npt_get_pdpe(void);
+u64 *npt_get_pml4e(void);
 bool smp_supported(void);
 bool default_supported(void);
 void default_prepare(struct svm_test *test);
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 92cefaf..b540527 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -824,13 +824,13 @@ static void npt_rsvd_pfwalk_prepare(struct svm_test *test)
     u64 *pdpe;
     vmcb_ident(vmcb);
 
-    pdpe = npt_get_pdpe();
+    pdpe = npt_get_pml4e();
     pdpe[0] |= (1ULL << 8);
 }
 
 static bool npt_rsvd_pfwalk_check(struct svm_test *test)
 {
-    u64 *pdpe = npt_get_pdpe();
+    u64 *pdpe = npt_get_pml4e();
     pdpe[0] &= ~(1ULL << 8);
 
     return (vmcb->control.exit_code == SVM_EXIT_NPF)

