Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7D7207556
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 16:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391158AbgFXOKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 10:10:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22329 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388395AbgFXOKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 10:10:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593007831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X/ddPMKFK52O0i/xE6u6isLskFjJDspQUCwUmvG2q9g=;
        b=Yi/4vpjMgCr1W5Z45yA8bEkKOhAl0wsaGxDWHWXOxYI0a+kBLUI24pzusFh7aeWSF3uFRm
        3lUVyzbwAkmQWGdBbsEQiS2tKaNbm/dg40UW9Q/iG5mx/Io5GB8WZGTG/KmPFQsLBOpmga
        27Bt34u/CJ53lpda/7frLigraWqseo0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-VDuRhBDzMYCcPZpopP3tlA-1; Wed, 24 Jun 2020 10:10:21 -0400
X-MC-Unique: VDuRhBDzMYCcPZpopP3tlA-1
Received: by mail-wm1-f71.google.com with SMTP id o13so2891798wmh.9
        for <kvm@vger.kernel.org>; Wed, 24 Jun 2020 07:10:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X/ddPMKFK52O0i/xE6u6isLskFjJDspQUCwUmvG2q9g=;
        b=HqaOo7w/fqlARFiIRd065YpXPQIfpr63kQcVu9BrTAZKIJKchBzsA3nfIWiTMNxhzY
         Rj9sOI0P0TBZFS2ZjTBWcxiMvDHGrygbcCoTYH7kmkcM+Uq4nARaYs31vC/upC+p0814
         DuaivjehkY49dZ7T+NNwLFQsq9siSgISqOOaqzgHMer/977Iueq/iGDoHT0KbweUdJHU
         D8QbsdVkTZaKMNJDgiEfDKhfCbTpS89GYKrV91L5noeyesIECVfBLGrAdVIrf/Thv2vF
         2/eyMRWdrZBngWsv/eyTY6sSjDYIV2mpuiVPvEnjqiZhMSahHelSAEGiusS2+lYjLtL/
         BymA==
X-Gm-Message-State: AOAM533tfIxOLTIeG3pV4DV2p6Qne4O5r2Bmg2BQtfohXb9Ug8G0y4ai
        ngr+N1LVcagUyB2fSloXqnJQFysaNYNvogpBUx28sEreULBH8h6xGarm19fpIHTRBRInGbpSFDf
        yBMhx4n0ufoZq
X-Received: by 2002:a1c:8117:: with SMTP id c23mr22480899wmd.157.1593007820406;
        Wed, 24 Jun 2020 07:10:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/zjFESCjivTfraJHy6CuthLgkns0Gis7vTXveb2snbUkcIjEeC+OYOh1JiPSt+Zp/40iz8g==
X-Received: by 2002:a1c:8117:: with SMTP id c23mr22480790wmd.157.1593007819254;
        Wed, 24 Jun 2020 07:10:19 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.253.55])
        by smtp.gmail.com with ESMTPSA id r12sm27031305wrc.22.2020.06.24.07.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 07:10:18 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Initialize segment selectors
To:     Thomas Huth <thuth@redhat.com>, Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org
References: <20200623084132.36213-1-namit@vmware.com>
 <40203296-7f31-16c7-bebb-e1f1cd478a19@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a9956a6f-5049-af9f-4e26-e37eb26e19c6@redhat.com>
Date:   Wed, 24 Jun 2020 16:10:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <40203296-7f31-16c7-bebb-e1f1cd478a19@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/20 14:52, Thomas Huth wrote:
> On 23/06/2020 10.41, Nadav Amit wrote:
>> Currently, the BSP's segment selectors are not initialized in 32-bit
>> (cstart.S). As a result the tests implicitly rely on the segment
>> selector values that are set by the BIOS. If this assumption is not
>> kept, the task-switch test fails.
>>
>> Fix it by initializing them.
>>
>> Signed-off-by: Nadav Amit <namit@vmware.com>
>> ---
>>   x86/cstart.S | 17 +++++++++++------
>>   1 file changed, 11 insertions(+), 6 deletions(-)
> 
> I'm sorry to be the bearer of bad news again, but this commit broke
> another set of tests in the Travis CI:
> 
>  https://travis-ci.com/github/huth/kvm-unit-tests/jobs/353103187#L796
> 
> smptest, smptest3, kvmclock_test, hyperv_synic and hyperv_stimer are
> failing now in the 32-bit kvm-unit-tests :-(

And that's just bad testing (both Nadav's and mine).  Writing to %gs
clobbers the PERCPU area.  The fix is as simple as this:

diff --git a/x86/cstart.S b/x86/cstart.S
index 5ad70b5..77dc34d 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -106,6 +106,7 @@ MSR_GS_BASE = 0xc0000101
 .globl start
 start:
         mov $stacktop, %esp
+        setup_segments
         push %ebx
         call setup_multiboot
         call setup_libcflat
@@ -118,7 +119,6 @@ start:

 prepare_32:
         lgdtl gdt32_descr
-	setup_segments

 	mov %cr4, %eax
 	bts $4, %eax  // pse

