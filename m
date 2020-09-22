Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F31427438D
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 15:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgIVNxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 09:53:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726473AbgIVNxd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 09:53:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600782812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LXJuAYQzwGM4MRAeNc53TpmewNQD8dfol4239Oya80c=;
        b=KR7Pmk+zmen2QdQMnPD1AmUVTnjSnk5Apo0sZxZswbSJSkLVDKnSWxICGtDbA4+XG5eZy1
        YaVqZqunMlIi1o9l9QFR/QQdCipF1Z9TUdfLUStfgNpQK5geZbjVajB2Uv+sr5D85kaCtb
        YcFeAtMPgvDyleZ3mCIyWQiqQ48sM4g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-sZr4EQRwM8i5D-n2L8YyjQ-1; Tue, 22 Sep 2020 09:53:30 -0400
X-MC-Unique: sZr4EQRwM8i5D-n2L8YyjQ-1
Received: by mail-wm1-f71.google.com with SMTP id a25so606499wmb.2
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 06:53:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LXJuAYQzwGM4MRAeNc53TpmewNQD8dfol4239Oya80c=;
        b=thdLlsH5cTfcBIxUvbmhaGp2cKzPm/54j2HAcUe5TVLJrUCJHmYVu1KQA/l5MYlUyI
         S3P3S717acGLc2ff9zjCz6SkcjM5TdbE3M3bCOS2LyQ+AlTDW0h1udaPPTQA2rAjAUUn
         SydsXft8vnF1TgFvVlYK6igV/tP4ytL6VFSknhPpfqdO2krV2O47/RJa01MwXJoOl8j/
         sHRQOQoXEyBs3u6wp9IzNfCpNJzQK5Nszj1y4IEgq8qinC9Q9MD9llw/WXZGoxRLyG00
         P4uEKF5IbWwMprY8iGdVmcXn0fbRdZ+6NZVKfx2bUj8J8kMgfC0IVA7vGa/BMu+G0Uo3
         ZGzw==
X-Gm-Message-State: AOAM533AIwCygjuo8ZhQ87K3Yqnncf0Qa6SWsmZkqbsfDzGYETSQeElA
        Y8d9zQBMId3yDTqK1Jc5VsZ33ng6IuMn5DUF6t8VzE9QLvAcKWVI/jDD10b7oRU+nNKMsI80wpt
        f03xGdn25xUAv
X-Received: by 2002:adf:e552:: with SMTP id z18mr5241834wrm.50.1600782809268;
        Tue, 22 Sep 2020 06:53:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0s+m4G9nvHe1LKq4Rgy1BV3rrz8uhJh6trBa7JSgetalXEhEXNQhSM+LrYfmYGFHWXO9QSg==
X-Received: by 2002:adf:e552:: with SMTP id z18mr5241810wrm.50.1600782808985;
        Tue, 22 Sep 2020 06:53:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id a83sm4792892wmh.48.2020.09.22.06.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 06:53:28 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 06/10] configure: Add an option to
 specify getopt
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>, Cameron Esfahani <dirty@apple.com>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-7-r.bolshakov@yadro.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <922fee6f-f6d0-b6cd-c9b7-63ad5e3a004c@redhat.com>
Date:   Tue, 22 Sep 2020 15:53:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200901085056.33391-7-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/09/20 10:50, Roman Bolshakov wrote:
> macOS is shipped with an old non-enhanced version of getopt and it
> doesn't support options used by run_tests.sh. Proper version of getopt
> is available from homebrew but it has to be added to PATH before invoking
> run_tests.sh. It's not convenient because it has to be done in each
> shell instance and there could be many if a multiplexor is used.
> 
> The change provides a way to override getopt and halts ./configure if
> enhanced getopt can't be found.
> 
> Cc: Cameron Esfahani <dirty@apple.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>

I don't like the extra option very much, generally people are just expected
to stick homebrew in their path somehow.  Reporting a better error is a
good idea though, what about this:

diff --git a/configure b/configure
index 4eb504f..3293634 100755
--- a/configure
+++ b/configure
@@ -167,6 +167,13 @@ EOF
   rm -f lib-test.{o,S}
 fi
 
+# require enhanced getopt
+getopt -T > /dev/null
+if [ $? -ne 4 ]; then
+    echo "Enhanced getopt is not available, add it to your PATH?"
+    exit 1
+fi
+
 # Are we in a separate build tree? If so, link the Makefile
 # and shared stuff so that 'make' and run_tests.sh work.
 if test ! -e Makefile; then
diff --git a/run_tests.sh b/run_tests.sh
index 01e36dc..70d012c 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -34,6 +34,13 @@ EOF
 RUNTIME_arch_run="./$TEST_DIR/run"
 source scripts/runtime.bash
 
+# require enhanced getopt
+getopt -T > /dev/null
+if [ $? -ne 4 ]; then
+    echo "Enhanced getopt is not available, add it to your PATH?"
+    exit 1
+fi
+
 only_tests=""
 args=`getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $*`
 [ $? -ne 0 ] && exit 2;

Paolo

