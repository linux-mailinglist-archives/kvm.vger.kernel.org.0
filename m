Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EC460E580
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 18:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbiJZQco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 12:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbiJZQcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 12:32:42 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46BBD8F6F
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 09:32:41 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id f5-20020a17090a4a8500b002131bb59d61so3778709pjh.1
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 09:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YIFf1F2Em+MFgq+iEQKUwj6Jiz+DV1k24mADJW6rhO4=;
        b=JGtXBh8bQN4FnK/1t34Dc9Ss0K/RekTRhlBUkNnTJFvLGJtlEv+L2mv4lpfm3x+Fp2
         iOTc+TqogYu16w221RJzAEsefuzq2vzY7x1MNsjcQVVj6TEh+tv1ywD999PCSloudqJm
         XyDakMXSUtbNiUBwI2bkBbRECKItPIGfFRDi7BKOv28RCxpQ+KROR7FDmHt6llb6sSTB
         6oYXR2WUB78L1G7I7OKLaNQbByJ12ijIRBg/Sl7NXcfobqjjSx6wsUFGKODd/7ST6gUQ
         /4L3Kxi/kIEbbcUVGuoOBBXLecp5y5uJ0yEcIZCZFoCPKNcJ2Y0+zVV4SSB1vuSI+sjS
         rq9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YIFf1F2Em+MFgq+iEQKUwj6Jiz+DV1k24mADJW6rhO4=;
        b=Yd0+jGSRT67ULS6pDMblw7y0WldUORBjLbNAck42ncSmlk4VWi3hGpet2j5CkHiQ79
         j738vby+LW4FDa8kFdwu8WguErgWN+luD4BFeT9dH4mjPCGuazJaBxJ89+94jLiZ+t1x
         hkL9nIASXupiD3RJA3ndk9kAbbhkydUuWjJos+Ao2cJsZS2+VDWnlcUUJuzKlPDVhxfR
         KEePgcXp3I+NfdHqwnKfX4CocznE9HDrWgMKO2wOs0F6u6YLl7IS5SoCTeGefRZHRj48
         Wset99mjLjkUWkpPus7l4JJbmE7Q4aSMfe55S71D/egso2rHiDFc9hJVdRjtBy+agbHH
         oW7Q==
X-Gm-Message-State: ACrzQf05gIP+iFvgkmfYWQYot1vMtNmhBip3MsYysjkiRPowb897b/0+
        06jGZGtQRlcAES579NgknwPLNg==
X-Google-Smtp-Source: AMsMyM4wSwZYmUYp64Xin17fql/Q1l//Z5XQaAG2yLsamfgh87ClkkKSWGvIc0r5uOVCK7prKO25vg==
X-Received: by 2002:a17:902:8309:b0:17a:695:b5bf with SMTP id bd9-20020a170902830900b0017a0695b5bfmr43490540plb.35.1666801961036;
        Wed, 26 Oct 2022 09:32:41 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902e94500b001868da70685sm3109366pll.235.2022.10.26.09.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 09:32:40 -0700 (PDT)
Date:   Wed, 26 Oct 2022 16:32:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] x86: Increase timeout for
 vmx_vmcs_shadow_test to 10 mins
Message-ID: <Y1lhJOJxn4fOmj7z@google.com>
References: <20221026102647.712110-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026102647.712110-1-po-hsu.lin@canonical.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 26, 2022, Po-Hsu Lin wrote:
> This test can take about 7 minutes to run on VM.DenseIO2.8 instance
> from Oracle cloud with Ubuntu Oracle cloud kernel (CONFIG_DEBUG_VM
> was not enabled):
>   * Ubuntu Focal 5.4 Oracle kernel: 6m42s / 6m46s / 6m42s
>   * Ubuntu Jammy 5.15 Oracle kernel: 6m26s / 6m27s / 6m26s
> 
> Bump the timeout for this test again to 10 minutes.

This test isn't all that interesting for a doubly-nested scenario, i.e. those 6+
minutes are almost always going to be a waste of time.  Rather than bumping the
timeout, what about skipping the the test by default if KVM-unit-tests detects
that it's running in a VM?

(I apologize for my horrific bash skills)

---
 scripts/common.bash     |  8 ++++++--
 scripts/runtime.bash    | 23 +++++++++++++++++++++--
 scripts/s390x/func.bash |  9 +++++----
 x86/unittests.cfg       |  1 +
 4 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index 7b983f7d..88738e39 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -11,6 +11,7 @@ function for_each_unittest()
 	local groups
 	local arch
 	local check
+	local grep
 	local accel
 	local timeout
 	local rematch
@@ -21,7 +22,7 @@ function for_each_unittest()
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
 			rematch=${BASH_REMATCH[1]}
 			if [ -n "${testname}" ]; then
-				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$grep" "$accel" "$timeout"
 			fi
 			testname=$rematch
 			smp=1
@@ -30,6 +31,7 @@ function for_each_unittest()
 			groups=""
 			arch=""
 			check=""
+			grep=""
 			accel=""
 			timeout=""
 		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
@@ -44,6 +46,8 @@ function for_each_unittest()
 			arch=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^check\ *=\ *(.*)$ ]]; then
 			check=${BASH_REMATCH[1]}
+		elif [[ $line =~ ^grep\ *=\ *(.*)$ ]]; then
+			grep=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^accel\ *=\ *(.*)$ ]]; then
 			accel=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^timeout\ *=\ *(.*)$ ]]; then
@@ -51,7 +55,7 @@ function for_each_unittest()
 		fi
 	done
 	if [ -n "${testname}" ]; then
-		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$grep" "$accel" "$timeout"
 	fi
 	exec {fd}<&-
 }
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index f8794e9a..ca502eab 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -79,8 +79,9 @@ function run()
     local opts="$5"
     local arch="$6"
     local check="${CHECK:-$7}"
-    local accel="$8"
-    local timeout="${9:-$TIMEOUT}" # unittests.cfg overrides the default
+    local grep="$8"
+    local accel="$9"
+    local timeout="${10:-$TIMEOUT}" # unittests.cfg overrides the default
 
     if [ "${CONFIG_EFI}" == "y" ]; then
         kernel=$(basename $kernel .flat)
@@ -130,6 +131,24 @@ function run()
         done
     fi
 
+    if [ "$grep" ]; then
+        for grep_param in "${grep[@]}"; do
+            search=${grep_param%%,*}
+            path=${grep_param#*,}
+            path=${path%%=*}
+            value=${grep_param#*=}
+            if [ ! -f "$path" ]; then
+                continue
+	    fi
+
+	    grep -q $search $path
+	    if [ $([ $? -ne 0 ] && echo "N" || echo "Y") != "$value" ]; then
+                print_result "SKIP" $testname "" "grep $search $path != $value"
+                return 2
+            fi
+        done
+    fi
+
     last_line=$(premature_failure > >(tail -1)) && {
         skip=true
         if [ "${CONFIG_EFI}" == "y" ] && [[ "${last_line}" =~ "Dummy Hello World!" ]]; then
diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
index 2a941bbb..c9ebe34d 100644
--- a/scripts/s390x/func.bash
+++ b/scripts/s390x/func.bash
@@ -14,11 +14,12 @@ function arch_cmd_s390x()
 	local opts=$6
 	local arch=$7
 	local check=$8
-	local accel=$9
-	local timeout=${10}
+	local grep=$9
+	local accel=$10
+	local timeout=${11}
 
 	# run the normal test case
-	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$grep" "$accel" "$timeout"
 
 	# run PV test case
 	if [ "$ACCEL" = 'tcg' ] || find_word "migration" "$groups"; then
@@ -34,5 +35,5 @@ function arch_cmd_s390x()
 		print_result 'SKIP' $testname '' 'PVM image was not created'
 		return 2
 	fi
-	"$cmd" "$testname" "$groups pv" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+	"$cmd" "$testname" "$groups pv" "$smp" "$kernel" "$opts" "$arch" "$check" "$grep" "$accel" "$timeout"
 }
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index ed651850..99ba52a8 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -374,6 +374,7 @@ extra_params = -cpu max,+vmx -append vmx_vmcs_shadow_test
 arch = x86_64
 groups = vmx
 timeout = 180
+grep = hypervisor,/proc/cpuinfo=N
 
 [vmx_pf_exception_test]
 file = vmx.flat

base-commit: 5bf99cb38621d44b0a7d2204ecd9326b3209ab73
-- 

