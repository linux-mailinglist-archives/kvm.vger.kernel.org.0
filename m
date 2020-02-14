Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1BE15D60A
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 11:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgBNKuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 05:50:15 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51427 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728890AbgBNKuM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 05:50:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581677411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vg61eGoWcA19Cw/AYeSU/k5T26Kt5O7PS7XobuUrPuk=;
        b=MMMIfMMwzSJRmdCzhupOFxMd6UXf6J/r7jvcgrbOW1iF/2DhGZpg0nciIMvhEAwI4HJMTG
        ThF0te5OBV84WvTgpmRx6mYc8U/YDIWSg8yWnNtpo4gOLUZmrDMMVr1luwc38UTXMDXchh
        YeGHw4TbgfowNNj/Zy+Zisn2HAqqfr8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-7AANGD2KOdWAB2rFtzKkBw-1; Fri, 14 Feb 2020 05:50:10 -0500
X-MC-Unique: 7AANGD2KOdWAB2rFtzKkBw-1
Received: by mail-wr1-f71.google.com with SMTP id m15so3773405wrs.22
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 02:50:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vg61eGoWcA19Cw/AYeSU/k5T26Kt5O7PS7XobuUrPuk=;
        b=SLx0WWQfblHj6FRYz0ALI79FbJ5f/xN9b5hl/aBOarJ5BPEnoW4UNxMzz4NMHo3wFz
         8snYGGTfbDLH6+p1gRFFFUVzpz02HkQxLkwsAqHsTITL7e48TQeimVMd9ck7fheyGxdk
         PQBV4gek7m5/hFQaSn0qvVqw26FyfLQVq2uiBwbBXfvh+H8wZyQVZKyJRiLJtn+LkTcD
         QBqljqIkWBZ+NamnJf5IIKCUUtNkSZIVeBRBNJKWBZlGz5kNZQuBu46JCGwLD0uirf6y
         zAbJ1ajDWJl/Ngagrnyzxi3rnp1YM9k8mbpAzquYs6nbJgwRTnS9Fl6/ap+lf4tNNiOE
         k6jQ==
X-Gm-Message-State: APjAAAW9sM5k+X7kBg+EFWBBRWYUApM9ocxroKwM0HtaJfjfVtqjbJ7N
        elnMS3td0sn2Ph12oGRJPmNIwEIOi/N3lLRMWUJNbU2sWMhDrTsk/Ta0qBxsViE/kYdnUmsTj1L
        xvczGk3oovb77
X-Received: by 2002:a1c:3b0a:: with SMTP id i10mr4236475wma.177.1581677408988;
        Fri, 14 Feb 2020 02:50:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqz41xB8QnJfCgmOLzRTn8TcOmx2AO9oKLOoO9cL7qNTMWGrjVYebj1WMP7PXbpeHRXwpqdjSQ==
X-Received: by 2002:a1c:3b0a:: with SMTP id i10mr4236436wma.177.1581677408695;
        Fri, 14 Feb 2020 02:50:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id c9sm7217655wme.41.2020.02.14.02.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 02:50:08 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests 2/2] runtime: Introduce VMM_PARAMS
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, peter.maydell@linaro.org,
        alex.bennee@linaro.org, lvivier@redhat.com, thuth@redhat.com,
        david@redhat.com, frankja@linux.ibm.com, eric.auger@redhat.com
References: <20200213143300.32141-1-drjones@redhat.com>
 <20200213143300.32141-3-drjones@redhat.com>
 <689d8031-22ac-c414-a3c3-e10567c3c9af@redhat.com>
 <20200214103853.ycxs4clif4gisk6i@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d04b6913-e71e-8983-e704-d956be12dac9@redhat.com>
Date:   Fri, 14 Feb 2020 11:50:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200214103853.ycxs4clif4gisk6i@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/02/20 11:38, Andrew Jones wrote:
> That was the way we originally planned on doing it when Alex Bennee posted
> his patch. However since d4d34e648482 ("run_tests: fix command line
> options handling") the "--" has become the divider between run_tests.sh
> parameter inputs and individually specified tests.

Hmm, more precisely that is how getopt separates options from other 
parameters.

Since we don't expect test names starting with a dash, we could do 
something like (untested):

diff --git a/run_tests.sh b/run_tests.sh
index 01e36dc..8b71cf2 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -35,7 +35,20 @@ RUNTIME_arch_run="./$TEST_DIR/run"
 source scripts/runtime.bash
 
 only_tests=""
-args=`getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $*`
+args=""
+vmm_args=""
+while [ $# -gt 0 ]; do
+   if test "$1" = --; then
+       shift
+       vmm_args=$*
+       break
+   else
+       args="args $1"
+       shift
+   fi
+done
+
+args=`getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $args`
 [ $? -ne 0 ] && exit 2;
 set -- $args;
 while [ $# -gt 0 ]; do

> will run the test with "-foo bar" appended to the command line. We could
> modify mkstandalone.sh to get that feature too (allowing the additional
> parameters to be given after tests/mytest), but with VMM_PARAMS we don't
> have to.

Yes, having consistency between standalone and run_tests.sh is a good thing.

Paolo

