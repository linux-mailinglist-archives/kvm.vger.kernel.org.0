Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2F738C27A
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 10:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhEUJBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbhEUJAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 05:00:53 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB99DC06138A;
        Fri, 21 May 2021 01:59:28 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f22so12777663pgb.9;
        Fri, 21 May 2021 01:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9VVK8/1KColE59Xv+mm8AL8uAr/GCHzBnr8zfukNEnQ=;
        b=tzlpR0iZmoOnnL3HUU+5tU3XVVpaO9lr4EYeRCULCPKhd9atNaueRaBVMauwxoFL3V
         guhGiDAcC93SbpTyCmq3CAMSpk1TCWpnoU/dPnHUUrydMd0M7RMjARdrZtNa3NGiez8q
         AVq8u7a+Mnsa364kIM7Y7P0cyYqGmtBaXnQms7iTyb18Cg9IOhp5ynXqI/WzUs00R/pL
         eXqqNda9L1/0HUusHsWegsA6GENsNCUYPjTnA0AQaUX/lbrodTJ+2z3QxNIbaoDmjVz8
         JTlBX7e79sqyjxLNYmhwUNNBfoFU8FspEUnIP2s+8LP35yVAzTjhn/0LW4lS/o1SQuc/
         WTcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9VVK8/1KColE59Xv+mm8AL8uAr/GCHzBnr8zfukNEnQ=;
        b=LcoyEX8c//Elo2IUTAO6uVy2i5zj3DbLGCxoG9XFKyF34XCN5ITAPGm6aID9zvVzsT
         VwcJ6RKzPj+5PMO0mhfwawpxa+3mosTXJ9dqLrGPrel64lEhaty2NotLawGCRQfsN7am
         zjIetnKM5kc3bgehKkv8/B2J+jn6uNweUbeQPlKjj0y20C5/KWZ6TjIxzLpgeg9YBVTr
         Dgh8lz2OFccEsRFeRMC8Q0SOjcd3BGbuljRGVy1TGEoqPjkld7OzsNbLgscWeK5dhn2/
         5W7OW4fLjxNqZ7V89NpLrn0DCghBm9nMLpSjqbfQZWhLbaI1sBZmt3fkSE4lMDC9M9d2
         P0Yg==
X-Gm-Message-State: AOAM532gMqAzm8bkXRDeAbS8h/bps7p0vEcr0pTj/oIMvxrPfRk+g3y2
        EGl2jhyMPYT3XvwxTBIy4+s=
X-Google-Smtp-Source: ABdhPJyc9Jyz5l4cpY6SfZOEGuvmlCLat0me4TBWH+8q7gJMiyUN/NrNb6qzjrqqQCVYZ1W+qfk04g==
X-Received: by 2002:a62:e21a:0:b029:2de:4440:3a with SMTP id a26-20020a62e21a0000b02902de4440003amr9052894pfi.23.1621587568515;
        Fri, 21 May 2021 01:59:28 -0700 (PDT)
Received: from pride.localdomain (c-174-61-140-56.hsd1.wa.comcast.net. [174.61.140.56])
        by smtp.gmail.com with ESMTPSA id q3sm3914489pff.142.2021.05.21.01.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 01:59:28 -0700 (PDT)
From:   Joe Richey <joerichey94@gmail.com>
To:     trivial@kernel.org
Cc:     Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Peter Xu <peterx@redhat.com>,
        Lei Cao <lei.cao@stratus.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: [PATCH v2 7/7] checkpatch: suggest _BITULL() and _BITUL() for UAPI headers
Date:   Fri, 21 May 2021 01:58:48 -0700
Message-Id: <20210521085849.37676-8-joerichey94@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210521085849.37676-1-joerichey94@gmail.com>
References: <20210520104343.317119-1-joerichey94@gmail.com>
 <20210521085849.37676-1-joerichey94@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joe Richey <joerichey@google.com>

Instead of just ignoring UAPI headers, reccomend the UAPI compatible
macros if a user adds something that looks like (1 << n). Normal kernel
code will continue to get BIT_ULL() and BIT() reccomended.

This change also modifies the $realfile regex to match headers that have
"include/uapi" anywhere in their path so paths like:
    tools/include/uapi/linux/kvm.h
    arch/x86/include/uapi/asm/hwcap2.h
get recognized as UAPI headers.

Signed-off-by: Joe Richey <joerichey@google.com>
---
 scripts/checkpatch.pl | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d65334588eb4..47edc61b74c2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -7020,15 +7020,17 @@ sub process {
 			}
 		}
 
-# check for #defines like: 1 << <digit> that could be BIT(digit), it is not exported to uapi
-		if ($realfile !~ m@^include/uapi/@ &&
-		    $line =~ /#\s*define\s+\w+\s+\(?\s*1\s*([ulUL]*)\s*\<\<\s*(?:\d+|$Ident)\s*\)?/) {
-			my $ull = "";
-			$ull = "_ULL" if (defined($1) && $1 =~ /ll/i);
+# check for #defines like: 1 << <digit> that could be BIT(digit) or similar
+		if ($line =~ /#\s*define\s+\w+\s+\(?\s*1\s*([ulUL]*)\s*\<\<\s*(?:\d+|$Ident)\s*\)?/) {
+			my $ull = (defined($1) && $1 =~ /ll/i);
+			my $macroname = $ull ? "BIT_ULL" : "BIT";
+			if ($realfile =~ m@include/uapi/@) {
+				$macroname = $ull ? "_BITULL" : "_BITUL";
+			}
 			if (CHK("BIT_MACRO",
-				"Prefer using the BIT$ull macro\n" . $herecurr) &&
+				"Prefer using the $macroname macro\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$fixlinenr] =~ s/\(?\s*1\s*[ulUL]*\s*<<\s*(\d+|$Ident)\s*\)?/BIT${ull}($1)/;
+				$fixed[$fixlinenr] =~ s/\(?\s*1\s*[ulUL]*\s*<<\s*(\d+|$Ident)\s*\)?/${macroname}($1)/;
 			}
 		}
 
-- 
2.31.1

