Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C579D166345
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 17:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgBTQjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 11:39:01 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36906 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728090AbgBTQjB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 11:39:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582216740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bvygEr7ehbjLOu3DEgLylicGpu1Z1T2V1MWMquNl+do=;
        b=Exq6h6782PHdgGznyGk/TUK1muYnnaNqbeU82l6wflXobYtyDR2zXqebkhE0fgVzhVL1Ww
        DYtqaA2g3mjFXJFouPlHDM5Oz3H2LnHhxodHnukoRLs/BD5R8SqNwCeYwB7yFQBTuXpcpZ
        X4+VlsHllLGhVRWAFzS6gji4FE5NWZQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-dzmv4xv3PKCxp9vVAaDgww-1; Thu, 20 Feb 2020 11:38:58 -0500
X-MC-Unique: dzmv4xv3PKCxp9vVAaDgww-1
Received: by mail-wm1-f69.google.com with SMTP id b205so1062638wmh.2
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 08:38:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bvygEr7ehbjLOu3DEgLylicGpu1Z1T2V1MWMquNl+do=;
        b=IOIYJJ5pKZOASHv3GRztUZwHUvqscpudOyonXNX5nHbNgyb1SWzBHyvCu8WjBxU8i7
         xt6Aj4cnJAilLAwh1SyQq7GVHEfTlduzOwa7GOQIZxLW1q4wZhWhBobK0pG7WeBRg58v
         51EIi2ZwNL3/frllvAwAUdsfkV2vBjB26N7uC/mND0LIAdiR39AdSj9CybEkRG6gEfP6
         53x0WxkQrhHA1QZEU5IcxtU9CEYiDK2Js21iXz8AxKyLUYDHu/z2e4wu3mgjCALDvu7z
         SGxfbRvawshOGBZVnSUMAoq8kwQT4+RA5YX9/uelZmu7drRWG8TnNXTuzON2hfHg/Koa
         7yjg==
X-Gm-Message-State: APjAAAVGwsSCU3dbaMUR9yaPRFjJ0QhPqaImodht/JCTYwq4wXi5CuDu
        uLkfNHWqZwz414GdVDwrb2SoZ/rRGKew/Q8jdUVTc2R3Yius8GIrK3bocwOCWfYkLJQRyTj9gaB
        ydAyAl3gLOmAe
X-Received: by 2002:adf:bbcf:: with SMTP id z15mr43835321wrg.266.1582216736808;
        Thu, 20 Feb 2020 08:38:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqxzfTS3XouIxNuZOXxhbZNG3VBh9HAN9HUc5WYkOidUFDAAhs5cztf/bMtMiVclm5QRcE5dUw==
X-Received: by 2002:adf:bbcf:: with SMTP id z15mr43835296wrg.266.1582216736496;
        Thu, 20 Feb 2020 08:38:56 -0800 (PST)
Received: from [10.201.49.12] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id s22sm4946604wmh.4.2020.02.20.08.38.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 08:38:55 -0800 (PST)
Subject: Re: [PATCH 01/13] HACK: Ensure __NR_userfaultfd is defined
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     bgardon@google.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, peterx@redhat.com
References: <20200214145920.30792-1-drjones@redhat.com>
 <20200214145920.30792-2-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2cf799f9-f4c3-67d5-9370-61c6adb69d75@redhat.com>
Date:   Thu, 20 Feb 2020 17:38:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200214145920.30792-2-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/02/20 15:59, Andrew Jones wrote:
> Without this hack kvm/queue kvm selftests don't compile for x86_64.
> ---
>  tools/testing/selftests/kvm/demand_paging_test.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index df1fc38b4df1..ec8860b70129 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -20,6 +20,10 @@
>  #include <linux/bitops.h>
>  #include <linux/userfaultfd.h>
>  
> +#ifndef __NR_userfaultfd
> +#define __NR_userfaultfd 282
> +#endif
> +
>  #include "test_util.h"
>  #include "kvm_util.h"
>  #include "processor.h"
> 

This is because we're getting a limited version of
asm/unistd.h from tools/arch/x86/include/asm/unistd_64.h.
So:

------------ 8< ----------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] fixup! KVM: selftests: Add demand paging content to the demand paging test

Without this, kvm selftests don't compile for x86_64 on old-enough
userspace.

diff --git a/tools/arch/x86/include/asm/unistd_64.h b/tools/arch/x86/include/asm/unistd_64.h
index cb52a3a8b8fc..4205ed4158bf 100644
--- a/tools/arch/x86/include/asm/unistd_64.h
+++ b/tools/arch/x86/include/asm/unistd_64.h
@@ -1,4 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NR_userfaultfd
+#define __NR_userfaultfd 282
+#endif
 #ifndef __NR_perf_event_open
 # define __NR_perf_event_open 298
 #endif
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index df1fc38b4df1..dd6c5ee56201 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -13,6 +13,7 @@
 #include <stdlib.h>
 #include <sys/syscall.h>
 #include <unistd.h>
+#include <asm/unistd.h>
 #include <time.h>
 #include <poll.h>
 #include <pthread.h>
@@ -24,6 +25,8 @@
 #include "kvm_util.h"
 #include "processor.h"
 
+#ifdef __NR_userfaultfd
+
 /* The memory slot index demand page */
 #define TEST_MEM_SLOT_INDEX		1
 
@@ -678,3 +681,15 @@ int main(int argc, char *argv[])
 
 	return 0;
 }
+
+#else /* __NR_userfaultfd */
+
+#warning "missing __NR_userfaultfd definition"
+
+int main(void)
+{
+        printf("skip: Skipping userfaultfd test (missing __NR_userfaultfd)\n");
+        return KSFT_SKIP;
+}
+
+#endif /* __NR_userfaultfd */

Paolo

