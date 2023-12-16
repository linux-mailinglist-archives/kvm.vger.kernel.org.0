Return-Path: <kvm+bounces-4626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9169181597D
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:45:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E74E284A62
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBD8031722;
	Sat, 16 Dec 2023 13:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GQSCY/HQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C544C315B4
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6da52f16427so1090204a34.0
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734275; x=1703339075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eQm/MfoDvPixkD3rzoXd8ExftC3lSnd6rRKzurLg4gU=;
        b=GQSCY/HQ+lxvaYkr7GkoN52mqJzvuM2FI2FdIMuj/NuaO3sYgBd0/I7X2VIDjJUWTw
         uIX40jDkc2c4Lp+f7B48AcKj0EE50PXuHyqUhuFJd/njzBZxrqb+y5gBfzeTMGiCVgNX
         OBEFOfoPVEWCFceAWcCBnqL/KpGGRbzeGqot7E3oOEbPDf6xr6WATvwHgeQmkkAHIydL
         ECMO+VlFAn+1UssU54+GmLKqDWT+XAktrM8wWEfUnDhm2Pj5B/Qb+/rr7B03ggw2Wlwr
         HKCwXWtsM/LoLcJDiwVkndKJOZx/E16XgmmefqtiIBBWp/kCokz4CvKazBLQWWzyllvE
         Rlrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734275; x=1703339075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eQm/MfoDvPixkD3rzoXd8ExftC3lSnd6rRKzurLg4gU=;
        b=fskEMsAZ7yIFGiZAOlpKe64Vzn+C7R3Bg7nCfH9QZ3N2097aUYyghwr7AgPBlGZTDb
         ZOEI5/UwyCW5AMddnD+BZ4leq+twpOFLr2ZLhgoDC/KqNSV4zF2ak0jgAitCw7WP6JJs
         eFEHgwBbjaoIvLWVH+iNS38VDRomWFBQRicJS6Sq14dPxFGjvWpBNKE0YL3sPBZKiayh
         6yWK35hYZhytVZZWrf9hutFbLbWLcaZWWPN6l8e7K0fjph8vL9PKD0UcjgGXRH8o8Syg
         1ehKRPU6peBW0W9CYzKHLLb4OUtiOllKUcZDwLxlxDRsZ1IcOzXBXUBSoQkprIZbUgfB
         iVJw==
X-Gm-Message-State: AOJu0YzsNNxtkA+5hMeGbRB5g05MLAJ0ZUgA2NO1c1hzX+CWEU7X9sNr
	RDhJfRBmGyLmrBvQTk2jCB/4U/QMiwA=
X-Google-Smtp-Source: AGHT+IE8dGDxP2KO0czC9s8iGgS22q0DWeVz9cMMp3BF3qZd1AFqTT/+4p8WVEA22fkCgHx3pgXcnw==
X-Received: by 2002:a9d:62c2:0:b0:6d8:8007:d56f with SMTP id z2-20020a9d62c2000000b006d88007d56fmr13927816otk.28.1702734275468;
        Sat, 16 Dec 2023 05:44:35 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:44:35 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 19/29] scripts: allow machine option to be specified in unittests.cfg
Date: Sat, 16 Dec 2023 23:42:46 +1000
Message-ID: <20231216134257.1743345-20-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231216134257.1743345-1-npiggin@gmail.com>
References: <20231216134257.1743345-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows different machines with different requirements to be
supported by run_tests.sh, similarly to how different accelerators
are handled.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/common.bash  |  8 ++++++--
 scripts/runtime.bash | 16 ++++++++++++----
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index b9413d68..ee1dd865 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -10,6 +10,7 @@ function for_each_unittest()
 	local opts
 	local groups
 	local arch
+	local machine
 	local check
 	local accel
 	local timeout
@@ -21,7 +22,7 @@ function for_each_unittest()
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
 			rematch=${BASH_REMATCH[1]}
 			if [ -n "${testname}" ]; then
-				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
 			fi
 			testname=$rematch
 			smp=1
@@ -29,6 +30,7 @@ function for_each_unittest()
 			opts=""
 			groups=""
 			arch=""
+			machine=""
 			check=""
 			accel=""
 			timeout=""
@@ -58,6 +60,8 @@ function for_each_unittest()
 			groups=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
 			arch=${BASH_REMATCH[1]}
+		elif [[ $line =~ ^machine\ *=\ *(.*)$ ]]; then
+			machine=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^check\ *=\ *(.*)$ ]]; then
 			check=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^accel\ *=\ *(.*)$ ]]; then
@@ -67,7 +71,7 @@ function for_each_unittest()
 		fi
 	done
 	if [ -n "${testname}" ]; then
-		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
 	fi
 	exec {fd}<&-
 }
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index fc156f2f..0803d02a 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -30,7 +30,7 @@ premature_failure()
 get_cmdline()
 {
     local kernel=$1
-    echo "TESTNAME=$testname TIMEOUT=$timeout ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
+    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
 }
 
 skip_nodefault()
@@ -78,9 +78,10 @@ function run()
     local kernel="$4"
     local opts="$5"
     local arch="$6"
-    local check="${CHECK:-$7}"
-    local accel="$8"
-    local timeout="${9:-$TIMEOUT}" # unittests.cfg overrides the default
+    local machine="$7"
+    local check="${CHECK:-$8}"
+    local accel="$9"
+    local timeout="${10:-$TIMEOUT}" # unittests.cfg overrides the default
 
     if [ "${CONFIG_EFI}" == "y" ]; then
         kernel=${kernel/%.flat/.efi}
@@ -114,6 +115,13 @@ function run()
         return 2
     fi
 
+    if [ -n "$machine" ] && [ -n "$MACHINE" ] && [ "$machine" != "$MACHINE" ]; then
+        print_result "SKIP" $testname "" "$machine only"
+        return 2
+    elif [ -n "$MACHINE" ]; then
+        machine="$MACHINE"
+    fi
+
     if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" ]; then
         print_result "SKIP" $testname "" "$accel only, but ACCEL=$ACCEL"
         return 2
-- 
2.42.0


