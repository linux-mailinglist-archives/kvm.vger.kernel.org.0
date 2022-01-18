Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F264929D9
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 16:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346007AbiARPrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 10:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345950AbiARPra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 10:47:30 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30458C061574
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 07:47:30 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id j7so32979259edr.4
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 07:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S/v2FaZmiVU5iYfpWpoM8du+CrTXLwQKhasq5k9Jgm8=;
        b=hvGoM2PlSwLt4R0iL9fiJ7AugUt/q9p1M5oaOfcyGIn2ZqBV7vkY7jEdvXSZNMqUnx
         q+80XqfQiq7seQ7Wxs4vS9f086OpBTz5KqEpOglJRGX51VqYbaf5dzK5kB37VxckFA8A
         aJa+m9mq/Pc3//SPwR+Nr9v4K3gg9nDEDzKb++H6qabFP/VSS/rVNM0pV6ivLv2tcsVR
         srrJBePTvpVna6e8z+0QuP44v7ZffUzTA/qVs+JZF8UPCDJI94iPKEWlk9K7khkuetqo
         yv49DiRFplr9dQJDITk0RdTKSyFCRbl0Gw0gOvTdRwKwEHtYLPjJsya14pAkDSKCr+rV
         uetg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S/v2FaZmiVU5iYfpWpoM8du+CrTXLwQKhasq5k9Jgm8=;
        b=UeiBj+xSAmiii6I6UOyNq4acuKy7nFOMuQLwG+6eqnwmck6km7b1SrTkDt5oeccWPt
         azQLQtM5xuXI4HCmD8DWhN4zXROsaPWA4/8Siy0vvA2gowHqAySmB5W0usHjF+OcRZSP
         U27rzU9zr9KD8CQx1xd19tragD1QJiA770rkCSZRswB4mWegqAdZOKWxEP1OQxUi6CI+
         p/A6krp3rt6z7mqKBTVmtPm1HbL2lFvUNYiUZHSPk4fwEh0HiIvsr+Zig/UyKBwtT7fp
         cNjhIanv3YCIJAUUnfwvbaxXmyrpDTgW/PTvh9ezjGt4mOEjIniqOP6RewB+nuCIDvPY
         WQ6Q==
X-Gm-Message-State: AOAM530ufQo7OvaCmgh4m/vL9goNsJt1jVEyJD0mzuyD31Qn5WkrCaoR
        irPr7lG/ynz22XwreHtUQeE=
X-Google-Smtp-Source: ABdhPJy/iNSL2J1hYsdnrK2E52RySP9TAfRmL4CjVOiqSxz39z1raf2Mjk2H+WBzf9G97dUPs+WHpQ==
X-Received: by 2002:a17:907:a41e:: with SMTP id sg30mr20414087ejc.249.1642520848725;
        Tue, 18 Jan 2022 07:47:28 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id s4sm5049090ejm.146.2022.01.18.07.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 07:47:28 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <fddefa8e-37bb-3c02-d387-71191a4ffa7e@redhat.com>
Date:   Tue, 18 Jan 2022 16:47:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH v2 10/10] x86 UEFI: Make _NO_FILE_4Uhere_
 work w/ BOOTX64.EFI
Content-Language: en-US
To:     Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
References: <20211116204053.220523-1-zxwang42@gmail.com>
 <20211116204053.220523-11-zxwang42@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211116204053.220523-11-zxwang42@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 21:40, Zixuan Wang wrote:
> From: Marc Orr <marcorr@google.com>
> 
> The `_NO_FILE_4Uhere_` test case is used by the runner scripts to verify
> QEMU's configuration. Make it work with EFI/BOOT/BOOTX64.EFI by compling
> a minimal EFI binary, called dummy.c that returns immediately.
> 
> Signed-off-by: Marc Orr <marcorr@google.com>

A slightly simpler way to do it is to just let the normal build process
create dummy.efi as well:

commit 2fbec25780568559e13486f7e5b5350630d061d3 (HEAD -> uefi)
Author: Marc Orr <marcorr@google.com>
Date:   Tue Nov 16 12:40:53 2021 -0800

     x86 UEFI: Make _NO_FILE_4Uhere_ work w/ BOOTX64.EFI
     
     The `_NO_FILE_4Uhere_` test case is used by the runner scripts to verify
     QEMU's configuration. Make it work with EFI/BOOT/BOOTX64.EFI by compling
     a minimal EFI binary, called dummy.c that returns immediately.
     
     Signed-off-by: Marc Orr <marcorr@google.com>
     Message-Id: <20211116204053.220523-11-zxwang42@gmail.com>
     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 228a207..bb89a53 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -132,7 +132,7 @@ function run()
  
      last_line=$(premature_failure > >(tail -1)) && {
          skip=true
-        if [ "${TARGET_EFI}" == "y" ] && [[ "${last_line}" =~ "Reset" ]]; then
+        if [ "${TARGET_EFI}" == "y" ] && [[ "${last_line}" =~ "enabling apic" ]]; then
              skip=false
          fi
          if [ ${skip} == true ]; then
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 2b39dd5..984444e 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -72,7 +72,7 @@ else
  endif
  
  tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
-               $(TEST_DIR)/smptest.$(exe)  \
+               $(TEST_DIR)/smptest.$(exe) $(TEST_DIR)/dummy.$(exe) \
                 $(TEST_DIR)/msr.$(exe) \
                 $(TEST_DIR)/hypercall.$(exe) $(TEST_DIR)/sieve.$(exe) \
                 $(TEST_DIR)/kvmclock_test.$(exe) \
diff --git a/x86/dummy.c b/x86/dummy.c
new file mode 100644
index 0000000..5019e79
--- /dev/null
+++ b/x86/dummy.c
@@ -0,0 +1,4 @@
+int main(int argc, char **argv)
+{
+	return 0;
+}
diff --git a/x86/efi/run b/x86/efi/run
index a888979..ac368a5 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -29,6 +29,10 @@ fi
  # Remove the TEST_CASE from $@
  shift 1
  
+if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
+	EFI_CASE=dummy
+fi
+
  # Prepare EFI boot file system
  #   - Copy .efi file to host dir $EFI_TEST/$EFI_CASE/EFI/BOOT/BOOTX64.EFI
  #     This host dir will be loaded by QEMU as a FAT32 image
@@ -37,9 +41,7 @@ shift 1
  : "${EFI_CASE_BINARY:="$EFI_CASE_DIR/BOOTX64.EFI"}"
  
  mkdir -p "$EFI_CASE_DIR"
-if [ "$EFI_CASE" != "_NO_FILE_4Uhere_" ]; then
-	cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
-fi
+cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
  
  # Run test case with 256MiB QEMU memory. QEMU default memory size is 128MiB.
  # After UEFI boot up and we call `LibMemoryMap()`, the largest consecutive

