Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBFD1A34FA
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 15:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgDINhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 09:37:00 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50476 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726597AbgDINhA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Apr 2020 09:37:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586439420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CUYqMNBJfIerOiEmQdHjA1xyi/Z/27IxW7+Uqv0ibw4=;
        b=bEYf0AeRX9hlIHQyrhht4RnbgEGl5Z9jKz2n0inI0gDdpPPTjglJsVKUR2HmNZy34j/ABK
        JNGGXHaTQzttXZ9ytLqRhVUucaWJE80a3vTBj1MEc65eED51zVSHlkgUIsWWmig5scpAIr
        JFrmzjABw/DQj5WlzRtcsNbc8feawHM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-v_p67rnPN4yhWQpez2MSgA-1; Thu, 09 Apr 2020 09:36:58 -0400
X-MC-Unique: v_p67rnPN4yhWQpez2MSgA-1
Received: by mail-wm1-f72.google.com with SMTP id f81so1878681wmf.2
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 06:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CUYqMNBJfIerOiEmQdHjA1xyi/Z/27IxW7+Uqv0ibw4=;
        b=TzHx3pRjG5tFTalfuWGx+x3wJYYM3xLLTAPP2Sh3vFuaI/knlmFxXAu8JBozEizgBE
         LMVuYxT6SZ6uE5ebPDsanZs99T4JzXIc5U99ChoZDS7SX99JSj08DXp8Ch5yRWKgBy+k
         QjewQnGcCGM8UXV4+2mtGDi73o+dk8cZMyUOUFXNHYLahPpb6dShLBvQO4cWK0mJQ22y
         DBVDXeFvzMPSvPtFkipgWy4lbyrF/E+8VTMofEb5wc48uPzUUnerRsR5njitfhhwki0r
         Li4ENQ9kc8UIZivK0UEPLA/LZIXS1xDB4RFkG4EwBjNlyyCuv0rMOjIYxEELga4fxWCR
         6efw==
X-Gm-Message-State: AGi0PubrKuQp23wd54vwdFy6Q0gGSl8+E523DIiYrwKUR+dNZ0eFF11L
        IJVF0Dmddi5u0l1mDpE+1NIbcTdRjA2wjcxnUmqkElM9yose/tENEwWvW0KpWXvcavUyVQtyR7b
        owSCBW9GMk/DV
X-Received: by 2002:a5d:5448:: with SMTP id w8mr4351709wrv.419.1586439417358;
        Thu, 09 Apr 2020 06:36:57 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ7Z1Q/VHHSPOzwmy75sXIIp0GoMjBUWtUBkZ+UivKqpFYwdzi7bReT3xp6uGSpIjAeede76g==
X-Received: by 2002:a5d:5448:: with SMTP id w8mr4351694wrv.419.1586439417118;
        Thu, 09 Apr 2020 06:36:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e8a3:73c:c711:b995? ([2001:b07:6468:f312:e8a3:73c:c711:b995])
        by smtp.gmail.com with ESMTPSA id y15sm16339997wro.68.2020.04.09.06.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 06:36:56 -0700 (PDT)
Subject: Re: Current mainline kernel FTBFS in KVM SEV
To:     Uros Bizjak <ubizjak@gmail.com>, like.xu@intel.com
Cc:     kvm@vger.kernel.org
References: <CAFULd4adXFX+y6eCV0tVhg-iHZe+tAchJkuHMXe3ZWktzGk7Sw@mail.gmail.com>
 <a2187cc0-cab6-78db-3e2d-6edaf647c882@redhat.com>
 <CAFULd4YG1Df_1HvjDUYCyW+VTLO3-xk8CU4Lwsv2Lq=G-wP+cQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b530f3b2-9b82-5260-1aca-3a2397cae2c2@redhat.com>
Date:   Thu, 9 Apr 2020 15:36:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAFULd4YG1Df_1HvjDUYCyW+VTLO3-xk8CU4Lwsv2Lq=G-wP+cQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/20 14:51, Uros Bizjak wrote:
> 
> --cut here--
> config KVM_AMD_SEV
>     def_bool y
>     bool "AMD Secure Encrypted Virtualization (SEV) support"
>     depends on KVM_AMD && X86_64
>     depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>     ---help---
>     Provides support for launching Encrypted VMs on AMD processors.
> --cut here--
> 
> which doesn't disable the compilation of sev.o. The missing functions
> are actually in ccp.o *module*, called from built-in functions of
> sev.o

Yes, that's also what I was thinking but I confused SP_PSP with CCP_DD.

> Enabling CRYPTO_DEV_CCP_DD=y as a built-in instead of a module fixes the build.

What about this:

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0e3fc311d7da..364ffe32139c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1117,7 +1117,7 @@ int __init sev_hardware_setup(void)
 	/* Maximum number of encrypted guests supported simultaneously */
 	max_sev_asid = cpuid_ecx(0x8000001F);
 
-	if (!max_sev_asid)
+	if (!svm_sev_enabled())
 		return 1;
 
 	/* Minimum ASID value that should be used for SEV guest */
@@ -1156,6 +1156,9 @@ int __init sev_hardware_setup(void)
 
 void sev_hardware_teardown(void)
 {
+	if (!svm_sev_enabled())
+		return;
+
 	bitmap_free(sev_asid_bitmap);
 	bitmap_free(sev_reclaim_asid_bitmap);
 
They should be the only places that call those functions and are not already
culled by svm_sev_enabled(), either directly or indirectly (most of sev.c
functions are static and the entry points reduce to just a return).

The two symbols go away for me with this change.

Paolo

